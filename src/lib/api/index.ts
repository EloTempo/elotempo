/**
 * Fronteira com o backend Rust.
 *
 * Toda chamada passa por `chamar`, que traduz o erro tipado do domínio numa
 * `ErroDoAcervo` legível. Sem isso, um `FilhoJaTemUniao` chega à interface
 * como `[object Object]`.
 */

import { invoke } from '@tauri-apps/api/core';
import type { DomainErrorCode } from '../../types';

/** Erro vindo do domínio Rust, já com a mensagem em português. */
export class ErroDoAcervo extends Error {
  constructor(
    readonly codigo: DomainErrorCode | 'Desconhecido',
    mensagem: string,
  ) {
    super(mensagem);
    this.name = 'ErroDoAcervo';
  }
}

function ehErroDominio(e: unknown): e is { codigo: string; mensagem: string } {
  return (
    typeof e === 'object' &&
    e !== null &&
    'codigo' in e &&
    'mensagem' in e &&
    typeof (e as { mensagem: unknown }).mensagem === 'string'
  );
}

export async function chamar<T>(comando: string, argumentos?: Record<string, unknown>): Promise<T> {
  try {
    return await invoke<T>(comando, argumentos);
  } catch (e) {
    if (ehErroDominio(e)) {
      throw new ErroDoAcervo(e.codigo as DomainErrorCode, e.mensagem);
    }
    throw new ErroDoAcervo('Desconhecido', typeof e === 'string' ? e : String(e));
  }
}

export * from './person';
export * from './nomes';
export * from './documentos';
export * from './locais';
export * from './relatorio';
export * from './union';
export * from './events';
export * from './attributes';
export * from './tree';
