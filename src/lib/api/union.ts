import { chamar } from './index';
import type { UnionStatus, ChildLinkType } from '../../types';

/**
 * Cria a união.
 *
 * Passar `null` num slot faz o backend criar a pessoa-placeholder — é assim
 * que se cadastra um filho conhecendo só um dos pais (seção 2.2). O modelo
 * nunca guarda slot vazio.
 */
export const criarUniao = (
  slotMasculinoId: string | null,
  slotFemininoId: string | null,
  estadoVinculo: UnionStatus = 'nao_informado',
): Promise<string> =>
  chamar<string>('criar_uniao', { slotMasculinoId, slotFemininoId, estadoVinculo });

export const atualizarUniao = (
  id: string,
  estadoVinculo: UnionStatus,
  nota?: string | null,
): Promise<void> =>
  chamar<void>('atualizar_uniao', {
    uniao: { id, estado_vinculo: estadoVinculo, nota: nota ?? null },
  });

export const removerUniao = (id: string): Promise<void> =>
  chamar<void>('remover_uniao', { id });

/**
 * Anexa um filho à união.
 *
 * Recusa se a pessoa já é filha de outra união (`FilhoJaTemUniao`) ou se a
 * ligação fecharia um laço no grafo (`CicloGenealogico`).
 */
export const anexarFilho = (
  uniaoId: string,
  pessoaId: string,
  tipoVinculo: ChildLinkType = 'biologico',
): Promise<void> => chamar<void>('anexar_filho', { uniaoId, pessoaId, tipoVinculo });

export const desvincularFilho = (pessoaId: string): Promise<void> =>
  chamar<void>('desvincular_filho', { pessoaId });

export interface UniaoRestauracao {
  id: string;
  slot_masculino_id: string;
  slot_feminino_id: string;
  estado_vinculo: string;
  nota?: string | null;
}

export const restaurarUniao = (uniao: UniaoRestauracao): Promise<string> =>
  chamar<string>('restaurar_uniao', { uniao });
