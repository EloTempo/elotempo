/**
//! Múltiplas Árvores Nomeadas e Conexões (Fatia 12, Seção 5).
 */

import { chamar } from './index';
import type { TipoTempo } from '../../types';

export interface ArvoreInfo {
  id: string;
  nome: string;
  descricao?: string | null;
  raiz_pessoa_id?: string | null;
  raiz_pessoa_nome?: string | null;
  total_membros: number;
  data_criacao?: string | null;
  data_modificacao?: string | null;
  is_publico?: boolean;
  categoria?: string | null;
  pais?: string | null;
  periodo?: string | null;
  tipo_tempo?: TipoTempo;
}

export interface NovaArvoreInput {
  nome: string;
  descricao?: string | null;
  raiz_pessoa_id?: string | null;
  categoria?: string | null;
  pais?: string | null;
  periodo?: string | null;
  tipo_tempo?: TipoTempo;
}

export interface AtualizarArvoreInput {
  id: string;
  nome: string;
  descricao?: string | null;
  raiz_pessoa_id?: string | null;
  categoria?: string | null;
  pais?: string | null;
  periodo?: string | null;
  tipo_tempo?: TipoTempo;
}

export const listarArvores = (): Promise<ArvoreInfo[]> =>
  chamar<ArvoreInfo[]>('listar_arvores');

export const obterArvore = (id: string): Promise<ArvoreInfo> =>
  chamar<ArvoreInfo>('obter_arvore', { id });

export const criarArvore = (dados: NovaArvoreInput): Promise<ArvoreInfo> =>
  chamar<ArvoreInfo>('criar_arvore', { dados });

export const atualizarArvore = (dados: AtualizarArvoreInput): Promise<ArvoreInfo> =>
  chamar<ArvoreInfo>('atualizar_arvore', { dados });

export const deletarArvore = (id: string, ticketAutorizacao?: string | null): Promise<void> =>
  chamar<void>('deletar_arvore', { id, ticketAutorizacao: ticketAutorizacao ?? null });

export const definirRaizArvore = (
  arvoreId: string,
  raizPessoaId: string,
): Promise<ArvoreInfo> =>
  chamar<ArvoreInfo>('definir_raiz_arvore', {
    arvoreId,
    raizPessoaId,
  });
