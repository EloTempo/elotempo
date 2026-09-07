import React, { useEffect, useRef, useState } from 'react';
import { ChevronDown } from 'lucide-react';
import { Button, cn } from './Button';

export interface DropdownMenuItem {
  id: string;
  rotulo: string;
  descricao?: string;
  icone?: React.ReactNode;
  onClick: () => void;
  destaque?: boolean;
  separadorApos?: boolean;
}

interface DropdownMenuProps {
  rotulo: string;
  icone?: React.ReactNode;
  items: DropdownMenuItem[];
  alinhamento?: 'esquerda' | 'direita';
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost';
  size?: 'sm' | 'md';
  title?: string;
  className?: string;
}

export function DropdownMenu({
  rotulo,
  icone,
  items,
  alinhamento = 'esquerda',
  variant = 'secondary',
  size = 'sm',
  title,
  className,
}: DropdownMenuProps) {
  const [aberto, setAberto] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!aberto) return;

    const aoClicarFora = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setAberto(false);
      }
    };

    const aoPressionarTecla = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        setAberto(false);
      }
    };

    document.addEventListener('mousedown', aoClicarFora);
    document.addEventListener('keydown', aoPressionarTecla);
    return () => {
      document.removeEventListener('mousedown', aoClicarFora);
      document.removeEventListener('keydown', aoPressionarTecla);
    };
  }, [aberto]);

  return (
    <div ref={containerRef} className={cn('relative inline-block text-left flex-none', className)}>
      <Button
        size={size}
        variant={variant}
        onClick={() => setAberto((prev) => !prev)}
        title={title}
        className={cn('flex items-center gap-1.5 font-medium', aberto && 'bg-sup text-tinta border-acento')}
      >
        {icone}
        <span>{rotulo}</span>
        <ChevronDown className={cn('w-3.5 h-3.5 text-tinta3 transition-transform duration-150', aberto && 'rotate-180 text-tinta')} />
      </Button>

      {aberto && (
        <div
          className={cn(
            'absolute z-50 mt-1 min-w-[220px] max-w-[300px] rounded-raio bg-card border border-borda shadow-sombra py-1 animate-in fade-in zoom-in-95 duration-100',
            alinhamento === 'direita' ? 'right-0' : 'left-0'
          )}
          role="menu"
        >
          {items.map((item) => (
            <React.Fragment key={item.id}>
              <button
                type="button"
                role="menuitem"
                onClick={() => {
                  setAberto(false);
                  item.onClick();
                }}
                className={cn(
                  'w-full text-left px-3 py-2 text-xs flex items-start gap-2.5 transition-colors cursor-pointer hover:bg-sup text-tinta group',
                  item.destaque && 'text-acento font-semibold'
                )}
              >
                {item.icone && (
                  <span className="w-4 h-4 flex-none mt-0.5 text-tinta3 group-hover:text-acento transition-colors">
                    {item.icone}
                  </span>
                )}
                <div className="flex-1 min-w-0">
                  <span className="block font-semibold truncate leading-tight">
                    {item.rotulo}
                  </span>
                  {item.descricao && (
                    <span className="block text-[10.5px] text-tinta3 leading-tight mt-0.5 whitespace-normal">
                      {item.descricao}
                    </span>
                  )}
                </div>
              </button>
              {item.separadorApos && <div className="h-px bg-borda my-1" />}
            </React.Fragment>
          ))}
        </div>
      )}
    </div>
  );
}
