/**
 * Exportação GEDCOM (fatia 08).
 *
 * "O SQLite é o formato de trabalho; o GEDCOM é o de transporte" (seção 4).
 * É o que transforma "você tem o arquivo" em "você tem os seus dados": um
 * acervo que só este programa sabe ler está preso a ele.
 *
 * O frontend escolhe onde salvar e entrega o caminho; quem escreve o arquivo é
 * o Rust. A capability concede `dialog:allow-save`, nunca `fs:`.
 */

import { open, save } from '@tauri-apps/plugin-dialog';
import { chamar } from './index';

export interface OpcoesExportacao {
  /** `null` = acervo inteiro. */
  raiz_id: string | null;
  ocultar_vivas: boolean;
  /** Empacota num GEDZip com a pasta de mídia. */
  incluir_midia: boolean;
}

export interface ResumoExportacao {
  caminho: string;
  pessoas: number;
  unioes: number;
  arquivos_de_midia: number;
  vivas_ocultadas: number;
  /** `true` quando saiu como GEDZip em vez de `.ged` solto. */
  empacotado: boolean;
}

export const exportarGedcom = (
  caminho: string,
  opcoes: OpcoesExportacao,
): Promise<ResumoExportacao> => chamar<ResumoExportacao>('exportar_gedcom', { caminho, opcoes });

/** `gdz` quando há mídia a levar junto; `ged` caso contrário. */
export const extensaoDeExportacao = (incluirMidia: boolean): Promise<string> =>
  chamar<string>('extensao_de_exportacao', { incluirMidia });

/**
 * Abre o diálogo de salvar. Devolve `null` se a pessoa cancelar — que é um
 * resultado normal, não erro.
 */
export async function escolherOndeSalvar(extensao: string): Promise<string | null> {
  const ehPacote = extensao === 'gdz';
  const escolhido = await save({
    defaultPath: `acervo-genealogico.${extensao}`,
    filters: [
      {
        name: ehPacote ? 'GEDZip (com fotos e documentos)' : 'GEDCOM',
        extensions: [extensao],
      },
    ],
  });
  return escolhido ?? null;
}

// ---------------------------------------------------------------------------
// Importação (fatia 09)
// ---------------------------------------------------------------------------

export interface OpcaoConflito {
  valor: string;
  rotulo: string;
}

export interface Conflito {
  /** Chave estável dentro do arquivo — é por ela que a decisão volta. */
  id: string;
  tipo: 'varios_famc' | 'slot_incompativel' | 'uniao_vazia' | 'ciclo' | string;
  titulo: string;
  explicacao: string;
  opcoes: OpcaoConflito[];
  padrao: string;
}

export interface AnalisePrevia {
  codificacao: string;
  versao: string;
  pessoas: number;
  unioes: number;
  conflitos: Conflito[];
  avisos: string[];
}

export interface ResumoImportacao {
  pessoas: number;
  unioes: number;
  filhos: number;
  placeholders: number;
  eventos: number;
  nomes: number;
  atributos: number;
  descartados: string[];
}

/** Lê o arquivo e devolve o que será perguntado. Não grava nada. */
export const analisarGedcom = (caminho: string): Promise<AnalisePrevia> =>
  chamar<AnalisePrevia>('analisar_gedcom', { caminho });

/** Aplica com as decisões tomadas. Tudo ou nada. */
export const importarGedcom = (
  caminho: string,
  decisoes: Record<string, string>,
): Promise<ResumoImportacao> =>
  chamar<ResumoImportacao>('importar_gedcom', { caminho, decisoes });

/** Abre o diálogo de escolher arquivo. `null` se a pessoa cancelar. */
export async function escolherGedcom(): Promise<string | null> {
  const escolhido = await open({
    multiple: false,
    directory: false,
    filters: [{ name: 'GEDCOM ou GEDZip', extensions: ['ged', 'gdz', 'zip'] }],
  });
  return typeof escolhido === 'string' ? escolhido : null;
}
