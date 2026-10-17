import { useState, useRef, useEffect, useMemo } from 'react';
import { useQuery } from '@tanstack/react-query';
import {
  ChevronDown,
  Plus,
  Settings2,
  Check,
  Globe,
  X,
  Search,
  Sparkles,
} from 'lucide-react';
import { IconeArvore } from '../../../components/icons';
import { listarArvores, type ArvoreInfo } from '../../../lib/api';
import { useI18n } from '../../../i18n/I18nContext';
import { ModalGerenciarArvores } from './ModalGerenciarArvores';

interface SeletorDeArvoreProps {
  arvoreAtivaId: string | null;
  onSelecionarArvore: (arvore: ArvoreInfo | null) => void;
  className?: string;
}

export function SeletorDeArvore({
  arvoreAtivaId,
  onSelecionarArvore,
  className = '',
}: SeletorDeArvoreProps) {
  const { t } = useI18n();
  const [menuAberto, setMenuAberto] = useState(false);
  const [modalGerenciarAberto, setModalGerenciarAberto] = useState(false);
  const [iniciarCriacaoAoSurgir, setIniciarCriacaoAoSurgir] = useState(false);
  const [busca, setBusca] = useState('');
  const [abaFiltro, setAbaFiltro] = useState<'todas' | 'pessoais' | 'historicas'>('historicas');
  const menuRef = useRef<HTMLDivElement>(null);
  const inputBuscaRef = useRef<HTMLInputElement>(null);

  const { data: arvores = [] } = useQuery({
    queryKey: ['arvores'],
    queryFn: listarArvores,
    staleTime: 30_000,
  });

  const arvoreAtiva = arvores.find((a) => a.id === arvoreAtivaId) ?? null;

  // Fecha menu ao clicar fora ou pressionar Escape
  useEffect(() => {
    function handleClickFora(e: MouseEvent) {
      if (menuRef.current && !menuRef.current.contains(e.target as Node)) {
        setMenuAberto(false);
      }
    }
    function handleKeyDown(e: KeyboardEvent) {
      if (e.key === 'Escape') setMenuAberto(false);
    }
    if (menuAberto) {
      document.addEventListener('mousedown', handleClickFora);
      document.addEventListener('keydown', handleKeyDown);
      setTimeout(() => inputBuscaRef.current?.focus(), 50);
      return () => {
        document.removeEventListener('mousedown', handleClickFora);
        document.removeEventListener('keydown', handleKeyDown);
      };
    }
  }, [menuAberto]);

  const totalPessoasAcervo = useMemo(
    () => arvores.reduce((acc, a) => acc + a.total_membros, 0),
    [arvores]
  );

  const arvoresPessoais = useMemo(() => arvores.filter((a) => !a.is_publico), [arvores]);
  const arvoresHistoricas = useMemo(() => arvores.filter((a) => a.is_publico), [arvores]);

  // Filtragem inteligente por busca e abas
  const arvoresFiltradas = useMemo(() => {
    return arvores.filter((a) => {
      if (abaFiltro === 'pessoais' && a.is_publico) return false;
      if (abaFiltro === 'historicas' && !a.is_publico) return false;

      if (!busca.trim()) return true;
      const q = busca.toLowerCase();
      return (
        a.nome.toLowerCase().includes(q) ||
        (a.descricao?.toLowerCase().includes(q) ?? false) ||
        (a.pais?.toLowerCase().includes(q) ?? false) ||
        (a.periodo?.toLowerCase().includes(q) ?? false) ||
        (a.categoria?.toLowerCase().includes(q) ?? false) ||
        (a.raiz_pessoa_nome?.toLowerCase().includes(q) ?? false)
      );
    });
  }, [arvores, abaFiltro, busca]);

  // Agrupamento por categoria para históricas
  const categoriasHistoricas = useMemo(() => {
    const mapa: Record<string, ArvoreInfo[]> = {};
    for (const a of arvoresFiltradas.filter((item) => item.is_publico)) {
      const cat = a.categoria || 'Geral';
      if (!mapa[cat]) mapa[cat] = [];
      mapa[cat].push(a);
    }
    return mapa;
  }, [arvoresFiltradas]);

  return (
    <>
      <div className={`relative ${className}`} ref={menuRef}>
        <div className="flex items-center">
          <button
            type="button"
            onClick={() => setMenuAberto((a) => !a)}
            className="h-8 px-2.5 rounded-raio-s bg-card hover:bg-sup border border-borda text-xs font-semibold text-tinta flex items-center gap-1.5 cursor-pointer shadow-2xs transition-colors max-w-[260px]"
            title={
              arvoreAtiva
                ? t('arvore', 'arvoreAtivaTitulo', { nome: arvoreAtiva.nome })
                : t('arvore', 'todoAcervoAtivoTitulo')
            }
          >
            {arvoreAtiva ? (
              <>
                <IconeArvore className="w-3.5 h-3.5 text-acento flex-none" />
                <span className="truncate">{arvoreAtiva.nome}</span>
              </>
            ) : (
              <>
                <Globe className="w-3.5 h-3.5 text-acento flex-none" />
                <span className="truncate">{t('arvore', 'todoAcervo')}</span>
                <span className="text-[9.5px] px-1 py-0.2 rounded font-sans font-medium bg-sup text-tinta3 border border-borda/60 flex-none">
                  {t('arvore', 'geral')}
                </span>
              </>
            )}
            <ChevronDown className="w-3 h-3 text-tinta3 flex-none ml-0.5" />
          </button>

          {arvoreAtiva && (
            <button
              type="button"
              onClick={() => onSelecionarArvore(null)}
              className="ml-1 p-1.5 rounded-raio-s hover:bg-sup text-tinta3 hover:text-tinta border border-transparent hover:border-borda transition-colors cursor-pointer"
              title={t('arvore', 'voltarTodoAcervo')}
              aria-label={t('arvore', 'voltarTodoAcervo')}
            >
              <X className="w-3 h-3" />
            </button>
          )}
        </div>

        {menuAberto && (
          <div className="absolute top-full left-0 mt-1 w-[420px] max-w-[calc(100vw-2rem)] bg-card/95 backdrop-blur-md border border-borda rounded-raio shadow-sombra py-1.5 z-50 animate-in fade-in duration-100 flex flex-col overflow-hidden">
            {/* Cabeçalho */}
            <div className="px-3 py-1.5 text-[10.5px] font-bold text-tinta3 uppercase tracking-wider border-b border-borda/40 flex items-center justify-between">
              <span>{t('arvore', 'arvoresDoAcervo')}</span>
              <span className="font-num text-[10.5px] text-acento font-bold">
                {t('arvore', 'arvoresNoAcervo', { total: arvores.length })}
              </span>
            </div>

            {/* Campo de Busca Rápida */}
            <div className="p-2 border-b border-borda/40">
              <div className="relative flex items-center">
                <Search className="w-3.5 h-3.5 text-tinta3 absolute left-2.5 pointer-events-none" />
                <input
                  ref={inputBuscaRef}
                  type="text"
                  placeholder={t('arvore', 'filtrarArvoresPlaceholder')}
                  value={busca}
                  onChange={(e) => setBusca(e.target.value)}
                  className="w-full text-xs pl-8 pr-7 py-1.5 rounded-raio-s bg-sup/80 border border-borda text-tinta placeholder:text-tinta3 outline-none focus:border-acento transition-colors"
                />
                {busca && (
                  <button
                    type="button"
                    onClick={() => setBusca('')}
                    className="absolute right-2 p-0.5 text-tinta3 hover:text-tinta cursor-pointer"
                  >
                    <X className="w-3 h-3" />
                  </button>
                )}
              </div>
            </div>

            {/* Abas Rápidas de Filtro */}
            <div className="px-2 py-1 flex items-center gap-1 border-b border-borda/40 text-[10.5px] font-semibold">
              <button
                type="button"
                onClick={() => setAbaFiltro('historicas')}
                className={`px-2 py-0.5 rounded cursor-pointer transition-colors flex items-center gap-1 ${
                  abaFiltro === 'historicas'
                    ? 'bg-acento text-acento-tinta font-bold'
                    : 'text-tinta2 hover:text-tinta hover:bg-sup'
                }`}
              >
                <span>🏛️ {t('arvore', 'publicas')}</span>
                <span>({arvoresHistoricas.length})</span>
              </button>
              <button
                type="button"
                onClick={() => setAbaFiltro('pessoais')}
                className={`px-2 py-0.5 rounded cursor-pointer transition-colors ${
                  abaFiltro === 'pessoais'
                    ? 'bg-acento text-acento-tinta font-bold'
                    : 'text-tinta2 hover:text-tinta hover:bg-sup'
                }`}
              >
                {t('arvore', 'minhas')} ({arvoresPessoais.length})
              </button>
              <button
                type="button"
                onClick={() => setAbaFiltro('todas')}
                className={`px-2 py-0.5 rounded cursor-pointer transition-colors ${
                  abaFiltro === 'todas'
                    ? 'bg-acento text-acento-tinta font-bold'
                    : 'text-tinta2 hover:text-tinta hover:bg-sup'
                }`}
              >
                {t('arvore', 'todas')} ({arvores.length})
              </button>
            </div>

            {/* Lista com Rolagem */}
            <div className="max-h-76 overflow-y-auto py-1 divide-y divide-borda/30">
              {/* Opção Principal: Todo o Acervo */}
              <button
                type="button"
                onClick={() => {
                  onSelecionarArvore(null);
                  setMenuAberto(false);
                }}
                className={`w-full text-left px-3 py-2 text-xs flex items-center justify-between gap-2 hover:bg-sup cursor-pointer transition-colors ${
                  !arvoreAtiva ? 'bg-acento/10 font-bold text-acento' : 'text-tinta2'
                }`}
              >
                <div className="flex items-center gap-2.5 min-w-0 flex-1">
                  <div className="w-6 h-6 rounded-full bg-acento/15 text-acento grid place-items-center flex-none">
                    <Globe className="w-3.5 h-3.5" />
                  </div>
                  <div className="flex flex-col min-w-0 flex-1">
                    <span className="truncate font-semibold text-tinta">{t('arvore', 'todoAcervo')}</span>
                    <span className="text-[10px] text-tinta3 truncate">
                      {t('arvore', 'visaoGlobal', { total: totalPessoasAcervo })}
                    </span>
                  </div>
                </div>
                {!arvoreAtiva && <Check className="w-4 h-4 text-acento flex-none" />}
              </button>

              {/* Minhas Árvores */}
              {(abaFiltro === 'todas' || abaFiltro === 'pessoais') &&
                arvoresFiltradas.some((a) => !a.is_publico) && (
                  <div>
                    <div className="px-3 py-1 text-[9.5px] font-bold text-tinta3 uppercase tracking-wider bg-sup/50 flex items-center justify-between">
                      <span>{t('arvore', 'minhasArvores')}</span>
                      <span className="font-num text-[9.5px] text-tinta3">
                        {arvoresFiltradas.filter((a) => !a.is_publico).length}
                      </span>
                    </div>
                    {arvoresFiltradas
                      .filter((a) => !a.is_publico)
                      .map((a) => {
                        const isAtiva = a.id === arvoreAtiva?.id;
                        return (
                          <button
                            key={a.id}
                            type="button"
                            onClick={() => {
                              onSelecionarArvore(a);
                              setMenuAberto(false);
                            }}
                            className={`w-full text-left px-3 py-2 text-xs flex items-center justify-between gap-2 hover:bg-sup cursor-pointer transition-colors border-l-4 ${
                              isAtiva
                                ? 'bg-acento/15 border-l-acento font-bold text-acento'
                                : 'border-l-transparent text-tinta2'
                            }`}
                          >
                            <div className="flex flex-col min-w-0 flex-1">
                              <span
                                className={`truncate ${
                                  isAtiva ? 'text-acento font-bold' : 'text-tinta font-medium'
                                }`}
                              >
                                {a.nome}
                              </span>
                              <div className="flex items-center gap-1.5 text-[10px] text-tinta3 truncate mt-0.5">
                                {a.raiz_pessoa_nome && (
                                  <span>
                                    {t('arvore', 'raiz')}: {a.raiz_pessoa_nome}
                                  </span>
                                )}
                                <span>
                                  · {a.total_membros} {t('arvore', 'membros')}
                                </span>
                              </div>
                            </div>
                            {isAtiva && (
                              <span className="px-2 py-0.5 rounded bg-acento text-acento-tinta text-[9px] font-bold flex items-center gap-1 flex-none shadow-2xs">
                                <Check className="w-3 h-3 stroke-[2.5]" />
                                {t('busca', 'arvoreAtivaBadge')}
                              </span>
                            )}
                          </button>
                        );
                      })}
                  </div>
                )}

              {/* Árvores Históricas Categorizadas */}
              {(abaFiltro === 'todas' || abaFiltro === 'historicas') &&
                Object.keys(categoriasHistoricas).length > 0 && (
                  <div>
                    <div className="px-3 py-1.5 text-[9.5px] font-bold text-acento uppercase tracking-wider bg-acento/10 flex items-center justify-between border-y border-borda/30">
                      <span className="flex items-center gap-1">
                        <Sparkles className="w-3 h-3" />
                        <span>{t('arvore', 'acervoHistorico')}</span>
                      </span>
                      <span className="font-num text-[10px] text-acento font-bold">
                        {arvoresFiltradas.filter((a) => a.is_publico).length}
                      </span>
                    </div>

                    {Object.entries(categoriasHistoricas).map(([catNome, arvoresDaCat]) => {
                      const contemAtiva = arvoresDaCat.some((a) => a.id === arvoreAtiva?.id);
                      return (
                        <div key={catNome} className="border-b border-borda/30 last:border-b-0">
                          <div
                            className={`px-3 py-1.5 text-[10px] font-bold uppercase tracking-wider flex items-center justify-between border-l-4 ${
                              contemAtiva
                                ? 'bg-acento/15 border-l-acento text-tinta'
                                : 'bg-sup/60 border-l-transparent text-tinta2'
                            }`}
                          >
                            <span className="truncate">{catNome}</span>
                            <span
                              className={`font-num text-[9.5px] px-1.5 py-0.2 rounded ${
                                contemAtiva
                                  ? 'bg-acento/20 text-acento font-bold'
                                  : 'bg-card text-tinta3 border border-borda'
                              }`}
                            >
                              {arvoresDaCat.length}
                            </span>
                          </div>
                          <div className="pl-2 border-l-2 border-acento/30 ml-2 my-1 flex flex-col gap-0.5">
                            {arvoresDaCat.map((a) => {
                              const isAtiva = a.id === arvoreAtiva?.id;
                              return (
                                <button
                                  key={a.id}
                                  type="button"
                                  onClick={() => {
                                    onSelecionarArvore(a);
                                    setMenuAberto(false);
                                  }}
                                  className={`w-full text-left px-2.5 py-2 text-xs flex items-center justify-between gap-2 hover:bg-sup cursor-pointer transition-colors border-l-4 rounded-r-raio-s ${
                                    isAtiva
                                      ? 'bg-acento/15 border-l-acento font-bold text-acento shadow-2xs'
                                      : 'border-l-transparent text-tinta2'
                                  }`}
                                >
                                  <div className="flex flex-col min-w-0 flex-1">
                                    <span
                                      className={`truncate ${
                                        isAtiva ? 'text-acento font-bold' : 'text-tinta font-medium'
                                      }`}
                                    >
                                      {a.nome}
                                    </span>
                                    <div className="flex items-center gap-1.5 text-[10px] text-tinta3 truncate mt-0.5">
                                      {a.pais && (
                                        <span className="font-semibold text-tinta2">{a.pais}</span>
                                      )}
                                      {a.periodo && <span>· {a.periodo}</span>}
                                      <span>
                                        · {a.total_membros} {t('arvore', 'membros')}
                                      </span>
                                    </div>
                                  </div>
                                  {isAtiva && (
                                    <span className="px-2 py-0.5 rounded bg-acento text-acento-tinta text-[9px] font-bold flex items-center gap-1 flex-none shadow-2xs">
                                      <Check className="w-3 h-3 stroke-[2.5]" />
                                      {t('busca', 'arvoreAtivaBadge')}
                                    </span>
                                  )}
                                </button>
                              );
                            })}
                          </div>
                        </div>
                      );
                    })}
                  </div>
                )}

              {arvoresFiltradas.length === 0 && (
                <div className="p-5 text-center text-xs text-tinta3 flex flex-col items-center gap-2">
                  <span>
                    {abaFiltro === 'pessoais'
                      ? t('arvore', 'nenhumaPessoalEncontrada')
                      : t('arvore', 'nenhumaEncontradaFiltro')}
                  </span>
                  {abaFiltro === 'pessoais' && (
                    <button
                      type="button"
                      onClick={() => {
                        setMenuAberto(false);
                        setIniciarCriacaoAoSurgir(true);
                        setModalGerenciarAberto(true);
                      }}
                      className="px-2.5 py-1 rounded bg-acento text-acento-tinta font-semibold hover:bg-acento/90 cursor-pointer flex items-center gap-1 mt-1 text-xs transition-colors"
                    >
                      <Plus className="w-3.5 h-3.5" />
                      {t('arvore', 'criarNovaArvore')}
                    </button>
                  )}
                </div>
              )}
            </div>

            {/* Rodapé de Ações */}
            <div className="border-t border-borda/60 pt-1 flex flex-col">
              <button
                type="button"
                onClick={() => {
                  setMenuAberto(false);
                  setIniciarCriacaoAoSurgir(true);
                  setModalGerenciarAberto(true);
                }}
                className="w-full text-left px-3 py-1.5 text-xs text-tinta2 hover:text-tinta hover:bg-sup flex items-center gap-2 cursor-pointer transition-colors"
              >
                <Plus className="w-3.5 h-3.5 text-acento" />
                {t('arvore', 'novaArvoreMenu')}
              </button>

              <button
                type="button"
                onClick={() => {
                  setMenuAberto(false);
                  setIniciarCriacaoAoSurgir(false);
                  setModalGerenciarAberto(true);
                }}
                className="w-full text-left px-3 py-1.5 text-xs text-tinta2 hover:text-tinta hover:bg-sup flex items-center gap-2 cursor-pointer transition-colors"
              >
                <Settings2 className="w-3.5 h-3.5 text-tinta3" />
                {t('arvore', 'gerenciarArvoresMenu')}
              </button>
            </div>
          </div>
        )}
      </div>

      <ModalGerenciarArvores
        isOpen={modalGerenciarAberto}
        onClose={() => {
          setModalGerenciarAberto(false);
          setIniciarCriacaoAoSurgir(false);
        }}
        arvoreAtivaId={arvoreAtiva?.id ?? null}
        onSelecionarArvore={onSelecionarArvore}
        iniciarComCriacao={iniciarCriacaoAoSurgir}
        abaInicial={abaFiltro === 'pessoais' ? 'pessoais' : 'publicas'}
      />
    </>
  );
}
