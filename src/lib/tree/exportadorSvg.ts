/**
 * Gerador de SVG Nativo e Standalone para Pôster e Impressão de Árvore Genealógica.
 *
 * Gera um SVG 100% puro e autônomo, sem dependência de classes Tailwind ou foreignObject,
 * permitindo abrir e editar em qualquer programa vetorial (Illustrator, Inkscape, CorelDraw)
 * ou rasterizar em ultra resolução (PNG 300 DPI) para impressão gráfica.
 */

import { METRICAS, caminhoOrtogonal, type LayoutArvore } from './layout';

export type TemaPoster = 'pergaminho' | 'branco' | 'escuro';

export interface ConfiguracaoPoster {
  titulo: string;
  subtitulo?: string;
  tema: TemaPoster;
  incluirDatas?: boolean;
  incluirCasamentos?: boolean;
  incluirMoldura?: boolean;
}

interface PaletaCores {
  fundo: string;
  moldura: string;
  ornamento: string;
  titulo: string;
  subtitulo: string;
  linhaRamo: string;
  linhaRamoNaoBio: string;
  anelStroke: string;
  anelFill: string;
  anelTexto: string;
  cardFundo: string;
  cardBorda: string;
  cardSombra: string;
  nomeTexto: string;
  sobrenomeTexto: string;
  datasTexto: string;
  corMasc: string;
  corFem: string;
  corOutro: string;
}

const PALETAS: Record<TemaPoster, PaletaCores> = {
  pergaminho: {
    fundo: '#f5efe3',
    moldura: '#bfae8e',
    ornamento: '#8a6839',
    titulo: '#2c2214',
    subtitulo: '#69553c',
    linhaRamo: '#998668',
    linhaRamoNaoBio: '#a39275',
    anelStroke: '#8a6839',
    anelFill: '#f5efe3',
    anelTexto: '#69553c',
    cardFundo: '#fdfbf6',
    cardBorda: '#c4b597',
    cardSombra: 'rgba(58, 49, 37, 0.08)',
    nomeTexto: '#241e16',
    sobrenomeTexto: '#4d3f2d',
    datasTexto: '#736148',
    corMasc: '#345579',
    corFem: '#933e4f',
    corOutro: '#b3986c',
  },
  branco: {
    fundo: '#ffffff',
    moldura: '#d1d5db',
    ornamento: '#4b5563',
    titulo: '#111827',
    subtitulo: '#4b5563',
    linhaRamo: '#9ca3af',
    linhaRamoNaoBio: '#9ca3af',
    anelStroke: '#6b7280',
    anelFill: '#ffffff',
    anelTexto: '#4b5563',
    cardFundo: '#ffffff',
    cardBorda: '#e5e7eb',
    cardSombra: 'rgba(0, 0, 0, 0.04)',
    nomeTexto: '#111827',
    sobrenomeTexto: '#374151',
    datasTexto: '#6b7280',
    corMasc: '#2563eb',
    corFem: '#db2777',
    corOutro: '#6b7280',
  },
  escuro: {
    fundo: '#181512',
    moldura: '#3d3428',
    ornamento: '#cbb387',
    titulo: '#f5ede0',
    subtitulo: '#b8a68f',
    linhaRamo: '#665643',
    linhaRamoNaoBio: '#665643',
    anelStroke: '#cbb387',
    anelFill: '#181512',
    anelTexto: '#cbb387',
    cardFundo: '#25201a',
    cardBorda: '#443a2d',
    cardSombra: 'rgba(0, 0, 0, 0.4)',
    nomeTexto: '#f5ede0',
    sobrenomeTexto: '#d6c8b4',
    datasTexto: '#a1937f',
    corMasc: '#60a5fa',
    corFem: '#f472b6',
    corOutro: '#cbb387',
  },
};

function escaparXml(texto: string): string {
  return texto
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;');
}

function formatarAno(ano?: number | null): string {
  if (ano == null) return '';
  if (ano < 0) return `${Math.abs(ano)} a.C.`;
  if (ano > 0 && ano <= 100) return `${ano} d.C.`;
  return String(ano);
}

function formatarDatas(nasc?: number | null, falec?: number | null, isVivo?: boolean): string {
  if (nasc == null && falec == null) return '';
  if (nasc != null && falec != null) {
    const idade = falec - nasc;
    return `* ${formatarAno(nasc)}  ✝ ${formatarAno(falec)} (${idade}a)`;
  }
  if (nasc != null) {
    return isVivo ? `* ${formatarAno(nasc)} (vivo)` : `* ${formatarAno(nasc)}`;
  }
  return `✝ ${formatarAno(falec)}`;
}

/**
 * Gera um documento SVG standalone completo da árvore para pôster ou exportação.
 */
export function gerarSvgArvore(layout: LayoutArvore, config: ConfiguracaoPoster): string {
  const paleta = PALETAS[config.tema] ?? PALETAS.pergaminho;
  const incluirDatas = config.incluirDatas ?? true;
  const incluirCasamentos = config.incluirCasamentos ?? true;
  const incluirMoldura = config.incluirMoldura ?? true;

  const margemCabecalho = config.titulo ? 160 : 60;
  const margemLateral = 80;
  const margemInferior = 80;

  const larguraConteudo = layout.largura;
  const alturaConteudo = layout.altura;

  const larguraTotal = Math.max(larguraConteudo + margemLateral * 2, 980);
  const alturaTotal = alturaConteudo + margemCabecalho + margemInferior;

  const deslocX = (larguraTotal - larguraConteudo) / 2;
  const deslocY = margemCabecalho;

  const svgParts: string[] = [];

  // Cabeçalho do SVG
  svgParts.push(`<?xml version="1.0" encoding="UTF-8"?>`);
  svgParts.push(
    `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${larguraTotal} ${alturaTotal}" width="${larguraTotal}" height="${alturaTotal}">`
  );

  // Definições de estilos e filtros
  svgParts.push(`  <defs>
    <style>
      .fonte-serif { font-family: 'Libre Baskerville', Georgia, 'Times New Roman', serif; }
      .fonte-sans { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; }
    </style>
  </defs>`);

  // Fundo Total
  svgParts.push(
    `  <rect width="${larguraTotal}" height="${alturaTotal}" fill="${paleta.fundo}" />`
  );

  // Moldura Decorativa do Pôster
  if (incluirMoldura) {
    const m = 24;
    const m2 = 30;
    svgParts.push(
      `  <rect x="${m}" y="${m}" width="${larguraTotal - m * 2}" height="${alturaTotal - m * 2}" fill="none" stroke="${paleta.moldura}" stroke-width="1.5" />`
    );
    svgParts.push(
      `  <rect x="${m2}" y="${m2}" width="${larguraTotal - m2 * 2}" height="${alturaTotal - m2 * 2}" fill="none" stroke="${paleta.moldura}" stroke-width="0.75" opacity="0.6" />`
    );

    // Cantoneiras nos 4 cantos
    const cTam = 18;
    // Canto superior esquerdo
    svgParts.push(
      `  <path d="M${m2},${m2 + cTam} L${m2},${m2} L${m2 + cTam},${m2}" fill="none" stroke="${paleta.ornamento}" stroke-width="2.5" />`
    );
    // Canto superior direito
    svgParts.push(
      `  <path d="M${larguraTotal - m2 - cTam},${m2} L${larguraTotal - m2},${m2} L${larguraTotal - m2},${m2 + cTam}" fill="none" stroke="${paleta.ornamento}" stroke-width="2.5" />`
    );
    // Canto inferior esquerdo
    svgParts.push(
      `  <path d="M${m2},${alturaTotal - m2 - cTam} L${m2},${alturaTotal - m2} L${m2 + cTam},${alturaTotal - m2}" fill="none" stroke="${paleta.ornamento}" stroke-width="2.5" />`
    );
    // Canto inferior direito
    svgParts.push(
      `  <path d="M${larguraTotal - m2 - cTam},${alturaTotal - m2} L${larguraTotal - m2},${alturaTotal - m2} L${larguraTotal - m2},${alturaTotal - m2 - cTam}" fill="none" stroke="${paleta.ornamento}" stroke-width="2.5" />`
    );
  }

  // Cabeçalho Artístico
  if (config.titulo) {
    const centroX = larguraTotal / 2;
    svgParts.push(`  <g id="cabecalho-poster">`);
    svgParts.push(
      `    <text x="${centroX}" y="76" text-anchor="middle" font-size="28" font-weight="bold" fill="${paleta.titulo}" class="fonte-serif">${escaparXml(config.titulo)}</text>`
    );

    if (config.subtitulo) {
      svgParts.push(
        `    <text x="${centroX}" y="104" text-anchor="middle" font-size="13" fill="${paleta.subtitulo}" class="fonte-sans" opacity="0.9">${escaparXml(config.subtitulo)}</text>`
      );
    }

    // Linha de divisor decorativa
    const larguraDiv = Math.min(larguraTotal * 0.4, 380);
    const divY = config.subtitulo ? 122 : 98;
    svgParts.push(
      `    <line x1="${centroX - larguraDiv / 2}" y1="${divY}" x2="${centroX + larguraDiv / 2}" y2="${divY}" stroke="${paleta.ornamento}" stroke-width="1.2" opacity="0.6" />`
    );
    svgParts.push(
      `    <circle cx="${centroX}" cy="${divY}" r="3.5" fill="${paleta.ornamento}" />`
    );
    svgParts.push(`  </g>`);
  }

  // Grupo do Conteúdo da Árvore
  svgParts.push(`  <g id="arvore-conteudo" transform="translate(${deslocX}, ${deslocY})">`);

  // 1. Arestas / Conexões
  svgParts.push(`    <g id="arestas" fill="none">`);
  for (const a of layout.arestas) {
    const isNaoBio = a.tipoVinculo && a.tipoVinculo !== 'biologico';
    const corAresta = isNaoBio ? paleta.linhaRamoNaoBio : paleta.linhaRamo;
    const dash = isNaoBio ? `stroke-dasharray="6,4"` : '';
    svgParts.push(
      `      <path d="${caminhoOrtogonal(a.origem, a.destino)}" stroke="${corAresta}" stroke-width="2" ${dash} stroke-linecap="round" stroke-linejoin="round" />`
    );
  }
  svgParts.push(`    </g>`);

  // 2. Anéis das Uniões
  svgParts.push(`    <g id="unioes">`);
  for (const u of layout.unioes) {
    const preenchido = u.estado_vinculo === 'casamento';
    const tracejado = u.estado_vinculo === 'dissolvida' ? `stroke-dasharray="4,3"` : '';

    svgParts.push(`      <g transform="translate(${u.x}, ${u.y})">`);
    svgParts.push(
      `        <circle r="13" fill="${preenchido ? paleta.anelStroke : paleta.anelFill}" stroke="${paleta.anelStroke}" stroke-width="2" ${tracejado} />`
    );

    if (incluirCasamentos && u.ano_casamento != null) {
      svgParts.push(
        `        <text y="-20" text-anchor="middle" font-size="10.5" fill="${paleta.anelTexto}" class="fonte-serif font-num">⚭ ${u.ano_casamento}</text>`
      );
    }
    svgParts.push(`      </g>`);
  }
  svgParts.push(`    </g>`);

  // 3. Cartões das Pessoas (Renderizados em SVG nativo e puro)
  svgParts.push(`    <g id="pessoas">`);
  const cardLargura = METRICAS.larguraNo;
  const cardAltura = METRICAS.alturaNo;

  for (const p of layout.pessoas) {
    const cx = p.x - cardLargura / 2;
    const cy = p.y - cardAltura / 2;

    const corSexo =
      p.sexo === 'M' ? paleta.corMasc : p.sexo === 'F' ? paleta.corFem : paleta.corOutro;

    const datasTexto = incluirDatas
      ? formatarDatas(p.ano_nascimento, p.ano_falecimento, p.is_vivo)
      : '';

    svgParts.push(`      <g transform="translate(${cx}, ${cy})">`);

    // Retângulo de fundo do cartão
    svgParts.push(
      `        <rect width="${cardLargura}" height="${cardAltura}" rx="8" ry="8" fill="${paleta.cardFundo}" stroke="${paleta.cardBorda}" stroke-width="1.2" />`
    );

    // Barra indicadora de sexo na esquerda
    svgParts.push(
      `        <path d="M0,8 Q0,0 8,0 L12,0 L12,${cardAltura} L8,${cardAltura} Q0,${cardAltura} 0,${cardAltura - 8} Z" fill="${corSexo}" />`
    );

    // Nome e Sobrenome
    const nomeCompleto = `${p.nome}${p.sobrenome ? ' ' + p.sobrenome : ''}`;
    const textoPrincipal = p.is_placeholder ? 'Pessoa Desconhecida' : nomeCompleto;

    // Se tiver datas ou biografia, distribui verticalmente na altura do cartão (cardAltura = 96)
    const yNome = datasTexto ? 34 : 52;

    svgParts.push(
      `        <text x="22" y="${yNome}" font-size="13.5" font-weight="bold" fill="${paleta.nomeTexto}" class="fonte-serif">${escaparXml(textoPrincipal)}</text>`
    );

    // Datas de nascimento / falecimento
    if (datasTexto) {
      svgParts.push(
        `        <text x="22" y="54" font-size="11" fill="${paleta.datasTexto}" class="fonte-sans" opacity="0.9">${escaparXml(datasTexto)}</text>`
      );
    }

    // Minibiografia quando presente
    if (p.minibiografia) {
      const bioCurta = p.minibiografia.length > 40 ? p.minibiografia.slice(0, 38) + '...' : p.minibiografia;
      svgParts.push(
        `        <text x="22" y="74" font-size="10.5" font-style="italic" fill="${paleta.datasTexto}" class="fonte-sans" opacity="0.75">${escaparXml(bioCurta)}</text>`
      );
    }

    svgParts.push(`      </g>`);
  }
  svgParts.push(`    </g>`);

  svgParts.push(`  </g>`);
  svgParts.push(`</svg>`);

  return svgParts.join('\n');
}
