import type { Sex } from '../../types';

/**
 * Decide qual dos dois vai para o slot masculino e qual vai para o feminino.
 *
 * A união tem sempre um slot de cada (invariante 2). O sexo decide; `X` e `U`
 * cabem nos dois lados, e é isso que torna o placeholder possível.
 *
 * Esta função **não valida** — quem valida é o domínio, em `regras.rs`. Aqui
 * só se escolhe a melhor acomodação possível. Quando não existe acomodação
 * válida (dois homens, por exemplo), o backend recusa com uma mensagem que
 * explica a regra, e é essa mensagem que o usuário lê. Duplicar a validação
 * aqui só criaria duas versões da regra para divergirem com o tempo.
 */
export function distribuirSlots(
  pessoaId: string,
  sexoPessoa: Sex,
  conjugeId: string,
  sexoConjuge: Sex,
): { masculino: string; feminino: string } {
  // Mulher nunca cabe no slot masculino: ela vai para o feminino, e o outro
  // ocupa o masculino (mesmo que isso venha a ser recusado adiante).
  if (sexoPessoa === 'F') return { masculino: conjugeId, feminino: pessoaId };

  // Homem do outro lado manda: ele fica no masculino. É o que resolve o caso
  // de quem tem sexo desconhecido casando com um homem conhecido.
  if (sexoConjuge === 'M') return { masculino: conjugeId, feminino: pessoaId };

  // Sobra o arranjo natural: quem está sendo editado à esquerda.
  return { masculino: pessoaId, feminino: conjugeId };
}
