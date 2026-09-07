/**
//! Estatísticas e Demografia da Família (Fatia 11, Seção 7).
 */

import { chamar } from './index';
import type { FiltrosBusca } from './busca';

export interface ContagemItem {
  chave: string;
  rotulo: string;
  contagem: number;
  percentual: number;
}

export interface EstatisticasAcervo {
  total_pessoas: number;
  total_vivas: number;
  total_falecidas: number;
  total_com_nascimento: number;
  idade_media_falecimento?: number | null;
  ano_mais_antigo?: number | null;
  ano_mais_recente?: number | null;

  distribuicao_sexo: ContagemItem[];
  distribuicao_situacao: ContagemItem[];
  distribuicao_decadas: ContagemItem[];
  distribuicao_sobrenomes: ContagemItem[];
  distribuicao_cidades: ContagemItem[];
  distribuicao_paises: ContagemItem[];
  distribuicao_religioes: ContagemItem[];
  distribuicao_profissoes: ContagemItem[];
  distribuicao_escolaridade: ContagemItem[];
}

export const calcularEstatisticas = (filtros?: FiltrosBusca): Promise<EstatisticasAcervo> =>
  chamar<EstatisticasAcervo>('calcular_estatisticas', { filtros: filtros ?? null });
