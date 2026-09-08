/**
 * Módulo de Alta Precisão Temporal do EloTempo.
 *
 * Suporta cálculo de tempo contínuo com resolução diária, mensal e anual,
 * considerando rigorosamente as regras de anos bissextos dos calendários
 * Gregoriano (desde 15/10/1582) e Juliano (histórico pré-1582).
 *
 * Permite que a Linha do Tempo e a Faixa da Vida posicionem com perfeição
 * eventos ocorridos no mesmo ano (ex: 09/01/1822 vs 07/09/1822 vs 01/12/1822)
 * e suporta zoom sub-anual profundo (meses e dias).
 */

export interface DataDecomposta {
  ano: number;
  mes: number;
  dia: number;
  ehBissexto: boolean;
}

export const NOMES_MESES_EXTENSO = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
] as const;

export const NOMES_MESES_CURTOS = [
  'Jan',
  'Fev',
  'Mar',
  'Abr',
  'Mai',
  'Jun',
  'Jul',
  'Ago',
  'Set',
  'Out',
  'Nov',
  'Dez',
] as const;

/**
 * Determina se um ano é bissexto.
 *
 * - Para anos >= 1582 (Calendário Gregoriano):
 *   Divisível por 4, EXCETO centenários que NÃO são divisíveis por 400.
 *   Ex: 1900 foi comum, 2000 foi bissexto, 2024 foi bissexto.
 * - Para anos < 1582 (Calendário Juliano):
 *   Todo ano divisível por 4 é bissexto.
 */
export function ehAnoBissexto(ano: number): boolean {
  if (ano >= 1582) {
    return (ano % 4 === 0 && ano % 100 !== 0) || ano % 400 === 0;
  }
  // No Juliano, todo ano múltiplo de 4 era bissexto (para d.C. e a.C.)
  return Math.abs(ano) % 4 === 0;
}

/**
 * Retorna o número total de dias de um determinado ano (366 em bissexto, 365 em comum).
 */
export function obterDiasNoAno(ano: number): number {
  return ehAnoBissexto(ano) ? 366 : 365;
}

/**
 * Retorna o número de dias de um determinado mês (1 a 12),
 * respeitando o ano bissexto para o mês de Fevereiro.
 */
export function obterDiasNoMes(mes: number, ano: number): number {
  switch (mes) {
    case 1:
      return 31;
    case 2:
      return ehAnoBissexto(ano) ? 29 : 28;
    case 3:
      return 31;
    case 4:
      return 30;
    case 5:
      return 31;
    case 6:
      return 30;
    case 7:
      return 31;
    case 8:
      return 31;
    case 9:
      return 30;
    case 10:
      return 31;
    case 11:
      return 30;
    case 12:
      return 31;
    default:
      return 30;
  }
}

/**
 * Converte uma data (ano, mes, dia) em uma coordenada decimal contínua no eixo do tempo.
 *
 * 1º de Janeiro = ano + 0.0
 * 31 de Dezembro = ano + (totalDias - 1) / totalDias
 *
 * Preserva monotonicidade estrita mesmo em anos a.C.
 */
export function dataParaAnoContinuo(
  ano: number,
  mes?: number | null,
  dia?: number | null,
): number {
  const m = mes != null && mes >= 1 && mes <= 12 ? mes : 1;
  const diasMes = obterDiasNoMes(m, ano);
  const d = dia != null && dia >= 1 ? Math.min(dia, diasMes) : 1;

  let diasAcumulados = 0;
  for (let i = 1; i < m; i++) {
    diasAcumulados += obterDiasNoMes(i, ano);
  }
  diasAcumulados += d - 1;

  const totalDias = obterDiasNoAno(ano);
  const fracao = diasAcumulados / totalDias;

  return ano + fracao;
}

/**
 * Operação inversa exata: transforma uma coordenada decimal de ano contínuo
 * de volta em seus componentes { ano, mes, dia, ehBissexto }.
 */
export function anoContinuoParaData(anoContinuo: number): DataDecomposta {
  const ano = Math.floor(anoContinuo);
  let fracao = anoContinuo - ano;
  if (fracao < 0) fracao = 0;
  if (fracao >= 0.999999) fracao = 0.999999;

  const totalDias = obterDiasNoAno(ano);
  let diaDoAno = Math.min(totalDias, Math.max(1, Math.round(fracao * totalDias) + 1));

  let mes = 1;
  while (mes <= 12) {
    const diasMes = obterDiasNoMes(mes, ano);
    if (diaDoAno <= diasMes) {
      break;
    }
    diaDoAno -= diasMes;
    mes++;
  }

  if (mes > 12) {
    mes = 12;
    diaDoAno = obterDiasNoMes(12, ano);
  }

  return {
    ano,
    mes,
    dia: diaDoAno,
    ehBissexto: ehAnoBissexto(ano),
  };
}

const MAPA_MESES_TEXTO: Record<string, number> = {
  jan: 1,
  janeiro: 1,
  fev: 2,
  fevereiro: 2,
  mar: 3,
  marco: 3,
  março: 3,
  abr: 4,
  abril: 4,
  mai: 5,
  maio: 5,
  jun: 6,
  junho: 6,
  jul: 7,
  julho: 7,
  ago: 8,
  agosto: 8,
  set: 9,
  setembro: 9,
  out: 10,
  outubro: 10,
  nov: 11,
  novembro: 11,
  dez: 12,
  dezembro: 12,
};

/**
 * Interpreta qualquer texto ou campos estruturados de data e calcula o valor
 * contínuo fracionário de alta precisão.
 */
export function interpretarDataParaAnoContinuo(
  ano?: number | null,
  dataTexto?: string | null,
  mes?: number | null,
  dia?: number | null,
): number | null {
  // 1. Se mês e dia estruturados foram fornecidos e ano existe
  if (ano != null && mes != null && mes >= 1 && mes <= 12) {
    return dataParaAnoContinuo(ano, mes, dia);
  }

  if (ano == null && !dataTexto) return null;
  if (!dataTexto) return ano ?? null;

  const limpo = dataTexto.trim().toLowerCase();

  // 2. Formato brasileiro DD/MM/AAAA ou D/M/AAAA
  const matchBr = limpo.match(/^(\d{1,2})\/(\d{1,2})\/(-?\d{1,5})/);
  if (matchBr) {
    const d = parseInt(matchBr[1], 10);
    const m = parseInt(matchBr[2], 10);
    const a = parseInt(matchBr[3], 10);
    return dataParaAnoContinuo(a, m, d);
  }

  // 3. Formato ISO AAAA-MM-DD
  const matchIso = limpo.match(/^(-?\d{1,5})-(\d{1,2})-(\d{1,2})/);
  if (matchIso) {
    const a = parseInt(matchIso[1], 10);
    const m = parseInt(matchIso[2], 10);
    const d = parseInt(matchIso[3], 10);
    return dataParaAnoContinuo(a, m, d);
  }

  // 4. Formato por extenso: "7 de setembro de 1822" ou "29 de fev de 2024"
  const matchExtenso = limpo.match(/(\d{1,2})\s+de\s+([a-zá-ú]+)\s+de\s+(-?\d{1,5})/);
  if (matchExtenso) {
    const d = parseInt(matchExtenso[1], 10);
    const nomeMes = matchExtenso[2];
    const a = parseInt(matchExtenso[3], 10);
    const m = MAPA_MESES_TEXTO[nomeMes];
    if (m) {
      return dataParaAnoContinuo(a, m, d);
    }
  }

  // 5. Formato "Mês de AAAA", ex: "setembro de 1822"
  const matchMesAno = limpo.match(/([a-zá-ú]+)\s+de\s+(-?\d{1,5})/);
  if (matchMesAno) {
    const nomeMes = matchMesAno[1];
    const a = parseInt(matchMesAno[2], 10);
    const m = MAPA_MESES_TEXTO[nomeMes];
    if (m) {
      return dataParaAnoContinuo(a, m, 1);
    }
  }

  // 6. Se o texto contiver ano a.C., ex: "44 a.C."
  const matchAc = limpo.match(/(\d+)\s*(?:a\.?\s*c\.?)/);
  if (matchAc) {
    const a = -parseInt(matchAc[1], 10);
    return dataParaAnoContinuo(a, 1, 1);
  }

  // Fallback para ano base
  return ano ?? null;
}

/**
 * Formata um ano contínuo para exibição elegante no cabeçote da agulha (playhead)
 * ou cursor de hover, de acordo com o zoom visível (span).
 */
export function formatarDataPrecisa(
  anoContinuo: number | null | undefined,
  spanAnos: number,
): string {
  if (anoContinuo == null) return '';

  const dec = anoContinuoParaData(anoContinuo);
  const anoStr = dec.ano < 0 ? `${Math.abs(dec.ano)} a.C.` : `${dec.ano}`;

  // Se zoom estiver macro (mais de 2.5 anos visíveis)
  if (spanAnos > 2.5) {
    return anoStr;
  }

  // Se zoom estiver em escala de meses (entre 0.3 e 2.5 anos visíveis)
  if (spanAnos > 0.3) {
    return `${NOMES_MESES_EXTENSO[dec.mes - 1]} de ${anoStr}`;
  }

  // Se zoom estiver em escala de dias (0.3 anos ou menos, i.e. <= ~110 dias)
  const diaPad = String(dec.dia).padStart(2, '0');
  const mesPad = String(dec.mes).padStart(2, '0');
  return `${diaPad}/${mesPad}/${anoStr}`;
}
