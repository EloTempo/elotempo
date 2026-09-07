/**
 * Marcadores de Linha do Tempo (Fatia NLE / DaVinci Markers).
 * Anotações temporais com comentários e cores que servem de âncora magnética (Snap).
 */

import { chamar } from './index';

export interface MarcadorLinhaTempo {
  id: string;
  ano: number;
  titulo: string;
  comentario?: string | null;
  cor: string;
  arvore_id?: string | null;
  criado_em: string;
}

export interface NovoMarcadorInput {
  ano: number;
  titulo: string;
  comentario?: string | null;
  cor?: string | null;
  arvore_id?: string | null;
}

export interface EdicaoMarcadorInput {
  id: string;
  ano: number;
  titulo: string;
  comentario?: string | null;
  cor?: string | null;
}

export const listarMarcadores = (arvoreId?: string | null): Promise<MarcadorLinhaTempo[]> =>
  chamar<MarcadorLinhaTempo[]>('listar_marcadores', { arvoreId: arvoreId ?? null });

export const criarMarcador = (novo: NovoMarcadorInput): Promise<string> =>
  chamar<string>('criar_marcador', { novo });

export const atualizarMarcador = (edicao: EdicaoMarcadorInput): Promise<void> =>
  chamar<void>('atualizar_marcador', { edicao });

export const deletarMarcador = (id: string): Promise<void> =>
  chamar<void>('deletar_marcador', { id });
