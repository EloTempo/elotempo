import { chamar } from './index';
import type { TreeGraph, PersonNode } from '../../types';

/**
 * Monta o grafo em volta de uma pessoa raiz.
 *
 * Devolve grafo, não desenho: as coordenadas saem de `calcularLayout`, no
 * frontend, porque o layout depende de estado de apresentação (ramos
 * colapsados, zoom) que o backend não conhece.
 */
export const buscarGrafoArvore = (
  raizId: string,
  geracoesAcima = 4,
  geracoesAbaixo = 4,
): Promise<TreeGraph> =>
  chamar<TreeGraph>('buscar_grafo_arvore', { raizId, geracoesAcima, geracoesAbaixo });

/** Busca por nome ou sobrenome, para o seletor de raiz e o painel de pesquisa. */
export const buscarPessoas = (termo = '', limite = 50): Promise<PersonNode[]> =>
  chamar<PersonNode[]>('buscar_pessoas', { termo, limite });
