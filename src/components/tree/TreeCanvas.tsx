/**
 * Superfície de desenho da árvore.
 *
 * Divisão de trabalho: o **D3 cuida só do pan/zoom**, escrevendo o `transform`
 * direto no nó do SVG; o **React desenha o conteúdo**. Duas razões:
 *
 * 1. O renderizador anterior montava os cards com `.html()` e interpolação de
 *    string. Nome de pessoa é dado do usuário — e vai passar a vir de arquivos
 *    GEDCOM de terceiros. Um `<` no lugar errado quebrava o desenho, e a porta
 *    ficava aberta para coisa pior.
 * 2. Escrever o transform no DOM em vez de guardá-lo em estado React evita um
 *    re-render por quadro durante o arraste. Numa árvore de milhares de nós é
 *    a diferença entre fluido e travado.
 */

import { useEffect, useMemo, useRef } from 'react';
import * as d3 from 'd3';
import { calcularLayout, caminhoOrtogonal, METRICAS } from '../../lib/tree/layout';
import type { TreeGraph } from '../../types';
import { NodeCard } from './NodeCard';

interface TreeCanvasProps {
  grafo: TreeGraph;
  pessoaSelecionadaId?: string | null;
  /**
   * Quem destacar — vem da linha do tempo, ao clicar num marco de contexto
   * ("quem estava vivo em 1930"). `null` significa sem destaque ativo, que é
   * diferente de uma lista vazia: vazia quer dizer "ninguém estava vivo", e
   * nesse caso todos os cards ficam apagados, que é a resposta certa.
   */
  destacadosIds?: string[] | null;
  onSelecionarPessoa?: (id: string) => void;
  onAbrirDetalhes?: (id: string) => void;
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
  pessoaSelecionadaId,
  destacadosIds,
  onSelecionarPessoa,
  onAbrirDetalhes,
}: TreeCanvasProps) {
  const destaqueAtivo = destacadosIds != null;
  const destacados = useMemo(
    () => new Set(destacadosIds ?? []),
    [destacadosIds],
  );
  const svgRef = useRef<SVGSVGElement>(null);
  const palcoRef = useRef<SVGGElement>(null);

  const layout = useMemo(() => calcularLayout(grafo), [grafo]);

  useEffect(() => {
    const svg = svgRef.current;
    const palco = palcoRef.current;
    if (!svg || !palco) return;

    const zoom = d3
      .zoom<SVGSVGElement, unknown>()
      .scaleExtent([0.15, 2.5])
      .on('zoom', (evento) => {
        palco.setAttribute('transform', evento.transform.toString());

        // Zoom semântico: o CSS em globals.css reage a estas classes,
        // escondendo detalhe quando os cards ficam pequenos demais para ler.
        const escala = evento.transform.k;
        palco.classList.toggle('zoom-semantic-low', escala <= 0.5);
        palco.classList.toggle('zoom-semantic-mid', escala > 0.5 && escala < 1.2);
        palco.classList.toggle('zoom-semantic-high', escala >= 1.2);
      });

    const selecao = d3.select(svg);
    selecao.call(zoom);

    // Enquadramento inicial: a árvore inteira visível, sem passar de 100%.
    const largura = svg.clientWidth || 1;
    const altura = svg.clientHeight || 1;
    const escala = Math.min(largura / layout.largura, altura / layout.altura, 1);
    const deslocX = (largura - layout.largura * escala) / 2;

    selecao.call(
      zoom.transform,
      d3.zoomIdentity.translate(deslocX, METRICAS.margem * escala).scale(escala),
    );

    return () => {
      selecao.on('.zoom', null);
    };
  }, [layout]);

  return (
    <div className="relative w-full h-full overflow-hidden bg-bg">
      {/* Papel milimetrado de fundo — fica parado, não acompanha o zoom. */}
      <div
        className="absolute inset-0 bg-[radial-gradient(var(--borda)_1px,transparent_1px)] bg-[size:26px_26px] opacity-50 pointer-events-none"
        aria-hidden
      />

      <svg
        ref={svgRef}
        className="absolute inset-0 w-full h-full cursor-grab active:cursor-grabbing touch-manipulation"
        role="application"
        aria-label="Árvore genealógica: arraste para mover, use a roda do mouse para aproximar"
      >
        <g ref={palcoRef}>
          {/* Ligações primeiro, para ficarem atrás dos cards. */}
          <g className="arestas" fill="none">
            {layout.arestas.map((a) => (
              <path
                key={a.id}
                d={caminhoOrtogonal(a.origem, a.destino)}
                stroke="var(--linha)"
                strokeWidth={2}
                // Vínculo não biológico é tracejado — a distinção que a
                // seção 2.6 pede, sem poluir o desenho com rótulo.
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
                // Com um destaque ativo, quem está fora dele desbota em vez de
                // sumir: o parentesco continua legível, e o contraste é que
                // conta a história de quem viveu naquela época.
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
    </div>
  );
}
