import { invoke } from '@tauri-apps/api/core';
import type { Union, UnionChild } from '../../types';

export const createUnion = async (union: Union): Promise<string> => {
  return await invoke('create_uniao', { uniao: union });
};

export const updateUnion = async (union: Union): Promise<void> => {
  await invoke('update_uniao', { uniao: union });
};

export const deleteUnion = async (id: string): Promise<void> => {
  await invoke('delete_uniao', { id });
};

export const addChildToUnion = async (childLink: UnionChild): Promise<void> => {
  await invoke('add_filho_uniao', { vinculo: childLink });
};
