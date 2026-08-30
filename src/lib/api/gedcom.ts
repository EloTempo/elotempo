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

import { save } from '@tauri-apps/plugin-dialog';
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
