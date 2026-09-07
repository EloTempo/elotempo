import { describe, it, expect } from 'vitest';
import type { DadosImpressaoTimeline, OpcoesImpressaoAcademica } from './tiposImpressao';
import type { Marco } from '../../lib/api';

/**
 * Função utilitária equivalente à lógica de fatiamento cronológico do LinhaTempoAcademicPrintView
 */
function calcularPaginasImpressao(
  anoDe: number,
  anoAte: number,
  anosPorPagina: number | 'auto'
): Array<{ de: number; ate: number }> {
  const spanTotal = Math.max(1, anoAte - anoDe);
  if (
    anosPorPagina === 'auto' ||
    spanTotal <= (typeof anosPorPagina === 'number' ? anosPorPagina : 40)
  ) {
    return [{ de: anoDe, ate: anoAte }];
  }
  const faixaAnos = typeof anosPorPagina === 'number' ? anosPorPagina : 40;
  const lista: Array<{ de: number; ate: number }> = [];
  for (let inicio = anoDe; inicio < anoAte; inicio += faixaAnos) {
    lista.push({
      de: inicio,
      ate: Math.min(anoAte, inicio + faixaAnos),
    });
  }
  return lista;
}

/**
 * Filtra marcos de contexto ativos que intersectam a faixa da prancha
 */
function filtrarMarcosDaFaixa(
  marcos: Marco[],
  linhasAtivasIds: string[],
  de: number,
  ate: number
): Marco[] {
  return marcos
    .filter((m) => {
      const ini = m.ano_inicio ?? de;
      const fim = m.ano_fim ?? ini;
      return fim >= de && ini <= ate && linhasAtivasIds.includes(m.linha_id);
    })
    .sort((a, b) => (a.ano_inicio ?? 0) - (b.ano_inicio ?? 0));
}

describe('Impressão Acadêmica da Linha do Tempo (ABNT A4 Paisagem)', () => {
  describe('Fatiamento Cronológico e Paginação', () => {
    it('mantém em folha única quando o modo for "auto"', () => {
      const pags = calcularPaginasImpressao(1800, 2000, 'auto');
      expect(pags).toHaveLength(1);
      expect(pags[0]).toEqual({ de: 1800, ate: 2000 });
    });

    it('divide um intervalo de 80 anos em 2 páginas de 40 anos', () => {
      const pags = calcularPaginasImpressao(1850, 1930, 40);
      expect(pags).toHaveLength(2);
      expect(pags[0]).toEqual({ de: 1850, ate: 1890 });
      expect(pags[1]).toEqual({ de: 1890, ate: 1930 });
    });

    it('enquadra o resto de anos na última página sem perder o teto anoAte', () => {
      const pags = calcularPaginasImpressao(1850, 1945, 40);
      expect(pags).toHaveLength(3);
      expect(pags[0]).toEqual({ de: 1850, ate: 1890 });
      expect(pags[1]).toEqual({ de: 1890, ate: 1930 });
      expect(pags[2]).toEqual({ de: 1930, ate: 1945 });
    });

    it('mantém 1 folha se a duração for menor ou igual à faixa configurada', () => {
      const pags = calcularPaginasImpressao(1900, 1935, 40);
      expect(pags).toHaveLength(1);
      expect(pags[0]).toEqual({ de: 1900, ate: 1935 });
    });
  });

  describe('Filtragem de Marcos por Prancha e Linhas Ativas', () => {
    const marcosMock: Marco[] = [
      {
        id: 'm1',
        linha_id: 'linha-brasil',
        titulo: 'Guerra do Paraguai',
        ano_inicio: 1864,
        ano_fim: 1870,
        data_periodo_texto: '1864–1870',
      },
      {
        id: 'm2',
        linha_id: 'linha-brasil',
        titulo: 'Proclamação da República',
        ano_inicio: 1889,
        ano_fim: 1889,
        data_periodo_texto: '1889',
      },
      {
        id: 'm3',
        linha_id: 'linha-mundo',
        titulo: 'Primeira Guerra Mundial',
        ano_inicio: 1914,
        ano_fim: 1918,
        data_periodo_texto: '1914–1918',
      },
    ];

    it('retorna apenas marcos pertencentes a linhas de contexto ativas', () => {
      // Somente linha-brasil está ativa
      const ativos = filtrarMarcosDaFaixa(marcosMock, ['linha-brasil'], 1850, 1950);
      expect(ativos).toHaveLength(2);
      expect(ativos.map((m) => m.id)).toEqual(['m1', 'm2']);
    });

    it('restringe marcos aos limites temporais da página', () => {
      // Página 1: 1850 a 1880
      const pag1 = filtrarMarcosDaFaixa(marcosMock, ['linha-brasil', 'linha-mundo'], 1850, 1880);
      expect(pag1.map((m) => m.id)).toEqual(['m1']);

      // Página 2: 1880 a 1920
      const pag2 = filtrarMarcosDaFaixa(marcosMock, ['linha-brasil', 'linha-mundo'], 1880, 1920);
      expect(pag2.map((m) => m.id)).toEqual(['m2', 'm3']);
    });
  });

  describe('Compatibilidade com Objeto DadosImpressaoTimeline', () => {
    it('valida a consistência do pacote completo de dados para exportação ABNT', () => {
      const dados: DadosImpressaoTimeline = {
        linhasPessoais: [
          {
            pessoa_id: 'p1',
            nome: 'Manuel da Silva',
            sexo: 'M',
            ano_nascimento: 1870,
            ano_falecimento: 1945,
            is_vivo: false,
            marcos: [
              {
                tipo: 'nascimento',
                ano: 1870,
                data_texto: '12/04/1870',
                local: 'Porto, Portugal',
                is_participacao: false,
                visivel_na_pessoa: true,
              },
            ],
          },
        ],
        linhasContexto: [
          {
            id: 'lc-1',
            titulo: 'História Regional',
            categoria: 'historia',
            ano_min: 1800,
            ano_max: 2000,
            is_contexto: true,
            is_bloqueada: false,
            marcos_alta: 5,
            marcos_total: 10,
          },
        ],
        linhasAtivasIds: ['lc-1'],
        marcos: [],
        coresPersonalizadas: { p1: '#10b981' },
        janelaAtual: { de: 1860, ate: 1950 },
        regiaoImpressao: { de: 1865, ate: 1940 },
        calendarioAtivo: 'gregoriano',
        arvoreTitulo: 'Família Silva',
      };

      const opcoes: OpcoesImpressaoAcademica = {
        numeroFigura: '1',
        tituloFigura: 'Linha do Tempo Comparativa da Família Silva',
        fonteTexto: 'Elaborado pelo autor com o software EloTempo (2026)',
        incluirQuadroMarcos: true,
        anosPorPagina: 40,
        anoDe: dados.regiaoImpressao!.de,
        anoAte: dados.regiaoImpressao!.ate,
      };

      expect(dados.regiaoImpressao?.de).toBe(1865);
      expect(dados.regiaoImpressao?.ate).toBe(1940);
      expect(dados.coresPersonalizadas['p1']).toBe('#10b981');
      expect(opcoes.numeroFigura).toBe('1');

      const span = opcoes.anoAte - opcoes.anoDe;
      expect(span).toBe(75);

      const paginas = calcularPaginasImpressao(opcoes.anoDe, opcoes.anoAte, opcoes.anosPorPagina);
      expect(paginas).toHaveLength(2);
      expect(paginas[0]).toEqual({ de: 1865, ate: 1905 });
      expect(paginas[1]).toEqual({ de: 1905, ate: 1940 });
    });
  });

  describe('Anticolisão Inteligente e Agrupamento (Clustering)', () => {
    // Import dynamically / verify
    it('agrupa 28 marcos hiperconcentrados em 1822 (escala de 180 anos) em um único cluster limpo', async () => {
      const { mapearNumerosMarcosDaFolha, calcularAnticolisaoMarcos } = await import('./anticolisaoImpressao');

      // 28 marcos ocorridos em 1822 (ex: Independência do Brasil)
      const marcosIndependencia: Marco[] = Array.from({ length: 28 }, (_, i) => ({
        id: `indep-${i + 1}`,
        linha_id: 'linha-indep',
        titulo: `Acontecimento da Independência ${i + 1}`,
        ano_inicio: 1822,
        data_periodo_texto: `1822`,
      }));

      const mapaNumeros = mapearNumerosMarcosDaFolha(marcosIndependencia);
      expect(mapaNumeros.size).toBe(28);
      expect(mapaNumeros.get('indep-1')).toBe(1);
      expect(mapaNumeros.get('indep-28')).toBe(28);

      // Em uma prancha de 180 anos (1760 a 1940) com trilha de 825px:
      // 1 ano = 4.58px. 28 marcos no ano 1822 caem no mesmo pixel!
      const resultado = calcularAnticolisaoMarcos(
        marcosIndependencia,
        mapaNumeros,
        1760,
        1940,
        825,
        18,
        75
      );

      // Deve agrupar em exatamente 1 cluster consolidado
      expect(resultado).toHaveLength(1);
      expect(resultado[0].tipo).toBe('cluster');
      if (resultado[0].tipo === 'cluster') {
        expect(resultado[0].total).toBe(28);
        expect(resultado[0].rotuloNumeros).toBe('1–28');
        expect(resultado[0].anoTexto).toBe('1822');
      }
    });

    it('suprime título de marco adjacente quando a distância for menor que o limiar seguro (evita sobreposição)', async () => {
      const { mapearNumerosMarcosDaFolha, calcularAnticolisaoMarcos } = await import('./anticolisaoImpressao');

      // Dois marcos a 8 anos de distância em uma escala de 100 anos (825px):
      // Delta = (8 / 100) * 825 = 66px.
      // 66px é maior que o pino (18px), mas MENOR que o limiar de título (75px)
      const marcos: Marco[] = [
        {
          id: 'm-1822',
          linha_id: 'linha-hist',
          titulo: 'Independência do Brasil',
          ano_inicio: 1822,
          data_periodo_texto: '1822',
        },
        {
          id: 'm-1830',
          linha_id: 'linha-hist',
          titulo: 'Noite das Garrafadas',
          ano_inicio: 1830,
          data_periodo_texto: '1830',
        },
      ];

      const mapaNumeros = mapearNumerosMarcosDaFolha(marcos);
      const resultado = calcularAnticolisaoMarcos(
        marcos,
        mapaNumeros,
        1800,
        1900,
        825,
        18,
        75
      );

      expect(resultado).toHaveLength(2);
      expect(resultado[0].tipo).toBe('individual');
      expect(resultado[1].tipo).toBe('individual');

      if (resultado[0].tipo === 'individual' && resultado[1].tipo === 'individual') {
        // O primeiro marco não tem 75px livres até o segundo (tem apenas ~66px)
        expect(resultado[0].exibirTitulo).toBe(false);
        // O segundo marco tem folga até a borda direita (1830 até 1900 = 70 anos = ~577px)
        expect(resultado[1].exibirTitulo).toBe(true);
      }
    });

    it('exibe títulos quando há espaçamento confortável entre os marcos', async () => {
      const { mapearNumerosMarcosDaFolha, calcularAnticolisaoMarcos } = await import('./anticolisaoImpressao');

      // Marcos separados por 50 anos (distância > 300px)
      const marcos: Marco[] = [
        {
          id: 'm-1808',
          linha_id: 'linha-hist',
          titulo: 'Chegada da Família Real',
          ano_inicio: 1808,
          data_periodo_texto: '1808',
        },
        {
          id: 'm-1889',
          linha_id: 'linha-hist',
          titulo: 'Proclamação da República',
          ano_inicio: 1889,
          data_periodo_texto: '1889',
        },
      ];

      const mapaNumeros = mapearNumerosMarcosDaFolha(marcos);
      const resultado = calcularAnticolisaoMarcos(
        marcos,
        mapaNumeros,
        1800,
        1900,
        825,
        18,
        75
      );

      expect(resultado).toHaveLength(2);
      if (resultado[0].tipo === 'individual' && resultado[1].tipo === 'individual') {
        expect(resultado[0].exibirTitulo).toBe(true);
        expect(resultado[1].exibirTitulo).toBe(true);
      }
    });
  });
});
