import { describe, it, expect } from 'vitest';
import { formatarBytesModelo, calcularProgressoDownload } from './assistenteIa';

describe('assistenteIa utilitários', () => {
  it('formata bytes em MB e GB de forma legível', () => {
    expect(formatarBytesModelo(0)).toBe('0 MB');
    expect(formatarBytesModelo(-500)).toBe('0 MB');
    expect(formatarBytesModelo(986 * 1024 * 1024)).toBe('986 MB');
    expect(formatarBytesModelo(1950 * 1024 * 1024)).toBe('1.90 GB');
  });

  it('calcula o percentual de download com proteção contra divisão por zero e limites [0, 100]', () => {
    expect(calcularProgressoDownload(0, 0)).toBe(0);
    expect(calcularProgressoDownload(500, 1000)).toBe(50);
    expect(calcularProgressoDownload(1200, 1000)).toBe(100);
    expect(calcularProgressoDownload(-50, 1000)).toBe(0);
  });
});
