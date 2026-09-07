/**
 * Linhas do tempo — a gaveta (fatia 07, seção 8).
 *
 * Não há função de escrita aqui, e é de propósito: linhas de contexto são
 * somente leitura. O conteúdo vem em migration versionada, e os gatilhos da
 * migration 013 recusam alteração mesmo por baixo.
 */

import { chamar } from './index';

/** Quantas linhas de contexto podem ficar ativas ao mesmo tempo. */
export const LIMITE_DE_CAMADAS = 3;

export interface LinhaDeContexto {
  id: string;
  categoria: string;
  titulo: string;
  is_contexto: boolean;
  is_bloqueada: boolean;
  fonte_referencia?: string | null;
  escopo?: string | null;
  icone?: string | null;
  /** Marcos de alta relevância — os únicos que a gaveta mostra. */
  marcos_alta: number;
  marcos_total: number;
  ano_min?: number | null;
  ano_max?: number | null;
}

export interface Marco {
  id: string;
  linha_id: string;
  /** O texto original: "c. 1695", "1580–1640". É o que se lê no detalhe. */
  data_periodo_texto: string;
  titulo: string;
  descricao?: string | null;
  relevancia?: string | null;
  fonte_especifica?: string | null;
  ano_inicio?: number | null;
  ano_fim?: number | null;
}

export interface MarcoPessoal {
  tipo: string;
  titulo?: string | null;
  data_texto?: string | null;
  local?: string | null;
  ano?: number | null;
  /** Com quem, nos eventos que pertencem a uma união (o casamento). */
  com?: string | null;
  is_participacao: boolean;
  linha_titulo?: string | null;
  papel?: string | null;
  visivel_na_pessoa: boolean;
}

export interface LinhaPessoal {
  pessoa_id: string;
  nome: string;
  /** Mesma cor do card na árvore — é o que liga as duas telas. */
  sexo: string;
  ano_nascimento?: number | null;
  ano_falecimento?: number | null;
  is_vivo: boolean;
  marcos: MarcoPessoal[];
}

export interface QuemEstavaVivo {
  ids: string[];
  /** Quantos não puderam ser avaliados por falta de ano de nascimento. */
  sem_data_de_nascimento: number;
}

export const listarLinhasDeContexto = (): Promise<LinhaDeContexto[]> =>
  chamar<LinhaDeContexto[]>('listar_linhas_de_contexto');

/**
 * Os marcos das linhas ativas na janela visível.
 *
 * Entra quem **se sobrepõe** à janela, não quem cabe nela: um intervalo que
 * começa antes e termina depois do recorte é justamente o que mais interessa —
 * o Estado Novo visto de dentro de 1940.
 */
export const buscarMarcos = (
  linhaIds: string[],
  anoDe?: number | null,
  anoAte?: number | null,
  apenasAlta?: boolean | null,
  relevanciaMinima?: 'alta' | 'media' | 'detalhe' | null,
): Promise<Marco[]> =>
  chamar<Marco[]>('buscar_marcos', {
    linhaIds,
    anoDe: anoDe ?? null,
    anoAte: anoAte ?? null,
    apenasAlta: apenasAlta ?? null,
    relevanciaMinima: relevanciaMinima ?? null,
  });

export const montarLinhaPessoal = (pessoaId: string): Promise<LinhaPessoal> =>
  chamar<LinhaPessoal>('montar_linha_pessoal', { pessoaId });

/** Quem estava vivo no ano ou período — o destaque na árvore. */
export const quemEstavaVivo = (
  anoInicio: number,
  anoFim?: number | null,
): Promise<QuemEstavaVivo> =>
  chamar<QuemEstavaVivo>('quem_estava_vivo', { anoInicio, anoFim: anoFim ?? null });

/** Um marco é intervalo quando cobre mais de um ano. */
export function ehIntervalo(m: Marco): boolean {
  return m.ano_fim != null && m.ano_inicio != null && m.ano_fim > m.ano_inicio;
}

// ---------- CRUD Estúdio de Linhas do Tempo (Fatia 10a) ----------

export interface NovaLinhaTempo {
  categoria: string;
  titulo: string;
  fonte_referencia?: string | null;
}

export interface EdicaoLinhaTempo {
  categoria: string;
  titulo: string;
  fonte_referencia?: string | null;
}

export interface NovoMarco {
  linha_id: string;
  data_periodo_texto: string;
  titulo: string;
  descricao?: string | null;
  relevancia: string;
  fonte_especifica?: string | null;
  ano_inicio?: number | null;
  ano_fim?: number | null;
}

export interface EdicaoMarco {
  data_periodo_texto: string;
  titulo: string;
  descricao?: string | null;
  relevancia: string;
  fonte_especifica?: string | null;
  ano_inicio?: number | null;
  ano_fim?: number | null;
}

export interface NovoParticipante {
  marco_id: string;
  pessoa_id: string;
  papel?: string | null;
  visivel_na_pessoa: boolean;
}

export const criarLinhaTempo = (nova: NovaLinhaTempo): Promise<string> =>
  chamar<string>('criar_linha_tempo', { nova });

export const atualizarLinhaTempo = (id: string, edicao: EdicaoLinhaTempo): Promise<void> =>
  chamar<void>('atualizar_linha_tempo', { id, edicao });

export const deletarLinhaTempo = (id: string): Promise<void> =>
  chamar<void>('deletar_linha_tempo', { id });

export const criarMarco = (novo: NovoMarco): Promise<string> =>
  chamar<string>('criar_marco', { novo });

export const atualizarMarco = (id: string, edicao: EdicaoMarco): Promise<void> =>
  chamar<void>('atualizar_marco', { id, edicao });

export const deletarMarco = (id: string): Promise<void> =>
  chamar<void>('deletar_marco', { id });

export const adicionarParticipante = (novo: NovoParticipante): Promise<string> =>
  chamar<string>('adicionar_participante', { novo });

export const removerParticipante = (id: string): Promise<void> =>
  chamar<void>('remover_participante', { id });

export const toggleVisibilidadeParticipacao = (id: string, visivel: boolean): Promise<void> =>
  chamar<void>('toggle_visibilidade_participacao', { id, visivel });

export interface ParticipanteDetalhado {
  id: string;
  marco_id: string;
  pessoa_id: string;
  nome: string;
  papel?: string | null;
  visivel_na_pessoa: boolean;
}

export const buscarParticipantesMarco = (marcoId: string): Promise<ParticipanteDetalhado[]> =>
  chamar<ParticipanteDetalhado[]>('buscar_participantes_marco', { marcoId });
