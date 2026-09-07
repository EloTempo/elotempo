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

export type TipoCalendario = 'gregoriano' | 'judaico' | 'romano' | 'holoceno' | 'islamico';

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

  switch (cal) {
    case 'judaico':
      return converterParaJudaico(ano).formatado;
    case 'romano':
      return converterParaRomano(ano).formatado;
    case 'holoceno':
      return converterParaHoloceno(ano).formatado;
    case 'islamico':
      return converterParaIslamico(ano).formatado;
    case 'gregoriano':
    default:
      return ano < 0 ? `${Math.abs(ano)} a.C.` : `${ano}`;
  }
}

/**
 * Retorna uma descrição completa para exibição na agulha temporal ou balões de detalhe,
 * mostrando o ano no calendário selecionado e opcionalmente o correspondente gregoriano
 * como referência universal.
 */
export function descreverAnoComDetalhes(
  ano: number | null | undefined,
  cal: TipoCalendario = 'gregoriano',
  tipoTempo: TipoTempo = 'real',
): { principal: string; secundario?: string } {
  if (ano == null) return { principal: '' };

  if (tipoTempo === 'ficticio') {
    return {
      principal: ano < 0 ? `Ano ${Math.abs(ano)} a.F.` : `Ano ${ano}`,
      secundario: 'Cronologia Narrativa / Fictícia',
    };
  }

  const formatado = formatarAnoNoCalendario(ano, cal, 'real');

  if (cal === 'gregoriano') {
    const gregorianoExtenso = ano < 0 ? `${Math.abs(ano)} a.C.` : `${ano} d.C.`;
    return {
      principal: gregorianoExtenso,
    };
  }

  const refGregoriana = ano < 0 ? `${Math.abs(ano)} a.C.` : `${ano} d.C.`;
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

