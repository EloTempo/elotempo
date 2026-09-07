import { describe, it, expect } from 'vitest';
import type { ArvoreInfo } from '../../lib/api';

describe('Múltiplas Árvores Nomeadas - Regras e Modelos', () => {
  it('identifica corretamente a árvore ativa e seus metadados', () => {
    const arvores: ArvoreInfo[] = [
      {
        id: 'arv-1',
        nome: 'Árvore Principal',
        descricao: 'Visão geral da família',
        raiz_pessoa_id: 'p-1',
        raiz_pessoa_nome: 'Joaquim Silva',
        total_membros: 12,
        data_criacao: '2026-09-01 10:00:00',
        data_modificacao: '2026-09-01 10:00:00',
      },
      {
        id: 'arv-2',
        nome: 'Ramo Materno',
        descricao: 'Família Albuquerque',
        raiz_pessoa_id: 'p-5',
        raiz_pessoa_nome: 'Maria Albuquerque',
        total_membros: 8,
        data_criacao: '2026-09-02 11:00:00',
        data_modificacao: '2026-09-02 11:00:00',
      },
    ];

    const ativaId = 'arv-2';
    const arvoreAtiva = arvores.find((a) => a.id === ativaId) ?? arvores[0];

    expect(arvoreAtiva.nome).toBe('Ramo Materno');
    expect(arvoreAtiva.raiz_pessoa_nome).toBe('Maria Albuquerque');
  });

  it('faz fallback para a primeira árvore se o ID ativo for inválido', () => {
    const arvores: ArvoreInfo[] = [
      {
        id: 'arv-1',
        nome: 'Árvore Principal',
        descricao: null,
        raiz_pessoa_id: null,
        raiz_pessoa_nome: null,
        total_membros: 0,
        data_criacao: null,
        data_modificacao: null,
      },
    ];

    const arvoreAtiva = arvores.find((a) => a.id === 'inexistente') ?? arvores[0];
    expect(arvoreAtiva.nome).toBe('Árvore Principal');
  });
});
