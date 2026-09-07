/**
 * Funções puras de ordenação e reordenação das trilhas da Linha do Tempo.
 */

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
  marcasPrincipais: number[];
  marcasSecundarias: number[];
}

/**
 * Calcula subdivisões principais (Major ticks) e secundárias (Minor lines)
 * estilo timeline/graph editor do Blender, adaptando-se harmonicamente ao zoom.
 */
export function calcularGridBlender({
  de,
  ate,
}: {
  de: number;
  ate: number;
}): GridBlender {
  const span = Math.max(1, ate - de);
  let passoPrincipal = 100;
  let passoSecundario = 20;

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
    passoPrincipal = 10;
    passoSecundario = 2;
  } else if (span > 10) {
    passoPrincipal = 5;
    passoSecundario = 1;
  } else if (span > 4) {
    passoPrincipal = 2;
    passoSecundario = 1;
  } else {
    passoPrincipal = 1;
    passoSecundario = 0;
  }

  const marcasPrincipais: number[] = [];
  for (let a = Math.ceil(de / passoPrincipal) * passoPrincipal; a <= ate; a += passoPrincipal) {
    marcasPrincipais.push(a);
  }

  const marcasSecundarias: number[] = [];
  if (passoSecundario > 0 && passoSecundario < passoPrincipal) {
    const princSet = new Set(marcasPrincipais);
    for (let a = Math.ceil(de / passoSecundario) * passoSecundario; a <= ate; a += passoSecundario) {
      if (!princSet.has(a)) {
        marcasSecundarias.push(a);
      }
    }
  }

  return {
    passoPrincipal,
    passoSecundario,
    marcasPrincipais,
    marcasSecundarias,
  };
}

/**
 * Converte um ano e string de data opcional ("DD/MM/AAAA" ou "AAAA-MM-DD")
 * em um valor de ano contínuo fracionário para posicionamento temporal preciso.
 * Ex: "24/08/1820" -> 1820 + (8 - 1)/12 + (24 - 1)/372 ~= 1820.645
 */
export function converterDataParaAnoFracionario(
  ano?: number | null,
  dataTexto?: string | null,
): number | null {
  if (ano == null && !dataTexto) return null;
  if (!dataTexto) return ano ?? null;

  const limpo = dataTexto.trim();
  // Formato brasileiro DD/MM/AAAA
  const matchBr = limpo.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})/);
  if (matchBr) {
    const dia = parseInt(matchBr[1], 10);
    const mes = parseInt(matchBr[2], 10);
    const a = parseInt(matchBr[3], 10);
    const frac = Math.max(0, Math.min(0.995, ((mes - 1) + (dia - 1) / 31) / 12));
    return a + frac;
  }

  // Formato ISO AAAA-MM-DD
  const matchIso = limpo.match(/^(\d{4})-(\d{1,2})-(\d{1,2})/);
  if (matchIso) {
    const a = parseInt(matchIso[1], 10);
    const mes = parseInt(matchIso[2], 10);
    const dia = parseInt(matchIso[3], 10);
    const frac = Math.max(0, Math.min(0.995, ((mes - 1) + (dia - 1) / 31) / 12));
    return a + frac;
  }

  return ano ?? null;
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
export function agruparMarcosPessoaisProximos<T extends { ano?: number | null; data_texto?: string | null }>(
  marcos: T[],
  posicaoDoAno: (ano: number) => number,
  distanciaMinima = 65,
  maxSubLanes = 2,
): GrupoMarcosPessoais<T>[] {
  if (!marcos || marcos.length === 0) return [];

  const mapeados = marcos
    .map((m, idx) => {
      const anoFrac = converterDataParaAnoFracionario(m.ano, m.data_texto) ?? m.ano ?? 0;
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
        const anoMedio = grupoAtual[0].ano;
        grupos.push({
          id: `cluster-${grupos.length}-${grupoAtual[0].idx}`,
          x: centroX,
          ano: Math.round(anoMedio),
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
    const anoMedio = grupoAtual[0].ano;
    grupos.push({
      id: `cluster-${grupos.length}-${grupoAtual[0].idx}`,
      x: centroX,
      ano: Math.round(anoMedio),
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
