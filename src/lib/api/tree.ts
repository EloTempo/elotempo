import { invoke } from '@tauri-apps/api/core';
import type { TreeGraph } from '../../types';

export const getTreeGraph = async (raizId: string, geracoes: number = 4): Promise<TreeGraph> => {
  return await invoke('fetch_arvore_enraizada', { raizId, geracoes });
};