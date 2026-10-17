/**
 * Layout da árvore genealógica — vertical clássico, de cima para baixo.
 *
 * Este é o item que o projeto ainda não tinha. Antes, as coordenadas vinham de
 * um espalhamento por índice (`x: 300 + (i % 3) * 260`), que desenhava três
 * colunas sem relação nenhuma com o parentesco.
 *
 * O desenho segue o modelo lineage-linked: **a união é o nó âncora**. Um casal
 * fica lado a lado com o anel da união entre eles; os filhos penduram na linha
 * que desce do anel, centralizados sob ele. Ancestrais no topo, descendentes
 * abaixo (seção 10) — leque e horizontal foram descartados por decisão de
 * design, e este módulo não os implementa de propósito.
 *
 * O algoritmo é o clássico de duas passadas:
 *
 *   1. **Medir** (de baixo para cima) — quanta largura cada pessoa e cada
 *      bloco de união ocupam com toda a sua descendência.
 *   2. **Colocar** (de cima para baixo) — distribuir as posições usando as
 *      larguras já conhecidas, centralizando cada casal sobre a própria prole.
 *
 * Medir antes de colocar é o que evita o problema clássico do layout de
 * árvore: sem saber a largura da subárvore, ou os irmãos se sobrepõem, ou
 * sobra um vão enorme entre eles.
 */

import type { TreeGraph, PersonNode, UnionNode } from '../../types';

export function formatarAno(ano?: number | null): string {
  if (ano == null) return '';
  if (ano < 0) return `${Math.abs(ano)} a.C.`;
  if (ano > 0 && ano <= 100) return `${ano} d.C.`;
  return String(ano);
}

// ---------------------------------------------------------------------------
// Métricas do desenho
// ---------------------------------------------------------------------------

export const METRICAS = {
  /** Largura do card de pessoa — aumentada para acomodar nomes completos e dados biográficos. */
  larguraNo: 290,
  /** Altura do card de pessoa. */
  alturaNo: 96,
  /** Vão entre os dois cônjuges — é onde o anel da união se encaixa. */
  espacoCasal: 64,
  /** Vão horizontal entre irmãos. */
  espacoIrmaos: 32,
  /** Vão entre blocos independentes (uniões distintas, raízes distintas). */
  espacoBlocos: 72,
  /** Distância vertical entre gerações. */
  alturaGeracao: 196,
  /** Margem em volta de todo o desenho. */
  margem: 60,
} as const;

// ---------------------------------------------------------------------------
// Tipos de saída
// ---------------------------------------------------------------------------

export interface PosicaoPessoa extends PersonNode {
  x: number;
  y: number;
  geracao: number;
}

export interface PosicaoUniao extends UnionNode {
  x: number;
  y: number;
  geracao: number;
  filhosTotal: number;
  colapsada: boolean;
}

export interface ArestaLayout {
  id: string;
  tipo: 'pai_uniao' | 'mae_uniao' | 'uniao_filho';
  tipoVinculo?: string;
  origem: { x: number; y: number };
  destino: { x: number; y: number };
}

export interface LayoutArvore {
  pessoas: PosicaoPessoa[];
  unioes: PosicaoUniao[];
  arestas: ArestaLayout[];
  largura: number;
  altura: number;
}

// ---------------------------------------------------------------------------
// Índice do grafo
// ---------------------------------------------------------------------------

interface Indice {
  pessoas: Map<string, PersonNode>;
  unioes: Map<string, UnionNode>;
  /** uniões em que a pessoa é um dos cônjuges */
  unioesDoParceiro: Map<string, string[]>;
  /** filhos de cada união visíveis no desenho */
  filhosDaUniao: Map<string, string[]>;
  /** total original de filhos cadastrados da união */
  filhosTotalDaUniao: Map<string, number>;
  /** união da qual a pessoa é filha (no máximo uma — invariante da seção 3) */
  uniaoDeOrigem: Map<string, string>;
  tipoVinculo: Map<string, string>;
  /** pessoas ocultadas por estarem abaixo de ramos colapsados */
  ocultados: Set<string>;
}

function indexar(grafo: TreeGraph, unioesColapsadas?: Set<string>): Indice {
  const pessoas = new Map(grafo.nodes.map((p) => [p.id, p]));

  // Consolidação de uniões duplicadas para o mesmo par de parceiros
  const unioesConsolidadas = new Map<string, string>(); // unionId -> uniaoPrimariaId
  const mapaParceirosParaUniao = new Map<string, string>();
  const unioesFiltradas: UnionNode[] = [];

  for (const u of grafo.unions) {
    const chave =
      u.slot_masculino_id === u.slot_feminino_id
        ? `mono::${u.slot_masculino_id}::${u.id}`
        : [u.slot_masculino_id, u.slot_feminino_id].sort().join('::');

    if (mapaParceirosParaUniao.has(chave)) {
      unioesConsolidadas.set(u.id, mapaParceirosParaUniao.get(chave)!);
    } else {
      mapaParceirosParaUniao.set(chave, u.id);
      unioesConsolidadas.set(u.id, u.id);
      unioesFiltradas.push(u);
    }
  }

  const unioes = new Map(unioesFiltradas.map((u) => [u.id, u]));

  const unioesDoParceiro = new Map<string, string[]>();
  const filhosDaUniaoBruto = new Map<string, string[]>();
  const uniaoDeOrigem = new Map<string, string>();
  const tipoVinculo = new Map<string, string>();

  for (const u of unioesFiltradas) {
    const parceirosUnicos = new Set([u.slot_masculino_id, u.slot_feminino_id]);
    for (const parceiro of parceirosUnicos) {
      if (!pessoas.has(parceiro)) continue;
      const lista = unioesDoParceiro.get(parceiro) ?? [];
      if (!lista.includes(u.id)) {
        lista.push(u.id);
      }
      unioesDoParceiro.set(parceiro, lista);
    }
    filhosDaUniaoBruto.set(u.id, []);
  }

  for (const l of grafo.links) {
    if (l.tipo !== 'uniao_filho') continue;
    const uidAlvo = unioesConsolidadas.get(l.source) ?? l.source;
    if (!unioes.has(uidAlvo) || !pessoas.has(l.target)) continue;
    const fLista = filhosDaUniaoBruto.get(uidAlvo)!;
    if (!fLista.includes(l.target)) {
      fLista.push(l.target);
    }
    uniaoDeOrigem.set(l.target, uidAlvo);
    if (l.tipo_vinculo) tipoVinculo.set(l.target, l.tipo_vinculo);
  }

  const filhosTotalDaUniao = new Map<string, number>();
  for (const [uid, lista] of filhosDaUniaoBruto) {
    filhosTotalDaUniao.set(uid, lista.length);
  }

  // Identifica recursivamente todos os descendentes das uniões colapsadas
  const ocultados = new Set<string>();
  if (unioesColapsadas && unioesColapsadas.size > 0) {
    const fila: string[] = [];
    for (const cuid of unioesColapsadas) {
      for (const f of filhosDaUniaoBruto.get(cuid) ?? []) {
        fila.push(f);
      }
    }
    while (fila.length > 0) {
      const pid = fila.shift()!;
      if (ocultados.has(pid)) continue;
      ocultados.add(pid);
      for (const uid of unioesDoParceiro.get(pid) ?? []) {
        for (const neto of filhosDaUniaoBruto.get(uid) ?? []) {
          fila.push(neto);
        }
      }
    }
  }

  const filhosDaUniao = new Map<string, string[]>();
  for (const [uid, lista] of filhosDaUniaoBruto) {
    if (unioesColapsadas?.has(uid)) {
      filhosDaUniao.set(uid, []);
    } else {
      filhosDaUniao.set(
        uid,
        lista.filter((f) => !ocultados.has(f)),
      );
    }
  }

  // Ordem dos irmãos: o backend já devolve por `ordem`, mas quem tem ano de
  // nascimento conhecido manda — é o que um leitor espera de uma prole.
  // Quem não tem ano fica no fim, na ordem cadastrada, e nunca some.
  for (const [uid, filhos] of filhosDaUniao) {
    const posicaoOriginal = new Map(filhos.map((f, i) => [f, i]));
    filhos.sort((a, b) => {
      const anoA = pessoas.get(a)?.ano_nascimento ?? null;
      const anoB = pessoas.get(b)?.ano_nascimento ?? null;
      if (anoA !== null && anoB !== null && anoA !== anoB) return anoA - anoB;
      if (anoA !== null && anoB === null) return -1;
      if (anoA === null && anoB !== null) return 1;
      return posicaoOriginal.get(a)! - posicaoOriginal.get(b)!;
    });
    filhosDaUniao.set(uid, filhos);
  }

  return {
    pessoas,
    unioes,
    unioesDoParceiro,
    filhosDaUniao,
    filhosTotalDaUniao,
    uniaoDeOrigem,
    tipoVinculo,
    ocultados,
  };
}

// ---------------------------------------------------------------------------
// Gerações
// ---------------------------------------------------------------------------

/**
 * Atribui a geração de cada pessoa.
 *
 * Regra: a geração de um filho é uma abaixo da mais funda entre pai e mãe, e
 * cônjuges ficam sempre na mesma linha (senão o anel da união sairia torto).
 * As duas regras se influenciam, então itera-se até estabilizar.
 *
 * O limite de iterações não é decoração: um acervo importado de fora pode
 * chegar com um ciclo, e sem o limite isto rodaria para sempre.
 */
function calcularGeracoes(idx: Indice): Map<string, number> {
  const geracao = new Map<string, number>();
  for (const id of idx.pessoas.keys()) geracao.set(id, 0);

  function ehAncestral(ancestralId: string, descendenteId: string): boolean {
    if (ancestralId === descendenteId) return true;
    const visitados = new Set<string>();
    const fila = [descendenteId];
    while (fila.length > 0) {
      const atual = fila.pop()!;
      if (visitados.has(atual)) continue;
      visitados.add(atual);
      const uOrigem = idx.uniaoDeOrigem.get(atual);
      if (!uOrigem) continue;
      const u = idx.unioes.get(uOrigem);
      if (!u) continue;
      if (u.slot_masculino_id === ancestralId || u.slot_feminino_id === ancestralId) {
        return true;
      }
      if (idx.pessoas.has(u.slot_masculino_id)) fila.push(u.slot_masculino_id);
      if (idx.pessoas.has(u.slot_feminino_id)) fila.push(u.slot_feminino_id);
    }
    return false;
  }

  const MAX_ITERACOES = idx.pessoas.size + 10;

  for (let i = 0; i < MAX_ITERACOES; i++) {
    let mudou = false;

    // Filhos descem em relação aos pais.
    for (const [uid, filhos] of idx.filhosDaUniao) {
      const u = idx.unioes.get(uid);
      if (!u) continue;
      const gPai = geracao.get(u.slot_masculino_id) ?? 0;
      const gMae = geracao.get(u.slot_feminino_id) ?? 0;
      const alvo = Math.max(gPai, gMae) + 1;
      for (const f of filhos) {
        if ((geracao.get(f) ?? 0) < alvo && !ehAncestral(f, u.slot_masculino_id) && !ehAncestral(f, u.slot_feminino_id)) {
          geracao.set(f, alvo);
          mudou = true;
        }
      }
    }

    // Cônjuges se alinham na mesma geração (exceto se houver ciclo ancestral-descendente).
    for (const u of idx.unioes.values()) {
      if (u.slot_masculino_id === u.slot_feminino_id) continue;
      if (
        ehAncestral(u.slot_masculino_id, u.slot_feminino_id) ||
        ehAncestral(u.slot_feminino_id, u.slot_masculino_id)
      ) {
        continue;
      }
      const gM = geracao.get(u.slot_masculino_id);
      const gF = geracao.get(u.slot_feminino_id);
      if (gM === undefined || gF === undefined) continue;
      const alvo = Math.max(gM, gF);
      if (gM < alvo) {
        geracao.set(u.slot_masculino_id, alvo);
        mudou = true;
      }
      if (gF < alvo) {
        geracao.set(u.slot_feminino_id, alvo);
        mudou = true;
      }
    }

    if (!mudou) break;
  }

  // Alinhamento cronológico de raízes secundárias desconectadas:
  // Se houver uma linhagem profunda (maxGer >= 4) e raízes isoladas com ano de nascimento
  // conhecido, aproxima a geração inicial da raiz para que contemporâneos não fiquem no topo da árvore.
  let minAno = Number.MAX_VALUE;
  let maxAno = Number.MIN_VALUE;
  let maxGer = 0;
  for (const [id, g] of geracao) {
    if (g > maxGer) maxGer = g;
    const ano = idx.pessoas.get(id)?.ano_nascimento;
    if (ano != null) {
      if (ano < minAno) minAno = ano;
      if (ano > maxAno) maxAno = ano;
    }
  }

  if (maxGer >= 4 && minAno < maxAno) {
    const anosPorGer = (maxAno - minAno) / maxGer;
    if (anosPorGer > 5) {
      let ajustou = false;
      for (const [id, p] of idx.pessoas) {
        if (!idx.uniaoDeOrigem.has(id) && (geracao.get(id) ?? 0) === 0 && p.ano_nascimento != null) {
          const gEstimada = Math.min(
            maxGer,
            Math.max(0, Math.round((p.ano_nascimento - minAno) / anosPorGer)),
          );
          if (gEstimada > 0) {
            geracao.set(id, gEstimada);
            ajustou = true;
          }
        }
      }

      if (ajustou) {
        for (let i = 0; i < MAX_ITERACOES; i++) {
          let mudou = false;
          for (const [uid, filhos] of idx.filhosDaUniao) {
            const u = idx.unioes.get(uid);
            if (!u) continue;
            const gPai = geracao.get(u.slot_masculino_id) ?? 0;
            const gMae = geracao.get(u.slot_feminino_id) ?? 0;
            const alvo = Math.max(gPai, gMae) + 1;
            for (const f of filhos) {
              if ((geracao.get(f) ?? 0) < alvo && !ehAncestral(f, u.slot_masculino_id) && !ehAncestral(f, u.slot_feminino_id)) {
                geracao.set(f, alvo);
                mudou = true;
              }
            }
          }
          for (const u of idx.unioes.values()) {
            if (u.slot_masculino_id === u.slot_feminino_id) continue;
            if (
              ehAncestral(u.slot_masculino_id, u.slot_feminino_id) ||
              ehAncestral(u.slot_feminino_id, u.slot_masculino_id)
            ) {
              continue;
            }
            const gM = geracao.get(u.slot_masculino_id);
            const gF = geracao.get(u.slot_feminino_id);
            if (gM === undefined || gF === undefined) continue;
            const alvo = Math.max(gM, gF);
            if (gM < alvo) {
              geracao.set(u.slot_masculino_id, alvo);
              mudou = true;
            }
            if (gF < alvo) {
              geracao.set(u.slot_feminino_id, alvo);
              mudou = true;
            }
          }
          if (!mudou) break;
        }
      }
    }
  }

  // Compressão de gerações vazias: garante que não haja faixas verticais em branco
  const geracoesOcupadas = [
    ...new Set(
      [...geracao.entries()]
        .filter(([id]) => !idx.ocultados.has(id))
        .map(([, g]) => g),
    ),
  ].sort((a, b) => a - b);

  if (geracoesOcupadas.length > 0) {
    const mapaCompacto = new Map<number, number>(
      geracoesOcupadas.map((g, idxComp) => [g, idxComp]),
    );
    for (const [id, g] of geracao) {
      geracao.set(id, mapaCompacto.get(g) ?? 0);
    }
  }

  return geracao;
}

// ---------------------------------------------------------------------------
// Resolução de Colisões Horizontais
// ---------------------------------------------------------------------------

/**
 * Garante que nenhum card de pessoa ou anel de união se sobreponha horizontalmente
 * em nenhuma linha de geração. Em convergência de ramos, árvores complexas ou consanguinidade,
 * afasta os cards adjacentes com garantia matemática de espaçamento mínimo.
 */
function resolverColisoesHorizontais(
  posPessoa: Map<string, { x: number; y: number }>,
  posUniao: Map<string, { x: number; y: number }>,
  idx: Indice,
  geracao: Map<string, number>,
): void {
  const { larguraNo, espacoIrmaos } = METRICAS;
  const distanciaMinima = larguraNo + espacoIrmaos;

  // 1. Agrupa os IDs de pessoas por geração
  const pessoasPorGeracao = new Map<number, string[]>();
  for (const [id] of posPessoa) {
    const g = geracao.get(id) ?? 0;
    const lista = pessoasPorGeracao.get(g) ?? [];
    lista.push(id);
    pessoasPorGeracao.set(g, lista);
  }

  // 2. Para cada linha de geração, ordena por X e afasta nós sobrepostos
  for (const [, pids] of pessoasPorGeracao) {
    if (pids.length <= 1) continue;

    pids.sort((a, b) => posPessoa.get(a)!.x - posPessoa.get(b)!.x);

    for (let i = 0; i < pids.length - 1; i++) {
      const p1 = pids[i];
      const p2 = pids[i + 1];
      const pos1 = posPessoa.get(p1)!;
      const pos2 = posPessoa.get(p2)!;

      const dist = pos2.x - pos1.x;
      if (dist < distanciaMinima) {
        const delta = distanciaMinima - dist;
        // Desloca o nó conflitante e todos os nós subsequentes nesta mesma linha
        for (let j = i + 1; j < pids.length; j++) {
          const pj = pids[j];
          const curr = posPessoa.get(pj)!;
          posPessoa.set(pj, { x: curr.x + delta, y: curr.y });
        }
      }
    }
  }

  // 3. Reajusta a posição dos anéis de união para que fiquem centralizados
  for (const [uid, u] of idx.unioes) {
    const pM = posPessoa.get(u.slot_masculino_id);
    const pF = posPessoa.get(u.slot_feminino_id);
    if (!pM && !pF) continue;

    let xAnel: number;
    if (pM && pF && u.slot_masculino_id !== u.slot_feminino_id) {
      const dist = Math.abs(pM.x - pF.x);
      // Se ambos os parceiros estão adjacentes (até distância de casal com folga):
      if (dist <= METRICAS.larguraNo * 2 + METRICAS.espacoCasal * 2) {
        xAnel = (pM.x + pF.x) / 2;
      } else {
        // Se estão distantes (ex.: um parceiro compartilhado em outra família/ramo),
        // preserva a posição original do anel ancorado sobre a prole / parceiro local
        xAnel = posUniao.get(uid)?.x ?? (pM.x + pF.x) / 2;
      }
    } else if (pM) {
      xAnel = pM.x;
    } else if (pF) {
      xAnel = pF.x;
    } else {
      continue;
    }

    const yAnel = (pM ?? pF)!.y;
    posUniao.set(uid, { x: xAnel, y: yAnel });
  }
}

// ---------------------------------------------------------------------------
// Layout
// ---------------------------------------------------------------------------

export function calcularLayout(
  grafo: TreeGraph,
  unioesColapsadas?: Set<string>,
): LayoutArvore {
  const idx = indexar(grafo, unioesColapsadas);
  const geracao = calcularGeracoes(idx);

  const { larguraNo, espacoCasal, espacoIrmaos, espacoBlocos, alturaGeracao, margem } = METRICAS;
  const larguraCasal = larguraNo * 2 + espacoCasal;

  // --- Ordenação estável das pessoas e identificação de raízes ---
  const ordemEstavel = [...idx.pessoas.keys()].sort((a, b) => {
    const ga = geracao.get(a) ?? 0;
    const gb = geracao.get(b) ?? 0;
    if (ga !== gb) return ga - gb;
    const pa = idx.pessoas.get(a)!;
    const pb = idx.pessoas.get(b)!;
    const anoA = pa.ano_nascimento ?? Number.MAX_SAFE_INTEGER;
    const anoB = pb.ano_nascimento ?? Number.MAX_SAFE_INTEGER;
    if (anoA !== anoB) return anoA - anoB;
    return a.localeCompare(b);
  });

  const raizes = ordemEstavel.filter(
    (id) => !idx.uniaoDeOrigem.has(id) && !idx.ocultados.has(id),
  );

  // --- Propriedade Única de União (Single-Ownership Union Layout) ---
  // Em árvores com consanguinidade ou casamento entre ramos colaterais (Darwin x Emma Wedgwood,
  // Franklin Roosevelt x Eleanor), a prole era medida duas vezes se ambos os cônjuges liderassem
  // a medição do bloco. Atribuímos a propriedade da união prioritariamente ao parceiro que descende
  // da linhagem (tem união de origem); se ambos ou nenhum descendem, segue a ordem a partir do topo/raízes.
  const uniaoDona = new Map<string, string>();

  for (const [uid, u] of idx.unioes) {
    if (u.slot_masculino_id === u.slot_feminino_id) {
      uniaoDona.set(uid, u.slot_masculino_id);
      continue;
    }
    const mEhDesc = idx.uniaoDeOrigem.has(u.slot_masculino_id);
    const fEhDesc = idx.uniaoDeOrigem.has(u.slot_feminino_id);
    if (mEhDesc && !fEhDesc) {
      uniaoDona.set(uid, u.slot_masculino_id);
    } else if (fEhDesc && !mEhDesc) {
      uniaoDona.set(uid, u.slot_feminino_id);
    } else {
      const mUnioes = idx.unioesDoParceiro.get(u.slot_masculino_id)?.length ?? 0;
      const fUnioes = idx.unioesDoParceiro.get(u.slot_feminino_id)?.length ?? 0;
      if (mUnioes > fUnioes) {
        uniaoDona.set(uid, u.slot_masculino_id);
      } else if (fUnioes > mUnioes) {
        uniaoDona.set(uid, u.slot_feminino_id);
      }
    }
  }

  const visitadosDono = new Set<string>();
  const filaDono = [...raizes, ...ordemEstavel];

  while (filaDono.length > 0) {
    const curr = filaDono.shift()!;
    if (visitadosDono.has(curr)) continue;
    visitadosDono.add(curr);

    for (const uid of idx.unioesDoParceiro.get(curr) ?? []) {
      if (!uniaoDona.has(uid)) {
        uniaoDona.set(uid, curr);
        const u = idx.unioes.get(uid);
        if (u) {
          const conjuge = u.slot_masculino_id === curr ? u.slot_feminino_id : u.slot_masculino_id;
          if (idx.pessoas.has(conjuge) && !visitadosDono.has(conjuge)) {
            filaDono.push(conjuge);
          }
          for (const f of idx.filhosDaUniao.get(uid) ?? []) {
            if (!visitadosDono.has(f)) {
              filaDono.push(f);
            }
          }
        }
      }
    }
  }

  for (const [uid, u] of idx.unioes) {
    if (!uniaoDona.has(uid)) {
      uniaoDona.set(uid, u.slot_masculino_id);
    }
  }

  // Uniões já consumidas por uma passagem anterior — evita desenhar o mesmo
  // casal duas vezes quando os dois cônjuges são alcançáveis pela raiz.
  const unioesConsumidas = new Set<string>();
  const medidaPessoa = new Map<string, number>();
  const medidaBloco = new Map<string, number>();

  /** Uniões que esta pessoa "lidera" no desenho — pertencentes a ela e ainda não consumidas. */
  function unioesLideradas(id: string): string[] {
    return (idx.unioesDoParceiro.get(id) ?? []).filter(
      (u) => uniaoDona.get(u) === id && !unioesConsumidas.has(u),
    );
  }

  // --- Passada 1: medir ---------------------------------------------------

  function medirFilhos(uid: string): number {
    const filhos = idx.filhosDaUniao.get(uid) ?? [];
    if (filhos.length === 0) return 0;
    let total = 0;
    for (const f of filhos) total += medirPessoa(f) + espacoIrmaos;
    return total - espacoIrmaos;
  }

  function medirBloco(uid: string): number {
    const cache = medidaBloco.get(uid);
    if (cache !== undefined) return cache;
    const u = idx.unioes.get(uid);
    const ehMesmoSlot = u ? u.slot_masculino_id === u.slot_feminino_id : false;
    const temDoisConjuges =
      !ehMesmoSlot &&
      u != null &&
      idx.pessoas.has(u.slot_masculino_id) &&
      idx.pessoas.has(u.slot_feminino_id);
    const larguraBase = temDoisConjuges ? larguraCasal : larguraNo;
    medidaBloco.set(uid, larguraBase); // trava contra recursão cíclica
    const largura = Math.max(larguraBase, medirFilhos(uid));
    medidaBloco.set(uid, largura);
    return largura;
  }

  function medirPessoa(id: string): number {
    const cache = medidaPessoa.get(id);
    if (cache !== undefined) return cache;
    medidaPessoa.set(id, larguraNo);

    const unioes = unioesLideradas(id);
    if (unioes.length === 0) {
      medidaPessoa.set(id, larguraNo);
      return larguraNo;
    }

    if (unioes.length === 1) {
      const res = Math.max(larguraNo, medirBloco(unioes[0]));
      medidaPessoa.set(id, res);
      return res;
    }

    // Múltiplas uniões lideradas por esta pessoa:
    const comFilhos = unioes.filter((uid) => (idx.filhosDaUniao.get(uid)?.length ?? 0) > 0);
    const semFilhos = unioes.filter((uid) => (idx.filhosDaUniao.get(uid)?.length ?? 0) === 0);

    if (comFilhos.length <= 1) {
      // Caso Pedro I & Marquesa de Santos: apenas 1 união tem descendência própria (ou nenhuma).
      // A união principal com filhos é colocada sobre sua prole. Cônjuges sem filhos
      // flanqueiam o parceiro no lado livre com espaçamento padrão de casal.
      const uPrincipal = comFilhos[0] ?? unioes[0];
      const blocoPrincipal = medirBloco(uPrincipal);
      const casalX0Rel = (blocoPrincipal - larguraCasal) / 2;
      const uPrinc = idx.unioes.get(uPrincipal)!;
      const idEhMasculino = uPrinc.slot_masculino_id === id;
      const xPessoaRel = idEhMasculino
        ? casalX0Rel + larguraNo / 2
        : casalX0Rel + larguraNo + espacoCasal + larguraNo / 2;

      const qtdSemFilhos = semFilhos.filter((uid) => uid !== uPrincipal).length;
      let res = blocoPrincipal;
      if (qtdSemFilhos > 0) {
        if (idEhMasculino) {
          const espacoNecessarioEsq = qtdSemFilhos * (larguraNo + espacoCasal);
          const espacoDisponivelEsq = xPessoaRel - larguraNo / 2;
          if (espacoNecessarioEsq > espacoDisponivelEsq) {
            res += espacoNecessarioEsq - espacoDisponivelEsq;
          }
        } else {
          const espacoNecessarioDir = qtdSemFilhos * (larguraNo + espacoCasal);
          const espacoDisponivelDir = blocoPrincipal - (xPessoaRel + larguraNo / 2);
          if (espacoNecessarioDir > espacoDisponivelDir) {
            res += espacoNecessarioDir - espacoDisponivelDir;
          }
        }
      }
      const finalRes = Math.max(larguraNo, res);
      medidaPessoa.set(id, finalRes);
      return finalRes;
    }

    // Múltiplas uniões com descendência separada:
    let total = 0;
    for (const uid of unioes) total += medirBloco(uid) + espacoBlocos;
    total -= espacoBlocos;

    const res = Math.max(larguraNo, total);
    medidaPessoa.set(id, res);
    return res;
  }

  // --- Passada 2: colocar -------------------------------------------------

  const posPessoa = new Map<string, { x: number; y: number }>();
  const posUniao = new Map<string, { x: number; y: number }>();
  const colocadas = new Set<string>();

  function y(id: string): number {
    return (geracao.get(id) ?? 0) * alturaGeracao;
  }

  function posicionarFilhosCompactados(uid: string, cursorBloco: number, larguraBloco: number): void {
    const filhos = idx.filhosDaUniao.get(uid) ?? [];
    if (filhos.length === 0) return;

    const larguraFilhos = medirFilhos(uid);
    let cursorFilho = cursorBloco + (larguraBloco - larguraFilhos) / 2;

    const pessoasDosIrmaosAnteriores: string[] = [];
    const todasPessoasDosFilhos: string[] = [];
    const todasUnioesDosFilhos: string[] = [];

    for (let i = 0; i < filhos.length; i++) {
      const f = filhos[i];
      const larguraFilho = medirPessoa(f);
      const pessoasAntes = new Set(posPessoa.keys());
      const unioesAntes = new Set(posUniao.keys());

      colocarPessoa(f, cursorFilho);
      cursorFilho += larguraFilho + espacoIrmaos;

      const novasPessoas = [...posPessoa.keys()].filter((k) => !pessoasAntes.has(k));
      const novasUnioes = [...posUniao.keys()].filter((k) => !unioesAntes.has(k));

      if (i > 0 && novasPessoas.length > 0 && pessoasDosIrmaosAnteriores.length > 0) {
        let menorFolga = Number.POSITIVE_INFINITY;
        for (const pNovo of novasPessoas) {
          const g = geracao.get(pNovo) ?? 0;
          const esqNovo = posPessoa.get(pNovo)!.x - larguraNo / 2;
          for (const pAnt of pessoasDosIrmaosAnteriores) {
            if ((geracao.get(pAnt) ?? 0) !== g) continue;
            const dirAnt = posPessoa.get(pAnt)!.x + larguraNo / 2;
            const folga = esqNovo - dirAnt;
            if (folga < menorFolga) menorFolga = folga;
          }
        }

        if (menorFolga < Number.POSITIVE_INFINITY && menorFolga > espacoIrmaos) {
          const recuo = menorFolga - espacoIrmaos;
          for (const pNovo of novasPessoas) {
            const pos = posPessoa.get(pNovo)!;
            posPessoa.set(pNovo, { x: pos.x - recuo, y: pos.y });
          }
          for (const uNovo of novasUnioes) {
            const pos = posUniao.get(uNovo)!;
            posUniao.set(uNovo, { x: pos.x - recuo, y: pos.y });
          }
        }
      }

      pessoasDosIrmaosAnteriores.push(...novasPessoas);
      todasPessoasDosFilhos.push(...novasPessoas);
      todasUnioesDosFilhos.push(...novasUnioes);
    }

    // Se houve compactação entre os irmãos na geração direta dos filhos,
    // centraliza o grupo de filhos sob o anel da união (mantendo dentro dos limites do bloco).
    const posAnel = posUniao.get(uid);
    const filhosColocados = filhos.filter((f) => posPessoa.has(f));
    if (posAnel && filhosColocados.length > 1 && todasPessoasDosFilhos.length > 0) {
      const xPrimeiroFilho = posPessoa.get(filhosColocados[0])!.x;
      const xUltimoFilho = posPessoa.get(filhosColocados[filhosColocados.length - 1])!.x;
      const centroFilhos = (xPrimeiroFilho + xUltimoFilho) / 2;
      let delta = posAnel.x - centroFilhos;

      let minEsq = Number.POSITIVE_INFINITY;
      let maxDir = Number.NEGATIVE_INFINITY;
      for (const p of todasPessoasDosFilhos) {
        const x = posPessoa.get(p)!.x;
        if (x - larguraNo / 2 < minEsq) minEsq = x - larguraNo / 2;
        if (x + larguraNo / 2 > maxDir) maxDir = x + larguraNo / 2;
      }

      if (minEsq + delta < cursorBloco) {
        delta = Math.max(0, cursorBloco - minEsq);
      }
      if (maxDir + delta > cursorBloco + larguraBloco) {
        delta = Math.min(0, cursorBloco + larguraBloco - maxDir);
      }

      if (Math.abs(delta) > 1) {
        for (const p of todasPessoasDosFilhos) {
          const pos = posPessoa.get(p)!;
          posPessoa.set(p, { x: pos.x + delta, y: pos.y });
        }
        for (const uId of todasUnioesDosFilhos) {
          const pos = posUniao.get(uId)!;
          posUniao.set(uId, { x: pos.x + delta, y: pos.y });
        }
      }
    }
  }

  function colocarPessoa(id: string, x0: number): void {
    if (colocadas.has(id) || idx.ocultados.has(id)) return;
    colocadas.add(id);

    const unioes = unioesLideradas(id);

    if (unioes.length === 0) {
      posPessoa.set(id, { x: x0 + larguraNo / 2, y: y(id) });
      return;
    }

    const comFilhos = unioes.filter((uid) => (idx.filhosDaUniao.get(uid)?.length ?? 0) > 0);

    // Se temos mais de uma união e no máximo UMA delas tem filhos próprios:
    // Flanqueia o parceiro com os cônjuges sem filhos no lado livre
    if (unioes.length > 1 && comFilhos.length <= 1) {
      const uPrincipal = comFilhos[0] ?? unioes[0];
      const uSecundarias = unioes.filter((uid) => uid !== uPrincipal);

      const blocoPrincipal = medirBloco(uPrincipal);
      const uPrinc = idx.unioes.get(uPrincipal)!;
      const ehMesmoSlot = uPrinc.slot_masculino_id === uPrinc.slot_feminino_id;
      const conjugePrincipalId =
        uPrinc.slot_masculino_id === id ? uPrinc.slot_feminino_id : uPrinc.slot_masculino_id;
      const temConjuge = !ehMesmoSlot && idx.pessoas.has(conjugePrincipalId) && conjugePrincipalId !== id;

      const casalX0Rel = temConjuge ? (blocoPrincipal - larguraCasal) / 2 : (blocoPrincipal - larguraNo) / 2;
      const idEhMasculino = uPrinc.slot_masculino_id === id;
      const xPessoaRel = temConjuge
        ? (idEhMasculino ? casalX0Rel + larguraNo / 2 : casalX0Rel + larguraNo + espacoCasal + larguraNo / 2)
        : casalX0Rel + larguraNo / 2;

      let offsetEsq = 0;
      if (idEhMasculino) {
        const espacoNecessarioEsq = uSecundarias.length * (larguraNo + espacoCasal);
        const espacoDisponivelEsq = xPessoaRel - larguraNo / 2;
        if (espacoNecessarioEsq > espacoDisponivelEsq) {
          offsetEsq = espacoNecessarioEsq - espacoDisponivelEsq;
        }
      }

      const cursorPrincipal = x0 + offsetEsq;
      unioesConsumidas.add(uPrincipal);

      if (!temConjuge) {
        const casalX0 = cursorPrincipal + casalX0Rel;
        posPessoa.set(id, { x: casalX0 + larguraNo / 2, y: y(id) });
        posUniao.set(uPrincipal, { x: posPessoa.get(id)!.x, y: y(id) });
      } else {
        const casalX0 = cursorPrincipal + casalX0Rel;
        const xEsquerda = casalX0 + larguraNo / 2;
        const xDireita = casalX0 + larguraNo + espacoCasal + larguraNo / 2;
        const xPessoa = idEhMasculino ? xEsquerda : xDireita;
        const xConjuge = idEhMasculino ? xDireita : xEsquerda;

        posPessoa.set(id, { x: xPessoa, y: y(id) });
        if (!colocadas.has(conjugePrincipalId)) {
          colocadas.add(conjugePrincipalId);
          posPessoa.set(conjugePrincipalId, { x: xConjuge, y: y(conjugePrincipalId) });
        }
        posUniao.set(uPrincipal, { x: (xPessoa + xConjuge) / 2, y: y(id) });
      }

      posicionarFilhosCompactados(uPrincipal, cursorPrincipal, blocoPrincipal);

      // Posiciona os cônjuges sem filhos no lado livre
      const xId = posPessoa.get(id)!.x;
      let step = 1;
      for (const uSecId of uSecundarias) {
        unioesConsumidas.add(uSecId);
        const uSec = idx.unioes.get(uSecId)!;
        const conjId = uSec.slot_masculino_id === id ? uSec.slot_feminino_id : uSec.slot_masculino_id;
        const temConj =
          uSec.slot_masculino_id !== uSec.slot_feminino_id && idx.pessoas.has(conjId) && conjId !== id;

        if (temConj) {
          let xConj: number;
          let xAnel: number;
          if (idEhMasculino) {
            xConj = xId - step * (larguraNo + espacoCasal);
            xAnel = (xId - (step - 1) * (larguraNo + espacoCasal) + xConj) / 2;
          } else {
            xConj = xId + step * (larguraNo + espacoCasal);
            xAnel = (xId + (step - 1) * (larguraNo + espacoCasal) + xConj) / 2;
          }

          if (!colocadas.has(conjId)) {
            colocadas.add(conjId);
            posPessoa.set(conjId, { x: xConj, y: y(conjId) });
          }
          posUniao.set(uSecId, { x: xAnel, y: y(id) });
          step++;
        } else {
          posUniao.set(uSecId, { x: xId, y: y(id) });
        }
      }

      return;
    }

    let cursor = x0;
    let primeiraUniao = true;

    for (const uid of unioes) {
      unioesConsumidas.add(uid);
      const u = idx.unioes.get(uid)!;
      const bloco = medirBloco(uid);

      const ehMesmoSlot = u.slot_masculino_id === u.slot_feminino_id;
      const conjugeId = u.slot_masculino_id === id ? u.slot_feminino_id : u.slot_masculino_id;
      const temConjuge = !ehMesmoSlot && idx.pessoas.has(conjugeId) && conjugeId !== id;

      if (!temConjuge) {
        // Família monoparental (mãe ou pai solo, ou ancestral único)
        const casalX0 = cursor + (bloco - larguraNo) / 2;
        const xPessoa = casalX0 + larguraNo / 2;

        if (primeiraUniao) {
          posPessoa.set(id, { x: xPessoa, y: y(id) });
          primeiraUniao = false;
        }

        posUniao.set(uid, { x: posPessoa.get(id)!.x, y: y(id) });
      } else {
        // Casal biparental: centralizado dentro do bloco sobre a própria prole
        const casalX0 = cursor + (bloco - larguraCasal) / 2;

        const idEhMasculino = u.slot_masculino_id === id;
        const xEsquerda = casalX0 + larguraNo / 2;
        const xDireita = casalX0 + larguraNo + espacoCasal + larguraNo / 2;

        const xPessoa = idEhMasculino ? xEsquerda : xDireita;
        const xConjuge = idEhMasculino ? xDireita : xEsquerda;

        if (primeiraUniao) {
          posPessoa.set(id, { x: xPessoa, y: y(id) });
          primeiraUniao = false;
        }

        const conjugeJaColocado = colocadas.has(conjugeId);
        if (!conjugeJaColocado) {
          colocadas.add(conjugeId);
          posPessoa.set(conjugeId, { x: xConjuge, y: y(conjugeId) });
        }

        const xr = posPessoa.get(id)?.x ?? xPessoa;
        let xAnel: number;
        if (conjugeJaColocado) {
          const xc = posPessoa.get(conjugeId)!.x;
          xAnel = (xr + xc) / 2;
        } else {
          // O anel fica centralizado no casal deste bloco (sobre sua própria prole),
          // mesmo que 'id' já tenha sido posicionado numa união anterior
          xAnel = (xEsquerda + xDireita) / 2;
        }
        posUniao.set(uid, { x: xAnel, y: y(id) });
      }

      // Filhos: centralizados e compactados por contorno por geração sob o bloco
      posicionarFilhosCompactados(uid, cursor, bloco);

      cursor += bloco + espacoBlocos;
    }
  }

  // --- Raízes -------------------------------------------------------------
  //
  // Começa por quem não é filho de ninguém — os ancestrais do topo. Depois
  // varre o resto para não deixar de fora componentes desconectados (o acervo
  // pode ter várias famílias sem ligação entre si, seção 5).

  let cursorRaiz = 0;
  for (const raiz of [...raizes, ...ordemEstavel]) {
    if (colocadas.has(raiz) || idx.ocultados.has(raiz)) continue;
    const largura = medirPessoa(raiz);

    // Se esta raiz possui filhos já alocados no desenho (ex.: Erasmus Darwin cujo filho Robert
    // já foi posicionado pelo casamento com Susannah Wedgwood), posiciona a raiz diretamente sobre seus filhos!
    const filhosColocados: number[] = [];
    for (const uid of idx.unioesDoParceiro.get(raiz) ?? []) {
      for (const f of idx.filhosDaUniao.get(uid) ?? []) {
        const pf = posPessoa.get(f);
        if (pf) filhosColocados.push(pf.x);
      }
    }

    if (filhosColocados.length > 0) {
      const avgX = filhosColocados.reduce((a, b) => a + b, 0) / filhosColocados.length;
      colocarPessoa(raiz, avgX - largura / 2);
    } else {
      colocarPessoa(raiz, cursorRaiz);
      cursorRaiz += largura + espacoBlocos;
    }
  }

  // --- Passada 3: Resolução de Colisões Horizontais por Linha de Geração ---
  //
  // Garante que nenhum card de pessoa se sobreponha horizontalmente em nenhuma
  // linha de geração. Em convergência de ramos, árvores complexas ou consanguinidade,
  // afasta os cards adjacentes com garantia matemática de espaçamento mínimo.
  resolverColisoesHorizontais(posPessoa, posUniao, idx, geracao);

  // --- Normalização e saída ----------------------------------------------

  const todosX = [...posPessoa.values(), ...posUniao.values()].map((p) => p.x);
  const todosY = [...posPessoa.values(), ...posUniao.values()].map((p) => p.y);
  const minX = todosX.length ? Math.min(...todosX) : 0;
  const minY = todosY.length ? Math.min(...todosY) : 0;
  const deslocX = margem + larguraNo / 2 - minX;
  const deslocY = margem + METRICAS.alturaNo / 2 - minY;

  const pessoas: PosicaoPessoa[] = [];
  for (const [id, pos] of posPessoa) {
    const p = idx.pessoas.get(id);
    if (!p) continue;
    pessoas.push({
      ...p,
      x: pos.x + deslocX,
      y: pos.y + deslocY,
      geracao: geracao.get(id) ?? 0,
      tipo_vinculo: idx.tipoVinculo.get(id),
    });
  }

  const unioes: PosicaoUniao[] = [];
  for (const [id, pos] of posUniao) {
    const u = idx.unioes.get(id);
    if (!u) continue;
    unioes.push({
      ...u,
      x: pos.x + deslocX,
      y: pos.y + deslocY,
      geracao: geracao.get(u.slot_masculino_id) ?? 0,
      filhosTotal: idx.filhosTotalDaUniao.get(id) ?? 0,
      colapsada: unioesColapsadas?.has(id) ?? false,
    });
  }

  // --- Arestas ------------------------------------------------------------

  const arestas: ArestaLayout[] = [];
  const mapaPessoa = new Map(pessoas.map((p) => [p.id, p]));

  for (const u of unioes) {
    for (const [slot, tipo] of [
      [u.slot_masculino_id, 'pai_uniao'],
      [u.slot_feminino_id, 'mae_uniao'],
    ] as const) {
      const p = mapaPessoa.get(slot);
      if (!p) continue;
      arestas.push({
        id: `${slot}->${u.id}`,
        tipo,
        origem: { x: p.x, y: p.y },
        destino: { x: u.x, y: u.y },
      });
    }

    for (const filhoId of idx.filhosDaUniao.get(u.id) ?? []) {
      const f = mapaPessoa.get(filhoId);
      if (!f) continue;
      arestas.push({
        id: `${u.id}->${filhoId}`,
        tipo: 'uniao_filho',
        tipoVinculo: idx.tipoVinculo.get(filhoId),
        origem: { x: u.x, y: u.y },
        destino: { x: f.x, y: f.y },
      });
    }
  }

  const maxX = pessoas.length ? Math.max(...pessoas.map((p) => p.x)) : 0;
  const maxY = pessoas.length ? Math.max(...pessoas.map((p) => p.y)) : 0;

  return {
    pessoas,
    unioes,
    arestas,
    largura: maxX + larguraNo / 2 + margem,
    altura: maxY + METRICAS.alturaNo / 2 + margem,
  };
}

/**
 * Caminho SVG ortogonal entre dois pontos, descendo em L.
 *
 * A quebra fica no meio vertical do vão para que as linhas de irmãos se
 * encontrem na mesma altura e formem o "pente" que se espera de uma árvore
 * genealógica desenhada à mão.
 */
export function caminhoOrtogonal(
  origem: { x: number; y: number },
  destino: { x: number; y: number },
): string {
  if (Math.abs(origem.x - destino.x) < 0.5) {
    return `M ${origem.x} ${origem.y} L ${destino.x} ${destino.y}`;
  }
  // Em salto de geração única, quebra exatamente no ponto médio entre os nós.
  // Em saltos de 2+ gerações (deltaY > 250), a canaleta passa no vão da primeira geração (origem + 98px),
  // impedindo que a linha horizontal atravesse cartões de gerações intermediárias.
  const deltaY = destino.y - origem.y;
  let canaletaY: number;
  if (deltaY > 250) {
    canaletaY = origem.y + 98;
  } else if (deltaY < -250) {
    canaletaY = origem.y - 98;
  } else {
    canaletaY = (origem.y + destino.y) / 2;
  }
  return `M ${origem.x} ${origem.y} L ${origem.x} ${canaletaY} L ${destino.x} ${canaletaY} L ${destino.x} ${destino.y}`;
}
