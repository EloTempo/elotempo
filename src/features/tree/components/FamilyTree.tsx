import { useEffect, useRef } from 'react';
import { renderTree } from '../../../lib/d3/treeRenderer';
import { useQuery } from '@tanstack/react-query';
import { getTreeGraph } from '../../../lib/api/tree';
import type { PersonNode } from '../../../types';

interface FamilyTreeProps {
  rootPersonId: string;
  onOpenDetails: (personId: string) => void;
}

export function FamilyTree({ rootPersonId, onOpenDetails }: FamilyTreeProps) {
  const svgRef = useRef<SVGSVGElement | null>(null);
  const containerRef = useRef<HTMLDivElement | null>(null);

  // Busca os nós, uniões e conexões pré-calculados do banco local SQLite via Tauri
  const { data, isLoading, isError } = useQuery({
    queryKey: ['familyTree', rootPersonId],
    queryFn: () => getTreeGraph(rootPersonId)
  });

  useEffect(() => {
    if (!data || !svgRef.current) return;

    // Dispara a renderização do D3, passando a função de callback do React
    renderTree(svgRef.current, data, (person: PersonNode) => {
      onOpenDetails(person.id);
    });

    // Função de limpeza opcional para listeners customizados
    return () => {
      if (svgRef.current) {
        svgRef.current.innerHTML = ''; 
      }
    };
  }, [data, onOpenDetails]);

  if (isLoading) {
    return (
      <div className="flex-1 flex items-center justify-center bg-bg">
        <span className="font-num text-tinta3 text-sm">Carregando acervo...</span>
      </div>
    );
  }

  if (isError || !data) {
    return (
      <div className="flex-1 flex items-center justify-center bg-bg">
        <span className="font-corpo text-fem text-sm font-fw6">
          Erro ao processar o grafo da árvore.
        </span>
      </div>
    );
  }

  return (
    <div ref={containerRef} className="relative w-full h-full bg-bg overflow-hidden">
      {/* Background com grid pattern que acompanha o pan/zoom opcionalmente */}
      <div className="absolute inset-0 bg-[radial-gradient(var(--borda)_1px,transparent_1px)] bg-[size:26px_26px] opacity-50 pointer-events-none"></div>
      
      {/* Container nativo que o D3 assumirá controle */}
      <svg 
        ref={svgRef} 
        className="absolute inset-0 w-full h-full touch-manipulation cursor-grab active:cursor-grabbing"
      />
    </div>
  );
}