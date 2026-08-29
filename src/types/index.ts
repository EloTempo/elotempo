export type Sex = 'M' | 'F' | 'X' | 'U';
export type UnionStatus = 'casamento' | 'estavel' | 'dissolvida' | 'nao_informado';
export type ChildLinkType = 'biologico' | 'adotado' | 'enteado' | 'tutelado';

export interface Person {
  id: string;
  nome: string;
  sobrenome?: string;
  sexo: Sex;
  minibiografia?: string;
  is_vivo: boolean;
  is_placeholder: boolean;
  foto_url?: string;
}

export interface Union {
  id: string;
  slot_masculino_id: string;
  slot_feminino_id: string;
  estado_vinculo: UnionStatus;
  nota?: string;
}

export interface UnionChild {
  uniao_id: string;
  pessoa_id: string;
  tipo_vinculo: ChildLinkType;
  ordem?: number;
}

export interface Event {
  id: string;
  pessoa_id?: string;
  uniao_id?: string;
  tipo_evento: string;
  data_texto?: string;
  local_id?: string;
  rotulo_historico_livre?: string;
  nota?: string;
}

export interface Country {
  id: string;
  nome: string;
  codigo_iso?: string;
}

export interface Location {
  id: string;
  nome: string;
  uf?: string;
  pais_id: string;
  codigo_ibge?: string;
}

export interface Nickname {
  id: string;
  pessoa_id: string;
  apelido: string;
}

export interface Nationality {
  id: string;
  pessoa_id: string;
  pais_id: string;
}

export interface Religion {
  id: string;
  pessoa_id: string;
  denominacao: string;
  periodo?: string;
}

export interface Education {
  id: string;
  pessoa_id: string;
  nivel: string;
  instituicao?: string;
  periodo?: string;
}

export interface Profession {
  id: string;
  pessoa_id: string;
  ocupacao: string;
  empregador_local?: string;
  periodo?: string;
}

export interface Language {
  id: string;
  pessoa_id: string;
  idioma: string;
}

// For D3 Graph mapping
export interface PersonNode {
  id: string;
  nome: string;
  sobrenome?: string;
  sexo: string;
  is_vivo: boolean;
  is_placeholder: boolean;
  ano_nascimento?: string;
  x?: number;
  y?: number;
}

export interface UnionNode {
  id: string;
  estado_vinculo: string;
  data_casamento?: string;
  x?: number;
  y?: number;
}

export interface GraphLink {
  source: string;
  target: string;
  tipo: string;
}

export interface TreeGraph {
  nodes: PersonNode[];
  unions: UnionNode[];
  links: GraphLink[];
}
