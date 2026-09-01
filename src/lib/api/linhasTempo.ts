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
  fonte_referencia?: string | null;
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
  data_texto?: string | null;
  local?: string | null;
  ano?: number | null;
  /** Com quem, nos eventos que pertencem a uma união (o casamento). */
  com?: string | null;
}

export interface LinhaPessoal {
  pessoa_id: string;
  nome: string;
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
  apenasAlta = true,
): Promise<Marco[]> =>
  chamar<Marco[]>('buscar_marcos', {
    linhaIds,
    anoDe: anoDe ?? null,
    anoAte: anoAte ?? null,
    apenasAlta,
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
