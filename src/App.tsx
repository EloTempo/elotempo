/**
 * Casca do aplicativo.
 *
 * Antes esta tela renderizava um `mockTree` fixo com Machado de Assis e não
 * tocava no banco. Agora lê o acervo de verdade: escolhe uma raiz, monta o
 * grafo pelo Rust e desenha com o layout vertical.
 *
 * O que ainda não está ligado (editor de união, detalhes, relatórios, linhas
 * do tempo) segue como protótipo visual em `src/features/` — ver CLAUDE.md.
 */

import { useEffect, useState } from 'react';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import {
  ArrowUpDown,
  BarChart3,
  FileDown,
  FileImage,
  FileUp,
  FolderOpen,
  Globe,
  History,
  Info,
  Plus,
  Printer,
  RotateCcw,
  RotateCw,
  Sparkles,
  Users,
  Wrench,
  Shield,
  ShieldCheck,
} from 'lucide-react';
import { IconeArvore, IconeLinhaTempo, IconeRelacoes, IconeAplicativo } from './components/icons';
import { Button } from './components/ui/Button';
import { DropdownMenu } from './components/ui/DropdownMenu';
import { Modal } from './components/ui/Modal';
import { ModalSobre } from './components/ui/ModalSobre';
import { SplashScreen } from './components/welcome/SplashScreen';
import { TelaCarregamentoSims } from './components/welcome/TelaCarregamentoSims';
import { TreeCanvas } from './components/tree/TreeCanvas';
import { PersonForm } from './features/person/components/PersonForm';
import { PersonDetails } from './features/person/components/PersonDetails';
import { PainelConexoes } from './features/union/components/PainelConexoes';
import { PainelBusca } from './features/search/components/PainelBusca';
import { CentralImpressaoModal } from './features/reports/components/CentralImpressaoModal';
import { DialogoExportar } from './features/export/components/DialogoExportar';
import { DialogoExportarArvore } from './features/export/components/DialogoExportarArvore';
import { DialogoImportar } from './features/import/components/DialogoImportar';
import { DialogoEstatisticas } from './features/statistics/components/DialogoEstatisticas';
import { SeletorDeArvore } from './features/trees/components/SeletorDeArvore';
import { ModalAhnentafel } from './features/trees/components/ModalAhnentafel';
import { ModalHistoricoAcoes } from './features/history/components/ModalHistoricoAcoes';
import { ModalCalculadoraParentesco } from './features/kinship/components/ModalCalculadoraParentesco';
import { ModalFusaoPessoas } from './features/person/components/ModalFusaoPessoas';
import { useHistorico } from './contexts/HistoricoContext';
import { useI18n } from './i18n/I18nContext';
import { type ModoVisaoArvore } from './components/tree/BarraControlesArvore';
import { GavetaLinhaTempo } from './features/timeline/components/GavetaLinhaTempo';
import type { DadosImpressaoTimeline } from './features/timeline/tiposImpressao';
import { useCriarPessoa, usePessoas } from './features/person/hooks/usePessoas';
import { buscarGrafoArvore, definirRaizArvore, type ArvoreInfo } from './lib/api';
import { useSeguranca, useGatekeeper, TelaDesbloqueio, ModalGerenciarSeguranca } from './features/security';

type Tema = 'classico-claro' | 'classico-escuro' | 'moderno-claro' | 'moderno-escuro';

const TEMAS: Array<{ id: Tema; rotulo: string }> = [
  { id: 'classico-claro', rotulo: 'Clássico claro' },
  { id: 'classico-escuro', rotulo: 'Clássico escuro' },
  { id: 'moderno-claro', rotulo: 'Moderno claro' },
  { id: 'moderno-escuro', rotulo: 'Moderno escuro' },
];

/** Lê o tema salvo. Falha em silêncio: tema é conforto, não dado do acervo. */
function temaInicial(): Tema {
  try {
    const salvo = localStorage.getItem('tema');
    if (salvo && TEMAS.some((t) => t.id === salvo)) return salvo as Tema;
  } catch {
    /* modo privado ou storage bloqueado */
  }
  return 'classico-claro';
}

export default function App() {
  const { status: statusSeguranca } = useSeguranca();
  const { executarComGatekeeper } = useGatekeeper();
  const [segurancaAberta, setSegurancaAberta] = useState(false);
  const qc = useQueryClient();
  const { idioma, setIdioma, t } = useI18n();

  const [tema, setTema] = useState<Tema>(temaInicial);
  // Consulta sem filtro, só para decidir a raiz inicial e detectar acervo
  // vazio. A busca de verdade mora no PainelBusca, com estado próprio.
  const termoBusca = '';
  const [raizId, setRaizId] = useState<string | null>(null);
  const [selecionadaId, setSelecionadaId] = useState<string | null>(null);
  const [formAberto, setFormAberto] = useState(false);
  const [fichaAberta, setFichaAberta] = useState<string | null>(null);
  const [centralImpressaoAberta, setCentralImpressaoAberta] = useState(false);
  const [abaImpressaoInicial, setAbaImpressaoInicial] = useState<'arvore' | 'timeline'>('arvore');
  const [dadosImpressaoTimeline, setDadosImpressaoTimeline] = useState<DadosImpressaoTimeline | null>(null);
  const [exportarAberto, setExportarAberto] = useState(false);
  const [exportarPosterAberto, setExportarPosterAberto] = useState(false);
  const [importarAberto, setImportarAberto] = useState(false);
  const [estatisticasAbertas, setEstatisticasAbertas] = useState(false);
  const [fusaoAberta, setFusaoAberta] = useState(false);
  const [pessoaInicialFusao, setPessoaInicialFusao] = useState<string | null>(null);
  const [sobreAberto, setSobreAberto] = useState(false);
  const [splashAberta, setSplashAberta] = useState<boolean>(() => {
    try {
      return localStorage.getItem('elotempo-mostrar-splash') !== 'false';
    } catch {
      return true;
    }
  });
  const [carregandoBoot, setCarregandoBoot] = useState(true);
  const [timelineAberta, setTimelineAberta] = useState<boolean>(() => {
    try {
      return localStorage.getItem('timeline-aberta') !== 'false';
    } catch {
      return true;
    }
  });
  const [arvoreAtivaId, setArvoreAtivaId] = useState<string | null>(null);

  // Garante que o aplicativo sempre inicie com a mesa limpa e trilhas da linha do tempo vazias no menor tamanho
  useEffect(() => {
    try {
      localStorage.removeItem('arvore-ativa-id');
      localStorage.removeItem('timeline-ativas');
      localStorage.removeItem('timeline-vidas-extras');
      localStorage.removeItem('timeline-alturas-individuais');
      localStorage.removeItem('timeline-altura-secao-contexto');
      localStorage.removeItem('timeline-modo-altura');
      localStorage.removeItem('timeline-altura-trilha');
      Object.keys(localStorage).forEach((key) => {
        if (key.startsWith('timeline-')) {
          localStorage.removeItem(key);
        }
      });
    } catch {}
  }, []);

  const handleSelecionarArvore = (arvore: ArvoreInfo | null) => {
    if (!arvore) {
      setArvoreAtivaId(null);
      setRaizId(null);
      setSelecionadaId(null);
      try {
        localStorage.removeItem('arvore-ativa-id');
      } catch {}
      return;
    }
    setArvoreAtivaId(arvore.id);
    try {
      localStorage.setItem('arvore-ativa-id', arvore.id);
    } catch {}
    if (arvore.raiz_pessoa_id) {
      setRaizId(arvore.raiz_pessoa_id);
      setSelecionadaId(arvore.raiz_pessoa_id);
    }
  };

  // Vem da linha do tempo: quem estava vivo no marco clicado. `null` = sem
  // destaque ativo, que é diferente de lista vazia.
  const [destacadosIds, setDestacadosIds] = useState<string[] | null>(null);

  // Visões auxiliares, profundidade e colapso de ramos (Fatia 13)
  const [modoVisao, setModoVisao] = useState<ModoVisaoArvore>('completa');
  const [geracoes, setGeracoes] = useState<number>(4);
  const [unioesColapsadas, setUnioesColapsadas] = useState<Set<string>>(new Set());
  const [ahnentafelAberto, setAhnentafelAberto] = useState<boolean>(false);
  const [historicoAberto, setHistoricoAberto] = useState<boolean>(false);
  const [parentescoAberto, setParentescoAberto] = useState<boolean>(false);
  const [pessoaInicialParentesco, setPessoaInicialParentesco] = useState<string | null>(null);

  // Controle de acessibilidade: Escala global de fonte (85% a 130%)
  const ESCALAS_FONTE = [0.85, 0.92, 1, 1.08, 1.18, 1.3];
  const [escalaFonte, setEscalaFonte] = useState<number>(() => {
    try {
      const salva = Number(localStorage.getItem('escala-fonte'));
      return ESCALAS_FONTE.includes(salva) ? salva : 1;
    } catch {
      return 1;
    }
  });

  const aumentarEscalaFonte = () => {
    setEscalaFonte((atual) => {
      const idx = ESCALAS_FONTE.findIndex((e) => Math.abs(e - atual) < 0.02);
      return idx >= 0 && idx < ESCALAS_FONTE.length - 1 ? ESCALAS_FONTE[idx + 1] : atual;
    });
  };

  const diminuirEscalaFonte = () => {
    setEscalaFonte((atual) => {
      const idx = ESCALAS_FONTE.findIndex((e) => Math.abs(e - atual) < 0.02);
      return idx > 0 ? ESCALAS_FONTE[idx - 1] : atual;
    });
  };

  useEffect(() => {
    document.documentElement.style.fontSize = `${Math.round(escalaFonte * 100)}%`;
    try {
      localStorage.setItem('escala-fonte', String(escalaFonte));
    } catch {}
  }, [escalaFonte]);

  const {
    desfazer,
    refazer,
    podeDesfazer,
    podeRefazer,
    proximoDesfazer,
    proximoRefazer,
  } = useHistorico();

  const handleToggleColapsarUniao = (uniaoId: string) => {
    setUnioesColapsadas((prev) => {
      const next = new Set(prev);
      if (next.has(uniaoId)) {
        next.delete(uniaoId);
      } else {
        next.add(uniaoId);
      }
      return next;
    });
  };

  const { data: pessoas, isLoading: carregandoPessoas, error: erroPessoas } = usePessoas(termoBusca);
  const criar = useCriarPessoa();

  // O tema tem de ir no <html>: as variáveis de cor são declaradas em
  // `:root[data-tema="…"]` (globals.css). Posto numa div, o seletor nunca
  // casava e o seletor de temas não mudava nada — os quatro temas existiam no
  // CSS mas só o clássico claro chegava à tela.
  useEffect(() => {
    document.documentElement.dataset.tema = tema;
    try {
      localStorage.setItem('tema', tema);
    } catch {
      /* sem persistência é aceitável; o tema volta ao padrão na próxima abertura */
    }
  }, [tema]);

  const geracoesAcima = modoVisao === 'descendentes' ? 0 : geracoes;
  const geracoesAbaixo = modoVisao === 'ancestrais' ? 0 : geracoes;

  const {
    data: grafo,
    isLoading: carregandoArvore,
    error: erroArvore,
  } = useQuery({
    queryKey: ['arvore', raizId, geracoesAcima, geracoesAbaixo],
    queryFn: () => (raizId ? buscarGrafoArvore(raizId, geracoesAcima, geracoesAbaixo) : null),
    enabled: !!raizId,
  });

  // Só é "vazio" quando a consulta deu certo e não achou ninguém. Sem o teste
  // de erro, uma falha ao ler o acervo apareceria como a tela de boas-vindas —
  // e o usuário concluiria que perdeu os dados.
  const acervoVazio =
    !carregandoPessoas && !erroPessoas && (pessoas?.length ?? 0) === 0 && !termoBusca;


  // Atalhos de Teclado Globais (Ctrl+F, Ctrl+N, Ctrl+P, Ctrl+T, Ctrl+L, F1)
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      const tag = (e.target as HTMLElement)?.tagName?.toLowerCase();
      const isInput =
        tag === 'input' ||
        tag === 'textarea' ||
        tag === 'select' ||
        (e.target as HTMLElement)?.isContentEditable;

      const isCtrlOrCmd = e.ctrlKey || e.metaKey;

      if (isCtrlOrCmd && e.key.toLowerCase() === 'f') {
        e.preventDefault();
        const campoBusca = document.getElementById('campo-busca-pessoas') as HTMLInputElement | null;
        if (campoBusca) {
          campoBusca.focus();
          campoBusca.select();
        }
        return;
      }

      if (isCtrlOrCmd && e.key.toLowerCase() === 'n') {
        if (!isInput) {
          e.preventDefault();
          setFormAberto(true);
        }
        return;
      }

      if (isCtrlOrCmd && e.key.toLowerCase() === 't') {
        if (!isInput) {
          e.preventDefault();
          setTimelineAberta((prev) => !prev);
        }
        return;
      }

      if (isCtrlOrCmd && e.key.toLowerCase() === 'p') {
        e.preventDefault();
        executarComGatekeeper(t('seguranca', 'gatekeeperDescRelatorio'), () => {
          setAbaImpressaoInicial('arvore');
          setCentralImpressaoAberta(true);
        });
        return;
      }

      if (isCtrlOrCmd && e.key.toLowerCase() === 'l') {
        if (statusSeguranca?.modo_blindado && !statusSeguranca?.bloqueado) {
          e.preventDefault();
          setSegurancaAberta(true);
        }
        return;
      }

      if (e.key === 'F1') {
        e.preventDefault();
        setSobreAberto(true);
        return;
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [executarComGatekeeper, statusSeguranca, t]);

  return (
    <div className="h-screen flex flex-col bg-mesa text-tinta font-corpo">
      {/* Barra superior */}
      <header className="flex items-center gap-2 px-3.5 py-2 bg-sup border-b border-borda flex-none select-none">
        {/* Bloco 1: Identidade do Aplicativo e Árvore Ativa */}
        <div className="flex items-center gap-2.5 flex-none">
          {/* A marca oficial do programa */}
          <IconeAplicativo size={22} className="rounded-md shadow-2xs flex-none" />
          <h1 className="font-marca font-normal text-[17.5px] tracking-[-0.02em] m-0 flex-none select-none text-tinta">
            {t('topo', 'tituloApp')}
          </h1>

          {/* Seletor de Árvore Ativa */}
          <SeletorDeArvore
            arvoreAtivaId={arvoreAtivaId}
            onSelecionarArvore={handleSelecionarArvore}
          />

          {/* Ilha de Desfazer / Refazer / Histórico */}
          <div className="flex items-center gap-0.5 border-l border-borda/60 pl-2 ml-0.5">
            <button
              type="button"
              onClick={desfazer}
              disabled={!podeDesfazer}
              title={proximoDesfazer ? `${t('topo', 'desfazer')}: ${proximoDesfazer} (Ctrl+Z)` : `${t('topo', 'desfazer')} (Ctrl+Z)`}
              aria-label={t('topo', 'desfazer')}
              className="p-1.5 rounded-raio-s border border-borda bg-card hover:bg-sup disabled:opacity-35 disabled:pointer-events-none text-tinta2 hover:text-tinta transition-colors cursor-pointer flex items-center justify-center"
            >
              <RotateCcw className="w-3.5 h-3.5" />
            </button>
            <button
              type="button"
              onClick={refazer}
              disabled={!podeRefazer}
              title={proximoRefazer ? `${t('topo', 'refazer')}: ${proximoRefazer} (Ctrl+Y)` : `${t('topo', 'refazer')} (Ctrl+Y)`}
              aria-label={t('topo', 'refazer')}
              className="p-1.5 rounded-raio-s border border-borda bg-card hover:bg-sup disabled:opacity-35 disabled:pointer-events-none text-tinta2 hover:text-tinta transition-colors cursor-pointer flex items-center justify-center"
            >
              <RotateCw className="w-3.5 h-3.5" />
            </button>
            <button
              type="button"
              onClick={() => setHistoricoAberto(true)}
              title={t('topo', 'historicoAcoes')}
              aria-label={t('topo', 'historicoAcoes')}
              className="p-1.5 rounded-raio-s border border-borda bg-card hover:bg-sup text-tinta2 hover:text-tinta transition-colors cursor-pointer flex items-center justify-center"
            >
              <History className="w-3.5 h-3.5" />
            </button>
          </div>
        </div>

        {/* Separador vertical sutil */}
        <div className="h-5 w-px bg-borda/70 mx-1 flex-none" />

        {/* Bloco 2: Ações Principais de Genealogia e Linhas do Tempo */}
        <div className="flex items-center gap-2 flex-none">
          {/* Botão de Destaque da Linha do Tempo */}
          <Button
            size="sm"
            variant={timelineAberta ? 'primary' : 'secondary'}
            onClick={() => setTimelineAberta((prev) => !prev)}
            title={timelineAberta ? `${t('linhaTempo', 'recolherGaveta')} (Ctrl+T)` : `${t('linhaTempo', 'expandirGaveta')} (Ctrl+T)`}
            className={timelineAberta ? 'shadow-xs font-semibold' : ''}
          >
            <IconeLinhaTempo className="w-4 h-4 mr-1.5 text-acento" />
            {t('linhaTempo', 'titulo')}
          </Button>

          {/* Menu Dropdown de Análise e Ferramentas Genealógicas */}
          <DropdownMenu
            rotulo={t('topo', 'ferramentas')}
            icone={<Wrench className="w-3.5 h-3.5 text-acento" />}
            items={[
              {
                id: 'parentesco',
                rotulo: t('topo', 'parentesco'),
                descricao: t('topo', 'parentescoDesc'),
                icone: <IconeRelacoes className="w-4 h-4 text-acento" />,
                onClick: () => {
                  setPessoaInicialParentesco(selecionadaId ?? raizId);
                  setParentescoAberto(true);
                },
                separadorApos: true,
              },
              {
                id: 'estatisticas',
                rotulo: t('topo', 'estatisticas'),
                descricao: 'Demografia, faixas etárias, expectativa de vida e gráficos familiares',
                icone: <BarChart3 className="w-4 h-4 text-acento" />,
                onClick: () => setEstatisticasAbertas(true),
                separadorApos: true,
              },
              {
                id: 'fusao',
                rotulo: t('topo', 'mesclarPessoas'),
                descricao: 'Detectar duplicatas ou fundir dois registros no acervo',
                icone: <Users className="w-4 h-4 text-acento" />,
                onClick: () => {
                  setPessoaInicialFusao(selecionadaId ?? raizId);
                  setFusaoAberta(true);
                },
              },
            ]}
            title={t('topo', 'ferramentas')}
          />

          {/* Menu Unificado GEDCOM (Importar / Exportar) */}
          <DropdownMenu
            rotulo={t('topo', 'dadosGedcom')}
            icone={<ArrowUpDown className="w-3.5 h-3.5 text-acento" />}
            items={[
              {
                id: 'importar',
                rotulo: t('topo', 'importarGedcom'),
                descricao: t('topo', 'importarGedcomDesc'),
                icone: <FileUp className="w-4 h-4 text-acento" />,
                onClick: () => setImportarAberto(true),
                separadorApos: true,
              },
              {
                id: 'exportar',
                rotulo: t('topo', 'exportarGedcom'),
                descricao: t('topo', 'exportarGedcomDesc'),
                icone: <FileDown className="w-4 h-4 text-acento" />,
                onClick: () => setExportarAberto(true),
              },
            ]}
            title={t('topo', 'dadosGedcom')}
          />

          {/* Menu Unificado de Impressão e Pôsteres */}
          <DropdownMenu
            rotulo={t('topo', 'imprimirMenu')}
            icone={<Printer className="w-3.5 h-3.5 text-acento" />}
            items={[
              {
                id: 'imprimir-arvore',
                rotulo: t('topo', 'imprimirArvore'),
                descricao: t('topo', 'imprimirArvoreDesc'),
                icone: <IconeArvore className="w-4 h-4 text-acento" />,
                onClick: () => {
                  executarComGatekeeper(t('seguranca', 'gatekeeperDescRelatorio'), () => {
                    setAbaImpressaoInicial('arvore');
                    setCentralImpressaoAberta(true);
                  });
                },
                separadorApos: true,
              },
              {
                id: 'imprimir-linha-tempo',
                rotulo: t('topo', 'imprimirLinhaTempo'),
                descricao: t('topo', 'imprimirLinhaTempoDesc'),
                icone: <IconeLinhaTempo className="w-4 h-4 text-acento" />,
                onClick: () => {
                  executarComGatekeeper(t('seguranca', 'gatekeeperDescRelatorio'), () => {
                    setAbaImpressaoInicial('timeline');
                    setCentralImpressaoAberta(true);
                  });
                },
                separadorApos: true,
              },
              {
                id: 'poster-arvore',
                rotulo: t('topo', 'posterArvore'),
                descricao: t('topo', 'posterArvoreDesc'),
                icone: <FileImage className="w-4 h-4 text-acento" />,
                onClick: () => setExportarPosterAberto(true),
              },
            ]}
            title={t('topo', 'imprimirMenu')}
          />

          {/* Botão de Ação Principal: Cadastrar Nova Pessoa */}
          <Button
            size="sm"
            onClick={() => setFormAberto(true)}
            title="Cadastrar uma nova pessoa no acervo (Ctrl+N)"
            className="shadow-xs font-semibold"
          >
            <Plus className="w-4 h-4 mr-1" />
            {t('topo', 'novaPessoa')}
          </Button>
        </div>

        {/* Bloco 3: Alinhado à Direita (Preferências, Acessibilidade e Segurança) */}
        <div className="ml-auto flex items-center gap-2 flex-none">
          {/* Controle global de acessibilidade de fonte */}
          <div
            className="flex items-center gap-0.5 px-1 py-0.5 rounded-raio-s border border-borda2 bg-card text-xs shadow-xs"
            title={t('topo', 'tamanhoFonte')}
          >
            <button
              type="button"
              onClick={diminuirEscalaFonte}
              disabled={escalaFonte <= ESCALAS_FONTE[0]}
              className="px-1.5 py-0.5 text-xs text-tinta2 hover:text-tinta hover:bg-sup rounded cursor-pointer disabled:opacity-30 font-num"
              title={t('topo', 'diminuirFonte')}
            >
              A−
            </button>
            <span className="text-[11px] font-num text-tinta3 px-0.5 select-none font-semibold">
              {Math.round(escalaFonte * 100)}%
            </span>
            <button
              type="button"
              onClick={aumentarEscalaFonte}
              disabled={escalaFonte >= ESCALAS_FONTE[ESCALAS_FONTE.length - 1]}
              className="px-1.5 py-0.5 text-xs text-tinta2 hover:text-tinta hover:bg-sup rounded cursor-pointer disabled:opacity-30 font-num font-bold"
              title={t('topo', 'aumentarFonte')}
            >
              A+
            </button>
          </div>

          {/* Seletor de Tema Visual */}
          <select
            aria-label={t('topo', 'temaVisual')}
            value={tema}
            onChange={(e) => setTema(e.target.value as Tema)}
            className="text-xs px-2 py-1.5 rounded-raio-s border border-borda2 bg-card text-tinta2 cursor-pointer font-corpo"
          >
            <option value="classico-claro">{t('topo', 'temaClassicoClaro')}</option>
            <option value="classico-escuro">{t('topo', 'temaClassicoEscuro')}</option>
            <option value="moderno-claro">{t('topo', 'temaModernoClaro')}</option>
            <option value="moderno-escuro">{t('topo', 'temaModernoEscuro')}</option>
          </select>

          {/* Seletor de Idioma */}
          <DropdownMenu
            rotulo={idioma === 'pt-BR' ? 'PT' : 'EN'}
            icone={<Globe className="w-3.5 h-3.5 text-acento" />}
            items={[
              {
                id: 'pt-BR',
                rotulo: 'Português (Brasil)',
                destaque: idioma === 'pt-BR',
                onClick: () => setIdioma('pt-BR'),
              },
              {
                id: 'en-US',
                rotulo: 'English (US)',
                destaque: idioma === 'en-US',
                onClick: () => setIdioma('en-US'),
              },
            ]}
            title={t('topo', 'idioma')}
          />

          <div className="h-5 w-px bg-borda/60 mx-0.5" />

          {/* Ilha de Botões de Sistema: Segurança, Boas-Vindas, Sobre */}
          <div className="flex items-center gap-1">
            <button
              type="button"
              onClick={() => setSegurancaAberta(true)}
              title={t('seguranca', 'segurancaAcervo')}
              aria-label={t('seguranca', 'segurancaAcervo')}
              className="p-1.5 rounded-raio-s border border-borda2 bg-card hover:bg-sup text-tinta2 hover:text-tinta transition-colors cursor-pointer flex items-center justify-center shadow-xs relative"
            >
              {statusSeguranca?.modo_blindado ? (
                <ShieldCheck className="w-3.5 h-3.5 text-acento" />
              ) : (
                <Shield className="w-3.5 h-3.5 text-tinta3" />
              )}
            </button>

            <button
              type="button"
              onClick={() => setSplashAberta(true)}
              title={t('splash', 'bemVindo')}
              aria-label={t('splash', 'bemVindo')}
              className="p-1.5 rounded-raio-s border border-borda2 bg-card hover:bg-sup text-tinta2 hover:text-tinta transition-colors cursor-pointer flex items-center justify-center shadow-xs"
            >
              <Sparkles className="w-3.5 h-3.5 text-acento" />
            </button>

            <button
              type="button"
              onClick={() => setSobreAberto(true)}
              title={`${t('topo', 'sobre')} (F1)`}
              aria-label={t('topo', 'sobre')}
              className="p-1.5 rounded-raio-s border border-borda2 bg-card hover:bg-sup text-tinta2 hover:text-tinta transition-colors cursor-pointer flex items-center justify-center shadow-xs"
            >
              <Info className="w-3.5 h-3.5 text-acento" />
            </button>
          </div>
        </div>
      </header>

      <div className="flex flex-1 min-h-0">
        {/* Busca multicritério: escolher aqui centraliza a pessoa na árvore. */}
        <aside className="w-96 flex-none border-r border-borda bg-sup flex flex-col min-h-0">
          <PainelBusca
            selecionadaId={raizId}
            arvoreAtivaId={arvoreAtivaId}
            onSelecionarArvore={handleSelecionarArvore}
            onEscolher={(id) => {
              setRaizId(id);
              setSelecionadaId(id);
            }}
          />
        </aside>

        {/* Palco da árvore */}
        <main className="flex-1 min-w-0 relative">
          {acervoVazio && (
            <div className="absolute inset-0 grid place-items-center p-8 text-center">
              <div className="max-w-md flex flex-col gap-3 items-center">
                <IconeArvore className="w-10 h-10 text-tinta3" />
                <h2 className="font-tit font-bold text-xl m-0">Comece pela pessoa mais nova</h2>
                <p className="text-sm text-tinta2 m-0 leading-relaxed">
                  Cadastre você mesmo, ou o parente mais recente que conhecer, e vá subindo. Se
                  não souber o nome de um dos pais, o programa cria um nó “desconhecido” no
                  lugar — e você troca pelo nome real quando descobrir, sem perder os filhos já
                  pendurados nele.
                </p>
                <Button onClick={() => setFormAberto(true)}>
                  <Plus className="w-4 h-4 mr-1" />
                  Cadastrar a primeira pessoa
                </Button>
              </div>
            </div>
          )}

          {!acervoVazio && !raizId && (
            <div className="absolute inset-0 grid place-items-center p-8 text-center bg-mesa">
              <div className="max-w-md flex flex-col gap-4 items-center animate-in fade-in duration-200">
                <div className="w-16 h-16 rounded-raio bg-card flex items-center justify-center border border-borda shadow-xs text-acento">
                  <IconeArvore className="w-8 h-8 opacity-80" />
                </div>
                <div>
                  <h2 className="font-tit font-bold text-xl m-0 text-tinta">
                    {t('splash', 'mesaLimpaTitulo')}
                  </h2>
                  <p className="text-sm text-tinta2 mt-1.5 m-0 leading-relaxed">
                    {t('splash', 'mesaLimpaDesc')}
                  </p>
                </div>
                <div className="flex items-center gap-2.5 flex-wrap justify-center mt-2">
                  <Button onClick={() => setFormAberto(true)}>
                    <Plus className="w-4 h-4 mr-1" />
                    {t('splash', 'novaArvore')}
                  </Button>
                  <Button variant="secondary" onClick={() => setSplashAberta(true)}>
                    <FolderOpen className="w-4 h-4 mr-1 text-acento" />
                    {t('splash', 'abrirAcervo')}
                  </Button>
                  <Button variant="secondary" onClick={() => setImportarAberto(true)}>
                    <FileUp className="w-4 h-4 mr-1 text-acento" />
                    {t('splash', 'importarGedcom')}
                  </Button>
                </div>
              </div>
            </div>
          )}

          {!acervoVazio && raizId && carregandoArvore && (
            <div className="absolute inset-0 grid place-items-center">
              <span className="font-num text-sm text-tinta3">Montando a árvore…</span>
            </div>
          )}

          {!acervoVazio && raizId && erroArvore && (
            <div className="absolute inset-0 grid place-items-center p-8">
              <p className="text-sm text-fem text-center max-w-sm">
                {erroArvore instanceof Error
                  ? erroArvore.message
                  : 'Não foi possível montar a árvore.'}
              </p>
            </div>
          )}

          {!acervoVazio && raizId && grafo && !carregandoArvore && (
            <TreeCanvas
              grafo={grafo}
              raizId={raizId}
              pessoaSelecionadaId={selecionadaId}
              destacadosIds={destacadosIds}
              unioesColapsadas={unioesColapsadas}
              onToggleColapsarUniao={handleToggleColapsarUniao}
              onSelecionarPessoa={setSelecionadaId}
              onAbrirDetalhes={setFichaAberta}
              modoVisao={modoVisao}
              onMudarModo={setModoVisao}
              geracoes={geracoes}
              onMudarGeracoes={setGeracoes}
              onAbrirAhnentafel={() => setAhnentafelAberto(true)}
              onExportarPoster={() => setExportarPosterAberto(true)}
            />
          )}
        </main>

        {/* Painel lateral de perfil e conexões da pessoa selecionada */}
        {selecionadaId && !acervoVazio && (
          <PainelConexoes
            key={selecionadaId}
            pessoaId={selecionadaId}
            onSelecionarPessoa={setSelecionadaId}
            onFechar={() => setSelecionadaId(null)}
            onAbrirEdicao={(id) => setFichaAberta(id)}
            onDefinirComoRaiz={(id) => setRaizId(id)}
            isRaizAtual={raizId === selecionadaId}
            onPessoaRemovida={(id) => {
              setSelecionadaId(null);
              // Se a raiz foi apagada, solta a referência: o efeito acima
              // escolhe outra pessoa e a árvore se remonta sozinha.
              if (raizId === id) setRaizId(null);
            }}
          />
        )}
      </div>

      {/* A gaveta divide a tela com a árvore — split, não overlay (seção 8). */}
      {!acervoVazio && (
        <GavetaLinhaTempo
          pessoaSelecionadaId={selecionadaId}
          arvoreAtivaId={arvoreAtivaId}
          onDestacar={setDestacadosIds}
          onAbrirFicha={(id) => setFichaAberta(id)}
          onAbrirParentesco={(id) => {
            setPessoaInicialParentesco(id);
            setParentescoAberto(true);
          }}
          onAbrirImpressao={(dados) => {
            setDadosImpressaoTimeline(dados ?? null);
            setAbaImpressaoInicial('timeline');
            setCentralImpressaoAberta(true);
          }}
          aberta={timelineAberta}
          onToggleAberta={setTimelineAberta}
        />
      )}

      <ModalCalculadoraParentesco
        aberto={parentescoAberto}
        aoFechar={() => {
          setParentescoAberto(false);
          setPessoaInicialParentesco(null);
        }}
        pessoaInicialId={pessoaInicialParentesco}
      />

      <ModalFusaoPessoas
        aberto={fusaoAberta}
        aoFechar={() => {
          setFusaoAberta(false);
          setPessoaInicialFusao(null);
        }}
        pessoaInicialId={pessoaInicialFusao}
        onFusaoConcluida={(idMestre) => {
          setSelecionadaId(idMestre);
        }}
      />

      {importarAberto && (
        <DialogoImportar
          onFechar={() => setImportarAberto(false)}
          onImportado={() => {
            // A raiz pode ter deixado de fazer sentido: soltando-a, o efeito
            // que escolhe a primeira pessoa remonta a árvore sozinho.
            setSelecionadaId(null);
            setRaizId(null);
          }}
        />
      )}

      {exportarAberto && (
        <DialogoExportar raizId={raizId} onFechar={() => setExportarAberto(false)} />
      )}

      {exportarPosterAberto && grafo && (
        <DialogoExportarArvore
          aberto={exportarPosterAberto}
          onFechar={() => setExportarPosterAberto(false)}
          grafo={grafo}
          unioesColapsadas={unioesColapsadas}
          raizPessoa={pessoas?.find((p) => p.id === (selecionadaId || raizId))}
        />
      )}

      {centralImpressaoAberta && (
        <CentralImpressaoModal
          raizId={raizId}
          pessoaSelecionadaId={selecionadaId}
          abaInicial={abaImpressaoInicial}
          dadosTimeline={dadosImpressaoTimeline}
          onFechar={() => {
            setCentralImpressaoAberta(false);
            setDadosImpressaoTimeline(null);
          }}
        />
      )}

      {estatisticasAbertas && (
        <DialogoEstatisticas onClose={() => setEstatisticasAbertas(false)} />
      )}

      <ModalAhnentafel
        isOpen={ahnentafelAberto}
        onClose={() => setAhnentafelAberto(false)}
        raizId={raizId}
        onFocarPessoa={(id) => {
          setRaizId(id);
          setSelecionadaId(id);
        }}
        onAbrirFicha={(id) => setFichaAberta(id)}
      />

      <ModalHistoricoAcoes
        isOpen={historicoAberto}
        onClose={() => setHistoricoAberto(false)}
      />

      <ModalSobre
        aberto={sobreAberto}
        aoFechar={() => setSobreAberto(false)}
      />

      <SplashScreen
        aberto={splashAberta && !carregandoBoot}
        aoFechar={() => setSplashAberta(false)}
        onCriarNovaArvore={() => setFormAberto(true)}
        onSelecionarArvore={handleSelecionarArvore}
        onImportarGedcom={() => setImportarAberto(true)}
        onAbrirLinhaTempo={() => setTimelineAberta(true)}
      />

      {/* Tela de Carregamento Estilo The Sims 2 com frases bem-humoradas */}
      {carregandoBoot && (
        <TelaCarregamentoSims onConcluido={() => setCarregandoBoot(false)} />
      )}

      {/* Ficha completa — o que o botão "Detalhes" do card abre. */}
      {fichaAberta && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm">
          <div
            className="absolute inset-0"
            onClick={() => setFichaAberta(null)}
            aria-hidden
          />
          <div className="relative w-full max-w-4xl bg-card rounded-raio border border-borda shadow-sombra overflow-hidden">
            <PersonDetails
              pessoaId={fichaAberta}
              onFechar={() => setFichaAberta(null)}
              isRaizAtual={raizId === fichaAberta}
              onCalcularParentesco={(id) => {
                setPessoaInicialParentesco(id);
                setParentescoAberto(true);
              }}
              onFundirPessoa={(id) => {
                setPessoaInicialFusao(id);
                setFusaoAberta(true);
              }}
              onDefinirComoRaiz={(id) => {
                setRaizId(id);
                setSelecionadaId(id);
                if (arvoreAtivaId) {
                  definirRaizArvore(arvoreAtivaId, id).then(() => {
                    qc.invalidateQueries({ queryKey: ['arvores'] });
                  });
                }
              }}
            />
          </div>
        </div>
      )}

      {/* Tela de Desbloqueio quando o cofre está trancado */}
      {statusSeguranca?.bloqueado && <TelaDesbloqueio />}

      <ModalGerenciarSeguranca
        isOpen={segurancaAberta}
        onClose={() => setSegurancaAberta(false)}
      />

      <Modal
        isOpen={formAberto}
        onClose={() => setFormAberto(false)}
        title="Cadastrar pessoa"
        className="max-w-2xl"
      >
        <PersonForm
          salvando={criar.isPending}
          erro={criar.error}
          onCancelar={() => setFormAberto(false)}
          onSalvar={(dados) =>
            criar.mutate(dados, {
              onSuccess: (id) => {
                setFormAberto(false);
                setSelecionadaId(id);
                if (!raizId) setRaizId(id);
              },
            })
          }
        />
      </Modal>
    </div>
  );
}
