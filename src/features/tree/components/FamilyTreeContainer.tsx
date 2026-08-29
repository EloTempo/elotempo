import { useEffect, useRef } from 'react';
import { useQuery } from '@tanstack/react-query';
import { getTreeGraph } from '../../../lib/api/tree';
import { renderTree } from '../../../lib/d3/treeRenderer'; // A engine pura do D3

export function FamilyTreeContainer({ raizId }: { raizId: string }) {
  const svgRef = useRef<SVGSVGElement>(null);

  const { data: treeGraph, isLoading } = useQuery({
    queryKey: ['tree', raizId],
    queryFn: () => getTreeGraph(raizId, 4),
    staleTime: 1000 * 60 * 5, // Cache de 5 minutos para eficiência
  });

  useEffect(() => {
    // O React "solta" o controle aqui e entrega o SVG para o D3
    if (treeGraph && svgRef.current) {
      renderTree(svgRef.current, treeGraph, (p) => console.log('Clicou', p.nome));
    }
  }, [treeGraph]); // Só re-renderiza o D3 se o grafo inteiro mudar

  if (isLoading) return <div className="text-tinta2">Calculando grafo...</div>;

  return (
    <div className="w-full h-full bg-bg relative overflow-hidden">
      <svg ref={svgRef} className="absolute inset-0 w-full h-full touch-manipulation" />
    </div>
  );
}