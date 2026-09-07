import type { ContagemItem } from '../../lib/api';

interface GraficoBarrasProps {
  itens: ContagemItem[];
  totalGeral: number;
  titulo?: string;
  corBarra?: string;
  className?: string;
  limite?: number;
}

export function GraficoBarras({
  itens,
  totalGeral,
  titulo,
  corBarra = 'var(--acento)',
  className = '',
  limite = 10,
}: GraficoBarrasProps) {
  const validos = itens.filter((i) => i.contagem > 0).slice(0, limite);
  const maximo = Math.max(1, ...validos.map((i) => i.contagem));

  if (validos.length === 0) {
    return (
      <div className={`p-4 text-center text-xs text-tinta3 italic bg-sup/40 rounded-raio-s border border-borda/60 ${className}`}>
        {titulo && <span className="block font-semibold not-italic mb-1 text-tinta2">{titulo}</span>}
        Nenhum dado registrado para esta categoria.
      </div>
    );
  }

  return (
    <div className={`flex flex-col gap-2 p-3 bg-card border border-borda rounded-raio shadow-xs ${className}`}>
      {titulo && (
        <h4 className="text-xs font-semibold text-tinta uppercase tracking-wide m-0 border-b border-borda/40 pb-1.5 flex items-center justify-between">
          <span>{titulo}</span>
          <span className="text-[10px] text-tinta3 lowercase font-normal">
            top {validos.length}
          </span>
        </h4>
      )}

      <div className="flex flex-col gap-2 pt-1">
        {validos.map((item) => {
          const larguraPct = Math.max(4, (item.contagem / maximo) * 100);

          return (
            <div key={item.chave} className="flex flex-col gap-0.5">
              <div className="flex items-baseline justify-between text-xs">
                <span className="font-medium text-tinta truncate max-w-[60%]" title={item.rotulo}>
                  {item.rotulo}
                </span>

                {/* Contagem absoluta junto do percentual: "6 de 12 · 50%" */}
                <span className="font-num text-[11px] text-tinta2 flex-none">
                  <strong className="text-tinta">{item.contagem}</strong> de {totalGeral} · {item.percentual}%
                </span>
              </div>

              {/* Barra Proporcional */}
              <div className="h-2 w-full bg-sup rounded-full overflow-hidden">
                <div
                  className="h-full rounded-full transition-all duration-300"
                  style={{
                    width: `${larguraPct}%`,
                    background: corBarra,
                    opacity: 0.85,
                  }}
                />
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
