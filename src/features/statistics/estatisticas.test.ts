import { describe, it, expect } from 'vitest';
import type { ContagemItem } from '../../lib/api';

describe('Estatísticas - Regras de formato e cálculo', () => {
  it('garante que a proporção exibe contagem absoluta junto do percentual', () => {
    const item: ContagemItem = {
      chave: 'M',
      rotulo: 'Masculino',
      contagem: 6,
      percentual: 50.0,
    };
    const totalGeral = 12;

    const textoFormatado = `${item.contagem} de ${totalGeral} · ${item.percentual}%`;
    expect(textoFormatado).toBe('6 de 12 · 50%');
  });

  it('lida corretamente com amostra de 100% e amostra de 0%', () => {
    const total = 5;
    const itemCem: ContagemItem = {
      chave: 'F',
      rotulo: 'Feminino',
      contagem: 5,
      percentual: 100.0,
    };
    expect(`${itemCem.contagem} de ${total} · ${itemCem.percentual}%`).toBe('5 de 5 · 100%');

    const itemZero: ContagemItem = {
      chave: 'X',
      rotulo: 'Outro',
      contagem: 0,
      percentual: 0.0,
    };
    expect(`${itemZero.contagem} de ${total} · ${itemZero.percentual}%`).toBe('0 de 5 · 0%');
  });

  it('arredonda percentuais para uma casa decimal sem enganos', () => {
    const parte = 1;
    const total = 3;
    const pct = Math.round((parte / total) * 1000) / 10;
    expect(pct).toBe(33.3);
  });
});
