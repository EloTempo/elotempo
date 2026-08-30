import { describe, it, expect } from 'vitest';
import { previaDoTexto } from './CampoDeData';
import { DATA_VAZIA, type DataEscolhida } from '../../types';

/**
 * A prévia mostrada na tela precisa bater com o texto que o Rust compõe ao
 * salvar (`datas::compor_texto`). Se divergirem, o usuário escolhe vendo uma
 * coisa e o acervo guarda outra — o pior tipo de erro, porque parece certo na
 * hora e só aparece depois.
 *
 * Os casos abaixo são os mesmos do teste `compoe_o_texto_a_partir_do_que_foi_escolhido`
 * em `datas.rs`. Ao mexer num, mexer no outro.
 */

function data(p: Partial<DataEscolhida>): DataEscolhida {
  return { ...DATA_VAZIA, ...p };
}

describe('previaDoTexto', () => {
  it('compõe data exata com dia, mês e ano', () => {
    expect(previaDoTexto(data({ qualificador: 'exata', dia: 12, mes: 3, ano: 1945 }))).toBe(
      '12 de março de 1945',
    );
  });

  it('compõe mês e ano sem dia', () => {
    expect(previaDoTexto(data({ qualificador: 'exata', mes: 3, ano: 1945 }))).toBe(
      'março de 1945',
    );
  });

  it('compõe só o ano', () => {
    expect(previaDoTexto(data({ qualificador: 'exata', ano: 1945 }))).toBe('1945');
  });

  it('dia sem mês não entra — "12 de 1945" não quer dizer nada', () => {
    expect(previaDoTexto(data({ qualificador: 'exata', dia: 12, ano: 1945 }))).toBe('1945');
  });

  it('escreve os qualificadores em português', () => {
    expect(previaDoTexto(data({ qualificador: 'cerca_de', ano: 1890 }))).toBe('cerca de 1890');
    expect(previaDoTexto(data({ qualificador: 'antes_de', ano: 1914 }))).toBe('antes de 1914');
    expect(previaDoTexto(data({ qualificador: 'apos', ano: 1900 }))).toBe('após 1900');
  });

  it('o intervalo mostra os dois anos', () => {
    expect(previaDoTexto(data({ qualificador: 'intervalo', ano: 1902, ano_fim: 1904 }))).toBe(
      'entre 1902 e 1904',
    );
  });

  it('sem ano não há prévia, e isso é válido', () => {
    // Regra transversal da seção 2.5: a data nunca bloqueia o salvamento.
    expect(previaDoTexto(DATA_VAZIA)).toBe('');
    expect(previaDoTexto(data({ qualificador: 'exata' }))).toBe('');
  });

  it('o texto livre é usado como está', () => {
    expect(
      previaDoTexto(data({ qualificador: 'livre', texto_livre: 'na época da guerra' })),
    ).toBe('na época da guerra');
  });

  it('texto livre em branco não vira prévia', () => {
    expect(previaDoTexto(data({ qualificador: 'livre', texto_livre: '   ' }))).toBe('');
  });

  it('os doze meses saem por extenso e em ordem', () => {
    const nomes = Array.from({ length: 12 }, (_, i) =>
      previaDoTexto(data({ qualificador: 'exata', mes: i + 1, ano: 2000 })),
    );
    expect(nomes[0]).toBe('janeiro de 2000');
    expect(nomes[2]).toBe('março de 2000');
    expect(nomes[11]).toBe('dezembro de 2000');
  });
});
