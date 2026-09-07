/**
 * A superfície impressa (fatia 05).
 *
 * Vive dentro de `#print-container`, que o `@media print` do globals.css revela
 * enquanto esconde o resto da interface. O PDF sai pelo `window.print()` da
 * webview — o caminho que a seção 6 indica —, e o mesmo botão serve para
 * impressão direta.
 *
 * Regra que atravessa a tela inteira: **ausência de dado é dita, não omitida**.
 * Em papel, campo em branco é ambíguo entre "não sei" e "esqueci de imprimir";
 * "sem registro" não é.
 */

import { calcularLayout, caminhoOrtogonal, METRICAS } from '../../../lib/tree/layout';
import type { EntradaRelatorio, EventoRelatorio, Relatorio } from '../../../lib/api';
import type { TreeGraph } from '../../../types';

export type ModoImpressao = 'hierarquia' | 'texto' | 'combinado';

export interface OpcoesImpressao {
  modo: ModoImpressao;
  incluirMiniaturas: boolean;
  quebrarPorGeracao: boolean;
}

interface RelatorioViewProps {
  relatorio: Relatorio;
  grafo: TreeGraph | null;
  opcoes: OpcoesImpressao;
  titulo: string;
}

const SEM_REGISTRO = 'sem registro';

function nomeCompleto(e: EntradaRelatorio): string {
  return [e.nome, e.sobrenome].filter(Boolean).join(' ');
}

function simboloDeSexo(sexo: string): string {
  if (sexo === 'M') return '♂';
  if (sexo === 'F') return '♀';
  return '·';
}

/** "12/03/1945 · Campos dos Goytacazes, RJ" ou "sem registro". */
function linhaDeEvento(evento?: EventoRelatorio | null): string {
  if (!evento) return SEM_REGISTRO;
  const partes = [evento.data_texto, evento.local].filter(Boolean);
  return partes.length > 0 ? partes.join(' · ') : SEM_REGISTRO;
}

/** Um campo da ficha. Só aparece quando há o que mostrar. */
function Campo({ rotulo, valores }: { rotulo: string; valores: string[] }) {
  if (valores.length === 0) return null;
  return (
    <div className="flex gap-2 text-[10.5pt] leading-snug">
      <span className="w-[22mm] flex-none text-[8.5pt] uppercase tracking-wider text-[#7a7266] pt-[1px]">
        {rotulo}
      </span>
      <span className="flex-1">{valores.join(' · ')}</span>
    </div>
  );
}

function Ficha({
  entrada,
  incluirMiniatura,
}: {
  entrada: EntradaRelatorio;
  incluirMiniatura: boolean;
}) {
  const unioes = entrada.unioes.map((u) => {
    const marcador =
      u.estado_vinculo === 'casamento' ? '⚭' : u.estado_vinculo === 'estavel' ? '⚯' : '⚮';
    const data = u.data_texto ? ` ${u.data_texto}` : '';
    const filhos =
      u.filhos.length > 0 ? ` · filhos: ${u.filhos.join(', ')}` : ' · sem filhos registrados';
    return `${marcador}${data} com ${u.conjuge}${filhos}`;
  });

  return (
    <article className="ficha-relatorio mb-[5mm] pb-[3mm] border-b border-[#ddd6c8]">
      <header className="flex items-baseline gap-2 mb-[1.5mm]">
        <span className="text-[9pt] text-[#7a7266]">{simboloDeSexo(entrada.sexo)}</span>
        <h3 className="m-0 text-[12.5pt] font-bold leading-tight">{nomeCompleto(entrada)}</h3>
        <span className="text-[8.5pt] text-[#7a7266]">geração {entrada.geracao + 1}</span>
      </header>

      <div className="flex gap-3">
        {incluirMiniatura && (
          <div className="w-[18mm] h-[22mm] flex-none border border-[#ddd6c8] bg-[#f4f0e6] grid place-items-center text-[7pt] text-[#9a9284]">
            {entrada.foto_url ? '' : 'sem foto'}
          </div>
        )}

        <div className="flex-1 flex flex-col gap-[0.8mm]">
          <Campo rotulo="Nasc." valores={[linhaDeEvento(entrada.nascimento)]} />
          <Campo rotulo="Falec." valores={[linhaDeEvento(entrada.falecimento)]} />
          <Campo rotulo="Apelidos" valores={entrada.apelidos} />
          <Campo rotulo="Nomes" valores={entrada.outros_nomes} />
          <Campo rotulo="Pais" valores={entrada.pais.length ? entrada.pais : [SEM_REGISTRO]} />
          <Campo rotulo="Uniões" valores={unioes} />
          <Campo rotulo="Nacionalid." valores={entrada.nacionalidades} />
          <Campo rotulo="Religião" valores={entrada.religioes} />
          <Campo rotulo="Profissões" valores={entrada.profissoes} />
          <Campo rotulo="Escolarid." valores={entrada.escolaridade} />
          <Campo rotulo="Idiomas" valores={entrada.idiomas} />
          <Campo
            rotulo="Outros"
            valores={entrada.outros_eventos.map(
              (ev) => `${ev.tipo}: ${linhaDeEvento(ev)}`,
            )}
          />

          {entrada.minibiografia && (
            <p className="mt-[1.5mm] mb-0 text-[10.5pt] leading-snug italic">
              {entrada.minibiografia}
            </p>
          )}
        </div>
      </div>
    </article>
  );
}

/** O diagrama, em SVG estático e escalado para caber na largura da página. */
export function DiagramaImpressao({
  grafo,
  maxAltura,
  className,
}: {
  grafo: TreeGraph;
  maxAltura?: string;
  className?: string;
}) {
  const layout = calcularLayout(grafo);

  return (
    <div className={className ?? 'mb-[8mm] w-full flex items-center justify-center'}>
      <svg
        viewBox={`0 0 ${layout.largura} ${layout.altura}`}
        width="100%"
        style={{ maxHeight: maxAltura ?? '220mm', display: 'block' }}
        preserveAspectRatio="xMidYMid meet"
        role="img"
        aria-label="Diagrama da árvore genealógica"
      >
        <defs>
          <filter id="sombra-card-print" x="-5%" y="-5%" width="110%" height="115%">
            <feDropShadow dx="0" dy="1.5" stdDeviation="1.5" floodColor="#000" floodOpacity="0.08" />
          </filter>
        </defs>

        <g fill="none" strokeWidth={1.8}>
          {layout.arestas.map((a) => (
            <path
              key={a.id}
              d={caminhoOrtogonal(a.origem, a.destino)}
              stroke="#8a8274"
              strokeDasharray={a.tipoVinculo && a.tipoVinculo !== 'biologico' ? '6 4' : undefined}
            />
          ))}
        </g>

        {layout.unioes.map((u) => (
          <g key={u.id} transform={`translate(${u.x}, ${u.y})`}>
            <circle
              r={10}
              fill={u.estado_vinculo === 'casamento' ? '#8a8274' : '#fff'}
              stroke="#8a8274"
              strokeWidth={1.8}
            />
            {u.estado_vinculo === 'casamento' && (
              <text textAnchor="middle" y={3.5} fontSize={10} fill="#fff" fontWeight="bold">
                ⚭
              </text>
            )}
          </g>
        ))}

        {layout.pessoas.map((p) => {
          const nome = [p.nome, p.sobrenome].filter(Boolean).join(' ');
          const anos = [p.ano_nascimento, p.ano_falecimento].filter(Boolean).join('–');
          const corBordaSexo = p.sexo === 'M' ? '#3b82f6' : p.sexo === 'F' ? '#ec4899' : '#8a8274';

          return (
            <g key={p.id} transform={`translate(${p.x}, ${p.y})`}>
              <rect
                x={-METRICAS.larguraNo / 2}
                y={-METRICAS.alturaNo / 2}
                width={METRICAS.larguraNo}
                height={METRICAS.alturaNo}
                rx={8}
                fill="#ffffff"
                stroke={p.is_placeholder ? '#c4bcac' : '#b8b0a2'}
                strokeWidth={1.5}
                strokeDasharray={p.is_placeholder ? '5 4' : undefined}
                filter="url(#sombra-card-print)"
              />
              {/* Barra lateral indicativa de sexo */}
              <rect
                x={-METRICAS.larguraNo / 2 + 1}
                y={-METRICAS.alturaNo / 2 + 3}
                width={5}
                height={METRICAS.alturaNo - 6}
                rx={2.5}
                fill={corBordaSexo}
              />
              <text
                textAnchor="middle"
                y={-10}
                fontSize={15}
                fontFamily="'Source Serif 4', Georgia, serif"
                fontWeight="bold"
                fill="#1c1917"
              >
                {nome.length > 28 ? `${nome.slice(0, 27)}…` : nome}
              </text>
              <text textAnchor="middle" y={12} fontSize={12.5} fill="#57534e" fontFamily="sans-serif">
                {anos ? `* ${anos}` : 'datas não registradas'}
              </text>
              {p.categoria && (
                <text textAnchor="middle" y={30} fontSize={10} fill="#78716c" fontFamily="sans-serif">
                  {p.categoria.length > 34 ? `${p.categoria.slice(0, 33)}…` : p.categoria}
                </text>
              )}
            </g>
          );
        })}
      </svg>
    </div>
  );
}

export function RelatorioView({ relatorio, grafo, opcoes, titulo }: RelatorioViewProps) {
  const mostrarDiagrama = opcoes.modo !== 'texto';
  const mostrarTexto = opcoes.modo !== 'hierarquia';

  // Agrupa por geração só quando a quebra de página foi pedida; caso contrário
  // as fichas correm seguidas e economizam papel.
  const porGeracao = new Map<number, EntradaRelatorio[]>();
  for (const e of relatorio.entradas) {
    const lista = porGeracao.get(e.geracao) ?? [];
    lista.push(e);
    porGeracao.set(e.geracao, lista);
  }
  const geracoes = [...porGeracao.keys()].sort((a, b) => a - b);

  return (
    <div id="print-container" className="hidden print:block text-[#2f2a22] bg-white">
      <header className="mb-[6mm] pb-[3mm] border-b-2 border-[#2f2a22]">
        <h1 className="m-0 text-[19pt] font-bold leading-tight">{titulo}</h1>
        <p className="m-0 mt-[1mm] text-[9.5pt] text-[#6b6355]">
          {relatorio.total} {relatorio.total === 1 ? 'pessoa' : 'pessoas'}
          {relatorio.omitidas_vivas > 0 &&
            ` · ${relatorio.omitidas_vivas} pessoa(s) viva(s) omitida(s)`}
          {' · do mais antigo ao mais recente'}
        </p>
      </header>

      {mostrarDiagrama && grafo && <DiagramaImpressao grafo={grafo} />}

      {mostrarDiagrama && !grafo && (
        <p className="text-[10pt] italic text-[#6b6355]">
          O diagrama exige uma árvore com raiz escolhida. Escolha uma pessoa na lista antes
          de gerar o relatório em modo hierarquia.
        </p>
      )}

      {mostrarTexto &&
        geracoes.map((g) => (
          <section
            key={g}
            className={opcoes.quebrarPorGeracao ? 'geracao-relatorio' : undefined}
          >
            <h2 className="text-[11pt] font-bold uppercase tracking-wider text-[#6b6355] mt-[4mm] mb-[2mm] pb-[1mm] border-b border-[#ddd6c8]">
              Geração {g + 1}
            </h2>
            {porGeracao.get(g)!.map((e) => (
              <Ficha key={e.id} entrada={e} incluirMiniatura={opcoes.incluirMiniaturas} />
            ))}
          </section>
        ))}

      {mostrarTexto && relatorio.entradas.length === 0 && (
        <p className="text-[10pt] italic">Nenhuma pessoa neste recorte.</p>
      )}
    </div>
  );
}
