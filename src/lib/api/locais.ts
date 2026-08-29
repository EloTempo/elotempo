/**
 * Locais (fatia 04).
 *
 * Os 5.571 municípios vêm do seed do IBGE, versionado na migration 009. O app
 * nunca consulta a API do IBGE em tempo de execução.
 */

import { chamar } from './index';
import type { Place } from '../../types';

/**
 * Autocomplete de local.
 *
 * A busca é feita numa coluna sem acento: "sao paulo" encontra "São Paulo".
 * Termo vazio devolve lista vazia, não o acervo inteiro.
 */
export const buscarLocais = (termo: string, limite = 20): Promise<Place[]> =>
  chamar<Place[]>('buscar_locais', { termo, limite });

export const obterLocal = (id: string): Promise<Place> =>
  chamar<Place>('obter_local', { id });

/**
 * Registra uma cidade no exterior, ou devolve a que já existe.
 *
 * Cidade estrangeira é texto livre — só o país é padronizado (seção 2.4). A
 * deduplicação por nome+país é o que impede "Lisboa" de virar três lugares e
 * quebrar o agrupamento por país.
 */
export const registrarLocalEstrangeiro = (nome: string, paisId: string): Promise<Place> =>
  chamar<Place>('registrar_local_estrangeiro', { nome, paisId });
