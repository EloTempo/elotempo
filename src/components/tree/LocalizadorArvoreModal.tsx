import React, { useState, useEffect, useRef, useMemo } from 'react';
import { Search, X, CornerDownLeft } from 'lucide-react';
import type { PosicaoPessoa } from '../../lib/tree/layout';
import { useI18n } from '../../i18n/I18nContext';
import { formatarAno } from '../../lib/tree/layout';

export interface LocalizadorArvoreModalProps {
  aberto: boolean;
  onFechar: () => void;
  pessoas: PosicaoPessoa[];
  pessoaSelecionadaId?: string | null;
  onSelecionarPessoa: (id: string) => void;
}

export function LocalizadorArvoreModal({
  aberto,
  onFechar,
  pessoas,
  pessoaSelecionadaId,
  onSelecionarPessoa,
}: LocalizadorArvoreModalProps) {
  const { t } = useI18n();
  const [consulta, setConsulta] = useState('');
  const [indiceFoco, setIndiceFoco] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);
  const listaRef = useRef<HTMLUListElement>(null);

  // Foca no input quando abre
  useEffect(() => {
    if (aberto) {
      setConsulta('');
      setIndiceFoco(0);
      setTimeout(() => {
        inputRef.current?.focus();
      }, 50);
    }
  }, [aberto]);

  // Filtra as pessoas da árvore
  const resultados = useMemo(() => {
    const q = consulta.trim().toLowerCase();
    if (!q) {
      // Exibe até 12 pessoas inicialmente
      return pessoas.slice(0, 12);
    }

    return pessoas
      .filter((p) => {
        const nomeCompleto = `${p.nome} ${p.sobrenome ?? ''}`.toLowerCase();
        const anoNasc = p.ano_nascimento != null ? String(p.ano_nascimento) : '';
        const anoFalec = p.ano_falecimento != null ? String(p.ano_falecimento) : '';
        return (
          nomeCompleto.includes(q) ||
          anoNasc.includes(q) ||
          anoFalec.includes(q)
        );
      })
      .slice(0, 20);
  }, [pessoas, consulta]);

  // Teclas de atalho para navegar na lista
  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Escape') {
      e.preventDefault();
      onFechar();
      return;
    }

    if (e.key === 'ArrowDown') {
      e.preventDefault();
      setIndiceFoco((prev) => (prev < resultados.length - 1 ? prev + 1 : 0));
      return;
    }

    if (e.key === 'ArrowUp') {
      e.preventDefault();
      setIndiceFoco((prev) => (prev > 0 ? prev - 1 : resultados.length - 1));
      return;
    }

    if (e.key === 'Enter') {
      e.preventDefault();
      const escolhido = resultados[indiceFoco];
      if (escolhido) {
        onSelecionarPessoa(escolhido.id);
        onFechar();
      }
    }
  };

  if (!aberto) return null;

  return (
    <div
      className="fixed inset-0 z-50 flex items-start justify-center pt-24 bg-black/40 backdrop-blur-xs animate-in fade-in duration-150"
      onClick={onFechar}
    >
      <div
        className="w-full max-w-md bg-card/95 backdrop-blur-md border border-borda shadow-2xl rounded-raio overflow-hidden flex flex-col"
        onClick={(e) => e.stopPropagation()}
        onKeyDown={handleKeyDown}
      >
        {/* Barra de Busca */}
        <div className="flex items-center gap-2.5 px-3.5 py-3 border-b border-borda/60 bg-sup/40">
          <Search className="w-4 h-4 text-acento flex-none" />
          <input
            ref={inputRef}
            type="text"
            value={consulta}
            onChange={(e) => {
              setConsulta(e.target.value);
              setIndiceFoco(0);
            }}
            placeholder={t('arvore', 'buscarMembroPlaceholder')}
            className="w-full bg-transparent text-sm text-tinta placeholder:text-tinta2/60 outline-hidden"
          />
          {consulta && (
            <button
              type="button"
              onClick={() => setConsulta('')}
              className="p-1 rounded text-tinta2 hover:text-tinta cursor-pointer"
            >
              <X className="w-3.5 h-3.5" />
            </button>
          )}
          <kbd className="hidden sm:inline-flex items-center gap-0.5 text-[10px] text-tinta2 bg-sup px-1.5 py-0.5 rounded border border-borda/60">
            Esc
          </kbd>
        </div>

        {/* Lista de Resultados */}
        <ul
          ref={listaRef}
          className="max-h-72 overflow-y-auto p-1.5 space-y-0.5 divide-y divide-borda/20"
        >
          {resultados.length === 0 ? (
            <li className="px-3 py-6 text-center text-xs text-tinta2">
              {t('arvore', 'nenhumMembroEncontrado')}
            </li>
          ) : (
            resultados.map((p, idx) => {
              const selecionado = idx === indiceFoco;
              const ehAtivoNaArvore = p.id === pessoaSelecionadaId;

              // Formatação de período de vida
              const nasc = formatarAno(p.ano_nascimento);
              const falec = formatarAno(p.ano_falecimento);
              const periodo =
                nasc || falec
                  ? `${nasc || '?'} – ${!p.is_vivo ? falec || '?' : t('arvore', 'vivo')}`
                  : null;

              return (
                <li
                  key={p.id}
                  onClick={() => {
                    onSelecionarPessoa(p.id);
                    onFechar();
                  }}
                  onMouseEnter={() => setIndiceFoco(idx)}
                  className={`flex items-center justify-between px-3 py-2 rounded-raio-s cursor-pointer transition-colors ${
                    selecionado
                      ? 'bg-acento/10 text-acento border border-acento/30'
                      : 'hover:bg-sup/60 text-tinta'
                  }`}
                >
                  <div className="flex items-center gap-2.5 min-w-0">
                    <div
                      className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold flex-none border ${
                        p.sexo === 'M'
                          ? 'bg-sky-500/10 text-sky-600 dark:text-sky-400 border-sky-500/30'
                          : p.sexo === 'F'
                            ? 'bg-pink-500/10 text-pink-600 dark:text-pink-400 border-pink-500/30'
                            : 'bg-zinc-500/10 text-zinc-600 dark:text-zinc-400 border-zinc-500/30'
                      }`}
                    >
                      {p.nome.charAt(0).toUpperCase()}
                    </div>
                    <div className="min-w-0">
                      <div className="text-xs font-semibold truncate flex items-center gap-1.5">
                        <span className={selecionado ? 'text-acento' : 'text-tinta'}>
                          {p.nome} {p.sobrenome ?? ''}
                        </span>
                        {ehAtivoNaArvore && (
                          <span className="text-[10px] px-1.5 py-0.2 rounded bg-acento/20 text-acento font-normal">
                            {t('arvore', 'ativaBadge')}
                          </span>
                        )}
                      </div>
                      {periodo && (
                        <div className="text-[11px] text-tinta2 font-num">
                          {periodo}
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="flex items-center gap-1.5 flex-none text-tinta2">
                    <span className="text-[10px] text-tinta2/80 font-num">
                      {p.geracao}ª {t('arvore', 'geracoesAbrev')}
                    </span>
                    {selecionado && <CornerDownLeft className="w-3.5 h-3.5 text-acento" />}
                  </div>
                </li>
              );
            })
          )}
        </ul>

        {/* Rodapé explicativo */}
        <div className="px-3 py-2 bg-sup/50 border-t border-borda/60 flex items-center justify-between text-[11px] text-tinta2">
          <span>{pessoas.length} {t('arvore', 'membros')} na árvore</span>
          <span className="flex items-center gap-1">
            <kbd className="px-1 py-0.5 bg-card border border-borda/60 rounded text-[10px]">↑↓</kbd> navegar
            <kbd className="px-1 py-0.5 bg-card border border-borda/60 rounded text-[10px] ml-1">Enter</kbd> ir
          </span>
        </div>
      </div>
    </div>
  );
}
