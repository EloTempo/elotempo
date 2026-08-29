import * as d3 from 'd3';
import type { PersonNode, UnionNode } from '../../types';

// O D3 precisa de uma estrutura de dados de grafo contendo nós (pessoas e uniões) e links.
interface TreeData {
  nodes: PersonNode[];
  unions: UnionNode[];
  links: any[]; // Links with object source/target after D3 binding
}

export function renderTree(
  svgElement: SVGSVGElement, 
  data: TreeData, 
  onNodeClick: (person: PersonNode) => void
) {
  const svg = d3.select(svgElement);
  svg.selectAll('*').remove(); // Limpa renderizações anteriores

  const width = svgElement.clientWidth;
  const height = svgElement.clientHeight;

  // 1. Criação do container principal e aplicação de Pan/Zoom
  const container = svg.append('g').attr('class', 'tree-container');

  const zoom = d3.zoom<SVGSVGElement, unknown>()
    .scaleExtent([0.2, 2.5]) // Limites de zoom: 20% a 250%
    .on('zoom', (event) => {
      container.attr('transform', event.transform);
      
      // Zoom Semântico: Ajusta classes no container para o CSS do Tailwind agir
      const scale = event.transform.k;
      container.classed('zoom-semantic-low', scale <= 0.5);   // < 50%: só nome
      container.classed('zoom-semantic-mid', scale > 0.5 && scale < 1.2); // 72%: foto e nome
      container.classed('zoom-semantic-high', scale >= 1.2);  // 150%: detalhes completos
    });

  svg.call(zoom);
  
  // Posicionamento inicial centralizado
  svg.call(zoom.transform, d3.zoomIdentity.translate(width / 2, height / 4).scale(0.8));

  // 2. Desenho das Linhas de Parentesco (Paths)
  // As linhas vão sempre de um Pai/Mãe -> União, e da União -> Filhos.
  container.append('g')
    .attr('class', 'links')
    .selectAll('path')
    .data(data.links)
    .join('path')
    .attr('d', (d: any) => drawOrthogonalPath(d.source, d.target))
    .attr('stroke', 'var(--linha)') // Variável CSS global definida no tema
    .attr('stroke-width', 2)
    .attr('fill', 'none');

  // 3. Desenho das Uniões (Anéis)
  // Cada união recebe seu marcador: preenchido (casamento), vazado (estável), etc.
  container.append('g')
    .attr('class', 'unions')
    .selectAll('g')
    .data(data.unions)
    .join('g')
    .attr('transform', d => `translate(${d.x}, ${d.y})`)
    .each(function(d: any) {
      const g = d3.select(this);
      g.append('circle')
        .attr('r', 15)
        .attr('stroke', 'var(--anel)') // Cor semântica do tema
        .attr('stroke-width', 2)
        .attr('fill', d.estado_vinculo === 'casamento' ? 'var(--anel)' : 'var(--bg)');
      
      g.append('text')
        .attr('y', -25)
        .attr('text-anchor', 'middle')
        .attr('class', 'text-[10.5px] font-num text-tinta2') // Classes Tailwind mapeadas
        .text(`⚭ ${d.data_casamento || ''}`);
    });

  // 4. Desenho dos Nós de Pessoas (via foreignObject)
  const nodeWidth = 240;
  const nodeHeight = 70;

  const nodeGroup = container.append('g')
    .attr('class', 'nodes')
    .selectAll('foreignObject')
    .data(data.nodes)
    .join('foreignObject')
    .attr('width', nodeWidth)
    .attr('height', nodeHeight)
    // Centraliza o foreignObject sobre a coordenada x,y calculada
    .attr('x', d => (d.x || 0) - nodeWidth / 2)
    .attr('y', d => (d.y || 0) - nodeHeight / 2)
    .on('click', (event, d) => {
      event.stopPropagation();
      onNodeClick(d as PersonNode);
    });

  // O HTML interno usa classes utilitárias configuradas previamente
  nodeGroup.append('xhtml:div')
    .attr('class', 'w-full h-full cursor-pointer touch-manipulation')
    .html((d: any) => `
      <div class="flex items-center gap-2 p-2 bg-card border border-borda2 rounded-raio shadow-sombra node-content">
        <div class="w-1 h-8 rounded-sm ${getSexColorClass(d.sexo)} flex-none"></div>
        <div class="flex flex-col gap-0.5 flex-1 min-w-0">
          <span class="font-tit font-fw7 text-[13.5px] text-tinta truncate">${d.nome}</span>
          <span class="font-num text-[11px] text-tinta2 detail-text">n. ${d.ano_nascimento || 's/d'}</span>
        </div>
      </div>
    `);
}

// Funções auxiliares SVG e Layout
function drawOrthogonalPath(s: {x: number, y: number}, t: {x: number, y: number}) {
  return `M ${s.x} ${s.y} L ${s.x} ${(s.y + t.y) / 2} L ${t.x} ${(s.y + t.y) / 2} L ${t.x} ${t.y}`;
}

function getSexColorClass(sexo: string) {
  if (sexo === 'M') return 'bg-masc';
  if (sexo === 'F') return 'bg-fem';
  if (sexo === 'X') return 'bg-gradient-to-b from-masc to-fem'; // X recebe faixa dividida
  return 'border border-dashed border-borda2 bg-transparent'; // U recebe pontilhado
}