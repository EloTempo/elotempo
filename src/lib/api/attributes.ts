import { invoke } from '@tauri-apps/api/core';
import type { Nickname, Nationality, Religion, Education, Profession, Language } from '../../types';

export const addReligion = async (religion: Religion): Promise<string> => {
  return await invoke('add_religiao', { religiao: religion });
};

export const removeReligion = async (id: string): Promise<void> => {
  await invoke('remove_religiao', { id });
};

export const addProfession = async (profession: Profession): Promise<string> => {
  return await invoke('add_profissao', { profissao: profession });
};

export const removeProfession = async (id: string): Promise<void> => {
  await invoke('remove_profissao', { id });
};

export const addLanguage = async (language: Language): Promise<string> => {
  return await invoke('add_idioma', { idioma: language });
};

export const removeLanguage = async (id: string): Promise<void> => {
  await invoke('remove_idioma', { id });
};

export const addEducation = async (education: Education): Promise<string> => {
  return await invoke('add_escolaridade', { escolaridade: education });
};

export const removeEducation = async (id: string): Promise<void> => {
  await invoke('remove_escolaridade', { id });
};

export const addNationality = async (nationality: Nationality): Promise<string> => {
  return await invoke('add_nacionalidade', { nacionalidade: nationality });
};

export const removeNationality = async (id: string): Promise<void> => {
  await invoke('remove_nacionalidade', { id });
};

export const addNickname = async (nickname: Nickname): Promise<string> => {
  return await invoke('add_apelido', { apelido: nickname });
};

export const removeNickname = async (id: string): Promise<void> => {
  await invoke('remove_apelido', { id });
};
