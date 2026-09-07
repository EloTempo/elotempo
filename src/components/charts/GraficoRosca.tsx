import { useState } from 'react';
import type { ContagemItem } from '../../lib/api';

interface GraficoRoscaProps {
  itens: ContagemItem[];
  totalGeral: number;
  titulo?: string;
  className?: string;
}

// Cores harmoniosas do projeto: editorial, neutros quentes e acentos
const CORES = [
  'var(--acento)', // Vinho / Acento
  '#4a7c59',       // Verde folha
  '#3d5a80',       // Azul clássico
  '#d4a373',       // Caramelo / Bronze
  '#9d8189',       // Malva
  '#e07a5f',       // Terracota
  '#6b705c',       // Oliva
  '#b7b7a4',       // Sálvia
  '#8d99ae',       // Ardósia
];

export function GraficoRosca({ itens, totalGeral, titulo, className = '' }: GraficoRoscaProps) {
  const [itemAtivo, setItemAtivo] = useState<string | null>(null);

  // Filtra itens com contagem > 0
  const validos = itens.filter((i) => i.contagem > 0);
  const totalValidos = validos.reduce((acc, i) => acc + i.contagem, 0);

  if (validos.length === 0 || totalValidos === 0) {
    return (
      <div className={`p-4 text-center text-xs text-tinta3 italic bg-sup/40 rounded-raio-s border border-borda/60 ${className}`}>
        {titulo && <span className="block font-semibold not-italic mb-1 text-tinta2">{titulo}</span>}
        Nenhum dado registrado para esta categoria.
      </div>
    );
  }

  // Raio e centro do SVG
  const raioExterno = 65;
  const raioInterno = 40;
  const centro = 75;

  let anguloAcumulado = 0;
  const fatias = validos.map((item, idx) => {
    const fracao = item.contagem / totalValidos;
    const angulo = fracao * 2 * Math.PI;
    const inicio = anguloAcumulado;
    const fim = anguloAcumulado + angulo;
    anguloAcumulado = fim;

    // Coordenadas das bordas
    const x1Ext = centro + raioExterno * Math.sin(inicio);
    const y1Ext = centro - raioExterno * Math.cos(inicio);
    const x2Ext = centro + raioExterno * Math.sin(fim);
    const y2Ext = centro - raioExterno * Math.cos(fim);

    const x1Int = centro + raioInterno * Math.sin(inicio);
    const y1Int = centro - raioInterno * Math.cos(inicio);
    const x2Int = centro + raioInterno * Math.sin(fim);
    const y2Int = centro - raioInterno * Math.cos(fim);

    const arcoGrande = angulo > Math.PI ? 1 : 0;

    const pathData =
      fracao >= 0.999
        ? `M ${centro} ${centro - raioExterno}
           A ${raioExterno} ${raioExterno} 0 1 1 ${centro - 0.01} ${centro - raioExterno}
           L ${centro - 0.01} ${centro - raioInterno}
           A ${raioInterno} ${raioInterno} 0 1 0 ${centro} ${centro - raioInterno}
           Z`
        : `M ${x1Ext} ${y1Ext}
           A ${raioExterno} ${raioExterno} 0 ${arcoGrande} 1 ${x2Ext} ${y2Ext}
           L ${x2Int} ${y2Int}
           A ${raioInterno} ${raioInterno} 0 ${arcoGrande} 0 ${x1Int} ${y1Int}
           Z`;

    const cor = CORES[idx % CORES.length];
    return { ...item, pathData, cor };
  });

  const selecionado = itemAtivo ? fatias.find((f) => f.chave === itemAtivo) : null;

  return (
    <div className={`flex flex-col gap-2 p-3 bg-card border border-borda rounded-raio shadow-xs ${className}`}>
      {titulo && (
        <h4 className="text-xs font-semibold text-tinta uppercase tracking-wide m-0 border-b border-borda/40 pb-1.5">
          {titulo}
        </h4>
      )}

      <div className="flex flex-col sm:flex-row items-center gap-4">
        {/* Gráfico Donut SVG */}
        <div className="relative flex-none w-[150px] h-[150px]">
          <svg width="150" height="150" viewBox="0 0 150 150" className="overflow-visible">
            {fatias.map((fatia) => {
              const isAtivo = itemAtivo === fatia.chave;
              return (
                <path
                  key={fatia.chave}
                  d={fatia.pathData}
                  fill={fatia.cor}
                  stroke="var(--bg)"
                  strokeWidth="2"
                  className="transition-all duration-200 cursor-pointer hover:opacity-90"
                  style={{
                    transform: isAtivo ? 'scale(1.05)' : 'scale(1)',
                    transformOrigin: `${centro}px ${centro}px`,
                    filter: isAtivo ? 'drop-shadow(0 2px 4px rgba(0,0,0,0.15))' : undefined,
                  }}
                  onMouseEnter={() => setItemAtivo(fatia.chave)}
                  onMouseLeave={() => setItemAtivo(null)}
                />
              );
            })}
          </svg>

          {/* Núcleo central da rosca com resumo */}
          <div className="absolute inset-0 flex flex-col items-center justify-center pointer-events-none text-center px-2">
            {selecionado ? (
              <>
                <span className="font-num text-sm font-bold text-tinta leading-none">
                  {selecionado.percentual}%
                </span>
                <span className="text-[10px] text-tinta3 font-num truncate max-w-[70px]">
                  {selecionado.contagem} {selecionado.contagem === 1 ? 'pessoa' : 'pessoas'}
                </span>
              </>
            ) : (
              <>
                <span className="font-num text-xs font-bold text-tinta leading-none">
                  {totalValidos}
                </span>
                <span className="text-[9px] text-tinta3 leading-tight">amostra</span>
              </>
            )}
          </div>
        </div>

        {/* Legenda com o formato obrigatório: "X de Y · Z%" */}
        <div className="flex-1 min-w-0 w-full flex flex-col gap-1 max-h-40 overflow-y-auto">
          {fatias.map((fatia) => {
            const isAtivo = itemAtivo === fatia.chave;
            return (
              <div
                key={fatia.chave}
                onMouseEnter={() => setItemAtivo(fatia.chave)}
                onMouseLeave={() => setItemAtivo(null)}
                className={`flex items-center justify-between text-xs px-2 py-1 rounded transition-colors cursor-pointer ${
                  isAtivo ? 'bg-sup font-semibold' : 'hover:bg-sup/50'
                }`}
              >
                <div className="flex items-center gap-1.5 min-w-0 truncate">
                  <span
                    className="w-2.5 h-2.5 rounded-full flex-none"
                    style={{ background: fatia.cor }}
                  />
                  <span className="truncate text-tinta">{fatia.rotulo}</span>
                </div>

                <span className="font-num text-[11px] text-tinta2 flex-none ml-2">
                  <strong className="text-tinta">{fatia.contagem}</strong> de {totalGeral} · {fatia.percentual}%
                </span>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
