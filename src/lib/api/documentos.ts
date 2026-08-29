/**
 * Fotos e documentos (fatia 03).
 *
 * O frontend **nunca toca o sistema de arquivos**. Ele abre o seletor, recebe
 * um caminho e o entrega ao Rust, que copia o arquivo para a pasta de dados do
 * app. Por isso a capability concede apenas `dialog:allow-open` — nada de `fs:`.
 */

import { convertFileSrc } from '@tauri-apps/api/core';
import { open } from '@tauri-apps/plugin-dialog';
import { appDataDir, join } from '@tauri-apps/api/path';
import { chamar } from './index';
import type { Document, NewDocument } from '../../types';

export const listarDocumentosPessoa = (pessoaId: string): Promise<Document[]> =>
  chamar<Document[]>('listar_documentos_pessoa', { pessoaId });

export const anexarDocumento = (novo: NewDocument): Promise<string> =>
  chamar<string>('anexar_documento', { novo });

/** Remove o registro e o arquivo copiado. */
export const removerDocumento = (id: string): Promise<void> =>
  chamar<void>('remover_documento', { id });

/** Passar `null` limpa o retrato da pessoa. */
export const definirFotoPrincipal = (
  pessoaId: string,
  documentoId: string | null,
): Promise<void> =>
  chamar<void>('definir_foto_principal', { pessoaId, documentoId });

/**
 * Abre o seletor de arquivo do sistema.
 *
 * Devolve `null` se a pessoa cancelar — que é um resultado normal, não erro.
 */
export async function escolherArquivo(): Promise<string | null> {
  const escolhido = await open({
    multiple: false,
    directory: false,
    filters: [
      {
        name: 'Fotos e documentos',
        extensions: ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp', 'pdf', 'txt', 'md', 'rtf'],
      },
      { name: 'Todos os arquivos', extensions: ['*'] },
    ],
  });

  if (typeof escolhido === 'string') return escolhido;
  return null;
}

/**
 * Converte o caminho relativo guardado no banco numa URL que o webview exibe.
 *
 * Usa o protocolo `asset:` do Tauri, cujo escopo está limitado a
 * `$APPDATA/midia/**` no tauri.conf.json. A alternativa — ler os bytes e
 * devolver base64 — recarregaria megabytes pela IPC a cada render da árvore.
 */
export async function urlDoArquivo(caminhoRelativo: string): Promise<string> {
  const base = await appDataDir();
  const absoluto = await join(base, caminhoRelativo);
  return convertFileSrc(absoluto);
}
