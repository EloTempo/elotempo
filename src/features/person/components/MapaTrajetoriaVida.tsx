import { useEffect, useRef, useState, useMemo } from 'react';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import {
  Compass,
  MapPin,
  ChevronLeft,
  ChevronRight,
  Maximize2,
  Layers,
  Flag,
} from 'lucide-react';
import { useTrajetoriaPessoa } from '../hooks/useTrajetoria';
import { rotuloDoTipo } from '../taxonomias';
import { useI18n } from '../../../i18n/I18nContext';
import type { PontoTrajetoria } from '../../../types';

interface MapaTrajetoriaVidaProps {
  pessoaId: string;
  nomePessoa: string;
  eventoInicialId?: string;
  onSelecionarEvento?: (eventoId: string) => void;
}

// Cores semânticas para os tipos de marco histórico
function corDoEvento(tipo: string): { bg: string; border: string; text: string; hex: string } {
  switch (tipo.toLowerCase()) {
    case 'nascimento':
    case 'batismo':
      return { bg: 'bg-emerald-500', border: 'border-emerald-600', text: 'text-emerald-50', hex: '#10b981' };
    case 'casamento':
    case 'uniao':
    case 'noivado':
      return { bg: 'bg-sky-500', border: 'border-sky-600', text: 'text-sky-50', hex: '#0ea5e9' };
    case 'falecimento':
    case 'sepultamento':
      return { bg: 'bg-zinc-600', border: 'border-zinc-700', text: 'text-zinc-100', hex: '#52525b' };
    default:
      return { bg: 'bg-amber-500', border: 'border-amber-600', text: 'text-amber-50', hex: '#f59e0b' };
  }
}

export function MapaTrajetoriaVida({
  pessoaId,
  nomePessoa,
  eventoInicialId,
  onSelecionarEvento,
}: MapaTrajetoriaVidaProps) {
  const { t } = useI18n();
  const { data: trajetoria, isLoading } = useTrajetoriaPessoa(pessoaId);

  const containerMapaRef = useRef<HTMLDivElement>(null);
  const mapaRef = useRef<L.Map | null>(null);
  const marcadoresRef = useRef<Map<string, L.Marker>>(new Map());
  const linhaRef = useRef<L.Polyline | null>(null);

  const [pontoAtivoId, setPontoAtivoId] = useState<string | null>(eventoInicialId ?? null);
  const [painelLateralAberto, setPainelLateralAberto] = useState(true);

  const pontos = useMemo(() => trajetoria?.pontos ?? [], [trajetoria]);

  // Ponto ativo atual
  const pontoAtivo = useMemo(
    () => pontos.find((p) => p.evento_id === pontoAtivoId) ?? pontos[0] ?? null,
    [pontos, pontoAtivoId],
  );

  const indiceAtivo = useMemo(
    () => (pontoAtivo ? pontos.findIndex((p) => p.evento_id === pontoAtivo.evento_id) : -1),
    [pontos, pontoAtivo],
  );

  // Inicialização do Mapa Leaflet
  useEffect(() => {
    if (!containerMapaRef.current || mapaRef.current) return;

    const isEscuro = document.documentElement.classList.contains('dark');
    
    // Configura o mapa com centro inicial neutro
    const map = L.map(containerMapaRef.current, {
      zoomControl: false,
      attributionControl: false,
      minZoom: 2,
      maxZoom: 18,
    });

    // Adiciona controle de zoom no canto superior direito
    L.control.zoom({ position: 'topright' }).addTo(map);

    // Attribution discreto no canto inferior direito
    L.control
      .attribution({ position: 'bottomright', prefix: false })
      .addAttribution('&copy; <a href="https://carto.com/" target="_blank">CARTO</a> · <a href="https://osm.org/copyright" target="_blank">OSM</a>')
      .addTo(map);

    // Tiles cartográficos de alta performance e paleta neutra
    const tileUrl = isEscuro
      ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
      : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';

    L.tileLayer(tileUrl, {
      subdomains: 'abcd',
      maxZoom: 19,
    }).addTo(map);

    mapaRef.current = map;

    return () => {
      map.remove();
      mapaRef.current = null;
    };
  }, []);

  // Atualização dos marcadores, linha e bounds quando os pontos chegam
  useEffect(() => {
    const map = mapaRef.current;
    if (!map) return;

    // Limpar marcadores anteriores
    marcadoresRef.current.forEach((m) => m.remove());
    marcadoresRef.current.clear();
    if (linhaRef.current) {
      linhaRef.current.remove();
      linhaRef.current = null;
    }

    if (pontos.length === 0) {
      map.setView([-15.78, -47.93], 4); // Centro do Brasil padrão
      return;
    }

    const latLngs: L.LatLngExpression[] = [];

    // Criar marcadores para cada ponto
    pontos.forEach((ponto, idx) => {
      const pos: [number, number] = [ponto.latitude, ponto.longitude];
      latLngs.push(pos);

      const cor = corDoEvento(ponto.tipo_evento);
      const isFoco = ponto.evento_id === pontoAtivoId;

      // Ícone HTML customizado com anel pulsante quando ativo
      const iconHtml = `
        <div class="relative flex items-center justify-center cursor-pointer group">
          ${
            isFoco
              ? `<div class="absolute -inset-2 rounded-full animate-ping opacity-40" style="background-color: ${cor.hex};"></div>`
              : ''
          }
          <div class="w-7 h-7 rounded-full shadow-md flex items-center justify-center font-bold text-[11px] text-white transition-transform transform group-hover:scale-110 ${
            isFoco ? 'ring-3 ring-white dark:ring-zinc-900 scale-110 z-30' : 'z-10'
          }" style="background-color: ${cor.hex};">
            ${idx + 1}
          </div>
        </div>
      `;

      const customIcon = L.divIcon({
        html: iconHtml,
        className: 'custom-map-marker',
        iconSize: [28, 28],
        iconAnchor: [14, 14],
      });

      const marker = L.marker(pos, { icon: customIcon }).addTo(map);

      // Popup com identidade do EloTempo
      const localExibicao = ponto.rotulo_historico
        ? `${ponto.rotulo_historico} <span style="opacity: 0.75; font-size: 11px;">(${ponto.local_nome})</span>`
        : ponto.local_nome;

      const popupHtml = `
        <div style="font-family: inherit; font-size: 12px; line-height: 1.4; min-width: 160px;">
          <div style="font-weight: 700; color: ${cor.hex}; text-transform: uppercase; font-size: 10px; letter-spacing: 0.5px;">
            ${rotuloDoTipo(ponto.tipo_evento)}
          </div>
          <div style="font-weight: 600; margin-top: 2px;">
            ${ponto.data_texto || (ponto.ano ? String(ponto.ano) : '')}
          </div>
          <div style="margin-top: 4px; display: flex; align-items: center; gap: 4px; opacity: 0.9;">
            📍 <span>${localExibicao}</span>
          </div>
          ${
            ponto.nota
              ? `<div style="margin-top: 6px; font-style: italic; opacity: 0.8; border-top: 1px dashed rgba(0,0,0,0.15); padding-top: 4px;">“${ponto.nota}”</div>`
              : ''
          }
        </div>
      `;

      marker.bindPopup(popupHtml, {
        closeButton: false,
        offset: [0, -10],
      });

      marker.on('click', () => {
        setPontoAtivoId(ponto.evento_id);
        onSelecionarEvento?.(ponto.evento_id);
      });

      marcadoresRef.current.set(ponto.evento_id, marker);
    });

    // Traçar linha geodésica pontilhada conectando a sequência da vida
    if (latLngs.length > 1) {
      linhaRef.current = L.polyline(latLngs, {
        color: '#6366f1',
        weight: 3,
        opacity: 0.75,
        dashArray: '8, 8',
      }).addTo(map);
    }

    // Se temos ponto ativo, foca nele; senão, enquadra todos
    if (pontoAtivoId) {
      const p = pontos.find((item) => item.evento_id === pontoAtivoId);
      if (p) {
        map.setView([p.latitude, p.longitude], 10, { animate: false });
        marcadoresRef.current.get(p.evento_id)?.openPopup();
        return;
      }
    }

    // Enquadramento geral da trajetória
    const bounds = L.latLngBounds(latLngs);
    map.fitBounds(bounds, { padding: [40, 40], maxZoom: 12 });
  }, [pontos, pontoAtivoId, onSelecionarEvento]);

  // Ação de focar em um marco específico com animação flyTo
  const focarPonto = (ponto: PontoTrajetoria) => {
    setPontoAtivoId(ponto.evento_id);
    onSelecionarEvento?.(ponto.evento_id);

    const map = mapaRef.current;
    if (!map) return;

    map.flyTo([ponto.latitude, ponto.longitude], 11, {
      duration: 1.2,
      easeLinearity: 0.25,
    });

    const marker = marcadoresRef.current.get(ponto.evento_id);
    if (marker) {
      setTimeout(() => marker.openPopup(), 600);
    }
  };

  // Visão geral (re-enquadra todos os pontos da vida)
  const verVisaoGeral = () => {
    const map = mapaRef.current;
    if (!map || pontos.length === 0) return;

    const latLngs = pontos.map((p) => [p.latitude, p.longitude] as [number, number]);
    const bounds = L.latLngBounds(latLngs);
    map.flyToBounds(bounds, { padding: [50, 50], duration: 1.2, maxZoom: 12 });
  };

  // Navegação anterior / próximo
  const irParaAnterior = () => {
    if (indiceAtivo > 0) {
      focarPonto(pontos[indiceAtivo - 1]);
    }
  };

  const irParaProximo = () => {
    if (indiceAtivo < pontos.length - 1) {
      focarPonto(pontos[indiceAtivo + 1]);
    }
  };

  // Redimensionamento do mapa ao abrir/fechar abas
  useEffect(() => {
    const timer = setTimeout(() => {
      mapaRef.current?.invalidateSize();
    }, 150);
    return () => clearTimeout(timer);
  }, [painelLateralAberto]);

  return (
    <div className="flex flex-col h-[560px] sm:h-[620px] rounded-raio border border-borda bg-card shadow-2xs overflow-hidden">
      {/* Barra de Título Superior do Mapa */}
      <div className="flex items-center justify-between px-4 py-2.5 border-b border-borda/60 bg-sup/50 flex-none gap-2">
        <div className="flex items-center gap-2 min-w-0">
          <Compass className="w-4 h-4 text-acento flex-none" />
          <h3 className="font-tit font-bold text-sm text-tinta m-0 truncate">
            {t('perfil', 'mapaVidaTitulo')}
          </h3>
          {pontos.length > 0 && (
            <span className="text-[11px] font-num px-2 py-0.5 rounded-full bg-acento/10 text-acento border border-acento/20 flex-none">
              {pontos.length} {pontos.length === 1 ? 'local' : 'locais'}
            </span>
          )}
        </div>

        <div className="flex items-center gap-1.5 flex-none">
          {pontos.length > 0 && (
            <>
              <button
                type="button"
                onClick={verVisaoGeral}
                className="px-2 py-1 text-xs font-semibold rounded-raio-s border border-borda bg-card hover:bg-sup text-tinta transition-colors flex items-center gap-1 cursor-pointer shadow-2xs"
                title={t('perfil', 'verTrajetoriaCompleta')}
              >
                <Maximize2 className="w-3.5 h-3.5 text-acento" />
                <span className="hidden sm:inline">{t('perfil', 'verTrajetoriaCompleta')}</span>
              </button>

              <div className="flex items-center border border-borda rounded-raio-s overflow-hidden bg-card shadow-2xs">
                <button
                  type="button"
                  onClick={irParaAnterior}
                  disabled={indiceAtivo <= 0}
                  className="p-1 hover:bg-sup disabled:opacity-30 disabled:hover:bg-transparent text-tinta transition-colors cursor-pointer border-none bg-transparent"
                  title={t('perfil', 'pontoAnterior')}
                >
                  <ChevronLeft className="w-4 h-4" />
                </button>
                <span className="text-[11px] font-num px-1.5 text-tinta3 font-medium">
                  {indiceAtivo >= 0 ? `${indiceAtivo + 1}/${pontos.length}` : `–/${pontos.length}`}
                </span>
                <button
                  type="button"
                  onClick={irParaProximo}
                  disabled={indiceAtivo >= pontos.length - 1}
                  className="p-1 hover:bg-sup disabled:opacity-30 disabled:hover:bg-transparent text-tinta transition-colors cursor-pointer border-none bg-transparent"
                  title={t('perfil', 'proximoPonto')}
                >
                  <ChevronRight className="w-4 h-4" />
                </button>
              </div>
            </>
          )}

          <button
            type="button"
            onClick={() => setPainelLateralAberto((a) => !a)}
            className={`p-1.5 rounded-raio-s border text-xs font-semibold transition-colors cursor-pointer ${
              painelLateralAberto
                ? 'bg-acento text-acento-tinta border-acento'
                : 'bg-card text-tinta hover:bg-sup border-borda'
            }`}
            title="Alternar lista de acontecimentos"
          >
            <Layers className="w-3.5 h-3.5" />
          </button>
        </div>
      </div>

      {/* Conteúdo: Split entre Lista e Mapa */}
      <div className="flex-1 relative flex overflow-hidden">
        {/* Painel Lateral com Lista Cronológica de Marcos */}
        {painelLateralAberto && (
          <aside className="w-72 sm:w-80 flex-none border-r border-borda/60 bg-sup/20 flex flex-col overflow-hidden z-10">
            <div className="p-3 border-b border-borda/40 bg-card flex items-center justify-between">
              <span className="text-xs font-bold text-tinta flex items-center gap-1.5">
                <Flag className="w-3.5 h-3.5 text-acento" />
                {t('perfil', 'eventosNoMapa')}
              </span>
              <span className="text-[11px] text-tinta3">
                {nomePessoa}
              </span>
            </div>

            <div className="flex-1 overflow-y-auto p-2.5 flex flex-col gap-2">
              {isLoading ? (
                <div className="p-6 text-center text-xs text-tinta3 animate-pulse">
                  Carregando coordenadas da trajetória…
                </div>
              ) : pontos.length === 0 ? (
                <div className="p-6 text-center text-xs text-tinta3 flex flex-col items-center gap-2">
                  <MapPin className="w-6 h-6 text-tinta3/40" />
                  <p className="m-0 font-medium">{t('perfil', 'nenhumLocalRegistrado')}</p>
                  <p className="m-0 text-[11px] leading-relaxed opacity-75">
                    {t('perfil', 'nenhumLocalDesc')}
                  </p>
                </div>
              ) : (
                pontos.map((ponto, idx) => {
                  const cor = corDoEvento(ponto.tipo_evento);
                  const isFoco = ponto.evento_id === pontoAtivoId;

                  return (
                    <button
                      key={ponto.evento_id}
                      type="button"
                      onClick={() => focarPonto(ponto)}
                      className={`w-full text-left p-2.5 rounded-raio-s border transition-all cursor-pointer flex items-start gap-2.5 ${
                        isFoco
                          ? 'bg-card border-acento shadow-xs ring-1 ring-acento/40'
                          : 'bg-card/70 hover:bg-card border-borda/60 hover:border-borda'
                      }`}
                    >
                      {/* Badge com número do passo */}
                      <span
                        className="w-6 h-6 rounded-full flex-none flex items-center justify-center font-bold text-[11px] text-white shadow-2xs mt-0.5"
                        style={{ backgroundColor: cor.hex }}
                      >
                        {idx + 1}
                      </span>

                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-1.5 justify-between">
                          <span
                            className="text-[11px] font-bold uppercase tracking-wider truncate"
                            style={{ color: cor.hex }}
                          >
                            {rotuloDoTipo(ponto.tipo_evento)}
                          </span>
                          <span className="font-num text-[11px] font-semibold px-1.5 py-0.2 rounded bg-sup text-tinta border border-borda/60 flex-none">
                            {ponto.data_texto || ponto.ano || '–'}
                          </span>
                        </div>

                        <div className="text-xs font-semibold text-tinta truncate mt-1 flex items-center gap-1">
                          <MapPin className="w-3 h-3 text-acento flex-none" />
                          <span className="truncate">{ponto.local_nome}</span>
                        </div>

                        {ponto.rotulo_historico && (
                          <div className="text-[11px] text-tinta3 italic truncate pl-4">
                            Época: {ponto.rotulo_historico}
                          </div>
                        )}

                        {ponto.nota && (
                          <p className="text-[11px] text-tinta2 italic m-0 mt-1 line-clamp-2 pl-4 leading-snug">
                            “{ponto.nota}”
                          </p>
                        )}
                      </div>
                    </button>
                  );
                })
              )}
            </div>
          </aside>
        )}

        {/* Canvas do Mapa Interativo Leaflet */}
        <div className="flex-1 relative h-full bg-sup/20">
          <div ref={containerMapaRef} className="w-full h-full z-0" />

          {/* Feedback Flutuante no Canto Inferior Esquerdo */}
          {pontoAtivo && (
            <div className="absolute bottom-3 left-3 z-[1000] p-2.5 rounded-raio-s bg-card/90 backdrop-blur-md border border-borda shadow-md max-w-xs text-xs flex items-center gap-2">
              <span
                className="w-3 h-3 rounded-full flex-none shadow-xs"
                style={{ backgroundColor: corDoEvento(pontoAtivo.tipo_evento).hex }}
              />
              <div className="min-w-0">
                <div className="font-bold text-tinta truncate">
                  {rotuloDoTipo(pontoAtivo.tipo_evento)} ({pontoAtivo.ano || pontoAtivo.data_texto})
                </div>
                <div className="text-[11px] text-tinta2 truncate">
                  {pontoAtivo.rotulo_historico
                    ? `${pontoAtivo.rotulo_historico} (${pontoAtivo.local_nome})`
                    : pontoAtivo.local_nome}
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
