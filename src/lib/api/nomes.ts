/**
 * Nomes que uma pessoa carregou ao longo da vida (fatia 02).
 *
 * Não confundir com `Person.nome`, que é o **nome de exibição** — o que aparece
 * no card da árvore. Estes são o registro completo: nascimento, público,
 * religioso, de casada.
 */

import { chamar } from './index';
import type { PersonName, NewPersonName } from '../../types';

export const listarNomesPessoa = (pessoaId: string): Promise<PersonName[]> =>
  chamar<PersonName[]>('listar_nomes_pessoa', { pessoaId });

export const adicionarNome = (novo: NewPersonName): Promise<string> =>
  chamar<string>('adicionar_nome', { novo });

export const removerNome = (id: string): Promise<void> =>
  chamar<void>('remover_nome', { id });

/**
 * Adota este nome como o de exibição da pessoa.
 *
 * Copia prefixo + nome + sufixo para `pessoas.nome` e o sobrenome para
 * `pessoas.sobrenome`. Nenhum registro de nome é apagado — dá para trocar de
 * volta a qualquer momento.
 */
export const usarNomeNaArvore = (nomeId: string): Promise<void> =>
  chamar<void>('usar_nome_na_arvore', { nomeId });
