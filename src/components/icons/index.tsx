/**
 * Ícones autorais do EloTempo.
 *
 * Derivam da construção do logo — traço reto, ponta arredondada, nó em círculo
 * cheio — mas **não são o logo reduzido**. A razão nó/traço do símbolo é
 * `34 ÷ 14 ≈ 2,4`; trazida para a grade de 24 do Lucide, onde o traço é 2, o nó
 * vira `r 2`, exatamente o dobro do traço. Reduzir o SVG do logo direto daria
 * traço 0,84 — invisível.
 *
 * A grade é a do Lucide de propósito: 87 ícones dele continuam no aplicativo, e
 * um autoral fora da grade fica gordo ao lado de um `Plus`.
 *
 * REGRAS, para quem acrescentar um ícone aqui:
 *
 * 1. `viewBox 0 0 24 24`, área viva de 2 a 22.
 * 2. Traço 2, constante — nunca varia dentro de um ícone.
 * 3. `strokeLinecap` e `strokeLinejoin` arredondados, sempre.
 * 4. Nó = círculo **cheio**, `r 2`. É uma pessoa ou um acontecimento.
 * 5. Nó **tracejado** = slot sem nome. Único uso do tracejado no sistema.
 * 6. `currentColor` no traço e no preenchimento — nenhuma cor fixa.
 *
 * A regra 6 é a que protege o aplicativo: as três cores da marca significam
 * *tempo* (passado, presente, futuro), e dentro da árvore o azul já significa
 * *masculino*. Ícone de domínio monocromático, herdando a cor do tema, não cria
 * essa colisão — e o mesmo arquivo serve aos quatro temas sem variante.
 *
 * A exceção é `IconeAplicativo`, que é a marca se apresentando: cores fixas,
 * para o splash, o "Sobre" e a tela de desbloqueio.
 */

import type { SVGProps } from 'react';

interface PropsIcone extends Omit<SVGProps<SVGSVGElement>, 'stroke'> {
  /** Igual ao Lucide. Uma classe `w-4 h-4` sobrepõe isto, como lá. */
  size?: number | string;
  strokeWidth?: number | string;
}

/**
 * A casca que prende a gramática num lugar só.
 *
 * Nenhum ícone daqui define `viewBox`, `stroke` ou as pontas: quem quiser
 * desviar teria de mexer nesta função, o que é justamente o ponto.
 */
function Base({ size = 24, strokeWidth = 2, children, ...resto }: PropsIcone) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
      {...resto}
    >
      {children}
    </svg>
  );
}

/** Nó: uma pessoa, um acontecimento. Cheio, `r 2`. */
function No({ cx, cy }: { cx: number; cy: number }) {
  return <circle cx={cx} cy={cy} r="2" fill="currentColor" stroke="none" />;
}

// ---------------------------------------------------------------------------
// Identidade
// ---------------------------------------------------------------------------

/**
 * A marca no cabeçalho e em linha: símbolo só, monocromático.
 *
 * Sem os nós de propósito — aos 16 px eles empastam o miolo do "E". E
 * monocromático porque tricolor briga com os temas clássicos, que são sépia; a
 * marca colorida fica onde ela se apresenta, em [IconeAplicativo].
 */
export function MarcaElotempo(props: PropsIcone) {
  return (
    <Base {...props}>
      <path d="M5.5 5h13M5.5 5v14M5.5 19h13M5.5 12h6.5M12 12l6.5-3M12 12l6.5 3" />
    </Base>
  );
}

/**
 * A marca se apresentando: squircle no azul da representação masculina com o símbolo em branco cristalino puro.
 *
 * Paleta oficial:
 * - Fundo: Azul Masculino / Primário (#2563EB)
 * - Símbolo e nós: Branco Cristalino Puro (#FFFFFF)
 */
export function IconeAplicativo({
  size = 24,
  className = '',
  variante = 'azul',
  ...resto
}: Omit<PropsIcone, 'strokeWidth'> & { variante?: 'azul' | 'transparente' }) {
  const numSize = typeof size === 'number' ? size : parseInt(String(size), 10) || 24;
  const pequeno = numSize < 48;
  const strokeWidth = pequeno ? 38 : 30;
  const rNo = pequeno ? 38 : 33;
  const corTraço = variante === 'azul' ? '#FFFFFF' : '#2563EB';

  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width={size}
      height={size}
      viewBox="0 0 512 512"
      aria-hidden="true"
      className={className}
      {...resto}
    >
      {variante === 'azul' && (
        <rect width="512" height="512" rx="115" fill="#2563EB" />
      )}
      <g fill="none" stroke={corTraço} strokeLinecap="round" strokeLinejoin="round" strokeWidth={strokeWidth}>
        <path d="M160 130v252" />
        <path d="M160 130h196" />
        <path d="M160 256h72" />
        <path d="M232 256l124-52M232 256l124 52" />
        <path d="M160 382h196" />
      </g>
      <g stroke="none" fill={corTraço}>
        <circle cx="160" cy="130" r={rNo} />
        <circle cx="356" cy="130" r={rNo} />
        <circle cx="160" cy="256" r={rNo} />
        <circle cx="232" cy="256" r={rNo} />
        <circle cx="356" cy="204" r={rNo} />
        <circle cx="356" cy="308" r={rNo} />
        <circle cx="160" cy="382" r={rNo} />
        <circle cx="356" cy="382" r={rNo} />
      </g>
    </svg>
  );
}

/**
 * Peça C: Assinatura Horizontal institucional.
 *
 * Utiliza o ícone do aplicativo (squircle azul com símbolo branco),
 * a tipografia Sora ('font-marca') e o subtítulo institucional.
 * Ideal para SplashScreen, ModalSobre e TelaDesbloqueio.
 */
export function MarcaAssinaturaHorizontal({
  tamanho = 'md',
  className = '',
}: {
  tamanho?: 'sm' | 'md' | 'lg';
  className?: string;
}) {
  const configs = {
    sm: {
      icone: 28,
      titulo: 'text-lg',
      sub: 'text-[8px] tracking-[0.2em]',
      gap: 'gap-2.5',
    },
    md: {
      icone: 40,
      titulo: 'text-2xl',
      sub: 'text-[9.5px] tracking-[0.25em]',
      gap: 'gap-3.5',
    },
    lg: {
      icone: 52,
      titulo: 'text-3xl',
      sub: 'text-[11px] tracking-[0.28em]',
      gap: 'gap-4',
    },
  }[tamanho];

  return (
    <div className={`flex items-center ${configs.gap} select-none ${className}`}>
      <IconeAplicativo size={configs.icone} className="flex-none rounded-lg shadow-2xs" />
      <div className="flex flex-col leading-none">
        <span className={`font-marca font-normal text-tinta tracking-[-0.025em] ${configs.titulo}`}>
          EloTempo
        </span>
        <span className={`font-marca font-medium text-masc uppercase mt-1 ${configs.sub}`}>
          Histórias que conectam gerações
        </span>
      </div>
    </div>
  );
}

/** Alias oficial com grafia EloTempo */
export const MarcaEloTempo = MarcaElotempo;

// ---------------------------------------------------------------------------
// Domínio
// ---------------------------------------------------------------------------

/** Árvore genealógica: raiz, distribuição, três filhos. */
export function IconeArvore(props: PropsIcone) {
  return (
    <Base {...props}>
      <path d="M12 7v3.6M4.6 10.6h14.8M4.6 10.6V15M12 10.6V15M19.4 10.6V15" />
      <No cx={12} cy={5} />
      <No cx={4.6} cy={17} />
      <No cx={12} cy={17} />
      <No cx={19.4} cy={17} />
    </Base>
  );
}

/**
 * Linha do tempo: eixo com marcos.
 *
 * Três nós, não quatro. O brand board desenha quatro, e quatro é o certo em
 * tamanho de apresentação — mas quase todo uso no aplicativo é de 14 a 20 px, e
 * ali a folga entre nós cai abaixo de 1 px e eles se fundem num borrão. Para os
 * tamanhos grandes existe [IconeLinhaTempoAmplo].
 */
export function IconeLinhaTempo(props: PropsIcone) {
  return (
    <Base {...props}>
      <path d="M5 12h14" />
      <No cx={5} cy={12} />
      <No cx={12} cy={12} />
      <No cx={19} cy={12} />
    </Base>
  );
}

/** A linha do tempo como o brand board a desenha. Só de 32 px para cima. */
export function IconeLinhaTempoAmplo(props: PropsIcone) {
  return (
    <Base {...props}>
      <path d="M4 12h16" />
      <No cx={4} cy={12} />
      <No cx={9.33} cy={12} />
      <No cx={14.67} cy={12} />
      <No cx={20} cy={12} />
    </Base>
  );
}

/** Medição temporal: compasso e linha de cota com delimitadores verticais e setas. */
export function IconeMedicaoTemporal(props: PropsIcone) {
  return (
    <Base {...props}>
      <path d="M4 12h16M4 7v10M20 7v10M7 9.5L4 12l3 2.5M17 9.5l3 2.5-3 2.5" />
    </Base>
  );
}

/** Relações e conexões: malha, não hierarquia. */
export function IconeRelacoes(props: PropsIcone) {
  return (
    <Base {...props}>
      <path d="M12 12L5 6M12 12l7-6M12 12v7M5 6h14" />
      <No cx={12} cy={12} />
      <No cx={5} cy={6} />
      <No cx={19} cy={6} />
      <No cx={12} cy={19} />
    </Base>
  );
}

/** Acontecimento histórico: relógio com o pivô como nó cheio. */
export function IconeAcontecimento(props: PropsIcone) {
  return (
    <Base {...props}>
      <circle cx="12" cy="12" r="8.5" />
      <path d="M12 12V7.4M12 12h3.9" />
      <circle cx="12" cy="12" r="1.9" fill="currentColor" stroke="none" />
    </Base>
  );
}

/**
 * Pessoa desconhecida — o placeholder que segura um slot de união.
 *
 * Neste vocabulário uma pessoa **é** um nó; sem nome, o nó não se preenche.
 * Não se lê como espera de carregamento porque nunca aparece sozinho: está
 * sempre no lugar de alguém, dentro de uma união.
 */
export function IconePessoaDesconhecida({ strokeWidth = 2, ...resto }: PropsIcone) {
  return (
    <Base strokeWidth={strokeWidth} {...resto}>
      <circle cx="12" cy="12" r="6.6" strokeDasharray="3.1 3.3" />
    </Base>
  );
}
