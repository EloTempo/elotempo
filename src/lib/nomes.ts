/**
 * Sobrenomes segundo a convenção brasileira.
 *
 * No Brasil (como em Portugal, e ao contrário da Espanha) a ordem é
 * **materno primeiro, paterno por último**:
 *
 *     mãe:   Maria da Silva SANTOS
 *     pai:   João Ferreira COSTA
 *     filho: Pedro SANTOS COSTA
 *
 * O sobrenome que uma pessoa transmite aos filhos é, portanto, o **último**
 * dela — o que herdou do próprio pai. É essa a regra que este módulo aplica.
 *
 * Duas ressalvas que o código respeita:
 *
 * 1. **É convenção, não lei.** Muita gente carrega só um sobrenome, ou os dois
 *    invertidos, ou o da avó. Tudo aqui é *sugestão*: a interface preenche o
 *    campo e o usuário sobrescreve à vontade. Nada bloqueia o salvamento —
 *    mesmo espírito da regra de datas da seção 2.5.
 *
 * 2. **Partículas andam grudadas.** "da Silva" é uma unidade só; separar em
 *    "da" e "Silva" produziria sugestões absurdas. Sobrenomes compostos sem
 *    partícula ("Castello Branco", "Villas Boas") não têm como ser detectados
 *    — o usuário corrige, e é por isso que o campo continua editável.
 */

/** Partículas que se ligam ao sobrenome seguinte e nunca ficam sozinhas. */
const PARTICULAS = new Set(['de', 'da', 'do', 'das', 'dos', 'e', 'di', 'del', 'della', 'du', 'van', 'von', 'la', 'le']);

function ehParticula(palavra: string): boolean {
  return PARTICULAS.has(palavra.toLocaleLowerCase('pt-BR'));
}

/**
 * Divide o sobrenome em unidades transmissíveis.
 *
 *   "da Silva Santos"        -> ["da Silva", "Santos"]
 *   "Ferreira Costa"         -> ["Ferreira", "Costa"]
 *   "dos Santos"             -> ["dos Santos"]
 *   "Souza e Silva"          -> ["Souza e Silva"]
 */
export function unidadesDeSobrenome(sobrenome: string | null | undefined): string[] {
  const palavras = (sobrenome ?? '').trim().split(/\s+/).filter(Boolean);
  if (palavras.length === 0) return [];

  const unidades: string[] = [];
  let atual: string[] = [];

  for (const palavra of palavras) {
    if (ehParticula(palavra)) {
      // A partícula abre (ou continua) uma unidade; nunca a fecha.
      atual.push(palavra);
      continue;
    }
    atual.push(palavra);
    // Um "e" seguinte ainda pode emendar ("Souza e Silva"), então só fecha
    // a unidade se a próxima palavra não for partícula — o laço abaixo
    // resolve isso ao processar a palavra seguinte.
    unidades.push(atual.join(' '));
    atual = [];
  }

  // Sobrou partícula solta no fim ("Silva de"): gruda na última unidade.
  if (atual.length > 0) {
    if (unidades.length > 0) unidades[unidades.length - 1] += ' ' + atual.join(' ');
    else unidades.push(atual.join(' '));
  }

  // Junta unidades ligadas por "e": ["Souza", "e Silva"] -> ["Souza e Silva"]
  const juntadas: string[] = [];
  for (const unidade of unidades) {
    const comecaComE = /^e\s/i.test(unidade);
    if (comecaComE && juntadas.length > 0) {
      juntadas[juntadas.length - 1] += ' ' + unidade;
    } else {
      juntadas.push(unidade);
    }
  }

  return juntadas;
}

/**
 * O sobrenome que esta pessoa transmite aos filhos — o último dela.
 *
 * É também o que faz sentido usar para agrupar por linhagem nas estatísticas
 * da seção 7: agrupar pela string inteira separaria irmãos de primos sem
 * necessidade.
 */
export function sobrenomeDeFamilia(sobrenome: string | null | undefined): string {
  const unidades = unidadesDeSobrenome(sobrenome);
  return unidades.length > 0 ? unidades[unidades.length - 1] : '';
}

/** O sobrenome herdado da mãe — o primeiro, quando há mais de um. */
export function sobrenomeMaterno(sobrenome: string | null | undefined): string {
  const unidades = unidadesDeSobrenome(sobrenome);
  return unidades.length >= 2 ? unidades[0] : '';
}

/**
 * Sugere o sobrenome de um filho a partir dos pais: materno, depois paterno.
 *
 * Se só um dos pais tiver sobrenome, usa o dele sozinho — é o caso comum de
 * quem cadastra um filho conhecendo só um lado da família.
 */
export function sugerirSobrenomeDeFilho(
  sobrenomeDoPai: string | null | undefined,
  sobrenomeDaMae: string | null | undefined,
): string {
  const doPai = sobrenomeDeFamilia(sobrenomeDoPai);
  const daMae = sobrenomeDeFamilia(sobrenomeDaMae);

  if (doPai && daMae) {
    // Mesmo sobrenome dos dois lados não vira repetição.
    if (doPai.toLocaleLowerCase('pt-BR') === daMae.toLocaleLowerCase('pt-BR')) return doPai;
    return `${daMae} ${doPai}`;
  }
  return doPai || daMae;
}

/**
 * Sugere o sobrenome de um pai a partir do filho — o último do filho.
 *
 * Serve o caminho inverso: você cadastrou "Pedro Santos Costa", clica em
 * "adicionar pais", e ao identificar o pai o campo já vem com "Costa".
 */
export function sugerirSobrenomeDoPai(sobrenomeDoFilho: string | null | undefined): string {
  return sobrenomeDeFamilia(sobrenomeDoFilho);
}

/**
 * Sugere o sobrenome de uma mãe a partir do filho — o primeiro dele.
 *
 * Só arrisca quando o filho tem dois ou mais sobrenomes. Com um só, não há
 * como saber de que lado veio, e chutar seria pior do que deixar em branco.
 */
export function sugerirSobrenomeDaMae(sobrenomeDoFilho: string | null | undefined): string {
  return sobrenomeMaterno(sobrenomeDoFilho);
}
