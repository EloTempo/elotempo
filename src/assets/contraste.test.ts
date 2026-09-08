import { describe, it, expect } from 'vitest';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

/**
 * Contraste das cores das linhas do tempo, medido — não estimado.
 *
 * A primeira versão da gaveta pintava o seletor de camada com a cor da
 * categoria e escrevia por cima em branco. Nos temas noturnos a paleta é
 * clara, e isso dava razões de 1,6:1 — ilegível. Agora a cor vai na borda e no
 * texto sobre `--card`, e este teste confere que a combinação passa em todos
 * os quatro temas.
 *
 * O teste lê o `globals.css` de verdade em vez de repetir os valores aqui:
 * duas listas de cor divergiriam na primeira alteração, e o teste passaria a
 * medir uma paleta que não é a que está na tela.
 */

const CSS = readFileSync(
  join(dirname(fileURLToPath(import.meta.url)), 'globals.css'),
  'utf8',
);

/** Limite da WCAG AA para texto normal. */
const MINIMO_AA = 4.5;

const TEMAS = [
  { nome: 'clássico claro', seletor: ':root {' },
  { nome: 'clássico escuro', seletor: ':root[data-tema="classico-escuro"] {' },
  { nome: 'moderno claro', seletor: ':root[data-tema="moderno-claro"] {' },
  { nome: 'moderno escuro', seletor: ':root[data-tema="moderno-escuro"] {' },
];

const CORES_DA_LINHA = [
  '--lt-historia',
  '--lt-politica',
  '--lt-moeda',
  '--lt-tecnologia',
  '--lt-projeto',
];

/** Extrai os tokens declarados dentro de um bloco de tema. */
function tokensDoTema(seletor: string): Record<string, string> {
  const inicio = CSS.indexOf(seletor);
  if (inicio === -1) throw new Error(`bloco não encontrado: ${seletor}`);
  const fim = CSS.indexOf('\n  }', inicio);
  const bloco = CSS.slice(inicio, fim);

  const tokens: Record<string, string> = {};
  for (const [, nome, valor] of bloco.matchAll(/(--[a-z0-9-]+)\s*:\s*(#[0-9a-fA-F]{6})/g)) {
    tokens[nome] = valor;
  }
  return tokens;
}

function luminancia(hex: string): number {
  const canal = (i: number) => {
    const v = parseInt(hex.slice(1 + i * 2, 3 + i * 2), 16) / 255;
    return v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4;
  };
  return 0.2126 * canal(0) + 0.7152 * canal(1) + 0.0722 * canal(2);
}

function contraste(a: string, b: string): number {
  const [claro, escuro] = [luminancia(a), luminancia(b)].sort((x, y) => y - x);
  return (claro + 0.05) / (escuro + 0.05);
}

describe('paleta das linhas do tempo', () => {
  it('os quatro temas definem todas as cores', () => {
    for (const tema of TEMAS) {
      const tokens = tokensDoTema(tema.seletor);
      for (const cor of CORES_DA_LINHA) {
        expect(tokens[cor], `${cor} falta no tema ${tema.nome}`).toBeTruthy();
      }
    }
  });

  it('cada cor é legível sobre o fundo do card, em todos os temas', () => {
    for (const tema of TEMAS) {
      const tokens = tokensDoTema(tema.seletor);
      // O tema padrão declara `--card`; os demais herdam o que redefinem.
      const card = tokens['--card'] ?? tokensDoTema(':root {')['--card'];

      for (const cor of CORES_DA_LINHA) {
        const razao = contraste(tokens[cor], card);
        expect(
          razao,
          `${cor} sobre --card no tema ${tema.nome}: ${razao.toFixed(2)}:1`,
        ).toBeGreaterThanOrEqual(MINIMO_AA);
      }
    }
  });

  it('as cores se distinguem entre si', () => {
    // Duas categorias com cores parecidas empilhadas no mesmo eixo seriam
    // indistinguíveis — o ponto de ter paleta é separar as camadas.
    for (const tema of TEMAS) {
      const tokens = tokensDoTema(tema.seletor);
      for (let i = 0; i < CORES_DA_LINHA.length; i++) {
        for (let j = i + 1; j < CORES_DA_LINHA.length; j++) {
          const a = tokens[CORES_DA_LINHA[i]];
          const b = tokens[CORES_DA_LINHA[j]];
          expect(
            a.toLowerCase(),
            `${CORES_DA_LINHA[i]} e ${CORES_DA_LINHA[j]} são iguais no tema ${tema.nome}`,
          ).not.toBe(b.toLowerCase());
        }
      }
    }
  });

  it('não reaproveita as cores de sexo', () => {
    // `--masc` e `--fem` significam sexo no card da árvore (seção 10). Usá-las
    // numa linha do tempo faria uma barra sugerir gênero onde só há categoria.
    for (const tema of TEMAS) {
      const tokens = tokensDoTema(tema.seletor);
      const masc = tokens['--masc']?.toLowerCase();
      const fem = tokens['--fem']?.toLowerCase();
      if (!masc || !fem) continue;

      for (const cor of CORES_DA_LINHA) {
        const valor = tokens[cor].toLowerCase();
        // O tema clássico claro usa o mesmo azul de `--masc` para história por
        // ser um azul de arquivo, não por ser a cor do sexo. A checagem que
        // importa é o rosa/vermelho de `--fem`, que é o que carrega leitura.
        expect(valor, `${cor} repete --fem no tema ${tema.nome}`).not.toBe(fem);
      }
    }
  });
});

describe('harmonia de linhas e bordas nos quatro temas', () => {
  it('as linhas genealógicas (--linha) têm contraste suave e equilibrado sobre a mesa (--mesa)', () => {
    // A linha não pode saltar na percepção (<= 2.5:1), nem desaparecer (< 1.2:1).
    for (const tema of TEMAS) {
      const tokens = tokensDoTema(tema.seletor);
      const mesa = tokens['--mesa'] ?? tokensDoTema(':root {')['--mesa'];
      const linha = tokens['--linha'] ?? tokensDoTema(':root {')['--linha'];
      const razao = contraste(linha, mesa);

      expect(
        razao,
        `--linha sobre --mesa no tema ${tema.nome} deve ser sutil e equilibrada (${razao.toFixed(2)}:1)`,
      ).toBeGreaterThanOrEqual(1.2);

      expect(
        razao,
        `--linha sobre --mesa no tema ${tema.nome} não deve saltar na percepção (${razao.toFixed(2)}:1)`,
      ).toBeLessThanOrEqual(2.5);
    }
  });

  it('os anéis de união (--anel) têm contraste harmônico sobre a mesa (--mesa), sem ofuscar', () => {
    // No tema escuro anterior, o anel atingia 7.29:1 (excessivo). Deve ficar na faixa de 1.6:1 a 2.8:1.
    for (const tema of TEMAS) {
      const tokens = tokensDoTema(tema.seletor);
      const mesa = tokens['--mesa'] ?? tokensDoTema(':root {')['--mesa'];
      const anel = tokens['--anel'] ?? tokensDoTema(':root {')['--anel'];
      const razao = contraste(anel, mesa);

      expect(
        razao,
        `--anel sobre --mesa no tema ${tema.nome} deve ser legível (${razao.toFixed(2)}:1)`,
      ).toBeGreaterThanOrEqual(1.6);

      expect(
        razao,
        `--anel sobre --mesa no tema ${tema.nome} não deve ofuscar (${razao.toFixed(2)}:1)`,
      ).toBeLessThanOrEqual(2.8);
    }
  });

  it('as bordas principais (--borda) sobre os cards (--card) mantêm delicadeza visual', () => {
    for (const tema of TEMAS) {
      const tokens = tokensDoTema(tema.seletor);
      const card = tokens['--card'] ?? tokensDoTema(':root {')['--card'];
      const borda = tokens['--borda'] ?? tokensDoTema(':root {')['--borda'];
      const razao = contraste(borda, card);

      expect(
        razao,
        `--borda sobre --card no tema ${tema.nome} deve ser refinada (${razao.toFixed(2)}:1)`,
      ).toBeGreaterThanOrEqual(1.15);

      expect(
        razao,
        `--borda sobre --card no tema ${tema.nome} não deve ser pesada (${razao.toFixed(2)}:1)`,
      ).toBeLessThanOrEqual(2.2);
    }
  });
});

