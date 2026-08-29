import { describe, it, expect } from 'vitest';
import { distribuirSlots } from './slots';
import type { Sex } from '../../types';

/** Atalho: devolve ['quem está no masculino', 'quem está no feminino']. */
function arranjo(sexoPessoa: Sex, sexoConjuge: Sex): [string, string] {
  const r = distribuirSlots('PESSOA', sexoPessoa, 'CONJUGE', sexoConjuge);
  return [r.masculino, r.feminino];
}

describe('distribuirSlots', () => {
  it('põe o homem no masculino e a mulher no feminino', () => {
    expect(arranjo('M', 'F')).toEqual(['PESSOA', 'CONJUGE']);
    expect(arranjo('F', 'M')).toEqual(['CONJUGE', 'PESSOA']);
  });

  it('nunca coloca uma mulher no slot masculino', () => {
    for (const sexoConjuge of ['M', 'F', 'X', 'U'] as Sex[]) {
      const [, feminino] = arranjo('F', sexoConjuge);
      expect(feminino, `falhou com cônjuge ${sexoConjuge}`).toBe('PESSOA');
    }
  });

  it('nunca coloca um homem no slot feminino quando há alternativa', () => {
    // Pessoa M com cônjuge F, X ou U: ela fica no masculino.
    for (const sexoConjuge of ['F', 'X', 'U'] as Sex[]) {
      const [masculino] = arranjo('M', sexoConjuge);
      expect(masculino, `falhou com cônjuge ${sexoConjuge}`).toBe('PESSOA');
    }
  });

  it('cede o slot masculino ao homem quando o outro tem sexo desconhecido', () => {
    // O caso que motiva a segunda regra: um placeholder `U` casando com um
    // homem conhecido. Sem isto, o U iria para o masculino e o M sobraria para
    // o feminino, que o domínio recusa.
    expect(arranjo('U', 'M')).toEqual(['CONJUGE', 'PESSOA']);
    expect(arranjo('X', 'M')).toEqual(['CONJUGE', 'PESSOA']);
  });

  it('acomoda sexo desconhecido dos dois lados sem travar', () => {
    expect(arranjo('U', 'U')).toEqual(['PESSOA', 'CONJUGE']);
    expect(arranjo('X', 'X')).toEqual(['PESSOA', 'CONJUGE']);
    expect(arranjo('U', 'F')).toEqual(['PESSOA', 'CONJUGE']);
  });

  it('sempre devolve os dois slots preenchidos e distintos', () => {
    const sexos: Sex[] = ['M', 'F', 'X', 'U'];
    for (const a of sexos) {
      for (const b of sexos) {
        const r = distribuirSlots('PESSOA', a, 'CONJUGE', b);
        expect(r.masculino, `${a}+${b}`).toBeTruthy();
        expect(r.feminino, `${a}+${b}`).toBeTruthy();
        expect(r.masculino, `${a}+${b}`).not.toBe(r.feminino);
      }
    }
  });

  it('não tenta impedir combinações que o domínio recusa', () => {
    // Dois homens não formam união sob a regra da seção 3. A função acomoda
    // do jeito que der; quem recusa — com a mensagem explicando — é o Rust.
    // Este teste existe para deixar claro que a omissão é deliberada.
    const r = distribuirSlots('A', 'M', 'B', 'M');
    expect([r.masculino, r.feminino].sort()).toEqual(['A', 'B']);
  });
});
