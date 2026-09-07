import { useMemo } from 'react';
import type { LinhaDeContexto, LinhaPessoal, Marco } from '../../../lib/api';

interface LinhaTempoPrintViewProps {
  linhasContexto: LinhaDeContexto[];
  linhasAtivasIds: string[];
  linhasPessoais: LinhaPessoal[];
  marcos: Marco[];
  anoDe: number;
  anoAte: number;
  anosPorFaixa?: number;
}

const ANO_CORRENTE = new Date().getFullYear();

export function LinhaTempoPrintView({
  linhasContexto,
  linhasAtivasIds,
  linhasPessoais,
  marcos,
  anoDe,
  anoAte,
  anosPorFaixa = 40,
}: LinhaTempoPrintViewProps) {
  // Gera faixas sucessivas de anos
  const faixas = useMemo(() => {
    const lista: { de: number; ate: number }[] = [];
    for (let inicio = anoDe; inicio < anoAte; inicio += anosPorFaixa) {
      lista.push({
        de: inicio,
        ate: Math.min(anoAte, inicio + anosPorFaixa),
      });
    }
    return lista;
  }, [anoDe, anoAte, anosPorFaixa]);

  // Linhas de contexto ativas
  const linhasAtivas = useMemo(
    () => linhasContexto.filter((l) => linhasAtivasIds.includes(l.id)),
    [linhasContexto, linhasAtivasIds]
  );

  return (
    <div id="print-container" className="hidden print:block text-[#1c1917] bg-white p-8">
      {/* Cabeçalho do Documento */}
      <div className="border-b-2 border-stone-800 pb-4 mb-6">
        <div className="flex items-baseline justify-between">
          <h1 className="text-2xl font-serif font-bold text-stone-900 tracking-tight m-0">
            Linha do Tempo
          </h1>
          <span className="text-sm font-sans text-stone-500">
            Período: {anoDe < 0 ? `${Math.abs(anoDe)} a.C.` : anoDe} a{' '}
            {anoAte < 0 ? `${Math.abs(anoAte)} a.C.` : anoAte}
          </span>
        </div>

        {/* Resumo das linhas e vidas incluídas */}
        <div className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-xs text-stone-600 font-sans">
          {linhasPessoais.length > 0 && (
            <span>
              <strong>Vidas:</strong> {linhasPessoais.map((p) => p.nome).join(', ')}
            </span>
          )}
          {linhasAtivas.length > 0 && (
            <span>
              <strong>Linhas de Contexto:</strong> {linhasAtivas.map((l) => l.titulo).join(', ')}
            </span>
          )}
        </div>
      </div>

      {/* Faixas Sucessivas com Eixo Repetido */}
      <div className="flex flex-col gap-8">
        {faixas.map((faixa, fIdx) => {
          const span = Math.max(1, faixa.ate - faixa.de);
          const passo = span <= 20 ? 5 : 10;
          const marcas: number[] = [];
          for (let a = Math.ceil(faixa.de / passo) * passo; a <= faixa.ate; a += passo) {
            marcas.push(a);
          }

          // Marcos dentro desta faixa
          const marcosFaixa = marcos
            .filter((m) => {
              const inicio = m.ano_inicio ?? faixa.de;
              const fim = m.ano_fim ?? inicio;
              return fim >= faixa.de && inicio <= faixa.ate;
            })
            .sort((a, b) => (a.ano_inicio ?? 0) - (b.ano_inicio ?? 0));

          // Eventos pessoais dentro desta faixa
          const eventosPessoaisFaixa: Array<{
            pessoaNome: string;
            tipo: string;
            ano: number;
            dataTexto?: string | null;
            local?: string | null;
            com?: string | null;
            titulo?: string | null;
            linhaTitulo?: string | null;
            papel?: string | null;
          }> = [];

          for (const lp of linhasPessoais) {
            for (const m of lp.marcos) {
              if (m.ano != null && m.ano >= faixa.de && m.ano <= faixa.ate) {
                eventosPessoaisFaixa.push({
                  pessoaNome: lp.nome,
                  tipo: m.tipo,
                  ano: m.ano,
                  dataTexto: m.data_texto,
                  local: m.local,
                  com: m.com,
                  titulo: m.titulo,
                  linhaTitulo: m.linha_titulo,
                  papel: m.papel,
                });
              }
            }
          }

          return (
            <div
              key={`faixa-${fIdx}`}
              className="border border-stone-300 rounded-sm p-4 break-inside-avoid"
            >
              {/* Régua de Anos Superior */}
              <div className="relative h-6 border-b-2 border-stone-800 mb-4">
                {marcas.map((ano) => {
                  const pct = ((ano - faixa.de) / span) * 100;
                  return (
                    <div
                      key={ano}
                      className="absolute top-0 flex flex-col items-start -translate-x-1/2"
                      style={{ left: `${pct}%` }}
                    >
                      <span className="text-[10px] font-mono font-semibold text-stone-700">
                        {ano < 0 ? `${Math.abs(ano)} a.C.` : ano}
                      </span>
                      <span className="w-px h-2 bg-stone-500 mt-0.5" />
                    </div>
                  );
                })}
              </div>

              {/* Trilhos das Vidas */}
              {linhasPessoais.map((lp) => {
                const nasc = lp.ano_nascimento;
                const falec = lp.ano_falecimento ?? (lp.is_vivo ? ANO_CORRENTE : null);
                if (nasc == null) return null;
                const fimVida = falec ?? faixa.ate;
                if (fimVida < faixa.de || nasc > faixa.ate) return null;

                const inicioClamped = Math.max(faixa.de, nasc);
                const fimClamped = Math.min(faixa.ate, fimVida);
                const leftPct = ((inicioClamped - faixa.de) / span) * 100;
                const widthPct = Math.max(2, ((fimClamped - inicioClamped) / span) * 100);

                return (
                  <div key={lp.pessoa_id} className="relative h-7 mb-2 border-b border-stone-200">
                    <span className="absolute left-0 -top-3 text-[9px] font-sans font-bold text-stone-700">
                      {lp.nome} ({nasc}–{falec ?? 'vivo'})
                    </span>

                    {/* Faixa da vida impressa */}
                    <div
                      className="absolute top-1 h-3.5 bg-stone-300 border border-stone-500 rounded-xs"
                      style={{ left: `${leftPct}%`, width: `${widthPct}%` }}
                    />

                    {/* Eventos da pessoa na faixa */}
                    {lp.marcos
                      .filter((m) => m.ano != null && m.ano >= faixa.de && m.ano <= faixa.ate)
                      .map((m, mIdx) => {
                        const mPct = ((m.ano! - faixa.de) / span) * 100;
                        return (
                          <div
                            key={mIdx}
                            className="absolute top-0.5 -translate-x-1/2 flex flex-col items-center"
                            style={{ left: `${mPct}%` }}
                          >
                            <span className="w-1.5 h-1.5 rounded-full bg-stone-900 border border-white" />
                            <span className="text-[8px] font-mono font-bold text-stone-800 mt-0.5">
                              {m.ano}
                            </span>
                          </div>
                        );
                      })}
                  </div>
                );
              })}

              {/* Trilhos das Linhas de Contexto com Marcadores Numerados */}
              {linhasAtivas.map((linha) => {
                const marcosDaLinha = marcosFaixa.filter((m) => m.linha_id === linha.id);
                if (marcosDaLinha.length === 0) return null;

                return (
                  <div key={linha.id} className="relative h-7 mb-2 border-b border-stone-200">
                    <span className="absolute left-0 -top-3 text-[9px] font-sans font-bold text-stone-600">
                      {linha.titulo}
                    </span>

                    {marcosDaLinha.map((m, mIdx) => {
                      const inicio = m.ano_inicio ?? faixa.de;
                      const mPct = ((inicio - faixa.de) / span) * 100;
                      return (
                        <div
                          key={m.id}
                          className="absolute top-0.5 -translate-x-1/2 flex flex-col items-center"
                          style={{ left: `${mPct}%` }}
                        >
                          <span className="w-3.5 h-3.5 rounded-full bg-stone-800 text-white text-[8px] font-mono font-bold flex items-center justify-center">
                            {mIdx + 1}
                          </span>
                        </div>
                      );
                    })}
                  </div>
                );
              })}

              {/* Legenda / Detalhes dos Acontecimentos desta Faixa */}
              {(marcosFaixa.length > 0 || eventosPessoaisFaixa.length > 0) && (
                <div className="mt-4 pt-3 border-t border-stone-200">
                  <h3 className="text-xs font-sans font-bold text-stone-700 uppercase tracking-wide mb-2">
                    Acontecimentos Registrados ({faixa.de}–{faixa.ate})
                  </h3>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-1.5 text-xs text-stone-800 font-sans">
                    {/* Eventos das Linhas de Contexto */}
                    {linhasAtivas.map((linha) => {
                      const marcosDaLinha = marcosFaixa.filter((m) => m.linha_id === linha.id);
                      return marcosDaLinha.map((m, mIdx) => (
                        <div key={m.id} className="flex items-start gap-1.5">
                          <span className="w-4 h-4 rounded-full bg-stone-800 text-white text-[9px] font-mono font-bold flex items-center justify-center flex-none mt-0.5">
                            {mIdx + 1}
                          </span>
                          <div className="min-w-0">
                            <span className="font-bold">{m.titulo}</span>
                            <span className="text-stone-500 font-mono text-[11px] ml-1">
                              ({m.data_periodo_texto})
                            </span>
                            {m.descricao && (
                              <p className="text-[11px] text-stone-600 leading-tight m-0 mt-0.5">
                                {m.descricao}
                              </p>
                            )}
                          </div>
                        </div>
                      ));
                    })}

                    {/* Eventos da Família / Pessoais */}
                    {eventosPessoaisFaixa.map((ep, epIdx) => (
                      <div key={`ep-${epIdx}`} className="flex items-start gap-1.5">
                        <span className="w-4 h-4 rounded-xs bg-stone-200 text-stone-800 text-[9px] font-mono font-bold flex items-center justify-center flex-none mt-0.5">
                          •
                        </span>
                        <div className="min-w-0">
                          <span className="font-bold">
                            {ep.pessoaNome}: {ep.titulo ?? ep.tipo}
                          </span>
                          <span className="text-stone-500 font-mono text-[11px] ml-1">
                            ({ep.dataTexto ?? ep.ano})
                          </span>
                          {ep.com && (
                            <span className="text-stone-600 text-[11px] ml-1">com {ep.com}</span>
                          )}
                          {ep.papel && (
                            <span className="text-stone-600 text-[11px] ml-1">
                              (Papel: {ep.papel})
                            </span>
                          )}
                          {ep.local && (
                            <span className="text-stone-500 text-[11px] block">{ep.local}</span>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* Rodapé da Impressão */}
      <div className="mt-8 pt-4 border-t border-stone-300 flex items-center justify-between text-xs text-stone-400 font-sans">
        <span>Árvore Genealógica — Linha do Tempo</span>
        <span>Impresso em {new Date().toLocaleDateString('pt-BR')}</span>
      </div>
    </div>
  );
}
