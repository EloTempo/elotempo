import { invoke } from '@tauri-apps/api/core';

export interface PassoParentesco {
  pessoa_id: string;
  nome: string;
  sobrenome: string | null;
  sexo: string;
  foto_url: string | null;
  papel: string;
}

export interface ParentescoResultado {
  pessoa_a_id: string;
  pessoa_b_id: string;
  pessoa_a_nome: string;
  pessoa_b_nome: string;
  tem_parentesco: boolean;
  tipo_relacao: 'consanguineo' | 'afim' | 'mesma_pessoa' | 'nenhum';
  descricao_parentesco: string;
  grau_consanguinidade: number | null;
  distancia_geracoes_a: number | null;
  distancia_geracoes_b: number | null;
  ancestral_comum: PassoParentesco | null;
  caminho: PassoParentesco[];
}

export async function calcularParentesco(
  pessoaAId: string,
  pessoaBId: string,
): Promise<ParentescoResultado> {
  return await invoke<ParentescoResultado>('calcular_parentesco', {
    pessoaAId,
    pessoaBId,
  });
}
