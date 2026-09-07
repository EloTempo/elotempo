/**
 * Conversor de SVG para PNG em alta resolução via Canvas off-screen.
 * Suporta escalas de 1x (tela), 2x (alta definição) e 3x (impressão de pôster a 300 DPI).
 */

import { invoke } from '@tauri-apps/api/core';
import { save } from '@tauri-apps/plugin-dialog';

export type EscalaPng = 1 | 2 | 3;

/**
 * Converte um código SVG string para um Uint8Array contendo os bytes da imagem PNG.
 */
export async function converterSvgParaPngBytes(
  svgTexto: string,
  escala: EscalaPng = 2
): Promise<Uint8Array> {
  // Cria um blob do SVG para carregar em um objeto Image
  const svgBlob = new Blob([svgTexto], { type: 'image/svg+xml;charset=utf-8' });
  const url = URL.createObjectURL(svgBlob);

  try {
    const img = new Image();

    // Promessa para aguardar o carregamento da imagem
    await new Promise<void>((resolve, reject) => {
      img.onload = () => resolve();
      img.onerror = (e) => reject(new Error(`Falha ao decodificar SVG: ${e}`));
      img.src = url;
    });

    // Dimensões naturais do SVG
    const larguraBase = img.naturalWidth || img.width || 1200;
    const alturaBase = img.naturalHeight || img.height || 800;

    const canvas = document.createElement('canvas');
    canvas.width = Math.round(larguraBase * escala);
    canvas.height = Math.round(alturaBase * escala);

    const ctx = canvas.getContext('2d');
    if (!ctx) {
      throw new Error('Não foi possível obter o contexto 2D do Canvas.');
    }

    ctx.imageSmoothingEnabled = true;
    ctx.imageSmoothingQuality = 'high';

    // Desenha a imagem na resolução multiplicada
    ctx.drawImage(img, 0, 0, canvas.width, canvas.height);

    const blob = await new Promise<Blob>((resolve, reject) => {
      canvas.toBlob(
        (b) => (b ? resolve(b) : reject(new Error('Erro ao converter Canvas para Blob PNG'))),
        'image/png'
      );
    });

    const buffer = await blob.arrayBuffer();
    return new Uint8Array(buffer);
  } finally {
    URL.revokeObjectURL(url);
  }
}

/**
 * Abre o seletor nativo de arquivo para escolher onde salvar a imagem.
 */
export async function escolherOndeSalvarGrafico(
  tipo: 'png' | 'svg',
  nomePadrao = 'poster-arvore-genealogica'
): Promise<string | null> {
  try {
    const escolhido = await save({
      defaultPath: `${nomePadrao}.${tipo}`,
      filters: [
        {
          name: tipo === 'png' ? 'Imagem PNG (*.png)' : 'Vetor SVG (*.svg)',
          extensions: [tipo],
        },
      ],
    });
    return escolhido ?? null;
  } catch {
    return null;
  }
}

/**
 * Salva a árvore como arquivo PNG no disco.
 */
export async function salvarArvorePng(
  caminhoDestino: string,
  svgTexto: string,
  escala: EscalaPng = 2,
  ticketAutorizacao?: string | null,
): Promise<void> {
  const bytes = await converterSvgParaPngBytes(svgTexto, escala);
  await invoke('salvar_arquivo_bytes', {
    caminho: caminhoDestino,
    bytes: Array.from(bytes),
    ticketAutorizacao: ticketAutorizacao ?? null,
  });
}

/**
 * Salva a árvore como arquivo SVG vetorial no disco.
 */
export async function salvarArvoreSvg(
  caminhoDestino: string,
  svgTexto: string,
  ticketAutorizacao?: string | null,
): Promise<void> {
  await invoke('salvar_arquivo_texto', {
    caminho: caminhoDestino,
    conteudo: svgTexto,
    ticketAutorizacao: ticketAutorizacao ?? null,
  });
}

/**
 * Fallback para download no navegador (caso não esteja em ambiente Tauri nativo).
 */
export function dispararDownloadNavegador(conteudo: Blob | string, nomeArquivo: string, tipoMime: string) {
  const blob = typeof conteudo === 'string' ? new Blob([conteudo], { type: tipoMime }) : conteudo;
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = nomeArquivo;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}
