import React, { createContext, useContext, useEffect, useState } from 'react';
import type { LanguageCode, TranslationSchema } from './types';
import { ptBR } from './locales/pt-BR';
import { enUS } from './locales/en-US';

const DICIONARIOS: Record<LanguageCode, TranslationSchema> = {
  'pt-BR': ptBR,
  'en-US': enUS,
};

interface I18nContextValue {
  idioma: LanguageCode;
  setIdioma: (lang: LanguageCode) => void;
  /** Retorna a tradução tipada com base na seção e chave. */
  t: <S extends keyof TranslationSchema, K extends keyof TranslationSchema[S]>(
    secao: S,
    chave: K,
    params?: Record<string, string | number>
  ) => string;
  /** Retorna a seção inteira do dicionário. */
  tSecao: <S extends keyof TranslationSchema>(secao: S) => TranslationSchema[S];
}

const I18nContext = createContext<I18nContextValue | null>(null);

function detectarIdiomaPadrao(): LanguageCode {
  try {
    const salvo = localStorage.getItem('app-idioma');
    if (salvo === 'pt-BR' || salvo === 'en-US') return salvo;
    if (typeof navigator !== 'undefined' && navigator.language?.toLowerCase().startsWith('pt')) {
      return 'pt-BR';
    }
    if (typeof navigator !== 'undefined' && navigator.language?.toLowerCase().startsWith('en')) {
      return 'en-US';
    }
  } catch {
    // Caso de SSR ou sandbox sem localStorage
  }
  return 'pt-BR';
}

export function I18nProvider({ children }: { children: React.ReactNode }) {
  const [idioma, setIdiomaState] = useState<LanguageCode>(detectarIdiomaPadrao);

  const setIdioma = (novo: LanguageCode) => {
    setIdiomaState(novo);
    try {
      localStorage.setItem('app-idioma', novo);
    } catch {}
  };

  useEffect(() => {
    document.documentElement.lang = idioma;
  }, [idioma]);

  const t = <S extends keyof TranslationSchema, K extends keyof TranslationSchema[S]>(
    secao: S,
    chave: K,
    params?: Record<string, string | number>
  ): string => {
    const dic = DICIONARIOS[idioma] ?? DICIONARIOS['pt-BR'];
    const sec = dic[secao];
    let texto: string = (sec && (sec[chave] as unknown as string)) || '';

    if (!texto) {
      // Fallback para português caso falte em outro idioma
      texto = (DICIONARIOS['pt-BR'][secao]?.[chave] as unknown as string) || String(chave);
    }

    if (params) {
      for (const [k, v] of Object.entries(params)) {
        texto = texto.replace(new RegExp(`\\{${k}\\}`, 'g'), String(v));
      }
    }

    return texto;
  };

  const tSecao = <S extends keyof TranslationSchema>(secao: S): TranslationSchema[S] => {
    const dic = DICIONARIOS[idioma] ?? DICIONARIOS['pt-BR'];
    return dic[secao] ?? DICIONARIOS['pt-BR'][secao];
  };

  return (
    <I18nContext.Provider value={{ idioma, setIdioma, t, tSecao }}>
      {children}
    </I18nContext.Provider>
  );
}

export function useI18n() {
  const ctx = useContext(I18nContext);
  if (!ctx) {
    throw new Error('useI18n deve ser utilizado dentro de um <I18nProvider>');
  }
  return ctx;
}
