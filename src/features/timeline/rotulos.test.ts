import { describe, it, expect } from 'vitest';
import { marcosComRotulo } from './components/GavetaLinhaTempo';
import type { Marco } from '../../lib/api';

/**
 * A regra que faltava na primeira versão da gaveta: quarenta marcos de
 * história do Brasil espremidos num eixo de mil pixels viravam um borrão
 * ilegível de rótulos sobrepostos. Aqui só se rotula quem tem espaço.
 */

function marco(id: string, ano: number): Marco {
  return {
    id,
    linha_id: 'lt-brasil',
    data_periodo_texto: String(ano),
    titulo: `Marco ${id}`,
    ano_inicio: ano,
    ano_fim: ano,
  };
}

/** Escala de 1 pixel por ano — facilita raciocinar sobre as distâncias. */
const umPixelPorAno = (ano: number) => ano - 1500;

describe('marcosComRotulo', () => {
  it('rotula marcos bem separados', () => {
    const marcos = [marco('a', 1500), marco('b', 1700), marco('c', 1900)];
    const r = marcosComRotulo(marcos, umPixelPorAno);
    expect(r.size).toBe(3);
  });

  it('suprime o rótulo de quem cai perto demais do anterior', () => {
    // 96 px é o espaço reservado por rótulo; 1500 e 1510 distam 10 px.
    const marcos = [marco('a', 1500), marco('b', 1510), marco('c', 1520)];
    const r = marcosComRotulo(marcos, umPixelPorAno);
    expect(r.has('a')).toBe(true);
    expect(r.has('b')).toBe(false);
    expect(r.has('c')).toBe(false);
  });

  it('volta a rotular assim que há espaço de novo', () => {
    const marcos = [marco('a', 1500), marco('b', 1510), marco('c', 1700)];
    const r = marcosComRotulo(marcos, umPixelPorAno);
    expect([...r].sort()).toEqual(['a', 'c']);
  });

  it('não depende da ordem em que os marcos chegam', () => {
    const embaralhado = [marco('c', 1700), marco('a', 1500), marco('b', 1510)];
    const r = marcosComRotulo(embaralhado, umPixelPorAno);
    expect([...r].sort()).toEqual(['a', 'c']);
  });

  it('sempre rotula ao menos o primeiro, por mais apertado que esteja', () => {
    // Nunca devolver conjunto vazio: uma faixa sem nenhum rótulo não diz nada.
    const marcos = Array.from({ length: 40 }, (_, i) => marco(`m${i}`, 1500 + i));
    const r = marcosComRotulo(marcos, umPixelPorAno);
    expect(r.size).toBeGreaterThanOrEqual(1);
    expect(r.has('m0')).toBe(true);
  });

  it('rotula mais quando se aproxima o zoom', () => {
    const marcos = [marco('a', 1500), marco('b', 1520), marco('c', 1540)];

    const afastado = marcosComRotulo(marcos, (ano: number) => (ano - 1500) * 1);
    const aproximado = marcosComRotulo(marcos, (ano: number) => (ano - 1500) * 10);

    expect(aproximado.size).toBeGreaterThan(afastado.size);
    expect(aproximado.size).toBe(3);
  });

  it('ignora marcos sem ano em vez de quebrar', () => {
    const semAno: Marco = {
      id: 'x',
      linha_id: 'lt-brasil',
      data_periodo_texto: 'sem data',
      titulo: 'Sem ano',
      ano_inicio: null,
      ano_fim: null,
    };
    const r = marcosComRotulo([semAno, marco('a', 1500)], umPixelPorAno);
    expect(r.has('x')).toBe(false);
    expect(r.has('a')).toBe(true);
  });

  it('aguenta lista vazia', () => {
    expect(marcosComRotulo([], umPixelPorAno).size).toBe(0);
  });
});

describe('marcosComRotulo com o texto ampliado', () => {
  /**
   * O usuário pode aumentar a fonte da gaveta. Texto maior ocupa mais largura,
   * e a regra de espaçamento tem de acompanhar — senão aumentar a fonte para
   * conseguir ler traz de volta exatamente o borrão que esta função existe
   * para evitar.
   */
  it('rotula menos marcos quando o texto cresce', () => {
    const marcos = [marco('a', 1500), marco('b', 1600), marco('c', 1700)];

    const normal = marcosComRotulo(marcos, umPixelPorAno, 1);
    const grande = marcosComRotulo(marcos, umPixelPorAno, 1.5);

    expect(normal.size).toBe(3);
    expect(grande.size).toBeLessThan(normal.size);
  });

  it('o primeiro marco sempre ganha rótulo, em qualquer escala', () => {
    const marcos = [marco('a', 1500), marco('b', 1510)];
    for (const escala of [0.85, 1, 1.5]) {
      expect(marcosComRotulo(marcos, umPixelPorAno, escala).has('a')).toBe(true);
    }
  });

  it('sem escala informada, comporta-se como antes', () => {
    const marcos = [marco('a', 1500), marco('b', 1600), marco('c', 1700)];
    expect(marcosComRotulo(marcos, umPixelPorAno)).toEqual(
      marcosComRotulo(marcos, umPixelPorAno, 1),
    );
  });
});
