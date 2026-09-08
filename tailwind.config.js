function comOpacidade(varName) {
  return ({ opacityValue }) => {
    if (opacityValue !== undefined) {
      return `color-mix(in srgb, var(${varName}) calc(100% * ${opacityValue}), transparent)`;
    }
    return `var(${varName})`;
  };
}

/** @type {import('tailwindcss').Config} */
export default {
  darkMode: ['selector', '[data-tema="classico-escuro"], [data-tema="moderno-escuro"]'],
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        mesa: comOpacidade('--mesa'),
        bg: comOpacidade('--bg'),
        sup: comOpacidade('--sup'),
        card: comOpacidade('--card'),
        card2: comOpacidade('--card2'),
        borda: comOpacidade('--borda'),
        borda2: comOpacidade('--borda2'),
        tinta: comOpacidade('--tinta'),
        tinta2: comOpacidade('--tinta2'),
        tinta3: comOpacidade('--tinta3'),
        linha: comOpacidade('--linha'),
        masc: comOpacidade('--masc'),
        fem: comOpacidade('--fem'),
        anel: comOpacidade('--anel'),
        acento: comOpacidade('--acento'),
        'acento-tinta': comOpacidade('--acento-tinta'),
        acento2: comOpacidade('--acento2'),
        'acento2-tinta': comOpacidade('--acento2-tinta'),
        chip: comOpacidade('--chip'),
        'lt-historia': comOpacidade('--lt-historia'),
        'lt-politica': comOpacidade('--lt-politica'),
        'lt-moeda': comOpacidade('--lt-moeda'),
        'lt-tecnologia': comOpacidade('--lt-tecnologia'),
        'lt-projeto': comOpacidade('--lt-projeto'),
      },
      fontFamily: {
        tit: 'var(--f-tit)',
        corpo: 'var(--f-corpo)',
        num: 'var(--f-num)',
        marca: ['Sora', 'Inter', 'system-ui', 'sans-serif'],
      },
      fontWeight: {
        tit: 'var(--peso-tit)',
      },
      letterSpacing: {
        tit: 'var(--tracking)',
      },
      borderRadius: {
        raio: 'var(--raio)',
        'raio-s': 'var(--raio-s)',
      },
      boxShadow: {
        sombra: 'var(--sombra)',
      },
    },
  },
  plugins: [],
}