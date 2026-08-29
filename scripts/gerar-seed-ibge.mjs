#!/usr/bin/env node
/**
 * Gera a migration de seed dos municípios brasileiros a partir da API de
 * Localidades do IBGE.
 *
 * Este script é a **única** parte do projeto que toca a internet, e roda na
 * máquina de quem desenvolve, nunca na de quem usa. O resultado — um arquivo
 * .sql com ~5.570 INSERTs — é versionado no repositório e embutido no binário.
 * É assim que a seção 2.4 pede: "baixada uma vez e transformada em tabela do
 * SQLite".
 *
 * Uso:
 *   npm run seed:ibge
 *
 * Rode de novo só quando o IBGE alterar a divisão municipal (o que acontece
 * raramente, e sempre por lei). O `codigo_ibge` é a chave estável: nomes de
 * cidade mudam com o tempo, e o acervo do usuário continua apontando certo.
 */

import { writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const AQUI = dirname(fileURLToPath(import.meta.url));
const SAIDA = join(AQUI, '..', 'src-tauri', 'migrations', '009__seed_municipios_ibge.sql');

const URL_MUNICIPIOS =
  'https://servicodados.ibge.gov.br/api/v1/localidades/municipios?orderBy=nome';

/** Escapa aspas simples para SQL. Há municípios como "Santa Bárbara d'Oeste". */
function aspas(texto) {
  return `'${String(texto).replace(/'/g, "''")}'`;
}

/**
 * A API já mudou a forma do aninhamento mais de uma vez (microrregiao vs.
 * regiao-imediata). Procura a UF nos dois caminhos conhecidos.
 */
function extrairUf(municipio) {
  return (
    municipio?.microrregiao?.mesorregiao?.UF?.sigla ??
    municipio?.['regiao-imediata']?.['regiao-intermediaria']?.UF?.sigla ??
    null
  );
}

async function principal() {
  process.stdout.write('Baixando municípios do IBGE… ');

  const resposta = await fetch(URL_MUNICIPIOS, {
    headers: { Accept: 'application/json' },
  });

  if (!resposta.ok) {
    throw new Error(`IBGE respondeu ${resposta.status} ${resposta.statusText}`);
  }

  const municipios = await resposta.json();
  if (!Array.isArray(municipios) || municipios.length < 5000) {
    throw new Error(
      `Resposta inesperada: ${Array.isArray(municipios) ? municipios.length : typeof municipios} itens. ` +
        'Esperava ~5.570 municípios — não vou gravar um seed incompleto por cima do bom.',
    );
  }

  const semUf = [];
  const linhas = [];

  for (const m of municipios) {
    const uf = extrairUf(m);
    if (!uf) {
      semUf.push(m.nome);
      continue;
    }
    // id = "ibge-<código>": legível num dump e estável entre gerações do seed.
    linhas.push(`(${aspas(`ibge-${m.id}`)},${aspas(m.nome)},${aspas(uf)},'br',${aspas(m.id)})`);
  }

  if (semUf.length > 0) {
    console.warn(`\nAviso: ${semUf.length} municípios sem UF identificável foram pulados.`);
    console.warn(semUf.slice(0, 5).join(', '));
  }

  const cabecalho = `-- 009 — Municípios brasileiros (seed do IBGE).
--
-- ARQUIVO GERADO. Não edite à mão: rode \`npm run seed:ibge\`.
--
-- Fonte: API de Localidades do IBGE (dados abertos)
--        ${URL_MUNICIPIOS}
-- Gerado em: ${new Date().toISOString().slice(0, 10)}
-- Municípios: ${linhas.length}
--
-- O \`codigo_ibge\` é a chave estável exigida pela seção 2.4. Nomes de cidade
-- mudam com o tempo ("nascido em Vila X, hoje município Y"); o rótulo
-- histórico livre fica em \`eventos.rotulo_historico_livre\`, e o código
-- continua ligando o registro ao lugar certo.

INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, codigo_ibge) VALUES
`;

  const sql = cabecalho + linhas.join(',\n') + ';\n';
  await writeFile(SAIDA, sql, 'utf8');

  console.log(`ok — ${linhas.length} municípios`);
  console.log(`Gravado em ${SAIDA}`);
  console.log('\nConfira o diff antes de commitar: este arquivo entra no binário.');
}

principal().catch((erro) => {
  console.error('\nFalhou:', erro.message);
  console.error(
    '\nSe for erro de certificado, pode ser antivírus interceptando TLS.\n' +
      'Exporte NODE_EXTRA_CA_CERTS apontando para o CA do antivírus e tente de novo.',
  );
  process.exit(1);
});
