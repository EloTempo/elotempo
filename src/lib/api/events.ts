import { invoke } from '@tauri-apps/api/core';
import type { Event } from '../../types';

export const createEvent = async (event: Event): Promise<string> => {
  return await invoke('create_evento', { evento: event });
};

export const updateEvent = async (event: Event): Promise<void> => {
  await invoke('update_evento', { evento: event });
};

export const deleteEvent = async (id: string): Promise<void> => {
  await invoke('delete_evento', { id });
};

export const listPersonEvents = async (pessoaId: string): Promise<Event[]> => {
  return await invoke('list_eventos_pessoa', { pessoaId });
};
