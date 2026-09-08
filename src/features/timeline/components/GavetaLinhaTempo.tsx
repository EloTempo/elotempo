/**
 * A gaveta das linhas do tempo (Fatia 07, Seção 8 + Fatia 10: Estúdio Autoral + NLE Design).
 *
 * Inspirada no DaVinci Resolve e Blender:
 * - Coluna fixa à esquerda com Track Headers (controles individuais por trilha).
 * - Separação categórica entre Trilhas Pessoais (Vidas da Árvore) e Trilhas de Contexto Histórico.
 * - Raias verticalmente coladas e compactas, eliminando espaços vazios.
 * - Controle de altura da trilha: Modo Compacto (38px) e Modo Expandido (68px).
 * - Marcadores Temporais com Anotações/Comentários e atração magnética (Snap).
 * - Régua de Anos com Scrubbing e Playhead vertical estilo DaVinci/Blender.
 */

import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { useQuery, useQueryClient, useMutation, useQueries } from '@tanstack/react-query';
import { cn } from '../../../components/ui/Button';
import {
  ArrowUpDown,
  BookOpen,
  Bookmark,
  Calendar,
  CalendarPlus,
  Check,
  ChevronDown,
  ChevronUp,
  Clock,
  Compass,
  Edit3,
  Eye,
  EyeOff,
  Layers,
  Magnet,
  MapPin,
  Maximize2,
  Plus,
  Trash2,
  User,
  UserPlus,
  Users,
  X,
  ZoomIn,
  ZoomOut,
} from 'lucide-react';
import { IconeLinhaTempo, IconeMedicaoTemporal, IconeRelacoes } from '../../../components/icons';
import {
  listarLinhasDeContexto,
  buscarMarcos,
  montarLinhaPessoal,
  quemEstavaVivo,
  type Marco,
  type MarcoPessoal,
  type LinhaPessoal,
  buscarParticipantesMarco,
  removerParticipante,
  toggleVisibilidadeParticipacao,
  adicionarParticipante,
  deletarMarco,
  listarMarcadores,
  type MarcadorLinhaTempo,
} from '../../../lib/api';
import { obterArvore } from '../../../lib/api/arvores';
import {
  CALENDARIOS,
  formatarAnoNoCalendario,
  converterAnoDoCalendarioParaGregoriano,
  obterNumeroAnoNoCalendario,
  obterSufixoAnoNoCalendario,
  formatarDataPrecisaNoCalendario,
  descreverDataComDetalhes,
  type InfoCalendario,
  type TipoCalendario,
} from '../../../lib/calendarios';
import { buscarPessoas } from '../../../lib/api/tree';
import { buscarPessoasFiltrado } from '../../../lib/api/busca';
import type { PersonNode } from '../../../types';
import { CabecalhoTrilha } from './CabecalhoTrilha';
import { ModalMarcadorComentario } from './ModalMarcadorComentario';
import { EditorLinhaTempo } from './EditorLinhaTempo';
import { EditorMarco } from './EditorMarco';
import { DialogoImprimirLinhaTempo } from './DialogoImprimirLinhaTempo';
import { ModalCompararVidas } from './ModalCompararVidas';
import { ModalCatalogoLinhasContexto } from './ModalCatalogoLinhasContexto';
import { ModalAdicionarEventoVida } from './ModalAdicionarEventoVida';
import { useI18n } from '../../../i18n/I18nContext';
import { dataParaAnoContinuo } from '../../../lib/precisionTime';
import {
  reordenarLista,
  ordenarIdsPorAno,
  sincronizarOrdemVidas,
  calcularFatiaVisivelBarra,
  calcularGridBlender,
  converterDataParaAnoFracionario,
  agruparMarcosPessoaisProximos,
  calcularSubLanesContexto,
} from '../ordenacaoTrilhas';
import type { DadosImpressaoTimeline } from '../tiposImpressao';

interface GavetaLinhaTempoProps {
  pessoaSelecionadaId: string | null;
  arvoreAtivaId?: string | null;
  /** Comunica à árvore quem destacar; `null` limpa o destaque. */
  onDestacar: (ids: string[] | null) => void;
  onAbrirFicha?: (pessoaId: string) => void;
  onAbrirParentesco?: (pessoaId: string) => void;
  onAbrirImpressao?: (dados?: DadosImpressaoTimeline) => void;
  aberta?: boolean;
  onToggleAberta?: (aberta: boolean) => void;
}

const ALTURA_MINIMA = 240;
const ALTURA_INICIAL = 260;

const LARGURA_SIDEBAR_PADRAO = 224; // Largura padrão inicial (redimensionável)
// Data atual sincronizada em alta precisão diretamente com o Sistema Operacional
const AGORA_SO = new Date();
const ANO_CORRENTE = AGORA_SO.getFullYear();
const HOJE_CONTINUO = dataParaAnoContinuo(
  AGORA_SO.getFullYear(),
  AGORA_SO.getMonth() + 1,
  AGORA_SO.getDate()
);
const ESPACO_ENTRE_ROTULOS = 100;

export function marcosComRotulo(
  marcos: Marco[],
  x: (ano: number) => number,
  escala = 1,
): Set<string> {
  const ordenados = [...marcos].sort(
    (a, b) => (a.ano_inicio ?? 0) - (b.ano_inicio ?? 0),
  );
  const comRotulo = new Set<string>();
  let proximoLivre = -Infinity;

  for (const m of ordenados) {
    if (m.ano_inicio == null) continue;
    const posicao = x(m.ano_inicio);
    if (posicao >= proximoLivre) {
      comRotulo.add(m.id);
      const fimPosicao =
        m.ano_fim != null && m.ano_fim > m.ano_inicio ? x(m.ano_fim) : posicao;
      proximoLivre = Math.max(posicao + ESPACO_ENTRE_ROTULOS * escala, fimPosicao + 10);
    }
  }
  return comRotulo;
}

const ESCALAS: number[] = [0.85, 1, 1.15, 1.3, 1.5];
const ESCALA_PADRAO = 1;

function escalaInicial(): number {
  try {
    const salva = Number(localStorage.getItem('escala-linha-tempo'));
    if (ESCALAS.includes(salva)) return salva;
  } catch {}
  return ESCALA_PADRAO;
}

const COR_DA_CATEGORIA: Record<string, string> = {
  historia: 'var(--lt-historia)',
  politica: 'var(--lt-politica)',
  moeda: 'var(--lt-moeda)',
  tecnologia: 'var(--lt-tecnologia)',
  projeto: 'var(--lt-projeto)',
};

function corDa(categoria: string | undefined): string {
  return COR_DA_CATEGORIA[categoria ?? ''] ?? 'var(--acento)';
}

function corDaPessoa(sexo: string | undefined): string {
  if (sexo === 'M') return 'var(--masc)';
  if (sexo === 'F') return 'var(--fem)';
  return 'var(--anel)';
}

function formatarAno(ano: number | null | undefined): string {
  if (ano == null) return '';
  if (ano < 0) return `${Math.abs(ano)} a.C.`;
  return String(ano);
}

const COR_MARCADOR_MAP: Record<string, string> = {
  azul: '#3b82f6',
  verde: '#10b981',
  amarelo: '#f59e0b',
  vermelho: '#ef4444',
  roxo: '#8b5cf6',
  ciano: '#06b6d4',
};

export interface MedicaoTemporal {
  de: number;
  ate: number;
  rotuloDe?: string;
  rotuloAte?: string;
}

export function calcularDistanciaFormatada(anoA: number, anoB: number): string {
  const diff = Math.abs(anoB - anoA);
  const anos = Math.floor(diff);
  const frac = diff - anos;
  if (frac < 0.02) {
    return anos === 1 ? '1 ano' : `${anos} anos`;
  }
  const meses = Math.floor(frac * 12);
  const dias = Math.round(((frac * 12) - meses) * 30.4375);
  const partes: string[] = [];
  if (anos > 0) partes.push(anos === 1 ? '1 ano' : `${anos} anos`);
  if (meses > 0) partes.push(meses === 1 ? '1 mês' : `${meses} meses`);
  if (dias > 0 && anos < 5) partes.push(dias === 1 ? '1 dia' : `${dias} dias`);
  return partes.length > 0 ? partes.join(', ') : `${anos} anos`;
}

export function GavetaLinhaTempo({
  pessoaSelecionadaId,
  arvoreAtivaId = null,
  onDestacar,
  onAbrirFicha,
  onAbrirParentesco,
  onAbrirImpressao: _onAbrirImpressao,
  aberta: propsAberta,
  onToggleAberta,
}: GavetaLinhaTempoProps) {
  const { t } = useI18n();
  const [abertaInterna, setAbertaInterna] = useState<boolean>(() => {
    try {
      return localStorage.getItem('timeline-aberta') !== 'false';
    } catch {
      return true;
    }
  });

  const aberta = propsAberta !== undefined ? propsAberta : abertaInterna;

  const setAberta = (proxima: boolean) => {
    setAbertaInterna(proxima);
    try {
      localStorage.setItem('timeline-aberta', String(proxima));
    } catch {}
    if (onToggleAberta) onToggleAberta(proxima);
  };

  // Inicia com altura suficiente para exibir Vidas na Árvore e Linhas de Contexto
  const [altura, setAltura] = useState(ALTURA_INICIAL);
  const [modoAltura, setModoAltura] = useState<'compacto' | 'expandido'>(() => {
    try {
      const salva = localStorage.getItem('timeline-modo-altura');
      if (salva === 'compacto' || salva === 'expandido') return salva;
    } catch {}
    return 'expandido';
  });

  // Altura customizada das trilhas quando em modo expandido
  const [alturaTrilhaCustom, setAlturaTrilhaCustom] = useState<number>(64);

  const alturaTrilha = modoAltura === 'compacto' ? 38 : alturaTrilhaCustom;

  // Largura customizada da coluna de trilhas (redimensionável puxando para direita / esquerda)
  const [larguraSidebar, setLarguraSidebar] = useState<number>(() => {
    try {
      const salva = Number(localStorage.getItem('timeline-largura-sidebar'));
      if (!isNaN(salva) && salva >= 160 && salva <= 600) return salva;
    } catch {}
    return LARGURA_SIDEBAR_PADRAO;
  });

  useEffect(() => {
    try {
      localStorage.setItem('timeline-largura-sidebar', String(larguraSidebar));
    } catch {}
  }, [larguraSidebar]);

  // Refs de redimensionamento de medidas (Splitters horizontal e vertical)
  const arrastandoSidebar = useRef(false);
  const inicioXSidebar = useRef(0);
  const larguraInicialSidebar = useRef(0);

  const arrastandoAlturaTrilha = useRef(false);
  const inicioYTrilha = useRef(0);
  const alturaInicialTrilha = useRef(0);

  const menuCalendarioRef = useRef<HTMLDivElement>(null);
  const menuMedicaoRef = useRef<HTMLDivElement>(null);

  const [calendarioAtivo, setCalendarioAtivo] = useState<TipoCalendario>(() => {
    try {
      const salvo = localStorage.getItem('timeline-calendario') as TipoCalendario;
      if (salvo && CALENDARIOS[salvo]) return salvo;
    } catch {}
    return 'gregoriano';
  });

  const [mostraMenuCalendario, setMostraMenuCalendario] = useState(false);

  useEffect(() => {
    try {
      localStorage.setItem('timeline-calendario', calendarioAtivo);
    } catch {}
  }, [calendarioAtivo]);

  useEffect(() => {
    const fechar = (e: MouseEvent) => {
      if (menuCalendarioRef.current && !menuCalendarioRef.current.contains(e.target as Node)) {
        setMostraMenuCalendario(false);
      }
    };
    if (mostraMenuCalendario) {
      document.addEventListener('mousedown', fechar);
      return () => document.removeEventListener('mousedown', fechar);
    }
  }, [mostraMenuCalendario]);


  const iniciarRedimensionamentoSidebar = useCallback(
    (e: React.MouseEvent) => {
      e.preventDefault();
      e.stopPropagation();
      arrastandoSidebar.current = true;
      inicioXSidebar.current = e.clientX;
      larguraInicialSidebar.current = larguraSidebar;
      document.body.style.cursor = 'col-resize';
      document.body.style.userSelect = 'none';
    },
    [larguraSidebar],
  );

  // Alturas individuais personalizadas por trilha: começa vazia (menor tamanho padrão)
  const [alturasIndividuais, setAlturasIndividuais] = useState<Record<string, number>>({});

  const obterAlturaTrilha = useCallback(
    (id: string) => {
      return alturasIndividuais[id] ?? alturaTrilha;
    },
    [alturasIndividuais, alturaTrilha],
  );

  const arrastandoTrilhaId = useRef<string | null>(null);
  const inicioYTrilhaIndividual = useRef(0);
  const alturaInicialTrilhaIndividual = useRef(0);

  const iniciarRedimensionamentoAlturaTrilha = useCallback(
    (id: string, e: React.MouseEvent) => {
      e.preventDefault();
      e.stopPropagation();
      arrastandoTrilhaId.current = id;
      inicioYTrilhaIndividual.current = e.clientY;
      alturaInicialTrilhaIndividual.current = alturasIndividuais[id] ?? alturaTrilha;
      document.body.style.cursor = 'row-resize';
      document.body.style.userSelect = 'none';

      const onMouseMove = (moveEvent: MouseEvent) => {
        if (!arrastandoTrilhaId.current) return;
        const deltaY = moveEvent.clientY - inicioYTrilhaIndividual.current;
        const novaAltura = Math.max(30, Math.min(180, Math.round(alturaInicialTrilhaIndividual.current + deltaY)));

        if (moveEvent.shiftKey || moveEvent.altKey) {
          // Segurando Shift ou Alt: altera a altura de todas as trilhas uniformemente!
          setAlturaTrilhaCustom(novaAltura);
          setAlturasIndividuais({});
        } else {
          // Sem tecla modificadora: altera apenas esta trilha individual
          setAlturasIndividuais((prev) => ({ ...prev, [id]: novaAltura }));
        }
      };

      const onMouseUp = () => {
        arrastandoTrilhaId.current = null;
        document.body.style.cursor = '';
        document.body.style.userSelect = '';
        window.removeEventListener('mousemove', onMouseMove);
        window.removeEventListener('mouseup', onMouseUp);
      };

      window.addEventListener('mousemove', onMouseMove);
      window.addEventListener('mouseup', onMouseUp);
    },
    [alturasIndividuais, alturaTrilha],
  );

  const resetarAlturaTrilha = useCallback((id: string, e?: React.MouseEvent) => {
    if (e?.shiftKey || e?.altKey) {
      // Segurando Shift ou Alt: restaura a altura padrão para todas as trilhas
      setAlturasIndividuais({});
      setAlturaTrilhaCustom(68);
    } else {
      setAlturasIndividuais((prev) => {
        const copia = { ...prev };
        delete copia[id];
        return copia;
      });
    }
  }, []);

  // Menu de cores flutuante ativo (apenas 1 aberto de cada vez)
  const [idMenuCorAberto, setIdMenuCorAberto] = useState<string | null>(null);

  // Chave de persistência de ordem das trilhas por árvore
  const chaveStorageOrdem = useMemo(
    () => `timeline-ordem-vidas-${arvoreAtivaId || 'global'}`,
    [arvoreAtivaId],
  );

  const [ativas, setAtivas] = useState<string[]>([]);
  const [vidasExtras, setVidasExtras] = useState<string[]>([]);
  const [vidasRemovidas, setVidasRemovidas] = useState<string[]>([]);
  const [ordemVidas, setOrdemVidas] = useState<string[]>(() => {
    try {
      const salvo = localStorage.getItem(`timeline-ordem-vidas-${arvoreAtivaId || 'global'}`);
      return salvo ? JSON.parse(salvo) : [];
    } catch {
      return [];
    }
  });

  // Cores personalizadas atribuídas às pessoas (pessoaId -> corHex)
  const [coresPersonalizadas, setCoresPersonalizadas] = useState<Record<string, string>>(() => {
    try {
      const salvo = localStorage.getItem('timeline-cores-pessoas');
      return salvo ? JSON.parse(salvo) : {};
    } catch {
      return {};
    }
  });

  const definirCorPessoa = useCallback((pessoaId: string, cor: string | null) => {
    setCoresPersonalizadas((prev) => {
      const proximo = { ...prev };
      if (cor) {
        proximo[pessoaId] = cor;
      } else {
        delete proximo[pessoaId];
      }
      try {
        localStorage.setItem('timeline-cores-pessoas', JSON.stringify(proximo));
      } catch {}
      return proximo;
    });
  }, []);

  const obterCorTrilha = useCallback(
    (pessoaId: string, sexo: string | undefined) => {
      return coresPersonalizadas[pessoaId] ?? corDaPessoa(sexo);
    },
    [coresPersonalizadas],
  );

  const [idArrastando, setIdArrastando] = useState<string | null>(null);
  const [dropAlvo, setDropAlvo] = useState<{ id: string; posicao: 'antes' | 'depois' } | null>(null);
  const [visibilidadeTrilhas, setVisibilidadeTrilhas] = useState<Record<string, boolean>>({});
  const [mostrarOcultos, setMostrarOcultos] = useState(false);
  const [densidadeModo, setDensidadeModo] = useState<'auto' | 'alta' | 'media' | 'detalhe'>('auto');
  const [mostrarDialogoImprimir, setMostrarDialogoImprimir] = useState(false);
  const [modalCompararAberto, setModalCompararAberto] = useState(false);

  // Ferramenta de Medição de Distância Temporal (Compasso / Intervalo de Marcos e Eventos)
  const [medicaoDistancia, setMedicaoDistancia] = useState<MedicaoTemporal | null>(null);
  const [modoMedicaoDistancia, setModoMedicaoDistancia] = useState(false);

  useEffect(() => {
    const fechar = (e: MouseEvent) => {
      if (menuMedicaoRef.current && !menuMedicaoRef.current.contains(e.target as Node)) {
        setModoMedicaoDistancia(false);
      }
    };
    if (modoMedicaoDistancia) {
      document.addEventListener('mousedown', fechar);
      return () => document.removeEventListener('mousedown', fechar);
    }
  }, [modoMedicaoDistancia]);

  // Retrocompatibilidade para relatórios/impressão
  const regiaoImpressao = useMemo(() => {
    return medicaoDistancia ? { de: Math.min(medicaoDistancia.de, medicaoDistancia.ate), ate: Math.max(medicaoDistancia.de, medicaoDistancia.ate) } : null;
  }, [medicaoDistancia]);

  // Marcadores e Anotações
  const [modalMarcadorAberto, setModalMarcadorAberto] = useState(false);
  const [marcadorParaEditar, setMarcadorParaEditar] = useState<MarcadorLinhaTempo | null>(null);

  // Crosshair e Cursor Temporal
  const [cursorX, setCursorX] = useState<number | null>(null);
  const [cursorAno, setCursorAno] = useState<number | null>(null);
  const [snapAtivo, setSnapAtivo] = useState<boolean>(() => {
    try {
      return localStorage.getItem('timeline-snap') !== 'false';
    } catch {
      return true;
    }
  });
  const [estaSnappado, setEstaSnappado] = useState(false);

  // Agulha Fixa Temporal (Playhead estilo DaVinci Resolve / Blender)
  const [agulhaAno, setAgulhaAno] = useState<number>(() => {
    try {
      const salva = Number(localStorage.getItem('timeline-agulha-ano'));
      if (!isNaN(salva) && salva > 0) return salva;
    } catch {}
    return 1889;
  });

  useEffect(() => {
    try {
      localStorage.setItem('timeline-agulha-ano', String(agulhaAno));
    } catch {}
  }, [agulhaAno]);

  const [marcoAberto, setMarcoAberto] = useState<Marco | null>(null);
  const [eventoPessoalAberto, setEventoPessoalAberto] = useState<{
    pessoaNome: string;
    pessoaId: string;
    marco: MarcoPessoal;
  } | null>(null);

  // Cache dos últimos dados para permitir transição suave de slide-down ao fechar o painel inferior
  const ultimoMarcoRef = useRef<Marco | null>(null);
  const ultimoEventoPessoalRef = useRef<{
    pessoaNome: string;
    pessoaId: string;
    marco: MarcoPessoal;
  } | null>(null);
  if (marcoAberto) ultimoMarcoRef.current = marcoAberto;
  if (eventoPessoalAberto) ultimoEventoPessoalRef.current = eventoPessoalAberto;

  const temPainelInferior = Boolean(marcoAberto || eventoPessoalAberto);
  const marcoExibido = marcoAberto ?? (!eventoPessoalAberto ? ultimoMarcoRef.current : null);
  const eventoExibido = eventoPessoalAberto ?? (!marcoAberto ? ultimoEventoPessoalRef.current : null);

  const ALTURA_PAINEL_INFERIOR = 230;
  const alturaPainelAdicional = temPainelInferior ? ALTURA_PAINEL_INFERIOR : 0;
  const alturaMaximaPermitida = Math.min(
    window.innerHeight - 60,
    Math.round(window.innerHeight * 0.9)
  );
  const alturaTotal = Math.min(alturaMaximaPermitida, altura + alturaPainelAdicional);

  const [escala] = useState<number>(escalaInicial);
  const [modalCatalogoAberto, setModalCatalogoAberto] = useState(false);
  const [modalEventoVidaAberto, setModalEventoVidaAberto] = useState(false);
  const [pessoaAlvoEventoVida, setPessoaAlvoEventoVida] = useState<string | null>(null);
  const [buscaParticipanteRapido, setBuscaParticipanteRapido] = useState('');
  const [pessoaSelecionadaRapida, setPessoaSelecionadaRapida] = useState<PersonNode | null>(null);
  const [papelRapido, setPapelRapido] = useState('');

  const [linhaEditando, setLinhaEditando] = useState<string | 'nova' | null>(null);
  const [marcoEditando, setMarcoEditando] = useState<Marco | 'novo' | null>(null);
  const [linhaAlvoMarco, setLinhaAlvoMarco] = useState<string | null>(null);

  const qc = useQueryClient();

  // Consulta as linhas de contexto do acervo
  const { data: linhas } = useQuery({
    queryKey: ['linhas-de-contexto'],
    queryFn: listarLinhasDeContexto,
  });

  // Consulta os marcadores temporais salvos
  const { data: marcadoresTimeline = [], refetch: refetchMarcadores } = useQuery({
    queryKey: ['marcadores-linha-tempo'],
    queryFn: () => listarMarcadores(),
    enabled: aberta,
  });

  const { data: arvoreAtual } = useQuery({
    queryKey: ['arvore-info', arvoreAtivaId],
    queryFn: () => (arvoreAtivaId ? obterArvore(arvoreAtivaId) : null),
    enabled: !!arvoreAtivaId,
  });

  // Busca membros da árvore ativa para alimentar automaticamente a comparação na linha do tempo
  const { data: pessoasDaArvore } = useQuery({
    queryKey: ['pessoas-arvore-timeline', arvoreAtivaId],
    queryFn: () =>
      arvoreAtivaId
        ? buscarPessoasFiltrado({ arvore_id: arvoreAtivaId, incluir_placeholders: false })
        : Promise.resolve([]),
    enabled: !!arvoreAtivaId,
    staleTime: 30_000,
  });

  // Ordenação base cronológica inicial das pessoas da árvore ativa
  const baseOrdenada = useMemo(() => {
    if (!pessoasDaArvore || pessoasDaArvore.length === 0) return [];
    return [...pessoasDaArvore].sort((a, b) => {
      const anoA = a.ano_nascimento ?? 999999;
      const anoB = b.ano_nascimento ?? 999999;
      if (anoA !== anoB) return anoA - anoB;
      return a.nome.localeCompare(b.nome);
    });
  }, [pessoasDaArvore]);

  // Sincroniza e restaura a ordenação salva ao trocar de árvore ativa
  useEffect(() => {
    setVidasRemovidas([]);
    setVidasExtras([]);
    try {
      const salvo = localStorage.getItem(chaveStorageOrdem);
      setOrdemVidas(salvo ? JSON.parse(salvo) : []);
    } catch {
      setOrdemVidas([]);
    }
  }, [chaveStorageOrdem]);

  const removerVida = useCallback((pessoaId: string) => {
    setVidasExtras((prev) => prev.filter((id) => id !== pessoaId));
    setVidasRemovidas((prev) => (prev.includes(pessoaId) ? prev : [...prev, pessoaId]));
  }, []);

  // Lista unificada de IDs de pessoas a exibir como trilhas de vida
  // Exibe todas as pessoas da árvore ativa quando uma árvore estiver selecionada
  const todasVidasIds = useMemo(() => {
    let baseIds: string[] = [];
    if (arvoreAtivaId) {
      if (pessoasDaArvore && pessoasDaArvore.length > 0) {
        baseIds = baseOrdenada.map((p) => p.id);
      } else if (arvoreAtual?.raiz_pessoa_id) {
        baseIds = [arvoreAtual.raiz_pessoa_id];
      }
      // Quando há árvore ativa selecionada, baseIds nunca cai em pessoaSelecionadaId da árvore anterior
    } else if (pessoaSelecionadaId) {
      baseIds = [pessoaSelecionadaId];
    }
    return sincronizarOrdemVidas({
      baseIds,
      vidasExtras,
      vidasRemovidas,
      ordemPersonalizada: ordemVidas,
    });
  }, [
    arvoreAtivaId,
    pessoasDaArvore,
    baseOrdenada,
    arvoreAtual?.raiz_pessoa_id,
    pessoaSelecionadaId,
    vidasExtras,
    vidasRemovidas,
    ordemVidas,
  ]);

  const reordenarTrilhas = useCallback(
    (origemId: string, destinoId: string, posicao: 'antes' | 'depois') => {
      const novaOrdem = reordenarLista(todasVidasIds, origemId, destinoId, posicao);
      setOrdemVidas(novaOrdem);
      try {
        localStorage.setItem(chaveStorageOrdem, JSON.stringify(novaOrdem));
      } catch {}
    },
    [todasVidasIds, chaveStorageOrdem],
  );

  const moverParaCima = useCallback(
    (id: string) => {
      const idx = todasVidasIds.indexOf(id);
      if (idx <= 0) return;
      reordenarTrilhas(id, todasVidasIds[idx - 1], 'antes');
    },
    [todasVidasIds, reordenarTrilhas],
  );

  const moverParaBaixo = useCallback(
    (id: string) => {
      const idx = todasVidasIds.indexOf(id);
      if (idx === -1 || idx >= todasVidasIds.length - 1) return;
      reordenarTrilhas(id, todasVidasIds[idx + 1], 'depois');
    },
    [todasVidasIds, reordenarTrilhas],
  );

  const idArrastandoRef = useRef<string | null>(null);
  const dropAlvoRef = useRef<{ id: string; posicao: 'antes' | 'depois' } | null>(null);

  const handleDragStart = useCallback((id: string, e: React.DragEvent) => {
    idArrastandoRef.current = id;
    setIdArrastando(id);
    try {
      e.dataTransfer.setData('text/plain', id);
    } catch {}
    e.dataTransfer.effectAllowed = 'move';
  }, []);

  const handleDragOver = useCallback(
    (id: string, e: React.DragEvent) => {
      e.preventDefault();
      e.stopPropagation();
      e.dataTransfer.dropEffect = 'move';
      const arrastando = idArrastandoRef.current;
      if (!arrastando || arrastando === id) {
        dropAlvoRef.current = null;
        setDropAlvo((prev) => (prev ? null : prev));
        return;
      }
      const rect = e.currentTarget.getBoundingClientRect();
      const meioY = rect.top + rect.height / 2;
      const posicao: 'antes' | 'depois' = e.clientY < meioY ? 'antes' : 'depois';
      dropAlvoRef.current = { id, posicao };
      setDropAlvo((prev) => {
        if (prev?.id === id && prev?.posicao === posicao) return prev;
        return { id, posicao };
      });
    },
    [],
  );

  const handleDragLeave = useCallback((id: string, e: React.DragEvent) => {
    e.stopPropagation();
    if (!e.currentTarget.contains(e.relatedTarget as Node)) {
      dropAlvoRef.current = null;
      setDropAlvo((prev) => (prev?.id === id ? null : prev));
    }
  }, []);

  const handleDrop = useCallback(
    (destinoId: string, e: React.DragEvent) => {
      e.preventDefault();
      e.stopPropagation();
      let origemId = idArrastandoRef.current;
      try {
        const data = e.dataTransfer.getData('text/plain');
        if (data) origemId = data;
      } catch {}
      if (!origemId || origemId === destinoId) {
        idArrastandoRef.current = null;
        dropAlvoRef.current = null;
        setIdArrastando(null);
        setDropAlvo(null);
        return;
      }
      const posicao = dropAlvoRef.current?.posicao ?? dropAlvo?.posicao ?? 'depois';
      reordenarTrilhas(origemId, destinoId, posicao);
      idArrastandoRef.current = null;
      dropAlvoRef.current = null;
      setIdArrastando(null);
      setDropAlvo(null);
    },
    [dropAlvo, reordenarTrilhas],
  );

  const handleDragEnd = useCallback(() => {
    idArrastandoRef.current = null;
    dropAlvoRef.current = null;
    setIdArrastando(null);
    setDropAlvo(null);
  }, []);

  // Consulta as vidas abertas no eixo
  const vidasQueries = useQueries({
    queries: todasVidasIds.map((id) => ({
      queryKey: ['linha-pessoal', id],
      queryFn: () => montarLinhaPessoal(id),
      enabled: aberta && !!id,
    })),
  });

  // Mapeia garantindo estritamente a ordem exata de todasVidasIds
  const linhasPessoais = useMemo(() => {
    const mapa = new Map<string, LinhaPessoal>();
    for (const q of vidasQueries) {
      if (q.data) mapa.set(q.data.pessoa_id, q.data);
    }
    const resultado: LinhaPessoal[] = [];
    for (const id of todasVidasIds) {
      const item = mapa.get(id);
      if (item) resultado.push(item);
    }
    return resultado;
  }, [vidasQueries, todasVidasIds]);

  const ordenarPorAnoNascimento = useCallback(() => {
    const mapaAnos = new Map<string, { ano?: number | null; nome?: string | null }>();
    for (const lp of linhasPessoais) {
      mapaAnos.set(lp.pessoa_id, {
        ano: lp.ano_nascimento,
        nome: lp.nome,
      });
    }
    const novaOrdem = ordenarIdsPorAno(todasVidasIds, mapaAnos);
    setOrdemVidas(novaOrdem);
    try {
      localStorage.setItem(chaveStorageOrdem, JSON.stringify(novaOrdem));
    } catch {}
  }, [linhasPessoais, todasVidasIds, chaveStorageOrdem]);

  // Se a pessoa selecionada na árvore mudar, foca suavemente na sua trilha sem alterar a ordem
  useEffect(() => {
    if (!pessoaSelecionadaId || !aberta) return;
    const el = document.querySelector(`[data-pessoa-id="${pessoaSelecionadaId}"]`);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
  }, [pessoaSelecionadaId, aberta]);

  const linhaPessoalPrincipal = linhasPessoais[0] ?? null;

  // Participantes do marco aberto
  const { data: participantesMarco } = useQuery({
    queryKey: ['marco-participantes', marcoAberto?.id],
    queryFn: () => buscarParticipantesMarco(marcoAberto!.id),
    enabled: !!marcoAberto?.id,
  });

  // Busca rápida de participante dentro do detalhe
  const { data: resultadosBuscaRapida } = useQuery({
    queryKey: ['busca-participante-rapida', buscaParticipanteRapido],
    queryFn: () => buscarPessoas(buscaParticipanteRapido, 6),
    enabled: buscaParticipanteRapido.trim().length >= 2,
  });

  const mRemoverParticipante = useMutation({
    mutationFn: (id: string) => removerParticipante(id),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['marco-participantes', marcoAberto?.id] });
      qc.invalidateQueries({ queryKey: ['linha-pessoal'] });
      qc.refetchQueries({ queryKey: ['linha-pessoal'] });
      qc.invalidateQueries({ queryKey: ['participacoes-pessoa'] });
    },
  });

  const mToggleVisibilidade = useMutation({
    mutationFn: ({ id, visivel }: { id: string; visivel: boolean }) =>
      toggleVisibilidadeParticipacao(id, visivel),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['marco-participantes', marcoAberto?.id] });
      qc.invalidateQueries({ queryKey: ['linha-pessoal'] });
      qc.refetchQueries({ queryKey: ['linha-pessoal'] });
      qc.invalidateQueries({ queryKey: ['participacoes-pessoa'] });
    },
  });

  // Escala de zoom na linha do tempo
  useEffect(() => {
    try {
      localStorage.setItem('escala-linha-tempo', String(escala));
    } catch {}
  }, [escala]);

  // ---------------------------------------------------------------
  // Janela de anos e Zoom Semântico
  // ---------------------------------------------------------------
  const [janela, setJanela] = useState({ de: 1850, ate: 2030 });

  // ---------------------------------------------------------------
  // Ferramenta de Medição de Distância Temporal (Compasso / Intervalo)
  // ---------------------------------------------------------------
  const definirPontoMedicao = useCallback((ano: number, rotulo?: string) => {
    setMedicaoDistancia((atual) => {
      if (!atual || atual.de === atual.ate) {
        return { de: ano, ate: ano, rotuloDe: rotulo, rotuloAte: rotulo };
      }
      if (ano < atual.de) {
        return { de: ano, ate: atual.de, rotuloDe: rotulo, rotuloAte: atual.rotuloDe };
      } else {
        return { de: atual.de, ate: ano, rotuloDe: atual.rotuloDe, rotuloAte: rotulo };
      }
    });
    setModoMedicaoDistancia(true);
  }, []);

  const marcarPontoA = useCallback((ano?: number, rotulo?: string) => {
    const alvo = ano ?? agulhaAno;
    setMedicaoDistancia((atual) => {
      if (!atual) return { de: alvo, ate: alvo, rotuloDe: rotulo };
      if (alvo > atual.ate) return { de: atual.ate, ate: alvo, rotuloDe: atual.rotuloAte, rotuloAte: rotulo };
      return { ...atual, de: alvo, rotuloDe: rotulo };
    });
    setModoMedicaoDistancia(true);
  }, [agulhaAno]);

  const marcarPontoB = useCallback((ano?: number, rotulo?: string) => {
    const alvo = ano ?? agulhaAno;
    setMedicaoDistancia((atual) => {
      if (!atual) return { de: alvo, ate: alvo, rotuloAte: rotulo };
      if (alvo < atual.de) return { de: alvo, ate: atual.de, rotuloDe: rotulo, rotuloAte: atual.rotuloDe };
      return { ...atual, ate: alvo, rotuloAte: rotulo };
    });
    setModoMedicaoDistancia(true);
  }, [agulhaAno]);

  const limparMedicao = useCallback(() => {
    setMedicaoDistancia(null);
  }, []);

  const enquadrarMedicao = useCallback(() => {
    if (!medicaoDistancia) return;
    const menor = Math.min(medicaoDistancia.de, medicaoDistancia.ate);
    const maior = Math.max(medicaoDistancia.de, medicaoDistancia.ate);
    const span = Math.max(1, maior - menor);
    const margem = Math.max(2, Math.round(span * 0.15));
    setJanela({ de: menor - margem, ate: maior + margem });
  }, [medicaoDistancia]);




  const enquadrarVida = useCallback((alvo?: LinhaPessoal) => {
    if (alvo?.ano_nascimento) {
      const nasc = alvo.ano_nascimento;
      const falec = alvo.ano_falecimento ?? (alvo.is_vivo ? ANO_CORRENTE : nasc + 80);
      const folga = Math.max(15, Math.round((falec - nasc) * 0.25));
      setJanela({ de: nasc - folga, ate: falec + folga });
      return;
    }
    // Se há uma árvore ativa, enquadra pela extensão da família
    if (arvoreAtivaId && pessoasDaArvore && pessoasDaArvore.length > 0) {
      const anos: number[] = [];
      for (const p of pessoasDaArvore) {
        if (p.ano_nascimento != null) anos.push(p.ano_nascimento);
        if (p.ano_falecimento != null) anos.push(p.ano_falecimento);
        else if (p.is_vivo && p.ano_nascimento != null) anos.push(ANO_CORRENTE);
      }
      if (anos.length > 0) {
        const minAno = Math.min(...anos);
        const maxAno = Math.max(...anos);
        const span = Math.max(10, maxAno - minAno);
        const margem = Math.max(5, Math.round(span * 0.1));
        setJanela({ de: minAno - margem, ate: maxAno + margem });
        setAgulhaAno(maxAno);
        return;
      }
    }
    // Se há múltiplas vidas abertas, enquadra todas elas simultaneamente
    if (linhasPessoais.length > 0) {
      const nascimentos = linhasPessoais
        .map((l) => l.ano_nascimento)
        .filter((n): n is number => n != null);
      if (nascimentos.length > 0) {
        const minNasc = Math.min(...nascimentos);
        const falecimentos = linhasPessoais
          .map((l) => l.ano_falecimento ?? (l.is_vivo ? ANO_CORRENTE : l.ano_nascimento ? l.ano_nascimento + 80 : null))
          .filter((f): f is number => f != null);
        const maxFalec = falecimentos.length > 0 ? Math.max(...falecimentos) : minNasc + 80;
        const folga = Math.max(15, Math.round((maxFalec - minNasc) * 0.2));
        setJanela({ de: minNasc - folga, ate: maxFalec + folga });
        return;
      }
    }
    if (linhaPessoalPrincipal?.ano_nascimento) {
      const nasc = linhaPessoalPrincipal.ano_nascimento;
      const falec =
        linhaPessoalPrincipal.ano_falecimento ??
        (linhaPessoalPrincipal.is_vivo ? ANO_CORRENTE : nasc + 80);
      const folga = Math.max(15, Math.round((falec - nasc) * 0.25));
      setJanela({ de: nasc - folga, ate: falec + folga });
    }
  }, [arvoreAtivaId, pessoasDaArvore, linhaPessoalPrincipal, linhasPessoais]);

  // Enquadramento automático EXCLUSIVAMENTE INICIAL ao selecionar nova árvore ou pessoa
  const ultimoAlvoEnquadradoRef = useRef<string | null>(null);
  useEffect(() => {
    const alvoAtual = arvoreAtivaId
      ? `arv:${arvoreAtivaId}`
      : pessoaSelecionadaId
      ? `p:${pessoaSelecionadaId}`
      : null;

    if (!alvoAtual || ultimoAlvoEnquadradoRef.current === alvoAtual) return;

    if (arvoreAtivaId) {
      if (!pessoasDaArvore || pessoasDaArvore.length === 0) return;
      ultimoAlvoEnquadradoRef.current = alvoAtual;
      enquadrarVida();
    } else if (pessoaSelecionadaId) {
      if (!linhaPessoalPrincipal?.ano_nascimento) return;
      ultimoAlvoEnquadradoRef.current = alvoAtual;
      enquadrarVida();
    }
  }, [arvoreAtivaId, pessoasDaArvore, pessoaSelecionadaId, linhaPessoalPrincipal, enquadrarVida]);

  const ehFicticio = useMemo(() => {
    return arvoreAtual?.tipo_tempo === 'ficticio';
  }, [arvoreAtual]);

  const formatarAnoAtual = useCallback(
    (ano: number | null | undefined) => {
      return formatarAnoNoCalendario(ano, calendarioAtivo, ehFicticio ? 'ficticio' : 'real');
    },
    [calendarioAtivo, ehFicticio],
  );

  const spanAnos = Math.max(1, janela.ate - janela.de);
  const densidadeAutomatica: 'alta' | 'media' | 'detalhe' =
    spanAnos > 120 ? 'alta' : spanAnos > 30 ? 'media' : 'detalhe';
  const relevanciaEfetiva = densidadeModo === 'auto' ? densidadeAutomatica : densidadeModo;

  const { data: marcos } = useQuery({
    queryKey: ['marcos', ativas, janela.de, janela.ate, relevanciaEfetiva],
    queryFn: () => buscarMarcos(ativas, janela.de, janela.ate, null, relevanciaEfetiva),
    enabled: aberta && ativas.length > 0 && !ehFicticio,
  });

  // ---------------------------------------------------------------
  // Medidas e Posicionamento Temporal
  // ---------------------------------------------------------------
  const palcoRef = useRef<HTMLDivElement>(null);
  const [larguraPalco, setLarguraPalco] = useState(1000);

  const painelInferiorRef = useRef<HTMLDivElement>(null);
  const trilhaAlvoScrollRef = useRef<{ tipo: 'contexto' | 'pessoal'; id: string } | null>(null);

  // Painéis independentes estilo DaVinci Resolve (Vidas na Árvore no topo, Linhas de Contexto fixas embaixo)
  const painelVidasRef = useRef<HTMLDivElement>(null);
  const painelContextoRef = useRef<HTMLDivElement>(null);

  // Altura customizada da seção de contexto histórico: começa em tamanho mínimo automático (null)
  const [alturaSecaoContexto, setAlturaSecaoContexto] = useState<number | null>(null);

  const arrastandoDivisor = useRef(false);
  const inicioYDivisor = useRef(0);
  const alturaInicialDivisor = useRef(0);

  const alturaPadraoContexto = useMemo(() => {
    if (ativas.length === 0) return 46;
    let total = 0;
    for (const id of ativas) {
      total += obterAlturaTrilha(id);
    }
    return Math.min(240, Math.max(46, total));
  }, [ativas, obterAlturaTrilha]);

  const iniciarRedimensionamentoDivisor = useCallback(
    (e: React.MouseEvent) => {
      e.preventDefault();
      e.stopPropagation();
      arrastandoDivisor.current = true;
      inicioYDivisor.current = e.clientY;
      alturaInicialDivisor.current = alturaSecaoContexto ?? alturaPadraoContexto;
      document.body.style.cursor = 'row-resize';
      document.body.style.userSelect = 'none';

      const onMouseMove = (moveEvent: MouseEvent) => {
        if (!arrastandoDivisor.current) return;
        // Puxar para cima (deltaY negativo) expande a seção de contexto inferior
        const deltaY = moveEvent.clientY - inicioYDivisor.current;
        const nova = Math.max(48, Math.min(450, alturaInicialDivisor.current - deltaY));
        setAlturaSecaoContexto(nova);
      };

      const onMouseUp = () => {
        arrastandoDivisor.current = false;
        window.removeEventListener('mousemove', onMouseMove);
        window.removeEventListener('mouseup', onMouseUp);
        document.body.style.cursor = '';
        document.body.style.userSelect = '';
        setAlturaSecaoContexto((atual) => {
          if (atual != null) {
            try {
              localStorage.setItem('timeline-altura-secao-contexto', String(atual));
            } catch {}
          }
          return atual;
        });
      };

      window.addEventListener('mousemove', onMouseMove);
      window.addEventListener('mouseup', onMouseUp);
    },
    [alturaSecaoContexto, alturaPadraoContexto],
  );

  const resetarAlturaContexto = useCallback((e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    setAlturaSecaoContexto(null);
    try {
      localStorage.removeItem('timeline-altura-secao-contexto');
    } catch {}
  }, []);

  useEffect(() => {
    const medir = () => setLarguraPalco(palcoRef.current?.clientWidth ?? 1000);
    medir();
    window.addEventListener('resize', medir);
    return () => window.removeEventListener('resize', medir);
  }, [aberta, alturaTotal]);

  // Garante a visibilidade da trilha clicada caso o painel inferior surja ou o usuário troque de marco
  useEffect(() => {
    if (!temPainelInferior) return;
    if (trilhaAlvoScrollRef.current) {
      if (trilhaAlvoScrollRef.current.tipo === 'pessoal') {
        const el = painelVidasRef.current?.querySelector(`[data-pessoa-id="${trilhaAlvoScrollRef.current.id}"]`);
        el?.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
      } else {
        const el = painelContextoRef.current?.querySelector(`[data-linha-id="${trilhaAlvoScrollRef.current.id}"]`);
        el?.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
      }
    }
  }, [temPainelInferior, marcoAberto, eventoPessoalAberto]);

  const larguraCanvas = Math.max(700, larguraPalco - larguraSidebar);

  const posicaoDoAno = useMemo(() => {
    const span = Math.max(0.0001, janela.ate - janela.de);
    return (ano: number) => ((ano - janela.de) / span) * larguraCanvas;
  }, [janela, larguraCanvas]);

  const anoDaPosicao = useMemo(() => {
    const span = Math.max(0.0001, janela.ate - janela.de);
    return (x: number) => janela.de + (x / Math.max(1, larguraCanvas)) * span;
  }, [janela, larguraCanvas]);

  // Divisões principais (Major ticks), secundárias (Minor subdivisions) e terciárias (Sub-minor / Meses) estilo Blender Timeline
  const { marcasDoEixo, marcasSecundarias, marcasTerciarias, rotulosGrid } = useMemo(() => {
    const grid = calcularGridBlender({
      de: janela.de,
      ate: janela.ate,
      calendario: calendarioAtivo,
      tipoTempo: ehFicticio ? 'ficticio' : 'real',
    });
    return {
      marcasDoEixo: grid.marcasPrincipais,
      marcasSecundarias: grid.marcasSecundarias,
      marcasTerciarias: grid.marcasTerciarias,
      rotulosGrid: grid.rotulos,
    };
  }, [janela, calendarioAtivo, ehFicticio]);

  // ---------------------------------------------------------------
  // Zoom e Deslocamento do Eixo
  // ---------------------------------------------------------------
  const aplicarZoom = useCallback(
    (fator: number, ancoraX?: number) => {
      setJanela((atual) => {
        const span = atual.ate - atual.de;
        const agulhaVisivel = agulhaAno >= atual.de && agulhaAno <= atual.ate;

        let anoNaAncora: number;
        let proporcao: number;

        if (ancoraX != null) {
          proporcao = Math.max(0.02, Math.min(0.98, ancoraX / Math.max(1, larguraCanvas)));
          anoNaAncora = atual.de + proporcao * span;
        } else if (agulhaVisivel) {
          // Ancorar na agulha temporal!
          anoNaAncora = agulhaAno;
          const proporcaoReal = (agulhaAno - atual.de) / span;
          // Preserva a posição exata da agulha na tela, mas garantindo margem de 15% a 80%
          // para que informações e eventos à direita da agulha nunca fiquem espremidos ou cortados.
          proporcao = Math.max(0.15, Math.min(0.80, proporcaoReal));
        } else {
          // Se a agulha não está no viewport, o zoom a traz exatamente para o centro
          anoNaAncora = agulhaAno;
          proporcao = 0.5;
        }

        const novoSpan = Math.max(0.01, Math.min(30000, span * fator));
        const novoDe = anoNaAncora - novoSpan * proporcao;
        const novoAte = anoNaAncora + novoSpan * (1 - proporcao);
        return {
          de: Number(novoDe.toFixed(4)),
          ate: Number(novoAte.toFixed(4)),
        };
      });
    },
    [larguraCanvas, agulhaAno],
  );

  const deslocar = useCallback(
    (pixels: number) => {
      setJanela((atual) => {
        const span = atual.ate - atual.de;
        const anos = (pixels / Math.max(1, larguraCanvas)) * span;
        const novoDe = atual.de + anos;
        const novoAte = atual.ate + anos;
        return {
          de: Number(novoDe.toFixed(4)),
          ate: Number(novoAte.toFixed(4)),
        };
      });
    },
    [larguraCanvas],
  );

  const arrastandoEixo = useRef(false);
  const arrastoInicio = useRef({ mouseX: 0, janelaDe: 0, janelaAte: 0 });
  const arrastou = useRef(false);

  useEffect(() => {
    let rafId: number | null = null;
    let pendenteJanela: { de: number; ate: number } | null = null;

    const mover = (e: MouseEvent) => {
      if (!arrastandoEixo.current) return;
      const deltaPixels = e.clientX - arrastoInicio.current.mouseX;
      if (Math.abs(deltaPixels) > 2) arrastou.current = true;
      const span = arrastoInicio.current.janelaAte - arrastoInicio.current.janelaDe;
      const deltaAnos = (deltaPixels / Math.max(1, larguraCanvas)) * span;
      const novoDe = arrastoInicio.current.janelaDe - deltaAnos;
      const novoAte = arrastoInicio.current.janelaAte - deltaAnos;

      pendenteJanela = {
        de: Number(novoDe.toFixed(4)),
        ate: Number(novoAte.toFixed(4)),
      };

      if (rafId === null) {
        rafId = requestAnimationFrame(() => {
          if (pendenteJanela) {
            setJanela(pendenteJanela);
          }
          rafId = null;
        });
      }
    };

    const soltar = () => {
      if (arrastandoEixo.current) {
        if (rafId !== null) {
          cancelAnimationFrame(rafId);
          rafId = null;
        }
        if (pendenteJanela) {
          setJanela(pendenteJanela);
          pendenteJanela = null;
        }
        arrastandoEixo.current = false;
        document.body.style.cursor = '';
        document.body.style.userSelect = '';
        setTimeout(() => {
          arrastou.current = false;
        }, 50);
      }
    };

    window.addEventListener('mousemove', mover);
    window.addEventListener('mouseup', soltar);
    return () => {
      if (rafId !== null) {
        cancelAnimationFrame(rafId);
      }
      window.removeEventListener('mousemove', mover);
      window.removeEventListener('mouseup', soltar);
    };
  }, [larguraCanvas]);

  // Atalhos de Teclado: 'M' marcador, 'I' início recorte, 'O' fim recorte, '+' aproximar (zoom in), '-' afastar (zoom out)
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (!aberta) return;
      if (
        e.target instanceof HTMLInputElement ||
        e.target instanceof HTMLTextAreaElement ||
        e.target instanceof HTMLSelectElement
      ) {
        return;
      }
      if (e.key === 'm' || e.key === 'M') {
        e.preventDefault();
        setMarcadorParaEditar(null);
        setModalMarcadorAberto(true);
      } else if (e.key === 'i' || e.key === 'I') {
        e.preventDefault();
        marcarPontoA();
      } else if (e.key === 'o' || e.key === 'O') {
        e.preventDefault();
        marcarPontoB();
      } else if (e.key === 'd' || e.key === 'D') {
        e.preventDefault();
        setModoMedicaoDistancia((prev) => !prev);
      } else if (e.key === '+' || e.key === '=') {
        e.preventDefault();
        aplicarZoom(0.7);
      } else if (e.key === '-' || e.key === '_') {
        e.preventDefault();
        aplicarZoom(1.4);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [aberta, marcarPontoA, marcarPontoB, aplicarZoom]);

  // ---------------------------------------------------------------
  // Alça de Redimensionamento da Gaveta
  // ---------------------------------------------------------------
  const [arrastandoAlcaEstado, setArrastandoAlcaEstado] = useState(false);
  const arrastandoAlca = useRef(false);
  const inicioY = useRef(0);
  const alturaInicial = useRef(0);

  useEffect(() => {
    const mover = (e: MouseEvent) => {
      if (!arrastandoAlca.current) return;
      const nova = Math.max(
        ALTURA_MINIMA,
        Math.min(window.innerHeight * 0.85, alturaInicial.current + (inicioY.current - e.clientY)),
      );
      setAltura(nova);
    };
    const soltar = () => {
      if (arrastandoAlca.current) {
        arrastandoAlca.current = false;
        setArrastandoAlcaEstado(false);
        document.body.style.cursor = '';
        document.body.style.userSelect = '';
      }
    };
    window.addEventListener('mousemove', mover);
    window.addEventListener('mouseup', soltar);
    return () => {
      window.removeEventListener('mousemove', mover);
      window.removeEventListener('mouseup', soltar);
    };
  }, []);

  // ---------------------------------------------------------------
  // Ações de Trilhas e Marcos
  // ---------------------------------------------------------------
  const alternarLinha = (id: string) => {
    setAtivas((atuais) => {
      if (atuais.includes(id)) return atuais.filter((x) => x !== id);
      return [...atuais, id];
    });
  };

  const toggleVisibilidadeTrilha = (id: string) => {
    setVisibilidadeTrilhas((prev) => ({
      ...prev,
      [id]: prev[id] === undefined ? false : !prev[id],
    }));
  };

  const abrirMarco = async (m: Marco) => {
    if (arrastou.current) {
      arrastou.current = false;
      return;
    }
    if (modoMedicaoDistancia && m.ano_inicio != null) {
      definirPontoMedicao(m.ano_inicio, m.titulo);
      return;
    }
    trilhaAlvoScrollRef.current = { tipo: 'contexto', id: m.linha_id };
    setEventoPessoalAberto(null);
    setMarcoAberto(m);
    if (m.ano_inicio != null) {
      try {
        const r = await quemEstavaVivo(m.ano_inicio, m.ano_fim ?? null);
        onDestacar(r.ids);
      } catch {
        onDestacar(null);
      }
    }
  };

  const fecharMarco = () => {
    setMarcoAberto(null);
    onDestacar(null);
  };

  const abrirEventoPessoal = async (
    pessoaNome: string,
    pessoaId: string,
    marco: MarcoPessoal,
  ) => {
    if (arrastou.current) {
      arrastou.current = false;
      return;
    }
    if (modoMedicaoDistancia && marco.ano != null) {
      definirPontoMedicao(marco.ano, `${marco.titulo} (${pessoaNome})`);
      return;
    }
    trilhaAlvoScrollRef.current = { tipo: 'pessoal', id: pessoaId };
    setMarcoAberto(null);
    setEventoPessoalAberto({ pessoaNome, pessoaId, marco });
    if (marco.ano != null) {
      try {
        const r = await quemEstavaVivo(marco.ano, marco.ano);
        onDestacar(r.ids);
      } catch {
        onDestacar(null);
      }
    }
  };

  const fecharEventoPessoal = () => {
    setEventoPessoalAberto(null);
    onDestacar(null);
  };

  const marcosPorLinha = useMemo(() => {
    const mapa = new Map<string, Marco[]>();
    for (const id of ativas) mapa.set(id, []);
    for (const m of marcos ?? []) {
      const lista = mapa.get(m.linha_id);
      if (lista) lista.push(m);
    }
    return mapa;
  }, [ativas, marcos]);

  // Pontos de atração magnética (Snap): nascimentos, mortes, marcos e marcadores criados
  const pontosSnap = useMemo(() => {
    const anos = new Set<number>();
    for (const lp of linhasPessoais) {
      const nascFrac = converterDataParaAnoFracionario(
        lp.ano_nascimento,
        lp.data_nascimento_texto,
        lp.mes_nascimento,
        lp.dia_nascimento,
      );
      if (nascFrac != null) anos.add(nascFrac);
      else if (lp.ano_nascimento != null) anos.add(lp.ano_nascimento);

      const falecFrac = converterDataParaAnoFracionario(
        lp.ano_falecimento,
        lp.data_falecimento_texto,
        lp.mes_falecimento,
        lp.dia_falecimento,
      );
      if (falecFrac != null) anos.add(falecFrac);
      else if (lp.ano_falecimento != null) anos.add(lp.ano_falecimento);

      for (const m of lp.marcos) {
        const mFrac = converterDataParaAnoFracionario(m.ano, m.data_texto, m.mes, m.dia);
        if (mFrac != null) anos.add(mFrac);
        else if (m.ano != null) anos.add(m.ano);
      }
    }
    for (const m of marcos ?? []) {
      const iniFrac = converterDataParaAnoFracionario(m.ano_inicio, m.data_periodo_texto);
      if (iniFrac != null) anos.add(iniFrac);
      else if (m.ano_inicio != null) anos.add(m.ano_inicio);
      if (m.ano_fim != null) anos.add(m.ano_fim);
    }
    for (const mk of marcadoresTimeline) {
      anos.add(mk.ano);
    }
    return Array.from(anos);
  }, [linhasPessoais, marcos, marcadoresTimeline]);

  // Centralização e salto direto para qualquer ano digitado
  const centralizarNoAno = useCallback((ano: number) => {
    setAgulhaAno(ano);
    setJanela((atual) => {
      const span = atual.ate - atual.de;
      const metade = Math.round(span / 2);
      return {
        de: ano - metade,
        ate: ano + metade,
      };
    });
  }, []);

  const [inputAnoTexto, setInputAnoTexto] = useState<string>(() =>
    String(
      obterNumeroAnoNoCalendario(
        Math.floor(agulhaAno),
        calendarioAtivo,
        ehFicticio ? 'ficticio' : 'real'
      )
    )
  );
  useEffect(() => {
    setInputAnoTexto(
      String(
        obterNumeroAnoNoCalendario(
          Math.floor(agulhaAno),
          calendarioAtivo,
          ehFicticio ? 'ficticio' : 'real'
        )
      )
    );
  }, [agulhaAno, calendarioAtivo, ehFicticio]);

  // ---------------------------------------------------------------
  // Guia Temporal Ancorado à Agulha Fixa (Inspeção Confortável e Interativa)
  // ---------------------------------------------------------------
  const [guiaTemporalAberto, setGuiaTemporalAberto] = useState<boolean>(false);
  const caixaGuiaRef = useRef<HTMLDivElement>(null);

  // Fecha o Guia Temporal ao pressionar a tecla Escape
  useEffect(() => {
    if (!guiaTemporalAberto) return;
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        setGuiaTemporalAberto(false);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [guiaTemporalAberto]);

  // Marcos e acontecimentos históricos ocorridos no ano selecionado pela agulha
  const marcosNaAgulha = useMemo(() => {
    if (agulhaAno == null || !marcos) return [];
    return marcos.filter((m) => {
      if (m.ano_inicio == null) return false;
      if (m.ano_fim != null) return agulhaAno >= m.ano_inicio && agulhaAno <= m.ano_fim;
      return Math.round(m.ano_inicio) === Math.round(agulhaAno);
    });
  }, [agulhaAno, marcos]);

  // Marcador customizado do usuário anotado neste ano
  const marcadorNaAgulha = useMemo(() => {
    return marcadoresTimeline.find((mk) => Math.abs(mk.ano - agulhaAno) < 0.005) ?? null;
  }, [agulhaAno, marcadoresTimeline]);

  // Contagem de pessoas vivas/contemporâneas no ano da agulha
  const vivosNaAgulhaCount = useMemo(() => {
    return linhasPessoais.filter((lp) => {
      if (!lp.ano_nascimento) return false;
      const idade = agulhaAno - lp.ano_nascimento;
      const falec = lp.ano_falecimento ?? (lp.is_vivo ? HOJE_CONTINUO : null);
      return idade >= 0 && (falec == null || agulhaAno <= falec);
    }).length;
  }, [linhasPessoais, agulhaAno]);

  // Posicionamento ancorado e estável diretamente sob a agulha temporal (com limites no palco)
  const posicaoGuiaAgulha = useMemo(() => {
    const wBox = 310;
    const posXAgulha = posicaoDoAno(agulhaAno);
    const absX = larguraSidebar + posXAgulha;

    let left = absX - wBox / 2;
    left = Math.max(larguraSidebar + 10, Math.min(left, larguraPalco - wBox - 16));

    const setaLeft = Math.max(16, Math.min(absX - left, wBox - 16));
    const top = 76; // Logo abaixo da régua de anos (toolbar 42px + régua 28px + folga)

    return { left, top, setaLeft };
  }, [agulhaAno, posicaoDoAno, larguraSidebar, larguraPalco]);

  // Arrasto e posicionamento da Agulha Fixa (Playhead estilo DaVinci Resolve)
  const arrastandoAgulha = useRef(false);

  const posicionarAgulhaEmX = useCallback(
    (canvasX: number) => {
      let anoFinal =
        spanAnos >= 3
          ? Math.round(anoDaPosicao(canvasX))
          : Number(anoDaPosicao(canvasX).toFixed(5));
      if (snapAtivo && pontosSnap.length > 0) {
        let menorDist = Infinity;
        let melhorAno: number | null = null;
        const RAIO_SNAP_PX = 18;

        for (const ano of pontosSnap) {
          const posX = posicaoDoAno(ano);
          const dist = Math.abs(posX - canvasX);
          if (dist <= RAIO_SNAP_PX && dist < menorDist) {
            menorDist = dist;
            melhorAno = ano;
          }
        }
        if (melhorAno != null) {
          anoFinal = melhorAno;
        }
      }
      setAgulhaAno(anoFinal);
    },
    [anoDaPosicao, posicaoDoAno, snapAtivo, pontosSnap, spanAnos],
  );

  useEffect(() => {
    const mover = (e: MouseEvent) => {
      // 1. Arraste da Agulha Temporal
      if (arrastandoAgulha.current) {
        const caixa = palcoRef.current?.getBoundingClientRect();
        if (caixa) {
          const canvasX = e.clientX - caixa.left - larguraSidebar;
          posicionarAgulhaEmX(canvasX);
        }
      }
      // 2. Arraste horizontal da largura dos cabeçalhos das trilhas (Splitter Coluna)
      if (arrastandoSidebar.current) {
        const deltaX = e.clientX - inicioXSidebar.current;
        const nova = Math.max(160, Math.min(600, larguraInicialSidebar.current + deltaX));
        setLarguraSidebar(nova);
      }
      // 3. Arraste vertical da altura das trilhas (Splitter Linhas)
      if (arrastandoAlturaTrilha.current) {
        const deltaY = e.clientY - inicioYTrilha.current;
        const nova = Math.max(32, Math.min(160, alturaInicialTrilha.current + deltaY));
        setAlturaTrilhaCustom(nova);
        if (nova <= 42) setModoAltura('compacto');
        else setModoAltura('expandido');
      }
    };
    const soltar = () => {
      if (arrastandoAgulha.current) {
        arrastandoAgulha.current = false;
        document.body.style.cursor = '';
      }
      if (arrastandoSidebar.current) {
        arrastandoSidebar.current = false;
        document.body.style.cursor = '';
        document.body.style.userSelect = '';
      }
      if (arrastandoAlturaTrilha.current) {
        arrastandoAlturaTrilha.current = false;
        document.body.style.cursor = '';
        document.body.style.userSelect = '';
      }
    };
    window.addEventListener('mousemove', mover);
    window.addEventListener('mouseup', soltar);
    return () => {
      window.removeEventListener('mousemove', mover);
      window.removeEventListener('mouseup', soltar);
    };
  }, [posicionarAgulhaEmX, larguraSidebar]);

  // ---------------------------------------------------------------
  // Renderização: Barra Recolhida
  // ---------------------------------------------------------------
  if (!aberta) {
    return (
      <div className="flex-none border-t border-borda bg-card2/90 hover:bg-card2 transition-colors print:hidden shadow-sm">
        <button
          type="button"
          onClick={() => setAberta(true)}
          className="w-full px-4 py-2.5 text-left text-sm flex items-center justify-between cursor-pointer group"
          title={t('linhaTempo', 'expandirGaveta')}
        >
          <div className="flex items-center gap-2.5">
            <span className="p-1 rounded bg-acento/15 text-acento group-hover:bg-acento group-hover:text-acento-tinta transition-colors shadow-2xs">
              <IconeLinhaTempo className="w-4 h-4" />
            </span>
            <span className="font-semibold text-tinta group-hover:text-acento transition-colors">
              {t('linhaTempo', 'titulo')}
            </span>
            <span className="text-xs text-tinta3 hidden md:inline">
              — {t('linhaTempo', 'subtitulo')}
            </span>
          </div>
          <div className="flex items-center gap-2 text-xs text-acento font-semibold">
            <span className="px-2 py-0.5 rounded-full bg-acento/10 border border-acento/30 group-hover:bg-acento group-hover:text-acento-tinta transition-all">
              {t('linhaTempo', 'expandirGaveta')}
            </span>
            <ChevronUp className="w-4 h-4 text-tinta3 group-hover:text-acento transition-transform group-hover:-translate-y-0.5" />
          </div>
        </button>
      </div>
    );
  }

  // ---------------------------------------------------------------
  // Renderização: Painel Completo Aberto (Estilo DaVinci Resolve)
  // ---------------------------------------------------------------
  return (
    <div
      className={cn(
        "flex-none border-t border-borda bg-sup flex flex-col print:hidden relative overflow-hidden select-none",
        arrastandoAlcaEstado ? "" : "transition-[height] duration-300 ease-out"
      )}
      style={{ height: alturaTotal, fontSize: `calc(12px * ${escala})` }}
    >
      {/* Alça de Redimensionamento Superior */}
      <div
        onMouseDown={(e) => {
          arrastandoAlca.current = true;
          setArrastandoAlcaEstado(true);
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

      {/* Barra de Ferramentas Superior Alinhada com a Estrutura de Trilhas */}
      <div className="flex-none flex items-stretch border-b border-borda bg-card shadow-2xs z-40 select-none min-h-[42px]">
        {/* Bloco 1: Identidade da Linha do Tempo & Informações Claras (Largura idêntica à coluna de Trilhas) */}
        <div
          className="flex-none px-3 py-1 border-r-2 border-borda/80 bg-card flex items-center justify-between gap-2 shadow-2xs select-none overflow-hidden"
          style={{ width: larguraSidebar }}
        >
          <div className="flex items-center gap-2 min-w-0">
            <span className="p-1 rounded bg-acento/10 text-acento flex-none">
              <IconeLinhaTempo className="w-4 h-4" />
            </span>
            <div className="flex flex-col min-w-0">
              <span className="font-bold text-xs text-tinta whitespace-nowrap leading-tight">
                {t('linhaTempo', 'titulo')}
              </span>
              {linhaPessoalPrincipal ? (
                <span
                  className="text-[10.5px] text-tinta3 truncate font-medium leading-tight max-w-full"
                  title={`Pessoa em foco: ${linhaPessoalPrincipal.nome}`}
                >
                  {linhaPessoalPrincipal.nome}
                </span>
              ) : (
                <span className="text-[10px] text-tinta3 font-medium leading-tight whitespace-nowrap">
                  {linhasPessoais.length + ativas.length} trilhas
                </span>
              )}
            </div>
          </div>
        </div>

        {/* Bloco 2: Ferramentas da Linha do Tempo (A partir da Divisória, sobre o Canvas da Timeline) */}
        <div className="flex-1 min-w-0 px-2.5 py-1 flex items-center justify-between gap-1.5 overflow-visible">
          {/* Sub-bloco Esquerda: Ações de Conteúdo (+ Comparar, + Evento, + Marcador, Linhas de Contexto) */}
          <div className="flex items-center gap-1 bg-sup/60 p-0.5 rounded-raio-s border border-borda/60 shrink-0">
            {/* Botão "+ Comparar Vida" */}
            <button
              type="button"
              onClick={() => setModalCompararAberto(true)}
              className="h-7 px-2 rounded-raio-s border border-borda/80 hover:border-acento bg-card hover:bg-card2 text-tinta hover:text-acento flex items-center gap-1 cursor-pointer transition-all shadow-2xs text-xs font-semibold whitespace-nowrap"
              title={t('linhaTempo', 'compararVidasModal')}
            >
              <UserPlus className="w-3.5 h-3.5 text-acento flex-none" />
              <span>{t('linhaTempo', 'compararBtn')}</span>
            </button>

            {/* Botão "+ Evento de Vida" */}
            <button
              type="button"
              onClick={() => {
                setPessoaAlvoEventoVida(null);
                setModalEventoVidaAberto(true);
              }}
              className="h-7 px-2 rounded-raio-s border border-borda/80 hover:border-purple-500/60 bg-card hover:bg-card2 text-tinta hover:text-purple-600 dark:hover:text-purple-400 flex items-center gap-1 cursor-pointer transition-all shadow-2xs text-xs font-semibold whitespace-nowrap"
              title={t('linhaTempo', 'eventoBtnTitle')}
            >
              <CalendarPlus className="w-3.5 h-3.5 text-purple-500 flex-none" />
              <span>{t('linhaTempo', 'eventoBtn')}</span>
            </button>

            {/* Botão "+ Marcador (M)" */}
            <button
              type="button"
              onClick={() => {
                setMarcadorParaEditar(null);
                setModalMarcadorAberto(true);
              }}
              className="h-7 px-2 rounded-raio-s border border-borda/80 hover:border-amber-500/60 bg-card hover:bg-card2 text-tinta hover:text-amber-600 dark:hover:text-amber-400 flex items-center gap-1 cursor-pointer transition-all shadow-2xs text-xs font-semibold whitespace-nowrap"
              title={t('linhaTempo', 'marcadorBtnTitle')}
            >
              <Bookmark className="w-3.5 h-3.5 text-amber-500 flex-none" />
              <span>{t('linhaTempo', 'marcadorBtn')}</span>
              <kbd className="hidden lg:inline text-[9px] text-tinta3 font-mono px-1 py-0.2 bg-sup rounded border border-borda/60 leading-none">M</kbd>
            </button>

            {/* Botão "Linhas de Contexto..." */}
            <button
              type="button"
              onClick={() => setModalCatalogoAberto(true)}
              className="h-7 px-2 rounded-raio-s border border-borda/80 hover:border-acento bg-card hover:bg-card2 text-tinta hover:text-acento flex items-center gap-1 cursor-pointer transition-all shadow-2xs text-xs font-medium whitespace-nowrap"
              title={t('linhaTempo', 'contextoBtnTitle')}
            >
              <Layers className="w-3.5 h-3.5 text-acento flex-none" />
              <span>{t('linhaTempo', 'contextoBtn')}</span>
              {ativas.length > 0 && (
                <span className="px-1.5 py-0.2 rounded-full text-[10px] bg-acento text-acento-tinta font-bold leading-none">
                  {ativas.length}
                </span>
              )}
            </button>
          </div>

          {/* Sub-bloco Centro: O ANO (Destaque Principal e Centralizado na Linha do Tempo) */}
          <div className="flex items-center justify-center gap-1.5 shrink-0 mx-auto">
            {/* Widget Principal do Ano com Borda de Destaque */}
            <div
              className="flex items-center h-7 gap-1 px-1.5 rounded-raio-s bg-card border-2 border-acento/30 dark:border-acento/40 hover:border-acento transition-colors text-xs font-num shadow-xs"
              title={`Agulha Temporal: ano no calendário ${CALENDARIOS[calendarioAtivo].rotuloCurto}. Digite o ano e tecle Enter para centralizar, ou use ◀ / ▶`}
            >
              <button
                type="button"
                onClick={() => {
                  const atualCal = obterNumeroAnoNoCalendario(
                    agulhaAno,
                    calendarioAtivo,
                    ehFicticio ? 'ficticio' : 'real'
                  );
                  const novoCal = atualCal - 1;
                  const novoGreg = converterAnoDoCalendarioParaGregoriano(
                    novoCal,
                    calendarioAtivo,
                    ehFicticio ? 'ficticio' : 'real'
                  );
                  setAgulhaAno(novoGreg);
                  setInputAnoTexto(String(novoCal));
                }}
                className="w-4 h-5 flex items-center justify-center hover:bg-sup text-tinta3 hover:text-tinta rounded text-[10px] cursor-pointer select-none"
                title="Recuar 1 ano"
              >
                ◀
              </button>

              <span className="text-[10px] uppercase font-sans tracking-tight text-tinta3 font-bold select-none">
                Ano:
              </span>
              <form
                onSubmit={(e) => {
                  e.preventDefault();
                  const num = parseInt(inputAnoTexto, 10);
                  if (!isNaN(num)) {
                    const anoGreg = converterAnoDoCalendarioParaGregoriano(
                      num,
                      calendarioAtivo,
                      ehFicticio ? 'ficticio' : 'real'
                    );
                    centralizarNoAno(anoGreg);
                  }
                }}
                className="flex items-center m-0 p-0"
              >
                <input
                  type="text"
                  size={4}
                  value={inputAnoTexto}
                  onChange={(e) => setInputAnoTexto(e.target.value)}
                  onBlur={() => {
                    const num = parseInt(inputAnoTexto, 10);
                    if (!isNaN(num)) {
                      const anoGreg = converterAnoDoCalendarioParaGregoriano(
                        num,
                        calendarioAtivo,
                        ehFicticio ? 'ficticio' : 'real'
                      );
                      if (anoGreg !== agulhaAno) {
                        centralizarNoAno(anoGreg);
                      } else {
                        setInputAnoTexto(String(num));
                      }
                    } else {
                      setInputAnoTexto(
                        String(
                          obterNumeroAnoNoCalendario(
                            agulhaAno,
                            calendarioAtivo,
                            ehFicticio ? 'ficticio' : 'real'
                          )
                        )
                      );
                    }
                  }}
                  className="w-13 text-center bg-sup hover:bg-sup focus:bg-sup border border-borda focus:border-acento rounded-xs font-num font-bold text-xs text-tinta px-0.5 py-0 outline-none transition-all cursor-text shadow-2xs"
                  title={`Ano no calendário ${CALENDARIOS[calendarioAtivo].rotuloCurto}. Digite o ano e pressione Enter para centralizar`}
                  aria-label="Ano da agulha temporal"
                />
              </form>

              {/* Sufixo informativo do calendário (ex: AM, AUC, HE, a.C.) */}
              {calendarioAtivo !== 'gregoriano' && (
                <span className="text-[10px] font-bold font-num text-tinta2 select-none -ml-0.5">
                  {obterSufixoAnoNoCalendario(agulhaAno, calendarioAtivo, ehFicticio ? 'ficticio' : 'real')}
                </span>
              )}

              <button
                type="button"
                onClick={() => {
                  const atualCal = obterNumeroAnoNoCalendario(
                    agulhaAno,
                    calendarioAtivo,
                    ehFicticio ? 'ficticio' : 'real'
                  );
                  const novoCal = atualCal + 1;
                  const novoGreg = converterAnoDoCalendarioParaGregoriano(
                    novoCal,
                    calendarioAtivo,
                    ehFicticio ? 'ficticio' : 'real'
                  );
                  setAgulhaAno(novoGreg);
                  setInputAnoTexto(String(novoCal));
                }}
                className="w-4 h-5 flex items-center justify-center hover:bg-sup text-tinta3 hover:text-tinta rounded text-[10px] cursor-pointer select-none"
                title="Avançar 1 ano"
              >
                ▶
              </button>
            </div>

            {/* Botão de Atalho: Ir para Hoje (Sincronizado com SO) */}
            <button
              type="button"
              onClick={() => {
                setAgulhaAno(HOJE_CONTINUO);
                centralizarNoAno(HOJE_CONTINUO);
              }}
              className="flex items-center h-7 gap-1.5 px-2 rounded-raio-s text-xs font-semibold bg-sup/80 hover:bg-sup text-tinta hover:text-acento border border-borda hover:border-acento/50 transition-all cursor-pointer shadow-2xs select-none"
              title={`Centralizar na data de Hoje do SO (${formatarDataPrecisaNoCalendario(HOJE_CONTINUO, 0.1, calendarioAtivo, ehFicticio ? 'ficticio' : 'real')})`}
            >
              <Clock className="w-3.5 h-3.5 text-acento" />
              <span>Hoje</span>
            </button>

            {/* Botão Guia Temporal */}
            <button
              type="button"
              onClick={() => {
                setGuiaTemporalAberto((prev) => {
                  const novo = !prev;
                  if (novo && (agulhaAno < janela.de || agulhaAno > janela.ate)) {
                    centralizarNoAno(agulhaAno);
                  }
                  return novo;
                });
              }}
              className={cn(
                'flex items-center h-7 gap-1.5 px-2 rounded-raio-s text-xs font-semibold transition-all cursor-pointer shadow-2xs select-none border',
                guiaTemporalAberto
                  ? 'bg-acento text-acento-tinta border-acento shadow-xs'
                  : 'bg-sup/80 hover:bg-sup text-tinta hover:text-acento border-borda hover:border-acento/50'
              )}
              title="Abrir ou fechar o Guia Temporal com idades e acontecimentos deste ano"
            >
              <Compass className="w-3.5 h-3.5" />
              <span>Guia</span>
            </button>

            {/* Seletor de Calendário Intercambiável ou Badge de Tempo Fictício */}
            {ehFicticio ? (
              <div
                className="flex items-center h-7 gap-1 px-2 rounded-raio-s text-xs font-semibold bg-sup text-tinta2 border border-borda select-none"
                title="Esta árvore opera em Cronologia Narrativa própria (Fictícia / Literária). Não há conversão para calendários terrestres reais."
              >
                <span>✨</span>
                <span>Fictício</span>
              </div>
            ) : (
              <div className="relative" ref={menuCalendarioRef}>
                <button
                  type="button"
                  onClick={() => setMostraMenuCalendario((prev) => !prev)}
                  className="flex items-center h-7 gap-1 px-2 rounded-raio-s text-xs font-semibold bg-sup/80 hover:bg-sup text-tinta border border-borda hover:border-borda2 transition-all cursor-pointer shadow-2xs select-none"
                  title="Alternar entre sistemas de calendário reais intercambiáveis"
                >
                  <Calendar className="w-3.5 h-3.5 text-acento" />
                  <span>{CALENDARIOS[calendarioAtivo].rotuloCurto}</span>
                  <ChevronDown className="w-3 h-3 text-tinta3" />
                </button>

                {mostraMenuCalendario && (
                  <div className="absolute top-full left-0 mt-1.5 w-48 bg-card border border-borda rounded-raio shadow-2xl p-1 z-50 flex flex-col gap-0.5 animate-in fade-in zoom-in-95 duration-100">
                    <div className="px-2 py-1 text-[10px] font-bold text-tinta3 uppercase tracking-wider border-b border-borda/60 mb-0.5 select-none">
                      Calendários
                    </div>
                    {(Object.values(CALENDARIOS) as InfoCalendario[]).map((cal) => (
                      <div key={cal.id} className="relative group">
                        <button
                          type="button"
                          onClick={() => {
                            setCalendarioAtivo(cal.id);
                            setMostraMenuCalendario(false);
                          }}
                          className={cn(
                            'w-full text-left px-2 py-1.5 rounded text-xs flex items-center justify-between cursor-pointer transition-colors',
                            calendarioAtivo === cal.id
                              ? 'bg-acento/15 text-acento font-bold'
                              : 'text-tinta hover:bg-sup'
                          )}
                        >
                          <div>
                            <div className="font-semibold text-xs leading-tight">{cal.nome}</div>
                            <div className="text-[10px] text-tinta3">{cal.rotuloCurto}</div>
                          </div>
                          {calendarioAtivo === cal.id && (
                            <Check className="w-3.5 h-3.5 text-acento flex-none" />
                          )}
                        </button>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>

          {/* Sub-bloco Direita: Exibição, Medição Temporal & Janela */}
          <div className="flex items-center gap-1.5 shrink-0">
            {/* Pod de Exibição das Trilhas */}
            <div className="flex items-center gap-1 bg-sup/60 p-0.5 rounded-raio-s border border-borda/60">
              {/* Modo de Altura de Trilha */}
              <div className="flex items-center h-6 rounded-xs bg-card p-0.5 text-xs">
                <button
                  type="button"
                  onClick={() => setModoAltura('compacto')}
                  className={cn(
                    'h-full px-1.5 rounded-2xs text-[10px] font-semibold transition-colors cursor-pointer flex items-center',
                    modoAltura === 'compacto' ? 'bg-sup text-acento shadow-2xs font-bold' : 'text-tinta3 hover:text-tinta'
                  )}
                  title="Visualização compacta das trilhas (ver mais em menos espaço)"
                >
                  {t('linhaTempo', 'modoCompacto')}
                </button>
                <button
                  type="button"
                  onClick={() => setModoAltura('expandido')}
                  className={cn(
                    'h-full px-1.5 rounded-2xs text-[10px] font-semibold transition-colors cursor-pointer flex items-center',
                    modoAltura === 'expandido' ? 'bg-sup text-acento shadow-2xs font-bold' : 'text-tinta3 hover:text-tinta'
                  )}
                  title="Visualização expandida com todos os chips e detalhes"
                >
                  {t('linhaTempo', 'modoExpandido')}
                </button>
              </div>

              {/* Snap Magnético */}
              <button
                type="button"
                onClick={() => {
                  setSnapAtivo((prev) => {
                    const proximo = !prev;
                    try {
                      localStorage.setItem('timeline-snap', String(proximo));
                    } catch {}
                    return proximo;
                  });
                }}
                title={
                  snapAtivo
                    ? t('linhaTempo', 'snapTooltipLigado')
                    : t('linhaTempo', 'snapTooltipDesligado')
                }
                className={cn(
                  'h-6 px-1.5 rounded-xs text-[10px] transition-colors cursor-pointer border flex items-center gap-1 shadow-2xs',
                  snapAtivo
                    ? 'bg-acento/10 text-acento border-acento/40 font-semibold'
                    : 'bg-card text-tinta3 hover:text-tinta border-borda/60'
                )}
              >
                <Magnet className={cn('w-3 h-3', snapAtivo ? 'text-acento' : 'text-tinta3')} />
                <span className="hidden xl:inline">{snapAtivo ? t('linhaTempo', 'snapLigado') : t('linhaTempo', 'snapDesligado')}</span>
              </button>

              {/* Seletor de Densidade */}
              <div
                className="flex items-center h-6 text-xs text-tinta2 gap-0.5 px-1.5 rounded-xs bg-card border border-borda/60 transition-colors shadow-2xs"
                title={t('linhaTempo', 'densidade')}
              >
                <select
                  value={densidadeModo}
                  onChange={(e) => setDensidadeModo(e.target.value as any)}
                  className="text-[10px] bg-transparent border-none text-tinta font-semibold focus:outline-none cursor-pointer pr-0.5"
                >
                  <option value="auto">{t('linhaTempo', 'densidadeAuto')}</option>
                  <option value="alta">{t('linhaTempo', 'densidadeAlta')}</option>
                  <option value="media">{t('linhaTempo', 'densidadeMedia')}</option>
                  <option value="detalhe">{t('linhaTempo', 'densidadeDetalhe')}</option>
                </select>
              </div>

              {/* Alternar Marcos Ocultos */}
              <button
                type="button"
                onClick={() => setMostrarOcultos(!mostrarOcultos)}
                title={t('linhaTempo', 'mostrarOcultos')}
                className={cn(
                  'w-6 h-6 flex items-center justify-center rounded-xs text-xs transition-colors cursor-pointer border shadow-2xs',
                  mostrarOcultos
                    ? 'bg-acento/10 text-acento border-acento/40'
                    : 'bg-card text-tinta3 hover:text-tinta border-borda/60'
                )}
              >
                {mostrarOcultos ? <Eye className="w-3 h-3" /> : <EyeOff className="w-3 h-3" />}
              </button>
            </div>

            <div className="w-px h-5 bg-borda flex-none mx-0.5" aria-hidden />

            {/* Ferramenta de Medição de Distância Temporal */}
            <div className="relative flex items-center" ref={menuMedicaoRef}>
              <button
                type="button"
                onClick={() => setModoMedicaoDistancia((prev) => !prev)}
                title={
                  medicaoDistancia
                    ? `${t('linhaTempo', 'distanciaTemporal')}: Δ ${calcularDistanciaFormatada(medicaoDistancia.de, medicaoDistancia.ate)}`
                    : t('linhaTempo', 'distanciaTemporalTooltip')
                }
                className={cn(
                  'h-7 px-2 rounded-raio-s text-xs font-semibold flex items-center gap-1.5 transition-colors cursor-pointer border shadow-2xs',
                  medicaoDistancia
                    ? 'bg-sky-500/15 border-sky-500 text-sky-600 dark:text-sky-300 font-bold'
                    : modoMedicaoDistancia
                    ? 'bg-acento text-acento-tinta border-acento'
                    : 'bg-sup/80 hover:bg-sup text-tinta3 hover:text-tinta border-borda'
                )}
              >
                <IconeMedicaoTemporal className="w-3.5 h-3.5" />
                <span className="font-num text-[11px] whitespace-nowrap">
                  {medicaoDistancia
                    ? `Δ ${calcularDistanciaFormatada(medicaoDistancia.de, medicaoDistancia.ate)}`
                    : t('linhaTempo', 'medirDistancia')}
                </span>
              </button>

              {modoMedicaoDistancia && (
                <div
                  ref={menuMedicaoRef}
                  className="absolute top-full right-0 mt-1.5 z-50 w-64 p-2.5 rounded-raio-s bg-card border border-borda shadow-xl text-xs flex flex-col gap-2 animate-in fade-in zoom-in-95 duration-100"
                >
                  {/* Cabeçalho Compacto */}
                  <div className="flex items-center justify-between border-b border-borda/70 pb-1">
                    <span className="font-bold text-xs text-tinta flex items-center gap-1.5">
                      <IconeMedicaoTemporal className="w-3.5 h-3.5 text-sky-600 dark:text-sky-400" />
                      {t('linhaTempo', 'distanciaTemporal')}
                    </span>
                    <button
                      type="button"
                      onClick={() => setModoMedicaoDistancia(false)}
                      className="p-0.5 text-tinta3 hover:text-tinta rounded-xs cursor-pointer"
                      title={t('comum', 'fechar')}
                    >
                      <X className="w-3 h-3" />
                    </button>
                  </div>

                  {/* Informações Essenciais */}
                  {medicaoDistancia ? (
                    <div className="flex flex-col gap-1 text-[11px]">
                      {/* Delta em destaque */}
                      <div className="flex items-baseline justify-between px-2 py-1 rounded bg-sky-500/10 border border-sky-500/25">
                        <span className="text-[10px] font-semibold text-tinta3">{t('linhaTempo', 'deltaTotal')}:</span>
                        <span className="font-bold font-num text-sky-600 dark:text-sky-400">
                          {calcularDistanciaFormatada(medicaoDistancia.de, medicaoDistancia.ate)}
                        </span>
                      </div>

                      {/* Pontos A e B */}
                      <div className="px-1 py-0.5 flex flex-col gap-0.5 text-tinta2">
                        <div className="flex items-center justify-between">
                          <span className="font-semibold text-sky-600 dark:text-sky-400">{t('linhaTempo', 'pontoA')}:</span>
                          <span className="font-num truncate max-w-[160px]" title={medicaoDistancia.rotuloDe || undefined}>
                            {formatarDataPrecisaNoCalendario(medicaoDistancia.de, spanAnos, calendarioAtivo, ehFicticio ? 'ficticio' : 'real')}
                            {medicaoDistancia.rotuloDe && <span className="text-tinta3 font-sans"> ({medicaoDistancia.rotuloDe})</span>}
                          </span>
                        </div>
                        <div className="flex items-center justify-between">
                          <span className="font-semibold text-sky-600 dark:text-sky-400">{t('linhaTempo', 'pontoB')}:</span>
                          <span className="font-num truncate max-w-[160px]" title={medicaoDistancia.rotuloAte || undefined}>
                            {formatarDataPrecisaNoCalendario(medicaoDistancia.ate, spanAnos, calendarioAtivo, ehFicticio ? 'ficticio' : 'real')}
                            {medicaoDistancia.rotuloAte && <span className="text-tinta3 font-sans"> ({medicaoDistancia.rotuloAte})</span>}
                          </span>
                        </div>
                        {linhaPessoalPrincipal?.ano_nascimento && (
                          <div className="flex items-center justify-between text-[10px] text-tinta3 pt-0.5 border-t border-borda/40 mt-0.5">
                            <span>{t('linhaTempo', 'idade')}:</span>
                            <span className="font-num">
                              {Math.max(0, Math.floor(medicaoDistancia.de - linhaPessoalPrincipal.ano_nascimento))}a → {Math.max(0, Math.floor(medicaoDistancia.ate - linhaPessoalPrincipal.ano_nascimento))}a
                            </span>
                          </div>
                        )}
                      </div>
                    </div>
                  ) : (
                    <div className="py-2 text-center text-[11px] text-tinta3">
                      {t('linhaTempo', 'nenhumPontoMarcado')}
                    </div>
                  )}

                  {/* Ações Rápidas */}
                  <div className="grid grid-cols-2 gap-1 pt-1 border-t border-borda/60">
                    <button
                      type="button"
                      onClick={() => marcarPontoA()}
                      className="px-1.5 py-1 rounded-xs bg-sup hover:bg-card2 border border-borda font-semibold text-[10.5px] text-tinta flex items-center justify-center gap-1 cursor-pointer transition-colors"
                      title={`Marcar Ponto A no ano da agulha: ${formatarAnoAtual(agulhaAno)}`}
                    >
                      <span>{t('linhaTempo', 'fixarA')}</span>
                    </button>
                    <button
                      type="button"
                      onClick={() => marcarPontoB()}
                      className="px-1.5 py-1 rounded-xs bg-sup hover:bg-card2 border border-borda font-semibold text-[10.5px] text-tinta flex items-center justify-center gap-1 cursor-pointer transition-colors"
                      title={`Marcar Ponto B no ano da agulha: ${formatarAnoAtual(agulhaAno)}`}
                    >
                      <span>{t('linhaTempo', 'fixarB')}</span>
                    </button>
                  </div>

                  {medicaoDistancia && (
                    <div className="flex items-center gap-1">
                      <button
                        type="button"
                        onClick={enquadrarMedicao}
                        className="flex-1 px-1.5 py-0.5 rounded-xs bg-sup hover:bg-card2 border border-borda text-[10px] font-medium text-tinta cursor-pointer transition-colors"
                      >
                        {t('linhaTempo', 'enquadrar')}
                      </button>
                      <button
                        type="button"
                        onClick={limparMedicao}
                        className="px-2 py-0.5 rounded-xs hover:bg-rose-500/10 text-rose-600 dark:text-rose-400 text-[10px] font-medium cursor-pointer transition-colors"
                      >
                        {t('linhaTempo', 'limpar')}
                      </button>
                    </div>
                  )}
                </div>
              )}
            </div>

            <div className="w-px h-5 bg-borda flex-none mx-0.5" aria-hidden />

            {/* Pod de Navegação de Janela */}
            <div className="flex items-center gap-1">
              {/* Zoom In/Out */}
              <div className="flex items-center h-7 rounded-raio-s border border-borda bg-sup/80 p-0.5 text-xs shadow-2xs">
                <button
                  type="button"
                  onClick={() => aplicarZoom(1.4)}
                  title={t('linhaTempo', 'zoomOutTitle')}
                  className="w-6 h-full flex items-center justify-center rounded-xs text-tinta2 hover:text-tinta hover:bg-card transition-colors cursor-pointer"
                >
                  <ZoomOut className="w-3.5 h-3.5" />
                </button>
                <div className="w-px h-3 bg-borda mx-0.5" />
                <button
                  type="button"
                  onClick={() => aplicarZoom(0.7)}
                  title={t('linhaTempo', 'zoomInTitle')}
                  className="w-6 h-full flex items-center justify-center rounded-xs text-tinta2 hover:text-tinta hover:bg-card transition-colors cursor-pointer"
                >
                  <ZoomIn className="w-3.5 h-3.5" />
                </button>
              </div>

              {/* Enquadrar Vida */}
              {linhaPessoalPrincipal?.ano_nascimento && (
                <button
                  type="button"
                  onClick={() => enquadrarVida()}
                  title={t('linhaTempo', 'enquadrarVidaTitle', { nome: linhaPessoalPrincipal.nome })}
                  className="w-7 h-7 flex items-center justify-center rounded-raio-s bg-sup/80 hover:bg-sup text-tinta border border-borda hover:border-acento transition-colors cursor-pointer shadow-2xs"
                >
                  <Maximize2 className="w-3.5 h-3.5" />
                </button>
              )}

              {/* Recolher Gaveta */}
              <button
                type="button"
                onClick={() => setAberta(false)}
                aria-label={t('linhaTempo', 'recolherGaveta')}
                className="w-7 h-7 flex items-center justify-center rounded-raio-s bg-sup/80 hover:bg-sup text-tinta3 hover:text-tinta border border-borda hover:border-borda2 transition-colors cursor-pointer shadow-2xs"
              >
                <ChevronDown className="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Palco Principal: Track Headers Fixos à Esquerda + Eixo Temporal à Direita */}
      <div
        ref={palcoRef}
        className="flex-1 min-h-0 flex flex-col overflow-hidden select-none cursor-grab active:cursor-grabbing relative"
        onMouseDown={(e) => {
          if (e.button !== 0) return;
          // Só inicia arraste se clicou no canvas temporal, não nos cabeçalhos
          const caixa = palcoRef.current?.getBoundingClientRect();
          if (!caixa) return;
          const x = e.clientX - caixa.left;
          if (x < larguraSidebar) return;

          // Se clicou em um elemento interativo, não inicia pan
          if ((e.target as HTMLElement).closest('button, input, select, [role="button"]')) {
            return;
          }

          arrastandoEixo.current = true;
          arrastou.current = false;
          arrastoInicio.current = {
            mouseX: e.clientX,
            janelaDe: janela.de,
            janelaAte: janela.ate,
          };
          document.body.style.cursor = 'grabbing';
          document.body.style.userSelect = 'none';
        }}
        onMouseMove={(e) => {
          if (arrastandoEixo.current) {
            setCursorX((ant) => (ant !== null ? null : ant));
            setCursorAno((ant) => (ant !== null ? null : ant));
            setEstaSnappado((ant) => (ant ? false : ant));
            return;
          }
          const caixa = palcoRef.current?.getBoundingClientRect();
          if (!caixa) return;
          const x = e.clientX - caixa.left;

          // Se estiver sobre a coluna de cabeçalhos, esconde a linha de cursor
          if (x < larguraSidebar) {
            setCursorX((ant) => (ant !== null ? null : ant));
            setCursorAno((ant) => (ant !== null ? null : ant));
            setEstaSnappado((ant) => (ant ? false : ant));
            return;
          }

          const canvasX = x - larguraSidebar;
          let anoFinal =
            spanAnos >= 3
              ? Math.round(anoDaPosicao(canvasX))
              : Number(anoDaPosicao(canvasX).toFixed(5));
          let xFinal = canvasX;
          let snappou = false;

          if (snapAtivo && pontosSnap.length > 0) {
            let menorDist = Infinity;
            let melhorAno: number | null = null;
            const RAIO_SNAP_PX = 18;

            for (const ano of pontosSnap) {
              const posX = posicaoDoAno(ano);
              const dist = Math.abs(posX - canvasX);
              if (dist <= RAIO_SNAP_PX && dist < menorDist) {
                menorDist = dist;
                melhorAno = ano;
              }
            }

            if (melhorAno != null) {
              anoFinal = melhorAno;
              xFinal = posicaoDoAno(melhorAno);
              snappou = true;
            }
          }

          setCursorX(xFinal);
          setCursorAno(anoFinal);
          setEstaSnappado(snappou);
        }}
        onMouseLeave={() => {
          setCursorX(null);
          setCursorAno(null);
          setEstaSnappado(false);
        }}
        onWheel={(e) => {
          const caixa = palcoRef.current?.getBoundingClientRect();
          const x = caixa ? e.clientX - caixa.left - larguraSidebar : larguraCanvas / 2;
          if (e.ctrlKey || e.metaKey) {
            // Ctrl + Scroll: Zoom in / Zoom out ancorado na agulha
            e.preventDefault();
            const agulhaVisivel = agulhaAno >= janela.de && agulhaAno <= janela.ate;
            aplicarZoom(e.deltaY > 0 ? 1.15 : 0.87, agulhaVisivel ? undefined : x);
          } else if (e.altKey || e.shiftKey || Math.abs(e.deltaX) > Math.abs(e.deltaY)) {
            // Alt + Scroll ou Shift + Scroll ou rolagem lateral: navegação horizontal pura (sem zoom e sem scroll vertical)
            e.preventDefault();
            const delta = e.altKey || e.shiftKey ? (e.deltaY !== 0 ? e.deltaY : e.deltaX) : e.deltaX;
            deslocar(delta * 0.75);
          }
          // Scroll normal (sem tecla modificadora): navega verticalmente pelas trilhas sem deslocamento lateral!
        }}
        onMouseUp={(e) => {
          if (arrastandoEixo.current) {
            arrastandoEixo.current = false;
            document.body.style.cursor = '';
            document.body.style.userSelect = '';
            // Se foi apenas um clique no canvas (não arrastou), posiciona a agulha temporal sem abrir popover
            if (!arrastou.current) {
              const caixa = palcoRef.current?.getBoundingClientRect();
              if (caixa) {
                const x = e.clientX - caixa.left;
                if (x >= larguraSidebar) {
                  posicionarAgulhaEmX(x - larguraSidebar);
                }
              }
            }
            setTimeout(() => {
              arrastou.current = false;
            }, 50);
          }
        }}
      >
        {/* 1. Fileira Superior Fixa: Célula de Canto + Régua de Anos */}
        <div className="flex-none h-7 bg-sup border-b border-borda shadow-2xs z-30 flex" style={{ minWidth: larguraSidebar + larguraCanvas }}>
          {/* Célula do Canto Superior Esquerdo */}
          <div
            className="flex-none bg-card border-r-2 border-borda/80 px-2.5 flex items-center justify-between text-[10px] font-bold uppercase tracking-wider text-tinta3 shadow-xs relative select-none"
            style={{ width: larguraSidebar }}
          >
            <span>{t('linhaTempo', 'trilhasHeader')}</span>
            <span className="font-num text-[9px] opacity-75">
              {linhasPessoais.length + ativas.length} {t('linhaTempo', 'ativas')}
            </span>
            {/* Alça do Splitter Vertical na Régua Superior */}
            <div
              onMouseDown={iniciarRedimensionamentoSidebar}
              onDoubleClick={() => setLarguraSidebar(LARGURA_SIDEBAR_PADRAO)}
              className="absolute top-0 bottom-0 -right-1 w-2 hover:bg-acento/80 cursor-col-resize z-50 transition-colors select-none"
              title="Clique e arraste para a esquerda ou direita para ajustar a largura dos nomes das trilhas (duplo-clique para restaurar)"
            />
          </div>

          {/* Régua de Anos com Marcadores Pins e Agulha Fixa */}
          <div
            className="flex-1 relative overflow-hidden h-full cursor-pointer"
            onClick={(e) => {
              const caixa = e.currentTarget.getBoundingClientRect();
              const canvasX = e.clientX - caixa.left;
              if (modoMedicaoDistancia) {
                const anoClicado = anoDaPosicao(canvasX);
                definirPontoMedicao(anoClicado);
              } else {
                posicionarAgulhaEmX(canvasX);
              }
            }}
            onMouseDown={(e) => {
              if ((e.target as HTMLElement).closest('button')) return;
              const caixa = e.currentTarget.getBoundingClientRect();
              const canvasX = e.clientX - caixa.left;
              posicionarAgulhaEmX(canvasX);
              arrastandoAgulha.current = true;
              document.body.style.cursor = 'ew-resize';
            }}
          >
            {/* Subdivisões Terciárias na Régua (Meses / Frações - entalhes finos) */}
            {marcasTerciarias.map((val) => (
              <div
                key={`regua-terc-${val}`}
                className="absolute bottom-0 h-1.5 border-l opacity-40 pointer-events-none"
                style={{ left: posicaoDoAno(val), borderColor: 'var(--borda)' }}
              />
            ))}

            {/* Subdivisões Secundárias na Régua (Anos Intermediários / Trimestres) */}
            {marcasSecundarias.map((ano) => {
              const ehMeioDecada = Math.abs(ano % 5) === 0;
              return (
                <div
                  key={`regua-sub-${ano}`}
                  className={cn(
                    'absolute bottom-0 pointer-events-none border-l',
                    ehMeioDecada ? 'h-3.5 opacity-80' : 'h-2.5 opacity-60'
                  )}
                  style={{ left: posicaoDoAno(ano), borderColor: 'var(--borda)' }}
                />
              );
            })}

            {/* Faixa Sombreada e Caliper da Medição de Distância na Régua */}
            {medicaoDistancia && (
              <>
                <div
                  className="absolute top-0 bottom-0 bg-sky-500/15 border-y border-sky-500/40 pointer-events-none z-10"
                  style={{
                    left: Math.min(posicaoDoAno(medicaoDistancia.de), posicaoDoAno(medicaoDistancia.ate)),
                    width: Math.max(2, Math.abs(posicaoDoAno(medicaoDistancia.ate) - posicaoDoAno(medicaoDistancia.de))),
                  }}
                />

                {/* Caliper / Cota de Distância Centralizada na Régua */}
                {Math.abs(posicaoDoAno(medicaoDistancia.ate) - posicaoDoAno(medicaoDistancia.de)) >= 36 && (
                  <div
                    className="absolute top-1/2 -translate-y-1/2 z-25 flex items-center pointer-events-none select-none"
                    style={{
                      left: Math.min(posicaoDoAno(medicaoDistancia.de), posicaoDoAno(medicaoDistancia.ate)),
                      width: Math.max(2, Math.abs(posicaoDoAno(medicaoDistancia.ate) - posicaoDoAno(medicaoDistancia.de))),
                    }}
                  >
                    <div className="w-1.5 h-3.5 border-l-2 border-sky-500 rounded-l-xs" />
                    <div className="flex-1 h-px bg-sky-500/70 relative flex items-center justify-center">
                      <span className="bg-card/95 px-1.5 py-0.5 rounded text-[10px] font-num font-bold text-sky-600 dark:text-sky-300 border border-sky-500/40 shadow-xs whitespace-nowrap">
                        Δ {calcularDistanciaFormatada(medicaoDistancia.de, medicaoDistancia.ate)}
                      </span>
                    </div>
                    <div className="w-1.5 h-3.5 border-r-2 border-sky-500 rounded-r-xs" />
                  </div>
                )}

                {/* Marcadores de Ponto A e Ponto B na Régua */}
                <div
                  className="absolute top-0 bottom-0 z-35 flex flex-col items-end select-none pointer-events-auto cursor-pointer"
                  style={{ left: posicaoDoAno(medicaoDistancia.de) }}
                  onClick={(e) => {
                    e.stopPropagation();
                    setModoMedicaoDistancia(true);
                  }}
                  title={`Ponto A: ${formatarDataPrecisaNoCalendario(medicaoDistancia.de, spanAnos, calendarioAtivo, ehFicticio ? 'ficticio' : 'real')}${medicaoDistancia.rotuloDe ? ` (${medicaoDistancia.rotuloDe})` : ''}`}
                >
                  <div className="bg-sky-600 hover:bg-sky-500 text-white font-num font-bold text-[9px] px-1.5 py-0.5 rounded-l-xs shadow-md flex items-center gap-0.5 border border-sky-700 whitespace-nowrap transform -translate-x-full">
                    <span>[ A: {formatarAnoAtual(medicaoDistancia.de)}</span>
                  </div>
                  <div className="w-0.5 h-full bg-sky-600 shadow-xs" />
                </div>

                <div
                  className="absolute top-0 bottom-0 z-35 flex flex-col items-start select-none pointer-events-auto cursor-pointer"
                  style={{ left: posicaoDoAno(medicaoDistancia.ate) }}
                  onClick={(e) => {
                    e.stopPropagation();
                    setModoMedicaoDistancia(true);
                  }}
                  title={`Ponto B: ${formatarDataPrecisaNoCalendario(medicaoDistancia.ate, spanAnos, calendarioAtivo, ehFicticio ? 'ficticio' : 'real')}${medicaoDistancia.rotuloAte ? ` (${medicaoDistancia.rotuloAte})` : ''}`}
                >
                  <div className="bg-sky-600 hover:bg-sky-500 text-white font-num font-bold text-[9px] px-1.5 py-0.5 rounded-r-xs shadow-md flex items-center gap-0.5 border border-sky-700 whitespace-nowrap">
                    <span>B: {formatarAnoAtual(medicaoDistancia.ate)} ]</span>
                  </div>
                  <div className="w-0.5 h-full bg-sky-600 shadow-xs" />
                </div>
              </>
            )}

            {/* Marcas Principais na Régua */}
            {marcasDoEixo.map((ano) => (
              <span
                key={ano}
                className="absolute top-0 font-num text-[10px] text-tinta3 font-medium border-l-2 border-borda h-full pl-1 pointer-events-none whitespace-nowrap select-none flex items-center z-10"
                style={{ left: posicaoDoAno(ano) }}
              >
                <span className="bg-sup/90 px-0.5 rounded-xs">
                  {rotulosGrid?.get(ano) ?? formatarAnoAtual(Math.round(ano))}
                </span>
              </span>
            ))}

            {/* Marcador de Alta Precisão: Hoje (Data do Sistema Operacional) */}
            {janela.de <= HOJE_CONTINUO && HOJE_CONTINUO <= janela.ate && (
              <div
                className="absolute top-0 bottom-0 pointer-events-none z-25 flex flex-col items-center select-none"
                style={{ left: posicaoDoAno(HOJE_CONTINUO), transform: 'translateX(-50%)' }}
                title={`Hoje: ${formatarDataPrecisaNoCalendario(HOJE_CONTINUO, 0.1, calendarioAtivo, ehFicticio ? 'ficticio' : 'real')}`}
              >
                <div className="bg-emerald-600 text-white font-num font-bold text-[8.5px] px-1.5 py-0.2 rounded-xs shadow-xs uppercase tracking-wider flex items-center gap-0.5 border border-emerald-700">
                  <span>Hoje</span>
                </div>
                <div className="w-0.5 flex-1 bg-emerald-500/80 shadow-xs" />
              </div>
            )}

            {/* Marcadores Temporais na Régua (Bandeiras / Pins) */}
            {marcadoresTimeline.map((mk) => {
              const posX = posicaoDoAno(mk.ano);
              const corHex = COR_MARCADOR_MAP[mk.cor] ?? '#3b82f6';
              return (
                <button
                  key={mk.id}
                  type="button"
                  className="absolute top-0 bottom-0 flex items-center cursor-pointer group z-20 px-0.5 border-none bg-transparent"
                  style={{ left: posX, transform: 'translateX(-50%)' }}
                  onClick={(e) => {
                    e.stopPropagation();
                    setMarcadorParaEditar(mk);
                    setModalMarcadorAberto(true);
                  }}
                  title={`${mk.titulo} (${formatarAnoAtual(mk.ano)})${mk.comentario ? ` — ${mk.comentario}` : ''}`}
                >
                  <div
                    className="w-3.5 h-3.5 rounded-xs flex items-center justify-center text-[9px] shadow-xs group-hover:scale-125 transition-transform"
                    style={{ backgroundColor: corHex }}
                  >
                    <Bookmark className="w-2.5 h-2.5 text-white fill-white" />
                  </div>
                </button>
              );
            })}

            {/* Agulha Fixa Temporal (Cabeçote do Playhead) */}
            <div
              className="absolute top-0 bottom-0 z-40 transform -translate-x-1/2 flex flex-col items-center cursor-pointer group select-none"
              style={{ left: posicaoDoAno(agulhaAno) }}
              onClick={(e) => {
                e.stopPropagation();
                setGuiaTemporalAberto((prev) => !prev);
              }}
              onMouseDown={(e) => {
                e.stopPropagation();
                arrastandoAgulha.current = true;
                document.body.style.cursor = 'ew-resize';
              }}
              title={`Agulha Temporal: ${formatarDataPrecisaNoCalendario(agulhaAno, spanAnos, calendarioAtivo, ehFicticio ? 'ficticio' : 'real')} (Clique para abrir/fechar o Guia Temporal ou arraste)`}
            >
              <div className="bg-rose-600 hover:bg-rose-500 text-white font-num font-bold text-[10px] px-2 py-0.5 rounded-t-xs shadow-md flex items-center gap-1 border border-rose-700">
                <span className="text-[9px]">📍</span>
                <span>{formatarDataPrecisaNoCalendario(agulhaAno, spanAnos, calendarioAtivo, ehFicticio ? 'ficticio' : 'real')}</span>
              </div>
              <div className="w-0 h-0 border-l-[4px] border-l-transparent border-r-[4px] border-r-transparent border-t-[4px] border-t-rose-600" />
            </div>

            {/* Cursor Fantasma de Hover */}
            {cursorX !== null &&
              cursorAno !== null &&
              Math.abs(cursorX - posicaoDoAno(agulhaAno)) >= 24 && (
                <div
                  className={cn(
                    'absolute top-0.5 pointer-events-none z-30 transform -translate-x-1/2 px-2 py-0.5 rounded-b-xs font-num font-bold text-[10.5px] shadow-md whitespace-nowrap select-none flex items-center gap-1 border',
                    estaSnappado
                      ? 'bg-amber-600 text-white border-amber-700 ring-1 ring-amber-400/50'
                      : 'bg-card text-tinta border-borda shadow-md'
                  )}
                  style={{ left: cursorX }}
                >
                  {estaSnappado && <span className="text-[9px]">🧲</span>}
                  <span>{formatarDataPrecisaNoCalendario(cursorAno, spanAnos, calendarioAtivo, ehFicticio ? 'ficticio' : 'real')}</span>
                </div>
              )}
          </div>
        </div>

        {/* 2. SEÇÃO: Vidas na Árvore (Painel Superior com Rolagem Interna estilo DaVinci Resolve) */}
        {/* 2. SEÇÃO: Vidas na Árvore (Painel Superior com Rolagem Interna estilo DaVinci Resolve) */}
        <div
          ref={painelVidasRef}
          className="flex-1 min-h-[58px] overflow-y-auto overflow-x-hidden relative scrollbar-fino"
        >
          <div className="relative min-h-full" style={{ minWidth: larguraSidebar + larguraCanvas }}>
              {/* Grade de Fundo Vertical */}
              <div
                className="absolute top-5 bottom-0 pointer-events-none overflow-hidden z-0"
                style={{ left: larguraSidebar, width: larguraCanvas }}
                aria-hidden
              >
                {/* Nível 3: Linhas Terciárias no Fundo das Vidas (Meses / Frações - delicadas e pontilhadas) */}
                {marcasTerciarias.map((val) => (
                  <div
                    key={`grade-terc-vidas-${val}`}
                    className="absolute top-0 bottom-0 border-l border-dotted opacity-30 pointer-events-none"
                    style={{ left: posicaoDoAno(val), borderColor: 'var(--borda)' }}
                  />
                ))}
                {/* Nível 2: Linhas Secundárias no Fundo das Vidas (Anos Intermediários Não Numerados - linha sólida sutil e nítida) */}
                {marcasSecundarias.map((ano) => (
                  <div
                    key={`grade-sub-vidas-${ano}`}
                    className="absolute top-0 bottom-0 border-l border-solid opacity-45 pointer-events-none"
                    style={{ left: posicaoDoAno(ano), borderColor: 'var(--borda)' }}
                  />
                ))}
                {/* Nível 1: Linhas Principais no Fundo das Vidas (Anos Numerados - tracejada de destaque) */}
                {marcasDoEixo.map((ano) => (
                  <div
                    key={`grade-vidas-${ano}`}
                    className="absolute top-0 bottom-0 border-l border-dashed opacity-65 pointer-events-none"
                    style={{ left: posicaoDoAno(ano), borderColor: 'var(--borda2)' }}
                  />
                ))}
                {/* Destaque da Região de Medição Temporal nas Vidas */}
                {medicaoDistancia && (
                  <div
                    className="absolute top-0 bottom-0 border-x border-dashed border-sky-500/40 bg-sky-500/[0.05] pointer-events-none"
                    style={{
                      left: Math.min(posicaoDoAno(medicaoDistancia.de), posicaoDoAno(medicaoDistancia.ate)),
                      width: Math.max(2, Math.abs(posicaoDoAno(medicaoDistancia.ate) - posicaoDoAno(medicaoDistancia.de))),
                    }}
                  />
                )}
                {/* Linha Vertical de Hoje no Fundo das Vidas (Sincronizada com SO) */}
                {janela.de <= HOJE_CONTINUO && HOJE_CONTINUO <= janela.ate && (
                  <div
                    key="linha-hoje-vidas"
                    className="absolute top-0 bottom-0 border-l-2 border-dashed border-emerald-500/70 pointer-events-none z-1"
                    style={{ left: posicaoDoAno(HOJE_CONTINUO) }}
                  />
                )}
              </div>

              {/* Camada Vertical de Agulha Fixa, Marcadores e Cursor Fantasma */}
              <div
                className="absolute top-5 bottom-0 pointer-events-none overflow-hidden z-5"
                style={{ left: larguraSidebar, width: larguraCanvas }}
                aria-hidden
              >
                {marcadoresTimeline.map((mk) => {
                  const corHex = COR_MARCADOR_MAP[mk.cor] ?? '#3b82f6';
                  return (
                    <div
                      key={`linha-marcador-vidas-${mk.id}`}
                      className="absolute top-0 bottom-0 border-l border-dotted opacity-60"
                      style={{ left: posicaoDoAno(mk.ano), borderColor: corHex }}
                    />
                  );
                })}
                <div
                  className="absolute top-0 bottom-0 border-l-2 border-rose-600 shadow-[0_0_8px_rgba(225,29,72,0.45)]"
                  style={{ left: posicaoDoAno(agulhaAno) }}
                />
                {cursorX !== null && Math.abs(cursorX - posicaoDoAno(agulhaAno)) >= 10 && (
                  <div
                    className={cn(
                      'absolute top-0 bottom-0 transition-colors',
                      estaSnappado
                        ? 'border-l-2 border-dashed border-amber-500 shadow-xs'
                        : 'border-l border-dashed border-borda2/60'
                    )}
                    style={{ left: cursorX }}
                  />
                )}
              </div>

              {/* Cabeçalho Fixo da Seção de Vidas */}
              <div className="sticky top-0 z-20 flex h-5 border-b border-borda/40 bg-sup/95">
                <div
                  className="sticky left-0 z-30 flex-none px-2.5 text-[9.5px] font-bold text-tinta3 uppercase tracking-wider flex items-center justify-between bg-card border-r-2 border-borda/80 shadow-2xs"
                  style={{ width: larguraSidebar }}
                >
                  <span className="flex items-center gap-1">
                    <User className="w-2.5 h-2.5 text-acento" />
                    <span>{t('linhaTempo', 'trilhasPessoais')}</span>
                  </span>
                  <div className="flex items-center gap-1.5">
                    <button
                      type="button"
                      onClick={ordenarPorAnoNascimento}
                      className="text-[8.5px] lowercase font-medium text-tinta3 hover:text-acento transition-colors flex items-center gap-0.5 cursor-pointer px-1 py-0.5 rounded hover:bg-sup"
                      title={t('linhaTempo', 'ordenarPorAnoTitle')}
                    >
                      <ArrowUpDown className="w-2.5 h-2.5" />
                      <span>{t('linhaTempo', 'porAno')}</span>
                    </button>
                    <span className="font-num text-[9px] opacity-75">{linhasPessoais.length}</span>
                  </div>
                </div>
                <div className="flex-1" />
              </div>

              {/* Raias de Vidas ou Placeholder de Adicionar */}
              {linhasPessoais.length === 0 ? (
                <div
                  className="flex items-center group/vazio-vidas cursor-pointer transition-colors hover:bg-acento/[0.04] border-b border-borda/40 select-none"
                  style={{ height: 38 }}
                  onClick={() => setModalCompararAberto(true)}
                  title={t('linhaTempo', 'compararVidasModal')}
                >
                  {/* Sidebar do Placeholder */}
                  <div
                    className="sticky left-0 z-10 flex-none h-full px-2.5 flex items-center justify-between bg-card/85 border-r-2 border-dashed border-borda group-hover/vazio-vidas:border-acento/60 transition-colors"
                    style={{ width: larguraSidebar }}
                  >
                    <div className="flex items-center gap-2 text-xs text-tinta3 group-hover/vazio-vidas:text-acento font-medium transition-colors">
                      <div className="w-5 h-5 rounded-full border border-dashed border-borda flex items-center justify-center group-hover/vazio-vidas:border-acento group-hover/vazio-vidas:bg-acento/10">
                        <Plus className="w-3 h-3 text-tinta3 group-hover/vazio-vidas:text-acento" />
                      </div>
                      <span>{t('linhaTempo', 'adicionarVidaArvore')}</span>
                    </div>
                  </div>

                  {/* Canvas do Placeholder */}
                  <div
                    className="flex-1 h-full border-b border-dashed border-borda/40 flex items-center px-4"
                    style={{ width: larguraCanvas }}
                  >
                    <div className="flex items-center gap-2 text-[11px] text-tinta3/70 group-hover/vazio-vidas:text-acento/90 transition-colors font-medium select-none">
                      <UserPlus className="w-3.5 h-3.5 text-acento/60" />
                      <span>{t('linhaTempo', 'cliqueParaAdicionarVidas')}</span>
                    </div>
                  </div>
                </div>
              ) : (
                linhasPessoais.map((lp, idx) => {
                const visivel = visibilidadeTrilhas[lp.pessoa_id] !== false;
                const ehSelecionado = lp.pessoa_id === pessoaSelecionadaId;
                const estaArrastando = idArrastando === lp.pessoa_id;
                const posicaoDrop = dropAlvo?.id === lp.pessoa_id ? dropAlvo.posicao : null;
                const nasceu = lp.ano_nascimento;
                const terminou = lp.ano_falecimento ?? (lp.is_vivo ? HOJE_CONTINUO : null);
                const anosTotais = nasceu != null && terminou != null ? Math.max(0, Math.floor(terminou - nasceu)) : null;
                const subtitulo = nasceu
                  ? `${formatarAnoAtual(nasceu)} – ${lp.ano_falecimento != null ? formatarAnoAtual(lp.ano_falecimento) : lp.is_vivo ? t('linhaTempo', 'hoje') : '?'} (${anosTotais ?? '?'}a)`
                  : t('linhaTempo', 'semData');

                const alturaEfetiva = obterAlturaTrilha(lp.pessoa_id);
                const menuAberto = idMenuCorAberto === lp.pessoa_id;

                return (
                  <div
                    key={`trilha-vida-${lp.pessoa_id}`}
                    data-pessoa-id={lp.pessoa_id}
                    onDragOver={(e) => handleDragOver(lp.pessoa_id, e)}
                    onDragLeave={(e) => handleDragLeave(lp.pessoa_id, e)}
                    onDrop={(e) => handleDrop(lp.pessoa_id, e)}
                    className={cn(
                      'flex relative border-b border-borda/50 hover:bg-sup/20 transition-colors',
                      menuAberto ? 'z-50' : 'z-10',
                      ehSelecionado && 'bg-acento/5',
                      posicaoDrop === 'antes' && 'border-t-2 border-t-acento',
                      posicaoDrop === 'depois' && 'border-b-2 border-b-acento',
                    )}
                    style={{ height: alturaEfetiva }}
                  >
                    {/* Track Header Fixo */}
                    <div className={cn("sticky left-0 flex-none bg-card shadow-xs", menuAberto ? "z-50" : "z-30")}>
                      <CabecalhoTrilha
                        identificador={`P${idx + 1}`}
                        tipo="pessoal"
                        titulo={lp.nome}
                        subtitulo={subtitulo}
                        cor={obterCorTrilha(lp.pessoa_id, lp.sexo)}
                        corPersonalizada={coresPersonalizadas[lp.pessoa_id] ?? null}
                        onMudarCor={(cor) => definirCorPessoa(lp.pessoa_id, cor)}
                        altura={alturaEfetiva}
                        largura={larguraSidebar}
                        onRedimensionarLargura={iniciarRedimensionamentoSidebar}
                        onRedimensionarAltura={(e) => iniciarRedimensionamentoAlturaTrilha(lp.pessoa_id, e)}
                        onResetarAltura={(e) => resetarAlturaTrilha(lp.pessoa_id, e)}
                        abrirMenuParaCima={idx >= Math.max(1, linhasPessoais.length - 2)}
                        menuCorAberto={menuAberto}
                        onAlternarMenuCor={(aberto) => setIdMenuCorAberto(aberto ? lp.pessoa_id : null)}
                        compacto={modoAltura === 'compacto'}
                        visivel={visivel}
                        selecionado={ehSelecionado}
                        arrastavel={true}
                        estaArrastando={estaArrastando}
                        posicaoDrop={posicaoDrop}
                        onArrastarInicio={(e) => handleDragStart(lp.pessoa_id, e)}
                        onArrastarSobre={(e) => handleDragOver(lp.pessoa_id, e)}
                        onArrastarSair={(e) => handleDragLeave(lp.pessoa_id, e)}
                        onSoltar={(e) => handleDrop(lp.pessoa_id, e)}
                        onArrastarFim={handleDragEnd}
                        onMoverCima={idx > 0 ? () => moverParaCima(lp.pessoa_id) : undefined}
                        onMoverBaixo={idx < linhasPessoais.length - 1 ? () => moverParaBaixo(lp.pessoa_id) : undefined}
                        onToggleVisibilidade={() => toggleVisibilidadeTrilha(lp.pessoa_id)}
                        onFocar={() => enquadrarVida(lp)}
                        onAbrirFicha={onAbrirFicha ? () => onAbrirFicha(lp.pessoa_id) : undefined}
                        onAdicionarEvento={() => {
                          setPessoaAlvoEventoVida(lp.pessoa_id);
                          setModalEventoVidaAberto(true);
                        }}
                        onRemover={() => removerVida(lp.pessoa_id)}
                      />
                    </div>

                    {/* Raia Temporal de Vida (Canvas) */}
                    <div className="flex-1 relative h-full overflow-hidden">
                      {posicaoDrop === 'antes' && (
                        <div className="absolute top-0 left-0 right-0 h-0.5 bg-acento z-50 shadow-[0_0_8px_var(--acento)] pointer-events-none" />
                      )}
                      {posicaoDrop === 'depois' && (
                        <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-acento z-50 shadow-[0_0_8px_var(--acento)] pointer-events-none" />
                      )}
                      {visivel && (
                        <FaixaDaVida
                          linha={lp}
                          posicaoDoAno={posicaoDoAno}
                          larguraCanvas={larguraCanvas}
                          cor={obterCorTrilha(lp.pessoa_id, lp.sexo)}
                          altura={alturaEfetiva}
                          compacto={modoAltura === 'compacto'}
                          mostrarOcultos={mostrarOcultos}
                          onAbrirMarco={abrirMarco}
                          onAbrirEventoPessoal={abrirEventoPessoal}
                          onFocar={() => enquadrarVida(lp)}
                          onPosicionarAgulha={posicionarAgulhaEmX}
                          formatarAno={formatarAnoAtual}
                        />
                      )}
                    </div>
                  </div>
                );
              })
            )}
            </div>
          </div>

        {/* Divisor de Seções Estilo DaVinci Resolve (Fixo e Redimensionável entre Vidas e Contexto) */}
        <div
          className="flex-none h-6 bg-card border-y-2 border-borda/80 z-20 flex items-center select-none relative shadow-2xs group"
          style={{ minWidth: larguraSidebar + larguraCanvas }}
        >
            {/* Lado Esquerdo (Sidebar) */}
            <div
              className="flex-none px-2.5 h-full flex items-center justify-between bg-card border-r-2 border-borda/80 text-[10px] font-bold text-tinta3 uppercase tracking-wider select-none"
              style={{ width: larguraSidebar }}
            >
              <span className="flex items-center gap-1">
                <IconeLinhaTempo className="w-3 h-3 text-acento" />
                <span>{t('linhaTempo', 'trilhasContexto')}</span>
              </span>
              <span className="font-num text-[9px] px-1.5 py-0.2 rounded-full bg-sup border border-borda font-bold text-tinta3">
                {ativas.length}
              </span>
            </div>

            {/* Barra Central do Divisor (Canvas com alça de redimensionamento estilo DaVinci Resolve) */}
            <div
              className="flex-1 h-full flex items-center justify-center relative cursor-row-resize hover:bg-acento/10 transition-colors"
              onMouseDown={iniciarRedimensionamentoDivisor}
              onDoubleClick={resetarAlturaContexto}
              title="Arraste para ajustar a divisão entre Vidas na Árvore e Linhas de Contexto (duplo clique para restaurar padrão)"
            >
              {/* Linha da Agulha Fixa cruzando o divisor */}
              <div
                className="absolute top-0 bottom-0 border-l-2 border-rose-600 shadow-[0_0_6px_rgba(225,29,72,0.45)] pointer-events-none"
                style={{ left: posicaoDoAno(agulhaAno) }}
              />
              {/* Alça visual de NLE */}
              <div className="flex items-center gap-1.5 opacity-40 group-hover:opacity-100 group-hover:text-acento transition-opacity">
                <div className="w-8 h-0.5 bg-current rounded-full" />
                <div className="w-1.5 h-1.5 bg-current rounded-full" />
                <div className="w-8 h-0.5 bg-current rounded-full" />
              </div>
            </div>
          </div>

        {/* 3. SEÇÃO: Linhas de Contexto (Fixa na parte inferior, sempre visível estilo DaVinci Resolve) */}
        <div
          ref={painelContextoRef}
          className="flex-none overflow-y-auto overflow-x-hidden relative scrollbar-fino"
          style={{
            height: alturaSecaoContexto ?? alturaPadraoContexto,
            maxHeight: '48%',
            minHeight: 46,
          }}
        >
            <div className="relative min-h-full" style={{ minWidth: larguraSidebar + larguraCanvas }}>
              {/* Grade de Fundo Vertical */}
              <div
                className="absolute top-0 bottom-0 pointer-events-none overflow-hidden z-0"
                style={{ left: larguraSidebar, width: larguraCanvas }}
                aria-hidden
              >
                {/* Nível 3: Linhas Terciárias no Fundo do Contexto (Meses / Frações) */}
                {marcasTerciarias.map((val) => (
                  <div
                    key={`grade-terc-contexto-${val}`}
                    className="absolute top-0 bottom-0 border-l border-dotted opacity-30 pointer-events-none"
                    style={{ left: posicaoDoAno(val), borderColor: 'var(--borda)' }}
                  />
                ))}
                {/* Nível 2: Linhas Secundárias no Fundo do Contexto (Anos Intermediários Não Numerados) */}
                {marcasSecundarias.map((ano) => (
                  <div
                    key={`grade-sub-contexto-${ano}`}
                    className="absolute top-0 bottom-0 border-l border-solid opacity-45 pointer-events-none"
                    style={{ left: posicaoDoAno(ano), borderColor: 'var(--borda)' }}
                  />
                ))}
                {/* Nível 1: Linhas Principais no Fundo do Contexto (Anos Numerados) */}
                {marcasDoEixo.map((ano) => (
                  <div
                    key={`grade-contexto-${ano}`}
                    className="absolute top-0 bottom-0 border-l border-dashed opacity-65 pointer-events-none"
                    style={{ left: posicaoDoAno(ano), borderColor: 'var(--borda2)' }}
                  />
                ))}
                {/* Destaque da Região de Medição Temporal no Contexto */}
                {medicaoDistancia && (
                  <div
                    className="absolute top-0 bottom-0 border-x border-dashed border-sky-500/40 bg-sky-500/[0.05] pointer-events-none"
                    style={{
                      left: Math.min(posicaoDoAno(medicaoDistancia.de), posicaoDoAno(medicaoDistancia.ate)),
                      width: Math.max(2, Math.abs(posicaoDoAno(medicaoDistancia.ate) - posicaoDoAno(medicaoDistancia.de))),
                    }}
                  />
                )}
                {/* Linha Vertical de Hoje no Fundo do Contexto (Sincronizada com SO) */}
                {janela.de <= HOJE_CONTINUO && HOJE_CONTINUO <= janela.ate && (
                  <div
                    key="linha-hoje-contexto"
                    className="absolute top-0 bottom-0 border-l-2 border-dashed border-emerald-500/70 pointer-events-none z-1"
                    style={{ left: posicaoDoAno(HOJE_CONTINUO) }}
                  />
                )}
              </div>

              {/* Camada Vertical de Agulha Fixa, Marcadores e Cursor Fantasma */}
              <div
                className="absolute top-0 bottom-0 pointer-events-none overflow-hidden z-5"
                style={{ left: larguraSidebar, width: larguraCanvas }}
                aria-hidden
              >
                {marcadoresTimeline.map((mk) => {
                  const corHex = COR_MARCADOR_MAP[mk.cor] ?? '#3b82f6';
                  return (
                    <div
                      key={`linha-marcador-contexto-${mk.id}`}
                      className="absolute top-0 bottom-0 border-l border-dotted opacity-60"
                      style={{ left: posicaoDoAno(mk.ano), borderColor: corHex }}
                    />
                  );
                })}
                <div
                  className="absolute top-0 bottom-0 border-l-2 border-rose-600 shadow-[0_0_8px_rgba(225,29,72,0.45)]"
                  style={{ left: posicaoDoAno(agulhaAno) }}
                />
                {cursorX !== null && Math.abs(cursorX - posicaoDoAno(agulhaAno)) >= 10 && (
                  <div
                    className={cn(
                      'absolute top-0 bottom-0 transition-colors',
                      estaSnappado
                        ? 'border-l-2 border-dashed border-amber-500 shadow-xs'
                        : 'border-l border-dashed border-borda2/60'
                    )}
                    style={{ left: cursorX }}
                  />
                )}
              </div>

              {/* Raias de Linhas de Contexto ou Placeholder de Adicionar */}
              {ativas.length === 0 ? (
                <div
                  className="flex items-center group/vazio-ctx cursor-pointer transition-colors hover:bg-acento/[0.04] border-b border-borda/40 select-none"
                  style={{ height: 38 }}
                  onClick={() => setModalCatalogoAberto(true)}
                  title="Clique para adicionar linhas de contexto histórico"
                >
                  {/* Sidebar do Placeholder */}
                  <div
                    className="sticky left-0 z-10 flex-none h-full px-2.5 flex items-center justify-between bg-card/85 border-r-2 border-dashed border-borda group-hover/vazio-ctx:border-acento/60 transition-colors"
                    style={{ width: larguraSidebar }}
                  >
                    <div className="flex items-center gap-2 text-xs text-tinta3 group-hover/vazio-ctx:text-acento font-medium transition-colors">
                      <div className="w-5 h-5 rounded-full border border-dashed border-borda flex items-center justify-center group-hover/vazio-ctx:border-acento group-hover/vazio-ctx:bg-acento/10">
                        <Plus className="w-3 h-3 text-tinta3 group-hover/vazio-ctx:text-acento" />
                      </div>
                      <span>Adicionar linha de contexto</span>
                    </div>
                  </div>

                  {/* Canvas do Placeholder */}
                  <div
                    className="flex-1 h-full border-b border-dashed border-borda/40 flex items-center px-4"
                    style={{ width: larguraCanvas }}
                  >
                    <div className="flex items-center gap-2 text-[11px] text-tinta3/70 group-hover/vazio-ctx:text-acento/90 transition-colors font-medium select-none">
                      <Compass className="w-3.5 h-3.5 text-acento/60" />
                      <span>+ Clique aqui ou em "Linhas de Contexto..." para adicionar marcos históricos</span>
                    </div>
                  </div>
                </div>
              ) : (
                ativas.map((linhaId, idx) => {
                const linha = linhas?.find((l) => l.id === linhaId);
                const cor = coresPersonalizadas[linhaId] ?? corDa(linha?.categoria);
                const daLinha = marcosPorLinha.get(linhaId) ?? [];
                const visivel = visibilidadeTrilhas[linhaId] !== false;
                const alturaEfetiva = obterAlturaTrilha(linhaId);
                const menuAberto = idMenuCorAberto === linhaId;
                const posicionados = calcularSubLanesContexto(
                  daLinha,
                  posicaoDoAno,
                  1,
                  escala,
                );

                return (
                  <div
                    key={`trilha-contexto-${linhaId}`}
                    data-linha-id={linhaId}
                    className={cn(
                      'flex relative border-b border-borda/50 hover:bg-sup/20 transition-colors',
                      menuAberto ? 'z-50' : 'z-10',
                    )}
                    style={{ height: alturaEfetiva }}
                  >
                    {/* Track Header Fixo */}
                    <div className={cn("sticky left-0 flex-none bg-card shadow-xs", menuAberto ? "z-50" : "z-30")}>
                      <CabecalhoTrilha
                        identificador={`C${idx + 1}`}
                        tipo="contexto"
                        titulo={linha?.titulo ?? linhaId}
                        subtitulo={`${linha?.marcos_alta ?? 0} marcos · ${linha?.categoria ?? 'história'}`}
                        cor={cor}
                        corPersonalizada={coresPersonalizadas[linhaId] ?? null}
                        onMudarCor={(novaCor) => definirCorPessoa(linhaId, novaCor)}
                        altura={alturaEfetiva}
                        largura={larguraSidebar}
                        onRedimensionarLargura={iniciarRedimensionamentoSidebar}
                        onRedimensionarAltura={(e) => iniciarRedimensionamentoAlturaTrilha(linhaId, e)}
                        onResetarAltura={(e) => resetarAlturaTrilha(linhaId, e)}
                        compacto={modoAltura === 'compacto'}
                        bloqueada={linha?.is_bloqueada}
                        visivel={visivel}
                        menuCorAberto={menuAberto}
                        onAlternarMenuCor={(aberto) => setIdMenuCorAberto(aberto ? linhaId : null)}
                        abrirMenuParaCima={idx >= Math.max(0, ativas.length - 1)}
                        onToggleVisibilidade={() => toggleVisibilidadeTrilha(linhaId)}
                        onFocar={() => {
                          if (linha?.ano_min != null && linha?.ano_max != null) {
                            const span = Math.max(10, linha.ano_max - linha.ano_min);
                            const margem = Math.max(5, Math.round(span * 0.1));
                            setJanela({ de: linha.ano_min - margem, ate: linha.ano_max + margem });
                          }
                        }}
                        onAdicionarMarco={() => {
                          setLinhaAlvoMarco(linhaId);
                          setMarcoEditando('novo');
                        }}
                        onConfigurar={() => setLinhaEditando(linhaId)}
                        onRemover={() => alternarLinha(linhaId)}
                      />
                    </div>

                    {/* Raia Temporal de Contexto */}
                    <div className="flex-1 relative h-full overflow-hidden">
                      {visivel && posicionados.length === 0 && (
                        <div className="h-full flex items-center px-4 gap-3">
                          <span className="text-xs text-tinta3 italic select-none">
                            Esta linha de contexto ainda não possui marcos cadastrados.
                          </span>
                          {!linha?.is_bloqueada && (
                            <button
                              type="button"
                              onClick={() => {
                                setLinhaAlvoMarco(linhaId);
                                setMarcoEditando('novo');
                              }}
                              className="px-2.5 py-1 text-xs bg-acento/10 hover:bg-acento text-acento hover:text-acento-tinta font-semibold rounded-raio-s border border-acento/40 flex items-center gap-1.5 cursor-pointer transition-colors shadow-2xs"
                            >
                              <Plus className="w-3.5 h-3.5" />
                              <span>+ Adicionar primeiro marco</span>
                            </button>
                          )}
                        </div>
                      )}
                      {visivel &&
                        posicionados.map(({ marco, subLane, temRotulo, x, intervalo, larguraBarra }) => {
                          const ehSelecionado = marcoAberto?.id === marco.id;
                          const topOffset = modoAltura === 'compacto' ? 4 : (subLane === 0 ? 6 : 32);

                          return (
                            <button
                              key={marco.id}
                              type="button"
                              onMouseDown={(e) => {
                                e.stopPropagation();
                                arrastou.current = false;
                              }}
                              onClick={(e) => {
                                e.stopPropagation();
                                abrirMarco(marco);
                              }}
                              className="absolute z-20 flex items-center gap-1 group text-left cursor-pointer border-none bg-transparent p-0"
                              style={{ left: x, top: topOffset }}
                              title={`${marco.titulo} (${marco.data_periodo_texto})${marco.descricao ? `\n\n${marco.descricao}` : ''}`}
                            >
                              {intervalo ? (
                                <div
                                  className={cn(
                                    'h-6 rounded-raio-s px-2 text-[11px] font-sans transition-all flex items-center shadow-xs border truncate',
                                    ehSelecionado
                                      ? 'bg-acento text-acento-tinta font-bold ring-2 ring-acento/40 shadow-sm border-acento z-20'
                                      : 'hover:opacity-90 text-white z-10'
                                  )}
                                  style={{
                                    width: Math.max(8, larguraBarra),
                                    backgroundColor: ehSelecionado ? undefined : cor,
                                    borderColor: ehSelecionado ? undefined : cor,
                                  }}
                                >
                                  {temRotulo && <span className="truncate">{marco.titulo}</span>}
                                </div>
                              ) : temRotulo ? (
                                <div
                                  className={cn(
                                    'px-1.5 py-0.5 rounded-raio-s text-[11px] font-sans transition-all flex items-center gap-1 max-w-[240px] truncate shadow-xs border bg-card',
                                    ehSelecionado
                                      ? 'bg-acento text-acento-tinta font-bold ring-2 ring-acento/40 shadow-sm border-acento z-20'
                                      : 'hover:bg-card2 border-borda/80 hover:border-acento hover:shadow-xs text-tinta z-10'
                                  )}
                                  style={{
                                    borderLeftWidth: ehSelecionado ? undefined : 3,
                                    borderLeftColor: ehSelecionado ? undefined : cor,
                                  }}
                                >
                                  <span
                                    className="w-1.5 h-1.5 rounded-full flex-none"
                                    style={{
                                      backgroundColor: ehSelecionado ? 'currentColor' : cor,
                                    }}
                                  />
                                  <span className="truncate">{marco.titulo}</span>
                                </div>
                              ) : (
                                <div className="relative flex items-center justify-center p-1 min-w-[20px] min-h-[22px]">
                                  <span
                                    className="block w-2 h-4 rounded-full opacity-80 group-hover:opacity-100 group-hover:w-2.5 group-hover:scale-125 transition-all shadow-xs"
                                    style={{ backgroundColor: cor }}
                                  />
                                </div>
                              )}
                            </button>
                          );
                        })}
                    </div>
                  </div>
                );
              })
            )}
            </div>
          </div>
      </div>

      {/* Popover Estável do Guia Temporal (Fixado e Ancorado à Agulha Temporal) */}
      {guiaTemporalAberto && (
        <div
          ref={caixaGuiaRef}
          className="absolute z-50 p-3 rounded-raio-m border-2 border-borda bg-card shadow-2xl text-xs flex flex-col gap-2 min-w-[280px] max-w-[320px] transition-[left] duration-150 ease-out select-none"
          style={{
            left: posicaoGuiaAgulha.left,
            top: posicaoGuiaAgulha.top,
            maxHeight: Math.max(200, alturaTotal - 90),
          }}
        >
          {/* Seta indicadora apontando para o cabeçote da agulha temporal */}
          <div
            className="absolute -top-2 w-3.5 h-3.5 bg-card border-t-2 border-l-2 border-borda transform rotate-45"
            style={{ left: posicaoGuiaAgulha.setaLeft - 7 }}
          />

          {/* Cabeçalho do Ano e Ações */}
          <div className="flex items-center justify-between border-b border-borda/70 pb-1.5 gap-2">
            <div className="flex items-center gap-1.5 min-w-0 flex-1">
              <span className="font-tit font-bold text-tinta text-[15px] tracking-wide flex items-center gap-1.5 flex-wrap">
                <span>📍</span>
                <span>{descreverDataComDetalhes(agulhaAno, spanAnos, calendarioAtivo, ehFicticio ? 'ficticio' : 'real').principal}</span>
                {descreverDataComDetalhes(agulhaAno, spanAnos, calendarioAtivo, ehFicticio ? 'ficticio' : 'real').secundario && (
                  <span className="text-[10.5px] font-normal text-tinta3 font-sans">
                    ({descreverDataComDetalhes(agulhaAno, spanAnos, calendarioAtivo, ehFicticio ? 'ficticio' : 'real').secundario})
                  </span>
                )}
              </span>
              {marcadorNaAgulha && (
                <span className="text-[9.5px] px-1.5 py-0.2 rounded font-sans font-bold bg-amber-500/20 text-amber-900 dark:text-amber-200 border border-amber-500/40 flex items-center gap-0.5 truncate max-w-[120px]">
                  <Bookmark className="w-2.5 h-2.5 fill-amber-500 text-amber-500 flex-none" />
                  <span className="truncate">{marcadorNaAgulha.titulo}</span>
                </span>
              )}
            </div>

            <div className="flex items-center gap-1 flex-none">
              <button
                type="button"
                onClick={() => {
                  setMarcadorParaEditar(marcadorNaAgulha);
                  setModalMarcadorAberto(true);
                }}
                className="px-1.5 py-0.5 rounded text-[10px] font-semibold bg-sup hover:bg-acento/10 hover:text-acento text-tinta border border-borda transition-colors cursor-pointer flex items-center gap-1"
                title="Criar ou editar marcador anotado neste ano"
              >
                <Bookmark className="w-3 h-3" />
                <span>{marcadorNaAgulha ? 'Editar' : 'Marcar'}</span>
              </button>

              <button
                type="button"
                onClick={() => setGuiaTemporalAberto(false)}
                className="p-1 rounded text-tinta3 hover:text-tinta hover:bg-sup transition-colors cursor-pointer"
                title="Fechar Guia Temporal (Esc)"
                aria-label="Fechar Guia Temporal"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </div>
          </div>

          {/* Comentário do Marcador (se houver) */}
          {marcadorNaAgulha?.comentario && (
            <div className="p-1.5 rounded-raio-s bg-amber-500/15 border border-amber-500/40 text-amber-900 dark:text-amber-200 flex flex-col gap-0.5">
              <p className="m-0 text-[11px] leading-tight opacity-90 italic">
                "{marcadorNaAgulha.comentario}"
              </p>
            </div>
          )}

          {/* Vidas Ativas e Idades */}
          {linhasPessoais.length > 0 && (
            <div className="flex flex-col gap-1">
              <div className="flex items-center justify-between">
                <span className="text-[9.5px] font-bold text-tinta3 uppercase tracking-wider">
                  {t('linhaTempo', 'idadesNesteAno')}
                </span>
                <span className="text-[10px] text-tinta3 font-medium">
                  {vivosNaAgulhaCount} {vivosNaAgulhaCount === 1 ? 'viva' : 'vivas'}
                </span>
              </div>
              <div className="flex flex-col gap-1 max-h-[150px] overflow-y-auto pr-1 select-auto">
                {linhasPessoais.map((lp) => {
                  const cor = obterCorTrilha(lp.pessoa_id, lp.sexo);
                  if (!lp.ano_nascimento) {
                    return (
                      <div
                        key={lp.pessoa_id}
                        onClick={() => enquadrarVida(lp)}
                        className="flex items-center justify-between text-[11px] gap-2 p-1 -mx-1 rounded hover:bg-sup/80 cursor-pointer transition-colors"
                        title={`Clique para focar na vida de ${lp.nome}`}
                      >
                        <div className="flex items-center gap-1.5 min-w-0 flex-1">
                          <span
                            className="w-2 h-2 rounded-full flex-none ring-1 ring-black/10 dark:ring-white/10"
                            style={{ backgroundColor: cor }}
                          />
                          <span className="truncate font-semibold text-tinta hover:text-acento">{lp.nome}</span>
                        </div>
                        <span className="text-tinta3 italic text-[10.5px] flex-none">sem data</span>
                      </div>
                    );
                  }
                  const idade = Math.floor(agulhaAno - lp.ano_nascimento);
                  const falec = lp.ano_falecimento ?? (lp.is_vivo ? HOJE_CONTINUO : null);
                  const vivo = idade >= 0 && (falec == null || agulhaAno <= falec);

                  return (
                    <div
                      key={lp.pessoa_id}
                      onClick={() => enquadrarVida(lp)}
                      className="flex items-center justify-between text-[11px] gap-2 p-1 -mx-1 rounded hover:bg-sup/80 cursor-pointer transition-colors"
                      title={`Clique para focar na vida de ${lp.nome}`}
                    >
                      <div className="flex items-center gap-1.5 min-w-0 flex-1">
                        <span
                          className="w-2 h-2 rounded-full flex-none ring-1 ring-black/10 dark:ring-white/10"
                          style={{ backgroundColor: cor }}
                        />
                        <span className="truncate font-semibold text-tinta hover:text-acento">{lp.nome}</span>
                      </div>
                      <span className="flex-none font-num text-[11px]">
                        {idade < 0 ? (
                          <span className="text-tinta3 font-medium text-[10.5px]">
                            nasce em {Math.ceil(Math.abs(agulhaAno - lp.ano_nascimento))}a
                          </span>
                        ) : vivo ? (
                          <span className="text-emerald-700 dark:text-emerald-300 font-bold bg-emerald-500/15 px-1.5 py-0.2 rounded border border-emerald-600/30 text-[10.5px]">
                            {idade} {t('arvore', 'anos')}
                          </span>
                        ) : (
                          <span className="text-tinta3 font-medium text-[10.5px]">
                            faleceu aos {falec != null ? Math.floor(falec - lp.ano_nascimento) : '?'}a
                          </span>
                        )}
                      </span>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* Marcos Históricos Coincidentes */}
          {marcosNaAgulha.length > 0 && (
            <div className="border-t border-borda/60 pt-1.5 flex flex-col gap-1">
              <span className="text-[9.5px] font-bold text-tinta3 uppercase tracking-wider">
                {t('linhaTempo', 'acontecimentosHistoricos')}
              </span>
              <div className="flex flex-col gap-1 max-h-[90px] overflow-y-auto pr-1">
                {marcosNaAgulha.map((m) => (
                  <button
                    key={m.id}
                    type="button"
                    onMouseDown={(e) => {
                      e.stopPropagation();
                      arrastou.current = false;
                    }}
                    onClick={(e) => {
                      e.stopPropagation();
                      abrirMarco(m);
                    }}
                    className="text-[10.5px] text-tinta font-medium truncate flex items-center gap-1.5 p-0.5 -mx-0.5 rounded hover:bg-sup/80 text-left cursor-pointer border-none bg-transparent transition-colors"
                    title={`Ver detalhes de: ${m.titulo}`}
                  >
                    <span className="w-1.5 h-1.5 rounded-full bg-acento flex-none" />
                    <span className="truncate flex-1 hover:text-acento">{m.titulo}</span>
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* Estado Vazio: se não houver dados no ano */}
          {linhasPessoais.length === 0 && marcosNaAgulha.length === 0 && !marcadorNaAgulha && (
            <span className="text-tinta3 italic text-[10.5px] py-1">
              Nenhum evento registrado em {formatarAnoAtual(agulhaAno)}.
            </span>
          )}
        </div>
      )}

      {/* Painel Inferior de Detalhes (Animado com transição deslizante, design editorial e conexões visuais) */}
      {(() => {
        const linhaDoMarcoExibido = marcoExibido?.linha_id
          ? linhas?.find((l) => l.id === marcoExibido.linha_id)
          : undefined;
        const corTrilhaAtiva = marcoExibido?.linha_id
          ? (coresPersonalizadas[marcoExibido.linha_id] ?? corDa(linhaDoMarcoExibido?.categoria))
          : '#3b82f6';
        const corPessoaAtiva = eventoExibido
          ? obterCorTrilha(eventoExibido.pessoaId, undefined)
          : '#3b82f6';
        const corPainelInferior = marcoExibido && (marcoAberto || !eventoPessoalAberto)
          ? corTrilhaAtiva
          : corPessoaAtiva;

        return (
          <div
            ref={painelInferiorRef}
            style={{
              borderTopColor: temPainelInferior ? corPainelInferior : 'transparent',
            }}
            className={cn(
              "flex-none border-t-[3px] bg-card/95 backdrop-blur-md z-30 shadow-[0_-6px_24px_rgba(0,0,0,0.08)] dark:shadow-[0_-8px_28px_rgba(0,0,0,0.35)] overflow-hidden transition-all duration-300 ease-out",
              temPainelInferior
                ? "h-[230px] opacity-100 translate-y-0"
                : "h-0 opacity-0 translate-y-4 pointer-events-none border-t-0"
            )}
          >
            {marcoExibido && (marcoAberto || !eventoPessoalAberto) && (
              <div className="p-3.5 md:p-4 flex flex-col md:flex-row items-stretch gap-3.5 h-[230px] overflow-y-auto md:overflow-hidden box-border">
                {/* Coluna 1: O Fato Histórico em Destaque Editorial */}
                <div
                  className="flex-[1.15] min-w-0 bg-sup/80 dark:bg-sup/50 rounded-raio border border-borda/80 p-3.5 flex flex-col justify-between relative overflow-hidden shadow-2xs"
                  style={{
                    borderLeftColor: corTrilhaAtiva,
                    borderLeftWidth: '4px',
                  }}
                >
                  <div>
                    {/* Linha superior: Trilha temática + Ano/Período + Categoria */}
                    <div className="flex items-center gap-2 flex-wrap">
                      <span
                        className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded text-xs font-bold tracking-wide uppercase"
                        style={{
                          backgroundColor: `${corTrilhaAtiva}20`,
                          color: corTrilhaAtiva,
                        }}
                      >
                        <BookOpen className="w-3.5 h-3.5" />
                        {linhaDoMarcoExibido?.titulo ?? 'História & Contexto'}
                      </span>

                      <span className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded bg-card border border-borda font-num text-xs font-bold text-tinta shadow-2xs">
                        <Calendar className="w-3.5 h-3.5 text-tinta3" />
                        {marcoExibido.data_periodo_texto}
                      </span>

                      {linhaDoMarcoExibido?.categoria && (
                        <span className="text-[11px] uppercase font-semibold tracking-wider text-tinta3/80 px-1">
                          {linhaDoMarcoExibido.categoria}
                        </span>
                      )}
                    </div>

                    {/* Título com destaque editorial */}
                    <h3 className="m-0 font-serif text-[17px] md:text-[18px] font-bold text-tinta leading-snug tracking-tight mt-2 line-clamp-2">
                      {marcoExibido.titulo}
                    </h3>

                    {/* Descrição contextual */}
                    {marcoExibido.descricao ? (
                      <p className="m-0 text-[13px] md:text-[14px] text-tinta2 leading-relaxed mt-1.5 overflow-y-auto max-h-[76px] pr-1 select-text scrollbar-fino">
                        {marcoExibido.descricao}
                      </p>
                    ) : (
                      <p className="m-0 text-xs md:text-[13px] text-tinta3 italic mt-1.5">
                        Nenhum texto descritivo cadastrado para este marco.
                      </p>
                    )}
                  </div>

                  {/* Rodapé da Coluna 1: Proveniência / Fonte */}
                  <div className="flex items-center gap-2 mt-2 pt-2 border-t border-borda/50 text-xs text-tinta3 truncate">
                    {marcoExibido.fonte_especifica ? (
                      <>
                        <Bookmark className="w-3.5 h-3.5 flex-none text-acento" />
                        <span className="truncate italic">Fonte: {marcoExibido.fonte_especifica}</span>
                      </>
                    ) : (
                      <>
                        <Compass className="w-3.5 h-3.5 flex-none text-tinta3/70" />
                        <span className="truncate">Marco cronológico de referência histórica</span>
                      </>
                    )}
                  </div>
                </div>

                {/* Coluna 2: Conexão com a Árvore & Familiares na Época */}
                <div className="flex-1 min-w-0 bg-sup/80 dark:bg-sup/50 rounded-raio border border-borda/80 p-3.5 flex flex-col justify-between shadow-2xs">
                  {/* Cabeçalho da Conexão */}
                  <div className="flex items-center justify-between gap-2 flex-wrap pb-2 border-b border-borda/60">
                    <span className="text-sm font-bold text-tinta flex items-center gap-2">
                      <Users className="w-4 h-4 text-acento" />
                      Quem Viveu Esta Época
                    </span>
                  </div>

                  {/* Lista de Participantes Vinculados */}
                  <div className="flex-1 overflow-y-auto max-h-[86px] py-1.5 flex flex-wrap gap-1.5 items-start content-start scrollbar-fino">
                    {participantesMarco && participantesMarco.length > 0 ? (
                      participantesMarco.map((p) => {
                        return (
                          <div
                            key={p.id}
                            className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-raio-s text-xs border transition-all ${
                              p.visivel_na_pessoa
                                ? 'bg-card border-borda text-tinta shadow-2xs'
                                : 'bg-transparent border-borda/40 text-tinta3 opacity-60'
                            }`}
                          >
                            <User className="w-3.5 h-3.5 text-acento/80 flex-none" />
                            <span className="font-semibold">{p.nome}</span>
                            {p.papel && (
                              <span className="text-[10.5px] px-1.5 py-0.5 rounded bg-sup text-tinta2 border border-borda/40">
                                {p.papel}
                              </span>
                            )}

                            <div className="flex items-center gap-1 ml-1.5 pl-1.5 border-l border-borda">
                              <button
                                type="button"
                                title={
                                  p.visivel_na_pessoa
                                    ? 'Visível na biografia (clique para ocultar)'
                                    : 'Oculto da biografia (clique para mostrar)'
                                }
                                onClick={() =>
                                  mToggleVisibilidade.mutate({
                                    id: p.id,
                                    visivel: !p.visivel_na_pessoa,
                                  })
                                }
                                className="p-0.5 hover:text-acento transition-colors cursor-pointer"
                              >
                                {p.visivel_na_pessoa ? (
                                  <Eye className="w-3.5 h-3.5" />
                                ) : (
                                  <EyeOff className="w-3.5 h-3.5" />
                                )}
                              </button>
                              <button
                                type="button"
                                title="Remover participante"
                                onClick={() => mRemoverParticipante.mutate(p.id)}
                                className="p-0.5 hover:text-fem transition-colors cursor-pointer"
                              >
                                <X className="w-3.5 h-3.5" />
                              </button>
                            </div>
                          </div>
                        );
                      })
                    ) : (
                      <span className="text-xs text-tinta3 italic py-1.5">
                        Nenhum familiar vinculado diretamente a este acontecimento.
                      </span>
                    )}
                  </div>

                  {/* Rodapé da Coluna 2: Adicionar Participante Rápido */}
                  {linhaDoMarcoExibido && (
                    <div className="pt-2 border-t border-borda/50 flex items-center gap-2">
                      {pessoaSelecionadaRapida ? (
                        <div className="flex items-center gap-2 w-full">
                          <span className="text-xs font-semibold text-tinta flex items-center gap-1.5 max-w-[140px] truncate bg-card px-2 py-1 rounded border border-borda">
                            <User className="w-3 h-3 text-acento flex-none" />
                            <span className="truncate">
                              {pessoaSelecionadaRapida.nome} {pessoaSelecionadaRapida.sobrenome}
                            </span>
                          </span>

                          <input
                            type="text"
                            placeholder="Papel (ex: Testemunha)..."
                            value={papelRapido}
                            onChange={(e) => setPapelRapido(e.target.value)}
                            onKeyDown={(e) => {
                              if (e.key === 'Enter') {
                                e.preventDefault();
                                const pId = pessoaSelecionadaRapida.id;
                                adicionarParticipante({
                                  marco_id: marcoExibido.id,
                                  pessoa_id: pId,
                                  papel: papelRapido.trim() || null,
                                  visivel_na_pessoa: true,
                                }).then(() => {
                                  qc.invalidateQueries({ queryKey: ['marco-participantes', marcoExibido.id] });
                                  qc.invalidateQueries({ queryKey: ['linha-pessoal'] });
                                  qc.refetchQueries({ queryKey: ['linha-pessoal'] });
                                  qc.invalidateQueries({ queryKey: ['participacoes-pessoa'] });
                                  qc.invalidateQueries({ queryKey: ['eventos'] });
                                  setVidasExtras((prev) => (prev.includes(pId) ? prev : [...prev, pId]));
                                  setVidasRemovidas((prev) => prev.filter((id) => id !== pId));
                                  setPessoaSelecionadaRapida(null);
                                  setPapelRapido('');
                                });
                              }
                            }}
                            className="px-2.5 py-1 text-xs bg-card border border-borda rounded text-tinta flex-1 min-w-[100px] focus:outline-none focus:border-acento"
                          />

                          <button
                            type="button"
                            onClick={() => {
                              const pId = pessoaSelecionadaRapida.id;
                              adicionarParticipante({
                                marco_id: marcoExibido.id,
                                pessoa_id: pId,
                                papel: papelRapido.trim() || null,
                                visivel_na_pessoa: true,
                              }).then(() => {
                                qc.invalidateQueries({ queryKey: ['marco-participantes', marcoExibido.id] });
                                qc.invalidateQueries({ queryKey: ['linha-pessoal'] });
                                qc.refetchQueries({ queryKey: ['linha-pessoal'] });
                                qc.invalidateQueries({ queryKey: ['participacoes-pessoa'] });
                                qc.invalidateQueries({ queryKey: ['eventos'] });
                                setVidasExtras((prev) => (prev.includes(pId) ? prev : [...prev, pId]));
                                setVidasRemovidas((prev) => prev.filter((id) => id !== pId));
                                setPessoaSelecionadaRapida(null);
                                setPapelRapido('');
                              });
                            }}
                            className="px-3 py-1 text-xs bg-acento text-acento-tinta font-semibold rounded cursor-pointer shadow-2xs hover:opacity-90 transition-opacity"
                          >
                            Incluir
                          </button>
                          <button
                            type="button"
                            onClick={() => {
                              setPessoaSelecionadaRapida(null);
                              setPapelRapido('');
                            }}
                            className="text-tinta3 hover:text-tinta p-1 rounded cursor-pointer"
                            title="Cancelar"
                          >
                            <X className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      ) : (
                        <div className="relative w-full">
                          <div className="flex items-center gap-1.5 bg-card rounded border border-borda px-2.5 py-1">
                            <UserPlus className="w-3.5 h-3.5 text-tinta3 flex-none" />
                            <input
                              type="text"
                              placeholder="+ Vincular familiar a este marco..."
                              value={buscaParticipanteRapido}
                              onChange={(e) => setBuscaParticipanteRapido(e.target.value)}
                              className="text-xs bg-transparent text-tinta w-full focus:outline-none placeholder:text-tinta3/60"
                            />
                          </div>

                          {resultadosBuscaRapida &&
                            resultadosBuscaRapida.length > 0 &&
                            buscaParticipanteRapido.trim().length >= 2 && (
                              <div className="absolute bottom-full left-0 mb-1 w-full bg-card border border-borda rounded-raio shadow-sombra max-h-40 overflow-y-auto z-50">
                                {resultadosBuscaRapida.map((r) => (
                                  <button
                                    key={r.id}
                                    type="button"
                                    onClick={() => {
                                      setPessoaSelecionadaRapida(r);
                                      setBuscaParticipanteRapido('');
                                    }}
                                    className="w-full text-left px-3 py-2 text-xs hover:bg-sup text-tinta flex items-center justify-between cursor-pointer gap-2 border-b border-borda/30 last:border-b-0"
                                  >
                                    <div className="flex flex-col min-w-0 flex-1">
                                      <span className="font-semibold text-tinta truncate">
                                        {r.nome} {r.sobrenome}
                                      </span>
                                      <span className="text-[11px] text-tinta3 truncate">
                                        {r.ano_nascimento ? `* ${r.ano_nascimento}` : ''}{' '}
                                        {r.ano_falecimento ? `✝ ${r.ano_falecimento}` : r.is_vivo ? '• vivo' : ''}
                                      </span>
                                    </div>
                                    <span className="text-xs text-acento font-semibold px-2 py-0.5 rounded bg-acento/10 flex-none">
                                      + Vincular
                                    </span>
                                  </button>
                                ))}
                              </div>
                            )}
                        </div>
                      )}
                    </div>
                  )}
                </div>

                {/* Coluna 3: Ações e Fechamento */}
                <div className="flex-none flex md:flex-col justify-between items-end gap-2 pl-0 md:pl-1">
                  {/* Fechar Painel */}
                  <button
                    type="button"
                    onClick={fecharMarco}
                    aria-label="Fechar painel de contexto"
                    className="p-1.5 rounded-full bg-sup hover:bg-card border border-borda text-tinta3 hover:text-tinta transition-all shadow-2xs hover:scale-105 cursor-pointer flex-none"
                    title="Fechar detalhe (Esc)"
                  >
                    <X className="w-4 h-4" />
                  </button>

                  {/* Ações de Edição e Exclusão (se linha editável) */}
                  {marcoExibido.linha_id &&
                    linhaDoMarcoExibido &&
                    !linhaDoMarcoExibido.is_bloqueada && (
                      <div className="flex md:flex-col gap-1.5 w-full">
                        <button
                          type="button"
                          onClick={() => {
                            setLinhaAlvoMarco(marcoExibido.linha_id);
                            setMarcoEditando(marcoExibido);
                          }}
                          className="flex items-center justify-center gap-1.5 px-3.5 py-1.5 rounded-raio-s text-xs font-semibold border border-borda hover:border-acento hover:text-acento bg-card text-tinta transition-colors shadow-2xs cursor-pointer"
                        >
                          <Edit3 className="w-3.5 h-3.5" />
                          <span>Editar</span>
                        </button>
                        <button
                          type="button"
                          onClick={() => {
                            if (confirm('Tem certeza de que deseja apagar este marco histórico?')) {
                              deletarMarco(marcoExibido.id).then(() => {
                                qc.invalidateQueries({ queryKey: ['marcos'] });
                                qc.invalidateQueries({ queryKey: ['linha-pessoal'] });
                                fecharMarco();
                              });
                            }
                          }}
                          className="flex items-center justify-center gap-1.5 px-3.5 py-1.5 rounded-raio-s text-xs font-semibold border border-fem/30 text-fem hover:bg-fem/10 bg-card transition-colors shadow-2xs cursor-pointer"
                        >
                          <Trash2 className="w-3.5 h-3.5" />
                          <span>Apagar</span>
                        </button>
                      </div>
                    )}
                </div>
              </div>
            )}

            {eventoExibido && (eventoPessoalAberto || !marcoAberto) && (
              <div className="p-3.5 md:p-4 flex flex-col md:flex-row items-stretch gap-3.5 h-[230px] overflow-y-auto md:overflow-hidden box-border">
                {/* Coluna 1: O Evento Biográfico */}
                <div
                  className="flex-[1.15] min-w-0 bg-sup/80 dark:bg-sup/50 rounded-raio border border-borda/80 p-3.5 flex flex-col justify-between relative overflow-hidden shadow-2xs"
                  style={{
                    borderLeftColor: corPessoaAtiva,
                    borderLeftWidth: '4px',
                  }}
                >
                  <div>
                    <div className="flex items-center gap-2 flex-wrap">
                      <span
                        className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded text-xs font-bold tracking-wide"
                        style={{
                          backgroundColor: `${corPessoaAtiva}20`,
                          color: corPessoaAtiva,
                        }}
                      >
                        <User className="w-3.5 h-3.5" />
                        {eventoExibido.pessoaNome}
                      </span>

                      <span className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded bg-card border border-borda font-num text-xs font-bold text-tinta shadow-2xs">
                        <Calendar className="w-3.5 h-3.5 text-tinta3" />
                        {eventoExibido.marco.data_texto ?? eventoExibido.marco.ano}
                      </span>

                      <span className="text-xs px-2.5 py-0.5 rounded-full bg-acento/10 border border-acento/30 text-acento font-semibold">
                        {eventoExibido.marco.titulo ?? eventoExibido.marco.tipo}
                      </span>

                      {eventoExibido.marco.papel && (
                        <span className="text-[11px] px-2 py-0.5 rounded-full bg-sup border border-borda2 text-tinta2">
                          Papel: {eventoExibido.marco.papel}
                        </span>
                      )}

                      {eventoExibido.marco.is_participacao &&
                        !eventoExibido.marco.visivel_na_pessoa && (
                          <span className="text-[11px] px-2 py-0.5 rounded-full bg-fem/10 border border-fem/30 text-fem font-medium">
                            Oculto da biografia
                          </span>
                        )}
                    </div>

                    <h3 className="m-0 font-serif text-[17px] md:text-[18px] font-bold text-tinta leading-snug tracking-tight mt-2">
                      {eventoExibido.marco.titulo ?? `${eventoExibido.pessoaNome} — ${eventoExibido.marco.tipo}`}
                    </h3>

                    {eventoExibido.marco.com && (
                      <p className="m-0 mt-1.5 text-[13px] md:text-sm text-tinta2">
                        Cônjuge / Companheiro(a):{' '}
                        <strong className="text-tinta font-semibold">{eventoExibido.marco.com}</strong>
                      </p>
                    )}

                    {eventoExibido.marco.local && (
                      <p className="m-0 mt-1.5 text-[13px] md:text-sm text-tinta2 flex items-center gap-1.5">
                        <MapPin className="w-3.5 h-3.5 text-acento flex-none" />
                        <span>{eventoExibido.marco.local}</span>
                      </p>
                    )}
                  </div>

                  {eventoExibido.marco.linha_titulo && (
                    <div className="flex items-center gap-2 mt-2 pt-2 border-t border-borda/50 text-xs text-tinta3 truncate">
                      <BookOpen className="w-3.5 h-3.5 flex-none text-tinta3" />
                      <span className="truncate">Originado da linha: {eventoExibido.marco.linha_titulo}</span>
                    </div>
                  )}
                </div>

                {/* Coluna 2: Contemporâneos na Árvore e Ações Rápidas */}
                <div className="flex-1 min-w-0 bg-sup/80 dark:bg-sup/50 rounded-raio border border-borda/80 p-3.5 flex flex-col justify-between shadow-2xs">
                  <div className="flex items-center justify-between gap-2 flex-wrap pb-2 border-b border-borda/60">
                    <span className="text-sm font-bold text-tinta flex items-center gap-2">
                      <Users className="w-4 h-4 text-acento" />
                      Contemporâneos na Árvore
                    </span>
                  </div>

                  <div className="flex-1 py-2 flex flex-col justify-center gap-2.5">
                    <p className="m-0 text-[13px] md:text-sm text-tinta2">
                      Navegue pela biografia completa ou calcule o cruzamento genealógico:
                    </p>
                    <div className="flex items-center gap-2.5 flex-wrap">
                      {onAbrirFicha && (
                        <button
                          type="button"
                          onClick={() => onAbrirFicha(eventoExibido.pessoaId)}
                          className="px-3.5 py-1.5 text-xs rounded-raio-s bg-card hover:bg-sup border border-borda text-tinta font-semibold transition-colors shadow-2xs cursor-pointer flex items-center gap-1.5"
                        >
                          <User className="w-3.5 h-3.5 text-acento" />
                          <span>Abrir Ficha Biográfica</span>
                        </button>
                      )}
                      {onAbrirParentesco && (
                        <button
                          type="button"
                          onClick={() => onAbrirParentesco(eventoExibido.pessoaId)}
                          className="px-3.5 py-1.5 text-xs rounded-raio-s bg-acento/10 hover:bg-acento/20 border border-acento/30 text-acento font-semibold transition-colors shadow-2xs cursor-pointer flex items-center gap-1.5"
                        >
                          <IconeRelacoes className="w-3.5 h-3.5" />
                          <span>Calcular Parentesco</span>
                        </button>
                      )}
                    </div>
                  </div>
                </div>

                {/* Coluna 3: Fechamento */}
                <div className="flex-none flex md:flex-col justify-start items-end gap-2 pl-0 md:pl-1">
                  <button
                    type="button"
                    onClick={fecharEventoPessoal}
                    aria-label="Fechar painel"
                    className="p-1.5 rounded-full bg-sup hover:bg-card border border-borda text-tinta3 hover:text-tinta transition-all shadow-2xs hover:scale-105 cursor-pointer"
                    title="Fechar detalhe (Esc)"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>
              </div>
            )}
          </div>
        );
      })()}

      {/* Modal de Marcador com Comentário (Novo ou Edição) */}
      <ModalMarcadorComentario
        aberto={modalMarcadorAberto}
        anoInicial={marcadorParaEditar ? marcadorParaEditar.ano : agulhaAno}
        marcadorParaEditar={marcadorParaEditar}
        aoFechar={() => {
          setModalMarcadorAberto(false);
          setMarcadorParaEditar(null);
        }}
        aoSalvar={() => {
          refetchMarcadores();
        }}
      />

      {/* Modal Editor de Linha do Tempo */}
      {linhaEditando && (
        <EditorLinhaTempo
          idOpcional={linhaEditando === 'nova' ? undefined : linhaEditando}
          valoresIniciais={
            linhaEditando !== 'nova' ? linhas?.find((x) => x.id === linhaEditando) : undefined
          }
          onClose={() => setLinhaEditando(null)}
          onSuccess={(id) => {
            const eraNova = linhaEditando === 'nova';
            setLinhaEditando(null);
            if (id) {
              if (!ativas.includes(id)) setAtivas((a) => [...a, id]);
              if (eraNova) {
                setLinhaAlvoMarco(id);
                setMarcoEditando('novo');
              }
            }
          }}
        />
      )}

      {/* Modal Editor de Marco */}
      {marcoEditando && (
        <EditorMarco
          linhaId={linhaAlvoMarco ?? undefined}
          idOpcional={marcoEditando === 'novo' ? undefined : marcoEditando.id}
          valoresIniciais={
            marcoEditando !== 'novo'
              ? {
                  ...marcoEditando,
                  relevancia: marcoEditando.relevancia ?? 'alta',
                }
              : undefined
          }
          onClose={() => {
            setMarcoEditando(null);
            setLinhaAlvoMarco(null);
          }}
          onSuccess={() => {
            setMarcoEditando(null);
            setLinhaAlvoMarco(null);
            fecharMarco();
          }}
        />
      )}

      {/* Modal de Impressão da Linha do Tempo */}
      {mostrarDialogoImprimir && (
        <DialogoImprimirLinhaTempo
          linhasContexto={linhas ?? []}
          linhasAtivasIds={ativas}
          linhasPessoais={linhasPessoais}
          marcos={marcos ?? []}
          anoDeAtual={janela.de}
          anoAteAtual={janela.ate}
          regiaoImpressao={regiaoImpressao}
          coresPersonalizadas={coresPersonalizadas}
          onClose={() => setMostrarDialogoImprimir(false)}
        />
      )}

      {/* Modal de Comparar Vidas */}
      <ModalCompararVidas
        aberto={modalCompararAberto}
        aoFechar={() => setModalCompararAberto(false)}
        vidasJaAbertas={todasVidasIds}
        pessoasDaArvore={pessoasDaArvore}
        onAdicionarVida={(id) => {
          setVidasRemovidas((prev) => prev.filter((v) => v !== id));
          if (!vidasExtras.includes(id)) {
            setVidasExtras((prev) => [...prev, id]);
          }
        }}
        onRemoverVida={(id) => {
          removerVida(id);
        }}
        onAdicionarTodas={() => {
          if (!pessoasDaArvore) return;
          const todosIds = pessoasDaArvore.map((p) => p.id);
          setVidasRemovidas([]);
          setVidasExtras(todosIds);
        }}
        onRemoverTodas={() => {
          setVidasExtras([]);
          setVidasRemovidas(pessoasDaArvore ? pessoasDaArvore.map((p) => p.id) : []);
        }}
      />

      {/* Modal de Catálogo Histórico de Linhas de Contexto */}
      <ModalCatalogoLinhasContexto
        aberto={modalCatalogoAberto}
        aoFechar={() => setModalCatalogoAberto(false)}
        linhas={linhas ?? []}
        ativas={ativas}
        onAlternarLinha={alternarLinha}
        onCriarNovaLinha={() => setLinhaEditando('nova')}
        onDesativarTodas={() => setAtivas([])}
      />

      {/* Modal para Adicionar Evento de Vida com Linha de Contexto */}
      <ModalAdicionarEventoVida
        aberto={modalEventoVidaAberto}
        aoFechar={() => {
          setModalEventoVidaAberto(false);
          setPessoaAlvoEventoVida(null);
        }}
        pessoaIdInicial={pessoaAlvoEventoVida ?? pessoaSelecionadaId ?? linhasPessoais[0]?.pessoa_id}
        pessoasDisponiveis={(pessoasDaArvore ?? []).map((p) => ({
          id: p.id,
          nome: p.nome,
          sobrenome: p.sobrenome,
          ano_nascimento: p.ano_nascimento,
          ano_falecimento: p.ano_falecimento,
          is_vivo: p.is_vivo,
        }))}
        linhasContexto={linhas ?? []}
        linhasAtivasIds={ativas}
      />
    </div>
  );
}

function iconeDoEvento(tipo: string): string {
  const t = tipo.toLowerCase();
  if (t.includes('nasc')) return '⭐';
  if (t.includes('batism')) return '💧';
  if (t.includes('casam') || t.includes('uni')) return '💍';
  if (t.includes('resid') || t.includes('mudan')) return '🏠';
  if (t.includes('educ') || t.includes('format') || t.includes('gradua')) return '🎓';
  if (t.includes('prof') || t.includes('ocup') || t.includes('carreir')) return '💼';
  if (t.includes('milit') || t.includes('combat') || t.includes('guerra')) return '⚔️';
  if (t.includes('imigr') || t.includes('emigr')) return '🚢';
  if (t.includes('viag')) return '✈️';
  if (t.includes('falec') || t.includes('óbit')) return '✝';
  if (t.includes('sepult') || t.includes('enterro')) return '🏛️';
  return '📍';
}

/**
 * A faixa de vida de uma pessoa no eixo horizontal (Clipe de Vida NLE).
 */
function FaixaDaVida({
  linha,
  posicaoDoAno,
  altura,
  larguraCanvas,
  cor,
  compacto,
  mostrarOcultos,
  onAbrirMarco,
  onAbrirEventoPessoal,
  onFocar,
  onPosicionarAgulha,
  formatarAno: formatarAnoProp,
}: {
  linha: LinhaPessoal;
  posicaoDoAno: (ano: number) => number;
  larguraCanvas: number;
  cor?: string;
  altura: number;
  compacto: boolean;
  mostrarOcultos: boolean;
  onAbrirMarco: (m: Marco) => void;
  onAbrirEventoPessoal?: (pessoaNome: string, pessoaId: string, marco: MarcoPessoal) => void;
  onFocar?: () => void;
  onPosicionarAgulha?: (canvasX: number) => void;
  formatarAno?: (ano: number | null | undefined) => string;
}) {
  const formatarAnoFn = formatarAnoProp ?? formatarAno;
  const nasceu = linha.ano_nascimento;
  const terminou = linha.ano_falecimento ?? (linha.is_vivo ? HOJE_CONTINUO : null);
  const corEfetiva = cor ?? corDaPessoa(linha.sexo);
  const anosTotais = nasceu != null && terminou != null ? Math.max(0, Math.floor(terminou - nasceu)) : null;

  const anoNascContinuo = useMemo(() => {
    if (linha.ano_nascimento == null) return null;
    return (
      converterDataParaAnoFracionario(
        linha.ano_nascimento,
        linha.data_nascimento_texto,
        linha.mes_nascimento,
        linha.dia_nascimento,
      ) ?? linha.ano_nascimento
    );
  }, [linha.ano_nascimento, linha.data_nascimento_texto, linha.mes_nascimento, linha.dia_nascimento]);

  const anoFalecContinuo = useMemo(() => {
    if (linha.ano_falecimento == null) {
      return linha.is_vivo ? HOJE_CONTINUO : null;
    }
    return (
      converterDataParaAnoFracionario(
        linha.ano_falecimento,
        linha.data_falecimento_texto,
        linha.mes_falecimento,
        linha.dia_falecimento,
      ) ?? linha.ano_falecimento
    );
  }, [linha.ano_falecimento, linha.data_falecimento_texto, linha.mes_falecimento, linha.dia_falecimento, linha.is_vivo]);

  const x0 = anoNascContinuo != null ? posicaoDoAno(anoNascContinuo) : null;
  const x1 = anoFalecContinuo != null ? posicaoDoAno(anoFalecContinuo) : x0 != null ? x0 + 16 : null;
  const larguraBarra = x0 != null && x1 != null ? Math.max(12, x1 - x0) : 0;

  // Interseção da barra com a tela visível (Viewport-Aware Sticky Label)
  const {
    barraNaTela,
    larguraVisivel,
    centroVisivelRelativo,
    estendeParaEsquerda,
    estendeParaDireita,
  } = useMemo(
    () => calcularFatiaVisivelBarra({ x0, x1, larguraCanvas }),
    [x0, x1, larguraCanvas],
  );

  const [clusterAbertoId, setClusterAbertoId] = useState<string | null>(null);

  const alturaClipe = compacto ? 24 : 22;
  const topClipe = compacto ? (altura - alturaClipe) / 2 : 6;

  const marcosValidos = useMemo(() => {
    return linha.marcos.filter((m) => {
      if (m.ano == null) return false;
      const tipo = (m.tipo ?? '').toLowerCase();
      if (!m.is_participacao && (tipo.includes('nasc') || tipo.includes('falec') || tipo.includes('óbit'))) {
        return false;
      }
      if (m.is_participacao && !m.visivel_na_pessoa && !mostrarOcultos) return false;
      return true;
    });
  }, [linha.marcos, mostrarOcultos]);

  const gruposMarcos = useMemo(() => {
    return agruparMarcosPessoaisProximos(
      marcosValidos,
      posicaoDoAno,
      compacto ? 28 : 65,
      compacto ? 1 : (altura >= 72 ? 2 : 1),
    );
  }, [marcosValidos, posicaoDoAno, altura, compacto]);

  return (
    <div className="relative w-full h-full select-none overflow-hidden">
      {/* Clipe da Vida (Barra Contínua de Anos Vividos) */}
      {x0 != null && (
        <div
          className="absolute rounded-xs shadow-xs flex items-center justify-between px-2 overflow-hidden border border-black/15 transition-all hover:brightness-110 cursor-pointer"
          style={{
            left: x0,
            width: larguraBarra,
            height: alturaClipe,
            top: topClipe,
            backgroundColor: corEfetiva,
            opacity: 1,
          }}
          onClick={onFocar}
          title={`${linha.nome}: ${nasceu != null ? formatarAnoFn(nasceu) : ''} – ${
            linha.ano_falecimento != null
              ? formatarAnoFn(linha.ano_falecimento)
              : linha.is_vivo
              ? 'hoje'
              : 'sem data'
          } ${anosTotais != null ? `(${anosTotais} anos)` : ''}`}
        >
          {/* Início: Ano de Nascimento (oculto se barra for estreita ou já ultrapassou a borda para evitar sobreposição) */}
          <span className="text-[10px] font-num font-bold text-white tracking-wide select-none drop-shadow-xs flex items-center gap-0.5 z-20">
            <span>★</span>
            {!estendeParaEsquerda && larguraBarra >= 140 && (
              <span>{linha.data_nascimento_texto && larguraBarra >= 220 ? linha.data_nascimento_texto : formatarAnoFn(nasceu)}</span>
            )}
          </span>

          {/* Nome e Idade: Rótulo Centralizado e Aderente ao Viewport (Sticky) com Anticolisão */}
          {barraNaTela && (
            <div
              className="absolute pointer-events-none flex items-center justify-center whitespace-nowrap z-20 select-none"
              style={{
                left: Math.max(
                  larguraBarra >= 140 ? 55 : 22,
                  Math.min(larguraBarra - (larguraBarra >= 140 ? 55 : 22), centroVisivelRelativo)
                ),
                transform: 'translateX(-50%)',
                maxWidth: Math.max(45, larguraVisivel - (larguraBarra >= 140 ? 70 : 34)),
              }}
            >
              <span className="text-[10.5px] font-semibold text-white truncate px-1.5 py-0.5 rounded-xs drop-shadow-md bg-black/75 border border-white/20 flex items-center gap-1">
                {estendeParaEsquerda && (
                  <span className="text-[9px] opacity-80" title={`Nasceu em ${formatarAnoFn(nasceu)}`}>
                    ◀ {formatarAnoFn(nasceu)}
                  </span>
                )}
                <span className="truncate">{linha.nome}</span>
                {anosTotais != null && (
                  <span className="opacity-85 font-num text-[10px]">({anosTotais}a)</span>
                )}
                {estendeParaDireita && (
                  <span
                    className="text-[9px] opacity-80"
                    title={`Faleceu em ${linha.ano_falecimento != null ? formatarAnoFn(linha.ano_falecimento) : 'hoje'}`}
                  >
                    {linha.ano_falecimento != null ? formatarAnoFn(linha.ano_falecimento) : 'hoje'} ▶
                  </span>
                )}
              </span>
            </div>
          )}

          {/* Fim: Ano de Falecimento ou Hoje (oculto se barra for estreita ou ultrapassou borda) */}
          <span className="text-[10px] font-num font-bold text-white tracking-wide select-none drop-shadow-xs flex items-center gap-0.5 z-20">
            {!estendeParaDireita && larguraBarra >= 140 && (
              <span>
                {linha.ano_falecimento != null
                  ? (linha.data_falecimento_texto && larguraBarra >= 220 ? linha.data_falecimento_texto : formatarAnoFn(linha.ano_falecimento))
                  : 'hoje'}
              </span>
            )}
            <span>{linha.is_vivo ? '●' : '✝'}</span>
          </span>
        </div>
      )}

      {/* Linha guia pontilhada se a pessoa não tiver ano de nascimento */}
      {x0 == null && (
        <div
          className="absolute inset-x-0 h-[1px] border-b border-dashed border-borda/40 pointer-events-none"
          style={{ top: topClipe + alturaClipe / 2 }}
        />
      )}

      {/* Eventos da Vida e Participações */}
      {gruposMarcos.map((grupo, idx) => {
        const topPos = compacto
          ? Math.max(14, altura - 22)
          : altura >= 72
          ? (grupo.subLane === 1 ? 52 : 32)
          : (grupo.subLane === 1 ? Math.min(altura - 22, 44) : 32);

        const proximoX = idx < gruposMarcos.length - 1 ? gruposMarcos[idx + 1].x : Infinity;
        const espacoAteProximo = proximoX - grupo.x;

        if (grupo.isCluster) {
          const primeiro = grupo.itens[0];
          const idadeNoEvento = nasceu != null ? Math.floor(grupo.ano - nasceu) : null;
          const idadeTexto = idadeNoEvento != null && idadeNoEvento >= 0 ? `${idadeNoEvento}a` : null;
          const isAberto = clusterAbertoId === grupo.id;
          const temEspacoRotuloCluster = !compacto && espacoAteProximo >= 115;
          const temEspacoAnoCluster = !compacto && espacoAteProximo >= 55;

          return (
            <div
              key={grupo.id}
              className="absolute flex flex-col items-start z-20"
              style={{ left: Math.round(grupo.x), top: topPos }}
            >
              <button
                type="button"
                onClick={() => {
                  onPosicionarAgulha?.(grupo.x);
                  setClusterAbertoId((atual) => (atual === grupo.id ? null : grupo.id));
                }}
                title={`${grupo.ano} (${grupo.itens.length} marcos):\n${grupo.itens
                  .map((m) => `• ${m.is_participacao ? m.titulo ?? m.tipo : m.tipo}: ${m.data_texto ?? m.ano}`)
                  .join('\n')}`}
                className="inline-flex items-center gap-1 px-1.5 py-0.5 rounded-raio-s border shadow-2xs transition-all bg-card border-acento/80 hover:border-acento hover:bg-card2 hover:shadow-xs hover:scale-105 select-none cursor-pointer whitespace-nowrap"
              >
                <span className="text-[10px] select-none">👑</span>
                {temEspacoAnoCluster && (
                  <span className="font-num text-[10px] font-semibold text-acento">
                    {grupo.ano}
                  </span>
                )}
                {temEspacoRotuloCluster && (
                  <span className="font-sans text-[10px] font-medium text-tinta max-w-[85px] truncate">
                    {primeiro.titulo ?? primeiro.tipo}
                  </span>
                )}
                <span className="font-num text-[9px] font-bold bg-acento/15 text-acento px-1 rounded-full">
                  +{grupo.itens.length - 1}
                </span>
                {temEspacoRotuloCluster && idadeTexto && (
                  <span className="font-num text-[9px] font-bold text-acento opacity-90 pl-0.5">
                    {idadeTexto}
                  </span>
                )}
                <span className="text-[8px] text-tinta3">▾</span>
              </button>

              {/* Dropdown Menu do Cluster de Marcos Coincidentes */}
              {isAberto && (
                <div
                  className="absolute top-full mt-1 w-64 bg-card border border-borda shadow-xl rounded-raio-s p-1.5 z-50 flex flex-col gap-1 text-left select-none animate-in fade-in zoom-in-95 duration-100"
                  onClick={(e) => e.stopPropagation()}
                >
                  <div className="text-[10px] font-bold text-tinta px-1 pb-1 border-b border-borda/60 flex items-center justify-between">
                    <span>{grupo.ano} · {grupo.itens.length} marcos históricos</span>
                    <button
                      type="button"
                      onClick={() => setClusterAbertoId(null)}
                      className="text-tinta3 hover:text-tinta text-[11px] p-0.5"
                    >
                      ✕
                    </button>
                  </div>
                  <div className="max-h-48 overflow-y-auto flex flex-col gap-0.5">
                    {grupo.itens.map((m, idxItem) => {
                      const rotulo = m.is_participacao ? (m.titulo ?? m.tipo) : m.tipo;
                      return (
                        <button
                          key={`${m.tipo}-${idxItem}`}
                          type="button"
                          className="flex items-center justify-between gap-1 p-1 hover:bg-sup/60 rounded text-left text-[10px] transition-colors cursor-pointer"
                          onMouseDown={(e) => e.stopPropagation()}
                          onClick={(e) => {
                            e.stopPropagation();
                            onPosicionarAgulha?.(grupo.x);
                            setClusterAbertoId(null);
                            if (onAbrirEventoPessoal) {
                              onAbrirEventoPessoal(linha.nome, linha.pessoa_id, m);
                            } else if (m.is_participacao) {
                              onAbrirMarco({
                                id: `part-${idxItem}`,
                                linha_id: '',
                                titulo: m.titulo ?? 'Participação',
                                data_periodo_texto: m.data_texto ?? String(m.ano),
                                descricao: m.papel ? `Papel: ${m.papel}` : null,
                                ano_inicio: m.ano,
                                ano_fim: m.ano,
                              });
                            }
                          }}
                        >
                          <div className="flex items-center gap-1.5 min-w-0">
                            <span className="text-[10px]">{m.is_participacao ? '👥' : iconeDoEvento(m.tipo)}</span>
                            <span className="font-medium text-tinta truncate">{rotulo}</span>
                          </div>
                          <span className="font-num text-[9px] text-tinta3 flex-none">{m.data_texto ?? m.ano}</span>
                        </button>
                      );
                    })}
                  </div>
                </div>
              )}
            </div>
          );
        }

        // Marco Único
        const m = grupo.itens[0];
        const isOculta = m.is_participacao && !m.visivel_na_pessoa;
        const idadeNoEvento = nasceu != null && m.ano != null ? Math.floor(m.ano - nasceu) : null;
        const idadeTexto = idadeNoEvento != null && idadeNoEvento >= 0 ? `${idadeNoEvento}a` : null;
        const rotulo = m.is_participacao ? (m.titulo ?? m.tipo) : m.tipo;

        // Regra: Se compacto, exibe sempre pino/ícone. Se expandido e com espaço, exibe texto.
        const larguraTextoCompleto = Math.ceil(rotulo.length * 6.8 + (idadeTexto ? 22 : 0) + 36);
        const temEspacoParaTexto = !compacto && espacoAteProximo >= (larguraTextoCompleto + 8);

          return (
            <div
              key={`${m.tipo}-${grupo.id}`}
              role="button"
              tabIndex={0}
              onMouseDown={(e) => e.stopPropagation()}
              className="absolute flex flex-col items-start group cursor-pointer z-20"
              style={{
                left: Math.round(grupo.x),
                transform: temEspacoParaTexto ? undefined : 'translateX(-50%)',
                top: topPos,
              }}
              title={[
                m.is_participacao
                  ? `Participação: ${m.titulo ?? m.tipo}`
                  : `${m.tipo}: ${m.data_texto ?? String(m.ano)}${
                      idadeNoEvento != null && idadeNoEvento >= 0 ? ` (${idadeNoEvento} anos)` : ''
                    }`,
                m.linha_titulo ? `Linha: ${m.linha_titulo}` : null,
                m.papel ? `Papel: ${m.papel}` : null,
                m.com ? `com ${m.com}` : null,
                m.local,
                'Clique para ver detalhes',
                isOculta ? '(Oculto da biografia)' : null,
              ]
                .filter(Boolean)
                .join(' · ')}
              onClick={(e) => {
                e.stopPropagation();
                onPosicionarAgulha?.(grupo.x);
                if (onAbrirEventoPessoal) {
                  onAbrirEventoPessoal(linha.nome, linha.pessoa_id, m);
                } else if (m.is_participacao) {
                  onAbrirMarco({
                    id: `part-${grupo.id}`,
                    linha_id: '',
                    titulo: m.titulo ?? 'Participação',
                    data_periodo_texto: m.data_texto ?? String(m.ano),
                    descricao: m.papel ? `Papel: ${m.papel}` : null,
                    ano_inicio: m.ano,
                    ano_fim: m.ano,
                  });
                }
              }}
            >
              {temEspacoParaTexto ? (
                /* Chip Completo com Rótulo e Ícone */
                <div
                  className={`inline-flex items-center gap-1 px-1.5 py-0.5 rounded-raio-s border shadow-2xs transition-all group-hover:scale-105 group-hover:shadow-xs whitespace-nowrap bg-card ${
                    m.is_participacao
                      ? isOculta
                        ? 'border-dashed border-tinta3/40 text-tinta3 opacity-50 line-through'
                        : 'border-acento/70 text-acento group-hover:border-acento group-hover:bg-card2'
                      : 'border-borda/80 text-tinta group-hover:border-acento'
                  }`}
                >
                  <span className="text-[10px] select-none flex-none">
                    {m.is_participacao ? '👥' : iconeDoEvento(m.tipo)}
                  </span>
                  <span className="font-sans text-[10px] font-medium whitespace-nowrap">
                    {rotulo}
                  </span>
                  {m.data_texto && espacoAteProximo >= (larguraTextoCompleto + 55) && (
                    <span className="font-num text-[9px] text-tinta3 font-normal opacity-85">
                      · {m.data_texto}
                    </span>
                  )}
                  {idadeTexto && (
                    <span className="font-num text-[9px] font-bold text-acento opacity-90 pl-0.5 flex-none">
                      {idadeTexto}
                    </span>
                  )}
                </div>
              ) : (
                /* Pino/Ícone Compacto sem Texto (apenas indicador pontual) */
                <div
                  className={`inline-flex items-center justify-center w-5 h-5 rounded-full border shadow-2xs transition-all group-hover:scale-125 group-hover:shadow-xs select-none bg-card ${
                    m.is_participacao
                      ? isOculta
                        ? 'border-dashed border-tinta3/40 text-tinta3 opacity-50'
                        : 'border-acento/70 text-acento group-hover:border-acento group-hover:bg-card2'
                      : 'border-borda/80 text-tinta group-hover:border-acento group-hover:text-acento'
                  }`}
                >
                  <span className="text-[10px] leading-none">
                    {m.is_participacao ? '👥' : iconeDoEvento(m.tipo)}
                  </span>
                </div>
              )}
            </div>
          );
        })}
    </div>
  );
}
