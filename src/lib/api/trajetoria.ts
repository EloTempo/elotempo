import { chamar } from './index';
import type { TrajetoriaPessoa } from '../../types';

/**
 * Busca a trajetória geográfica de vida de uma pessoa, contendo todos os
 * acontecimentos que possuem coordenadas válidas (latitude/longitude),
 * ordenados cronologicamente.
 */
export const obterTrajetoriaPessoa = (pessoaId: string): Promise<TrajetoriaPessoa> =>
  chamar<TrajetoriaPessoa>('obter_trajetoria_pessoa', { pessoaId });
