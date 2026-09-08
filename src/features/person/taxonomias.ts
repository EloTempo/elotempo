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
 * Motivos pelos quais alguém passou a usar outro nome (fatia 02).
 *
 * A primeira versão desta lista tinha nove tipos e expunha o modelo de dados
 * em vez do modelo mental de quem usa. Ninguém pensa "vou cadastrar um nome do
 * tipo público"; pensa "ela virou freira e mudou de nome", "ele virou papa",
 * "esse é o nome de palco". Por isso cada opção traz um exemplo real: o
 * exemplo ensina mais rápido do que a definição.
 *
 * `nascimento` fica de fora: não é uma *mudança*, é o nome completo de
 * registro, e tem campo próprio na interface.
 */
export const MOTIVOS_DE_NOME = [
  {
    valor: 'religioso',
    rotulo: 'Nome religioso',
    exemplo: 'Jorge Mario Bergoglio passou a ser Francisco ao virar papa; Edith Stein virou Teresa Benedita da Cruz no Carmelo.',
  },
  {
    valor: 'artistico',
    rotulo: 'Nome artístico ou de palco',
    exemplo: 'Maria da Graça Meneghel é conhecida como Xuxa.',
  },
  {
    valor: 'publico',
    rotulo: 'Título ou nome de tratamento',
    exemplo: 'Um príncipe que vira rei passa a ser tratado por outro nome — D. João VI.',
  },
  {
    valor: 'casada',
    rotulo: 'Passou a usar o sobrenome do cônjuge',
    exemplo: 'Maria Aparecida Souza virou Maria Aparecida Souza Lima ao casar.',
  },
  {
    valor: 'solteira',
    rotulo: 'Voltou ao nome de solteira',
    exemplo: 'Retomado após viuvez ou separação.',
  },
  {
    valor: 'imigracao',
    rotulo: 'Nome aportuguesado na imigração',
    exemplo: 'Giovanni Battista Rossi passou a assinar João Batista Rosa.',
  },
  {
    valor: 'profissional',
    rotulo: 'Nome de ofício',
    exemplo: 'Usado no exercício de um cargo ou profissão.',
  },
  { valor: 'outro', rotulo: 'Outro motivo', exemplo: '' },
] as const;

/** Todos os tipos que a tabela aceita, incluindo o de nascimento. */
export const TIPOS_DE_NOME = [
  { valor: 'nascimento', rotulo: 'Nome completo de registro' },
  ...MOTIVOS_DE_NOME.map((m) => ({ valor: m.valor, rotulo: m.rotulo })),
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

/** Formata o código de país em gentílico em português com bandeira. */
export function obterRotuloNacionalidade(
  paisId?: string | null,
  sexo?: string
): { flag: string; texto: string } | null {
  if (!paisId) return null;
  const map: Record<string, { flag: string; m: string; f: string }> = {
    br: { flag: '🇧🇷', m: 'Brasileiro', f: 'Brasileira' },
    pt: { flag: '🇵🇹', m: 'Português', f: 'Portuguesa' },
    it: { flag: '🇮🇹', m: 'Italiano', f: 'Italiana' },
    es: { flag: '🇪🇸', m: 'Espanhol', f: 'Espanhola' },
    de: { flag: '🇩🇪', m: 'Alemão', f: 'Alemã' },
    jp: { flag: '🇯🇵', m: 'Japonês', f: 'Japonesa' },
    fr: { flag: '🇫🇷', m: 'Francês', f: 'Francesa' },
    gb: { flag: '🇬🇧', m: 'Britânico', f: 'Britânica' },
    us: { flag: '🇺🇸', m: 'Norte-Americano', f: 'Norte-Americana' },
    ar: { flag: '🇦🇷', m: 'Argentino', f: 'Argentina' },
    uy: { flag: '🇺🇾', m: 'Uruguaio', f: 'Uruguaia' },
    py: { flag: '🇵🇾', m: 'Paraguaio', f: 'Paraguaia' },
    pl: { flag: '🇵🇱', m: 'Polonês', f: 'Polonesa' },
    ru: { flag: '🇷🇺', m: 'Russo', f: 'Russa' },
    ua: { flag: '🇺🇦', m: 'Ucraniano', f: 'Ucraniana' },
    lb: { flag: '🇱🇧', m: 'Libanês', f: 'Libanesa' },
    sy: { flag: '🇸🇾', m: 'Sírio', f: 'Síria' },
    ch: { flag: '🇨🇭', m: 'Suíço', f: 'Suíça' },
    at: { flag: '🇦🇹', m: 'Austríaco', f: 'Austríaca' },
    nl: { flag: '🇳🇱', m: 'Holandês', f: 'Holandesa' },
  };

  const item = map[paisId.toLowerCase()];
  if (item) {
    return { flag: item.flag, texto: sexo === 'F' ? item.f : item.m };
  }

  const flag =
    paisId.length === 2
      ? paisId
          .toUpperCase()
          .replace(/./g, (c) => String.fromCodePoint(127397 + c.charCodeAt(0)))
      : '🌐';

  return { flag, texto: paisId.toUpperCase() };
}

