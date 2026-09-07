import { useState, useRef, useEffect, useMemo } from 'react';
import {
  Check,
  ChevronDown,
  Globe,
  Search,
  X,
} from 'lucide-react';
import { IconeArvore } from '../../../components/icons';
import type { ArvoreInfo } from '../../../lib/api';

interface SeletorArvoreEstatisticaProps {
  arvoreId: string | null;
  onSelecionar: (arvoreId: string | null) => void;
  arvores?: ArvoreInfo[];
  desabilitarId?: string | null;
  permitirTodoAcervo?: boolean;
  labelPlaceholder?: string;
  className?: string;
}

export function SeletorArvoreEstatistica({
  arvoreId,
  onSelecionar,
  arvores = [],
  desabilitarId = null,
  permitirTodoAcervo = true,
  labelPlaceholder = 'Selecionar árvore...',
  className = '',
}: SeletorArvoreEstatisticaProps) {
  const [aberto, setAberto] = useState(false);
  const [termoBusca, setTermoBusca] = useState('');
  const [abaFiltro, setAbaFiltro] = useState<'todas' | 'pessoais' | 'historicas'>('todas');
  const containerRef = useRef<HTMLDivElement>(null);
  const inputBuscaRef = useRef<HTMLInputElement>(null);

  // Fecha popover ao clicar fora ou pressionar Escape
  useEffect(() => {
    function handleClickFora(e: MouseEvent) {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setAberto(false);
      }
    }
    function handleKeyDown(e: KeyboardEvent) {
      if (e.key === 'Escape') setAberto(false);
    }

    if (aberto) {
      document.addEventListener('mousedown', handleClickFora);
      document.addEventListener('keydown', handleKeyDown);
      setTimeout(() => inputBuscaRef.current?.focus(), 50);
      return () => {
        document.removeEventListener('mousedown', handleClickFora);
        document.removeEventListener('keydown', handleKeyDown);
      };
    }
  }, [aberto]);

  const arvoreSelecionada = useMemo(
    () => arvores.find((a) => a.id === arvoreId) ?? null,
    [arvores, arvoreId]
  );

  const totalPessoasAcervo = useMemo(
    () => arvores.reduce((acc, a) => acc + a.total_membros, 0),
    [arvores]
  );

  // Filtragem inteligente por termo e por aba
  const arvoresFiltradas = useMemo(() => {
    return arvores.filter((a) => {
      if (a.id === desabilitarId) return false;

      if (abaFiltro === 'pessoais' && a.is_publico) return false;
      if (abaFiltro === 'historicas' && !a.is_publico) return false;

      if (!termoBusca.trim()) return true;
      const q = termoBusca.toLowerCase();
      return (
        a.nome.toLowerCase().includes(q) ||
        (a.descricao?.toLowerCase().includes(q) ?? false) ||
        (a.pais?.toLowerCase().includes(q) ?? false) ||
        (a.categoria?.toLowerCase().includes(q) ?? false) ||
        (a.periodo?.toLowerCase().includes(q) ?? false) ||
        (a.raiz_pessoa_nome?.toLowerCase().includes(q) ?? false)
      );
    });
  }, [arvores, desabilitarId, abaFiltro, termoBusca]);

  // Agrupamento por categoria para árvores de referência histórica
  const historicasPorCategoria = useMemo(() => {
    const grupos: Record<string, ArvoreInfo[]> = {};
    for (const arv of arvoresFiltradas.filter((a) => a.is_publico)) {
      const cat = arv.categoria || 'Geral';
      if (!grupos[cat]) grupos[cat] = [];
      grupos[cat].push(arv);
    }
    return grupos;
  }, [arvoresFiltradas]);

  const pessoaisFiltradas = useMemo(
    () => arvoresFiltradas.filter((a) => !a.is_publico),
    [arvoresFiltradas]
  );

  return (
    <div ref={containerRef} className={`relative w-full ${className}`}>
      {/* Botão de Disparo do Popover */}
      <button
        type="button"
        onClick={() => setAberto((v) => !v)}
        className="w-full text-left px-3 py-2 rounded-raio-s border border-borda bg-card hover:bg-sup/80 text-xs flex items-center justify-between gap-2 cursor-pointer transition-colors shadow-2xs group select-none"
      >
        <div className="flex items-center gap-2 min-w-0 flex-1">
          {arvoreSelecionada ? (
            <>
              <IconeArvore className="w-3.5 h-3.5 text-acento flex-none" />
              <span className="truncate font-semibold text-tinta">
                {arvoreSelecionada.nome}
              </span>
              <span className="text-[10px] text-tinta3 flex-none">
                ({arvoreSelecionada.total_membros} pessoas)
              </span>
            </>
          ) : permitirTodoAcervo ? (
            <>
              <Globe className="w-3.5 h-3.5 text-acento flex-none" />
              <span className="truncate font-semibold text-tinta">Todo o Acervo</span>
              <span className="text-[10px] text-tinta3 flex-none">
                ({totalPessoasAcervo} pessoas)
              </span>
            </>
          ) : (
            <span className="text-tinta3 italic truncate">{labelPlaceholder}</span>
          )}
        </div>
        <div className="flex items-center gap-1.5 flex-none">
          <span className="text-[10px] px-1.5 py-0.5 rounded bg-sup text-tinta3 border border-borda/60 font-medium group-hover:border-acento/40">
            Alternar
          </span>
          <ChevronDown className="w-3.5 h-3.5 text-tinta3 group-hover:text-tinta transition-transform" />
        </div>
      </button>

      {/* Popover Pesquisável Flutuante */}
      {aberto && (
        <div className="absolute top-full left-0 right-0 sm:right-auto sm:w-[380px] mt-1 bg-card border border-borda rounded-raio shadow-2xl z-50 p-2 flex flex-col gap-2 animate-in fade-in duration-100">
          {/* Campo de Busca Rápida */}
          <div className="relative flex items-center">
            <Search className="w-3.5 h-3.5 text-tinta3 absolute left-2.5 pointer-events-none" />
            <input
              ref={inputBuscaRef}
              type="text"
              placeholder="Buscar árvore por nome, categoria ou país..."
              value={termoBusca}
              onChange={(e) => setTermoBusca(e.target.value)}
              className="w-full text-xs pl-8 pr-7 py-1.5 rounded-raio-s bg-sup/90 border border-borda text-tinta placeholder:text-tinta3 outline-none focus:border-acento"
            />
            {termoBusca && (
              <button
                type="button"
                onClick={() => setTermoBusca('')}
                className="absolute right-2 text-tinta3 hover:text-tinta p-0.5"
                title="Limpar busca"
              >
                <X className="w-3 h-3" />
              </button>
            )}
          </div>

          {/* Abas Rápidas de Categoria */}
          <div className="flex items-center gap-1 border-b border-borda/40 pb-1.5 text-[10.5px]">
            <button
              type="button"
              onClick={() => setAbaFiltro('todas')}
              className={`px-2 py-0.5 rounded cursor-pointer transition-colors ${
                abaFiltro === 'todas'
                  ? 'bg-acento text-acento-tinta font-bold'
                  : 'text-tinta3 hover:text-tinta hover:bg-sup'
              }`}
            >
              Todas ({arvores.length})
            </button>
            <button
              type="button"
              onClick={() => setAbaFiltro('pessoais')}
              className={`px-2 py-0.5 rounded cursor-pointer transition-colors ${
                abaFiltro === 'pessoais'
                  ? 'bg-acento text-acento-tinta font-bold'
                  : 'text-tinta3 hover:text-tinta hover:bg-sup'
              }`}
            >
              Minhas Árvores ({arvores.filter((a) => !a.is_publico).length})
            </button>
            <button
              type="button"
              onClick={() => setAbaFiltro('historicas')}
              className={`px-2 py-0.5 rounded cursor-pointer transition-colors ${
                abaFiltro === 'historicas'
                  ? 'bg-acento text-acento-tinta font-bold'
                  : 'text-tinta3 hover:text-tinta hover:bg-sup'
              }`}
            >
              🏛️ Históricas ({arvores.filter((a) => a.is_publico).length})
            </button>
          </div>

          {/* Lista de Opções com Rolagem Suave */}
          <div className="max-h-60 overflow-y-auto flex flex-col gap-1 pr-1">
            {/* Opção 'Todo o Acervo' */}
            {permitirTodoAcervo && (abaFiltro === 'todas' || !termoBusca) && (
              <button
                type="button"
                onClick={() => {
                  onSelecionar(null);
                  setAberto(false);
                }}
                className={`w-full text-left px-2.5 py-1.5 text-xs rounded-raio-s flex items-center justify-between gap-2 hover:bg-sup cursor-pointer transition-colors ${
                  arvoreId === null ? 'bg-acento/10 text-acento font-bold border border-acento/30' : 'text-tinta'
                }`}
              >
                <div className="flex items-center gap-2 min-w-0 flex-1">
                  <Globe className="w-3.5 h-3.5 text-acento flex-none" />
                  <div className="flex flex-col min-w-0">
                    <span className="truncate font-semibold">Todo o Acervo</span>
                    <span className="text-[10px] text-tinta3">
                      Visão agregada de todas as árvores registradas ({totalPessoasAcervo} pessoas)
                    </span>
                  </div>
                </div>
                {arvoreId === null && <Check className="w-3.5 h-3.5 text-acento flex-none" />}
              </button>
            )}

            {/* Minhas Árvores */}
            {pessoaisFiltradas.length > 0 && (
              <div className="flex flex-col gap-0.5 pt-1">
                <div className="px-2 py-0.5 text-[9px] font-bold text-tinta3 uppercase tracking-wider bg-sup/50 rounded">
                  Minhas Árvores ({pessoaisFiltradas.length})
                </div>
                {pessoaisFiltradas.map((a) => {
                  const isSelecionada = a.id === arvoreId;
                  return (
                    <button
                      key={a.id}
                      type="button"
                      onClick={() => {
                        onSelecionar(a.id);
                        setAberto(false);
                      }}
                      className={`w-full text-left px-2.5 py-1.5 text-xs rounded-raio-s flex items-center justify-between gap-2 hover:bg-sup cursor-pointer transition-colors ${
                        isSelecionada ? 'bg-acento/10 text-acento font-bold border border-acento/30' : 'text-tinta'
                      }`}
                    >
                      <div className="flex items-center gap-2 min-w-0 flex-1">
                        <IconeArvore className="w-3.5 h-3.5 text-acento flex-none" />
                        <span className="truncate">{a.nome}</span>
                      </div>
                      <span className="text-[10px] font-num text-tinta3 flex-none">
                        {a.total_membros}p
                      </span>
                      {isSelecionada && <Check className="w-3.5 h-3.5 text-acento flex-none" />}
                    </button>
                  );
                })}
              </div>
            )}

            {/* Árvores de Referência Histórica Agrupadas por Categoria */}
            {Object.keys(historicasPorCategoria).length > 0 && (
              <div className="flex flex-col gap-1.5 pt-1">
                <div className="px-2 py-0.5 text-[9px] font-bold text-acento uppercase tracking-wider bg-acento/10 rounded flex items-center justify-between">
                  <span>🏛️ Referência Histórica</span>
                  <span className="font-num text-[10px]">
                    {arvoresFiltradas.filter((a) => a.is_publico).length}
                  </span>
                </div>

                {Object.entries(historicasPorCategoria).map(([categoria, lista]) => (
                  <div key={categoria} className="flex flex-col gap-0.5 pl-1">
                    <span className="text-[9.5px] font-bold text-tinta3 uppercase tracking-wider px-1.5">
                      {categoria}
                    </span>
                    {lista.map((a) => {
                      const isSelecionada = a.id === arvoreId;
                      return (
                        <button
                          key={a.id}
                          type="button"
                          onClick={() => {
                            onSelecionar(a.id);
                            setAberto(false);
                          }}
                          className={`w-full text-left px-2 py-1 text-xs rounded-raio-s flex items-center justify-between gap-2 hover:bg-sup cursor-pointer transition-colors ${
                            isSelecionada ? 'bg-acento/10 text-acento font-bold border border-acento/30' : 'text-tinta'
                          }`}
                        >
                          <div className="flex items-center gap-1.5 min-w-0 flex-1">
                            <span className="truncate">{a.nome}</span>
                            {a.pais && (
                              <span className="text-[9.5px] px-1 py-0.2 rounded bg-sup text-tinta3 border border-borda/60 flex-none">
                                {a.pais}
                              </span>
                            )}
                          </div>
                          <span className="text-[10px] font-num text-tinta3 flex-none">
                            {a.total_membros}p
                          </span>
                          {isSelecionada && <Check className="w-3.5 h-3.5 text-acento flex-none" />}
                        </button>
                      );
                    })}
                  </div>
                ))}
              </div>
            )}

            {arvoresFiltradas.length === 0 && (
              <div className="p-4 text-center text-xs text-tinta3 italic">
                Nenhuma árvore encontrada para "{termoBusca}".
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
