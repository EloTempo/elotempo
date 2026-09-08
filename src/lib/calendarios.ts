/**
 * Módulo de Calendários e Cronologias do EloTempo.
 *
 * Suporta dois paradigmas temporais fundamentais:
 * 1. Tempo Real / Histórico: Calendários reais intercambiáveis sincronizados matematicamente
 *    a partir do ano gregoriano canônico (positivo = d.C., negativo = a.C.).
 *    - Gregoriano / Era Comum (d.C. / a.C.)
 *    - Judaico / Hebraico (Anno Mundi - AM)
 *    - Romano Clássico (Ab Urbe Condita - AUC)
 *    - Holoceno / Era Humana (Human Era - HE)
 *    - Islâmico (Hijri - AH / BH)
 *
 * 2. Tempo Fictício / Literário: Cronologias narrativas de obras (Tolkien, Westeros,
 *    Macondo, mitologia ou fantasia). Não são convertidas para calendários terrestres
 *    reais para evitar anacronismos e confusões históricas.
 */

import type { TipoTempo } from '../types';
import {
  anoContinuoParaData,
  NOMES_MESES_EXTENSO,
  NOMES_MESES_CURTOS,
} from './precisionTime';

export type TipoCalendario = 'gregoriano' | 'judaico' | 'romano' | 'holoceno' | 'islamico';

export type FormatoDataCalendario =
  | 'completo'
  | 'mesAno'
  | 'mesCurtoAno'
  | 'mesCurto'
  | 'diaMes'
  | 'anoApenas';

export interface DataEntradaCalendario {
  ano: number;
  mes?: number | null;
  dia?: number | null;
}

export interface InfoCalendario {
  id: TipoCalendario;
  nome: string;
  rotuloCurto: string;
  sufixoPositivo: string;
  sufixoNegativo: string;
  descricao: string;
  exemplo: string;
}

export const CALENDARIOS: Record<TipoCalendario, InfoCalendario> = {
  gregoriano: {
    id: 'gregoriano',
    nome: 'Gregoriano / Era Comum',
    rotuloCurto: 'Gregoriano (d.C.)',
    sufixoPositivo: 'd.C.',
    sufixoNegativo: 'a.C.',
    descricao: 'Calendário civil padrão mundial (Era Cristã / Era Comum).',
    exemplo: '2026 d.C. · 2822 a.C.',
  },
  judaico: {
    id: 'judaico',
    nome: 'Judaico (Anno Mundi)',
    rotuloCurto: 'Judaico (AM)',
    sufixoPositivo: 'AM',
    sufixoNegativo: 'a.M.',
    descricao: 'Conta os anos desde a Criação bíblica (3761 a.C.). Ideal para árvores hebraicas e bíblicas.',
    exemplo: '5786 AM · 939 AM',
  },
  romano: {
    id: 'romano',
    nome: 'Romano (Ab Urbe Condita)',
    rotuloCurto: 'Romano (AUC)',
    sufixoPositivo: 'AUC',
    sufixoNegativo: 'a.U.C.',
    descricao: 'Conta os anos desde a fundação de Roma por Rômulo e Remo (753 a.C.).',
    exemplo: '2779 AUC · 710 AUC',
  },
  holoceno: {
    id: 'holoceno',
    nome: 'Holoceno (Era Humana)',
    rotuloCurto: 'Holoceno (HE)',
    sufixoPositivo: 'HE',
    sufixoNegativo: 'a.H.E.',
    descricao: 'Adiciona 10.000 anos, sincronizando com a aurora da civilização humana e eliminando números negativos.',
    exemplo: '12026 HE · 7179 HE',
  },
  islamico: {
    id: 'islamico',
    nome: 'Islâmico (Hijri)',
    rotuloCurto: 'Islâmico (AH)',
    sufixoPositivo: 'AH',
    sufixoNegativo: 'BH',
    descricao: 'Calendário lunar iniciado com a Hégira de Maomé (622 d.C.).',
    exemplo: '1447 AH',
  },
};

export interface ResultadoConversaoAno {
  anoCalculado: number;
  sufixo: string;
  formatado: string;
  ehAproximado?: boolean;
}

/**
 * Converte um ano gregoriano canônico para o calendário Judaico (Anno Mundi - AM).
 * Época da criação estabelecida em 3761 a.C.
 */
export function converterParaJudaico(ano: number): ResultadoConversaoAno {
  if (ano > 0) {
    const am = ano + 3760;
    return {
      anoCalculado: am,
      sufixo: 'AM',
      formatado: `${am} AM`,
    };
  }

  // Anos a.C. (representados como negativos, ex: -2822 para 2822 a.C.)
  const anoAc = Math.abs(ano);
  if (anoAc <= 3760) {
    const am = 3761 - anoAc;
    return {
      anoCalculado: am,
      sufixo: 'AM',
      formatado: `${am} AM`,
    };
  }

  // Anteriores à criação bíblica
  const antesAm = anoAc - 3760;
  return {
    anoCalculado: antesAm,
    sufixo: 'a.M.',
    formatado: `${antesAm} a.M.`,
  };
}

/**
 * Converte um ano gregoriano canônico para o calendário Romano (Ab Urbe Condita - AUC).
 * Fundação de Roma estabelecida em 753 a.C.
 */
export function converterParaRomano(ano: number): ResultadoConversaoAno {
  if (ano > 0) {
    const auc = ano + 753;
    return {
      anoCalculado: auc,
      sufixo: 'AUC',
      formatado: `${auc} AUC`,
    };
  }

  const anoAc = Math.abs(ano);
  if (anoAc <= 753) {
    const auc = 753 - anoAc + 1;
    return {
      anoCalculado: auc,
      sufixo: 'AUC',
      formatado: `${auc} AUC`,
    };
  }

  const antesAuc = anoAc - 753;
  return {
    anoCalculado: antesAuc,
    sufixo: 'a.U.C.',
    formatado: `${antesAuc} a.U.C.`,
  };
}

/**
 * Converte um ano gregoriano canônico para o calendário Holoceno (Human Era - HE).
 * Adiciona exatamente 10.000 anos à era comum.
 */
export function converterParaHoloceno(ano: number): ResultadoConversaoAno {
  if (ano > 0) {
    const he = ano + 10000;
    return {
      anoCalculado: he,
      sufixo: 'HE',
      formatado: `${he} HE`,
    };
  }

  const anoAc = Math.abs(ano);
  if (anoAc <= 10000) {
    const he = 10001 - anoAc;
    return {
      anoCalculado: he,
      sufixo: 'HE',
      formatado: `${he} HE`,
    };
  }

  const antesHe = anoAc - 10000;
  return {
    anoCalculado: antesHe,
    sufixo: 'a.H.E.',
    formatado: `${antesHe} a.H.E.`,
  };
}

/**
 * Converte um ano gregoriano para o calendário Islâmico lunar (Hijri - AH / BH).
 * Hégira no ano 622 d.C.
 */
export function converterParaIslamico(ano: number): ResultadoConversaoAno {
  if (ano >= 622) {
    // Proporção lunar de 33/32 (aprox. 1.0306888)
    const ah = Math.round((ano - 622) * 1.0306888) + 1;
    return {
      anoCalculado: ah,
      sufixo: 'AH',
      formatado: `${ah} AH`,
      ehAproximado: true,
    };
  }

  // Antes da Hégira (BH - Before Hijra)
  const anosAntes = 622 - (ano > 0 ? ano : ano + 1);
  const bh = Math.max(1, Math.round(anosAntes * 1.0306888));
  return {
    anoCalculado: bh,
    sufixo: 'BH',
    formatado: `${bh} BH`,
    ehAproximado: true,
  };
}

/**
 * Formata um ano gregoriano canônico no calendário especificado,
 * respeitando a natureza do tempo (Real vs Fictício).
 */
export function formatarAnoNoCalendario(
  ano: number | null | undefined,
  cal: TipoCalendario = 'gregoriano',
  tipoTempo: TipoTempo = 'real',
): string {
  if (ano == null) return '';

  // Se o tempo for fictício / narrativo, nunca converte para calendários terrestres
  if (tipoTempo === 'ficticio') {
    return ano < 0 ? `Ano ${Math.abs(ano)} a.F.` : `Ano ${ano}`;
  }

  const anoInt = Math.floor(ano);

  switch (cal) {
    case 'judaico':
      return converterParaJudaico(anoInt).formatado;
    case 'romano':
      return converterParaRomano(anoInt).formatado;
    case 'holoceno':
      return converterParaHoloceno(anoInt).formatado;
    case 'islamico':
      return converterParaIslamico(anoInt).formatado;
    case 'gregoriano':
    default:
      return anoInt < 0 ? `${Math.abs(anoInt)} a.C.` : `${anoInt}`;
  }
}

/**
 * Formata uma data decomposta (ano, mês, dia) no calendário especificado,
 * respeitando os nomes de meses nativos de cada sistema (ex: Adar, Ramadan, etc.).
 */
export function formatarDataNoCalendario(
  data: DataEntradaCalendario,
  cal: TipoCalendario = 'gregoriano',
  tipoTempo: TipoTempo = 'real',
  formato: FormatoDataCalendario = 'completo',
): string {
  const { ano, mes, dia } = data;
  if (ano == null || isNaN(ano)) return '';

  const m = mes != null && mes >= 1 && mes <= 12 ? mes : 1;
  const d = dia != null && dia >= 1 ? dia : 1;

  if (tipoTempo === 'ficticio') {
    const anoStr = ano < 0 ? `Ano ${Math.abs(ano)} a.F.` : `Ano ${ano}`;
    switch (formato) {
      case 'anoApenas':
        return anoStr;
      case 'mesCurto':
        return NOMES_MESES_CURTOS[m - 1];
      case 'mesCurtoAno':
        return `${NOMES_MESES_CURTOS[m - 1]} ${anoStr}`;
      case 'diaMes':
        return `${d} ${NOMES_MESES_CURTOS[m - 1]}`;
      case 'mesAno':
        return `${NOMES_MESES_EXTENSO[m - 1]} de ${anoStr}`;
      case 'completo':
      default:
        return dia != null
          ? `${d} de ${NOMES_MESES_EXTENSO[m - 1]} do ${anoStr}`
          : `${NOMES_MESES_EXTENSO[m - 1]} do ${anoStr}`;
    }
  }

  // 1. Calendário Judaico (Anno Mundi)
  if (cal === 'judaico') {
    if (formato === 'anoApenas') {
      return converterParaJudaico(ano).formatado;
    }
    try {
      const dataJs = new Date(0);
      dataJs.setFullYear(ano, m - 1, d);
      const parts = new Intl.DateTimeFormat('pt-BR-u-ca-hebrew', {
        day: 'numeric',
        month: 'long',
        year: 'numeric',
      }).formatToParts(dataJs);

      const diaJudaico = parts.find((p) => p.type === 'day')?.value || String(d);
      const mesJudaico = parts.find((p) => p.type === 'month')?.value || 'Adar';
      const anoJudaico =
        parts.find((p) => p.type === 'year')?.value || String(converterParaJudaico(ano).anoCalculado);

      switch (formato) {
        case 'mesCurto':
          return mesJudaico;
        case 'mesCurtoAno':
          return `${mesJudaico} ${anoJudaico}`;
        case 'diaMes':
          return `${diaJudaico} ${mesJudaico}`;
        case 'mesAno':
          return `${mesJudaico} de ${anoJudaico} AM`;
        case 'completo':
        default:
          return dia != null
            ? `${diaJudaico} de ${mesJudaico} de ${anoJudaico} AM`
            : `${mesJudaico} de ${anoJudaico} AM`;
      }
    } catch {
      return converterParaJudaico(ano).formatado;
    }
  }

  // 2. Calendário Islâmico (Hijri)
  if (cal === 'islamico') {
    if (formato === 'anoApenas') {
      return converterParaIslamico(ano).formatado;
    }
    if (ano >= 622) {
      try {
        const dataJs = new Date(0);
        dataJs.setFullYear(ano, m - 1, d);
        const parts = new Intl.DateTimeFormat('pt-BR-u-ca-islamic-umalqura', {
          day: 'numeric',
          month: 'long',
          year: 'numeric',
        }).formatToParts(dataJs);

        const diaIslamico = parts.find((p) => p.type === 'day')?.value || String(d);
        const mesIslamico = parts.find((p) => p.type === 'month')?.value || 'Ramadan';
        const anoIslamico =
          parts.find((p) => p.type === 'year')?.value || String(converterParaIslamico(ano).anoCalculado);

        switch (formato) {
          case 'mesCurto':
            return mesIslamico;
          case 'mesCurtoAno':
            return `${mesIslamico} ${anoIslamico}`;
          case 'diaMes':
            return `${diaIslamico} ${mesIslamico}`;
          case 'mesAno':
            return `${mesIslamico} de ${anoIslamico} AH`;
          case 'completo':
          default:
            return dia != null
              ? `${diaIslamico} de ${mesIslamico} de ${anoIslamico} AH`
              : `${mesIslamico} de ${anoIslamico} AH`;
        }
      } catch {
        return converterParaIslamico(ano).formatado;
      }
    } else {
      return converterParaIslamico(ano).formatado;
    }
  }

  // 3. Calendário Romano (AUC - Ab Urbe Condita)
  if (cal === 'romano') {
    const rom = converterParaRomano(ano);
    switch (formato) {
      case 'anoApenas':
        return rom.formatado;
      case 'mesCurto':
        return NOMES_MESES_CURTOS[m - 1];
      case 'mesCurtoAno':
        return `${NOMES_MESES_CURTOS[m - 1]} ${rom.anoCalculado}`;
      case 'diaMes':
        return `${d} ${NOMES_MESES_CURTOS[m - 1]}`;
      case 'mesAno':
        return `${NOMES_MESES_EXTENSO[m - 1]} de ${rom.formatado}`;
      case 'completo':
      default:
        return dia != null
          ? `${d} de ${NOMES_MESES_EXTENSO[m - 1]} de ${rom.formatado}`
          : `${NOMES_MESES_EXTENSO[m - 1]} de ${rom.formatado}`;
    }
  }

  // 4. Calendário Holoceno (HE - Human Era)
  if (cal === 'holoceno') {
    const hol = converterParaHoloceno(ano);
    switch (formato) {
      case 'anoApenas':
        return hol.formatado;
      case 'mesCurto':
        return NOMES_MESES_CURTOS[m - 1];
      case 'mesCurtoAno':
        return `${NOMES_MESES_CURTOS[m - 1]} ${hol.anoCalculado}`;
      case 'diaMes':
        return `${d} ${NOMES_MESES_CURTOS[m - 1]}`;
      case 'mesAno':
        return `${NOMES_MESES_EXTENSO[m - 1]} de ${hol.formatado}`;
      case 'completo':
      default:
        return dia != null
          ? `${d} de ${NOMES_MESES_EXTENSO[m - 1]} de ${hol.formatado}`
          : `${NOMES_MESES_EXTENSO[m - 1]} de ${hol.formatado}`;
    }
  }

  // 5. Calendário Gregoriano Padrão
  const anoGregStr = ano < 0 ? `${Math.abs(ano)} a.C.` : `${ano}`;
  switch (formato) {
    case 'anoApenas':
      return ano < 0 ? `${Math.abs(ano)} a.C.` : `${ano} d.C.`;
    case 'mesCurto':
      return NOMES_MESES_CURTOS[m - 1];
    case 'mesCurtoAno':
      return `${NOMES_MESES_CURTOS[m - 1]} ${anoGregStr}`;
    case 'diaMes':
      return `${d} ${NOMES_MESES_CURTOS[m - 1]}`;
    case 'mesAno':
      return `${NOMES_MESES_EXTENSO[m - 1]} de ${anoGregStr}`;
    case 'completo':
    default:
      return dia != null
        ? `${d} de ${NOMES_MESES_EXTENSO[m - 1]} de ${anoGregStr}`
        : `${NOMES_MESES_EXTENSO[m - 1]} de ${anoGregStr}`;
  }
}

/**
 * Formata uma coordenada contínua de ano para exibição na agulha temporal ou régua,
 * adaptando o nível de granularidade (ano, mês ou dia) de acordo com o zoom visível (spanAnos).
 */
export function formatarDataPrecisaNoCalendario(
  anoContinuo: number | null | undefined,
  spanAnos: number,
  cal: TipoCalendario = 'gregoriano',
  tipoTempo: TipoTempo = 'real',
): string {
  if (anoContinuo == null || isNaN(anoContinuo)) return '';

  const dec = anoContinuoParaData(anoContinuo);

  // Zoom macro (mais de 2.5 anos visíveis): apenas o ano
  if (spanAnos > 2.5) {
    if (tipoTempo === 'ficticio') {
      return dec.ano < 0 ? `Ano ${Math.abs(dec.ano)} a.F.` : `Ano ${dec.ano}`;
    }
    return formatarAnoNoCalendario(dec.ano, cal, 'real');
  }

  // Zoom médio (meses: entre 0.35 e 2.5 anos visíveis)
  if (spanAnos > 0.35) {
    return formatarDataNoCalendario(dec, cal, tipoTempo, 'mesAno');
  }

  // Zoom micro (dias: <= 0.35 anos visíveis)
  return formatarDataNoCalendario(dec, cal, tipoTempo, 'completo');
}

/**
 * Retorna uma descrição completa para exibição na agulha temporal ou balões de detalhe,
 * mostrando o ano ou data no calendário selecionado e o correspondente gregoriano
 * como referência universal.
 */
export function descreverDataComDetalhes(
  anoContinuo: number | null | undefined,
  spanAnos: number,
  cal: TipoCalendario = 'gregoriano',
  tipoTempo: TipoTempo = 'real',
): { principal: string; secundario?: string } {
  if (anoContinuo == null || isNaN(anoContinuo)) return { principal: '' };

  const dec = anoContinuoParaData(anoContinuo);

  if (tipoTempo === 'ficticio') {
    return {
      principal: formatarDataPrecisaNoCalendario(anoContinuo, spanAnos, cal, 'ficticio'),
      secundario: 'Cronologia Narrativa / Fictícia',
    };
  }

  if (cal === 'gregoriano') {
    const principal =
      spanAnos > 2.5
        ? dec.ano < 0
          ? `${Math.abs(dec.ano)} a.C.`
          : `${dec.ano} d.C.`
        : formatarDataPrecisaNoCalendario(anoContinuo, spanAnos, 'gregoriano', 'real');
    return { principal };
  }

  const principal = formatarDataPrecisaNoCalendario(anoContinuo, spanAnos, cal, 'real');
  const refGregoriana =
    spanAnos > 2.5
      ? dec.ano < 0
        ? `${Math.abs(dec.ano)} a.C.`
        : `${dec.ano} d.C.`
      : formatarDataPrecisaNoCalendario(anoContinuo, spanAnos, 'gregoriano', 'real');

  return {
    principal,
    secundario: `equiv. ${refGregoriana}`,
  };
}

/**
 * Retorna uma descrição de ano para exibição estática sem necessidade de fração contínua.
 */
export function descreverAnoComDetalhes(
  ano: number | null | undefined,
  cal: TipoCalendario = 'gregoriano',
  tipoTempo: TipoTempo = 'real',
): { principal: string; secundario?: string } {
  if (ano == null || isNaN(ano)) return { principal: '' };
  const anoInt = Math.floor(ano);

  if (tipoTempo === 'ficticio') {
    return {
      principal: anoInt < 0 ? `Ano ${Math.abs(anoInt)} a.F.` : `Ano ${anoInt}`,
      secundario: 'Cronologia Narrativa / Fictícia',
    };
  }

  const formatado = formatarAnoNoCalendario(anoInt, cal, 'real');

  if (cal === 'gregoriano') {
    const gregorianoExtenso = anoInt < 0 ? `${Math.abs(anoInt)} a.C.` : `${anoInt} d.C.`;
    return {
      principal: gregorianoExtenso,
    };
  }

  const refGregoriana = anoInt < 0 ? `${Math.abs(anoInt)} a.C.` : `${anoInt} d.C.`;
  return {
    principal: formatado,
    secundario: `equiv. ${refGregoriana}`,
  };
}

/**
 * Converte um ano numérico expresso no calendário especificado de volta para
 * o ano canônico interno (gregoriano astronômico onde positivo = d.C. e negativo = a.C.).
 */
export function converterAnoDoCalendarioParaGregoriano(
  anoNoCal: number,
  cal: TipoCalendario = 'gregoriano',
  tipoTempo: TipoTempo = 'real',
): number {
  if (tipoTempo === 'ficticio' || isNaN(anoNoCal)) {
    return anoNoCal;
  }

  switch (cal) {
    case 'judaico': {
      // No calendário Judaico (Anno Mundi - AM):
      // 1 AM = 3760 a.C. (-3760)
      // 3760 AM = 1 a.C. (-1)
      // 3761 AM = 1 d.C. (+1)
      // 5786 AM = 2026 d.C. (+2026)
      // 0 AM = 3761 a.C. (-3761, época bíblica da Criação tradicional)
      if (anoNoCal >= 3761) {
        return anoNoCal - 3760;
      }
      return anoNoCal - 3761;
    }
    case 'romano': {
      // No calendário Romano (Ab Urbe Condita - AUC):
      // 1 AUC = 753 a.C. (-753)
      // 753 AUC = 1 a.C. (-1)
      // 754 AUC = 1 d.C. (+1)
      // 2779 AUC = 2026 d.C. (+2026)
      if (anoNoCal >= 754) {
        return anoNoCal - 753;
      }
      return anoNoCal - 754;
    }
    case 'holoceno': {
      // No calendário Holoceno (Human Era - HE):
      // 1 HE = 10000 a.C. (-10000)
      // 10000 HE = 1 a.C. (-1)
      // 10001 HE = 1 d.C. (+1)
      // 12026 HE = 2026 d.C. (+2026)
      if (anoNoCal >= 10001) {
        return anoNoCal - 10000;
      }
      return anoNoCal - 10001;
    }
    case 'islamico': {
      // No calendário Islâmico (Hijri - AH):
      // 1 AH = 622 d.C.
      // 1447 AH ≈ 2026 d.C.
      if (anoNoCal >= 1) {
        return Math.round((anoNoCal - 1) / 1.0306888) + 622;
      }
      const anosAntes = Math.round((Math.abs(anoNoCal) + 1) / 1.0306888);
      const res = 622 - anosAntes;
      return res <= 0 ? res - 1 : res;
    }
    case 'gregoriano':
    default:
      return anoNoCal;
  }
}

/**
 * Obtém o valor numérico puro do ano no calendário especificado,
 * ideal para inputs de número, cálculos de avanço/recuo de 1 ano e sincronização.
 */
export function obterNumeroAnoNoCalendario(
  anoGregoriano: number,
  cal: TipoCalendario = 'gregoriano',
  tipoTempo: TipoTempo = 'real',
): number {
  if (tipoTempo === 'ficticio' || isNaN(anoGregoriano)) {
    return anoGregoriano;
  }

  switch (cal) {
    case 'judaico':
      return anoGregoriano > 0 ? anoGregoriano + 3760 : anoGregoriano + 3761;
    case 'romano':
      return anoGregoriano > 0 ? anoGregoriano + 753 : anoGregoriano + 754;
    case 'holoceno':
      return anoGregoriano > 0 ? anoGregoriano + 10000 : anoGregoriano + 10001;
    case 'islamico': {
      if (anoGregoriano >= 622) {
        return Math.round((anoGregoriano - 622) * 1.0306888) + 1;
      }
      const anosAntes = 622 - (anoGregoriano > 0 ? anoGregoriano : anoGregoriano + 1);
      return -Math.max(1, Math.round(anosAntes * 1.0306888));
    }
    case 'gregoriano':
    default:
      return anoGregoriano;
  }
}

/**
 * Retorna o sufixo curto correspondente ao ano no calendário (ex: 'AM', 'AUC', 'HE', 'd.C.', 'a.C.').
 */
export function obterSufixoAnoNoCalendario(
  anoGregoriano: number,
  cal: TipoCalendario = 'gregoriano',
  tipoTempo: TipoTempo = 'real',
): string {
  if (tipoTempo === 'ficticio') {
    return anoGregoriano < 0 ? 'a.F.' : '';
  }

  switch (cal) {
    case 'judaico': {
      const num = obterNumeroAnoNoCalendario(anoGregoriano, 'judaico');
      return num >= 1 ? 'AM' : 'a.M.';
    }
    case 'romano': {
      const num = obterNumeroAnoNoCalendario(anoGregoriano, 'romano');
      return num >= 1 ? 'AUC' : 'a.U.C.';
    }
    case 'holoceno': {
      const num = obterNumeroAnoNoCalendario(anoGregoriano, 'holoceno');
      return num >= 1 ? 'HE' : 'a.H.E.';
    }
    case 'islamico': {
      return anoGregoriano >= 622 ? 'AH' : 'BH';
    }
    case 'gregoriano':
    default:
      return anoGregoriano < 0 ? 'a.C.' : 'd.C.';
  }
}

