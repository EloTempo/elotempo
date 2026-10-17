/**
 * Atributos de vida em lista (seção 2.5).
 *
 * Em todos, o período é opcional: a data nunca é obrigatória para salvar.
 */

import { chamar } from './index';
import type {
  Religion,
  Education,
  Profession,
  Language,
  Nickname,
  Nationality,
  Country,
  ObraCultural,
} from '../../types';

// Religião
export const adicionarReligiao = (
  pessoaId: string,
  denominacao: string,
  periodo?: string | null,
): Promise<string> =>
  chamar<string>('adicionar_religiao', { pessoaId, denominacao, periodo: periodo ?? null });

export const removerReligiao = (id: string): Promise<void> =>
  chamar<void>('remover_religiao', { id });

export const listarReligioes = (pessoaId: string): Promise<Religion[]> =>
  chamar<Religion[]>('listar_religioes', { pessoaId });

// Profissão
export const adicionarProfissao = (
  pessoaId: string,
  ocupacao: string,
  empregadorLocal?: string | null,
  periodo?: string | null,
): Promise<string> =>
  chamar<string>('adicionar_profissao', {
    pessoaId,
    ocupacao,
    empregadorLocal: empregadorLocal ?? null,
    periodo: periodo ?? null,
  });

export const removerProfissao = (id: string): Promise<void> =>
  chamar<void>('remover_profissao', { id });

export const listarProfissoes = (pessoaId: string): Promise<Profession[]> =>
  chamar<Profession[]>('listar_profissoes', { pessoaId });

// Idioma
export const adicionarIdioma = (pessoaId: string, idioma: string): Promise<string> =>
  chamar<string>('adicionar_idioma', { pessoaId, idioma });

export const removerIdioma = (id: string): Promise<void> =>
  chamar<void>('remover_idioma', { id });

export const listarIdiomas = (pessoaId: string): Promise<Language[]> =>
  chamar<Language[]>('listar_idiomas', { pessoaId });

// Escolaridade
export const adicionarEscolaridade = (
  pessoaId: string,
  nivel: string,
  instituicao?: string | null,
  periodo?: string | null,
): Promise<string> =>
  chamar<string>('adicionar_escolaridade', {
    pessoaId,
    nivel,
    instituicao: instituicao ?? null,
    periodo: periodo ?? null,
  });

export const removerEscolaridade = (id: string): Promise<void> =>
  chamar<void>('remover_escolaridade', { id });

export const listarEscolaridade = (pessoaId: string): Promise<Education[]> =>
  chamar<Education[]>('listar_escolaridade', { pessoaId });

// Nacionalidade
export const adicionarNacionalidade = (pessoaId: string, paisId: string): Promise<string> =>
  chamar<string>('adicionar_nacionalidade', { pessoaId, paisId });

export const removerNacionalidade = (id: string): Promise<void> =>
  chamar<void>('remover_nacionalidade', { id });

export const listarNacionalidades = (pessoaId: string): Promise<Nationality[]> =>
  chamar<Nationality[]>('listar_nacionalidades', { pessoaId });

// Apelido
export const adicionarApelido = (pessoaId: string, apelido: string): Promise<string> =>
  chamar<string>('adicionar_apelido', { pessoaId, apelido });

export const removerApelido = (id: string): Promise<void> =>
  chamar<void>('remover_apelido', { id });

export const listarApelidos = (pessoaId: string): Promise<Nickname[]> =>
  chamar<Nickname[]>('listar_apelidos', { pessoaId });

/** Países, com os de imigração no topo (seção 2.4). */
export const listarPaises = (): Promise<Country[]> => chamar<Country[]>('listar_paises');

// Obras Culturais
export const adicionarObraCultural = (
  pessoaId: string,
  categoria: string,
  titulo: string,
  subtipo?: string | null,
  ano?: number | null,
  anoFim?: number | null,
  detalhes?: string | null,
  localId?: string | null,
): Promise<string> =>
  chamar<string>('adicionar_obra_cultural', {
    pessoaId,
    categoria,
    titulo,
    subtipo: subtipo ?? null,
    ano: ano ?? null,
    anoFim: anoFim ?? null,
    detalhes: detalhes ?? null,
    localId: localId ?? null,
  });

export const removerObraCultural = (id: string): Promise<void> =>
  chamar<void>('remover_obra_cultural', { id });

export const listarObrasCulturais = (pessoaId: string): Promise<ObraCultural[]> =>
  chamar<ObraCultural[]>('listar_obras_culturais', { pessoaId });
