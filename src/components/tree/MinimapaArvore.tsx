import React, { useRef, useCallback, useState } from 'react';
import { Minus, Compass } from 'lucide-react';
import type { LayoutArvore } from '../../lib/tree/layout';
import { caminhoOrtogonal } from '../../lib/tree/layout';
import { useI18n } from '../../i18n/I18nContext';

export interface MinimapaArvoreProps {
  layout: LayoutArvore;
  viewportTransform: { x: number; y: number; k: number };
  containerWidth: number;
  containerHeight: number;
  pessoaSelecionadaId?: string | null;
  onNavegarPara: (x: number, y: number) => void;
  abertoPadrao?: boolean;
  className?: string;
}

export function MinimapaArvore({
  layout,
  viewportTransform,
  containerWidth,
  containerHeight,
  pessoaSelecionadaId,
  onNavegarPara,
  abertoPadrao = true,
  className = '',
}: MinimapaArvoreProps) {
  const { t } = useI18n();
  const [aberto, setAberto] = useState<boolean>(() => {
    try {
      const salvo = localStorage.getItem('arvore-minimapa-aberto');
      return salvo !== null ? salvo === 'true' : abertoPadrao;
    } catch {
      return abertoPadrao;
    }
  });

  const svgRef = useRef<SVGSVGElement>(null);
  const estaArrastandoRef = useRef(false);

  const toggleAberto = () => {
    setAberto((prev) => {
      const next = !prev;
      try {
        localStorage.setItem('arvore-minimapa-aberto', String(next));
      } catch {}
      return next;
    });
  };

  // Dimensões do minimapa no painel UI
  const LARGURA_MINIMAPA = 220;
  const proporcao = (layout.altura || 1) / (layout.largura || 1);
  const ALTURA_MINIMAPA = Math.max(90, Math.min(160, Math.round(LARGURA_MINIMAPA * proporcao)));

  // Viewport visível em coordenadas do layout
  const escala = viewportTransform.k || 1;
  const vx = -viewportTransform.x / escala;
  const vy = -viewportTransform.y / escala;
  const vw = containerWidth / escala;
  const vh = containerHeight / escala;

  // Converter clique no minimapa para coordenadas da árvore
  const handleInteragir = useCallback(
    (e: React.MouseEvent<SVGSVGElement>) => {
      const svg = svgRef.current;
      if (!svg || !layout.largura || !layout.altura) return;

      const rect = svg.getBoundingClientRect();
      const clickX = e.clientX - rect.left;
      const clickY = e.clientY - rect.top;

      const proporcaoX = Math.max(0, Math.min(1, clickX / rect.width));
      const proporcaoY = Math.max(0, Math.min(1, clickY / rect.height));

      const targetX = proporcaoX * layout.largura;
      const targetY = proporcaoY * layout.altura;

      onNavegarPara(targetX, targetY);
    },
    [layout.largura, layout.altura, onNavegarPara],
  );

  const handleMouseDown = (e: React.MouseEvent<SVGSVGElement>) => {
    estaArrastandoRef.current = true;
    handleInteragir(e);
  };

  const handleMouseMove = (e: React.MouseEvent<SVGSVGElement>) => {
    if (estaArrastandoRef.current && (e.buttons & 1) === 1) {
      handleInteragir(e);
    } else {
      estaArrastandoRef.current = false;
    }
  };

  const handleMouseUp = () => {
    estaArrastandoRef.current = false;
  };

  if (!aberto) {
    return (
      <div className={`absolute bottom-5 right-5 z-20 ${className}`}>
        <button
          type="button"
          onClick={toggleAberto}
          className="p-2.5 bg-card/90 hover:bg-card backdrop-blur-md border border-borda shadow-sombra rounded-full text-tinta2 hover:text-acento cursor-pointer transition-all hover:scale-105 active:scale-95"
          title={t('arvore', 'minimapaAbrir')}
        >
          <Compass className="w-5 h-5 text-acento" />
        </button>
      </div>
    );
  }

  // Largura de traço ajustada proporcionalmente ao tamanho total do layout
  const strokeLinha = Math.max(2, Math.round(layout.largura / 250));
  const strokeViewport = Math.max(3, Math.round(layout.largura / 200));

  return (
    <div
      className={`absolute bottom-5 right-5 z-20 bg-card/95 backdrop-blur-md border border-borda shadow-sombra rounded-raio overflow-hidden select-none transition-all ${className}`}
      style={{ width: `${LARGURA_MINIMAPA}px` }}
    >
      {/* Cabeçalho do Minimapa */}
      <div className="flex items-center justify-between px-2.5 py-1.5 border-b border-borda/60 bg-sup/50 text-[11px] text-tinta font-semibold">
        <div className="flex items-center gap-1.5">
          <Compass className="w-3.5 h-3.5 text-acento" />
          <span>{t('arvore', 'radarTitulo')}</span>
          <span className="text-[10px] text-tinta2 font-normal font-num ml-0.5">
            ({layout.pessoas.length})
          </span>
        </div>
        <button
          type="button"
          onClick={toggleAberto}
          className="p-0.5 rounded text-tinta2 hover:text-tinta hover:bg-card cursor-pointer transition-colors"
          title={t('arvore', 'minimapaFechar')}
        >
          <Minus className="w-3.5 h-3.5" />
        </button>
      </div>

      {/* Superfície do SVG Reduzido */}
      <div className="p-1.5 bg-bg/80">
        <svg
          ref={svgRef}
          viewBox={`0 0 ${layout.largura} ${layout.altura}`}
          className="w-full bg-card/40 rounded border border-borda/40 cursor-crosshair overflow-hidden"
          style={{ height: `${ALTURA_MINIMAPA}px` }}
          onMouseDown={handleMouseDown}
          onMouseMove={handleMouseMove}
          onMouseUp={handleMouseUp}
        >
          {/* Arestas conectando os parentes */}
          <g fill="none" opacity={0.45}>
            {layout.arestas.map((a) => (
              <path
                key={a.id}
                d={caminhoOrtogonal(a.origem, a.destino)}
                stroke="var(--linha)"
                strokeWidth={strokeLinha}
              />
            ))}
          </g>

          {/* Uniões */}
          <g opacity={0.6}>
            {layout.unioes.map((u) => (
              <circle
                key={u.id}
                cx={u.x}
                cy={u.y}
                r={Math.max(6, strokeLinha * 1.5)}
                fill="var(--anel)"
              />
            ))}
          </g>

          {/* Cards reduzidos dos parentes */}
          <g>
            {layout.pessoas.map((p) => {
              const selecionado = p.id === pessoaSelecionadaId;
              const corNo =
                selecionado
                  ? 'var(--acento)'
                  : p.sexo === 'M'
                    ? '#0284c7'
                    : p.sexo === 'F'
                      ? '#db2777'
                      : '#d97706';

              // Dimensões do nó na escala original
              const larguraMini = 160;
              const alturaMini = 50;

              return (
                <rect
                  key={p.id}
                  x={p.x - larguraMini / 2}
                  y={p.y - alturaMini / 2}
                  width={larguraMini}
                  height={alturaMini}
                  rx={alturaMini / 3}
                  fill={corNo}
                  fillOpacity={selecionado ? 1 : 0.8}
                  stroke={selecionado ? '#ffffff' : 'none'}
                  strokeWidth={selecionado ? strokeViewport : 0}
                />
              );
            })}
          </g>

          {/* Retângulo indicador da Viewport / Câmera */}
          <rect
            x={vx}
            y={vy}
            width={vw}
            height={vh}
            fill="var(--acento)"
            fillOpacity={0.15}
            stroke="var(--acento)"
            strokeWidth={strokeViewport}
            rx={strokeViewport * 2}
            className="pointer-events-none"
          />
        </svg>
      </div>
    </div>
  );
}
