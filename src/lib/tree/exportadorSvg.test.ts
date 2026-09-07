import { describe, it, expect } from 'vitest';
import { calcularLayout } from './layout';
import { gerarSvgArvore } from './exportadorSvg';
import type { TreeGraph, PersonNode, UnionNode } from '../../types';

function mockPessoa(id: string, nome: string, sobrenome: string, sexo: string, nasc?: number, falec?: number): PersonNode {
  return {
    id,
    nome,
    sobrenome,
    sexo,
    is_vivo: falec == null,
    is_placeholder: false,
    ano_nascimento: nasc ?? null,
    ano_falecimento: falec ?? null,
    tem_foto: false,
    tem_biografia: false,
    tem_documentos: false,
    tem_religiao: false,
  };
}

function mockUniao(id: string, m: string, f: string, anoCasamento?: number): UnionNode {
  return {
    id,
    estado_vinculo: 'casamento',
    ano_casamento: anoCasamento ?? null,
    slot_masculino_id: m,
    slot_feminino_id: f,
  };
}

describe('Gerador de SVG Standalone (exportadorSvg)', () => {
  it('gera documento SVG válido contendo pessoas, linhas e cabeçalho', () => {
    const pai = mockPessoa('pai', 'Pedro', 'de Alcântara', 'M', 1825, 1891);
    const mae = mockPessoa('mae', 'Teresa', 'Cristina', 'F', 1822, 1889);
    const filha = mockPessoa('filha', 'Isabel', 'de Bragança', 'F', 1846, 1921);
    const u = mockUniao('u1', 'pai', 'mae', 1843);

    const grafo: TreeGraph = {
      raiz_id: 'filha',
      nodes: [pai, mae, filha],
      unions: [u],
      links: [
        { source: 'pai', target: 'u1', tipo: 'pai_uniao' },
        { source: 'mae', target: 'u1', tipo: 'mae_uniao' },
        { source: 'u1', target: 'filha', tipo: 'uniao_filho' },
      ],
    };

    const layout = calcularLayout(grafo);
    const svg = gerarSvgArvore(layout, {
      titulo: 'Família Imperial do Brasil',
      subtitulo: 'Linhagem de Dom Pedro II',
      tema: 'pergaminho',
      incluirDatas: true,
      incluirCasamentos: true,
      incluirMoldura: true,
    });

    expect(svg).toContain('<?xml version="1.0" encoding="UTF-8"?>');
    expect(svg).toContain('<svg xmlns="http://www.w3.org/2000/svg"');
    expect(svg).toContain('Família Imperial do Brasil');
    expect(svg).toContain('Linhagem de Dom Pedro II');
    expect(svg).toContain('Pedro de Alcântara');
    expect(svg).toContain('Teresa Cristina');
    expect(svg).toContain('Isabel de Bragança');
    expect(svg).toContain('* 1825  ✝ 1891');
    expect(svg).toContain('⚭ 1843');
    expect(svg).toContain('#f5efe3'); // Fundo do pergaminho
  });

  it('suporta tema branco e escuro', () => {
    const p = mockPessoa('p1', 'Elizabeth', 'Windsor', 'F', 1926, 2022);
    const layout = calcularLayout({ raiz_id: 'p1', nodes: [p], unions: [], links: [] });

    const svgBranco = gerarSvgArvore(layout, {
      titulo: 'Casa de Windsor',
      tema: 'branco',
    });
    expect(svgBranco).toContain('#ffffff');

    const svgEscuro = gerarSvgArvore(layout, {
      titulo: 'Casa de Windsor',
      tema: 'escuro',
    });
    expect(svgEscuro).toContain('#181512');
  });
});
