/**
 * Busca multicritério (fatia 06, seção 7).
 *
 * Os filtros se acumulam em `E`: quem aparece passou em todos. Campo vazio não
 * filtra — sem nenhum critério, a lista é o acervo.
 */

import { chamar } from './index';
import type { PersonNode } from '../../types';

export interface FiltrosBusca {
  /** Nome, sobrenome, ou qualquer nome que a pessoa tenha carregado. */
  texto?: string | null;
  sobrenome?: string | null;
  /** Local do **nascimento** — ver a decisão declarada na spec da fatia 06. */
  local_id?: string | null;
  pais_id?: string | null;
  /** 1940 casa com quem nasceu entre 1940 e 1949. */
  decada?: number | null;
  religiao?: string | null;
  profissao?: string | null;
  idioma?: string | null;
  escolaridade?: string | null;
  /** `true` = só vivas; `false` = só falecidas; `null` = ambas. */
  apenas_vivas?: boolean | null;
  incluir_placeholders: boolean;
}

export interface OpcaoDeFiltro {
  valor: string;
  rotulo: string;
  /** Quantas pessoas têm este valor. Ajuda a escolher onde há o que ver. */
  quantas: number;
}

export interface OpcoesDeFiltro {
  religioes: OpcaoDeFiltro[];
  profissoes: OpcaoDeFiltro[];
  idiomas: OpcaoDeFiltro[];
  escolaridade: OpcaoDeFiltro[];
  decadas: OpcaoDeFiltro[];
  paises: OpcaoDeFiltro[];
  locais: OpcaoDeFiltro[];
}

export const buscarPessoasFiltrado = (
  filtros: FiltrosBusca,
  limite = 200,
): Promise<PersonNode[]> => chamar<PersonNode[]>('buscar_pessoas_filtrado', { filtros, limite });

/**
 * O que os seletores devem oferecer — só o que existe no acervo.
 *
 * Mostrar a taxonomia inteira faria o usuário escolher "Budista" num acervo sem
 * nenhum budista e receber lista vazia, o que parece defeito do programa.
 */
export const opcoesDeFiltro = (): Promise<OpcoesDeFiltro> =>
  chamar<OpcoesDeFiltro>('opcoes_de_filtro');
