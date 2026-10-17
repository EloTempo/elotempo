/**
 * Superfície de desenho da árvore com navegação e visões auxiliares (Fatia 13).
 */

import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import * as d3 from 'd3';
import { calcularLayout, caminhoOrtogonal, METRICAS } from '../../lib/tree/layout';
import type { TreeGraph } from '../../types';
import { NodeCard } from './NodeCard';
import { BarraControlesArvore, type ModoVisaoArvore } from './BarraControlesArvore';
import { MinimapaArvore } from './MinimapaArvore';
import { LocalizadorArvoreModal } from './LocalizadorArvoreModal';

interface TreeCanvasProps {
  grafo: TreeGraph;
  raizId?: string | null;
  pessoaSelecionadaId?: string | null;
  destacadosIds?: string[] | null;
  unioesColapsadas?: Set<string>;
  onToggleColapsarUniao?: (uniaoId: string) => void;
  onSelecionarPessoa?: (id: string) => void;
  onAbrirDetalhes?: (id: string) => void;
  modoVisao?: ModoVisaoArvore;
  onMudarModo?: (modo: ModoVisaoArvore) => void;
  geracoes?: number;
  onMudarGeracoes?: (g: number) => void;
  onAbrirAhnentafel?: () => void;
  onExportarPoster?: () => void;
}

/** Marcador do anel, por estado do vínculo (seção 10). */
function estiloAnel(estado: string): { preenchido: boolean; tracejado: boolean } {
  switch (estado) {
    case 'casamento':
      return { preenchido: true, tracejado: false };
    case 'estavel':
      return { preenchido: false, tracejado: false };
    case 'dissolvida':
      return { preenchido: false, tracejado: true };
    default:
      return { preenchido: false, tracejado: true };
  }
}

export function TreeCanvas({
  grafo,
  raizId,
  pessoaSelecionadaId,
  destacadosIds,
  unioesColapsadas,
  onToggleColapsarUniao,
  onSelecionarPessoa,
  onAbrirDetalhes,
  modoVisao,
  onMudarModo,
  geracoes,
  onMudarGeracoes,
  onAbrirAhnentafel,
  onExportarPoster,
}: TreeCanvasProps) {
  const destaqueAtivo = destacadosIds != null;
  const destacados = useMemo(
    () => new Set(destacadosIds ?? []),
    [destacadosIds],
  );
  const svgRef = useRef<SVGSVGElement>(null);
  const palcoRef = useRef<SVGGElement>(null);
  const zoomRef = useRef<d3.ZoomBehavior<SVGSVGElement, unknown> | null>(null);

  // Estados para sincronização do Minimapa e Localizador
  const [viewportTransform, setViewportTransform] = useState({ x: 0, y: 0, k: 1 });
  const [containerDimensoes, setContainerDimensoes] = useState({ largura: 1000, altura: 800 });
  const [localizadorAberto, setLocalizadorAberto] = useState(false);

  const layout = useMemo(
    () => calcularLayout(grafo, unioesColapsadas),
    [grafo, unioesColapsadas],
  );

  useEffect(() => {
    const svg = svgRef.current;
    const palco = palcoRef.current;
    if (!svg || !palco) return;

    const zoom = d3
      .zoom<SVGSVGElement, unknown>()
      .scaleExtent([0.15, 2.5])
      .on('zoom', (evento) => {
        palco.setAttribute('transform', evento.transform.toString());
        setViewportTransform({
          x: evento.transform.x,
          y: evento.transform.y,
          k: evento.transform.k,
        });

        // Zoom semântico: o CSS em globals.css reage a estas classes,
        // escondendo detalhe quando os cards ficam pequenos demais para ler.
        const escala = evento.transform.k;
        palco.classList.toggle('zoom-semantic-low', escala <= 0.5);
        palco.classList.toggle('zoom-semantic-mid', escala > 0.5 && escala < 1.2);
        palco.classList.toggle('zoom-semantic-high', escala >= 1.2);
      });

    zoomRef.current = zoom;
    const selecao = d3.select(svg);
    selecao.call(zoom);

    // Enquadramento inicial: a árvore inteira visível, sem passar de 100%.
    const largura = svg.clientWidth || 1;
    const altura = svg.clientHeight || 1;
    setContainerDimensoes({ largura, altura });
    const escala = Math.min(largura / layout.largura, altura / layout.altura, 1);
    const deslocX = (largura - layout.largura * escala) / 2;

    const transformInicial = d3.zoomIdentity.translate(deslocX, METRICAS.margem * escala).scale(escala);
    selecao.call(zoom.transform, transformInicial);
    setViewportTransform({
      x: transformInicial.x,
      y: transformInicial.y,
      k: transformInicial.k,
    });

    const atualizarDimensoes = () => {
      if (svg) {
        setContainerDimensoes({
          largura: svg.clientWidth || 1000,
          altura: svg.clientHeight || 800,
        });
      }
    };
    window.addEventListener('resize', atualizarDimensoes);

    return () => {
      selecao.on('.zoom', null);
      window.removeEventListener('resize', atualizarDimensoes);
    };
  }, [layout]);

  // Atalho de teclado global Ctrl+F / Cmd+F para abrir o localizador da árvore
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'f') {
        const tag = (e.target as HTMLElement)?.tagName?.toLowerCase();
        if (tag !== 'input' && tag !== 'textarea') {
          e.preventDefault();
          setLocalizadorAberto(true);
        }
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  const zoomIn = () => {
    if (!svgRef.current || !zoomRef.current) return;
    d3.select(svgRef.current).transition().duration(250).call(zoomRef.current.scaleBy, 1.3);
  };

  const zoomOut = () => {
    if (!svgRef.current || !zoomRef.current) return;
    d3.select(svgRef.current).transition().duration(250).call(zoomRef.current.scaleBy, 0.75);
  };

  const ajustarTela = () => {
    const svg = svgRef.current;
    const zoom = zoomRef.current;
    if (!svg || !zoom) return;
    const largura = svg.clientWidth || 1;
    const altura = svg.clientHeight || 1;
    const escala = Math.min(largura / layout.largura, altura / layout.altura, 1);
    const deslocX = (largura - layout.largura * escala) / 2;
    d3.select(svg)
      .transition()
      .duration(350)
      .call(
        zoom.transform,
        d3.zoomIdentity.translate(deslocX, METRICAS.margem * escala).scale(escala),
      );
  };

  const centralizarRaiz = () => {
    const svg = svgRef.current;
    const zoom = zoomRef.current;
    if (!svg || !zoom) return;
    const foco =
      layout.pessoas.find((p) => p.id === (pessoaSelecionadaId || raizId)) ??
      layout.pessoas[0];
    if (!foco) return;
    const largura = svg.clientWidth || 1;
    const altura = svg.clientHeight || 1;
    d3.select(svg)
      .transition()
      .duration(350)
      .call(
        zoom.transform,
        d3.zoomIdentity.translate(largura / 2 - foco.x, altura / 2 - foco.y).scale(1),
      );
  };

  const navegarPara = useCallback(
    (targetX: number, targetY: number) => {
      const svg = svgRef.current;
      const zoom = zoomRef.current;
      if (!svg || !zoom) return;

      const largura = svg.clientWidth || containerDimensoes.largura;
      const altura = svg.clientHeight || containerDimensoes.altura;
      const k = viewportTransform.k || 1;

      d3.select(svg)
        .transition()
        .duration(280)
        .call(
          zoom.transform,
          d3.zoomIdentity
            .translate(largura / 2 - targetX * k, altura / 2 - targetY * k)
            .scale(k),
        );
    },
    [containerDimensoes, viewportTransform.k],
  );

  const centralizarEmPessoa = useCallback(
    (id: string) => {
      const svg = svgRef.current;
      const zoom = zoomRef.current;
      if (!svg || !zoom) return;

      const alvo = layout.pessoas.find((p) => p.id === id);
      if (!alvo) return;

      onSelecionarPessoa?.(id);

      const largura = svg.clientWidth || containerDimensoes.largura;
      const altura = svg.clientHeight || containerDimensoes.altura;

      d3.select(svg)
        .transition()
        .duration(450)
        .call(
          zoom.transform,
          d3.zoomIdentity
            .translate(largura / 2 - alvo.x, altura / 2 - alvo.y)
            .scale(1),
        );
    },
    [layout.pessoas, containerDimensoes, onSelecionarPessoa],
  );

  return (
    <div className="relative w-full h-full overflow-hidden bg-bg">
      {/* Papel milimetrado de fundo — fica estático no fundo z-0 */}
      <div
        className="absolute inset-0 bg-[radial-gradient(var(--borda)_1px,transparent_1px)] bg-[size:26px_26px] opacity-40 pointer-events-none z-0"
        aria-hidden
      />

      <svg ref={svgRef} className="relative z-10 w-full h-full cursor-grab active:cursor-grabbing select-none">
        <g ref={palcoRef}>
          {/* Ligações primeiro, para ficarem atrás dos cards. */}
          <g className="arestas" fill="none">
            {layout.arestas.map((a) => (
              <path
                key={a.id}
                d={caminhoOrtogonal(a.origem, a.destino)}
                stroke={
                  a.tipoVinculo && a.tipoVinculo !== 'biologico'
                    ? 'var(--acento)'
                    : 'var(--linha)'
                }
                strokeWidth={a.tipoVinculo && a.tipoVinculo !== 'biologico' ? 2.5 : 2}
                strokeDasharray={
                  a.tipoVinculo && a.tipoVinculo !== 'biologico' ? '6 4' : undefined
                }
              />
            ))}
          </g>

          {/* Anéis das uniões */}
          <g className="unioes">
            {layout.unioes.map((u) => {
              const estilo = estiloAnel(u.estado_vinculo);
              const temFilhos = u.filhosTotal > 0;
              return (
                <g key={u.id} transform={`translate(${u.x}, ${u.y})`}>
                  <circle
                    r={13}
                    stroke="var(--anel)"
                    strokeWidth={2}
                    strokeDasharray={estilo.tracejado ? '4 3' : undefined}
                    fill={estilo.preenchido ? 'var(--anel)' : 'var(--bg)'}
                  />
                  {u.ano_casamento != null && (
                    <text
                      y={-22}
                      textAnchor="middle"
                      className="font-num fill-[var(--tinta2)] text-[10.5px] detail-text"
                    >
                      ⚭ {u.ano_casamento}
                    </text>
                  )}

                  {/* Botão de colapsar/expandir descendentes */}
                  {temFilhos && onToggleColapsarUniao && (
                    <g
                      transform="translate(0, 22)"
                      onClick={(e) => {
                        e.stopPropagation();
                        onToggleColapsarUniao(u.id);
                      }}
                      className="cursor-pointer select-none"
                    >
                      <rect
                        x={u.colapsada ? -15 : -9}
                        y={-8}
                        width={u.colapsada ? 30 : 18}
                        height={16}
                        rx={8}
                        fill="var(--card)"
                        stroke={u.colapsada ? 'var(--acento)' : 'var(--borda)'}
                        strokeWidth={1.5}
                      />
                      <text
                        textAnchor="middle"
                        y={3.5}
                        fill={u.colapsada ? 'var(--acento)' : 'var(--tinta2)'}
                        className="font-num font-bold text-[9.5px]"
                      >
                        {u.colapsada ? `+${u.filhosTotal}` : '−'}
                      </text>
                    </g>
                  )}
                </g>
              );
            })}
          </g>

          {/* Cards das pessoas */}
          <g className="pessoas">
            {layout.pessoas.map((p) => (
              <foreignObject
                key={p.id}
                x={p.x - METRICAS.larguraNo / 2}
                y={p.y - METRICAS.alturaNo / 2}
                width={METRICAS.larguraNo}
                height={METRICAS.alturaNo}
                overflow="visible"
                opacity={destaqueAtivo && !destacados.has(p.id) ? 0.28 : 1}
              >
                <NodeCard
                  person={p}
                  selecionado={p.id === pessoaSelecionadaId}
                  destacado={destaqueAtivo && destacados.has(p.id)}
                  onClick={() => onSelecionarPessoa?.(p.id)}
                  onDetalhes={() => onAbrirDetalhes?.(p.id)}
                />
              </foreignObject>
            ))}
          </g>
        </g>
      </svg>

      {/* Barra flutuante de navegação e modos */}
      {modoVisao && onMudarModo && geracoes != null && onMudarGeracoes && (
        <BarraControlesArvore
          modo={modoVisao}
          onMudarModo={onMudarModo}
          geracoes={geracoes}
          onMudarGeracoes={onMudarGeracoes}
          onZoomIn={zoomIn}
          onZoomOut={zoomOut}
          onAjustarTela={ajustarTela}
          onCentralizarRaiz={centralizarRaiz}
          onAbrirAhnentafel={onAbrirAhnentafel}
          onExportarPoster={onExportarPoster}
          onLocalizarMembro={() => setLocalizadorAberto(true)}
        />
      )}

      {/* Radar / Minimapa flutuante interativo */}
      {layout.pessoas.length > 0 && (
        <MinimapaArvore
          layout={layout}
          viewportTransform={viewportTransform}
          containerWidth={containerDimensoes.largura}
          containerHeight={containerDimensoes.altura}
          pessoaSelecionadaId={pessoaSelecionadaId}
          onNavegarPara={navegarPara}
          abertoPadrao={layout.pessoas.length >= 8}
        />
      )}

      {/* Modal Localizador Rápido de Membros (Ctrl+F) */}
      <LocalizadorArvoreModal
        aberto={localizadorAberto}
        onFechar={() => setLocalizadorAberto(false)}
        pessoas={layout.pessoas}
        pessoaSelecionadaId={pessoaSelecionadaId}
        onSelecionarPessoa={centralizarEmPessoa}
      />
    </div>
  );
}
