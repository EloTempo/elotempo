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

/** Meses por extenso, na ordem. Espelha `datas::MESES` no Rust. */
export const MESES = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
] as const;

/**
 * Uma data escolhida nas listas suspensas.
 *
 * Chega estruturada em vez de digitada: com isso o programa **sabe** o dia e o
 * mês, em vez de tentar deduzi-los de texto livre — que era o que fazia a
 * exportação GEDCOM perder fidelidade.
 *
 * `qualificador` aceita `'livre'` além dos valores do banco: é a saída para o
 * que a estrutura não comporta ("na época da guerra"), e ao salvar vira
 * `desconhecida` com o texto preservado.
 */
export interface DataEscolhida {
  qualificador: DateQualifier | 'livre' | null;
  dia: number | null;
  mes: number | null;
  ano: number | null;
  /** Só no qualificador `intervalo`. */
  ano_fim: number | null;
  texto_livre: string | null;
}

export const DATA_VAZIA: DataEscolhida = {
  qualificador: null,
  dia: null,
  mes: null,
  ano: null,
  ano_fim: null,
  texto_livre: null,
};

/** Tipos canônicos de evento — sempre minúsculos, como o Rust normaliza. */
export const TIPOS_EVENTO = {
  nascimento: 'nascimento',
  batismo: 'batismo',
  casamento: 'casamento',
  falecimento: 'falecimento',
  sepultamento: 'sepultamento',
} as const;

export type TipoTempo = 'real' | 'ficticio';

export interface Person {
  id: string;
  nome: string;
  sobrenome?: string | null;
  sexo: Sex;
  minibiografia?: string | null;
  is_vivo: boolean;
  is_placeholder: boolean;
  foto_url?: string | null;
  is_publico?: boolean;
  categoria?: string | null;
  tipo_tempo?: TipoTempo;
}

/** O que se envia para criar — sem `id`, que o backend gera. */
export interface NewPerson {
  nome: string;
  sobrenome?: string | null;
  sexo: Sex;
  minibiografia?: string | null;
  is_vivo: boolean;
  foto_url?: string | null;
  tipo_tempo?: TipoTempo;
}

export interface Union {
  id: string;
  slot_masculino_id: string;
  slot_feminino_id: string;
  estado_vinculo: UnionStatus;
  nota?: string | null;
}

/**
 * Um lugar. Município brasileiro do seed do IBGE, ou cidade estrangeira criada
 * no uso.
 *
 * `codigo_ibge` é a chave estável exigida pela seção 2.4 — nome de cidade muda
 * com o tempo, o código não. Nulo no exterior, onde só o país é padronizado.
 */
export interface Place {
  id: string;
  nome: string;
  uf?: string | null;
  pais_id: string;
  codigo_ibge?: string | null;
  pais_nome: string;
}

/** "Campos dos Goytacazes, RJ" ou "Lisboa, Portugal". */
export function rotuloDoLocal(local: Place): string {
  return local.uf ? `${local.nome}, ${local.uf}` : `${local.nome}, ${local.pais_nome}`;
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
  /** Nome do local já resolvido pelo backend. */
  local_nome?: string | null;
  rotulo_historico_livre?: string | null;
  denominacao_religiosa?: string | null;
  instituicao?: string | null;
  nota?: string | null;
}

export interface NewEvent {
  pessoa_id?: string | null;
  uniao_id?: string | null;
  tipo_evento: string;
  /** Caminho antigo, ainda usado pela importação. */
  data_texto?: string | null;
  /** Caminho novo: quando vem preenchido, manda. */
  data?: DataEscolhida | null;
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

/** Apelido: alcunha afetiva ("Zezinho", "a Tia Chica"). GEDCOM `NICK`. */
export interface Nickname {
  id: string;
  pessoa_id: string;
  apelido: string;
}

/**
 * Tipos de nome (fatia 02).
 *
 * `publico`, `religioso` e `artistico` caem todos em `AKA` no GEDCOM, mas aqui
 * ficam separados: num acervo de figuras históricas, saber que "Francisco" é
 * nome religioso e não apelido é o dado, não um detalhe.
 */
export type NameType =
  | 'nascimento'
  | 'publico'
  | 'religioso'
  | 'casada'
  | 'solteira'
  | 'artistico'
  | 'profissional'
  | 'imigracao'
  | 'outro';

/** Um nome que a pessoa carregou. Distinto do nome de exibição em `Person`. */
export interface PersonName {
  id: string;
  pessoa_id: string;
  tipo: NameType;
  prefixo?: string | null;
  nome: string;
  sobrenome?: string | null;
  sufixo?: string | null;
  periodo?: string | null;
  nota?: string | null;
  ordem?: number | null;
}

export interface NewPersonName {
  pessoa_id: string;
  tipo: NameType;
  prefixo?: string | null;
  nome: string;
  sobrenome?: string | null;
  sufixo?: string | null;
  periodo?: string | null;
  nota?: string | null;
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
  minibiografia?: string | null;
  /** Caminho relativo do retrato, quando há um escolhido (fatia 03). */
  foto_url?: string | null;
  /** Ícones de presença do card (seção 10). */
  tem_foto: boolean;
  tem_biografia: boolean;
  tem_documentos: boolean;
  tem_religiao: boolean;
  is_publico?: boolean;
  categoria?: string | null;
  tipo_tempo?: TipoTempo;
  arvore_nome?: string | null;
  arvore_id?: string | null;
  tipo_vinculo?: string | null;
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
// Fotos e documentos (fatia 03)
// ---------------------------------------------------------------------------

export interface Document {
  id: string;
  /**
   * Caminho **relativo** à pasta de dados do app ("midia/<id>.jpg").
   * Nunca absoluto: é o que faz o acervo sobreviver a uma cópia entre máquinas.
   */
  caminho_relativo: string;
  /** "imagem" ou "documento" — decide se a ficha mostra miniatura. */
  tipo_midia: 'imagem' | 'documento';
  tamanho_bytes?: number | null;
  data_documento?: string | null;
  titulo?: string | null;
  descricao?: string | null;
  nome_original?: string | null;
}

export interface NewDocument {
  pessoa_id: string;
  /** Caminho absoluto do arquivo escolhido; o Rust copia a partir dele. */
  caminho_origem: string;
  titulo?: string | null;
  data_documento?: string | null;
  descricao?: string | null;
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
  is_publico?: boolean;
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
