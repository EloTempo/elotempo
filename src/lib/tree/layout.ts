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

// ---------------------------------------------------------------------------
// Métricas do desenho
// ---------------------------------------------------------------------------

export const METRICAS = {
  /** Largura do card de pessoa. */
  larguraNo: 220,
  /** Altura do card de pessoa. */
  alturaNo: 72,
  /** Vão entre os dois cônjuges — é onde o anel da união se encaixa. */
  espacoCasal: 64,
  /** Vão horizontal entre irmãos. */
  espacoIrmaos: 28,
  /** Vão entre blocos independentes (uniões distintas, raízes distintas). */
  espacoBlocos: 72,
  /** Distância vertical entre gerações. */
  alturaGeracao: 168,
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
  /** filhos de cada união, na ordem em que devem ser desenhados */
  filhosDaUniao: Map<string, string[]>;
  /** união da qual a pessoa é filha (no máximo uma — invariante da seção 3) */
  uniaoDeOrigem: Map<string, string>;
  tipoVinculo: Map<string, string>;
}

function indexar(grafo: TreeGraph): Indice {
  const pessoas = new Map(grafo.nodes.map((p) => [p.id, p]));
  const unioes = new Map(grafo.unions.map((u) => [u.id, u]));

  const unioesDoParceiro = new Map<string, string[]>();
  const filhosDaUniao = new Map<string, string[]>();
  const uniaoDeOrigem = new Map<string, string>();
  const tipoVinculo = new Map<string, string>();

  for (const u of grafo.unions) {
    for (const parceiro of [u.slot_masculino_id, u.slot_feminino_id]) {
      if (!pessoas.has(parceiro)) continue;
      const lista = unioesDoParceiro.get(parceiro) ?? [];
      lista.push(u.id);
      unioesDoParceiro.set(parceiro, lista);
    }
    filhosDaUniao.set(u.id, []);
  }

  for (const l of grafo.links) {
    if (l.tipo !== 'uniao_filho') continue;
    if (!unioes.has(l.source) || !pessoas.has(l.target)) continue;
    filhosDaUniao.get(l.source)!.push(l.target);
    uniaoDeOrigem.set(l.target, l.source);
    if (l.tipo_vinculo) tipoVinculo.set(l.target, l.tipo_vinculo);
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

  return { pessoas, unioes, unioesDoParceiro, filhosDaUniao, uniaoDeOrigem, tipoVinculo };
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
        if ((geracao.get(f) ?? 0) < alvo) {
          geracao.set(f, alvo);
          mudou = true;
        }
      }
    }

    // Cônjuges se alinham na mesma geração.
    for (const u of idx.unioes.values()) {
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

  return geracao;
}

// ---------------------------------------------------------------------------
// Layout
// ---------------------------------------------------------------------------

export function calcularLayout(grafo: TreeGraph): LayoutArvore {
  const idx = indexar(grafo);
  const geracao = calcularGeracoes(idx);

  const { larguraNo, espacoCasal, espacoIrmaos, espacoBlocos, alturaGeracao, margem } = METRICAS;
  const larguraCasal = larguraNo * 2 + espacoCasal;

  // Uniões já consumidas por uma passagem anterior — evita desenhar o mesmo
  // casal duas vezes quando os dois cônjuges são alcançáveis pela raiz.
  const unioesConsumidas = new Set<string>();
  const medidaPessoa = new Map<string, number>();
  const medidaBloco = new Map<string, number>();

  /** Uniões que esta pessoa "lidera" no desenho — as ainda não consumidas. */
  function unioesLideradas(id: string): string[] {
    return (idx.unioesDoParceiro.get(id) ?? []).filter((u) => !unioesConsumidas.has(u));
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
    medidaBloco.set(uid, larguraCasal); // trava contra recursão cíclica
    const largura = Math.max(larguraCasal, medirFilhos(uid));
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

    let total = 0;
    for (const uid of unioes) total += medirBloco(uid) + espacoBlocos;
    total -= espacoBlocos;

    medidaPessoa.set(id, total);
    return total;
  }

  // --- Passada 2: colocar -------------------------------------------------

  const posPessoa = new Map<string, { x: number; y: number }>();
  const posUniao = new Map<string, { x: number; y: number }>();
  const colocadas = new Set<string>();

  function y(id: string): number {
    return (geracao.get(id) ?? 0) * alturaGeracao;
  }

  function colocarPessoa(id: string, x0: number): void {
    if (colocadas.has(id)) return;
    colocadas.add(id);

    const unioes = unioesLideradas(id);

    if (unioes.length === 0) {
      posPessoa.set(id, { x: x0 + larguraNo / 2, y: y(id) });
      return;
    }

    let cursor = x0;
    let primeiraUniao = true;

    for (const uid of unioes) {
      unioesConsumidas.add(uid);
      const u = idx.unioes.get(uid)!;
      const bloco = medirBloco(uid);

      // O casal fica centralizado dentro do bloco, sobre a própria prole.
      const casalX0 = cursor + (bloco - larguraCasal) / 2;

      const conjugeId = u.slot_masculino_id === id ? u.slot_feminino_id : u.slot_masculino_id;
      // Quem está no slot masculino desenha à esquerda; é a convenção do
      // diagrama e mantém o desenho previsível entre aberturas.
      const idEhMasculino = u.slot_masculino_id === id;
      const xEsquerda = casalX0 + larguraNo / 2;
      const xDireita = casalX0 + larguraNo + espacoCasal + larguraNo / 2;

      const xPessoa = idEhMasculino ? xEsquerda : xDireita;
      const xConjuge = idEhMasculino ? xDireita : xEsquerda;

      // A pessoa fica onde a primeira união a colocou; uniões seguintes só
      // acrescentam cônjuges à direita.
      if (primeiraUniao) {
        posPessoa.set(id, { x: xPessoa, y: y(id) });
        primeiraUniao = false;
      }

      if (idx.pessoas.has(conjugeId) && !colocadas.has(conjugeId)) {
        colocadas.add(conjugeId);
        posPessoa.set(conjugeId, { x: xConjuge, y: y(conjugeId) });
      }

      // O anel fica entre os dois, na mesma linha do casal.
      const xr = posPessoa.get(id)!.x;
      const xc = posPessoa.get(conjugeId)?.x ?? xConjuge;
      posUniao.set(uid, { x: (xr + xc) / 2, y: y(id) });

      // Filhos: centralizados sob o bloco, não sob um dos pais.
      const filhos = idx.filhosDaUniao.get(uid) ?? [];
      if (filhos.length > 0) {
        const larguraFilhos = medirFilhos(uid);
        let cursorFilho = cursor + (bloco - larguraFilhos) / 2;
        for (const f of filhos) {
          // Medir ANTES de colocar. `colocarPessoa` consome as uniões do
          // filho, e uma medição feita depois disso volta encolhida —
          // exatamente a largura da caixa dele, sem a descendência.
          const larguraFilho = medirPessoa(f);
          colocarPessoa(f, cursorFilho);
          cursorFilho += larguraFilho + espacoIrmaos;
        }
      }

      cursor += bloco + espacoBlocos;
    }
  }

  // --- Raízes -------------------------------------------------------------
  //
  // Começa por quem não é filho de ninguém — os ancestrais do topo. Depois
  // varre o resto para não deixar de fora componentes desconectados (o acervo
  // pode ter várias famílias sem ligação entre si, seção 5).

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

  const raizes = ordemEstavel.filter((id) => !idx.uniaoDeOrigem.has(id));

  let cursorRaiz = 0;
  for (const raiz of [...raizes, ...ordemEstavel]) {
    if (colocadas.has(raiz)) continue;
    // Mesma armadilha de novo: a largura tem de ser medida com as uniões
    // ainda disponíveis, senão o próximo componente começa em cima deste.
    const largura = medirPessoa(raiz);
    colocarPessoa(raiz, cursorRaiz);
    cursorRaiz += largura + espacoBlocos;
  }

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
    pessoas.push({ ...p, x: pos.x + deslocX, y: pos.y + deslocY, geracao: geracao.get(id) ?? 0 });
  }

  const unioes: PosicaoUniao[] = [];
  for (const [id, pos] of posUniao) {
    const u = idx.unioes.get(id);
    if (!u) continue;
    unioes.push({ ...u, x: pos.x + deslocX, y: pos.y + deslocY, geracao: geracao.get(u.slot_masculino_id) ?? 0 });
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
  const meio = (origem.y + destino.y) / 2;
  return `M ${origem.x} ${origem.y} L ${origem.x} ${meio} L ${destino.x} ${meio} L ${destino.x} ${destino.y}`;
}
