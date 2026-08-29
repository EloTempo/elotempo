/**
 * Operações de conexão entre pessoas.
 *
 * Cada uma compõe os comandos que já existem no Rust; nenhuma regra de
 * parentesco mora aqui. Se uma invariante for violada, o erro sobe do domínio
 * com a mensagem certa — este módulo não a antecipa nem a duplica.
 */

import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import {
  obterConexoesPessoa,
  criarUniao,
  anexarFilho,
  desvincularFilho,
  atualizarUniao,
  promoverPlaceholder,
} from '../../../lib/api';
import { distribuirSlots } from '../slots';
import type { ChildLinkType, PersonSummary, UnionStatus } from '../../../types';

function invalidarAcervo(queryClient: ReturnType<typeof useQueryClient>) {
  queryClient.invalidateQueries({ queryKey: ['arvore'] });
  queryClient.invalidateQueries({ queryKey: ['conexoes'] });
  queryClient.invalidateQueries({ queryKey: ['pessoas'] });
}

export function useConexoes(pessoaId: string | null) {
  return useQuery({
    queryKey: ['conexoes', pessoaId],
    queryFn: () => obterConexoesPessoa(pessoaId!),
    enabled: !!pessoaId,
  });
}

/**
 * Cria a união dos pais e pendura a pessoa como filha.
 *
 * Os dois slots vão nulos de propósito: o backend cria os placeholders, e a
 * pessoa passa a ter um pai e uma mãe desconhecidos que dá para identificar
 * depois, um de cada vez, sem perder o vínculo. É a regra da seção 2.2 em uso.
 */
export function useAdicionarPais() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (pessoaId: string) => {
      const uniaoId = await criarUniao(null, null, 'nao_informado');
      await anexarFilho(uniaoId, pessoaId, 'biologico');
      return uniaoId;
    },
    onSuccess: () => invalidarAcervo(queryClient),
  });
}

export function useAdicionarConjuge() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (args: {
      pessoa: PersonSummary;
      conjuge: PersonSummary;
      estado: UnionStatus;
    }) => {
      const { masculino, feminino } = distribuirSlots(
        args.pessoa.id,
        args.pessoa.sexo,
        args.conjuge.id,
        args.conjuge.sexo,
      );
      return criarUniao(masculino, feminino, args.estado);
    },
    onSuccess: () => invalidarAcervo(queryClient),
  });
}

/**
 * Anexa um filho a uma união.
 *
 * Quando a pessoa ainda não tem união, cria uma com o cônjuge em placeholder —
 * é o que permite cadastrar um filho conhecendo só um dos pais.
 */
export function useAdicionarFilho() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (args: {
      uniaoId: string | null;
      pessoa: PersonSummary;
      filhoId: string;
      tipoVinculo: ChildLinkType;
    }) => {
      let uniaoId = args.uniaoId;
      if (!uniaoId) {
        const ehFeminino = args.pessoa.sexo === 'F';
        uniaoId = await criarUniao(
          ehFeminino ? null : args.pessoa.id,
          ehFeminino ? args.pessoa.id : null,
          'nao_informado',
        );
      }
      await anexarFilho(uniaoId, args.filhoId, args.tipoVinculo);
      return uniaoId;
    },
    onSuccess: () => invalidarAcervo(queryClient),
  });
}

export function useDesvincularFilho() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: desvincularFilho,
    onSuccess: () => invalidarAcervo(queryClient),
  });
}

export function useAtualizarUniao() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (args: { id: string; estado: UnionStatus }) =>
      atualizarUniao(args.id, args.estado),
    onSuccess: () => invalidarAcervo(queryClient),
  });
}

/** Dá nome a um placeholder. Os filhos já pendurados nele permanecem. */
export function usePromoverPlaceholder() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (args: { pessoaId: string; nome: string; sobrenome?: string | null }) =>
      promoverPlaceholder(args.pessoaId, args.nome, args.sobrenome),
    onSuccess: () => invalidarAcervo(queryClient),
  });
}
