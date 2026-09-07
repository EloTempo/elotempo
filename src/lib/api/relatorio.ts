/**
 * Relatório impresso (fatia 05).
 *
 * O backend devolve tudo pronto e **já ordenado** — geração, ano, nome. A
 * ordenação é decisão de domínio (seção 6), não de apresentação, e por isso
 * mora no Rust, onde tem teste.
 */

import { chamar } from './index';

export interface EventoRelatorio {
  tipo: string;
  /** O texto que o usuário escreveu. Nunca o ano derivado. */
  data_texto?: string | null;
  local?: string | null;
  nota?: string | null;
}

export interface UniaoRelatorio {
  conjuge: string;
  estado_vinculo: string;
  data_texto?: string | null;
  filhos: string[];
}

export interface EntradaRelatorio {
  id: string;
  nome: string;
  sobrenome?: string | null;
  sexo: string;
  is_vivo: boolean;
  is_placeholder: boolean;
  foto_url?: string | null;
  minibiografia?: string | null;
  geracao: number;
  ano_nascimento?: number | null;

  nascimento?: EventoRelatorio | null;
  falecimento?: EventoRelatorio | null;
  outros_eventos: EventoRelatorio[];

  outros_nomes: string[];
  apelidos: string[];
  nacionalidades: string[];
  religioes: string[];
  escolaridade: string[];
  profissoes: string[];
  idiomas: string[];

  pais: string[];
  unioes: UniaoRelatorio[];
}

export interface Relatorio {
  entradas: EntradaRelatorio[];
  total: number;
  /** Quantas ficaram de fora por estarem vivas. */
  omitidas_vivas: number;
}

export interface OpcoesRelatorio {
  /** `null` = acervo inteiro. */
  raiz_id: string | null;
  ocultar_vivas: boolean;
  incluir_placeholders: boolean;
}

export const montarRelatorio = (
  opcoes: OpcoesRelatorio,
  ticketAutorizacao?: string | null,
): Promise<Relatorio> =>
  chamar<Relatorio>('montar_relatorio', { opcoes, ticketAutorizacao: ticketAutorizacao ?? null });
