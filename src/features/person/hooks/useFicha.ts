/**
 * Leitura e escrita da ficha completa de uma pessoa.
 *
 * As seis listas de atributos (seção 2.5) seguem o mesmo padrão, então em vez
 * de doze hooks quase idênticos há um construtor genérico. O que varia entre
 * elas é só o comando do Rust e a chave de cache.
 */

import { useMutation, useQuery, useQueryClient, type QueryKey } from '@tanstack/react-query';
import {
  obterPessoa,
  atualizarPessoa,
  listarEventosPessoa,
  criarEvento,
  atualizarEvento,
  removerEvento,
  listarReligioes,
  adicionarReligiao,
  removerReligiao,
  listarProfissoes,
  adicionarProfissao,
  removerProfissao,
  listarIdiomas,
  adicionarIdioma,
  removerIdioma,
  listarEscolaridade,
  adicionarEscolaridade,
  removerEscolaridade,
  listarApelidos,
  adicionarApelido,
  removerApelido,
  listarNacionalidades,
  adicionarNacionalidade,
  removerNacionalidade,
  listarPaises,
  listarNomesPessoa,
  adicionarNome,
  removerNome,
  usarNomeNaArvore,
  listarDocumentosPessoa,
  anexarDocumento,
  removerDocumento,
  definirFotoPrincipal,
} from '../../../lib/api';
import { useHistorico } from '../../../contexts/HistoricoContext';
import type { NewDocument, NewPersonName, Person } from '../../../types';

// ---------------------------------------------------------------------------
// Pessoa e eventos
// ---------------------------------------------------------------------------

export function usePessoa(pessoaId: string | null) {
  return useQuery({
    queryKey: ['pessoa', pessoaId],
    queryFn: () => obterPessoa(pessoaId!),
    enabled: !!pessoaId,
  });
}

/** Invalida tudo que muda quando a pessoa muda — inclusive a árvore. */
function invalidarPessoa(queryClient: ReturnType<typeof useQueryClient>, pessoaId: string) {
  queryClient.invalidateQueries({ queryKey: ['pessoa', pessoaId] });
  queryClient.invalidateQueries({ queryKey: ['arvore'] });
  queryClient.invalidateQueries({ queryKey: ['pessoas'] });
  queryClient.invalidateQueries({ queryKey: ['conexoes'] });
}

export function useSalvarPessoa(pessoaId: string) {
  const queryClient = useQueryClient();
  const { registrarAcao } = useHistorico();

  return useMutation({
    mutationFn: async (novaPessoa: Person) => {
      const anterior = queryClient.getQueryData<Person>(['pessoa', pessoaId]);
      await atualizarPessoa(novaPessoa);

      if (anterior) {
        registrarAcao({
          descricao: `Editar dados de ${novaPessoa.nome}`,
          desfazer: async () => {
            await atualizarPessoa(anterior);
            invalidarPessoa(queryClient, pessoaId);
          },
          refazer: async () => {
            await atualizarPessoa(novaPessoa);
            invalidarPessoa(queryClient, pessoaId);
          },
        });
      }
    },
    onSuccess: () => invalidarPessoa(queryClient, pessoaId),
  });
}

export function useEventos(pessoaId: string | null) {
  return useQuery({
    queryKey: ['eventos', pessoaId],
    queryFn: () => listarEventosPessoa(pessoaId!),
    enabled: !!pessoaId,
  });
}

function invalidarEventos(queryClient: ReturnType<typeof useQueryClient>, pessoaId: string) {
  queryClient.invalidateQueries({ queryKey: ['eventos', pessoaId] });
  // A árvore mostra os anos de nascimento e falecimento nos cards.
  queryClient.invalidateQueries({ queryKey: ['arvore'] });
  queryClient.invalidateQueries({ queryKey: ['pessoas'] });
}

export function useCriarEvento(pessoaId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: criarEvento,
    onSuccess: () => invalidarEventos(queryClient, pessoaId),
  });
}

export function useAtualizarEvento(pessoaId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: atualizarEvento,
    onSuccess: () => invalidarEventos(queryClient, pessoaId),
  });
}

export function useRemoverEvento(pessoaId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: removerEvento,
    onSuccess: () => invalidarEventos(queryClient, pessoaId),
  });
}

// ---------------------------------------------------------------------------
// Atributos em lista
// ---------------------------------------------------------------------------

/**
 * Monta o trio listar/adicionar/remover de um atributo.
 *
 * `TItem` é o formato devolvido pelo Rust; `TNovo` é o que o formulário manda.
 */
function criarHooksDeAtributo<TItem, TNovo extends unknown[]>(
  nomeDaChave: string,
  listar: (pessoaId: string) => Promise<TItem[]>,
  adicionar: (pessoaId: string, ...args: TNovo) => Promise<string>,
  remover: (id: string) => Promise<void>,
) {
  const chave = (pessoaId: string | null): QueryKey => [nomeDaChave, pessoaId];

  return {
    useLista(pessoaId: string | null) {
      return useQuery({
        queryKey: chave(pessoaId),
        queryFn: () => listar(pessoaId!),
        enabled: !!pessoaId,
      });
    },

    useAdicionar(pessoaId: string) {
      const queryClient = useQueryClient();
      return useMutation({
        mutationFn: (args: TNovo) => adicionar(pessoaId, ...args),
        onSuccess: () => {
          queryClient.invalidateQueries({ queryKey: chave(pessoaId) });
          // Os ícones de presença do card reagem a religião.
          queryClient.invalidateQueries({ queryKey: ['arvore'] });
        },
      });
    },

    useRemover(pessoaId: string) {
      const queryClient = useQueryClient();
      return useMutation({
        mutationFn: remover,
        onSuccess: () => {
          queryClient.invalidateQueries({ queryKey: chave(pessoaId) });
          queryClient.invalidateQueries({ queryKey: ['arvore'] });
        },
      });
    },
  };
}

export const religioes = criarHooksDeAtributo(
  'religioes',
  listarReligioes,
  (pessoaId, denominacao: string, periodo: string | null) =>
    adicionarReligiao(pessoaId, denominacao, periodo),
  removerReligiao,
);

export const profissoes = criarHooksDeAtributo(
  'profissoes',
  listarProfissoes,
  (pessoaId, ocupacao: string, empregador: string | null, periodo: string | null) =>
    adicionarProfissao(pessoaId, ocupacao, empregador, periodo),
  removerProfissao,
);

export const idiomas = criarHooksDeAtributo(
  'idiomas',
  listarIdiomas,
  (pessoaId, idioma: string) => adicionarIdioma(pessoaId, idioma),
  removerIdioma,
);

export const escolaridade = criarHooksDeAtributo(
  'escolaridade',
  listarEscolaridade,
  (pessoaId, nivel: string, instituicao: string | null, periodo: string | null) =>
    adicionarEscolaridade(pessoaId, nivel, instituicao, periodo),
  removerEscolaridade,
);

export const apelidos = criarHooksDeAtributo(
  'apelidos',
  listarApelidos,
  (pessoaId, apelido: string) => adicionarApelido(pessoaId, apelido),
  removerApelido,
);

export const nacionalidades = criarHooksDeAtributo(
  'nacionalidades',
  listarNacionalidades,
  (pessoaId, paisId: string) => adicionarNacionalidade(pessoaId, paisId),
  removerNacionalidade,
);

// ---------------------------------------------------------------------------
// Nomes ao longo da vida (fatia 02)
// ---------------------------------------------------------------------------

export function useNomes(pessoaId: string | null) {
  return useQuery({
    queryKey: ['nomes', pessoaId],
    queryFn: () => listarNomesPessoa(pessoaId!),
    enabled: !!pessoaId,
  });
}

export function useAdicionarNome(pessoaId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (novo: NewPersonName) => adicionarNome(novo),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['nomes', pessoaId] }),
  });
}

export function useRemoverNome(pessoaId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: removerNome,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['nomes', pessoaId] }),
  });
}

/**
 * Adota um nome como o de exibição.
 *
 * Invalida a árvore e a busca junto, porque o card e a lista lateral passam a
 * mostrar outra coisa.
 */
export function useUsarNomeNaArvore(pessoaId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: usarNomeNaArvore,
    onSuccess: () => invalidarPessoa(queryClient, pessoaId),
  });
}

// ---------------------------------------------------------------------------
// Fotos e documentos (fatia 03)
// ---------------------------------------------------------------------------

export function useDocumentos(pessoaId: string | null) {
  return useQuery({
    queryKey: ['documentos', pessoaId],
    queryFn: () => listarDocumentosPessoa(pessoaId!),
    enabled: !!pessoaId,
  });
}

function invalidarDocumentos(
  queryClient: ReturnType<typeof useQueryClient>,
  pessoaId: string,
) {
  queryClient.invalidateQueries({ queryKey: ['documentos', pessoaId] });
  // O card mostra o retrato e o ícone de "tem documentos".
  queryClient.invalidateQueries({ queryKey: ['arvore'] });
  queryClient.invalidateQueries({ queryKey: ['pessoa', pessoaId] });
}

export function useAnexarDocumento(pessoaId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (novo: NewDocument) => anexarDocumento(novo),
    onSuccess: () => invalidarDocumentos(queryClient, pessoaId),
  });
}

export function useRemoverDocumento(pessoaId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: removerDocumento,
    onSuccess: () => invalidarDocumentos(queryClient, pessoaId),
  });
}

/** Passar `null` limpa o retrato. */
export function useDefinirFotoPrincipal(pessoaId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (documentoId: string | null) => definirFotoPrincipal(pessoaId, documentoId),
    onSuccess: () => invalidarDocumentos(queryClient, pessoaId),
  });
}

/** Países, com Brasil e os de imigração no topo (seção 2.4). */
export function usePaises() {
  return useQuery({
    queryKey: ['paises'],
    queryFn: listarPaises,
    // Lista fixa que vem de uma migration: não muda em tempo de execução.
    staleTime: Infinity,
  });
}
