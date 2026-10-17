import { describe, it, expect } from 'vitest';
import { calcularLayout, METRICAS, caminhoOrtogonal } from './layout';
import type { TreeGraph, PersonNode, UnionNode, GraphLink } from '../../types';

// ---------------------------------------------------------------------------
// Construtores de cenário
// ---------------------------------------------------------------------------

function pessoa(id: string, sexo: string, ano?: number): PersonNode {
  return {
    id,
    nome: id,
    sobrenome: null,
    sexo,
    is_vivo: false,
    is_placeholder: false,
    ano_nascimento: ano ?? null,
    ano_falecimento: null,
    tem_foto: false,
    tem_biografia: false,
    tem_documentos: false,
    tem_religiao: false,
  };
}

function uniao(id: string, m: string, f: string): UnionNode {
  return {
    id,
    estado_vinculo: 'casamento',
    ano_casamento: null,
    slot_masculino_id: m,
    slot_feminino_id: f,
  };
}

function grafo(
  nodes: PersonNode[],
  unions: UnionNode[],
  filhos: Array<[string, string]> = [],
): TreeGraph {
  const links: GraphLink[] = [];
  for (const u of unions) {
    links.push({ source: u.slot_masculino_id, target: u.id, tipo: 'pai_uniao' });
    links.push({ source: u.slot_feminino_id, target: u.id, tipo: 'mae_uniao' });
  }
  for (const [uid, pid] of filhos) {
    links.push({ source: uid, target: pid, tipo: 'uniao_filho', tipo_vinculo: 'biologico' });
  }
  return { raiz_id: nodes[0]?.id ?? '', nodes, unions, links };
}

/** Duas caixas se sobrepõem horizontalmente na mesma linha? */
function sobrepoe(
  a: { x: number; y: number },
  b: { x: number; y: number },
  largura = METRICAS.larguraNo,
): boolean {
  if (Math.abs(a.y - b.y) > 1) return false;
  return Math.abs(a.x - b.x) < largura;
}

// ---------------------------------------------------------------------------

describe('calcularLayout', () => {
  it('não quebra com um grafo vazio', () => {
    const r = calcularLayout({ raiz_id: '', nodes: [], unions: [], links: [] });
    expect(r.pessoas).toHaveLength(0);
    expect(r.unioes).toHaveLength(0);
    expect(r.arestas).toHaveLength(0);
  });

  it('posiciona uma pessoa sozinha', () => {
    const r = calcularLayout(grafo([pessoa('a', 'M')], []));
    expect(r.pessoas).toHaveLength(1);
    expect(r.pessoas[0].geracao).toBe(0);
    expect(r.largura).toBeGreaterThan(0);
  });

  it('põe o casal lado a lado, na mesma linha, com o anel entre os dois', () => {
    const r = calcularLayout(
      grafo([pessoa('pai', 'M'), pessoa('mae', 'F')], [uniao('u1', 'pai', 'mae')]),
    );

    const pai = r.pessoas.find((p) => p.id === 'pai')!;
    const mae = r.pessoas.find((p) => p.id === 'mae')!;
    const anel = r.unioes.find((u) => u.id === 'u1')!;

    expect(pai.y).toBe(mae.y);
    expect(anel.y).toBe(pai.y);

    // O slot masculino desenha à esquerda, por convenção.
    expect(pai.x).toBeLessThan(mae.x);
    // E o anel fica exatamente no meio.
    expect(anel.x).toBeCloseTo((pai.x + mae.x) / 2, 5);
    // Sem sobreposição entre os cards.
    expect(Math.abs(mae.x - pai.x)).toBeGreaterThanOrEqual(METRICAS.larguraNo);
  });

  it('coloca os filhos uma geração abaixo dos pais', () => {
    const r = calcularLayout(
      grafo(
        [pessoa('pai', 'M'), pessoa('mae', 'F'), pessoa('filho', 'M')],
        [uniao('u1', 'pai', 'mae')],
        [['u1', 'filho']],
      ),
    );

    const pai = r.pessoas.find((p) => p.id === 'pai')!;
    const filho = r.pessoas.find((p) => p.id === 'filho')!;

    expect(filho.geracao).toBe(pai.geracao + 1);
    expect(filho.y).toBeGreaterThan(pai.y);
    expect(filho.y - pai.y).toBe(METRICAS.alturaGeracao);
  });

  it('centraliza o filho único sob o anel da união', () => {
    const r = calcularLayout(
      grafo(
        [pessoa('pai', 'M'), pessoa('mae', 'F'), pessoa('filho', 'M')],
        [uniao('u1', 'pai', 'mae')],
        [['u1', 'filho']],
      ),
    );

    const anel = r.unioes.find((u) => u.id === 'u1')!;
    const filho = r.pessoas.find((p) => p.id === 'filho')!;

    expect(filho.x).toBeCloseTo(anel.x, 5);
  });

  it('centraliza a prole inteira sob o anel, não sob um dos pais', () => {
    const r = calcularLayout(
      grafo(
        [
          pessoa('pai', 'M'),
          pessoa('mae', 'F'),
          pessoa('f1', 'M', 1940),
          pessoa('f2', 'F', 1942),
          pessoa('f3', 'M', 1944),
        ],
        [uniao('u1', 'pai', 'mae')],
        [
          ['u1', 'f1'],
          ['u1', 'f2'],
          ['u1', 'f3'],
        ],
      ),
    );

    const anel = r.unioes.find((u) => u.id === 'u1')!;
    const filhos = ['f1', 'f2', 'f3'].map((id) => r.pessoas.find((p) => p.id === id)!);
    const centroDaProle = (filhos[0].x + filhos[2].x) / 2;

    expect(centroDaProle).toBeCloseTo(anel.x, 5);
  });

  it('ordena os irmãos por ano de nascimento', () => {
    const r = calcularLayout(
      grafo(
        [
          pessoa('pai', 'M'),
          pessoa('mae', 'F'),
          // Cadastrados fora de ordem de propósito.
          pessoa('caçula', 'M', 1950),
          pessoa('primogênito', 'F', 1940),
          pessoa('meio', 'M', 1945),
        ],
        [uniao('u1', 'pai', 'mae')],
        [
          ['u1', 'caçula'],
          ['u1', 'primogênito'],
          ['u1', 'meio'],
        ],
      ),
    );

    const x = (id: string) => r.pessoas.find((p) => p.id === id)!.x;
    expect(x('primogênito')).toBeLessThan(x('meio'));
    expect(x('meio')).toBeLessThan(x('caçula'));
  });

  it('põe quem não tem ano de nascimento no fim da prole, sem sumir', () => {
    const r = calcularLayout(
      grafo(
        [
          pessoa('pai', 'M'),
          pessoa('mae', 'F'),
          pessoa('sem-data', 'M'),
          pessoa('com-data', 'F', 1940),
        ],
        [uniao('u1', 'pai', 'mae')],
        [
          ['u1', 'sem-data'],
          ['u1', 'com-data'],
        ],
      ),
    );

    const semData = r.pessoas.find((p) => p.id === 'sem-data')!;
    const comData = r.pessoas.find((p) => p.id === 'com-data')!;

    expect(comData.x).toBeLessThan(semData.x);
    expect(semData).toBeDefined(); // continua no desenho
  });

  it('não sobrepõe irmãos que têm proles de tamanhos diferentes', () => {
    // O caso que o espalhamento por índice errava sempre: um ramo largo
    // ao lado de um ramo estreito.
    const nodes = [
      pessoa('avô', 'M'),
      pessoa('avó', 'F'),
      pessoa('tio', 'M', 1930),
      pessoa('tia-esposa', 'F'),
      pessoa('pai', 'M', 1935),
      pessoa('mãe', 'F'),
    ];
    // O tio tem 4 filhos; o pai tem 1.
    for (let i = 0; i < 4; i++) nodes.push(pessoa(`primo${i}`, 'M', 1960 + i));
    nodes.push(pessoa('eu', 'M', 1965));

    const unions = [
      uniao('u-avós', 'avô', 'avó'),
      uniao('u-tio', 'tio', 'tia-esposa'),
      uniao('u-pais', 'pai', 'mãe'),
    ];

    const filhos: Array<[string, string]> = [
      ['u-avós', 'tio'],
      ['u-avós', 'pai'],
      ['u-tio', 'primo0'],
      ['u-tio', 'primo1'],
      ['u-tio', 'primo2'],
      ['u-tio', 'primo3'],
      ['u-pais', 'eu'],
    ];

    const r = calcularLayout(grafo(nodes, unions, filhos));

    // Nenhum par de cards se sobrepõe.
    for (let i = 0; i < r.pessoas.length; i++) {
      for (let j = i + 1; j < r.pessoas.length; j++) {
        expect(
          sobrepoe(r.pessoas[i], r.pessoas[j]),
          `${r.pessoas[i].id} sobrepõe ${r.pessoas[j].id}`,
        ).toBe(false);
      }
    }
  });

  it('mantém ancestrais acima dos descendentes em três gerações', () => {
    const nodes = [
      pessoa('avô', 'M'),
      pessoa('avó', 'F'),
      pessoa('pai', 'M'),
      pessoa('mãe', 'F'),
      pessoa('neto', 'M'),
    ];
    const unions = [uniao('u1', 'avô', 'avó'), uniao('u2', 'pai', 'mãe')];
    const filhos: Array<[string, string]> = [
      ['u1', 'pai'],
      ['u2', 'neto'],
    ];

    const r = calcularLayout(grafo(nodes, unions, filhos));
    const g = (id: string) => r.pessoas.find((p) => p.id === id)!.geracao;

    expect(g('avô')).toBe(0);
    expect(g('avó')).toBe(0);
    expect(g('pai')).toBe(1);
    expect(g('neto')).toBe(2);
  });

  it('alinha os cônjuges na mesma geração mesmo quando um deles não tem pais', () => {
    // A mãe entra na família "de fora": não é filha de ninguém no acervo, e
    // mesmo assim tem de ficar na linha do marido.
    const r = calcularLayout(
      grafo(
        [pessoa('avô', 'M'), pessoa('avó', 'F'), pessoa('pai', 'M'), pessoa('mãe-de-fora', 'F')],
        [uniao('u1', 'avô', 'avó'), uniao('u2', 'pai', 'mãe-de-fora')],
        [['u1', 'pai']],
      ),
    );

    const pai = r.pessoas.find((p) => p.id === 'pai')!;
    const mae = r.pessoas.find((p) => p.id === 'mãe-de-fora')!;

    expect(mae.geracao).toBe(pai.geracao);
    expect(mae.y).toBe(pai.y);
  });

  it('desenha cada pessoa uma única vez', () => {
    const r = calcularLayout(
      grafo(
        [pessoa('a', 'M'), pessoa('b', 'F'), pessoa('c', 'M')],
        [uniao('u1', 'a', 'b')],
        [['u1', 'c']],
      ),
    );
    const ids = r.pessoas.map((p) => p.id);
    expect(new Set(ids).size).toBe(ids.length);
  });

  it('lida com segunda união sem duplicar a pessoa nem sobrepor os cônjuges', () => {
    const r = calcularLayout(
      grafo(
        [
          pessoa('homem', 'M'),
          pessoa('primeira', 'F'),
          pessoa('segunda', 'F'),
          pessoa('filho1', 'M', 1940),
          pessoa('filho2', 'F', 1955),
        ],
        [uniao('u1', 'homem', 'primeira'), uniao('u2', 'homem', 'segunda')],
        [
          ['u1', 'filho1'],
          ['u2', 'filho2'],
        ],
      ),
    );

    expect(r.pessoas.filter((p) => p.id === 'homem')).toHaveLength(1);
    expect(r.unioes).toHaveLength(2);

    const primeira = r.pessoas.find((p) => p.id === 'primeira')!;
    const segunda = r.pessoas.find((p) => p.id === 'segunda')!;
    expect(sobrepoe(primeira, segunda)).toBe(false);
  });

  it('posiciona segundo cônjuge sem filhos adjacente ao parceiro e sem anel flutuante distante', () => {
    // Cenário D. Pedro I: pais no topo, 1ª união com Leopoldina (4 filhos), 2ª união com Marquesa de Santos (sem filhos)
    const nodes = [
      pessoa('avo_m', 'M', 1767),
      pessoa('avo_f', 'F', 1775),
      pessoa('pai', 'M', 1798),
      pessoa('esposa1', 'F', 1797),
      pessoa('esposa2', 'F', 1797),
      pessoa('filho1', 'F', 1819),
      pessoa('filho2', 'F', 1822),
      pessoa('filho3', 'F', 1824),
      pessoa('filho4', 'M', 1825),
      pessoa('irmao', 'M', 1802),
    ];
    const unions = [
      uniao('u_pais', 'avo_m', 'avo_f'),
      uniao('u1', 'pai', 'esposa1'),
      uniao('u2', 'pai', 'esposa2'),
    ];
    const filhos: Array<[string, string]> = [
      ['u_pais', 'pai'],
      ['u_pais', 'irmao'],
      ['u1', 'filho1'],
      ['u1', 'filho2'],
      ['u1', 'filho3'],
      ['u1', 'filho4'],
    ];

    const r = calcularLayout(grafo(nodes, unions, filhos));

    const pai = r.pessoas.find((p) => p.id === 'pai')!;
    const esposa1 = r.pessoas.find((p) => p.id === 'esposa1')!;
    const esposa2 = r.pessoas.find((p) => p.id === 'esposa2')!;
    const anel2 = r.unioes.find((u) => u.id === 'u2')!;

    expect(esposa1).toBeDefined();
    // Esposa 2 fica adjacente ao pai (no lado livre), sem ser jogada para depois dos 4 filhos
    const distPaiEsposa2 = Math.abs(esposa2.x - pai.x);
    expect(distPaiEsposa2).toBeLessThanOrEqual(METRICAS.larguraNo * 2 + METRICAS.espacoCasal);

    // O anel da união 2 fica exatamente centralizado entre o pai e a esposa 2
    expect(anel2.x).toBeCloseTo((pai.x + esposa2.x) / 2, 1);

    // Ninguém se sobrepõe
    for (let i = 0; i < r.pessoas.length; i++) {
      for (let j = i + 1; j < r.pessoas.length; j++) {
        expect(sobrepoe(r.pessoas[i], r.pessoas[j])).toBe(false);
      }
    }
  });

  it('termina mesmo se o grafo chegar com um ciclo', () => {
    // Um import GEDCOM defeituoso pode trazer isto. O layout não é o lugar
    // de corrigir o dado, mas travar a interface não é opção.
    const nodes = [pessoa('a', 'M'), pessoa('b', 'F'), pessoa('c', 'M'), pessoa('d', 'F')];
    const unions = [uniao('u1', 'a', 'b'), uniao('u2', 'c', 'd')];
    const links: GraphLink[] = [];
    for (const u of unions) {
      links.push({ source: u.slot_masculino_id, target: u.id, tipo: 'pai_uniao' });
      links.push({ source: u.slot_feminino_id, target: u.id, tipo: 'mae_uniao' });
    }
    // c é filho de u1, e a é filho de u2 — laço fechado.
    links.push({ source: 'u1', target: 'c', tipo: 'uniao_filho' });
    links.push({ source: 'u2', target: 'a', tipo: 'uniao_filho' });

    const inicio = Date.now();
    const r = calcularLayout({ raiz_id: 'a', nodes, unions, links });
    expect(Date.now() - inicio).toBeLessThan(2000);
    expect(r.pessoas.length).toBeGreaterThan(0);
  });

  it('separa componentes desconectados sem empilhar um sobre o outro', () => {
    // Duas famílias sem ligação (seção 5: o banco é único, as árvores são
    // visões nomeadas).
    const r = calcularLayout(
      grafo(
        [pessoa('a1', 'M'), pessoa('a2', 'F'), pessoa('b1', 'M'), pessoa('b2', 'F')],
        [uniao('ua', 'a1', 'a2'), uniao('ub', 'b1', 'b2')],
      ),
    );

    for (let i = 0; i < r.pessoas.length; i++) {
      for (let j = i + 1; j < r.pessoas.length; j++) {
        expect(sobrepoe(r.pessoas[i], r.pessoas[j])).toBe(false);
      }
    }
  });

  it('produz o mesmo desenho para a mesma entrada', () => {
    const g = grafo(
      [pessoa('pai', 'M'), pessoa('mae', 'F'), pessoa('f1', 'M', 1940), pessoa('f2', 'F', 1942)],
      [uniao('u1', 'pai', 'mae')],
      [
        ['u1', 'f1'],
        ['u1', 'f2'],
      ],
    );

    const a = calcularLayout(g);
    const b = calcularLayout(g);
    expect(a.pessoas.map((p) => [p.id, p.x, p.y])).toEqual(
      b.pessoas.map((p) => [p.id, p.x, p.y]),
    );
  });

  it('gera uma aresta para cada ligação desenhável', () => {
    const r = calcularLayout(
      grafo(
        [pessoa('pai', 'M'), pessoa('mae', 'F'), pessoa('filho', 'M')],
        [uniao('u1', 'pai', 'mae')],
        [['u1', 'filho']],
      ),
    );

    // pai→união, mãe→união, união→filho
    expect(r.arestas).toHaveLength(3);
    expect(r.arestas.filter((a) => a.tipo === 'uniao_filho')).toHaveLength(1);
    expect(r.arestas.filter((a) => a.tipo === 'pai_uniao')).toHaveLength(1);
    expect(r.arestas.filter((a) => a.tipo === 'mae_uniao')).toHaveLength(1);
  });

  it('mantém tudo dentro dos limites informados', () => {
    const r = calcularLayout(
      grafo(
        [pessoa('pai', 'M'), pessoa('mae', 'F'), pessoa('f1', 'M'), pessoa('f2', 'F')],
        [uniao('u1', 'pai', 'mae')],
        [
          ['u1', 'f1'],
          ['u1', 'f2'],
        ],
      ),
    );

    for (const p of r.pessoas) {
      expect(p.x).toBeGreaterThanOrEqual(0);
      expect(p.y).toBeGreaterThanOrEqual(0);
      expect(p.x).toBeLessThanOrEqual(r.largura);
      expect(p.y).toBeLessThanOrEqual(r.altura);
    }
  });

  it('dá conta de uma árvore grande em tempo razoável', () => {
    // Seção 1: milhares de nós sem travar a interface.
    const nodes: PersonNode[] = [];
    const unions: UnionNode[] = [];
    const filhos: Array<[string, string]> = [];

    let contador = 0;
    const novo = (sexo: string, ano: number) => {
      const id = `p${contador++}`;
      nodes.push(pessoa(id, sexo, ano));
      return id;
    };

    // Sete gerações, cada casal com dois filhos: ~250 casais, ~500 pessoas.
    let geracaoAtual = [novo('M', 1800)];
    const conjuge0 = novo('F', 1802);
    unions.push(uniao('u0', geracaoAtual[0], conjuge0));
    let unionCount = 1;

    for (let g = 0; g < 7; g++) {
      const proxima: string[] = [];
      for (const pessoaId of geracaoAtual) {
        const uid = `u${unionCount++}`;
        const conjuge = novo('F', 1800 + g * 25);
        unions.push(uniao(uid, pessoaId, conjuge));
        for (let k = 0; k < 2; k++) {
          const filho = novo('M', 1825 + g * 25 + k);
          filhos.push([uid, filho]);
          proxima.push(filho);
        }
      }
      geracaoAtual = proxima;
    }

    const g = grafo(nodes, unions, filhos);
    const inicio = Date.now();
    const r = calcularLayout(g);
    const duracao = Date.now() - inicio;

    expect(nodes.length).toBeGreaterThan(350);
    expect(r.pessoas.length).toBe(nodes.length);
    expect(duracao).toBeLessThan(1500);
  });
});

describe('caminhoOrtogonal', () => {
  it('desce reto quando origem e destino estão na mesma coluna', () => {
    const d = caminhoOrtogonal({ x: 100, y: 0 }, { x: 100, y: 200 });
    expect(d).toBe('M 100 0 L 100 200');
  });

  it('quebra no meio vertical do vão, para os irmãos formarem um pente', () => {
    const d = caminhoOrtogonal({ x: 100, y: 0 }, { x: 300, y: 200 });
    expect(d).toContain('L 100 100');
    expect(d).toContain('L 300 100');
    expect(d.endsWith('L 300 200')).toBe(true);
  });

  it('em saltos de 2 ou mais gerações, a canaleta passa no vão livre sem cortar cartões', () => {
    const d = caminhoOrtogonal({ x: 100, y: 0 }, { x: 300, y: 392 });
    expect(d).toContain('L 100 98');
    expect(d).toContain('L 300 98');
    expect(d.endsWith('L 300 392')).toBe(true);
  });

  it('garante que pais ficam sempre acima dos filhos (Y menor)', () => {
    const pPai = pessoa('pai', 'M', 1900);
    const pMae = pessoa('mae', 'F', 1905);
    const pFilho = pessoa('filho', 'M', 1930);
    const pNeto = pessoa('neto', 'M', 1960);

    const uPais = uniao('u1', 'pai', 'mae');
    const uFilho = uniao('u2', 'filho', 'filho');

    const g = grafo(
      [pPai, pMae, pFilho, pNeto],
      [uPais, uFilho],
      [
        ['u1', 'filho'],
        ['u2', 'neto'],
      ],
    );

    const layout = calcularLayout(g);
    const mapa = new Map(layout.pessoas.map((p) => [p.id, p]));

    expect(mapa.get('pai')!.y).toBeLessThan(mapa.get('filho')!.y);
    expect(mapa.get('mae')!.y).toBeLessThan(mapa.get('filho')!.y);
    expect(mapa.get('filho')!.y).toBeLessThan(mapa.get('neto')!.y);
  });

  it('cadeia monoparental profunda (estilo Adão) mantém largura contida e alinhamento sem explosão exponencial', () => {
    // 10 gerações em linha reta monoparental
    const nodes: PersonNode[] = [];
    const unions: UnionNode[] = [];
    const links: Array<[string, string]> = [];

    for (let i = 0; i < 10; i++) {
      nodes.push(pessoa(`p${i}`, 'M', 2000 - i * 30));
      if (i < 9) {
        unions.push(uniao(`u${i}`, `p${i}`, `p${i}`));
        links.push([`u${i}`, `p${i + 1}`]);
      }
    }

    const g = grafo(nodes, unions, links);
    const layout = calcularLayout(g);

    // A largura total NÃO deve explodir para 900.000px, deve ser próxima de um card + margens
    expect(layout.largura).toBeLessThan(600);

    // Todos os nós em linha reta devem estar alinhados no mesmo X
    const primeiroX = layout.pessoas[0].x;
    for (const p of layout.pessoas) {
      expect(Math.abs(p.x - primeiroX)).toBeLessThan(1);
    }
  });

  it('resolução de colisões afasta cards garantindo zero sobreposição', () => {
    const p1 = pessoa('p1', 'M');
    const p2 = pessoa('p2', 'M');
    // Duas pessoas sem parentesco que caem na mesma geração
    const g = grafo([p1, p2], []);
    const layout = calcularLayout(g);

    const pos1 = layout.pessoas.find((p) => p.id === 'p1')!;
    const pos2 = layout.pessoas.find((p) => p.id === 'p2')!;

    expect(sobrepoe(pos1, pos2)).toBe(false);
    expect(Math.abs(pos1.x - pos2.x)).toBeGreaterThanOrEqual(METRICAS.larguraNo + METRICAS.espacoIrmaos);
  });

  it('consolida uniões duplicadas para o mesmo casal reunindo os filhos sob a mesma união', () => {
    const pai = pessoa('pai', 'M');
    const mae = pessoa('mae', 'F');
    const f1 = pessoa('filho1', 'M');
    const f2 = pessoa('filho2', 'M');

    // Duas uniões distintas entre o mesmo casal, cada uma com um filho (como em sementes com duplicidade)
    const u1 = uniao('u1', 'pai', 'mae');
    const u2 = uniao('u2', 'pai', 'mae');

    const g: TreeGraph = {
      raiz_id: 'pai',
      nodes: [pai, mae, f1, f2],
      unions: [u1, u2],
      links: [
        { source: 'pai', target: 'u1', tipo: 'pai_uniao' },
        { source: 'mae', target: 'u1', tipo: 'mae_uniao' },
        { source: 'pai', target: 'u2', tipo: 'pai_uniao' },
        { source: 'mae', target: 'u2', tipo: 'mae_uniao' },
        { source: 'u1', target: 'filho1', tipo: 'uniao_filho' },
        { source: 'u2', target: 'filho2', tipo: 'uniao_filho' },
      ],
    };

    const layout = calcularLayout(g);

    // Deve ter apenas 1 anel de união desenhado
    expect(layout.unioes).toHaveLength(1);
    // Os dois filhos devem estar lado a lado na mesma geração sem sobreposição
    const pF1 = layout.pessoas.find((p) => p.id === 'filho1')!;
    const pF2 = layout.pessoas.find((p) => p.id === 'filho2')!;
    expect(pF1.y).toBe(pF2.y);
    expect(sobrepoe(pF1, pF2)).toBe(false);
  });

  it('posiciona raízes secundárias centralizadas acima de filhos já alocados por casamento colateral', () => {
    // Cenário tipo Darwin:
    // Raiz 1: AvoMaterno + AvoMaterna -> Mae
    // Raiz 2: AvoPaterno -> Pai
    // Pai + Mae -> Filho
    const avoM = pessoa('avoM', 'M');
    const avoF = pessoa('avoF', 'F');
    const mae = pessoa('mae', 'F');
    const avoPaterno = pessoa('avoPaterno', 'M');
    const pai = pessoa('pai', 'M');
    const neto = pessoa('neto', 'M');

    const uMat = uniao('uMat', 'avoM', 'avoF');
    const uPat = uniao('uPat', 'avoPaterno', 'avoPaterno'); // monoparental ou com placeholder
    const uCasal = uniao('uCasal', 'pai', 'mae');

    const g: TreeGraph = {
      raiz_id: 'avoM',
      nodes: [avoM, avoF, mae, avoPaterno, pai, neto],
      unions: [uMat, uPat, uCasal],
      links: [
        { source: 'avoM', target: 'uMat', tipo: 'pai_uniao' },
        { source: 'avoF', target: 'uMat', tipo: 'mae_uniao' },
        { source: 'uMat', target: 'mae', tipo: 'uniao_filho' },
        { source: 'avoPaterno', target: 'uPat', tipo: 'pai_uniao' },
        { source: 'uPat', target: 'pai', tipo: 'uniao_filho' },
        { source: 'pai', target: 'uCasal', tipo: 'pai_uniao' },
        { source: 'mae', target: 'uCasal', tipo: 'mae_uniao' },
        { source: 'uCasal', target: 'neto', tipo: 'uniao_filho' },
      ],
    };

    const layout = calcularLayout(g);
    const pAvoPaterno = layout.pessoas.find((p) => p.id === 'avoPaterno')!;
    const pPai = layout.pessoas.find((p) => p.id === 'pai')!;

    // O avô paterno não deve ser jogado milhares de pixels para o lado:
    // a distância horizontal para o pai deve ser moderada e não um abismo de milhares de pixels
    expect(Math.abs(pAvoPaterno.x - pPai.x)).toBeLessThan(500);
  });

  it('compacta irmão sem filhos próximo ao irmão com grande descendência (caso Silva Prado)', () => {
    // Pai + Mãe têm 2 filhos:
    // - Irmão 1 (Martinho, 1811 + Veridiana) tem 4 filhos na geração 2
    // - Irmão 2 (Caio, 1815) não tem filhos (ocupa apenas geração 1)
    const pai = pessoa('antonio', 'M', 1780);
    const mae = pessoa('maria', 'F', 1785);
    const martinho = pessoa('martinho', 'M', 1811);
    const veridiana = pessoa('veridiana', 'F', 1825);
    const caio = pessoa('caio', 'M', 1815);
    const n1 = pessoa('n1', 'M', 1840);
    const n2 = pessoa('n2', 'M', 1842);
    const n3 = pessoa('n3', 'M', 1844);
    const n4 = pessoa('n4', 'F', 1846);

    const uPais = uniao('uPais', 'antonio', 'maria');
    const uMartinho = uniao('uMartinho', 'martinho', 'veridiana');

    const g = grafo(
      [pai, mae, martinho, veridiana, caio, n1, n2, n3, n4],
      [uPais, uMartinho],
      [
        ['uPais', 'martinho'],
        ['uPais', 'caio'],
        ['uMartinho', 'n1'],
        ['uMartinho', 'n2'],
        ['uMartinho', 'n3'],
        ['uMartinho', 'n4'],
      ],
    );
    const layout = calcularLayout(g);

    const pVeridiana = layout.pessoas.find((p) => p.id === 'veridiana')!;
    const pCaio = layout.pessoas.find((p) => p.id === 'caio')!;

    // Caio deve ficar imediatamente ao lado de Veridiana na geração 1 (separados por espacoIrmaos),
    // e não empurrado para além da borda direita dos 4 sobrinhos na geração 2.
    const distanciaBorda = pCaio.x - (pVeridiana.x + METRICAS.larguraNo);
    expect(distanciaBorda).toBeCloseTo(METRICAS.espacoIrmaos, 0);
  });

  it('protege contra ciclos genealógicos em grafos importados sem espiral vertical', () => {
    const a = pessoa('a', 'M');
    const b = pessoa('b', 'F');
    const c = pessoa('c', 'M');
    // a + b -> c, mas c tem união com b (ciclo cônjuge-mãe)
    const u1 = uniao('u1', 'a', 'b');
    const u2 = uniao('u2', 'c', 'b');

    const g = grafo([a, b, c], [u1, u2], [['u1', 'c']]);
    const layout = calcularLayout(g);

    expect(layout.pessoas).toHaveLength(3);
    // Diferença máxima de Y não deve ultrapassar 2 gerações
    const ys = layout.pessoas.map((p) => p.y);
    const spanVertical = Math.max(...ys) - Math.min(...ys);
    expect(spanVertical).toBeLessThanOrEqual(2 * (METRICAS.alturaNo + METRICAS.alturaGeracao));
  });
});




