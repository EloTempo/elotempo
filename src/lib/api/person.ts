import { chamar } from './index';
import type { Person, NewPerson, PersonConnections } from '../../types';

/**
 * Pais, cônjuges e filhos de uma pessoa.
 *
 * Consulta direta ao banco, não derivada do grafo da árvore — o grafo é podado
 * pelo limite de gerações, e um cônjuge fora do recorte sumiria justamente do
 * lugar onde ele não pode faltar.
 */
export const obterConexoesPessoa = (pessoaId: string): Promise<PersonConnections> =>
  chamar<PersonConnections>('obter_conexoes_pessoa', { pessoaId });

/** Cria a pessoa e devolve o id gerado pelo backend. */
export const criarPessoa = (nova: NewPerson): Promise<string> =>
  chamar<string>('criar_pessoa', { nova });

export const obterPessoa = (id: string): Promise<Person> =>
  chamar<Person>('obter_pessoa', { id });

export const atualizarPessoa = (pessoa: Person): Promise<void> =>
  chamar<void>('atualizar_pessoa', { pessoa });

/**
 * Recusa se a pessoa ocupa um slot de união — apagar deixaria a união com um
 * lado só. O erro vem como `PessoaEmUso`.
 */
export const removerPessoa = (id: string): Promise<void> =>
  chamar<void>('remover_pessoa', { id });

/**
 * Transforma o placeholder no ancestral real, preservando os filhos já
 * pendurados nele (seção 2.2).
 */
export const promoverPlaceholder = (
  pessoaId: string,
  nome: string,
  sobrenome?: string | null,
): Promise<void> =>
  chamar<void>('promover_placeholder', { pessoaId, nome, sobrenome: sobrenome ?? null });
