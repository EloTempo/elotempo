import type { Marco } from '../../lib/api';
import { converterDataParaAnoFracionario } from './ordenacaoTrilhas';

export interface MarcoComPosicao {
  marco: Marco;
  numeroNaFolha: number;
  anoInicioFrac: number;
  pctX: number;
  pxX: number;
  ehIntervalo: boolean;
  larguraBarraPct: number;
  larguraBarraPx: number;
}

export interface ItemRenderizavelIndividual {
  tipo: 'individual';
  marco: Marco;
  numeroNaFolha: number;
  anoInicioFrac: number;
  pctX: number;
  pxX: number;
  exibirTitulo: boolean;
  ehIntervalo: boolean;
  larguraBarraPct: number;
  larguraBarraPx: number;
}

export interface ItemRenderizavelCluster {
  tipo: 'cluster';
  marcos: Marco[];
  numerosNaFolha: number[];
  anoInicioFrac: number;
  pctX: number;
  pxX: number;
  rotuloNumeros: string;
  anoTexto: string;
  total: number;
}

export type ItemRenderizavelMarco = ItemRenderizavelIndividual | ItemRenderizavelCluster;

/**
 * Cria um mapa de identificadores únicos para o número global sequencial de cada marco
 * na folha A4 (1, 2, 3, ...), ordenados cronologicamente.
 */
export function mapearNumerosMarcosDaFolha(marcosFaixa: Marco[]): Map<string, number> {
  const mapa = new Map<string, number>();
  const ordenados = [...marcosFaixa].sort((a, b) => {
    const anoA = converterDataParaAnoFracionario(a.ano_inicio, a.data_periodo_texto) ?? a.ano_inicio ?? 0;
    const anoB = converterDataParaAnoFracionario(b.ano_inicio, b.data_periodo_texto) ?? b.ano_inicio ?? 0;
    return anoA - anoB;
  });

  ordenados.forEach((m, idx) => {
    mapa.set(m.id, idx + 1);
  });

  return mapa;
}

/**
 * Processa a lista de marcos de uma linha de contexto em uma folha A4 Paisagem,
 * aplicando regras cartográficas de desdensificação e anticolisão:
 * 1. Agrupa marcos adjacentes cuja distância seja inferior ao limiar do pino (< limiarClusterPx)
 * 2. Suprime o texto de títulos extensos quando não houver folga horizontal mínima (< limiarTituloPx)
 * 3. Garante que os números e identificadores correspondam perfeitamente ao Quadro Sinóptico
 */
export function calcularAnticolisaoMarcos(
  marcosDaLinha: Marco[],
  mapaNumerosGlobais: Map<string, number>,
  faixaDe: number,
  faixaAte: number,
  larguraTrilhaPx: number = 825,
  limiarClusterPx: number = 18,
  limiarTituloPx: number = 75
): ItemRenderizavelMarco[] {
  const spanFaixa = Math.max(1, faixaAte - faixaDe);

  // 1. Converter cada marco em coordenada proporcional e pixel
  const marcosComPos: MarcoComPosicao[] = marcosDaLinha.map((m) => {
    const anoInicioFrac =
      converterDataParaAnoFracionario(m.ano_inicio, m.data_periodo_texto) ?? m.ano_inicio ?? faixaDe;
    const pctX = Math.max(0, Math.min(100, ((anoInicioFrac - faixaDe) / spanFaixa) * 100));
    const pxX = (pctX / 100) * larguraTrilhaPx;

    const ehIntervalo = m.ano_fim != null && m.ano_fim > (m.ano_inicio ?? 0);
    const anoFimFrac = ehIntervalo
      ? converterDataParaAnoFracionario(m.ano_fim, undefined) ?? m.ano_fim!
      : anoInicioFrac;
    const pctFim = Math.max(0, Math.min(100, ((anoFimFrac - faixaDe) / spanFaixa) * 100));
    const larguraBarraPct = ehIntervalo ? Math.max(0.5, pctFim - pctX) : 0;
    const larguraBarraPx = (larguraBarraPct / 100) * larguraTrilhaPx;

    return {
      marco: m,
      numeroNaFolha: mapaNumerosGlobais.get(m.id) ?? 1,
      anoInicioFrac,
      pctX,
      pxX,
      ehIntervalo,
      larguraBarraPct,
      larguraBarraPx,
    };
  });

  // Ordenar cronologicamente
  marcosComPos.sort((a, b) => a.anoInicioFrac - b.anoInicioFrac);

  // 2. Agrupamento (Clustering) de marcos com coordenadas excessivamente próximas (< limiarClusterPx)
  const itensAgrupados: Array<MarcoComPosicao | MarcoComPosicao[]> = [];
  let i = 0;

  while (i < marcosComPos.length) {
    const atual = marcosComPos[i];

    // Se for um intervalo com largura considerável (>= limiarClusterPx), não faz cluster
    if (atual.ehIntervalo && atual.larguraBarraPx >= limiarClusterPx) {
      itensAgrupados.push(atual);
      i++;
      continue;
    }

    // Tenta acumular marcos próximos
    const grupo: MarcoComPosicao[] = [atual];
    let j = i + 1;

    while (j < marcosComPos.length) {
      const proximo = marcosComPos[j];
      // Se for intervalo grande, para o cluster
      if (proximo.ehIntervalo && proximo.larguraBarraPx >= limiarClusterPx) {
        break;
      }
      // Distância em relação ao anterior do cluster
      const deltaPx = proximo.pxX - grupo[grupo.length - 1].pxX;
      if (deltaPx < limiarClusterPx) {
        grupo.push(proximo);
        j++;
      } else {
        break;
      }
    }

    if (grupo.length > 1) {
      itensAgrupados.push(grupo);
      i = j;
    } else {
      itensAgrupados.push(atual);
      i++;
    }
  }

  // 3. Converter grupos em itens renderizáveis com determinação de rótulo (Anticolisão de Texto)
  const itensFinais: ItemRenderizavelMarco[] = [];

  for (let k = 0; k < itensAgrupados.length; k++) {
    const item = itensAgrupados[k];

    if (Array.isArray(item)) {
      // Cluster de 2 ou mais marcos
      const primeiro = item[0];
      const numeros = item.map((m) => m.numeroNaFolha);
      const minNum = Math.min(...numeros);
      const maxNum = Math.max(...numeros);

      let rotuloNumeros = '';
      if (item.length === 2) {
        rotuloNumeros = `${minNum}, ${maxNum}`;
      } else {
        rotuloNumeros = `${minNum}–${maxNum}`;
      }

      const anoTexto = Math.round(primeiro.anoInicioFrac).toString();

      itensFinais.push({
        tipo: 'cluster',
        marcos: item.map((m) => m.marco),
        numerosNaFolha: numeros,
        anoInicioFrac: primeiro.anoInicioFrac,
        pctX: primeiro.pctX,
        pxX: primeiro.pxX,
        rotuloNumeros,
        anoTexto,
        total: item.length,
      });
    } else {
      // Marco individual: avaliar se há espaço livre para o título
      const proximoItem = itensAgrupados[k + 1];
      const proxPx = proximoItem
        ? Array.isArray(proximoItem)
          ? proximoItem[0].pxX
          : proximoItem.pxX
        : larguraTrilhaPx;

      const espacoLivre = proxPx - item.pxX;
      const exibirTitulo = !item.ehIntervalo && espacoLivre >= limiarTituloPx;

      itensFinais.push({
        tipo: 'individual',
        marco: item.marco,
        numeroNaFolha: item.numeroNaFolha,
        anoInicioFrac: item.anoInicioFrac,
        pctX: item.pctX,
        pxX: item.pxX,
        exibirTitulo,
        ehIntervalo: item.ehIntervalo,
        larguraBarraPct: item.larguraBarraPct,
        larguraBarraPx: item.larguraBarraPx,
      });
    }
  }

  return itensFinais;
}
