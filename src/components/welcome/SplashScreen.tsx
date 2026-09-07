import { useState, useEffect } from 'react';
import { useQuery } from '@tanstack/react-query';
import {
  FileUp,
  FolderOpen,
  Globe2,
  Plus,
  ShieldCheck,
  X,
  Users,
} from 'lucide-react';
import { IconeArvore, IconeLinhaTempo, IconeAplicativo } from '../icons';
import { listarArvores, type ArvoreInfo } from '../../lib/api';
import { useI18n } from '../../i18n/I18nContext';

interface SplashScreenProps {
  aberto: boolean;
  aoFechar: () => void;
  onCriarNovaArvore: () => void;
  onSelecionarArvore: (arvore: ArvoreInfo) => void;
  onImportarGedcom: () => void;
  onAbrirLinhaTempo?: () => void;
}

export function SplashScreen({
  aberto,
  aoFechar,
  onCriarNovaArvore,
  onSelecionarArvore,
  onImportarGedcom,
  onAbrirLinhaTempo,
}: SplashScreenProps) {
  const { t } = useI18n();
  const [mostrarAoIniciar, setMostrarAoIniciar] = useState<boolean>(() => {
    try {
      return localStorage.getItem('elotempo-mostrar-splash') !== 'false';
    } catch {
      return true;
    }
  });

  const { data: arvores } = useQuery({
    queryKey: ['arvores'],
    queryFn: listarArvores,
    enabled: aberto,
  });

  const handleToggleMostrarAoIniciar = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.checked;
    setMostrarAoIniciar(val);
    try {
      localStorage.setItem('elotempo-mostrar-splash', String(val));
    } catch {}
  };

  // Fecha com tecla Escape
  useEffect(() => {
    if (!aberto) return;
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') aoFechar();
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [aberto, aoFechar]);

  if (!aberto) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-6 bg-black/60 backdrop-blur-md animate-in fade-in duration-200">
      <div className="relative w-full max-w-2xl bg-card rounded-raio border border-borda shadow-sombra overflow-hidden flex flex-col max-h-[90vh]">
        {/* Banner Superior Estilo Blender */}
        <div className="relative p-6 bg-gradient-to-br from-sup via-card2 to-sup border-b border-borda flex items-start justify-between">
          <div className="flex items-start gap-4">
            {/* O ícone oficial da marca EloTempo */}
            <IconeAplicativo size={54} className="flex-none rounded-[14px] shadow-xs" />
            <div>
              <div className="flex items-center gap-2.5">
                <h2 className="font-marca font-medium text-2xl text-tinta leading-none tracking-[-0.025em]">
                  EloTempo
                </h2>
                <span className="text-xs font-semibold px-2 py-0.5 rounded-full bg-masc/15 text-masc border border-masc/25 font-num">
                  v0.1.0
                </span>
              </div>
              <p className="text-xs text-tinta2 mt-1.5 m-0 max-w-md leading-relaxed">
                {t('splash', 'subtitulo')}
              </p>
              <div className="flex items-center gap-4 mt-2.5 text-[11px] text-tinta3 font-medium">
                <span className="flex items-center gap-1">
                  <ShieldCheck className="w-3.5 h-3.5 text-emerald-600 dark:text-emerald-400" />
                  100% Offline & Local-First
                </span>
                <span className="flex items-center gap-1">
                  <Globe2 className="w-3.5 h-3.5 text-acento" />
                  GEDCOM 7.0 & 5.5.1
                </span>
              </div>
            </div>
          </div>

          <button
            type="button"
            onClick={aoFechar}
            className="p-1 rounded-full text-tinta3 hover:text-tinta hover:bg-sup transition-colors cursor-pointer"
            title="Fechar"
            aria-label="Fechar"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Corpo: Duas Colunas (Ações Rápidas à Esquerda, Árvores Recentes à Direita) */}
        <div className="p-6 grid grid-cols-1 md:grid-cols-2 gap-6 overflow-y-auto">
          {/* Coluna 1: Ações Iniciais */}
          <div className="flex flex-col gap-2.5">
            <span className="text-xs font-bold text-tinta3 uppercase tracking-wider mb-1">
              Começar
            </span>

            <button
              type="button"
              onClick={() => {
                aoFechar();
                onCriarNovaArvore();
              }}
              className="flex items-start gap-3 p-3 rounded-raio border border-acento/40 bg-acento/10 hover:bg-acento/15 text-left transition-all cursor-pointer group shadow-2xs hover:border-acento"
            >
              <div className="w-9 h-9 rounded-raio-s bg-acento text-acento-tinta flex items-center justify-center flex-none mt-0.5 group-hover:scale-105 transition-transform">
                <Plus className="w-5 h-5" />
              </div>
              <div className="min-w-0">
                <span className="font-semibold text-tinta text-sm block group-hover:text-acento transition-colors">
                  {t('splash', 'novaArvore')}
                </span>
                <span className="text-xs text-tinta2 leading-relaxed">
                  {t('splash', 'novaArvoreDesc')}
                </span>
              </div>
            </button>

            <button
              type="button"
              onClick={() => {
                aoFechar();
                onImportarGedcom();
              }}
              className="flex items-start gap-3 p-3 rounded-raio border border-borda hover:border-acento/60 bg-card hover:bg-sup text-left transition-all cursor-pointer group shadow-2xs"
            >
              <div className="w-9 h-9 rounded-raio-s bg-sup text-tinta2 flex items-center justify-center flex-none mt-0.5 group-hover:text-acento group-hover:scale-105 transition-transform border border-borda">
                <FileUp className="w-5 h-5" />
              </div>
              <div className="min-w-0">
                <span className="font-semibold text-tinta text-sm block group-hover:text-acento transition-colors">
                  {t('splash', 'importarGedcom')}
                </span>
                <span className="text-xs text-tinta2 leading-relaxed">
                  {t('splash', 'importarGedcomDesc')}
                </span>
              </div>
            </button>

            {onAbrirLinhaTempo && (
              <button
                type="button"
                onClick={() => {
                  aoFechar();
                  onAbrirLinhaTempo();
                }}
                className="flex items-start gap-3 p-3 rounded-raio border border-borda hover:border-acento/60 bg-card hover:bg-sup text-left transition-all cursor-pointer group shadow-2xs"
              >
                <div className="w-9 h-9 rounded-raio-s bg-sup text-tinta2 flex items-center justify-center flex-none mt-0.5 group-hover:text-acento group-hover:scale-105 transition-transform border border-borda">
                  <IconeLinhaTempo className="w-5 h-5" />
                </div>
                <div className="min-w-0">
                  <span className="font-semibold text-tinta text-sm block group-hover:text-acento transition-colors">
                    {t('splash', 'explorarLinhaTempo')}
                  </span>
                  <span className="text-xs text-tinta2 leading-relaxed">
                    {t('splash', 'explorarLinhaTempoDesc')}
                  </span>
                </div>
              </button>
            )}
          </div>

          {/* Coluna 2: Árvores do Acervo */}
          <div className="flex flex-col gap-2 min-w-0">
            <span className="text-xs font-bold text-tinta3 uppercase tracking-wider mb-1 flex items-center justify-between">
              <span>{t('splash', 'arvoresDisponiveis')}</span>
              <FolderOpen className="w-3.5 h-3.5 text-tinta3" />
            </span>

            {arvores && arvores.length > 0 ? (
              <div className="flex flex-col gap-1.5 max-h-56 overflow-y-auto pr-1">
                {arvores.map((a) => (
                  <button
                    key={a.id}
                    type="button"
                    onClick={() => {
                      onSelecionarArvore(a);
                      aoFechar();
                    }}
                    className="flex items-center justify-between p-2.5 rounded-raio-s border border-borda bg-card hover:bg-sup text-left transition-colors cursor-pointer group"
                  >
                    <div className="flex items-center gap-2.5 min-w-0 flex-1">
                      <IconeArvore className="w-4 h-4 text-acento flex-none" />
                      <div className="min-w-0 flex-1">
                        <span className="font-semibold text-xs text-tinta truncate block group-hover:text-acento">
                          {a.nome}
                        </span>
                        <span className="text-[11px] text-tinta3 truncate block">
                          {a.raiz_pessoa_nome ?? (a.is_publico ? 'Exemplo histórico' : 'Árvore familiar')}
                        </span>
                      </div>
                    </div>
                    {a.total_membros != null && a.total_membros > 0 && (
                      <span className="text-[11px] font-num text-tinta3 px-1.5 py-0.5 rounded bg-sup border border-borda flex-none ml-2 flex items-center gap-1">
                        <Users className="w-3 h-3 text-tinta3" />
                        {a.total_membros}
                      </span>
                    )}
                  </button>
                ))}
              </div>
            ) : (
              <div className="p-6 text-center border border-dashed border-borda rounded-raio text-xs text-tinta3 flex flex-col items-center justify-center gap-1.5 h-44">
                <IconeArvore className="w-6 h-6 opacity-40 text-acento" />
                <span>{t('splash', 'semArvores')}</span>
              </div>
            )}
          </div>
        </div>

        {/* Rodapé da Splash Screen */}
        <div className="px-6 py-3 border-t border-borda bg-card2/60 flex items-center justify-between gap-4 flex-wrap text-xs">
          <label className="flex items-center gap-2 text-tinta2 cursor-pointer select-none text-xs">
            <input
              type="checkbox"
              checked={mostrarAoIniciar}
              onChange={handleToggleMostrarAoIniciar}
              className="rounded border-borda text-acento focus:ring-acento cursor-pointer"
            />
            <span>{t('splash', 'mostrarAoIniciar')}</span>
          </label>

          <button
            type="button"
            onClick={aoFechar}
            className="text-xs text-tinta2 hover:text-tinta font-semibold cursor-pointer underline-offset-4 hover:underline"
          >
            {t('splash', 'comecarEmBranco')} →
          </button>
        </div>
      </div>
    </div>
  );
}
