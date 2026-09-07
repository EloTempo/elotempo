/**
 * Central Unificada de Impressão e Exportação Visual (Árvore, Relatórios e Linha do Tempo).
 *
 * Fornece um ambiente WYSIWYG (What You See Is What You Get) com:
 * - Alternador de abas entre Relatório de Família e Linha do Tempo.
 * - Simulação fiel da folha de papel (A4 / A3, Retrato / Paisagem) com margens reais.
 * - Zoom interativo de inspeção (50% a 150% e Ajustar à Tela).
 * - Paginação navegável com numeração (Página X de Y).
 * - Botão direto de envio à impressora / geração de PDF via window.print().
 */

import { useMemo, useState } from 'react';
import { createPortal } from 'react-dom';
import { useQuery } from '@tanstack/react-query';
import {
  ChevronLeft,
  ChevronRight,
  Printer,
  X,
  ZoomIn,
  ZoomOut,
} from 'lucide-react';
import { IconeArvore, IconeLinhaTempo } from '../../../components/icons';
import { Button, cn } from '../../../components/ui/Button';
import { useI18n } from '../../../i18n/I18nContext';
import {
  montarRelatorio,
  buscarGrafoArvore,
  listarLinhasDeContexto,
  buscarMarcos,
  montarLinhaPessoal,
  type EntradaRelatorio,
} from '../../../lib/api';
import { RelatorioView, DiagramaImpressao, type ModoImpressao } from './RelatorioView';
import type { DadosImpressaoTimeline, OpcoesImpressaoAcademica } from '../../timeline/tiposImpressao';
import { LinhaTempoAcademicPrintView } from '../../timeline/components/LinhaTempoAcademicPrintView';
import { useGatekeeper } from '../../security';

interface CentralImpressaoModalProps {
  raizId: string | null;
  pessoaSelecionadaId: string | null;
  abaInicial?: 'arvore' | 'timeline';
  dadosTimeline?: DadosImpressaoTimeline | null;
  onFechar: () => void;
}

const ANO_ATUAL = new Date().getFullYear();

export function CentralImpressaoModal({
  raizId,
  pessoaSelecionadaId,
  abaInicial = 'arvore',
  dadosTimeline,
  onFechar,
}: CentralImpressaoModalProps) {
  const { executarComGatekeeper } = useGatekeeper();
  const { t } = useI18n();

  const [aba, setAba] = useState<'arvore' | 'timeline'>(abaInicial);

  // Opções de Relatório da Árvore
  const [modo, setModo] = useState<ModoImpressao>('combinado');
  const [escopoArvore, setEscopoArvore] = useState(!!raizId);
  const [ocultarVivas, setOcultarVivas] = useState(false);
  const [incluirMiniaturas, setIncluirMiniaturas] = useState(true);
  const [quebrarPorGeracao, setQuebrarPorGeracao] = useState(true);

  // Opções de Linha do Tempo e Recorte
  const [escopoTimeline, setEscopoTimeline] = useState<'recorte' | 'janela' | 'vida' | 'personalizado'>(() => {
    if (dadosTimeline?.regiaoImpressao) return 'recorte';
    if (abaInicial === 'timeline' && dadosTimeline?.janelaAtual) return 'janela';
    return 'vida';
  });
  const [anoDeCustom, setAnoDeCustom] = useState<number>(() => {
    if (dadosTimeline?.regiaoImpressao) return dadosTimeline.regiaoImpressao.de;
    if (dadosTimeline?.janelaAtual) return Math.round(dadosTimeline.janelaAtual.de);
    return 1800;
  });
  const [anoAteCustom, setAnoAteCustom] = useState<number>(() => {
    if (dadosTimeline?.regiaoImpressao) return dadosTimeline.regiaoImpressao.ate;
    if (dadosTimeline?.janelaAtual) return Math.round(dadosTimeline.janelaAtual.ate);
    return ANO_ATUAL;
  });
  const [anosPorFaixa, setAnosPorFaixa] = useState<number | 'auto'>(40);

  // Parâmetros de Formatação Acadêmica ABNT (NBR 14724)
  const [numeroFigura, setNumeroFigura] = useState<string>('1');
  const [tituloFigura, setTituloFigura] = useState<string>(() => {
    if (dadosTimeline?.arvoreTitulo) {
      return `Linha do Tempo Comparativa – ${dadosTimeline.arvoreTitulo}`;
    }
    return 'Linha do Tempo Genealógica e Histórica';
  });
  const [fonteTexto, setFonteTexto] = useState<string>(
    'Elaborado pelo autor com o software EloTempo (2026), com base em registros civis, eclesiásticos e acervo histórico consultado.'
  );
  const [incluirQuadroMarcos, setIncluirQuadroMarcos] = useState<boolean>(true);

  // Controles de Visualização / Folha Virtual
  const [orientacao, setOrientacao] = useState<'retrato' | 'paisagem'>(
    abaInicial === 'timeline' ? 'paisagem' : 'retrato'
  );
  const [zoomPreview, setZoomPreview] = useState<number>(0.85);
  const [paginaAtual, setPaginaAtual] = useState<number>(1);

  const raizEfetiva = escopoArvore ? raizId : null;

  // Consultas da Árvore / Relatório
  const { data: relatorio } = useQuery({
    queryKey: ['relatorio-impressao', raizEfetiva, ocultarVivas],
    queryFn: () =>
      montarRelatorio({
        raiz_id: raizEfetiva,
        ocultar_vivas: ocultarVivas,
        incluir_placeholders: false,
      }),
  });

  const { data: grafo } = useQuery({
    queryKey: ['arvore-impressao', raizId],
    queryFn: () => buscarGrafoArvore(raizId!),
    enabled: !!raizId && modo !== 'texto',
  });

  // Consultas da Linha do Tempo (quando não fornecidos pela gaveta)
  const idParaLinhaPessoal = pessoaSelecionadaId ?? raizId;
  const { data: linhaPessoal } = useQuery({
    queryKey: ['linha-pessoal-impressao', idParaLinhaPessoal],
    queryFn: () => montarLinhaPessoal(idParaLinhaPessoal!),
    enabled: !dadosTimeline && !!idParaLinhaPessoal,
  });

  const { data: linhasContexto = [] } = useQuery({
    queryKey: ['linhas-contexto-impressao'],
    queryFn: listarLinhasDeContexto,
    enabled: !dadosTimeline,
  });

  // Anos efetivos da Timeline
  const { anoDeTimeline, anoAteTimeline } = useMemo(() => {
    if (escopoTimeline === 'recorte' && dadosTimeline?.regiaoImpressao) {
      return {
        anoDeTimeline: dadosTimeline.regiaoImpressao.de,
        anoAteTimeline: dadosTimeline.regiaoImpressao.ate,
      };
    }
    if (escopoTimeline === 'janela' && dadosTimeline?.janelaAtual) {
      return {
        anoDeTimeline: Math.round(dadosTimeline.janelaAtual.de),
        anoAteTimeline: Math.round(dadosTimeline.janelaAtual.ate),
      };
    }
    if (escopoTimeline === 'vida') {
      const lp = (dadosTimeline?.linhasPessoais && dadosTimeline.linhasPessoais[0]) || linhaPessoal;
      if (lp?.ano_nascimento != null) {
        const de = lp.ano_nascimento - 2;
        const ate =
          (lp.ano_falecimento ??
            (lp.is_vivo ? ANO_ATUAL : lp.ano_nascimento + 80)) + 2;
        return { anoDeTimeline: de, anoAteTimeline: ate };
      }
    }
    if (escopoTimeline === 'personalizado') {
      return { anoDeTimeline: anoDeCustom, anoAteTimeline: anoAteCustom };
    }
    if (dadosTimeline?.janelaAtual) {
      return {
        anoDeTimeline: Math.round(dadosTimeline.janelaAtual.de),
        anoAteTimeline: Math.round(dadosTimeline.janelaAtual.ate),
      };
    }
    return { anoDeTimeline: 1800, anoAteTimeline: ANO_ATUAL };
  }, [escopoTimeline, dadosTimeline, linhaPessoal, anoDeCustom, anoAteCustom]);

  const linhaIds = useMemo(() => linhasContexto.map((l) => l.id), [linhasContexto]);

  const { data: marcosTimeline = [] } = useQuery({
    queryKey: ['marcos-timeline-impressao', linhaIds, anoDeTimeline, anoAteTimeline],
    queryFn: () => buscarMarcos(linhaIds, anoDeTimeline, anoAteTimeline, false, 'detalhe'),
    enabled: aba === 'timeline' && !dadosTimeline && linhaIds.length > 0,
  });

  const dadosEfetivosTimeline: DadosImpressaoTimeline = useMemo(() => {
    if (dadosTimeline) {
      return dadosTimeline;
    }
    return {
      linhasPessoais: linhaPessoal ? [linhaPessoal] : [],
      linhasContexto,
      linhasAtivasIds: linhasContexto.map((l) => l.id),
      marcos: marcosTimeline,
      coresPersonalizadas: {},
      janelaAtual: { de: anoDeTimeline, ate: anoAteTimeline },
      regiaoImpressao: null,
      calendarioAtivo: 'gregoriano',
      arvoreTitulo: undefined,
    };
  }, [dadosTimeline, linhaPessoal, linhasContexto, marcosTimeline, anoDeTimeline, anoAteTimeline]);

  const opcoesAcademicas: OpcoesImpressaoAcademica = useMemo(
    () => ({
      numeroFigura,
      tituloFigura,
      fonteTexto,
      incluirQuadroMarcos,
      anosPorPagina: anosPorFaixa,
      anoDe: anoDeTimeline,
      anoAte: anoAteTimeline,
    }),
    [
      numeroFigura,
      tituloFigura,
      fonteTexto,
      incluirQuadroMarcos,
      anosPorFaixa,
      anoDeTimeline,
      anoAteTimeline,
    ],
  );

  // Paginação e divisão em páginas da Árvore
  const { paginasArvore, totalPaginasArvore } = useMemo(() => {
    if (!relatorio) return { paginasArvore: [], totalPaginasArvore: 1 };

    const pags: Array<{
      tipo: 'diagrama' | 'fichas';
      geracao?: number;
      entradas?: EntradaRelatorio[];
    }> = [];

    // Se tiver diagrama
    if (modo !== 'texto' && grafo) {
      pags.push({ tipo: 'diagrama' });
    }

    // Se tiver fichas textuais
    if (modo !== 'hierarquia') {
      const porGeracao = new Map<number, EntradaRelatorio[]>();
      for (const e of relatorio.entradas) {
        const lista = porGeracao.get(e.geracao) ?? [];
        lista.push(e);
        porGeracao.set(e.geracao, lista);
      }
      const geracoesOrdenadas = [...porGeracao.keys()].sort((a, b) => a - b);

      if (quebrarPorGeracao) {
        for (const g of geracoesOrdenadas) {
          const entradas = porGeracao.get(g) ?? [];
          // Divide em lotes de 6 fichas por folha para preencher a página A4 elegantemente
          for (let i = 0; i < entradas.length; i += 6) {
            pags.push({
              tipo: 'fichas',
              geracao: g,
              entradas: entradas.slice(i, i + 6),
            });
          }
        }
      } else {
        // Sem quebra por geração: lotes corridos de 6 por página
        const todas = relatorio.entradas;
        for (let i = 0; i < todas.length; i += 6) {
          pags.push({
            tipo: 'fichas',
            entradas: todas.slice(i, i + 6),
          });
        }
      }
    }

    const total = Math.max(1, pags.length);
    return { paginasArvore: pags, totalPaginasArvore: total };
  }, [relatorio, grafo, modo, quebrarPorGeracao]);

  // Paginação da Linha do Tempo Acadêmica (Pranchas A4 Paisagem)
  const totalPaginasTimeline = useMemo(() => {
    const span = Math.max(1, anoAteTimeline - anoDeTimeline);
    if (anosPorFaixa === 'auto' || span <= (typeof anosPorFaixa === 'number' ? anosPorFaixa : 40)) {
      return 1;
    }
    const faixa = typeof anosPorFaixa === 'number' ? anosPorFaixa : 40;
    return Math.ceil(span / faixa);
  }, [anoDeTimeline, anoAteTimeline, anosPorFaixa]);

  const totalPaginas = aba === 'arvore' ? totalPaginasArvore : totalPaginasTimeline;
  const paginaValida = Math.min(Math.max(1, paginaAtual), totalPaginas);

  const handlePrint = async () => {
    await executarComGatekeeper(t('seguranca', 'gatekeeperDescRelatorio'), () => {
      window.print();
    });
  };

  const tituloDocumento =
    aba === 'arvore'
      ? escopoArvore && raizId
        ? 'Árvore Genealógica'
        : 'Acervo Genealógico Completo'
      : `Linha do Tempo (${anoDeTimeline} a ${anoAteTimeline})`;

  return (
    <>
      {/* Modal na Tela (desaparece no @media print) */}
      <div className="fixed inset-0 z-50 flex items-center justify-center p-3 bg-black/60 backdrop-blur-xs print:hidden animate-in fade-in duration-150">
        <div className="absolute inset-0" onClick={onFechar} aria-hidden />

        <div className="relative w-full max-w-6xl h-[92vh] bg-card rounded-raio border border-borda shadow-sombra overflow-hidden flex flex-col">
          {/* Cabeçalho Superior da Central */}
          <header className="flex items-center justify-between px-4 py-2.5 border-b border-borda bg-card2 flex-none">
            <div className="flex items-center gap-2">
              <Printer className="w-5 h-5 text-acento" />
              <div>
                <h2 className="font-tit font-bold text-base text-tinta m-0 leading-tight">
                  {t('impressao', 'centralImpressao')}
                </h2>
                <p className="text-[11px] text-tinta3 m-0">
                  Visualização fidedigna de folha (WYSIWYG) · Salvável como PDF ou impressão direta
                </p>
              </div>
            </div>

            {/* Abas no Topo */}
            <div className="flex items-center gap-1 bg-sup p-1 rounded-raio-s border border-borda2">
              <button
                type="button"
                onClick={() => {
                  setAba('arvore');
                  setPaginaAtual(1);
                }}
                className={cn(
                  'px-3 py-1 rounded-raio-s text-xs font-semibold flex items-center gap-1.5 transition-colors cursor-pointer',
                  aba === 'arvore'
                    ? 'bg-card text-tinta shadow-2xs'
                    : 'text-tinta3 hover:text-tinta'
                )}
              >
                <IconeArvore className="w-3.5 h-3.5 text-acento" />
                <span>{t('impressao', 'abaArvoreRelatorio')}</span>
              </button>
              <button
                type="button"
                onClick={() => {
                  setAba('timeline');
                  setOrientacao('paisagem');
                  setPaginaAtual(1);
                }}
                className={cn(
                  'px-3 py-1 rounded-raio-s text-xs font-semibold flex items-center gap-1.5 transition-colors cursor-pointer',
                  aba === 'timeline'
                    ? 'bg-card text-tinta shadow-2xs'
                    : 'text-tinta3 hover:text-tinta'
                )}
              >
                <IconeLinhaTempo className="w-3.5 h-3.5 text-acento" />
                <span>{t('impressao', 'abaLinhaTempo')}</span>
              </button>
            </div>

            <button
              type="button"
              onClick={onFechar}
              aria-label="Fechar"
              className="text-tinta3 hover:text-tinta p-1 rounded-raio-s hover:bg-sup transition-colors cursor-pointer"
            >
              <X className="w-5 h-5" />
            </button>
          </header>

          {/* Corpo: Barra Lateral de Ajustes (Esquerda) + Preview da Folha (Direita) */}
          <div className="flex-1 flex min-h-0 overflow-hidden">
            {/* 1. Painel Lateral de Parâmetros de Impressão */}
            <aside className="w-80 flex-none border-r border-borda bg-sup p-4 flex flex-col gap-4 overflow-y-auto min-h-0 text-xs">
              {aba === 'arvore' ? (
                <>
                  {/* Modo de Impressão */}
                  <div className="flex flex-col gap-1.5">
                    <label className="font-bold text-tinta text-[11px] uppercase tracking-wider">
                      {t('impressao', 'modoImpressao')}
                    </label>
                    <select
                      value={modo}
                      onChange={(e) => {
                        setModo(e.target.value as ModoImpressao);
                        setPaginaAtual(1);
                      }}
                      className="w-full px-2.5 py-1.5 rounded-raio-s border border-borda2 bg-card text-tinta text-xs cursor-pointer font-medium"
                    >
                      <option value="combinado">{t('impressao', 'modoCombinado')}</option>
                      <option value="hierarquia">{t('impressao', 'modoHierarquia')}</option>
                      <option value="texto">{t('impressao', 'modoTexto')}</option>
                    </select>
                  </div>

                  {/* Escopo */}
                  <div className="flex flex-col gap-1.5">
                    <label className="font-bold text-tinta text-[11px] uppercase tracking-wider">
                      {t('impressao', 'escopo')}
                    </label>
                    <label className="flex items-center gap-2 cursor-pointer text-tinta">
                      <input
                        type="radio"
                        checked={escopoArvore}
                        onChange={() => setEscopoArvore(true)}
                        disabled={!raizId}
                        className="accent-acento"
                      />
                      <span>{t('impressao', 'arvoreAtiva')}</span>
                    </label>
                    <label className="flex items-center gap-2 cursor-pointer text-tinta">
                      <input
                        type="radio"
                        checked={!escopoArvore}
                        onChange={() => setEscopoArvore(false)}
                        className="accent-acento"
                      />
                      <span>{t('impressao', 'acervoCompleto')}</span>
                    </label>
                  </div>

                  {/* Opções de Conteúdo */}
                  <div className="flex flex-col gap-2 pt-2 border-t border-borda/60">
                    <label className="font-bold text-tinta text-[11px] uppercase tracking-wider">
                      {t('impressao', 'opcoesAdicionais')}
                    </label>
                    <label className="flex items-center gap-2 cursor-pointer text-tinta">
                      <input
                        type="checkbox"
                        checked={ocultarVivas}
                        onChange={(e) => setOcultarVivas(e.target.checked)}
                        className="accent-acento rounded"
                      />
                      <span>{t('impressao', 'ocultarPessoasVivas')}</span>
                    </label>
                    <label className="flex items-center gap-2 cursor-pointer text-tinta">
                      <input
                        type="checkbox"
                        checked={incluirMiniaturas}
                        onChange={(e) => setIncluirMiniaturas(e.target.checked)}
                        className="accent-acento rounded"
                      />
                      <span>{t('impressao', 'incluirMiniaturas')}</span>
                    </label>
                    <label className="flex items-center gap-2 cursor-pointer text-tinta">
                      <input
                        type="checkbox"
                        checked={quebrarPorGeracao}
                        onChange={(e) => {
                          setQuebrarPorGeracao(e.target.checked);
                          setPaginaAtual(1);
                        }}
                        className="accent-acento rounded"
                      />
                      <span>{t('impressao', 'quebrarPorGeracao')}</span>
                    </label>
                  </div>
                </>
              ) : (
                <>
                  {/* Recorte da Linha do Tempo */}
                  <div className="flex flex-col gap-1.5">
                    <label className="font-bold text-tinta text-[11px] uppercase tracking-wider">
                      {t('impressao', 'recorteTemporal')}
                    </label>
                    <select
                      value={escopoTimeline}
                      onChange={(e) => {
                        setEscopoTimeline(e.target.value as any);
                        setPaginaAtual(1);
                      }}
                      className="w-full px-2.5 py-1.5 rounded-raio-s border border-borda2 bg-card text-tinta text-xs cursor-pointer font-medium"
                    >
                      {dadosTimeline?.regiaoImpressao && (
                        <option value="recorte">
                          ✂ Recorte demarcado ({dadosTimeline.regiaoImpressao.de} a{' '}
                          {dadosTimeline.regiaoImpressao.ate})
                        </option>
                      )}
                      {((dadosTimeline?.linhasPessoais && dadosTimeline.linhasPessoais[0]) ||
                        linhaPessoal)?.ano_nascimento != null && (
                        <option value="vida">
                          Vida de {((dadosTimeline?.linhasPessoais && dadosTimeline.linhasPessoais[0]) ||
                            linhaPessoal)?.nome}
                        </option>
                      )}
                      <option value="janela">{t('impressao', 'janelaVisivel')}</option>
                      <option value="personalizado">{t('impressao', 'personalizado')}</option>
                    </select>
                  </div>

                  {escopoTimeline === 'personalizado' && (
                    <div className="grid grid-cols-2 gap-2">
                      <div>
                        <label className="block text-[10px] text-tinta3 mb-0.5">Ano Inicial</label>
                        <input
                          type="number"
                          value={anoDeCustom}
                          onChange={(e) => setAnoDeCustom(Number(e.target.value))}
                          className="w-full px-2 py-1 rounded-raio-s border border-borda2 bg-card text-tinta font-num text-xs"
                        />
                      </div>
                      <div>
                        <label className="block text-[10px] text-tinta3 mb-0.5">Ano Final</label>
                        <input
                          type="number"
                          value={anoAteCustom}
                          onChange={(e) => setAnoAteCustom(Number(e.target.value))}
                          className="w-full px-2 py-1 rounded-raio-s border border-borda2 bg-card text-tinta font-num text-xs"
                        />
                      </div>
                    </div>
                  )}

                  {/* Anos por Prancha A4 Paisagem */}
                  <div className="flex flex-col gap-1.5">
                    <label className="font-bold text-tinta text-[11px] uppercase tracking-wider">
                      Anos por Prancha A4 Paisagem
                    </label>
                    <select
                      value={anosPorFaixa}
                      onChange={(e) => {
                        const val = e.target.value;
                        setAnosPorFaixa(val === 'auto' ? 'auto' : Number(val));
                        setPaginaAtual(1);
                      }}
                      className="w-full px-2.5 py-1.5 rounded-raio-s border border-borda2 bg-card text-tinta text-xs cursor-pointer font-medium"
                    >
                      <option value="auto">Ajustar tudo em 1 folha (Automático)</option>
                      <option value={25}>25 anos por folha (Altíssimo detalhe)</option>
                      <option value={40}>40 anos por folha (Recomendado ABNT)</option>
                      <option value={50}>50 anos por folha</option>
                      <option value={75}>75 anos por folha</option>
                      <option value={100}>100 anos por folha (Visão macro panorâmica)</option>
                    </select>
                  </div>

                  {/* Parâmetros Acadêmicos ABNT (NBR 14724) */}
                  <div className="flex flex-col gap-2 pt-2 border-t border-borda/60">
                    <label className="font-bold text-tinta text-[11px] uppercase tracking-wider flex items-center gap-1">
                      <span>Identificação Acadêmica (ABNT)</span>
                    </label>
                    <div className="flex flex-col gap-1.5">
                      <div>
                        <label className="block text-[10px] text-tinta3 mb-0.5">Número da Figura</label>
                        <input
                          type="text"
                          value={numeroFigura}
                          onChange={(e) => setNumeroFigura(e.target.value)}
                          placeholder="Ex: 1, 2.1"
                          className="w-full px-2 py-1 rounded-raio-s border border-borda2 bg-card text-tinta text-xs"
                        />
                      </div>
                      <div>
                        <label className="block text-[10px] text-tinta3 mb-0.5">Título da Ilustração</label>
                        <input
                          type="text"
                          value={tituloFigura}
                          onChange={(e) => setTituloFigura(e.target.value)}
                          placeholder="Título descritivo da figura"
                          className="w-full px-2 py-1 rounded-raio-s border border-borda2 bg-card text-tinta text-xs"
                        />
                      </div>
                      <div>
                        <label className="block text-[10px] text-tinta3 mb-0.5">Nota de Fonte</label>
                        <input
                          type="text"
                          value={fonteTexto}
                          onChange={(e) => setFonteTexto(e.target.value)}
                          placeholder="Ex: Elaborado pelo autor..."
                          className="w-full px-2 py-1 rounded-raio-s border border-borda2 bg-card text-tinta text-xs"
                        />
                      </div>
                      <label className="flex items-center gap-2 text-xs text-tinta mt-1 cursor-pointer select-none">
                        <input
                          type="checkbox"
                          checked={incluirQuadroMarcos}
                          onChange={(e) => setIncluirQuadroMarcos(e.target.checked)}
                          className="accent-acento rounded"
                        />
                        <span>Quadro sinóptico de marcos e citações</span>
                      </label>
                    </div>
                  </div>

                  {/* Resumo das Trilhas Ativas */}
                  <div className="p-2.5 rounded-raio-s bg-sup border border-borda text-[11px] text-tinta2 flex flex-col gap-1">
                    <div className="font-semibold text-tinta flex items-center justify-between">
                      <span>Trilhas Habilitadas:</span>
                      <span className="font-num font-bold text-acento">
                        {dadosEfetivosTimeline.linhasPessoais.length} vidas ·{' '}
                        {dadosEfetivosTimeline.linhasAtivasIds.length} contexto
                      </span>
                    </div>
                    <p className="text-[10.5px] text-tinta3 leading-tight m-0">
                      Vidas comparadas, cores personalizadas e marcos ativos são diagramados fielmente na prancha.
                    </p>
                  </div>
                </>
              )}

              {/* Orientação da Folha */}
              <div className="flex flex-col gap-1.5 pt-2 border-t border-borda/60">
                <label className="font-bold text-tinta text-[11px] uppercase tracking-wider">
                  {t('impressao', 'orientacao')}
                </label>
                <div className="grid grid-cols-2 gap-2">
                  <button
                    type="button"
                    onClick={() => setOrientacao('retrato')}
                    className={cn(
                      'py-1.5 px-2 rounded-raio-s border text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors cursor-pointer',
                      orientacao === 'retrato'
                        ? 'border-acento bg-acento/10 text-tinta font-bold shadow-2xs'
                        : 'border-borda2 bg-card text-tinta3 hover:text-tinta'
                    )}
                  >
                    <span>{t('impressao', 'retrato')}</span>
                  </button>
                  <button
                    type="button"
                    onClick={() => setOrientacao('paisagem')}
                    className={cn(
                      'py-1.5 px-2 rounded-raio-s border text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors cursor-pointer',
                      orientacao === 'paisagem'
                        ? 'border-acento bg-acento/10 text-tinta font-bold shadow-2xs'
                        : 'border-borda2 bg-card text-tinta3 hover:text-tinta'
                    )}
                  >
                    <span>{t('impressao', 'paisagem')}</span>
                  </button>
                </div>
              </div>

              {/* Botão de Ação Primária no Rodapé da Barra Lateral */}
              <div className="mt-auto pt-4 flex flex-col gap-2 border-t border-borda">
                <Button
                  variant="primary"
                  size="md"
                  onClick={handlePrint}
                  className="w-full flex items-center justify-center gap-2 font-bold py-2.5 shadow-sm cursor-pointer"
                >
                  <Printer className="w-4 h-4" />
                  <span>{t('impressao', 'imprimirOuPdf')}</span>
                </Button>
                <p className="text-[10.5px] text-tinta3 text-center leading-relaxed m-0">
                  {t('impressao', 'dicaImpressao')}
                </p>
              </div>
            </aside>

            {/* 2. Área Central de Visualização Virtual da Folha (WYSIWYG Preview) */}
            <main className="flex-1 flex flex-col min-w-0 bg-[#353432] overflow-hidden relative">
              {/* Barra de Ferramentas Superior do Preview */}
              <div className="flex items-center justify-between px-4 py-2 bg-card/90 border-b border-borda text-xs flex-none">
                {/* Controles de Paginação */}
                <div className="flex items-center gap-2">
                  <button
                    type="button"
                    onClick={() => setPaginaAtual((p) => Math.max(1, p - 1))}
                    disabled={paginaValida <= 1}
                    className="p-1 rounded border border-borda bg-card text-tinta hover:bg-sup disabled:opacity-30 disabled:pointer-events-none cursor-pointer"
                    title={t('impressao', 'paginaAnterior')}
                  >
                    <ChevronLeft className="w-4 h-4" />
                  </button>
                  <span className="font-num font-semibold text-tinta text-xs select-none">
                    {t('impressao', 'paginaAtual')} {paginaValida} {t('impressao', 'paginaDe')}{' '}
                    {totalPaginas}
                  </span>
                  <button
                    type="button"
                    onClick={() => setPaginaAtual((p) => Math.min(totalPaginas, p + 1))}
                    disabled={paginaValida >= totalPaginas}
                    className="p-1 rounded border border-borda bg-card text-tinta hover:bg-sup disabled:opacity-30 disabled:pointer-events-none cursor-pointer"
                    title={t('impressao', 'proximaPagina')}
                  >
                    <ChevronRight className="w-4 h-4" />
                  </button>
                </div>

                {/* Controles de Zoom da Folha */}
                <div className="flex items-center gap-2">
                  <span className="text-[11px] text-tinta3">{t('impressao', 'zoomPreview')}:</span>
                  <button
                    type="button"
                    onClick={() => setZoomPreview((z) => Math.max(0.4, Number((z - 0.1).toFixed(2))))}
                    className="p-1 rounded border border-borda bg-card text-tinta hover:bg-sup cursor-pointer"
                    title="Diminuir zoom do preview"
                  >
                    <ZoomOut className="w-3.5 h-3.5" />
                  </button>
                  <span className="font-num font-semibold text-tinta text-xs w-12 text-center select-none">
                    {Math.round(zoomPreview * 100)}%
                  </span>
                  <button
                    type="button"
                    onClick={() => setZoomPreview((z) => Math.min(1.5, Number((z + 0.1).toFixed(2))))}
                    className="p-1 rounded border border-borda bg-card text-tinta hover:bg-sup cursor-pointer"
                    title="Aumentar zoom do preview"
                  >
                    <ZoomIn className="w-3.5 h-3.5" />
                  </button>
                  <button
                    type="button"
                    onClick={() => setZoomPreview(orientacao === 'paisagem' ? 0.65 : 0.8)}
                    className="px-2 py-1 text-[11px] rounded border border-borda bg-card text-tinta2 hover:text-tinta hover:bg-sup cursor-pointer"
                  >
                    {t('impressao', 'ajustarPreview')}
                  </button>
                </div>
              </div>

                    {/* Contêiner de Rolagem do Preview */}
                    <div className="flex-1 overflow-auto p-6 flex justify-center items-start min-h-0 select-none">
                      {aba === 'timeline' ? (
                        /* Prancha A4 Paisagem ABNT Fiel com Linha do Tempo Comparativa */
                        <div
                          className="shadow-2xl border border-neutral-400/80 transition-transform duration-100 flex flex-col relative bg-white"
                          style={{
                            transform: `scale(${zoomPreview})`,
                            transformOrigin: 'top center',
                          }}
                        >
                          <LinhaTempoAcademicPrintView
                            dados={dadosEfetivosTimeline}
                            opcoes={opcoesAcademicas}
                            paginaAtual={paginaValida}
                            modoPreview={true}
                          />
                        </div>
                      ) : (
                        /* A Folha de Papel Virtual para Relatórios e Diagramas da Árvore */
                        <div
                          className={cn(
                            'bg-white text-[#2f2a22] shadow-2xl border border-neutral-400/80 transition-transform duration-100 flex flex-col relative',
                            orientacao === 'retrato'
                              ? 'w-[794px] min-h-[1123px] max-w-[794px]'
                              : 'w-[1123px] min-h-[794px] max-w-[1123px]'
                          )}
                          style={{
                            transform: `scale(${zoomPreview})`,
                            transformOrigin: 'top center',
                          }}
                        >
                          {/* Margem e Conteúdo da Folha */}
                          <div className="p-10 flex-1 flex flex-col">
                            {/* Cabeçalho Fiel da Página Impressa */}
                            <div className="border-b-2 border-[#2f2a22] pb-3 mb-6 flex-none">
                              <div className="flex items-baseline justify-between">
                                <h1 className="text-2xl font-serif font-bold text-[#1c1917] m-0 tracking-tight">
                                  {tituloDocumento}
                                </h1>
                                <span className="text-xs font-sans text-stone-500">
                                  {new Date().toLocaleDateString('pt-BR')}
                                </span>
                              </div>
                              <p className="text-[11px] text-stone-600 m-0 mt-1 font-sans">
                                {relatorio?.total ?? 0} pessoas · Ordenação cronológica por geração
                              </p>
                            </div>

                            {/* Conteúdo Dinâmico da Página Selecionada */}
                            <div className="flex-1 flex flex-col">
                              {(() => {
                                const pag = paginasArvore[paginaValida - 1];
                                if (!pag) {
                                  return (
                                    <p className="text-sm italic text-stone-500 text-center py-12">
                                      Nenhuma informação neste recorte.
                                    </p>
                                  );
                                }

                                if (pag.tipo === 'diagrama' && grafo) {
                                  return (
                                    <div className="flex-1 flex flex-col items-center justify-center p-2 min-h-0 w-full overflow-hidden">
                                      <span className="text-xs font-bold uppercase tracking-wider text-stone-500 mb-2 flex-none">
                                        Mapa Genealógico ({grafo.nodes.length} pessoas)
                                      </span>
                                      <div className="w-full flex-1 border border-stone-200 rounded p-3 flex items-center justify-center bg-white shadow-2xs overflow-hidden">
                                        <DiagramaImpressao
                                          grafo={grafo}
                                          maxAltura="750px"
                                          className="w-full h-full flex items-center justify-center"
                                        />
                                      </div>
                                    </div>
                                  );
                                }

                                return (
                                  <div className="flex flex-col gap-4">
                                    {pag.geracao !== undefined && (
                                      <h2 className="text-sm font-bold uppercase tracking-wider text-stone-700 pb-1 border-b border-stone-300">
                                        Geração {pag.geracao + 1}
                                      </h2>
                                    )}
                                    <div className="flex flex-col gap-3">
                                      {pag.entradas?.map((e) => (
                                        <div
                                          key={e.id}
                                          className="p-3 border-b border-stone-200 flex items-start gap-3"
                                        >
                                          <div className="w-10 h-12 bg-stone-100 border border-stone-300 flex-none grid place-items-center text-[9px] text-stone-400">
                                            {e.foto_url ? 'Foto' : '—'}
                                          </div>
                                          <div className="flex-1 min-w-0 font-sans">
                                            <div className="flex items-baseline justify-between">
                                              <strong className="text-sm font-serif text-stone-900">
                                                {e.nome}
                                              </strong>
                                              <span className="text-[11px] font-mono text-stone-500">
                                                {(e.nascimento?.data_texto || e.ano_nascimento) ? (e.nascimento?.data_texto ?? e.ano_nascimento) : ''}
                                                {e.falecimento?.data_texto ? ` – ${e.falecimento.data_texto}` : e.is_vivo ? ' (vivo)' : ''}
                                              </span>
                                            </div>
                                            <div className="text-xs text-stone-600 mt-1 flex flex-col gap-0.5">
                                              {e.nascimento?.data_texto && (
                                                <div>
                                                  <strong>Nascimento:</strong> {e.nascimento.data_texto}
                                                  {e.nascimento.local ? ` · ${e.nascimento.local}` : ''}
                                                </div>
                                              )}
                                              {e.falecimento?.data_texto && (
                                                <div>
                                                  <strong>Falecimento:</strong> {e.falecimento.data_texto}
                                                  {e.falecimento.local ? ` · ${e.falecimento.local}` : ''}
                                                </div>
                                              )}
                                              {e.unioes.length > 0 && (
                                                <div className="text-[11px] text-stone-500 mt-0.5">
                                                  {e.unioes.map((u, ui) => (
                                                    <span key={ui}>
                                                      ⚭ com {u.conjuge}
                                                      {u.filhos.length > 0 && ` (filhos: ${u.filhos.join(', ')})`}
                                                    </span>
                                                  ))}
                                                </div>
                                              )}
                                            </div>
                                          </div>
                                        </div>
                                      ))}
                                    </div>
                                  </div>
                                );
                              })()}
                            </div>

                            {/* Rodapé Fiel da Página Impressa */}
                            <div className="border-t border-stone-300 pt-3 mt-6 flex items-center justify-between text-[10px] text-stone-500 font-sans flex-none">
                              <span>Software Árvore Genealógica</span>
                              <span>
                                Página {paginaValida} de {totalPaginas}
                              </span>
                            </div>
                          </div>
                        </div>
                      )}
                    </div>
                  </main>
                </div>
              </div>
            </div>

            {/* Componentes de Impressão Reais para o @media print montados via Portal */}
            {typeof document !== 'undefined' &&
              createPortal(
                <div id="print-container">
                  {/* Injeta estilo dinâmico de orientação da folha (Retrato vs Paisagem) */}
                  <style>
                    {`@page { size: ${orientacao === 'paisagem' ? 'A4 landscape' : 'A4 portrait'}; margin: 10mm; }`}
                  </style>

                  {aba === 'arvore' && (
                    <RelatorioView
                      relatorio={
                        relatorio ?? {
                          total: 0,
                          omitidas_vivas: 0,
                          entradas: [],
                        }
                      }
                      grafo={grafo ?? null}
                      opcoes={{ modo, incluirMiniaturas, quebrarPorGeracao }}
                      titulo={tituloDocumento}
                    />
                  )}

                  {aba === 'timeline' && (
                    <LinhaTempoAcademicPrintView
                      dados={dadosEfetivosTimeline}
                      opcoes={opcoesAcademicas}
                      modoPreview={false}
                    />
                  )}
                </div>,
                document.getElementById('print-portal-root') || document.body,
              )}
          </>
        );
      }
