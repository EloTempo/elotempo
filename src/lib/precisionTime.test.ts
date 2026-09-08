import { describe, expect, it } from 'vitest';
import {
  anoContinuoParaData,
  dataParaAnoContinuo,
  ehAnoBissexto,
  formatarDataPrecisa,
  interpretarDataParaAnoContinuo,
  obterDiasNoAno,
  obterDiasNoMes,
} from './precisionTime';

describe('precisionTime - Regras de Anos Bissextos', () => {
  it('identifica corretamente anos bissextos e comuns gregorianos (>= 1582)', () => {
    // 2024 é bissexto (divisível por 4)
    expect(ehAnoBissexto(2024)).toBe(true);
    expect(obterDiasNoAno(2024)).toBe(366);
    expect(obterDiasNoMes(2, 2024)).toBe(29);

    // 2023 é comum
    expect(ehAnoBissexto(2023)).toBe(false);
    expect(obterDiasNoAno(2023)).toBe(365);
    expect(obterDiasNoMes(2, 2023)).toBe(28);

    // 2000 é bissexto (centenário divisível por 400)
    expect(ehAnoBissexto(2000)).toBe(true);
    expect(obterDiasNoAno(2000)).toBe(366);

    // 1900 é comum (centenário não divisível por 400)
    expect(ehAnoBissexto(1900)).toBe(false);
    expect(obterDiasNoAno(1900)).toBe(365);
    expect(obterDiasNoMes(2, 1900)).toBe(28);

    // 1820 foi bissexto
    expect(ehAnoBissexto(1820)).toBe(true);
    // 1822 foi comum
    expect(ehAnoBissexto(1822)).toBe(false);
  });

  it('identifica corretamente anos bissextos no calendário Juliano pré-1582', () => {
    // No calendário Juliano, 1500 era divisível por 4 -> bissexto
    expect(ehAnoBissexto(1500)).toBe(true);
    expect(obterDiasNoAno(1500)).toBe(366);

    // 44 a.C. (assassinato de Júlio César) -> divisível por 4 -> bissexto
    expect(ehAnoBissexto(-44)).toBe(true);
  });

  it('valida os dias de todos os meses do ano', () => {
    expect(obterDiasNoMes(1, 2024)).toBe(31); // Jan
    expect(obterDiasNoMes(3, 2024)).toBe(31); // Mar
    expect(obterDiasNoMes(4, 2024)).toBe(30); // Abr
    expect(obterDiasNoMes(5, 2024)).toBe(31); // Mai
    expect(obterDiasNoMes(6, 2024)).toBe(30); // Jun
    expect(obterDiasNoMes(7, 2024)).toBe(31); // Jul
    expect(obterDiasNoMes(8, 2024)).toBe(31); // Ago
    expect(obterDiasNoMes(9, 2024)).toBe(30); // Set
    expect(obterDiasNoMes(10, 2024)).toBe(31); // Out
    expect(obterDiasNoMes(11, 2024)).toBe(30); // Nov
    expect(obterDiasNoMes(12, 2024)).toBe(31); // Dez
  });
});

describe('precisionTime - Conversão Contínua e Reversão (Bijetividade)', () => {
  it('converte e recupera exatamente o dia 29 de fevereiro de ano bissexto', () => {
    const anoContinuo = dataParaAnoContinuo(2024, 2, 29);
    // 31 dias em janeiro + 28 dias = dia 59 (índice 0-based). 59 / 366 ~= 0.1612
    expect(anoContinuo).toBeCloseTo(2024 + 59 / 366, 6);

    const recuperada = anoContinuoParaData(anoContinuo);
    expect(recuperada.ano).toBe(2024);
    expect(recuperada.mes).toBe(2);
    expect(recuperada.dia).toBe(29);
    expect(recuperada.ehBissexto).toBe(true);
  });

  it('converte e recupera o 1º de Janeiro e 31 de Dezembro', () => {
    // 1º de Janeiro
    const inicio = dataParaAnoContinuo(2024, 1, 1);
    expect(inicio).toBe(2024.0);
    const recInicio = anoContinuoParaData(inicio);
    expect(recInicio.ano).toBe(2024);
    expect(recInicio.mes).toBe(1);
    expect(recInicio.dia).toBe(1);

    // 31 de Dezembro
    const fim = dataParaAnoContinuo(2024, 12, 31);
    const recFim = anoContinuoParaData(fim);
    expect(recFim.ano).toBe(2024);
    expect(recFim.mes).toBe(12);
    expect(recFim.dia).toBe(31);
  });

  it('diferencia o 28/02 de ano comum de ano bissexto', () => {
    const fev28Comum = dataParaAnoContinuo(2023, 2, 28);
    const recComum = anoContinuoParaData(fev28Comum);
    expect(recComum.ano).toBe(2023);
    expect(recComum.mes).toBe(2);
    expect(recComum.dia).toBe(28);

    const mar01Comum = dataParaAnoContinuo(2023, 3, 1);
    const recMar = anoContinuoParaData(mar01Comum);
    expect(recMar.ano).toBe(2023);
    expect(recMar.mes).toBe(3);
    expect(recMar.dia).toBe(1);
  });
});

describe('precisionTime - Interpretação Textual de Datas', () => {
  it('ordena com precisão os acontecimentos históricos de 1822', () => {
    // Dia do Fico: 09/01/1822
    const fico = interpretarDataParaAnoContinuo(1822, '09/01/1822');
    // Grito do Ipiranga: 07/09/1822
    const ipiranga = interpretarDataParaAnoContinuo(1822, '07/09/1822');
    // Coroação de D. Pedro I: 01/12/1822
    const coroacao = interpretarDataParaAnoContinuo(1822, '01/12/1822');

    expect(fico).not.toBeNull();
    expect(ipiranga).not.toBeNull();
    expect(coroacao).not.toBeNull();

    expect(fico!).toBeLessThan(ipiranga!);
    expect(ipiranga!).toBeLessThan(coroacao!);

    // Reversão de Ipiranga
    const decIpiranga = anoContinuoParaData(ipiranga!);
    expect(decIpiranga.ano).toBe(1822);
    expect(decIpiranga.mes).toBe(9);
    expect(decIpiranga.dia).toBe(7);
  });

  it('interpreta formatos variados: ISO, texto por extenso e nomes de meses', () => {
    const iso = interpretarDataParaAnoContinuo(null, '1822-09-07');
    const br = interpretarDataParaAnoContinuo(null, '07/09/1822');
    const extenso = interpretarDataParaAnoContinuo(null, '7 de setembro de 1822');

    expect(iso).toBe(br);
    expect(extenso).toBe(br);

    const mesAno = interpretarDataParaAnoContinuo(null, 'setembro de 1822');
    expect(mesAno).toBe(dataParaAnoContinuo(1822, 9, 1));
  });

  it('interpreta datas com dia e mês estruturados', () => {
    const estruturado = interpretarDataParaAnoContinuo(1822, null, 9, 7);
    const textual = interpretarDataParaAnoContinuo(1822, '07/09/1822');
    expect(estruturado).toBe(textual);
  });
});

describe('precisionTime - Formatação Adaptativa ao Zoom', () => {
  it('exibe apenas o ano em zoom afastado (span > 2.5)', () => {
    const t = dataParaAnoContinuo(1822, 9, 7);
    expect(formatarDataPrecisa(t, 50)).toBe('1822');
  });

  it('exibe mês e ano em zoom médio (0.3 < span <= 2.5)', () => {
    const t = dataParaAnoContinuo(1822, 9, 7);
    expect(formatarDataPrecisa(t, 1.2)).toBe('Setembro de 1822');
  });

  it('exibe dia, mês e ano em zoom de alta proximidade (span <= 0.3)', () => {
    const t = dataParaAnoContinuo(1822, 9, 7);
    expect(formatarDataPrecisa(t, 0.1)).toBe('07/09/1822');
  });
});
