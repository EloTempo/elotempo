import { useEffect, useRef } from 'react';
import { renderTree } from '../../lib/d3/treeRenderer';
import type { TreeGraph, PersonNode } from '../../types';

interface TreeGraphViewerProps {
  data: TreeGraph | null;
  onPersonClick: (person: PersonNode) => void;
}

export function TreeGraphViewer({ data, onPersonClick }: TreeGraphViewerProps) {
  const svgRef = useRef<SVGSVGElement>(null);

  useEffect(() => {
    if (!svgRef.current || !data) return;
    
    // Na vida real, precisaríamos calcular o layout X e Y aqui
    // usando d3-dag ou um algoritmo customizado de linhagem.
    // Para simplificar a POC, vamos distribuir na tela manualmente se não tiverem x/y:
    const nodes = data.nodes.map((n, i) => ({
      ...n,
      x: n.x ?? 300 + (i % 3) * 260,
      y: n.y ?? 100 + Math.floor(i / 3) * 120
    }));

    const unions = data.unions.map((u, i) => ({
      ...u,
      x: u.x ?? 430 + (i % 2) * 260,
      y: u.y ?? 160 + Math.floor(i / 2) * 120
    }));

    const links = data.links.map(l => {
      const sourceNode = nodes.find(n => n.id === l.source) || unions.find(u => u.id === l.source);
      const targetNode = nodes.find(n => n.id === l.target) || unions.find(u => u.id === l.target);
      return {
        ...l,
        source: sourceNode,
        target: targetNode,
      };
    }).filter(l => l.source && l.target); // Filtra links quebrados

    renderTree(
      svgRef.current,
      { nodes, unions, links },
      onPersonClick as any
    );
  }, [data, onPersonClick]);

  if (!data) {
    return (
      <div className="w-full h-full flex items-center justify-center text-tinta3">
        Carregando árvore...
      </div>
    );
  }

  return (
    <div className="w-full h-[600px] border border-borda rounded-raio overflow-hidden bg-mesa">
      <svg ref={svgRef} className="w-full h-full" />
    </div>
  );
}
