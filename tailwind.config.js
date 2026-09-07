/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        mesa: 'var(--mesa)',
        bg: 'var(--bg)',
        sup: 'var(--sup)',
        card: 'var(--card)',
        card2: 'var(--card2)',
        borda: 'var(--borda)',
        borda2: 'var(--borda2)',
        tinta: 'var(--tinta)',
        tinta2: 'var(--tinta2)',
        tinta3: 'var(--tinta3)',
        linha: 'var(--linha)',
        masc: 'var(--masc)',
        fem: 'var(--fem)',
        anel: 'var(--anel)',
        acento: 'var(--acento)',
        'acento-tinta': 'var(--acento-tinta)',
        acento2: 'var(--acento2)',
        'acento2-tinta': 'var(--acento2-tinta)',
        chip: 'var(--chip)',
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