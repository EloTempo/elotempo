/**
 * Fontes e Citações Históricas (fatia 07 / seção 2.7).
 *
 * Provê a infraestrutura de comprovação documental para certidões de nascimento,
 * casamentos em paróquia, censos e fontes arquivísticas no EloTempo.
 */

import { chamar } from './index';

export type TipoFonte =
  | 'certidao'
  | 'censo'
  | 'registro_paroquial'
  | 'jornal'
  | 'livro'
  | 'lapide'
  | 'entrevista'
  | 'correspondencia'
  | 'fotografia'
  | 'outro';

export type GrauConfianca = 'alta' | 'media' | 'baixa' | 'questionavel';

export interface Fonte {
  id: string;
  titulo: string;
  tipo?: TipoFonte | null;
  autor_orgao?: string | null;
  data_publicacao?: string | null;
  repositorio?: string | null;
  referencia?: string | null;
  nota?: string | null;
  data_criacao?: string | null;
}

export interface NovaFonte {
  titulo: string;
  tipo?: TipoFonte | null;
  autor_orgao?: string | null;
  data_publicacao?: string | null;
  repositorio?: string | null;
  referencia?: string | null;
  nota?: string | null;
}

export interface CitacaoComFonte {
  id: string;
  fonte_id: string;
  alvo_tipo: string;
  alvo_id: string;
  pagina_folha?: string | null;
  confianca?: GrauConfianca | null;
  transcricao?: string | null;
  nota?: string | null;
  fonte_titulo: string;
  fonte_tipo?: TipoFonte | null;
  fonte_autor_orgao?: string | null;
  fonte_repositorio?: string | null;
  fonte_referencia?: string | null;
}

export interface NovaCitacao {
  fonte_id: string;
  alvo_tipo: string;
  alvo_id: string;
  pagina_folha?: string | null;
  confianca?: GrauConfianca | null;
  transcricao?: string | null;
  nota?: string | null;
}

export const listarFontes = (busca?: string): Promise<Fonte[]> =>
  chamar<Fonte[]>('listar_fontes', { busca });

export const obterFonte = (id: string): Promise<Fonte> =>
  chamar<Fonte>('obter_fonte', { id });

export const criarFonte = (dados: NovaFonte): Promise<Fonte> =>
  chamar<Fonte>('criar_fonte', { dados });

export const atualizarFonte = (id: string, dados: NovaFonte): Promise<Fonte> =>
  chamar<Fonte>('atualizar_fonte', { id, dados });

export const removerFonte = (id: string): Promise<void> =>
  chamar<void>('remover_fonte', { id });

export const listarCitacoesDoAlvo = (alvoTipo: string, alvoId: string): Promise<CitacaoComFonte[]> =>
  chamar<CitacaoComFonte[]>('listar_citacoes_do_alvo', { alvoTipo, alvoId });

export const criarCitacao = (dados: NovaCitacao): Promise<CitacaoComFonte> =>
  chamar<CitacaoComFonte>('criar_citacao', { dados });

export const removerCitacao = (id: string): Promise<void> =>
  chamar<void>('remover_citacao', { id });
