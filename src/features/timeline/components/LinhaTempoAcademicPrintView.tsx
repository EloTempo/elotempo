import { useMemo } from "react";
import type { DadosImpressaoTimeline, OpcoesImpressaoAcademica } from "../tiposImpressao";
import { formatarAno } from "../../../lib/tree/layout";
import { converterDataParaAnoFracionario } from "../ordenacaoTrilhas";
import { mapearNumerosMarcosDaFolha, calcularAnticolisaoMarcos } from "../anticolisaoImpressao";

interface LinhaTempoAcademicPrintViewProps {
  dados: DadosImpressaoTimeline;
  opcoes: OpcoesImpressaoAcademica;
  paginaAtual?: number;
  modoPreview?: boolean;
}

const ANO_CORRENTE = new Date().getFullYear();

function corPadraoPessoa(sexo: string | undefined): string {
  if (sexo === "F") return "#ec4899";
  if (sexo === "M") return "#3b82f6";
  return "#8b5cf6";
}

export function LinhaTempoAcademicPrintView({
  dados,
  opcoes,
  paginaAtual,
  modoPreview = false,
}: LinhaTempoAcademicPrintViewProps) {
  const {
    linhasPessoais,
    linhasContexto,
    linhasAtivasIds,
    marcos,
    coresPersonalizadas,
  } = dados;

  // Filtrar apenas linhas de contexto ativas
  const linhasAtivas = useMemo(
    () => linhasContexto.filter((l) => linhasAtivasIds.includes(l.id)),
    [linhasContexto, linhasAtivasIds]
  );

  // Determinar o intervalo temporal global a ser impresso
  const anoDe = opcoes.anoDe;
  const anoAte = Math.max(anoDe + 1, opcoes.anoAte);
  const spanTotal = anoAte - anoDe;

  // Calcular as páginas (fatias cronológicas em A4 Paisagem)
  const paginas = useMemo(() => {
    if (opcoes.anosPorPagina === "auto" || spanTotal <= (typeof opcoes.anosPorPagina === "number" ? opcoes.anosPorPagina : 40)) {
      return [{ de: anoDe, ate: anoAte }];
    }
    const faixaAnos = typeof opcoes.anosPorPagina === "number" ? opcoes.anosPorPagina : 40;
    const lista: { de: number; ate: number }[] = [];
    for (let inicio = anoDe; inicio < anoAte; inicio += faixaAnos) {
      lista.push({
        de: inicio,
        ate: Math.min(anoAte, inicio + faixaAnos),
      });
    }
    return lista;
  }, [anoDe, anoAte, spanTotal, opcoes.anosPorPagina]);

  const totalPaginas = paginas.length;

  // Se estiver em modo preview de folha única, exibe apenas a página selecionada
  const paginasParaRenderizar = useMemo(() => {
    if (modoPreview && paginaAtual != null) {
      const idx = Math.min(Math.max(0, paginaAtual - 1), paginas.length - 1);
      return [{ ...paginas[idx], indiceReal: idx }];
    }
    return paginas.map((p, idx) => ({ ...p, indiceReal: idx }));
  }, [modoPreview, paginaAtual, paginas]);

  return (
    <div className={modoPreview ? "flex flex-col items-center gap-8 w-full" : "academic-print-root"}>
      {paginasParaRenderizar.map((faixa) => {
        const spanFaixa = Math.max(1, faixa.ate - faixa.de);
        const pIdx = faixa.indiceReal;

        // Calcular subdivisões da régua para esta página
        const passoPrincipal = spanFaixa <= 25 ? 5 : spanFaixa <= 60 ? 10 : 20;
        const marcasPrincipais: number[] = [];
        const primeiroAnoRedondo = Math.ceil(faixa.de / passoPrincipal) * passoPrincipal;
        for (let a = primeiroAnoRedondo; a <= faixa.ate; a += passoPrincipal) {
          marcasPrincipais.push(a);
        }

        const passoSecundario = spanFaixa <= 25 ? 1 : spanFaixa <= 60 ? 2 : 5;
        const marcasSecundarias: number[] = [];
        const primeiroAnoSecundario = Math.ceil(faixa.de / passoSecundario) * passoSecundario;
        for (let a = primeiroAnoSecundario; a <= faixa.ate; a += passoSecundario) {
          if (!marcasPrincipais.includes(a)) {
            marcasSecundarias.push(a);
          }
        }

        // Função de mapeamento X (%) dentro da faixa da página
        const obterPct = (ano: number) => {
          return Math.max(0, Math.min(100, ((ano - faixa.de) / spanFaixa) * 100));
        };

        // Marcos de contexto que caem nesta página
        const marcosContextoFaixa = marcos
          .filter((m) => {
            const ini = m.ano_inicio ?? faixa.de;
            const fim = m.ano_fim ?? ini;
            return fim >= faixa.de && ini <= faixa.ate && linhasAtivasIds.includes(m.linha_id);
          })
          .sort((a, b) => {
            const anoA = converterDataParaAnoFracionario(a.ano_inicio, a.data_periodo_texto) ?? a.ano_inicio ?? 0;
            const anoB = converterDataParaAnoFracionario(b.ano_inicio, b.data_periodo_texto) ?? b.ano_inicio ?? 0;
            return anoA - anoB;
          });

        // Mapeamento global de números de marcos desta folha (1, 2, 3, ...)
        const mapaNumerosGlobais = mapearNumerosMarcosDaFolha(marcosContextoFaixa);

        // Eventos pessoais que caem nesta página
        const eventosPessoaisFaixa: Array<{
          pessoaId: string;
          pessoaNome: string;
          cor: string;
          tipo: string;
          ano: number;
          dataTexto?: string | null;
          local?: string | null;
          com?: string | null;
          titulo?: string | null;
          papel?: string | null;
        }> = [];

        for (const lp of linhasPessoais) {
          const corPessoa = coresPersonalizadas[lp.pessoa_id] ?? corPadraoPessoa(lp.sexo);
          for (const m of lp.marcos) {
            if (m.ano != null && m.ano >= faixa.de && m.ano <= faixa.ate) {
              eventosPessoaisFaixa.push({
                pessoaId: lp.pessoa_id,
                pessoaNome: lp.nome,
                cor: corPessoa,
                tipo: m.tipo,
                ano: m.ano,
                dataTexto: m.data_texto,
                local: m.local,
                com: m.com,
                titulo: m.titulo,
                papel: m.papel,
              });
            }
          }
        }

        return (
          <div
            key={`academic-page-${pIdx}`}
            className="academic-a4-landscape bg-white text-[#1c1917] flex flex-col justify-between box-border"
            style={{
              width: "1123px",
              minHeight: "794px",
              maxHeight: "794px",
              padding: "36px 44px 32px 44px",
              boxSizing: "border-box",
              pageBreakAfter: "always",
              breakAfter: "page",
            }}
          >
            {/* 1. TOPO: Identificação da Ilustração Acadêmica conforme ABNT (NBR 14724) */}
            <div className="border-b-2 border-neutral-900 pb-2.5 mb-3 flex-none">
              <div className="flex items-baseline justify-between gap-4">
                <h2 className="text-[15px] font-serif font-bold text-neutral-900 m-0 tracking-tight leading-snug">
                  Figura {opcoes.numeroFigura || "1"} – {opcoes.tituloFigura || "Linha do Tempo Genealógica e Histórica"} ({formatarAno(faixa.de)} a {formatarAno(faixa.ate)})
                </h2>
                <span className="text-[11px] font-mono text-neutral-500 flex-none">
                  Folha {pIdx + 1} de {totalPaginas}
                </span>
              </div>
              <div className="flex items-center justify-between text-[10.5px] text-neutral-600 font-sans mt-0.5">
                <span>
                  Recorte cronológico de {spanFaixa} anos · {linhasPessoais.length} {linhasPessoais.length === 1 ? "vida analisada" : "vidas comparadas"} · {linhasAtivas.length} {linhasAtivas.length === 1 ? "trilha de contexto" : "trilhas de contexto"}
                </span>
                <span className="text-neutral-400">
                  EloTempo · Pesquisa Histórico-Genealógica
                </span>
              </div>
            </div>

            {/* 2. ÁREA GRÁFICA DA LINHA DO TEMPO (Régua + Vidas + Contexto) */}
            <div className="flex-1 flex flex-col border border-neutral-300 rounded-xs p-3 bg-neutral-50/30 min-h-0 overflow-hidden relative">
              {/* Régua de Anos Superior da Página */}
              <div className="relative h-7 border-b border-neutral-800 mb-2 flex-none select-none">
                {/* Marcas Secundárias */}
                {marcasSecundarias.map((ano) => (
                  <div
                    key={`sub-${ano}`}
                    className="absolute bottom-0 h-1.5 border-l border-neutral-400 pointer-events-none"
                    style={{ left: `${obterPct(ano)}%` }}
                  />
                ))}

                {/* Marcas Principais */}
                {marcasPrincipais.map((ano) => (
                  <div
                    key={`pri-${ano}`}
                    className="absolute top-0 bottom-0 flex flex-col items-center -translate-x-1/2 pointer-events-none"
                    style={{ left: `${obterPct(ano)}%` }}
                  >
                    <span className="text-[10px] font-mono font-bold text-neutral-800">
                      {formatarAno(ano)}
                    </span>
                    <span className="w-px h-2.5 bg-neutral-800 mt-auto" />
                  </div>
                ))}
              </div>

              {/* Grade de fundo vertical nas trilhas */}
              <div className="absolute top-10 bottom-2 left-3 right-3 pointer-events-none overflow-hidden z-0">
                {marcasPrincipais.map((ano) => (
                  <div
                    key={`grid-print-${ano}`}
                    className="absolute top-0 bottom-0 border-l border-dashed border-neutral-200"
                    style={{ left: `${obterPct(ano)}%` }}
                  />
                ))}
              </div>

              {/* Trilhas de Vidas na Árvore */}
              <div className="flex flex-col gap-1.5 z-10 mb-2">
                {linhasPessoais.map((lp) => {
                  const nasc = lp.ano_nascimento;
                  const falec = lp.ano_falecimento ?? (lp.is_vivo ? ANO_CORRENTE : null);
                  const cor = coresPersonalizadas[lp.pessoa_id] ?? corPadraoPessoa(lp.sexo);

                  // Se a pessoa não nasceu ou já morreu antes desta folha
                  const vivoNestaFolha = nasc != null && (falec ?? ANO_CORRENTE) >= faixa.de && nasc <= faixa.ate;

                  return (
                    <div key={`vida-${lp.pessoa_id}`} className="flex items-center gap-2 h-6 relative border-b border-neutral-200/60 pb-1 last:border-b-0">
                      {/* Identificador / Nome na lateral esquerda */}
                      <div className="w-44 flex-none flex items-center gap-1.5 truncate pr-2 border-r border-neutral-300">
                        <span
                          className="w-2.5 h-2.5 rounded-full flex-none"
                          style={{ backgroundColor: cor }}
                        />
                        <span className="text-[11px] font-bold text-neutral-900 truncate" title={lp.nome}>
                          {lp.nome}
                        </span>
                      </div>

                      {/* Raia Temporal com Barra de Vida */}
                      <div className="flex-1 relative h-full">
                        {vivoNestaFolha && nasc != null && (
                          <>
                            {/* Barra de Longevidade Desduplicada */}
                            {(() => {
                              const inicioClamped = Math.max(faixa.de, nasc);
                              const fimClamped = Math.min(faixa.ate, falec ?? ANO_CORRENTE);
                              const xIni = obterPct(inicioClamped);
                              const xFim = obterPct(fimClamped);
                              const larguraPct = Math.max(0.8, xFim - xIni);
                              // Largura estimada em pixels (raia tem ~825px)
                              const larguraPx = (larguraPct / 100) * 825;

                              return (
                                <div
                                  className="absolute top-1 h-3.5 rounded-xs flex items-center px-1 shadow-2xs overflow-hidden"
                                  style={{
                                    left: `${xIni}%`,
                                    width: `${larguraPct}%`,
                                    backgroundColor: `${cor}25`,
                                    border: `1.5px solid ${cor}`,
                                  }}
                                  title={`${lp.nome} (${nasc ?? "?"} – ${falec ?? (lp.is_vivo ? "presente" : "?")})`}
                                >
                                  {/* Rótulo limpo e desdensificado dentro da barra */}
                                  {larguraPx >= 110 ? (
                                    <span className="text-[9px] font-semibold text-neutral-800 truncate select-none">
                                      {nasc >= faixa.de ? nasc : ""}–{falec != null && falec <= faixa.ate ? falec : (lp.is_vivo ? "atual" : "")}
                                    </span>
                                  ) : larguraPx >= 65 ? (
                                    <span className="text-[8px] font-medium text-neutral-700 truncate select-none">
                                      {nasc}–{falec ?? ""}
                                    </span>
                                  ) : null}
                                </div>
                              );
                            })()}

                            {/* Marcos intermediários na vida (casamento, marcos específicos) - evita duplicar nascimento/falecimento */}
                            {lp.marcos
                              .filter((m) => m.ano != null && m.ano >= faixa.de && m.ano <= faixa.ate && m.tipo !== "nascimento" && m.tipo !== "falecimento")
                              .map((m, mIdx) => {
                                const posX = obterPct(m.ano!);
                                return (
                                  <div
                                    key={mIdx}
                                    className="absolute top-0 -translate-x-1/2 flex flex-col items-center z-10"
                                    style={{ left: `${posX}%` }}
                                    title={`${m.titulo ?? m.tipo} (${m.ano})`}
                                  >
                                    <div
                                      className="w-3.5 h-3.5 rounded-full bg-white flex items-center justify-center text-[8.5px] shadow-xs border"
                                      style={{ borderColor: cor }}
                                    >
                                      {m.tipo === "casamento" ? "⚭" : "•"}
                                    </div>
                                  </div>
                                );
                              })}
                          </>
                        )}
                      </div>
                    </div>
                  );
                })}
              </div>

              {/* Divisória sutil entre vidas e contexto */}
              {linhasPessoais.length > 0 && linhasAtivas.length > 0 && (
                <div className="border-t border-neutral-300 my-1 flex-none" />
              )}

              {/* Trilhas de Linhas de Contexto com Anticolisão e Agrupamento */}
              <div className="flex flex-col gap-1.5 z-10">
                {linhasAtivas.map((linha) => {
                  const corLinha = coresPersonalizadas[linha.id] ?? "#64748b";
                  const marcosDaLinhaNestaFaixa = marcosContextoFaixa.filter((m) => m.linha_id === linha.id);

                  // Processamento cartográfico anticolisão
                  const itensRenderizaveis = calcularAnticolisaoMarcos(
                    marcosDaLinhaNestaFaixa,
                    mapaNumerosGlobais,
                    faixa.de,
                    faixa.ate,
                    825,
                    18,
                    75
                  );

                  return (
                    <div key={`ctx-${linha.id}`} className="flex items-center gap-2 h-6 relative border-b border-neutral-200/60 pb-1 last:border-b-0">
                      {/* Header da Linha de Contexto */}
                      <div className="w-44 flex-none flex items-center gap-1.5 truncate pr-2 border-r border-neutral-300">
                        <span
                          className="w-2.5 h-2.5 rounded-xs flex-none"
                          style={{ backgroundColor: corLinha }}
                        />
                        <span className="text-[11px] font-bold text-neutral-800 truncate" title={linha.titulo}>
                          {linha.titulo}
                        </span>
                      </div>

                      {/* Raia de Marcos da Linha de Contexto com Anticolisão */}
                      <div className="flex-1 relative h-full">
                        {itensRenderizaveis.map((item) => {
                          if (item.tipo === "cluster") {
                            // Cluster elegante de marcos densamente concentrados
                            return (
                              <div
                                key={`cluster-${item.anoInicioFrac}-${item.rotuloNumeros}`}
                                className="absolute top-0.5 -translate-x-1/2 flex items-center z-20"
                                style={{ left: `${item.pctX}%` }}
                                title={`${item.total} acontecimentos históricos em ${item.anoTexto} (Marcos ${item.rotuloNumeros}). Consulte o quadro sinóptico abaixo.`}
                              >
                                <div
                                  className="h-4 px-1.5 rounded-full text-white text-[8px] font-bold font-mono flex items-center gap-1 shadow-xs border border-white whitespace-nowrap"
                                  style={{ backgroundColor: corLinha }}
                                >
                                  <span>{item.rotuloNumeros}</span>
                                  <span className="text-[7px] font-sans opacity-85">({item.total})</span>
                                </div>
                              </div>
                            );
                          }

                          // Marco individual (pontual ou intervalo)
                          if (item.ehIntervalo) {
                            return (
                              <div
                                key={item.marco.id}
                                className="absolute top-0.5 flex items-center"
                                style={{ left: `${item.pctX}%` }}
                              >
                                <div
                                  className="h-3.5 rounded-xs flex items-center px-1 border text-[8.5px] font-bold truncate text-white shadow-2xs"
                                  style={{
                                    width: `${Math.max(item.larguraBarraPct, 1)}%`,
                                    backgroundColor: corLinha,
                                    borderColor: corLinha,
                                  }}
                                  title={`${item.marco.titulo} (${item.marco.data_periodo_texto ?? item.marco.ano_inicio})`}
                                >
                                  {item.larguraBarraPx >= 55 && (
                                    <span className="truncate">{item.marco.titulo}</span>
                                  )}
                                </div>
                              </div>
                            );
                          }

                          // Marco individual pontual
                          return (
                            <div
                              key={item.marco.id}
                              className="absolute top-0.5 flex items-center -translate-x-1/2 z-10"
                              style={{ left: `${item.pctX}%` }}
                              title={`${item.marco.titulo} (${item.marco.data_periodo_texto ?? item.marco.ano_inicio})`}
                            >
                              <span
                                className="min-w-[15px] h-[15px] px-0.5 rounded-full text-white text-[8px] font-bold font-mono flex items-center justify-center shadow-xs border border-white flex-none"
                                style={{ backgroundColor: corLinha }}
                              >
                                {item.numeroNaFolha}
                              </span>
                              {/* Rótulo textual garantido sem sobreposição */}
                              {item.exibirTitulo && (
                                <span className="ml-1 text-[9px] font-sans font-semibold text-neutral-900 bg-white/95 px-1 py-0.2 rounded border border-neutral-300 truncate max-w-[125px] shadow-2xs">
                                  {item.marco.titulo}
                                </span>
                              )}
                            </div>
                          );
                        })}
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>

            {/* 3. BASE ABNT: Legenda Cromática, Quadro de Acontecimentos e Fonte */}
            <div className="flex-none mt-2 pt-2 border-t border-neutral-300">
              {/* Legenda de Cores e Convenções */}
              <div className="mb-2">
                <span className="text-[10px] font-bold uppercase tracking-wider text-neutral-600 block mb-1">
                  Legenda Cromática e Iconográfica:
                </span>
                <div className="flex flex-wrap gap-x-4 gap-y-1 text-[10px] text-neutral-800">
                  {linhasPessoais.map((lp) => {
                    const cor = coresPersonalizadas[lp.pessoa_id] ?? corPadraoPessoa(lp.sexo);
                    return (
                      <div key={`leg-p-${lp.pessoa_id}`} className="flex items-center gap-1">
                        <span className="w-2.5 h-2.5 rounded-full flex-none" style={{ backgroundColor: cor }} />
                        <span className="font-semibold">{lp.nome}</span>
                      </div>
                    );
                  })}
                  {linhasAtivas.map((l) => {
                    const cor = coresPersonalizadas[l.id] ?? "#64748b";
                    return (
                      <div key={`leg-c-${l.id}`} className="flex items-center gap-1">
                        <span className="w-2.5 h-2.5 rounded-xs flex-none" style={{ backgroundColor: cor }} />
                        <span>{l.titulo}</span>
                      </div>
                    );
                  })}
                  <div className="flex items-center gap-2 pl-2 border-l border-neutral-300 text-neutral-500 font-medium">
                    <span>— Barra de Vida (Nasc.–Falec.)</span>
                    <span>⚭ Casamento</span>
                    <span>① Marcos Numerados / Clusters</span>
                  </div>
                </div>
              </div>

              {/* Quadro Sinóptico de Marcos (se habilitado) */}
              {opcoes.incluirQuadroMarcos && (marcosContextoFaixa.length > 0 || eventosPessoaisFaixa.length > 0) && (
                <div className="bg-neutral-100/75 border border-neutral-200 rounded-xs p-2 mb-2 max-h-[115px] overflow-hidden">
                  <div className="flex items-center justify-between mb-1">
                    <span className="text-[9.5px] font-bold uppercase tracking-wider text-neutral-700">
                      Acontecimentos Registrados na Folha ({faixa.de} a {faixa.ate}):
                    </span>
                    <span className="text-[9px] font-mono text-neutral-500">
                      {marcosContextoFaixa.length} marco(s) de contexto · {eventosPessoaisFaixa.length} evento(s) biográfico(s)
                    </span>
                  </div>
                  <div className={`grid ${marcosContextoFaixa.length > 10 ? "grid-cols-3" : "grid-cols-2"} gap-x-3 gap-y-1 text-[9px] text-neutral-800 leading-tight`}>
                    {marcosContextoFaixa.slice(0, marcosContextoFaixa.length > 10 ? 18 : 8).map((m) => {
                      const num = mapaNumerosGlobais.get(m.id) ?? 1;
                      const cor = coresPersonalizadas[m.linha_id] ?? "#64748b";
                      return (
                        <div key={m.id} className="flex items-start gap-1 truncate">
                          <span
                            className="w-3.5 h-3.5 rounded-full text-white text-[7.5px] font-mono font-bold flex items-center justify-center flex-none"
                            style={{ backgroundColor: cor }}
                          >
                            {num}
                          </span>
                          <span className="font-semibold truncate">{m.titulo}</span>
                          <span className="text-neutral-500 font-mono text-[8px] flex-none">
                            ({m.data_periodo_texto ?? m.ano_inicio})
                          </span>
                          {m.fonte_especifica && (
                            <span className="text-neutral-400 italic truncate text-[8px]">[{m.fonte_especifica}]</span>
                          )}
                        </div>
                      );
                    })}
                    {marcosContextoFaixa.length > (marcosContextoFaixa.length > 10 ? 18 : 8) && (
                      <div className="text-[8px] italic text-neutral-500 col-span-full pt-0.5">
                        + {marcosContextoFaixa.length - (marcosContextoFaixa.length > 10 ? 18 : 8)} outros marcos catalogados nesta folha (consulte anexo/relatório completo).
                      </div>
                    )}
                    {eventosPessoaisFaixa.slice(0, 3).map((ep, epIdx) => (
                      <div key={`ep-${epIdx}`} className="flex items-start gap-1 truncate">
                        <span className="font-bold text-neutral-700 flex-none">•</span>
                        <span className="font-semibold truncate">{ep.pessoaNome}: {ep.titulo ?? ep.tipo}</span>
                        <span className="text-neutral-500 font-mono text-[8px] flex-none">({ep.dataTexto ?? ep.ano})</span>
                        {ep.local && <span className="text-neutral-400 truncate text-[7.5px]">em {ep.local}</span>}
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Nota de Responsabilidade e Citação de Fonte (ABNT NBR 14724) */}
              <div className="flex items-center justify-between text-[9.5px] text-neutral-500 border-t border-neutral-200 pt-1.5 font-sans">
                <span>
                  <strong>Fonte:</strong> {opcoes.fonteTexto || "Elaborado pelo autor com o software EloTempo (2026), com base em registros civis, eclesiásticos e acervo histórico consultado."}
                </span>
                <span className="font-mono text-neutral-600 font-semibold">
                  Página {pIdx + 1} de {totalPaginas}
                </span>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
}
