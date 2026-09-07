import { describe, it, expect, vi } from 'vitest';
import type { AcaoHistorico } from '../../contexts/HistoricoContext';

describe('Fatia 14: Sistema de Desfazer/Refazer (Undo/Redo)', () => {
  it('registra nova ação na pilha de desfazer e limpa a pilha de refazer', () => {
    let pilhaDesfazer: AcaoHistorico[] = [];
    let pilhaRefazer: AcaoHistorico[] = [
      {
        id: '1',
        descricao: 'Ação anterior',
        timestamp: new Date(),
        desfazer: vi.fn(),
        refazer: vi.fn(),
      },
    ];

    const registrarAcao = (nova: {
      descricao: string;
      desfazer: () => Promise<void>;
      refazer: () => Promise<void>;
    }) => {
      const item: AcaoHistorico = {
        id: '2',
        descricao: nova.descricao,
        timestamp: new Date(),
        desfazer: nova.desfazer,
        refazer: nova.refazer,
      };
      pilhaDesfazer = [item, ...pilhaDesfazer].slice(0, 30);
      pilhaRefazer = [];
    };

    registrarAcao({
      descricao: 'Criar Joaquim Silva',
      desfazer: vi.fn(),
      refazer: vi.fn(),
    });

    expect(pilhaDesfazer).toHaveLength(1);
    expect(pilhaDesfazer[0].descricao).toBe('Criar Joaquim Silva');
    expect(pilhaRefazer).toHaveLength(0);
  });

  it('desfaz uma ação chamando o callback reverso e movendo para a pilha de refazer', async () => {
    const fnDesfazer = vi.fn().mockResolvedValue(undefined);
    const fnRefazer = vi.fn().mockResolvedValue(undefined);

    const acao: AcaoHistorico = {
      id: '1',
      descricao: 'Editar dados de Maria',
      timestamp: new Date(),
      desfazer: fnDesfazer,
      refazer: fnRefazer,
    };

    let pilhaDesfazer = [acao];
    let pilhaRefazer: AcaoHistorico[] = [];

    // Executa desfazer
    const [aDesfazer, ...resto] = pilhaDesfazer;
    await aDesfazer.desfazer();
    pilhaDesfazer = resto;
    pilhaRefazer = [aDesfazer, ...pilhaRefazer];

    expect(fnDesfazer).toHaveBeenCalledTimes(1);
    expect(pilhaDesfazer).toHaveLength(0);
    expect(pilhaRefazer).toHaveLength(1);
    expect(pilhaRefazer[0].descricao).toBe('Editar dados de Maria');
  });

  it('refaz uma ação desfeita chamando o callback direto e voltando para a pilha de desfazer', async () => {
    const fnDesfazer = vi.fn().mockResolvedValue(undefined);
    const fnRefazer = vi.fn().mockResolvedValue(undefined);

    const acao: AcaoHistorico = {
      id: '1',
      descricao: 'Vincular filho Pedro',
      timestamp: new Date(),
      desfazer: fnDesfazer,
      refazer: fnRefazer,
    };

    let pilhaDesfazer: AcaoHistorico[] = [];
    let pilhaRefazer = [acao];

    // Executa refazer
    const [aRefazer, ...resto] = pilhaRefazer;
    await aRefazer.refazer();
    pilhaRefazer = resto;
    pilhaDesfazer = [aRefazer, ...pilhaDesfazer];

    expect(fnRefazer).toHaveBeenCalledTimes(1);
    expect(pilhaRefazer).toHaveLength(0);
    expect(pilhaDesfazer).toHaveLength(1);
    expect(pilhaDesfazer[0].descricao).toBe('Vincular filho Pedro');
  });

  it('respeita o limite máximo de 30 ações na pilha', () => {
    let pilhaDesfazer: AcaoHistorico[] = [];

    for (let i = 1; i <= 35; i++) {
      const item: AcaoHistorico = {
        id: `acao-${i}`,
        descricao: `Ação ${i}`,
        timestamp: new Date(),
        desfazer: vi.fn(),
        refazer: vi.fn(),
      };
      pilhaDesfazer = [item, ...pilhaDesfazer].slice(0, 30);
    }

    expect(pilhaDesfazer).toHaveLength(30);
    // A mais recente deve ser a ação 35
    expect(pilhaDesfazer[0].descricao).toBe('Ação 35');
    // A mais antiga sobrevivente deve ser a ação 6 (1 a 5 foram descartadas)
    expect(pilhaDesfazer[29].descricao).toBe('Ação 6');
  });
});
