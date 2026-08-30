/**
 * A gaveta das linhas do tempo (fatia 07, seção 8).
 *
 * **Split, não overlay** — a seção 8 é explícita. A alça arrasta e o usuário
 * escolhe a proporção entre a árvore e o contexto; a gaveta não tapa a árvore,
 * divide a tela com ela.
 *
 * O eixo é horizontal. A proibição de layout horizontal da seção 10 vale só
 * para a **árvore** — o tempo é horizontal por natureza.
 *
 * Não há zoom semântico aqui: com quatro linhas dessa densidade, o filtro de
 * relevância dá conta, e a agregação por escala fica para fatia própria.
 */

import { useEffect, useMemo, useRef, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { ChevronDown, ChevronUp, Clock, Info, X } from 'lucide-react';
import {
  listarLinhasDeContexto,
  buscarMarcos,
  montarLinhaPessoal,
  quemEstavaVivo,
  ehIntervalo,
  LIMITE_DE_CAMADAS,
  type Marco,
} from '../../../lib/api';

interface GavetaLinhaTempoProps {
  pessoaSelecionadaId: string | null;
  /** Comunica à árvore quem destacar; `null` limpa o destaque. */
  onDestacar: (ids: string[] | null) => void;
}

const ALTURA_MINIMA = 180;
const ALTURA_INICIAL = 300;
/** Acima disto a gaveta rola em vez de espremer as faixas (seção 8). */
const ALTURA_DA_FAIXA = 46;

/** Cor por categoria — o suficiente para distinguir camadas empilhadas. */
const COR_DA_CATEGORIA: Record<string, string> = {
  historia: 'var(--masc)',
  politica: 'var(--acento)',
  moeda: 'var(--anel)',
  tecnologia: 'var(--fem)',
};

export function GavetaLinhaTempo({
  pessoaSelecionadaId,
  onDestacar,
}: GavetaLinhaTempoProps) {
  const [aberta, setAberta] = useState(false);
  const [altura, setAltura] = useState(ALTURA_INICIAL);
  const [ativas, setAtivas] = useState<string[]>([]);
  const [marcoAberto, setMarcoAberto] = useState<Marco | null>(null);
  const [avisoLimite, setAvisoLimite] = useState<string | null>(null);

  const { data: linhas } = useQuery({
    queryKey: ['linhas-de-contexto'],
    queryFn: listarLinhasDeContexto,
    staleTime: Infinity,
  });

  const { data: linhaPessoal } = useQuery({
    queryKey: ['linha-pessoal', pessoaSelecionadaId],
    queryFn: () => montarLinhaPessoal(pessoaSelecionadaId!),
    enabled: !!pessoaSelecionadaId && aberta,
  });

  // Começa com a história do Brasil ligada: é a linha que serve a qualquer
  // acervo, e uma gaveta que abre vazia não ensina nada.
  useEffect(() => {
    if (linhas && linhas.length > 0 && ativas.length === 0) {
      const brasil = linhas.find((l) => l.categoria === 'historia');
      if (brasil) setAtivas([brasil.id]);
    }
  }, [linhas, ativas.length]);

  // ---------------------------------------------------------------
  // A janela de anos visível
  //
  // Com uma pessoa selecionada, enquadra a vida dela com folga de uma geração
  // para cada lado — é o recorte que responde "o que estava acontecendo
  // enquanto ele viveu". Sem ninguém, mostra o século que a maioria dos
  // acervos familiares alcança.
  // ---------------------------------------------------------------
  const [janela, setJanela] = useState<{ de: number; ate: number }>({ de: 1850, ate: 2030 });

  useEffect(() => {
    if (!linhaPessoal) return;
    const nasc = linhaPessoal.ano_nascimento;
    const falec = linhaPessoal.ano_falecimento ?? (linhaPessoal.is_vivo ? 2026 : null);
    if (nasc) {
      setJanela({ de: nasc - 30, ate: (falec ?? nasc + 80) + 30 });
    }
  }, [linhaPessoal]);

  const { data: marcos } = useQuery({
    queryKey: ['marcos', ativas, janela.de, janela.ate],
    queryFn: () => buscarMarcos(ativas, janela.de, janela.ate, true),
    enabled: aberta && ativas.length > 0,
  });

  // ---------------------------------------------------------------
  // Arrastar a alça
  // ---------------------------------------------------------------
  const arrastando = useRef(false);
  const inicioY = useRef(0);
  const alturaInicial = useRef(0);

  useEffect(() => {
    const mover = (e: MouseEvent) => {
      if (!arrastando.current) return;
      const delta = inicioY.current - e.clientY;
      const nova = Math.max(
        ALTURA_MINIMA,
        Math.min(window.innerHeight * 0.8, alturaInicial.current + delta),
      );
      setAltura(nova);
    };
    const soltar = () => {
      arrastando.current = false;
      document.body.style.cursor = '';
      document.body.style.userSelect = '';
    };
    window.addEventListener('mousemove', mover);
    window.addEventListener('mouseup', soltar);
    return () => {
      window.removeEventListener('mousemove', mover);
      window.removeEventListener('mouseup', soltar);
    };
  }, []);

  // ---------------------------------------------------------------
  // Escala do eixo
  // ---------------------------------------------------------------
  const larguraRef = useRef<HTMLDivElement>(null);
  const [largura, setLargura] = useState(900);

  useEffect(() => {
    const medir = () => setLargura(larguraRef.current?.clientWidth ?? 900);
    medir();
    window.addEventListener('resize', medir);
    return () => window.removeEventListener('resize', medir);
  }, [aberta, altura]);

  const posicaoDoAno = useMemo(() => {
    const span = Math.max(1, janela.ate - janela.de);
    return (ano: number) => ((ano - janela.de) / span) * largura;
  }, [janela, largura]);

  /** Marcas de década ou de século, conforme couber sem embolar. */
  const marcasDoEixo = useMemo(() => {
    const span = janela.ate - janela.de;
    const passo = span > 400 ? 100 : span > 150 ? 50 : span > 60 ? 20 : 10;
    const marcas: number[] = [];
    const primeiro = Math.ceil(janela.de / passo) * passo;
    for (let a = primeiro; a <= janela.ate; a += passo) marcas.push(a);
    return marcas;
  }, [janela]);

  const aplicarZoom = (fator: number, ancoraX: number) => {
    const span = janela.ate - janela.de;
    const anoNaAncora = janela.de + (ancoraX / largura) * span;
    const novoSpan = Math.max(20, Math.min(600, span * fator));
    const proporcao = ancoraX / largura;
    setJanela({
      de: Math.round(anoNaAncora - novoSpan * proporcao),
      ate: Math.round(anoNaAncora + novoSpan * (1 - proporcao)),
    });
  };

  const alternarLinha = (id: string) => {
    setAvisoLimite(null);
    setAtivas((atuais) => {
      if (atuais.includes(id)) return atuais.filter((x) => x !== id);
      if (atuais.length >= LIMITE_DE_CAMADAS) {
        setAvisoLimite(
          `A gaveta mostra até ${LIMITE_DE_CAMADAS} linhas de contexto ao mesmo tempo. Desligue uma para ligar outra — a vida da pessoa selecionada não ocupa vaga.`,
        );
        return atuais;
      }
      return [...atuais, id];
    });
  };

  const abrirMarco = async (m: Marco) => {
    setMarcoAberto(m);
    if (m.ano_inicio != null) {
      try {
        const r = await quemEstavaVivo(m.ano_inicio, m.ano_fim ?? null);
        onDestacar(r.ids);
        setVivosInfo(r);
      } catch {
        onDestacar(null);
      }
    }
  };

  const [vivosInfo, setVivosInfo] = useState<{
    ids: string[];
    sem_data_de_nascimento: number;
  } | null>(null);

  const fecharMarco = () => {
    setMarcoAberto(null);
    setVivosInfo(null);
    onDestacar(null);
  };

  const marcosPorLinha = useMemo(() => {
    const mapa = new Map<string, Marco[]>();
    for (const m of marcos ?? []) {
      const lista = mapa.get(m.linha_id) ?? [];
      lista.push(m);
      mapa.set(m.linha_id, lista);
    }
    return mapa;
  }, [marcos]);

  // ---------------------------------------------------------------

  if (!aberta) {
    return (
      <div className="flex-none border-t border-borda bg-sup print:hidden">
        <button
          type="button"
          onClick={() => setAberta(true)}
          className="w-full flex items-center gap-2 px-4 py-2 text-sm text-tinta2 hover:text-tinta hover:bg-card transition-colors bg-transparent border-none cursor-pointer"
        >
          <Clock className="w-4 h-4" />
          Linha do tempo
          <span className="text-xs text-tinta3">
            — situe esta vida no contexto da época
          </span>
          <ChevronUp className="w-4 h-4 ml-auto" />
        </button>
      </div>
    );
  }

  return (
    <div
      className="flex-none border-t border-borda bg-sup flex flex-col print:hidden"
      style={{ height: altura }}
    >
      {/* Alça de arraste */}
      <div
        onMouseDown={(e) => {
          arrastando.current = true;
          inicioY.current = e.clientY;
          alturaInicial.current = altura;
          document.body.style.cursor = 'row-resize';
          document.body.style.userSelect = 'none';
        }}
        className="h-2 cursor-row-resize bg-borda/40 hover:bg-acento/40 transition-colors flex-none grid place-items-center"
        role="separator"
        aria-label="Arraste para redimensionar a linha do tempo"
      >
        <div className="w-10 h-0.5 rounded-full bg-borda2" />
      </div>

      {/* Cabeçalho e camadas */}
      <div className="flex items-start gap-2 px-4 py-2 border-b border-borda flex-none flex-wrap">
        <Clock className="w-4 h-4 text-acento flex-none mt-0.5" />

        <div className="flex flex-wrap gap-1.5 flex-1 min-w-0">
          {linhas?.map((l) => {
            const ligada = ativas.includes(l.id);
            return (
              <button
                key={l.id}
                type="button"
                onClick={() => alternarLinha(l.id)}
                title={l.fonte_referencia ?? undefined}
                className={`text-[11px] px-2 py-1 rounded-raio-s border transition-colors cursor-pointer ${
                  ligada
                    ? 'border-transparent text-white'
                    : 'border-borda2 bg-card text-tinta2 hover:text-tinta'
                }`}
                style={ligada ? { background: COR_DA_CATEGORIA[l.categoria] ?? 'var(--acento)' } : undefined}
              >
                {l.titulo}
                <span className="opacity-70"> · {l.marcos_alta}</span>
              </button>
            );
          })}
        </div>

        <button
          type="button"
          onClick={() => setAberta(false)}
          aria-label="Recolher a linha do tempo"
          className="text-tinta3 hover:text-tinta p-1 flex-none"
        >
          <ChevronDown className="w-4 h-4" />
        </button>
      </div>

      {avisoLimite && (
        <p className="px-4 py-1.5 text-[11px] text-tinta2 bg-card2 border-b border-borda m-0">
          {avisoLimite}
        </p>
      )}

      {/* O eixo */}
      <div
        ref={larguraRef}
        className="flex-1 overflow-y-auto overflow-x-hidden min-h-0 relative"
        onWheel={(e) => {
          if (!e.ctrlKey && Math.abs(e.deltaY) < 2) return;
          const caixa = larguraRef.current?.getBoundingClientRect();
          const x = caixa ? e.clientX - caixa.left : largura / 2;
          aplicarZoom(e.deltaY > 0 ? 1.15 : 0.87, x);
        }}
      >
        {/* Régua de anos */}
        <div className="sticky top-0 h-6 bg-sup border-b border-borda z-10">
          {marcasDoEixo.map((ano) => (
            <span
              key={ano}
              className="absolute top-0 font-num text-[10px] text-tinta3 border-l border-borda h-full pl-1"
              style={{ left: posicaoDoAno(ano) }}
            >
              {ano}
            </span>
          ))}
        </div>

        {/* Faixa de cada linha ativa */}
        {ativas.map((linhaId) => {
          const linha = linhas?.find((l) => l.id === linhaId);
          const cor = COR_DA_CATEGORIA[linha?.categoria ?? ''] ?? 'var(--acento)';
          return (
            <div
              key={linhaId}
              className="relative border-b border-borda/50"
              style={{ height: ALTURA_DA_FAIXA }}
            >
              <span className="absolute left-1 top-0.5 font-num text-[9.5px] text-tinta3 z-10 pointer-events-none bg-sup/80 px-1 rounded">
                {linha?.titulo}
              </span>

              {(marcosPorLinha.get(linhaId) ?? []).map((m) => {
                const inicio = m.ano_inicio ?? janela.de;
                const x = posicaoDoAno(inicio);
                const intervalo = ehIntervalo(m);
                const largura2 = intervalo
                  ? Math.max(3, posicaoDoAno(m.ano_fim!) - x)
                  : 0;

                return (
                  <button
                    key={m.id}
                    type="button"
                    onClick={() => abrirMarco(m)}
                    title={`${m.data_periodo_texto} — ${m.titulo}`}
                    className="absolute bottom-1 cursor-pointer bg-transparent border-none p-0 text-left group"
                    style={{ left: x, width: intervalo ? largura2 : 'auto' }}
                  >
                    {intervalo ? (
                      <span
                        className="block h-3 rounded-sm opacity-70 group-hover:opacity-100 transition-opacity"
                        style={{ background: cor, width: largura2 }}
                      />
                    ) : (
                      <span
                        className="block w-[3px] h-4 rounded-sm opacity-80 group-hover:opacity-100"
                        style={{ background: cor }}
                      />
                    )}
                    <span className="block font-num text-[9.5px] text-tinta2 whitespace-nowrap truncate max-w-[140px] group-hover:text-tinta">
                      {m.titulo}
                    </span>
                  </button>
                );
              })}
            </div>
          );
        })}

        {/* A vida da pessoa selecionada — sempre presente, sem ocupar vaga. */}
        {linhaPessoal && linhaPessoal.ano_nascimento && (
          <div
            className="relative border-t-2 border-acento/40 bg-card/40"
            style={{ height: ALTURA_DA_FAIXA + 6 }}
          >
            <span className="absolute left-1 top-0.5 font-num text-[9.5px] text-acento z-10 pointer-events-none bg-sup/80 px-1 rounded">
              {linhaPessoal.nome}
            </span>

            {(() => {
              const de = linhaPessoal.ano_nascimento!;
              const ate =
                linhaPessoal.ano_falecimento ?? (linhaPessoal.is_vivo ? 2026 : de);
              const x = posicaoDoAno(de);
              return (
                <span
                  className="absolute bottom-5 h-2.5 rounded-full bg-acento/60"
                  style={{ left: x, width: Math.max(4, posicaoDoAno(ate) - x) }}
                  title={`${de}–${linhaPessoal.ano_falecimento ?? (linhaPessoal.is_vivo ? 'hoje' : '?')}`}
                />
              );
            })()}

            {linhaPessoal.marcos
              .filter((m) => m.ano != null)
              .map((m, i) => (
                <span
                  key={`${m.tipo}-${i}`}
                  className="absolute bottom-1 flex flex-col items-start"
                  style={{ left: posicaoDoAno(m.ano!) }}
                  title={`${m.tipo}: ${m.data_texto ?? ''}${m.local ? ' · ' + m.local : ''}`}
                >
                  <span className="w-[3px] h-3 rounded-sm bg-acento" />
                  <span className="font-num text-[9px] text-tinta2 whitespace-nowrap">
                    {m.tipo}
                  </span>
                </span>
              ))}
          </div>
        )}

        {ativas.length === 0 && (
          <p className="p-4 text-sm text-tinta3 m-0">
            Nenhuma linha ligada. Escolha uma acima.
          </p>
        )}
      </div>

      {/* Detalhe do marco clicado */}
      {marcoAberto && (
        <div className="flex-none border-t border-borda bg-card px-4 py-2.5 flex items-start gap-3">
          <Info className="w-4 h-4 text-acento flex-none mt-0.5" />
          <div className="flex-1 min-w-0">
            <p className="m-0 text-sm text-tinta">
              <strong>{marcoAberto.titulo}</strong>
              <span className="font-num text-tinta2"> · {marcoAberto.data_periodo_texto}</span>
            </p>
            {marcoAberto.descricao && (
              <p className="m-0 text-xs text-tinta2 leading-relaxed">{marcoAberto.descricao}</p>
            )}
            {marcoAberto.fonte_especifica && (
              <p className="m-0 text-[11px] text-tinta3 italic">
                Fonte: {marcoAberto.fonte_especifica}
              </p>
            )}
            {vivosInfo && (
              <p className="m-0 mt-1 text-[11px] text-acento">
                {vivosInfo.ids.length}{' '}
                {vivosInfo.ids.length === 1 ? 'pessoa destacada' : 'pessoas destacadas'} na
                árvore
                {vivosInfo.sem_data_de_nascimento > 0 &&
                  ` · ${vivosInfo.sem_data_de_nascimento} sem data de nascimento não puderam ser avaliadas`}
              </p>
            )}
          </div>
          <button
            type="button"
            onClick={fecharMarco}
            aria-label="Fechar detalhe"
            className="text-tinta3 hover:text-tinta p-1 flex-none"
          >
            <X className="w-4 h-4" />
          </button>
        </div>
      )}
    </div>
  );
}
