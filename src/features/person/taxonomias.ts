/**
 * Taxonomias da seção 2.5.
 *
 * São **sugestões**, nunca listas fechadas. Cada campo que as usa aceita texto
 * livre ao lado: um acervo familiar tem casos que nenhuma taxonomia prevê, e
 * travar o usuário aqui faria perder o dado que ele veio registrar.
 *
 * Entram como `<datalist>`, que é o controle certo para isso — o navegador
 * mostra as opções e continua aceitando qualquer coisa digitada.
 */

/** Denominações religiosas, agrupadas por tradição (seção 2.5). */
export const RELIGIOES = [
  'Católica (Apostólica Romana)',
  'Evangélica — Batista',
  'Evangélica — Assembleia de Deus',
  'Evangélica — Congregacional',
  'Evangélica — Presbiteriana',
  'Evangélica — Metodista',
  'Evangélica — Universal',
  'Evangélica — Adventista',
  'Evangélica — Quadrangular',
  'Evangélica/Protestante (outra)',
  'Espírita (kardecista)',
  'Umbanda',
  'Candomblé',
  'Testemunha de Jeová',
  'Judaica',
  'Islâmica',
  'Budista',
  'Maçonaria',
  'Sem religião',
  'Não informada',
] as const;

/** Níveis de ensino na taxonomia brasileira (seção 2.5). */
export const NIVEIS_ESCOLARIDADE = [
  'Fundamental incompleto',
  'Fundamental completo',
  'Médio incompleto',
  'Médio completo',
  'Técnico',
  'Superior incompleto',
  'Superior completo',
  'Especialização',
  'Mestrado',
  'Doutorado',
] as const;

/**
 * Idiomas comuns num acervo brasileiro.
 *
 * A ordem privilegia os que aparecem de fato nas famílias daqui — línguas de
 * imigração e as indígenas de maior presença — antes das de estudo.
 */
export const IDIOMAS = [
  'Português',
  'Italiano',
  'Espanhol',
  'Alemão',
  'Japonês',
  'Árabe',
  'Polonês',
  'Ucraniano',
  'Iídiche',
  'Inglês',
  'Francês',
  'Talian (vêneto brasileiro)',
  'Hunsrückisch (alemão riograndense)',
  'Guarani',
  'Nheengatu',
  'Libras',
] as const;

/**
 * Tipos de nome (fatia 02), com uma frase que diz quando cada um se aplica.
 *
 * A explicação existe porque a distinção entre "público" e "apelido" não é
 * óbvia — e errá-la é justamente o problema que a fatia veio resolver.
 */
export const TIPOS_DE_NOME = [
  {
    valor: 'nascimento',
    rotulo: 'De nascimento',
    ajuda: 'O nome completo de registro, como está na certidão.',
  },
  {
    valor: 'publico',
    rotulo: 'Público',
    ajuda: 'O nome pelo qual a pessoa é conhecida. Ex.: D. João VI, Pelé.',
  },
  {
    valor: 'religioso',
    rotulo: 'Religioso',
    ajuda: 'Adotado em ordem, ministério ou pontificado. Ex.: Papa Francisco.',
  },
  {
    valor: 'casada',
    rotulo: 'De casada',
    ajuda: 'Assumido na união.',
  },
  {
    valor: 'solteira',
    rotulo: 'De solteira',
    ajuda: 'O de antes da união.',
  },
  {
    valor: 'artistico',
    rotulo: 'Artístico',
    ajuda: 'Usado em palco, obra ou publicação.',
  },
  {
    valor: 'profissional',
    rotulo: 'Profissional',
    ajuda: 'Usado no exercício de um ofício ou cargo.',
  },
  {
    valor: 'imigracao',
    rotulo: 'De imigração',
    ajuda: 'Aportuguesado ou alterado na chegada. Ex.: Giovanni → João.',
  },
  { valor: 'outro', rotulo: 'Outro', ajuda: '' },
] as const;

export function rotuloDoTipoDeNome(tipo: string): string {
  return TIPOS_DE_NOME.find((t) => t.valor === tipo)?.rotulo ?? tipo;
}

/** Tipos de evento, com rótulo para a interface. */
export const TIPOS_DE_EVENTO = [
  { valor: 'nascimento', rotulo: 'Nascimento' },
  { valor: 'batismo', rotulo: 'Batismo' },
  { valor: 'casamento', rotulo: 'Casamento' },
  { valor: 'falecimento', rotulo: 'Falecimento' },
  { valor: 'sepultamento', rotulo: 'Sepultamento' },
] as const;

/** Rótulo de exibição de um tipo; tipos fora da lista aparecem como vieram. */
export function rotuloDoTipo(tipo: string): string {
  const conhecido = TIPOS_DE_EVENTO.find((t) => t.valor === tipo);
  if (conhecido) return conhecido.rotulo;
  return tipo.charAt(0).toLocaleUpperCase('pt-BR') + tipo.slice(1);
}
