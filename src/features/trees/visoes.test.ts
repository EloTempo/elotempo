import { describe, it, expect } from 'vitest';
import {
  rotuloParentescoAhnentafel,
  montarAhnentafel,
} from './components/ModalAhnentafel';
import { calcularLayout } from '../../lib/tree/layout';
import type { TreeGraph } from '../../types';

describe('Fatia 13: Visões Auxiliares e Navegação', () => {
  describe('Ahnentafel (Sosa-Stradonitz)', () => {
    it('calcula os rótulos de parentesco canônicos pela numeração matemática', () => {
      expect(rotuloParentescoAhnentafel(1)).toBe('Pessoa Foco (Raiz)');
      expect(rotuloParentescoAhnentafel(2)).toBe('Pai');
      expect(rotuloParentescoAhnentafel(3)).toBe('Mãe');
      expect(rotuloParentescoAhnentafel(4)).toBe('Avô Paterno');
      expect(rotuloParentescoAhnentafel(5)).toBe('Avó Paterna');
      expect(rotuloParentescoAhnentafel(6)).toBe('Avô Materno');
      expect(rotuloParentescoAhnentafel(7)).toBe('Avó Materna');
      expect(rotuloParentescoAhnentafel(8)).toBe('Bisavô');
      expect(rotuloParentescoAhnentafel(9)).toBe('Bisavó');
    });

    it('monta a lista de ancestrais a partir de grafo', () => {
      const mockGrafo: TreeGraph = {
        raiz_id: 'p1',
        nodes: [
          {
            id: 'p1',
            nome: 'João',
            sobrenome: 'Silva',
            sexo: 'M',
            is_vivo: true,
            is_placeholder: false,
            ano_nascimento: 1990,
            ano_falecimento: null,
            tem_foto: false,
            tem_biografia: false,
            tem_documentos: false,
            tem_religiao: false,
          },
          {
            id: 'p2',
            nome: 'Carlos',
            sobrenome: 'Silva',
            sexo: 'M',
            is_vivo: false,
            is_placeholder: false,
            ano_nascimento: 1960,
            ano_falecimento: 2020,
            tem_foto: false,
            tem_biografia: false,
            tem_documentos: false,
            tem_religiao: false,
          },
          {
            id: 'p3',
            nome: 'Ana',
            sobrenome: 'Souza',
            sexo: 'F',
            is_vivo: true,
            is_placeholder: false,
            ano_nascimento: 1965,
            ano_falecimento: null,
            tem_foto: false,
            tem_biografia: false,
            tem_documentos: false,
            tem_religiao: false,
          },
        ],
        unions: [
          {
            id: 'u1',
            estado_vinculo: 'casamento',
            ano_casamento: 1988,
            slot_masculino_id: 'p2',
            slot_feminino_id: 'p3',
          },
        ],
        links: [
          { source: 'u1', target: 'p1', tipo: 'uniao_filho' },
        ],
      };

      const ahnentafel = montarAhnentafel(mockGrafo, 'p1');
      expect(ahnentafel).toHaveLength(3);

      expect(ahnentafel[0].numero).toBe(1);
      expect(ahnentafel[0].pessoa.nome).toBe('João');
      expect(ahnentafel[0].geracao).toBe(1);

      expect(ahnentafel[1].numero).toBe(2);
      expect(ahnentafel[1].pessoa.nome).toBe('Carlos');
      expect(ahnentafel[1].grauParentesco).toBe('Pai');
      expect(ahnentafel[1].geracao).toBe(2);

      expect(ahnentafel[2].numero).toBe(3);
      expect(ahnentafel[2].pessoa.nome).toBe('Ana');
      expect(ahnentafel[2].grauParentesco).toBe('Mãe');
      expect(ahnentafel[2].geracao).toBe(2);
    });
  });

  describe('Colapso de Ramos no Layout da Árvore', () => {
    const mockFamilia: TreeGraph = {
      raiz_id: 'pai',
      nodes: [
        {
          id: 'pai',
          nome: 'Pai',
          sexo: 'M',
          is_vivo: true,
          is_placeholder: false,
          tem_foto: false,
          tem_biografia: false,
          tem_documentos: false,
          tem_religiao: false,
        },
        {
          id: 'mae',
          nome: 'Mãe',
          sexo: 'F',
          is_vivo: true,
          is_placeholder: false,
          tem_foto: false,
          tem_biografia: false,
          tem_documentos: false,
          tem_religiao: false,
        },
        {
          id: 'filho1',
          nome: 'Filho 1',
          sexo: 'M',
          is_vivo: true,
          is_placeholder: false,
          tem_foto: false,
          tem_biografia: false,
          tem_documentos: false,
          tem_religiao: false,
        },
        {
          id: 'filho2',
          nome: 'Filho 2',
          sexo: 'F',
          is_vivo: true,
          is_placeholder: false,
          tem_foto: false,
          tem_biografia: false,
          tem_documentos: false,
          tem_religiao: false,
        },
      ],
      unions: [
        {
          id: 'uniao_pais',
          estado_vinculo: 'casamento',
          slot_masculino_id: 'pai',
          slot_feminino_id: 'mae',
        },
      ],
      links: [
        { source: 'uniao_pais', target: 'filho1', tipo: 'uniao_filho' },
        { source: 'uniao_pais', target: 'filho2', tipo: 'uniao_filho' },
      ],
    };

    it('renderiza todos os membros quando a união não está colapsada', () => {
      const layout = calcularLayout(mockFamilia);
      expect(layout.pessoas).toHaveLength(4);
      expect(layout.unioes[0].colapsada).toBe(false);
      expect(layout.unioes[0].filhosTotal).toBe(2);
    });

    it('omite os filhos e compacta quando a união está colapsada', () => {
      const colapsadas = new Set(['uniao_pais']);
      const layout = calcularLayout(mockFamilia, colapsadas);

      // Apenas os pais devem estar no desenho
      expect(layout.pessoas).toHaveLength(2);
      expect(new Set(layout.pessoas.map((p) => p.id))).toEqual(new Set(['pai', 'mae']));

      // A união deve reportar que está colapsada e que tem 2 filhos ocultos
      expect(layout.unioes[0].colapsada).toBe(true);
      expect(layout.unioes[0].filhosTotal).toBe(2);
    });
  });
});
