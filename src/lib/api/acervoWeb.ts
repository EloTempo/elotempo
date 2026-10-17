/**
 * Exportação do acervo histórico público para o portal web.
 *
 * Ferramenta de manutenção do acervo público, não de uso diário: gera os
 * arquivos JSON que o site `elotempo.org/acervo` consome. Não tem nada a ver
 * com os dados familiares do usuário, que saem pelo GEDCOM.
 *
 * Como no GEDCOM, quem escolhe a pasta é o diálogo do sistema e quem escreve
 * é o Rust. A capability concede `dialog:allow-open`, nunca `fs:`.
 */

import { open } from '@tauri-apps/plugin-dialog';
import { chamar } from './index';

export interface RelatorioExportacao {
  destino: string;
  arvores: number;
  pessoas: number;
  unioes: number;
  linhas_tempo: number;
  fotos_copiadas: number;
  fotos_ausentes: number;
  bytes_de_midia: number;
  /** Vazio quando tudo saiu como esperado. */
  avisos: string[];
}

/**
 * Pede a pasta de destino e exporta. Devolve `null` se o usuário cancelar —
 * cancelar não é erro e não deve virar mensagem de falha.
 */
export async function exportarAcervoWeb(): Promise<RelatorioExportacao | null> {
  const escolhido = await open({
    directory: true,
    multiple: false,
    title: 'Escolha a pasta "acervo" do repositório do site',
  });

  if (!escolhido || Array.isArray(escolhido)) return null;

  return chamar<RelatorioExportacao>('exportar_acervo_web', { destino: escolhido });
}

/** Formata bytes para o resumo da exportação. */
export function formatarBytes(bytes: number): string {
  if (!Number.isFinite(bytes) || bytes <= 0) return '0 MB';
  const mb = bytes / (1024 * 1024);
  return mb >= 1024 ? `${(mb / 1024).toFixed(2)} GB` : `${Math.round(mb)} MB`;
}
