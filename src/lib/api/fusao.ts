import { invoke } from '@tauri-apps/api/core';
import type { PersonNode } from '../../types';

export interface ResumoFusao {
  id_mestre: string;
  nome_mestre: string;
  unioes_afetadas: number;
  eventos_transferidos: number;
  documentos_transferidos: number;
  nomes_transferidos: number;
}

export interface CandidatoDuplicata {
  pessoa_a: PersonNode;
  pessoa_b: PersonNode;
  score: number;
  motivo: string;
}

/**
 * Executa a fusão de duas pessoas no acervo.
 * A `idAbsorver` é totalmente incorporada à `idMestre` e excluída.
 */
export async function fundirPessoas(
  idMestre: string,
  idAbsorver: string,
  ticketAutorizacao?: string | null,
): Promise<ResumoFusao> {
  return invoke<ResumoFusao>('fundir_pessoas', {
    idMestre,
    idAbsorver,
    ticketAutorizacao: ticketAutorizacao ?? null,
  });
}

/**
 * Detecta pares de pessoas com forte probabilidade de serem duplicatas no acervo.
 */
export async function buscarDuplicatasPotenciais(
  limite: number = 20,
): Promise<CandidatoDuplicata[]> {
  return invoke<CandidatoDuplicata[]>('buscar_duplicatas_potenciais', {
    limite,
  });
}
