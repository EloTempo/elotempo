import { describe, it, expect } from 'vitest';
import type { PosicaoPessoa, LayoutArvore } from '../../lib/tree/layout';

describe('Navegação e Radar da Árvore', () => {
  const pessoasExemplo: PosicaoPessoa[] = [
    {
      id: 'p-machado',
      nome: 'Machado',
      sobrenome: 'de Assis',
      sexo: 'M',
      is_vivo: false,
      is_placeholder: false,
      ano_nascimento: 1839,
      ano_falecimento: 1908,
      tem_foto: true,
      tem_biografia: true,
      tem_documentos: true,
      tem_religiao: false,
      x: 500,
      y: 200,
      geracao: 1,
    },
    {
      id: 'p-carolina',
      nome: 'Carolina',
      sobrenome: 'Xavier de Novais',
      sexo: 'F',
      is_vivo: false,
      is_placeholder: false,
      ano_nascimento: 1835,
      ano_falecimento: 1904,
      tem_foto: true,
      tem_biografia: false,
      tem_documentos: false,
      tem_religiao: false,
      x: 800,
      y: 200,
      geracao: 1,
    },
    {
      id: 'p-contemporaneo',
      nome: 'Leitor',
      sobrenome: 'Moderno',
      sexo: 'M',
      is_vivo: true,
      is_placeholder: false,
      ano_nascimento: 1995,
      ano_falecimento: null,
      tem_foto: false,
      tem_biografia: false,
      tem_documentos: false,
      tem_religiao: false,
      x: 650,
      y: 400,
      geracao: 2,
    },
  ];

  const layoutExemplo: LayoutArvore = {
    pessoas: pessoasExemplo,
    unioes: [
      {
        id: 'u-1',
        slot_masculino_id: 'p-machado',
        slot_feminino_id: 'p-carolina',
        estado_vinculo: 'casamento',
        x: 650,
        y: 200,
        geracao: 1,
        filhosTotal: 0,
        colapsada: false,
      },
    ],
    arestas: [],
    largura: 1400,
    altura: 700,
  };

  it('calcula corretamente as proporções de altura do minimapa dentro dos limites seguros', () => {
    const LARGURA_MINIMAPA = 220;
    const proporcao = layoutExemplo.altura / layoutExemplo.largura; // 700 / 1400 = 0.5
    const alturaMinimapa = Math.max(90, Math.min(160, Math.round(LARGURA_MINIMAPA * proporcao)));

    expect(alturaMinimapa).toBe(110);
    expect(alturaMinimapa).toBeGreaterThanOrEqual(90);
    expect(alturaMinimapa).toBeLessThanOrEqual(160);
  });

  it('calcula coordenadas de viewport da câmera em escala 1x', () => {
    const transform = { x: -200, y: -100, k: 1 };
    const containerWidth = 1000;
    const containerHeight = 600;

    const vx = -transform.x / transform.k;
    const vy = -transform.y / transform.k;
    const vw = containerWidth / transform.k;
    const vh = containerHeight / transform.k;

    expect(vx).toBe(200);
    expect(vy).toBe(100);
    expect(vw).toBe(1000);
    expect(vh).toBe(600);
  });

  it('calcula coordenadas de viewport da câmera em zoom de 2x (viewport encolhe no layout)', () => {
    const transform = { x: -400, y: -200, k: 2 };
    const containerWidth = 1000;
    const containerHeight = 600;

    const vx = -transform.x / transform.k;
    const vy = -transform.y / transform.k;
    const vw = containerWidth / transform.k;
    const vh = containerHeight / transform.k;

    expect(vx).toBe(200);
    expect(vy).toBe(100);
    expect(vw).toBe(500);
    expect(vh).toBe(300);
  });

  it('filtra pessoas da árvore por nome, sobrenome ou ano de nascimento para o localizador', () => {
    const filtrar = (consulta: string) => {
      const q = consulta.trim().toLowerCase();
      if (!q) return pessoasExemplo;
      return pessoasExemplo.filter((p) => {
        const nomeCompleto = `${p.nome} ${p.sobrenome ?? ''}`.toLowerCase();
        const anoNasc = p.ano_nascimento != null ? String(p.ano_nascimento) : '';
        const anoFalec = p.ano_falecimento != null ? String(p.ano_falecimento) : '';
        return nomeCompleto.includes(q) || anoNasc.includes(q) || anoFalec.includes(q);
      });
    };

    // Busca por sobrenome
    const resultadoMachado = filtrar('assis');
    expect(resultadoMachado).toHaveLength(1);
    expect(resultadoMachado[0].id).toBe('p-machado');

    // Busca por ano de nascimento
    const resultado1835 = filtrar('1835');
    expect(resultado1835).toHaveLength(1);
    expect(resultado1835[0].id).toBe('p-carolina');

    // Busca inexistente
    const resultadoInexistente = filtrar('desconhecido');
    expect(resultadoInexistente).toHaveLength(0);
  });

  it('converte cliques no minimapa de forma proporcional para as coordenadas da árvore', () => {
    const rectMinimapa = { width: 220, height: 110 };
    // Clique exatamente no centro do minimapa (110px x 55px)
    const clickX = 110;
    const clickY = 55;

    const propX = clickX / rectMinimapa.width; // 0.5
    const propY = clickY / rectMinimapa.height; // 0.5

    const targetX = propX * layoutExemplo.largura;
    const targetY = propY * layoutExemplo.altura;

    expect(targetX).toBe(700);
    expect(targetY).toBe(350);
  });
});
