// src/lib/api/person.ts
import { invoke } from '@tauri-apps/api/core';
import type { Person } from '../../types';

export const createPerson = async (person: Person): Promise<string> => {
  return await invoke('create_pessoa', { pessoa: person });
};

export const getPerson = async (id: string): Promise<Person> => {
  return await invoke('get_pessoa', { id });
};

export const updatePerson = async (person: Person): Promise<void> => {
  await invoke('update_pessoa', { pessoa: person });
};

export const deletePerson = async (id: string): Promise<void> => {
  await invoke('delete_pessoa', { id });
};