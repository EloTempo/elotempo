import React, { useRef, useCallback, useState, useEffect } from 'react';
import { Minus, Compass, GripHorizontal } from 'lucide-react';
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

interface PosicaoRadar {
  x: number;
  y: number;
}

const CHAVE_POSICAO_RADAR = 'arvore-minimapa-posicao-v1';

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

  // Dimensões do minimapa no painel UI
  const LARGURA_MINIMAPA = 220;
  const proporcao = (layout.altura || 1) / (layout.largura || 1);
  const ALTURA_MINIMAPA = Math.max(90, Math.min(160, Math.round(LARGURA_MINIMAPA * proporcao)));
  const ALTURA_TOTAL_CARD = ALTURA_MINIMAPA + 44;

  // Posição livre (x, y a partir do canto superior esquerdo do canvas).
  // Padrão inicial: canto superior direito (top: 16, right: 16) para nunca colidir com a barra inferior.
  const [posicao, setPosicao] = useState<PosicaoRadar | null>(() => {
    try {
      const salvo = localStorage.getItem(CHAVE_POSICAO_RADAR);
      if (salvo) {
        const parsed = JSON.parse(salvo);
        if (typeof parsed?.x === 'number' && typeof parsed?.y === 'number') {
          return parsed;
        }
      }
    } catch {}
    return null;
  });

  const [arrastandoPainel, setArrastandoPainel] = useState(false);
  const dragOffsetRef = useRef<{ startMouseX: number; startMouseY: number; startX: number; startY: number } | null>(null);
  const moveuDuranteCliqueRef = useRef(false);

  const svgRef = useRef<SVGSVGElement>(null);
  const painelRef = useRef<HTMLDivElement>(null);
  const estaArrastandoRef = useRef(false);

  // Calcula coordenadas garantidas dentro dos limites visíveis do container
  const larguraAtual = aberto ? LARGURA_MINIMAPA : 42;
  const alturaAtual = aberto ? ALTURA_TOTAL_CARD : 42;
  const maxX = Math.max(12, (containerWidth || 1000) - larguraAtual - 16);
  const maxY = Math.max(12, (containerHeight || 800) - alturaAtual - 16);

  const posX = posicao ? Math.max(12, Math.min(maxX, posicao.x)) : maxX;
  const posY = posicao ? Math.max(12, Math.min(maxY, posicao.y)) : 16;

  const iniciarArrastePainel = useCallback(
    (e: React.MouseEvent<HTMLElement>) => {
      if (e.button !== 0) return;
      e.stopPropagation();
      moveuDuranteCliqueRef.current = false;
      dragOffsetRef.current = {
        startMouseX: e.clientX,
        startMouseY: e.clientY,
        startX: posX,
        startY: posY,
      };
      setArrastandoPainel(true);
    },
    [posX, posY],
  );

  useEffect(() => {
    if (!arrastandoPainel) return;

    const handleWindowMouseMove = (e: MouseEvent) => {
      if (!dragOffsetRef.current) return;
      const dx = e.clientX - dragOffsetRef.current.startMouseX;
      const dy = e.clientY - dragOffsetRef.current.startMouseY;
      if (Math.abs(dx) > 3 || Math.abs(dy) > 3) {
        moveuDuranteCliqueRef.current = true;
      }
      const novoX = Math.max(12, Math.min(maxX, dragOffsetRef.current.startX + dx));
      const novoY = Math.max(12, Math.min(maxY, dragOffsetRef.current.startY + dy));
      const novaPos = { x: novoX, y: novoY };
      setPosicao(novaPos);
      try {
        localStorage.setItem(CHAVE_POSICAO_RADAR, JSON.stringify(novaPos));
      } catch {}
    };

    const handleWindowMouseUp = () => {
      setArrastandoPainel(false);
      dragOffsetRef.current = null;
    };

    window.addEventListener('mousemove', handleWindowMouseMove);
    window.addEventListener('mouseup', handleWindowMouseUp);
    return () => {
      window.removeEventListener('mousemove', handleWindowMouseMove);
      window.removeEventListener('mouseup', handleWindowMouseUp);
    };
  }, [arrastandoPainel, maxX, maxY]);

  const toggleAberto = () => {
    if (moveuDuranteCliqueRef.current) {
      moveuDuranteCliqueRef.current = false;
      return;
    }
    setAberto((prev) => {
      const next = !prev;
      try {
        localStorage.setItem('arvore-minimapa-aberto', String(next));
      } catch {}
      return next;
    });
  };

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
    e.stopPropagation();
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
      <div
        ref={painelRef}
        style={{ left: `${posX}px`, top: `${posY}px` }}
        className={`absolute z-30 ${className}`}
      >
        <button
          type="button"
          onMouseDown={iniciarArrastePainel}
          onClick={toggleAberto}
          className="p-2.5 bg-card/95 hover:bg-card backdrop-blur-md border border-borda shadow-sombra rounded-full text-tinta2 hover:text-acento cursor-grab active:cursor-grabbing transition-transform hover:scale-105"
          title={`${t('arvore', 'minimapaAbrir')} (arraste para mover)`}
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
      ref={painelRef}
      style={{ width: `${LARGURA_MINIMAPA}px`, left: `${posX}px`, top: `${posY}px` }}
      className={`absolute z-30 bg-card/95 backdrop-blur-md border border-borda shadow-sombra rounded-raio overflow-hidden select-none ${
        arrastandoPainel ? 'ring-2 ring-acento/50 shadow-lg' : ''
      } ${className}`}
    >
      {/* Cabeçalho Arrastável do Minimapa */}
      <div
        onMouseDown={iniciarArrastePainel}
        title="Arraste para mover o Radar da Árvore"
        className="flex items-center justify-between px-2.5 py-1.5 border-b border-borda/60 bg-sup/70 hover:bg-sup text-[11px] text-tinta font-semibold cursor-grab active:cursor-grabbing transition-colors"
      >
        <div className="flex items-center gap-1.5">
          <GripHorizontal className="w-3.5 h-3.5 text-tinta3 flex-none" />
          <Compass className="w-3.5 h-3.5 text-acento flex-none" />
          <span>{t('arvore', 'radarTitulo')}</span>
          <span className="text-[10px] text-tinta2 font-normal font-num ml-0.5">
            ({layout.pessoas.length})
          </span>
        </div>
        <button
          type="button"
          onMouseDown={(e) => e.stopPropagation()}
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
