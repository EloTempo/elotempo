/**
 * Funções puras de ordenação e reordenação das trilhas da Linha do Tempo.
 */

import {
  dataParaAnoContinuo,
  interpretarDataParaAnoContinuo,
  NOMES_MESES_CURTOS,
  obterDiasNoMes,
} from '../../lib/precisionTime';
import {
  formatarAnoNoCalendario,
  formatarDataNoCalendario,
  type TipoCalendario,
} from '../../lib/calendarios';
import type { TipoTempo } from '../../types';

export function reordenarLista<T>(
  lista: T[],
  origem: T,
  destino: T,
  posicao: 'antes' | 'depois',
): T[] {
  if (origem === destino) return lista;
  const semOrigem = lista.filter((item) => item !== origem);
  const idxDestino = semOrigem.indexOf(destino);
  if (idxDestino === -1) {
    return [...semOrigem, origem];
  }
  const insercao = posicao === 'antes' ? idxDestino : idxDestino + 1;
  const copia = [...semOrigem];
  copia.splice(insercao, 0, origem);
  return copia;
}

export interface InfoPessoaOrdenacao {
  ano?: number | null;
  nome?: string | null;
}

export function ordenarIdsPorAno(
  ids: string[],
  mapaAnos: Map<string, InfoPessoaOrdenacao>,
): string[] {
  return [...ids].sort((a, b) => {
    const infoA = mapaAnos.get(a) ?? { ano: 999999, nome: '' };
    const infoB = mapaAnos.get(b) ?? { ano: 999999, nome: '' };
    const anoA = infoA.ano ?? 999999;
    const anoB = infoB.ano ?? 999999;
    if (anoA !== anoB) return anoA - anoB;
    return (infoA.nome || '').localeCompare(infoB.nome || '');
  });
}

export function sincronizarOrdemVidas({
  baseIds,
  vidasExtras = [],
  vidasRemovidas = [],
  ordemPersonalizada = [],
}: {
  baseIds: string[];
  vidasExtras?: string[];
  vidasRemovidas?: string[];
  ordemPersonalizada?: string[];
}): string[] {
  const candidatosSet = new Set<string>();
  for (const id of baseIds) {
    if (!vidasRemovidas.includes(id)) candidatosSet.add(id);
  }
  for (const id of vidasExtras) {
    if (!vidasRemovidas.includes(id)) candidatosSet.add(id);
  }

  if (ordemPersonalizada.length > 0) {
    const resultado: string[] = [];
    for (const id of ordemPersonalizada) {
      if (candidatosSet.has(id)) {
        resultado.push(id);
        candidatosSet.delete(id);
      }
    }
    for (const id of candidatosSet) {
      resultado.push(id);
    }
    return resultado;
  }

  const resultado: string[] = [];
  for (const id of baseIds) {
    if (candidatosSet.has(id) && !resultado.includes(id)) {
      resultado.push(id);
    }
  }
  for (const id of vidasExtras) {
    if (candidatosSet.has(id) && !resultado.includes(id)) {
      resultado.push(id);
    }
  }
  return resultado;
}

export interface FatiaVisivel {
  barraNaTela: boolean;
  visivelInicio: number;
  visivelFim: number;
  larguraVisivel: number;
  centroVisivelRelativo: number;
  estendeParaEsquerda: boolean;
  estendeParaDireita: boolean;
}

/**
 * Calcula a porção visível de uma barra de vida no canvas (Viewport-Aware Sticky Label).
 * Garante que o nome da pessoa fique sempre centralizado no trecho da barra atualmente visível.
 */
export function calcularFatiaVisivelBarra({
  x0,
  x1,
  larguraCanvas,
}: {
  x0: number | null;
  x1: number | null;
  larguraCanvas: number;
}): FatiaVisivel {
  if (x0 == null || x1 == null || x1 <= 0 || x0 >= larguraCanvas) {
    const w = x0 != null && x1 != null ? Math.max(12, x1 - x0) : 0;
    return {
      barraNaTela: false,
      visivelInicio: 0,
      visivelFim: 0,
      larguraVisivel: 0,
      centroVisivelRelativo: w / 2,
      estendeParaEsquerda: x0 != null && x0 < 0,
      estendeParaDireita: x1 != null && x1 > larguraCanvas,
    };
  }

  const visivelInicio = Math.max(0, x0);
  const visivelFim = Math.min(larguraCanvas, x1);
  const larguraVisivel = Math.max(0, visivelFim - visivelInicio);
  const centroVisivelRelativo = (visivelInicio + visivelFim) / 2 - x0;

  return {
    barraNaTela: true,
    visivelInicio,
    visivelFim,
    larguraVisivel,
    centroVisivelRelativo,
    estendeParaEsquerda: x0 < 0,
    estendeParaDireita: x1 > larguraCanvas,
  };
}

export interface GridBlender {
  passoPrincipal: number;
  passoSecundario: number;
  passoTerciario?: number;
  marcasPrincipais: number[];
  marcasSecundarias: number[];
  marcasTerciarias: number[];
  rotulos?: Map<number, string>;
  escala?: 'anos' | 'meses' | 'dias';
}

/**
 * Calcula subdivisões principais (Major ticks), secundárias (Minor lines) e
 * terciárias (Sub-minor / Meses) estilo timeline/graph editor do Blender, adaptando-se
 * harmonicamente ao zoom (cascata harmônica de séculos -> décadas -> anos -> meses -> dias).
 */
export function calcularGridBlender({
  de,
  ate,
  calendario = 'gregoriano',
  tipoTempo = 'real',
}: {
  de: number;
  ate: number;
  calendario?: TipoCalendario;
  tipoTempo?: TipoTempo;
}): GridBlender {
  const span = Math.max(0.0001, ate - de);
  const rotulos = new Map<number, string>();
  const marcasPrincipais: number[] = [];
  const marcasSecundarias: number[] = [];
  const marcasTerciarias: number[] = [];

  // 1. Nível Sub-Anual: Dias (menos de 0.35 anos / ~128 dias)
  if (span < 0.35) {
    const passoDias = span < 0.09 ? 1 : 5;
    const anoInicio = Math.floor(de);
    const anoFim = Math.floor(ate);

    for (let ano = anoInicio; ano <= anoFim; ano++) {
      for (let mes = 1; mes <= 12; mes++) {
        const totalDiasMes = obterDiasNoMes(mes, ano);
        for (let dia = 1; dia <= totalDiasMes; dia++) {
          const anoCont = dataParaAnoContinuo(ano, mes, dia);
          if (anoCont >= de - 0.002 && anoCont <= ate + 0.002) {
            const ehPrincipal = dia === 1 || (passoDias === 1 ? true : dia % passoDias === 0);
            if (ehPrincipal) {
              marcasPrincipais.push(anoCont);
              const rotulo =
                calendario === 'gregoriano' && tipoTempo === 'real'
                  ? dia === 1
                    ? `${dia} ${NOMES_MESES_CURTOS[mes - 1]}`
                    : `${dia}`
                  : formatarDataNoCalendario({ ano, mes, dia }, calendario, tipoTempo, 'diaMes');
              rotulos.set(anoCont, rotulo);
            } else {
              marcasSecundarias.push(anoCont);
            }

            // Subdivisão terciária: meio-dia (12h) se zoom for de passo 1 dia
            if (passoDias === 1 && span < 0.08) {
              const meioDia = anoCont + 0.5 / (totalDiasMes * 12);
              if (meioDia >= de && meioDia <= ate) {
                marcasTerciarias.push(meioDia);
              }
            }
          }
        }
      }
    }

    marcasPrincipais.sort((a, b) => a - b);
    marcasSecundarias.sort((a, b) => a - b);
    marcasTerciarias.sort((a, b) => a - b);

    return {
      passoPrincipal: passoDias / 365,
      passoSecundario: 1 / 365,
      marcasPrincipais,
      marcasSecundarias,
      marcasTerciarias,
      rotulos,
      escala: 'dias',
    };
  }

  // 2. Nível Sub-Anual: Meses (entre 0.35 e 2 anos)
  if (span <= 2.0) {
    const passoMes = span > 1.2 ? 2 : 1;
    const anoInicio = Math.floor(de);
    const anoFim = Math.floor(ate);

    for (let ano = anoInicio; ano <= anoFim; ano++) {
      for (let mes = 1; mes <= 12; mes++) {
        const anoCont = dataParaAnoContinuo(ano, mes, 1);
        if (anoCont >= de - 0.05 && anoCont <= ate + 0.05) {
          if ((mes - 1) % passoMes === 0) {
            marcasPrincipais.push(anoCont);
            const rotulo =
              calendario === 'gregoriano' && tipoTempo === 'real'
                ? mes === 1 || marcasPrincipais.length === 1
                  ? `${NOMES_MESES_CURTOS[mes - 1]} ${ano}`
                  : NOMES_MESES_CURTOS[mes - 1]
                : mes === 1 || marcasPrincipais.length === 1
                  ? formatarDataNoCalendario({ ano, mes, dia: 1 }, calendario, tipoTempo, 'mesCurtoAno')
                  : formatarDataNoCalendario({ ano, mes, dia: 1 }, calendario, tipoTempo, 'mesCurto');
            rotulos.set(anoCont, rotulo);
          } else {
            marcasSecundarias.push(anoCont);
          }
        }
        // Marca secundária: quinzena (dia 15)
        const quinzena = dataParaAnoContinuo(ano, mes, 15);
        if (quinzena >= de && quinzena <= ate) {
          marcasSecundarias.push(quinzena);
        }
        // Marca terciária: a cada 5 dias (dias 5, 10, 20, 25) se span <= 1.2
        if (span <= 1.2) {
          for (const d of [5, 10, 20, 25]) {
            const diaCont = dataParaAnoContinuo(ano, mes, d);
            if (diaCont >= de && diaCont <= ate) {
              marcasTerciarias.push(diaCont);
            }
          }
        }
      }
    }

    marcasPrincipais.sort((a, b) => a - b);
    marcasSecundarias.sort((a, b) => a - b);
    marcasTerciarias.sort((a, b) => a - b);

    return {
      passoPrincipal: passoMes / 12,
      passoSecundario: 0.5 / 12,
      marcasPrincipais,
      marcasSecundarias,
      marcasTerciarias,
      rotulos,
      escala: 'meses',
    };
  }

  // 3. Nível Anual (span > 2 anos)
  let passoPrincipal = 100;
  let passoSecundario = 20;
  let passoTerciario: number | undefined = undefined;

  if (span > 15000) {
    passoPrincipal = 2500;
    passoSecundario = 500;
  } else if (span > 8000) {
    passoPrincipal = 1000;
    passoSecundario = 200;
  } else if (span > 3000) {
    passoPrincipal = 500;
    passoSecundario = 100;
  } else if (span > 1200) {
    passoPrincipal = 200;
    passoSecundario = 50;
  } else if (span > 400) {
    passoPrincipal = 100;
    passoSecundario = 20;
  } else if (span > 150) {
    passoPrincipal = 50;
    passoSecundario = 10;
  } else if (span > 60) {
    passoPrincipal = 20;
    passoSecundario = 5;
  } else if (span > 25) {
    // Zoom de 25 a 60 anos (ex: 2000 e 2010): exatamente 9 anos intermediários (2001..2009)!
    passoPrincipal = 10;
    passoSecundario = 1;
  } else if (span > 10) {
    // Zoom de 10 a 25 anos (ex: 2000, 2005, 2010): 4 anos intermediários (2001..2004) + trimestres
    passoPrincipal = 5;
    passoSecundario = 1;
    passoTerciario = 0.25;
  } else if (span > 5) {
    // Zoom de 5 a 10 anos: a cada 2 anos principal, anos ímpares secundários, todos os meses terciários
    passoPrincipal = 2;
    passoSecundario = 1;
    passoTerciario = 1 / 12;
  } else {
    // 2 < span <= 5 anos: cada ano é principal numerado, trimestres secundários, todos os meses terciários
    passoPrincipal = 1;
    passoSecundario = 0.25;
    passoTerciario = 1 / 12;
  }

  // Gera marcas principais
  for (let a = Math.ceil(de / passoPrincipal) * passoPrincipal; a <= ate; a += passoPrincipal) {
    marcasPrincipais.push(a);
    const rotulo =
      calendario === 'gregoriano' && tipoTempo === 'real'
        ? a < 0 ? `${Math.abs(a)} a.C.` : `${a}`
        : formatarAnoNoCalendario(a, calendario, tipoTempo);
    rotulos.set(a, rotulo);
  }

  const princSet = new Set(marcasPrincipais);

  // Gera marcas secundárias e terciárias para span > 2
  if (span <= 5) {
    // Para span <= 5 anos:
    // Secundárias = trimestres (meses 4, 7, 10 de cada ano)
    // Terciárias = outros meses (meses 2, 3, 5, 6, 8, 9, 11, 12)
    const anoMin = Math.floor(de);
    const anoMax = Math.ceil(ate);
    for (let a = anoMin; a <= anoMax; a++) {
      for (const m of [4, 7, 10]) {
        const frac = dataParaAnoContinuo(a, m, 1);
        if (frac >= de && frac <= ate) {
          marcasSecundarias.push(frac);
        }
      }
      for (const m of [2, 3, 5, 6, 8, 9, 11, 12]) {
        const frac = dataParaAnoContinuo(a, m, 1);
        if (frac >= de && frac <= ate) {
          marcasTerciarias.push(frac);
        }
      }
    }
  } else if (span <= 10) {
    // Para 5 < span <= 10 anos:
    // Secundárias = anos intermediários inteiros (ex: ímpares quando passoPrincipal = 2)
    const anoMin = Math.floor(de);
    const anoMax = Math.ceil(ate);
    for (let a = anoMin; a <= anoMax; a++) {
      if (a >= de && a <= ate && !princSet.has(a)) {
        marcasSecundarias.push(a);
      }
      // Terciárias = todos os meses de 2 a 12
      for (let m = 2; m <= 12; m++) {
        const frac = dataParaAnoContinuo(a, m, 1);
        if (frac >= de && frac <= ate) {
          marcasTerciarias.push(frac);
        }
      }
    }
  } else if (span <= 25) {
    // Para 10 < span <= 25 anos (ex: imagem 2 do usuário: 2000, 2005, 2010):
    // Secundárias = anos intermediários inteiros (2001, 2002, 2003, 2004) -> 4 linhas de anos
    // Terciárias = trimestres (meses 4, 7, 10 indicando a passagem dos meses no ano)
    const anoMin = Math.floor(de);
    const anoMax = Math.ceil(ate);
    for (let a = anoMin; a <= anoMax; a++) {
      if (a >= de && a <= ate && !princSet.has(a)) {
        marcasSecundarias.push(a);
      }
      for (const m of [4, 7, 10]) {
        const frac = dataParaAnoContinuo(a, m, 1);
        if (frac >= de && frac <= ate) {
          marcasTerciarias.push(frac);
        }
      }
    }
  } else {
    // Para span > 25 (ex: imagem 1 do usuário: 2000 e 2010 -> 9 anos intermediários 2001..2009!):
    if (passoSecundario > 0 && passoSecundario < passoPrincipal) {
      for (let a = Math.ceil(de / passoSecundario) * passoSecundario; a <= ate; a += passoSecundario) {
        if (!princSet.has(a)) {
          marcasSecundarias.push(a);
        }
      }
    }
  }

  marcasPrincipais.sort((a, b) => a - b);
  marcasSecundarias.sort((a, b) => a - b);
  marcasTerciarias.sort((a, b) => a - b);

  return {
    passoPrincipal,
    passoSecundario,
    passoTerciario,
    marcasPrincipais,
    marcasSecundarias,
    marcasTerciarias,
    rotulos,
    escala: 'anos',
  };
}

/**
 * Converte um ano, texto de data e/ou campos estruturados (mês, dia)
 * em um valor de ano contínuo fracionário de alta precisão com suporte a bissextos.
 */
export function converterDataParaAnoFracionario(
  ano?: number | null,
  dataTexto?: string | null,
  mes?: number | null,
  dia?: number | null,
): number | null {
  return interpretarDataParaAnoContinuo(ano, dataTexto, mes, dia);
}

export interface GrupoMarcosPessoais<T> {
  id: string;
  x: number;
  ano: number;
  itens: T[];
  isCluster: boolean;
  subLane: number;
}

/**
 * Agrupa marcos pessoais que estejam a uma distância visual menor que `distanciaMinima`
 * no canvas para evitar empilhamento caótico de chips no mesmo ano (ex: 1822).
 */
export function agruparMarcosPessoaisProximos<T extends { ano?: number | null; data_texto?: string | null; mes?: number | null; dia?: number | null }>(
  marcos: T[],
  posicaoDoAno: (ano: number) => number,
  distanciaMinima = 65,
  maxSubLanes = 2,
): GrupoMarcosPessoais<T>[] {
  if (!marcos || marcos.length === 0) return [];

  const mapeados = marcos
    .map((m, idx) => {
      const anyM = m as { ano?: number | null; data_texto?: string | null; mes?: number | null; dia?: number | null };
      const anoFrac = converterDataParaAnoFracionario(anyM.ano, anyM.data_texto, anyM.mes, anyM.dia) ?? anyM.ano ?? 0;
      return {
        item: m,
        idx,
        ano: anoFrac,
        x: posicaoDoAno(anoFrac),
      };
    })
    .sort((a, b) => a.x - b.x);

  const grupos: GrupoMarcosPessoais<T>[] = [];
  let grupoAtual: typeof mapeados = [];

  for (let i = 0; i < mapeados.length; i++) {
    const atual = mapeados[i];
    if (grupoAtual.length === 0) {
      grupoAtual.push(atual);
    } else {
      const primeiroDoGrupo = grupoAtual[0];
      const ultimoDoGrupo = grupoAtual[grupoAtual.length - 1];
      // Se muito próximo do primeiro (< distanciaMinima) ou do último (< 28px), agrega ao cluster
      if (atual.x - primeiroDoGrupo.x < distanciaMinima || atual.x - ultimoDoGrupo.x < 28) {
        grupoAtual.push(atual);
      } else {
        const centroX = grupoAtual.reduce((acc, el) => acc + el.x, 0) / grupoAtual.length;
        const anoMedio =
          grupoAtual.length === 1
            ? grupoAtual[0].ano
            : grupoAtual.reduce((acc, el) => acc + el.ano, 0) / grupoAtual.length;
        grupos.push({
          id: `cluster-${grupos.length}-${grupoAtual[0].idx}`,
          x: centroX,
          ano: grupoAtual.length > 1 ? Math.round(anoMedio) : anoMedio,
          itens: grupoAtual.map((g) => g.item),
          isCluster: grupoAtual.length > 1,
          subLane: 0,
        });
        grupoAtual = [atual];
      }
    }
  }

  if (grupoAtual.length > 0) {
    const centroX = grupoAtual.reduce((acc, el) => acc + el.x, 0) / grupoAtual.length;
    const anoMedio =
      grupoAtual.length === 1
        ? grupoAtual[0].ano
        : grupoAtual.reduce((acc, el) => acc + el.ano, 0) / grupoAtual.length;
    grupos.push({
      id: `cluster-${grupos.length}-${grupoAtual[0].idx}`,
      x: centroX,
      ano: grupoAtual.length > 1 ? Math.round(anoMedio) : anoMedio,
      itens: grupoAtual.map((g) => g.item),
      isCluster: grupoAtual.length > 1,
      subLane: 0,
    });
  }

  // Atribui sub-lanes alternadas para grupos consecutivos próximos
  for (let i = 0; i < grupos.length; i++) {
    if (i === 0) {
      grupos[i].subLane = 0;
    } else {
      const anterior = grupos[i - 1];
      if (grupos[i].x - anterior.x < 115) {
        grupos[i].subLane = (anterior.subLane + 1) % maxSubLanes;
      } else {
        grupos[i].subLane = 0;
      }
    }
  }

  return grupos;
}

export interface MarcoContextoPosicionado<T> {
  marco: T;
  x: number;
  larguraBarra: number;
  intervalo: boolean;
  temRotulo: boolean;
  subLane: number;
}

/**
 * Regra Simples do Usuário:
 * Se tiver espaço para mostrar o texto completo sem interferir no marco seguinte
 * no zoom temporal atual, o texto aparece.
 * Se não tiver espaço para o texto aparecer por completo (ou seja, uma parte do
 * texto ficaria sobre o marco seguinte), então deixa sem texto (apenas o pino do marco).
 */
export function calcularSubLanesContexto<
  T extends {
    id: string;
    ano_inicio?: number | null;
    ano_fim?: number | null;
    data_periodo_texto?: string | null;
    titulo: string;
  },
>(
  marcos: T[],
  posicaoDoAno: (ano: number) => number,
  _numLanes = 1,
  _larguraEstimadaRotulo = 110,
): MarcoContextoPosicionado<T>[] {
  if (!marcos || marcos.length === 0) return [];

  const ordenados = [...marcos]
    .map((m) => {
      const anoFrac =
        converterDataParaAnoFracionario(m.ano_inicio, m.data_periodo_texto) ??
        m.ano_inicio ??
        0;
      const x = posicaoDoAno(anoFrac);
      const ehInterv = m.ano_fim != null && m.ano_fim > (m.ano_inicio ?? 0);
      const larguraBarra = ehInterv
        ? Math.max(4, posicaoDoAno(m.ano_fim!) - x)
        : 0;
      return {
        marco: m,
        anoFrac,
        x,
        intervalo: ehInterv,
        larguraBarra,
      };
    })
    .sort((a, b) => a.x - b.x);

  const resultado: MarcoContextoPosicionado<T>[] = [];

  for (let i = 0; i < ordenados.length; i++) {
    const item = ordenados[i];
    const proximoX = i < ordenados.length - 1 ? ordenados[i + 1].x : Infinity;
    const espacoAteProximo = proximoX - item.x;

    let temRotulo = false;

    if (item.intervalo) {
      // Se for intervalo, o texto só cabe se a barra do intervalo comportar o título completo
      const larguraMinimaTexto = Math.max(35, Math.ceil(item.marco.titulo.length * 6.8 + 16));
      temRotulo = item.larguraBarra >= larguraMinimaTexto;
    } else {
      // Para marco pontual: calcula o espaço real necessário para exibir o texto completo
      const larguraTextoCompleto = Math.ceil(item.marco.titulo.length * 7 + 28);
      // Só mostra texto se o espaço até o próximo marco for suficiente para comportar o texto completo com folga
      temRotulo = espacoAteProximo >= (larguraTextoCompleto + 8);
    }

    resultado.push({
      marco: item.marco,
      x: item.x,
      larguraBarra: item.larguraBarra,
      intervalo: item.intervalo,
      temRotulo,
      subLane: 0,
    });
  }

  return resultado;
}
