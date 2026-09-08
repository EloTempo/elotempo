import { describe, expect, it } from 'vitest';
import {
  CALENDARIOS,
  converterParaHoloceno,
  converterParaIslamico,
  converterParaJudaico,
  converterParaRomano,
  descreverAnoComDetalhes,
  formatarAnoNoCalendario,
  converterAnoDoCalendarioParaGregoriano,
  obterNumeroAnoNoCalendario,
  obterSufixoAnoNoCalendario,
  formatarDataNoCalendario,
  formatarDataPrecisaNoCalendario,
  descreverDataComDetalhes,
} from './calendarios';

describe('Módulo de Calendários e Cronologias', () => {
  it('metadados dos calendários estão devidamente configurados', () => {
    expect(CALENDARIOS.gregoriano.id).toBe('gregoriano');
    expect(CALENDARIOS.judaico.rotuloCurto).toContain('AM');
    expect(CALENDARIOS.romano.rotuloCurto).toContain('AUC');
    expect(CALENDARIOS.holoceno.rotuloCurto).toContain('HE');
    expect(CALENDARIOS.islamico.rotuloCurto).toContain('AH');
  });

  describe('Calendário Gregoriano / Era Comum', () => {
    it('formata anos d.C. e a.C. corretamente', () => {
      expect(formatarAnoNoCalendario(2026, 'gregoriano')).toBe('2026');
      expect(formatarAnoNoCalendario(1, 'gregoriano')).toBe('1');
      expect(formatarAnoNoCalendario(-44, 'gregoriano')).toBe('44 a.C.');
      expect(formatarAnoNoCalendario(-2822, 'gregoriano')).toBe('2822 a.C.');
      expect(formatarAnoNoCalendario(null, 'gregoriano')).toBe('');
    });
  });

  describe('Calendário Judaico (Anno Mundi - AM)', () => {
    it('converte ano atual e anos d.C. com precisão', () => {
      // 2026 + 3760 = 5786 AM
      const res2026 = converterParaJudaico(2026);
      expect(res2026.anoCalculado).toBe(5786);
      expect(res2026.sufixo).toBe('AM');
      expect(res2026.formatado).toBe('5786 AM');

      // 1 d.C. + 3760 = 3761 AM
      const res1 = converterParaJudaico(1);
      expect(res1.anoCalculado).toBe(3761);
      expect(res1.formatado).toBe('3761 AM');
    });

    it('converte anos a.C. bíblicos (Adão, Noé)', () => {
      // Criação bíblica aproximada: 3760 a.C. = 1 AM
      expect(converterParaJudaico(-3760).anoCalculado).toBe(1);
      expect(converterParaJudaico(-3760).formatado).toBe('1 AM');

      // 2822 a.C. (época patriarcas bíblicos): 3761 - 2822 = 939 AM
      const resBiblico = converterParaJudaico(-2822);
      expect(resBiblico.anoCalculado).toBe(939);
      expect(resBiblico.formatado).toBe('939 AM');
    });
  });

  describe('Calendário Romano Clássico (AUC)', () => {
    it('converte a partir da fundação de Roma (753 a.C.)', () => {
      // Ano da fundação de Roma: 753 a.C. = 1 AUC
      expect(converterParaRomano(-753).anoCalculado).toBe(1);
      expect(converterParaRomano(-753).formatado).toBe('1 AUC');

      // 44 a.C. (morte de Júlio César): 753 - 44 + 1 = 710 AUC
      expect(converterParaRomano(-44).anoCalculado).toBe(710);
      expect(converterParaRomano(-44).formatado).toBe('710 AUC');

      // 1 d.C.: 1 + 753 = 754 AUC
      expect(converterParaRomano(1).anoCalculado).toBe(754);
      expect(converterParaRomano(1).formatado).toBe('754 AUC');

      // 2026 d.C.: 2026 + 753 = 2779 AUC
      expect(converterParaRomano(2026).anoCalculado).toBe(2779);
      expect(converterParaRomano(2026).formatado).toBe('2779 AUC');
    });
  });

  describe('Calendário Holoceno (Human Era - HE)', () => {
    it('adiciona 10.000 anos eliminando anos negativos para a civilização', () => {
      // 2026 d.C. = 12026 HE
      expect(converterParaHoloceno(2026).anoCalculado).toBe(12026);
      expect(converterParaHoloceno(2026).formatado).toBe('12026 HE');

      // 1 d.C. = 10001 HE
      expect(converterParaHoloceno(1).anoCalculado).toBe(10001);
      expect(converterParaHoloceno(1).formatado).toBe('10001 HE');

      // 1 a.C. = 10000 HE
      expect(converterParaHoloceno(-1).anoCalculado).toBe(10000);
      expect(converterParaHoloceno(-1).formatado).toBe('10000 HE');

      // 2822 a.C. = 7179 HE
      expect(converterParaHoloceno(-2822).anoCalculado).toBe(7179);
      expect(converterParaHoloceno(-2822).formatado).toBe('7179 HE');
    });
  });

  describe('Calendário Islâmico (Hijri - AH)', () => {
    it('calcula a partir da Hégira (622 d.C.) com razão lunar', () => {
      // Ano da Hégira: 622 d.C. = 1 AH
      expect(converterParaIslamico(622).anoCalculado).toBe(1);
      expect(converterParaIslamico(622).formatado).toBe('1 AH');

      // 2026 d.C. = 1447/1448 AH (ano lunar que cruza meados do ano gregoriano)
      const ah2026 = converterParaIslamico(2026);
      expect([1447, 1448]).toContain(ah2026.anoCalculado);
      expect(ah2026.formatado).toMatch(/144[78] AH/);
    });
  });

  describe('Tempo Fictício / Literário', () => {
    it('preserva os anos literais narrativos sem conversão', () => {
      // Mesmo selecionando calendários reais, tempo fictício retorna ano literal
      expect(formatarAnoNoCalendario(3019, 'judaico', 'ficticio')).toBe('Ano 3019');
      expect(formatarAnoNoCalendario(1984, 'romano', 'ficticio')).toBe('Ano 1984');
      expect(formatarAnoNoCalendario(100, 'holoceno', 'ficticio')).toBe('Ano 100');
      expect(formatarAnoNoCalendario(-500, 'islamico', 'ficticio')).toBe('Ano 500 a.F.');
    });

    it('descreverAnoComDetalhes indica cronologia narrativa para ficção', () => {
      const descFicticio = descreverAnoComDetalhes(3019, 'gregoriano', 'ficticio');
      expect(descFicticio.principal).toBe('Ano 3019');
      expect(descFicticio.secundario).toContain('Narrativa');
    });

    it('descreverAnoComDetalhes exibe equivalência gregoriana para calendários alternativos', () => {
      const descJudaico = descreverAnoComDetalhes(2026, 'judaico', 'real');
      expect(descJudaico.principal).toBe('5786 AM');
      expect(descJudaico.secundario).toBe('equiv. 2026 d.C.');
    });
  });

  describe('Conversão Bidirecional e Sincronização Numérica', () => {
    it('sincroniza ano numérico e converte de volta ao gregoriano canônico', () => {
      // Caso 1: Calendário Judaico (Anno Mundi)
      // Ano 2026 d.C. -> 5786 AM
      expect(obterNumeroAnoNoCalendario(2026, 'judaico')).toBe(5786);
      expect(converterAnoDoCalendarioParaGregoriano(5786, 'judaico')).toBe(2026);

      // Ano -784 (784 a.C.) -> 2977 AM
      expect(obterNumeroAnoNoCalendario(-784, 'judaico')).toBe(2977);
      expect(converterAnoDoCalendarioParaGregoriano(2977, 'judaico')).toBe(-784);

      // Ano da Criação bíblica / Adão tradicional (3761 a.C.): digitar zero no calendário Judaico
      expect(converterAnoDoCalendarioParaGregoriano(0, 'judaico')).toBe(-3761);
      // 1 AM corresponde a 3760 a.C.
      expect(converterAnoDoCalendarioParaGregoriano(1, 'judaico')).toBe(-3760);

      // Caso 2: Calendário Romano (AUC)
      // 2026 d.C. -> 2779 AUC
      expect(obterNumeroAnoNoCalendario(2026, 'romano')).toBe(2779);
      expect(converterAnoDoCalendarioParaGregoriano(2779, 'romano')).toBe(2026);
      // 1 AUC (753 a.C.)
      expect(converterAnoDoCalendarioParaGregoriano(1, 'romano')).toBe(-753);

      // Caso 3: Calendário Holoceno (HE)
      // 2026 d.C. -> 12026 HE
      expect(obterNumeroAnoNoCalendario(2026, 'holoceno')).toBe(12026);
      expect(converterAnoDoCalendarioParaGregoriano(12026, 'holoceno')).toBe(2026);

      // Caso 4: Calendário Islâmico (AH)
      // 622 d.C. -> 1 AH
      expect(obterNumeroAnoNoCalendario(622, 'islamico')).toBe(1);
      expect(converterAnoDoCalendarioParaGregoriano(1, 'islamico')).toBe(622);

      // Caso 5: Tempo Fictício
      expect(obterNumeroAnoNoCalendario(3019, 'judaico', 'ficticio')).toBe(3019);
      expect(converterAnoDoCalendarioParaGregoriano(3019, 'judaico', 'ficticio')).toBe(3019);
    });

    it('retorna sufixos corretos para exibição na agulha temporal', () => {
      expect(obterSufixoAnoNoCalendario(2026, 'gregoriano')).toBe('d.C.');
      expect(obterSufixoAnoNoCalendario(-784, 'gregoriano')).toBe('a.C.');
      expect(obterSufixoAnoNoCalendario(2026, 'judaico')).toBe('AM');
      expect(obterSufixoAnoNoCalendario(-784, 'judaico')).toBe('AM');
      expect(obterSufixoAnoNoCalendario(-4004, 'judaico')).toBe('a.M.');
      expect(obterSufixoAnoNoCalendario(2026, 'romano')).toBe('AUC');
      expect(obterSufixoAnoNoCalendario(2026, 'holoceno')).toBe('HE');
      expect(obterSufixoAnoNoCalendario(2026, 'islamico')).toBe('AH');
    });
  });

  describe('Formatação de Datas Completas e Sub-Anuais em Múltiplos Calendários', () => {
    it('formata datas no Calendário Judaico com nome de mês hebraico (ex: Adar)', () => {
      // 8 de Março de 2026
      const resCompleto = formatarDataNoCalendario(
        { ano: 2026, mes: 3, dia: 8 },
        'judaico',
        'real',
        'completo',
      );
      expect(resCompleto).toContain('Adar');
      expect(resCompleto).toContain('5786 AM');

      const resMesAno = formatarDataNoCalendario(
        { ano: 2026, mes: 3, dia: 8 },
        'judaico',
        'real',
        'mesAno',
      );
      expect(resMesAno).toBe('Adar de 5786 AM');

      const resDiaMes = formatarDataNoCalendario(
        { ano: 2026, mes: 3, dia: 8 },
        'judaico',
        'real',
        'diaMes',
      );
      expect(resDiaMes).toContain('Adar');
    });

    it('formata datas no Calendário Islâmico com nome de mês lunar (ex: Ramadan)', () => {
      // 8 de Março de 2026
      const resCompleto = formatarDataNoCalendario(
        { ano: 2026, mes: 3, dia: 8 },
        'islamico',
        'real',
        'completo',
      );
      expect(resCompleto).toContain('Ramadan');
      expect(resCompleto).toContain('1447 AH');
    });

    it('formata datas no Calendário Romano (AUC) e Holoceno (HE)', () => {
      const resRomano = formatarDataNoCalendario(
        { ano: 2026, mes: 3, dia: 8 },
        'romano',
        'real',
        'completo',
      );
      expect(resRomano).toBe('8 de Março de 2779 AUC');

      const resHoloceno = formatarDataNoCalendario(
        { ano: 2026, mes: 3, dia: 8 },
        'holoceno',
        'real',
        'completo',
      );
      expect(resHoloceno).toBe('8 de Março de 12026 HE');
    });

    it('formatarDataPrecisaNoCalendario adapta a saída de acordo com o zoom visível', () => {
      // 8 de março de 2026 ~ 2026.18
      const anoCont = 2026.18;

      // Zoom Macro (> 2.5 anos visíveis): apenas ano
      expect(formatarDataPrecisaNoCalendario(anoCont, 50, 'judaico')).toBe('5786 AM');
      expect(formatarDataPrecisaNoCalendario(anoCont, 50, 'romano')).toBe('2779 AUC');

      // Zoom Médio (entre 0.35 e 2.5 anos visíveis): mês e ano
      expect(formatarDataPrecisaNoCalendario(anoCont, 1.2, 'judaico')).toBe('Adar de 5786 AM');
      expect(formatarDataPrecisaNoCalendario(anoCont, 1.2, 'romano')).toBe('Março de 2779 AUC');

      // Zoom Micro (<= 0.35 anos visíveis): data completa
      const dataJudaicaMicro = formatarDataPrecisaNoCalendario(anoCont, 0.1, 'judaico');
      expect(dataJudaicaMicro).toContain('Adar');
      expect(dataJudaicaMicro).toContain('5786 AM');
    });

    it('descreverDataComDetalhes inclui referência gregoriana informativa', () => {
      const anoCont = 2026.18;
      const descJudaico = descreverDataComDetalhes(anoCont, 0.1, 'judaico');
      expect(descJudaico.principal).toContain('Adar');
      expect(descJudaico.secundario).toContain('equiv.');
      expect(descJudaico.secundario).toContain('Março de 2026');

      const descGregoriano = descreverDataComDetalhes(anoCont, 0.1, 'gregoriano');
      expect(descGregoriano.principal).toContain('Março de 2026');
      expect(descGregoriano.secundario).toBeUndefined();
    });
  });
});
