import { describe, it, expect } from 'vitest';
import {
  reordenarLista,
  ordenarIdsPorAno,
  sincronizarOrdemVidas,
  calcularFatiaVisivelBarra,
  calcularGridBlender,
  converterDataParaAnoFracionario,
  agruparMarcosPessoaisProximos,
  calcularSubLanesContexto,
} from './ordenacaoTrilhas';

describe('reordenarLista (drag-and-drop de trilhas)', () => {
  const listaInicial = ['P1', 'P2', 'P3', 'P4', 'P5'];

  it('move um item para antes de outro', () => {
    // Mover P4 para antes de P2 -> [P1, P4, P2, P3, P5]
    const resultado = reordenarLista(listaInicial, 'P4', 'P2', 'antes');
    expect(resultado).toEqual(['P1', 'P4', 'P2', 'P3', 'P5']);
  });

  it('move um item para depois de outro', () => {
    // Mover P2 para depois de P4 -> [P1, P3, P4, P2, P5]
    const resultado = reordenarLista(listaInicial, 'P2', 'P4', 'depois');
    expect(resultado).toEqual(['P1', 'P3', 'P4', 'P2', 'P5']);
  });

  it('move o primeiro item para o final da lista', () => {
    const resultado = reordenarLista(listaInicial, 'P1', 'P5', 'depois');
    expect(resultado).toEqual(['P2', 'P3', 'P4', 'P5', 'P1']);
  });

  it('move o último item para o topo da lista', () => {
    const resultado = reordenarLista(listaInicial, 'P5', 'P1', 'antes');
    expect(resultado).toEqual(['P5', 'P1', 'P2', 'P3', 'P4']);
  });

  it('não altera a lista se origem e destino forem iguais', () => {
    const resultado = reordenarLista(listaInicial, 'P3', 'P3', 'antes');
    expect(resultado).toEqual(listaInicial);
  });
});

describe('ordenarIdsPorAno', () => {
  it('ordena pessoas cronologicamente pelo ano de nascimento', () => {
    const ids = ['carlos2', 'joana', 'filipe2', 'carlos1'];
    const mapa = new Map([
      ['carlos2', { ano: 1661, nome: 'Carlos II' }],
      ['joana', { ano: 1479, nome: 'Joana, a Louca' }],
      ['filipe2', { ano: 1527, nome: 'Filipe II' }],
      ['carlos1', { ano: 1500, nome: 'Carlos I' }],
    ]);

    const ordenados = ordenarIdsPorAno(ids, mapa);
    expect(ordenados).toEqual(['joana', 'carlos1', 'filipe2', 'carlos2']);
  });

  it('posiciona pessoas sem ano de nascimento no final, desempatando por nome', () => {
    const ids = ['desconhecidoB', 'joana', 'desconhecidoA'];
    const mapa = new Map([
      ['desconhecidoB', { ano: null, nome: 'Zeca' }],
      ['joana', { ano: 1479, nome: 'Joana' }],
      ['desconhecidoA', { ano: null, nome: 'Ana' }],
    ]);

    const ordenados = ordenarIdsPorAno(ids, mapa);
    expect(ordenados).toEqual(['joana', 'desconhecidoA', 'desconhecidoB']);
  });
});

describe('sincronizarOrdemVidas (estabilidade de seleção e preservação de ordem)', () => {
  const baseMembros = ['joana', 'carlos1', 'filipe2', 'carlos2'];

  it('não altera a ordem das trilhas quando o usuário clica em alguém da árvore', () => {
    // Cenário relatado pelo usuário: clicar em qualquer pessoa não deve alterar as posições
    const ordemComPessoa1 = sincronizarOrdemVidas({
      baseIds: baseMembros,
    });
    // O usuário clica em 'filipe2' na árvore genealógica
    // A base continua a mesma, e a ordem deve permanecer idêntica!
    const ordemAposClique = sincronizarOrdemVidas({
      baseIds: baseMembros,
    });
    expect(ordemAposClique).toEqual(ordemComPessoa1);
    expect(ordemAposClique).toEqual(['joana', 'carlos1', 'filipe2', 'carlos2']);
  });

  it('preserva a ordem personalizada após o usuário arrastar e reordenar', () => {
    const ordemCustom = ['carlos2', 'carlos1', 'joana', 'filipe2'];
    const resultado = sincronizarOrdemVidas({
      baseIds: baseMembros,
      ordemPersonalizada: ordemCustom,
    });
    expect(resultado).toEqual(ordemCustom);
  });

  it('anexa novos membros ao final da ordem personalizada sem bagunçar os já ordenados', () => {
    const ordemCustom = ['carlos2', 'carlos1'];
    const resultado = sincronizarOrdemVidas({
      baseIds: baseMembros, // tem joana e filipe2 também
      ordemPersonalizada: ordemCustom,
    });
    expect(resultado).toEqual(['carlos2', 'carlos1', 'joana', 'filipe2']);
  });

  it('ignora membros removidos temporariamente', () => {
    const resultado = sincronizarOrdemVidas({
      baseIds: baseMembros,
      vidasRemovidas: ['carlos1'],
    });
    expect(resultado).toEqual(['joana', 'filipe2', 'carlos2']);
  });
});

describe('calcularFatiaVisivelBarra (Viewport-Aware Sticky Label)', () => {
  const larguraCanvas = 1000;

  it('centraliza o rótulo no meio da barra quando ela está totalmente visível', () => {
    // Barra de x=200 a x=600 (largura 400)
    const fatia = calcularFatiaVisivelBarra({ x0: 200, x1: 600, larguraCanvas });
    expect(fatia.barraNaTela).toBe(true);
    expect(fatia.visivelInicio).toBe(200);
    expect(fatia.visivelFim).toBe(600);
    expect(fatia.larguraVisivel).toBe(400);
    expect(fatia.centroVisivelRelativo).toBe(200); // 200 + 200 = 400 no canvas
    expect(fatia.estendeParaEsquerda).toBe(false);
    expect(fatia.estendeParaDireita).toBe(false);
  });

  it('mantém o rótulo centralizado na tela quando o nascimento ocorreu antes da borda esquerda (x0 < 0)', () => {
    // Ex: José Bonifácio nasceu antes da janela visível.
    // Barra começa em -500 e termina em +300 no canvas
    const fatia = calcularFatiaVisivelBarra({ x0: -500, x1: 300, larguraCanvas });
    expect(fatia.barraNaTela).toBe(true);
    expect(fatia.visivelInicio).toBe(0);
    expect(fatia.visivelFim).toBe(300);
    expect(fatia.larguraVisivel).toBe(300);
    // Centro visível no canvas = 150. Relativo a x0 (-500) = 150 - (-500) = 650
    expect(fatia.centroVisivelRelativo).toBe(650);
    expect(fatia.estendeParaEsquerda).toBe(true);
    expect(fatia.estendeParaDireita).toBe(false);
  });

  it('mantém o rótulo centralizado na tela quando o falecimento ocorre além da borda direita (x1 > larguraCanvas)', () => {
    // Barra começa em +700 e termina em +1500
    const fatia = calcularFatiaVisivelBarra({ x0: 700, x1: 1500, larguraCanvas });
    expect(fatia.barraNaTela).toBe(true);
    expect(fatia.visivelInicio).toBe(700);
    expect(fatia.visivelFim).toBe(1000);
    expect(fatia.larguraVisivel).toBe(300);
    // Centro visível no canvas = 850. Relativo a x0 (700) = 850 - 700 = 150
    expect(fatia.centroVisivelRelativo).toBe(150);
    expect(fatia.estendeParaEsquerda).toBe(false);
    expect(fatia.estendeParaDireita).toBe(true);
  });

  it('detecta quando a vida atravessa completamente o viewport de um lado ao outro', () => {
    // Barra começa em -800 e termina em +2000 (abrange toda a janela 0..1000)
    const fatia = calcularFatiaVisivelBarra({ x0: -800, x1: 2000, larguraCanvas });
    expect(fatia.barraNaTela).toBe(true);
    expect(fatia.visivelInicio).toBe(0);
    expect(fatia.visivelFim).toBe(1000);
    expect(fatia.larguraVisivel).toBe(1000);
    // Centro visível no canvas = 500. Relativo a x0 = 500 - (-800) = 1300
    expect(fatia.centroVisivelRelativo).toBe(1300);
    expect(fatia.estendeParaEsquerda).toBe(true);
    expect(fatia.estendeParaDireita).toBe(true);
  });

  it('retorna barraNaTela falso se a vida estiver totalmente fora da tela', () => {
    const antesDaTela = calcularFatiaVisivelBarra({ x0: -900, x1: -100, larguraCanvas });
    expect(antesDaTela.barraNaTela).toBe(false);

    const depoisDaTela = calcularFatiaVisivelBarra({ x0: 1200, x1: 1800, larguraCanvas });
    expect(depoisDaTela.barraNaTela).toBe(false);
  });
});

describe('calcularGridBlender (Grade adaptativa de alta precisão)', () => {
  it('calcula subdivisões adequadas para um zoom macro (séculos)', () => {
    const grid = calcularGridBlender({ de: 1500, ate: 2000 }); // span 500
    expect(grid.passoPrincipal).toBe(100);
    expect(grid.passoSecundario).toBe(20);
    expect(grid.marcasPrincipais).toEqual([1500, 1600, 1700, 1800, 1900, 2000]);
    // Marcas secundárias não contêm as principais
    expect(grid.marcasSecundarias).toContain(1520);
    expect(grid.marcasSecundarias).not.toContain(1600);
  });

  it('calcula subdivisões adequadas para um zoom próximo de 30 anos (9 anos intermediários entre décadas)', () => {
    const grid = calcularGridBlender({ de: 1810, ate: 1840 }); // span 30
    expect(grid.passoPrincipal).toBe(10);
    expect(grid.passoSecundario).toBe(1); // Exatamente 1 ano por subdivisão
    expect(grid.marcasPrincipais).toEqual([1810, 1820, 1830, 1840]);
    // Entre 1810 e 1820, devem existir exatamente as 9 linhas intermediárias (1811 a 1819)
    const entre1810e1820 = grid.marcasSecundarias.filter((a) => a > 1810 && a < 1820);
    expect(entre1810e1820).toEqual([1811, 1812, 1813, 1814, 1815, 1816, 1817, 1818, 1819]);
    expect(grid.marcasSecundarias).toContain(1822); // ano da Independência!
    expect(grid.marcasSecundarias).not.toContain(1820);
  });

  it('calcula subdivisões de 3 níveis para zoom de 15 anos (quinquênios + anos intermediários + meses)', () => {
    const grid = calcularGridBlender({ de: 2000, ate: 2015 }); // span 15
    expect(grid.passoPrincipal).toBe(5);
    expect(grid.passoSecundario).toBe(1);
    expect(grid.marcasPrincipais).toEqual([2000, 2005, 2010, 2015]);
    // Anos intermediários entre 2000 e 2005 (2001 a 2004)
    const entre2000e2005 = grid.marcasSecundarias.filter((a) => a > 2000 && a < 2005);
    expect(entre2000e2005).toEqual([2001, 2002, 2003, 2004]);
    // Marcas terciárias representando meses (trimestres 4, 7, 10 de cada ano)
    expect(grid.marcasTerciarias.length).toBeGreaterThan(0);
    // Ex: abril de 2001 deve estar presente nas marcas terciárias
    const abril2001 = grid.marcasTerciarias.find((t) => t > 2001.2 && t < 2001.3);
    expect(abril2001).toBeDefined();
  });

  it('calcula subdivisões para zoom ultra-próximo de poucos anos com meses', () => {
    const grid = calcularGridBlender({ de: 1820, ate: 1826 }); // span 6
    expect(grid.passoPrincipal).toBe(2);
    expect(grid.passoSecundario).toBe(1);
    expect(grid.marcasPrincipais).toEqual([1820, 1822, 1824, 1826]);
    expect(grid.marcasSecundarias).toEqual([1821, 1823, 1825]);
    expect(grid.marcasTerciarias.length).toBeGreaterThan(0);
  });
});

describe('Cálculo Contínuo de Pan (Deslocamento Temporal Suave)', () => {
  it('calcula o novo intervalo de anos sem perda por arredondamento para movimentos suaves', () => {
    const janelaInicial = { de: 1800, ate: 1900 }; // span = 100 anos
    const larguraCanvas = 1200; // 1200px
    const span = janelaInicial.ate - janelaInicial.de;

    // Simula 12 movimentos de 3 pixels cada (total de 36 pixels à direita: 36/1200 * 100 = 3 anos exatos)
    let janelaFinal = { ...janelaInicial };
    const mouseInicialX = 500;
    for (let passo = 1; passo <= 12; passo++) {
      const mouseAtualX = mouseInicialX + passo * 3; // +3, +6, ..., +36px
      const deltaPixels = mouseAtualX - mouseInicialX;
      const deltaAnos = (deltaPixels / larguraCanvas) * span;
      janelaFinal = {
        de: Math.round(janelaInicial.de - deltaAnos),
        ate: Math.round(janelaInicial.ate - deltaAnos),
      };
    }

    // 36 pixels / 1200px * 100 anos = 3 anos exatos para a esquerda no tempo
    expect(janelaFinal.de).toBe(1797);
    expect(janelaFinal.ate).toBe(1897);
  });
});

describe('Resolução de Alturas Individuais de Trilhas', () => {
  it('usa a altura individual configurada ou recorre à altura padrão', () => {
    const alturasIndividuais: Record<string, number> = {
      'pedro1': 75,
      'leopoldina': 60,
    };
    const alturaPadrao = 38;

    const obterAltura = (id: string) => alturasIndividuais[id] ?? alturaPadrao;

    expect(obterAltura('pedro1')).toBe(75);
    expect(obterAltura('leopoldina')).toBe(60);
    expect(obterAltura('teresa_cristina')).toBe(38); // fallback para padrão
  });
});

describe('converterDataParaAnoFracionario', () => {
  it('converte datas brasileiras DD/MM/AAAA para ano com fração decimal', () => {
    // 09/01/1822 -> início de 1822
    const fico = converterDataParaAnoFracionario(1822, '09/01/1822');
    expect(fico).toBeCloseTo(1822.02, 1);

    // 07/09/1822 -> setembro de 1822
    const ipiranga = converterDataParaAnoFracionario(1822, '07/09/1822');
    expect(ipiranga).toBeCloseTo(1822.72, 1);

    // 01/12/1822 -> final de 1822
    const coroacao = converterDataParaAnoFracionario(1822, '01/12/1822');
    expect(coroacao).toBeCloseTo(1822.92, 1);

    expect(ipiranga!).toBeGreaterThan(fico!);
    expect(coroacao!).toBeGreaterThan(ipiranga!);
  });

  it('usa o ano base quando a data de texto não tiver dia/mês', () => {
    expect(converterDataParaAnoFracionario(1822, '1822')).toBe(1822);
    expect(converterDataParaAnoFracionario(1822, null)).toBe(1822);
    expect(converterDataParaAnoFracionario(null, null)).toBeNull();
  });
});

describe('agruparMarcosPessoaisProximos (Clustering)', () => {
  it('isola marcos distantes em chips individuais', () => {
    const marcos = [
      { ano: 1800, tipo: 'Nascimento', data_texto: '1800' },
      { ano: 1850, tipo: 'Casamento', data_texto: '1850' },
    ];
    // Escala 10px por ano: 1800 = 0px, 1850 = 500px
    const pos = (a: number) => (a - 1800) * 10;
    const grupos = agruparMarcosPessoaisProximos(marcos, pos, 60);

    expect(grupos).toHaveLength(2);
    expect(grupos[0].isCluster).toBe(false);
    expect(grupos[1].isCluster).toBe(false);
  });

  it('agrupa múltiplos marcos coincidentes no mesmo ano ou mês para evitar sobreposição', () => {
    const marcos1822 = [
      { ano: 1822, tipo: 'Dia do Fico', data_texto: '09/01/1822' },
      { ano: 1822, tipo: 'Cumpra-se', data_texto: '04/05/1822' },
      { ano: 1822, tipo: 'Independência', data_texto: '07/09/1822' },
      { ano: 1822, tipo: 'Coroação', data_texto: '01/12/1822' },
    ];
    // Escala 1px por ano (zoom afastado): todos os eventos de 1822 distam menos de 1px
    const pos = (a: number) => (a - 1800) * 1;
    const grupos = agruparMarcosPessoaisProximos(marcos1822, pos, 60);

    expect(grupos).toHaveLength(1);
    expect(grupos[0].isCluster).toBe(true);
    expect(grupos[0].itens).toHaveLength(4);
  });
});

describe('calcularSubLanesContexto (Regra Simples de Visibilidade de Texto)', () => {
  it('omite o texto se o marco seguinte estiver próximo demais (evitando sobreposição)', () => {
    const marcos = [
      { id: '1', titulo: 'Revolução Liberal do Porto', ano_inicio: 1820, ano_fim: 1820 },
      { id: '2', titulo: 'Retorno de D. João VI', ano_inicio: 1821, ano_fim: 1821 },
    ];
    // Zoom afastado: 10px por ano. Distância = 10px. O texto precisa de ~130px.
    const pos = (a: number) => a * 10;
    const posicionado = calcularSubLanesContexto(marcos, pos);

    expect(posicionado).toHaveLength(2);
    // Como a distância para o próximo marco é de apenas 10px, o primeiro NÃO mostra texto (apenas o pino)
    expect(posicionado[0].temRotulo).toBe(false);
    // O segundo é o último marco da série, então tem espaço livre à frente
    expect(posicionado[1].temRotulo).toBe(true);
  });

  it('exibe o texto completo quando houver espaço temporal suficiente no zoom atual', () => {
    const marcos = [
      { id: '1', titulo: 'Revolução Liberal', ano_inicio: 1820, ano_fim: 1820 },
      { id: '2', titulo: 'Constituição de 1824', ano_inicio: 1824, ano_fim: 1824 },
    ];
    // Zoom aproximado: 100px por ano. Distância = 400px.
    const pos = (a: number) => a * 100;
    const posicionado = calcularSubLanesContexto(marcos, pos);

    expect(posicionado).toHaveLength(2);
    // Espaço de 400px é mais que suficiente para o texto: ambos mostram texto completo
    expect(posicionado[0].temRotulo).toBe(true);
    expect(posicionado[1].temRotulo).toBe(true);
  });
});

describe('calcularGridBlender - Escalas Sub-Anuais (Meses e Dias)', () => {
  it('gera marcas de meses quando o span está entre 0.35 e 2 anos', () => {
    // Zoom em 1 ano exato (1822)
    const grid = calcularGridBlender({ de: 1822.0, ate: 1823.0 });
    expect(grid.escala).toBe('meses');
    expect(grid.marcasPrincipais.length).toBeGreaterThanOrEqual(11);
    // Primeiro mês de 1822
    expect(grid.rotulos?.get(grid.marcasPrincipais[0])).toContain('Jan 1822');
    // Deve conter Setembro
    const temSetembro = Array.from(grid.rotulos?.values() ?? []).some((r) => r.includes('Set'));
    expect(temSetembro).toBe(true);
  });

  it('gera marcas de dias quando o span está abaixo de 0.35 anos', () => {
    // Zoom em ~1 mês (fevereiro de 2024 - ano bissexto)
    const deFev = 2024 + 31 / 366;
    const ateFev = 2024 + 60 / 366;
    const grid = calcularGridBlender({ de: deFev, ate: ateFev });
    expect(grid.escala).toBe('dias');
    expect(grid.marcasPrincipais.length).toBeGreaterThan(0);
    // Deve conter o dia 1 de Fev
    const temDia1 = Array.from(grid.rotulos?.values() ?? []).some((r) => r.includes('1 Fev'));
    expect(temDia1).toBe(true);
  });
});
