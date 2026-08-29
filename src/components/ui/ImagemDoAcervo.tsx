/**
 * Exibe um arquivo da pasta de mídia do acervo.
 *
 * O banco guarda caminho **relativo**; o webview precisa de uma URL. A
 * conversão é assíncrona (depende de descobrir a pasta de dados do sistema),
 * então o componente resolve uma vez e guarda.
 *
 * Fora do Tauri — no `npm run dev` puro — a conversão falha, e aí o
 * `alternativo` aparece. É o comportamento certo: melhor um ícone do que uma
 * imagem quebrada.
 */

import { useEffect, useState, type ReactNode } from 'react';
import { urlDoArquivo } from '../../lib/api';

interface ImagemDoAcervoProps {
  caminhoRelativo?: string | null;
  alt: string;
  className?: string;
  /** Mostrado enquanto resolve, se falhar, ou se não houver caminho. */
  alternativo: ReactNode;
}

export function ImagemDoAcervo({
  caminhoRelativo,
  alt,
  className,
  alternativo,
}: ImagemDoAcervoProps) {
  const [url, setUrl] = useState<string | null>(null);
  const [falhou, setFalhou] = useState(false);

  useEffect(() => {
    let ativo = true;
    setUrl(null);
    setFalhou(false);

    if (!caminhoRelativo) return;

    urlDoArquivo(caminhoRelativo)
      .then((u) => {
        if (ativo) setUrl(u);
      })
      .catch(() => {
        if (ativo) setFalhou(true);
      });

    // Evita escrever estado depois que o componente saiu da tela — comum na
    // árvore, onde os cards entram e saem conforme o pan.
    return () => {
      ativo = false;
    };
  }, [caminhoRelativo]);

  if (!caminhoRelativo || falhou || !url) {
    return <>{alternativo}</>;
  }

  return (
    <img
      src={url}
      alt={alt}
      className={className}
      onError={() => setFalhou(true)}
      draggable={false}
    />
  );
}
