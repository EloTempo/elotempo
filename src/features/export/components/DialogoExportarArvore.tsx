import { useGatekeeper } from '../../security';
import { useI18n } from '../../../i18n/I18nContext';
import { useState, useMemo } from 'react';
import { createPortal } from 'react-dom';
import {
  X,
  Download,
  Printer,
  Sparkles,
  Check,
  AlertCircle,
  FileImage,
  Layers,
  Palette,
  Eye,
} from 'lucide-react';
import { calcularLayout } from '../../../lib/tree/layout';
import {
  gerarSvgArvore,
  type TemaPoster,
  type ConfiguracaoPoster,
} from '../../../lib/tree/exportadorSvg';
import {
  escolherOndeSalvarGrafico,
  salvarArvorePng,
  salvarArvoreSvg,
  dispararDownloadNavegador,
  type EscalaPng,
} from '../../../lib/tree/exportadorPng';
import type { TreeGraph, PersonNode } from '../../../types';

interface DialogoExportarArvoreProps {
  aberto: boolean;
  onFechar: () => void;
  grafo: TreeGraph;
  unioesColapsadas?: Set<string>;
  nomeArvorePadrao?: string;
  raizPessoa?: PersonNode | null;
}

export function DialogoExportarArvore({

  aberto,
  onFechar,
  grafo,
  unioesColapsadas,
  nomeArvorePadrao,
  raizPessoa,
}: DialogoExportarArvoreProps) {
  const { t } = useI18n();
  const { executarComGatekeeper } = useGatekeeper();
  const [titulo, setTitulo] = useState(() => {
    if (nomeArvorePadrao && nomeArvorePadrao !== 'Minha Árvore') {
      return nomeArvorePadrao;
    }
    if (raizPessoa?.sobrenome) {
      return `Família ${raizPessoa.sobrenome}`;
    }
    return 'Árvore Genealógica Familiar';
  });

  const [subtitulo, setSubtitulo] = useState(() => {
    if (raizPessoa) {
      return `Linhagem de ${raizPessoa.nome} ${raizPessoa.sobrenome ?? ''} • Acervo Histórico`;
    }
    return 'Linhagem e Descendência Familiar';
  });

  const [tema, setTema] = useState<TemaPoster>('pergaminho');
  const [incluirDatas, setIncluirDatas] = useState(true);
  const [incluirCasamentos, setIncluirCasamentos] = useState(true);
  const [incluirMoldura, setIncluirMoldura] = useState(true);
  const [escalaPng, setEscalaPng] = useState<EscalaPng>(2);

  const [salvando, setSalvando] = useState(false);
  const [sucessoMsg, setSucessoMsg] = useState<string | null>(null);
  const [erroMsg, setErroMsg] = useState<string | null>(null);

  // Calcula o layout geométrico completo
  const layout = useMemo(() => {
    return calcularLayout(grafo, unioesColapsadas);
  }, [grafo, unioesColapsadas]);

  // Configuração atual do pôster
  const configPoster: ConfiguracaoPoster = useMemo(() => {
    return {
      titulo: titulo.trim(),
      subtitulo: subtitulo.trim() || undefined,
      tema,
      incluirDatas,
      incluirCasamentos,
      incluirMoldura,
    };
  }, [titulo, subtitulo, tema, incluirDatas, incluirCasamentos, incluirMoldura]);

  // Gera o SVG standalone
  const svgConteudo = useMemo(() => {
    return gerarSvgArvore(layout, configPoster);
  }, [layout, configPoster]);

  if (!aberto) return null;

  const nomeArquivoSugerido = (titulo.trim() || 'arvore-genealogica')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]/g, '-')
    .replace(/-+/g, '-')
    .replace(/^-|-$/g, '');

  const handleExportarPng = async () => {
    setErroMsg(null);
    setSucessoMsg(null);

    try {
      const caminho = await escolherOndeSalvarGrafico('png', nomeArquivoSugerido);
      if (!caminho) return;

      await executarComGatekeeper(t('seguranca', 'gatekeeperDescPoster'), async (ticket: string) => {
        setSalvando(true);
        try {
          await salvarArvorePng(caminho, svgConteudo, escalaPng, ticket);
          setSucessoMsg(`Imagem PNG exportada com sucesso em: ${caminho}`);
        } finally {
          setSalvando(false);
        }
      });
    } catch (err) {
      console.warn('Salvamento nativo falhou, tentando fallback navegador:', err);
      try {
        const svgBlob = new Blob([svgConteudo], { type: 'image/svg+xml;charset=utf-8' });
        dispararDownloadNavegador(svgBlob, `${nomeArquivoSugerido}.svg`, 'image/svg+xml');
        setSucessoMsg('Download do gráfico iniciado.');
      } catch (e2) {
        setErroMsg(err instanceof Error ? err.message : 'Erro ao exportar imagem PNG.');
      }
    }
  };

  const handleExportarSvg = async () => {
    setErroMsg(null);
    setSucessoMsg(null);

    try {
      const caminho = await escolherOndeSalvarGrafico('svg', nomeArquivoSugerido);
      if (!caminho) return;

      await executarComGatekeeper(t('seguranca', 'gatekeeperDescPoster'), async (ticket: string) => {
        setSalvando(true);
        try {
          await salvarArvoreSvg(caminho, svgConteudo, ticket);
          setSucessoMsg(`Vetor SVG exportado com sucesso em: ${caminho}`);
        } finally {
          setSalvando(false);
        }
      });
    } catch (err) {
      console.warn('Salvamento nativo falhou, tentando fallback navegador:', err);
      try {
        dispararDownloadNavegador(svgConteudo, `${nomeArquivoSugerido}.svg`, 'image/svg+xml');
        setSucessoMsg('Download do arquivo SVG iniciado.');
      } catch (e2) {
        setErroMsg(err instanceof Error ? err.message : 'Erro ao exportar vetor SVG.');
      }
    }
  };

  const handleImprimir = async () => {
    await executarComGatekeeper(t('seguranca', 'gatekeeperDescPoster'), () => {
      window.print();
    });
  };

  return (
    <>
      {/* Contêiner de impressão isolado no fluxo nativo do documento via portal */}
      {typeof document !== 'undefined' &&
        createPortal(
          <div id="print-container" className="p-0 m-0 bg-white">
            <style>{`@page { size: auto; margin: 10mm; }`}</style>
            <div
              dangerouslySetInnerHTML={{ __html: svgConteudo }}
              className="w-full flex items-center justify-center"
            />
          </div>,
          document.getElementById('print-portal-root') || document.body,
        )}

      {/* Modal na interface */}
      <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-in fade-in print:hidden">
        <div className="bg-card border border-borda rounded-raio shadow-sombra w-full max-w-4xl max-h-[92vh] flex flex-col overflow-hidden text-tinta">
          {/* Cabeçalho */}
          <div className="flex items-center justify-between px-6 py-4 border-b border-borda bg-sup/50">
            <div className="flex items-center gap-2.5">
              <div className="p-2 rounded-raio-s bg-acento/10 text-acento">
                <FileImage className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-base font-serif font-bold text-tinta">
                  Exportar Pôster da Árvore Genealógica
                </h2>
                <p className="text-xs text-tinta3">
                  Gere arquivos de alta resolução para impressão de quadros, banners familiares ou vetores SVG para gráficas.
                </p>
              </div>
            </div>
            <button
              type="button"
              onClick={onFechar}
              className="p-1.5 rounded-raio-s text-tinta3 hover:text-tinta hover:bg-sup transition-colors cursor-pointer"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Conteúdo com Grid Split: Controles à esquerda, Prévia à direita */}
          <div className="flex-1 overflow-y-auto p-6 grid grid-cols-1 md:grid-cols-[1.1fr,1.3fr] gap-6">
            {/* Coluna 1: Opções de Customização */}
            <div className="flex flex-col gap-4">
              {/* Título e Subtítulo */}
              <div className="flex flex-col gap-3 p-3.5 rounded-raio bg-sup/40 border border-borda">
                <label className="text-xs font-semibold text-tinta flex items-center gap-1.5">
                  <Sparkles className="w-3.5 h-3.5 text-acento" />
                  Identificação do Pôster
                </label>
                <div>
                  <span className="text-[11px] text-tinta3 block mb-1">Título Principal:</span>
                  <input
                    type="text"
                    value={titulo}
                    onChange={(e) => setTitulo(e.target.value)}
                    placeholder="Ex: Família Silva"
                    className="w-full px-3 py-1.5 text-xs bg-card border border-borda rounded-raio-s text-tinta focus:outline-none focus:ring-1 focus:ring-acento font-serif font-bold"
                  />
                </div>
                <div>
                  <span className="text-[11px] text-tinta3 block mb-1">Subtítulo / Descrição:</span>
                  <input
                    type="text"
                    value={subtitulo}
                    onChange={(e) => setSubtitulo(e.target.value)}
                    placeholder="Ex: Linhagem registrada no acervo..."
                    className="w-full px-3 py-1.5 text-xs bg-card border border-borda rounded-raio-s text-tinta focus:outline-none focus:ring-1 focus:ring-acento"
                  />
                </div>
              </div>

              {/* Tema de Cores */}
              <div className="flex flex-col gap-2.5 p-3.5 rounded-raio bg-sup/40 border border-borda">
                <label className="text-xs font-semibold text-tinta flex items-center gap-1.5">
                  <Palette className="w-3.5 h-3.5 text-acento" />
                  Tema Visual do Pôster
                </label>
                <div className="grid grid-cols-3 gap-2">
                  <button
                    type="button"
                    onClick={() => setTema('pergaminho')}
                    className={`p-2.5 rounded-raio-s border text-left flex flex-col gap-1 transition-all cursor-pointer ${
                      tema === 'pergaminho'
                        ? 'border-acento bg-acento/10 shadow-xs ring-1 ring-acento'
                        : 'border-borda bg-card hover:bg-sup'
                    }`}
                  >
                    <div className="w-full h-3 rounded-xs bg-[#f5efe3] border border-[#bfae8e]" />
                    <span className="text-xs font-bold text-tinta">Pergaminho</span>
                    <span className="text-[10px] text-tinta3">Tons sépia e papiro</span>
                  </button>

                  <button
                    type="button"
                    onClick={() => setTema('branco')}
                    className={`p-2.5 rounded-raio-s border text-left flex flex-col gap-1 transition-all cursor-pointer ${
                      tema === 'branco'
                        ? 'border-acento bg-acento/10 shadow-xs ring-1 ring-acento'
                        : 'border-borda bg-card hover:bg-sup'
                    }`}
                  >
                    <div className="w-full h-3 rounded-xs bg-white border border-gray-300" />
                    <span className="text-xs font-bold text-tinta">Gráfica</span>
                    <span className="text-[10px] text-tinta3">Branco econômico</span>
                  </button>

                  <button
                    type="button"
                    onClick={() => setTema('escuro')}
                    className={`p-2.5 rounded-raio-s border text-left flex flex-col gap-1 transition-all cursor-pointer ${
                      tema === 'escuro'
                        ? 'border-acento bg-acento/10 shadow-xs ring-1 ring-acento'
                        : 'border-borda bg-card hover:bg-sup'
                    }`}
                  >
                    <div className="w-full h-3 rounded-xs bg-[#181512] border border-[#443a2d]" />
                    <span className="text-xs font-bold text-tinta">Nobre Escuro</span>
                    <span className="text-[10px] text-tinta3">Grafite e ouro</span>
                  </button>
                </div>
              </div>

              {/* Elementos e Detalhes */}
              <div className="flex flex-col gap-2 p-3.5 rounded-raio bg-sup/40 border border-borda text-xs">
                <label className="font-semibold text-tinta flex items-center gap-1.5 mb-1">
                  <Layers className="w-3.5 h-3.5 text-acento" />
                  Elementos e Detalhes
                </label>
                <label className="flex items-center gap-2 cursor-pointer text-tinta2 hover:text-tinta">
                  <input
                    type="checkbox"
                    checked={incluirDatas}
                    onChange={(e) => setIncluirDatas(e.target.checked)}
                    className="rounded text-acento focus:ring-acento"
                  />
                  <span>Incluir anos de nascimento e falecimento</span>
                </label>
                <label className="flex items-center gap-2 cursor-pointer text-tinta2 hover:text-tinta">
                  <input
                    type="checkbox"
                    checked={incluirCasamentos}
                    onChange={(e) => setIncluirCasamentos(e.target.checked)}
                    className="rounded text-acento focus:ring-acento"
                  />
                  <span>Incluir anos de casamento sobre os anéis</span>
                </label>
                <label className="flex items-center gap-2 cursor-pointer text-tinta2 hover:text-tinta">
                  <input
                    type="checkbox"
                    checked={incluirMoldura}
                    onChange={(e) => setIncluirMoldura(e.target.checked)}
                    className="rounded text-acento focus:ring-acento"
                  />
                  <span>Moldura decorativa com cantoneiras artísticas</span>
                </label>
              </div>

              {/* Resolução para PNG */}
              <div className="flex items-center justify-between p-3 rounded-raio bg-sup/40 border border-borda text-xs">
                <span className="font-semibold text-tinta">Resolução PNG:</span>
                <div className="flex items-center gap-1 bg-card rounded p-0.5 border border-borda">
                  <button
                    type="button"
                    onClick={() => setEscalaPng(1)}
                    className={`px-2 py-1 rounded text-xs font-semibold cursor-pointer ${
                      escalaPng === 1 ? 'bg-acento text-acento-tinta' : 'text-tinta2 hover:text-tinta'
                    }`}
                    title="1x - Padrão de Tela"
                  >
                    1x
                  </button>
                  <button
                    type="button"
                    onClick={() => setEscalaPng(2)}
                    className={`px-2 py-1 rounded text-xs font-semibold cursor-pointer ${
                      escalaPng === 2 ? 'bg-acento text-acento-tinta' : 'text-tinta2 hover:text-tinta'
                    }`}
                    title="2x - Alta Definição (Recomendado)"
                  >
                    2x (HD)
                  </button>
                  <button
                    type="button"
                    onClick={() => setEscalaPng(3)}
                    className={`px-2 py-1 rounded text-xs font-semibold cursor-pointer ${
                      escalaPng === 3 ? 'bg-acento text-acento-tinta' : 'text-tinta2 hover:text-tinta'
                    }`}
                    title="3x - Qualidade Pôster (300 DPI para Gráfica)"
                  >
                    3x (300 DPI)
                  </button>
                </div>
              </div>
            </div>

            {/* Coluna 2: Pré-visualização do Pôster */}
            <div className="flex flex-col gap-2.5">
              <div className="flex items-center justify-between">
                <span className="text-xs font-semibold text-tinta2 flex items-center gap-1.5">
                  <Eye className="w-3.5 h-3.5 text-acento" />
                  Prévia em Tempo Real
                </span>
                <span className="text-[11px] text-tinta3">
                  {layout.pessoas.length} {layout.pessoas.length === 1 ? 'pessoa' : 'pessoas'} no gráfico
                </span>
              </div>

              {/* Quadro de Prévia com Proporção Adequada */}
              <div
                className={`w-full h-80 md:h-full rounded-raio border border-borda overflow-hidden flex items-center justify-center p-3 shadow-inner ${
                  tema === 'escuro' ? 'bg-[#12100d]' : tema === 'branco' ? 'bg-gray-100' : 'bg-[#ece4d6]'
                }`}
              >
                <div
                  className="w-full h-full flex items-center justify-center overflow-hidden"
                  dangerouslySetInnerHTML={{ __html: svgConteudo }}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                  }}
                />
              </div>
            </div>
          </div>

          {/* Mensagens de Sucesso ou Erro */}
          {sucessoMsg && (
            <div className="mx-6 p-3 rounded-raio-s bg-emerald-500/10 border border-emerald-500/30 text-emerald-700 dark:text-emerald-400 text-xs flex items-center gap-2">
              <Check className="w-4 h-4 flex-none" />
              <span>{sucessoMsg}</span>
            </div>
          )}

          {erroMsg && (
            <div className="mx-6 p-3 rounded-raio-s bg-erro/10 border border-erro/30 text-erro text-xs flex items-center gap-2">
              <AlertCircle className="w-4 h-4 flex-none" />
              <span>{erroMsg}</span>
            </div>
          )}

          {/* Rodapé com Botões de Ação */}
          <div className="px-6 py-4 border-t border-borda bg-sup/30 flex flex-wrap items-center justify-between gap-3">
            <button
              type="button"
              onClick={onFechar}
              className="px-4 py-2 rounded-raio-s bg-sup hover:bg-card border border-borda text-xs font-semibold text-tinta transition-colors cursor-pointer"
            >
              Fechar
            </button>

            <div className="flex items-center gap-2.5 flex-wrap">
              <button
                type="button"
                onClick={handleImprimir}
                className="px-3.5 py-2 rounded-raio-s border border-borda bg-card hover:bg-sup text-xs font-semibold text-tinta flex items-center gap-1.5 transition-colors cursor-pointer shadow-xs"
                title="Imprimir pôster em página inteira ou salvar como PDF"
              >
                <Printer className="w-4 h-4 text-tinta2" />
                <span>Imprimir / PDF</span>
              </button>

              <button
                type="button"
                onClick={handleExportarSvg}
                disabled={salvando}
                className="px-3.5 py-2 rounded-raio-s border border-borda bg-card hover:bg-sup text-xs font-semibold text-tinta flex items-center gap-1.5 transition-colors cursor-pointer disabled:opacity-50 shadow-xs"
                title="Exportar como vetor SVG para Illustrator, Inkscape ou plotters"
              >
                <Download className="w-4 h-4 text-tinta2" />
                <span>Exportar SVG</span>
              </button>

              <button
                type="button"
                onClick={handleExportarPng}
                disabled={salvando}
                className="px-4 py-2 rounded-raio-s bg-acento hover:bg-acento/90 text-acento-tinta text-xs font-semibold flex items-center gap-1.5 transition-colors cursor-pointer disabled:opacity-50 shadow-xs"
                title={`Exportar como imagem PNG em alta resolução (${escalaPng}x)`}
              >
                <FileImage className="w-4 h-4" />
                <span>{salvando ? 'Gerando Imagem...' : `Exportar PNG (${escalaPng}x)`}</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
