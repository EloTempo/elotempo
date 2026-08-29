import { describe, it, expect } from 'vitest';
import {
  unidadesDeSobrenome,
  sobrenomeDeFamilia,
  sobrenomeMaterno,
  sugerirSobrenomeDeFilho,
  sugerirSobrenomeDoPai,
  sugerirSobrenomeDaMae,
} from './nomes';

describe('unidadesDeSobrenome', () => {
  it('separa sobrenomes simples', () => {
    expect(unidadesDeSobrenome('Ferreira Costa')).toEqual(['Ferreira', 'Costa']);
  });

  it('mantém a partícula grudada no sobrenome que ela acompanha', () => {
    expect(unidadesDeSobrenome('da Silva Santos')).toEqual(['da Silva', 'Santos']);
    expect(unidadesDeSobrenome('dos Santos')).toEqual(['dos Santos']);
    expect(unidadesDeSobrenome('de Oliveira Lima')).toEqual(['de Oliveira', 'Lima']);
  });

  it('trata "e" como ligação, não como sobrenome', () => {
    expect(unidadesDeSobrenome('Souza e Silva')).toEqual(['Souza e Silva']);
  });

  it('aguenta espaços sobrando e campo vazio', () => {
    expect(unidadesDeSobrenome('  Costa   ')).toEqual(['Costa']);
    expect(unidadesDeSobrenome('')).toEqual([]);
    expect(unidadesDeSobrenome(null)).toEqual([]);
    expect(unidadesDeSobrenome(undefined)).toEqual([]);
  });

  it('não perde palavra quando sobra partícula no fim', () => {
    // Digitação incompleta acontece; o importante é não engolir texto.
    expect(unidadesDeSobrenome('Silva de').join(' ')).toContain('Silva');
    expect(unidadesDeSobrenome('Silva de').join(' ')).toContain('de');
  });
});

describe('sobrenomeDeFamilia', () => {
  it('devolve o último — que é o paterno, o que se transmite', () => {
    expect(sobrenomeDeFamilia('da Silva Santos')).toBe('Santos');
    expect(sobrenomeDeFamilia('Ferreira Costa')).toBe('Costa');
  });

  it('com um sobrenome só, devolve ele mesmo', () => {
    expect(sobrenomeDeFamilia('Costa')).toBe('Costa');
    expect(sobrenomeDeFamilia('dos Santos')).toBe('dos Santos');
  });

  it('devolve vazio quando não há sobrenome', () => {
    expect(sobrenomeDeFamilia('')).toBe('');
    expect(sobrenomeDeFamilia(null)).toBe('');
  });
});

describe('sobrenomeMaterno', () => {
  it('devolve o primeiro quando há dois ou mais', () => {
    expect(sobrenomeMaterno('Santos Costa')).toBe('Santos');
    expect(sobrenomeMaterno('da Silva Ferreira Costa')).toBe('da Silva');
  });

  it('não arrisca quando há um sobrenome só', () => {
    // Com "Pedro Costa" não dá para saber de que lado veio o Costa.
    expect(sobrenomeMaterno('Costa')).toBe('');
  });
});

describe('sugerirSobrenomeDeFilho', () => {
  it('compõe materno + paterno, nessa ordem', () => {
    // Mãe: Maria da Silva Santos · Pai: João Ferreira Costa
    expect(sugerirSobrenomeDeFilho('Ferreira Costa', 'da Silva Santos')).toBe('Santos Costa');
  });

  it('usa só o que existe quando um dos pais não tem sobrenome', () => {
    expect(sugerirSobrenomeDeFilho('Costa', '')).toBe('Costa');
    expect(sugerirSobrenomeDeFilho('', 'Santos')).toBe('Santos');
    expect(sugerirSobrenomeDeFilho(null, null)).toBe('');
  });

  it('não repete quando os dois lados têm o mesmo sobrenome', () => {
    expect(sugerirSobrenomeDeFilho('Silva', 'Silva')).toBe('Silva');
    expect(sugerirSobrenomeDeFilho('Souza SILVA', 'Lima silva')).toBe('SILVA');
  });

  it('usa só a última unidade de cada pai, não o nome inteiro', () => {
    // O erro fácil seria concatenar tudo e produzir
    // "da Silva Santos Ferreira Costa".
    const r = sugerirSobrenomeDeFilho('Ferreira Costa', 'da Silva Santos');
    expect(r.split(/\s+/)).toHaveLength(2);
  });

  it('preserva a partícula do sobrenome herdado', () => {
    expect(sugerirSobrenomeDeFilho('dos Santos', 'da Silva')).toBe('da Silva dos Santos');
  });
});

describe('sugestões no sentido inverso (do filho para os pais)', () => {
  it('o pai herda o último sobrenome do filho', () => {
    expect(sugerirSobrenomeDoPai('Santos Costa')).toBe('Costa');
    expect(sugerirSobrenomeDoPai('Costa')).toBe('Costa');
  });

  it('a mãe herda o primeiro, e só quando há dois', () => {
    expect(sugerirSobrenomeDaMae('Santos Costa')).toBe('Santos');
    expect(sugerirSobrenomeDaMae('Costa')).toBe('');
  });

  it('ida e volta são coerentes', () => {
    // Compor a partir dos pais e depois decompor devolve os mesmos pedaços.
    const filho = sugerirSobrenomeDeFilho('Ferreira Costa', 'da Silva Santos');
    expect(sugerirSobrenomeDoPai(filho)).toBe('Costa');
    expect(sugerirSobrenomeDaMae(filho)).toBe('Santos');
  });
});
