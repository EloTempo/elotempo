/**
 * Tipos espelhando os modelos do backend Rust.
 *
 * Os nomes de campo são os do banco (`is_vivo`, `slot_masculino_id`) porque é
 * assim que o serde serializa do outro lado. Traduzir aqui só criaria um
 * dicionário a mais para manter em dia.
 */

export type Sex = 'M' | 'F' | 'X' | 'U';
export type UnionStatus = 'casamento' | 'estavel' | 'dissolvida' | 'nao_informado';
export type ChildLinkType = 'biologico' | 'adotado' | 'enteado' | 'tutelado';

export type DateQualifier =
  | 'exata'
  | 'cerca_de'
  | 'antes_de'
  | 'apos'
  | 'intervalo'
  | 'desconhecida';

/** Tipos canônicos de evento — sempre minúsculos, como o Rust normaliza. */
export const TIPOS_EVENTO = {
  nascimento: 'nascimento',
  batismo: 'batismo',
  casamento: 'casamento',
  falecimento: 'falecimento',
  sepultamento: 'sepultamento',
} as const;

export interface Person {
  id: string;
  nome: string;
  sobrenome?: string | null;
  sexo: Sex;
  minibiografia?: string | null;
  is_vivo: boolean;
  is_placeholder: boolean;
  foto_url?: string | null;
}

/** O que se envia para criar — sem `id`, que o backend gera. */
export interface NewPerson {
  nome: string;
  sobrenome?: string | null;
  sexo: Sex;
  minibiografia?: string | null;
  is_vivo: boolean;
  foto_url?: string | null;
}

export interface Union {
  id: string;
  slot_masculino_id: string;
  slot_feminino_id: string;
  estado_vinculo: UnionStatus;
  nota?: string | null;
}

export interface Event {
  id: string;
  pessoa_id?: string | null;
  uniao_id?: string | null;
  tipo_evento: string;
  data_texto?: string | null;
  data_qualificador: DateQualifier;
  ano_inicio?: number | null;
  ano_fim?: number | null;
  local_id?: string | null;
  rotulo_historico_livre?: string | null;
  denominacao_religiosa?: string | null;
  instituicao?: string | null;
  nota?: string | null;
}

export interface NewEvent {
  pessoa_id?: string | null;
  uniao_id?: string | null;
  tipo_evento: string;
  data_texto?: string | null;
  local_id?: string | null;
  rotulo_historico_livre?: string | null;
  denominacao_religiosa?: string | null;
  instituicao?: string | null;
  nota?: string | null;
}

export interface Country {
  id: string;
  nome: string;
  codigo_iso?: string | null;
  ordem_destaque: number;
}

export interface Religion {
  id: string;
  pessoa_id: string;
  denominacao: string;
  periodo?: string | null;
}

export interface Education {
  id: string;
  pessoa_id: string;
  nivel: string;
  instituicao?: string | null;
  periodo?: string | null;
}

export interface Profession {
  id: string;
  pessoa_id: string;
  ocupacao: string;
  empregador_local?: string | null;
  periodo?: string | null;
}

export interface Language {
  id: string;
  pessoa_id: string;
  idioma: string;
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

// ---------------------------------------------------------------------------
// Grafo da árvore (o que `buscar_grafo_arvore` devolve)
// ---------------------------------------------------------------------------

export interface PersonNode {
  id: string;
  nome: string;
  sobrenome?: string | null;
  sexo: string;
  is_vivo: boolean;
  is_placeholder: boolean;
  ano_nascimento?: number | null;
  ano_falecimento?: number | null;
  /** Ícones de presença do card (seção 10). */
  tem_foto: boolean;
  tem_biografia: boolean;
  tem_documentos: boolean;
  tem_religiao: boolean;
}

export interface UnionNode {
  id: string;
  estado_vinculo: string;
  ano_casamento?: number | null;
  slot_masculino_id: string;
  slot_feminino_id: string;
}

export interface GraphLink {
  source: string;
  target: string;
  tipo: 'pai_uniao' | 'mae_uniao' | 'uniao_filho';
  tipo_vinculo?: string | null;
}

export interface TreeGraph {
  raiz_id: string;
  nodes: PersonNode[];
  unions: UnionNode[];
  links: GraphLink[];
}

// ---------------------------------------------------------------------------
// Conexões de uma pessoa (o que `obter_conexoes_pessoa` devolve)
// ---------------------------------------------------------------------------

export interface PersonSummary {
  id: string;
  nome: string;
  sobrenome?: string | null;
  sexo: Sex;
  is_placeholder: boolean;
}

export interface UnionSummary {
  id: string;
  estado_vinculo: UnionStatus;
  /** Ocupante do slot masculino. Nunca nulo — no pior caso, um placeholder. */
  masculino: PersonSummary;
  /** Ocupante do slot feminino. Nunca nulo. */
  feminino: PersonSummary;
  /**
   * Onde está a pessoa consultada. `nenhum` é o caso da união dos pais dela —
   * e é por isso que os dois lados vêm resolvidos em vez de um campo "cônjuge":
   * ali não há cônjuge, há pai e mãe, e os dois têm de aparecer.
   */
  slot_da_pessoa: 'masculino' | 'feminino' | 'nenhum';
  filhos: PersonSummary[];
}

/** O outro lado da união, do ponto de vista de quem foi consultado. */
export function conjugeDe(u: UnionSummary): PersonSummary {
  return u.slot_da_pessoa === 'masculino' ? u.feminino : u.masculino;
}

export interface PersonConnections {
  pessoa: PersonSummary;
  /** A união da qual ela é filha. No máximo uma — invariante da seção 3. */
  uniao_de_origem?: UnionSummary | null;
  /** As uniões em que ela é cônjuge. Podem ser várias. */
  unioes: UnionSummary[];
}

// ---------------------------------------------------------------------------
// Erros do domínio (espelha `ErroDominio` no Rust)
// ---------------------------------------------------------------------------

export type DomainErrorCode =
  | 'PessoaNaoEncontrada'
  | 'UniaoNaoEncontrada'
  | 'SlotIncompativel'
  | 'FilhoJaTemUniao'
  | 'CicloGenealogico'
  | 'SexoTravadoPorUniao'
  | 'PessoaEmUso'
  | 'ValorInvalido'
  | 'Persistencia';

export interface DomainError {
  codigo: DomainErrorCode;
  detalhe?: unknown;
}
