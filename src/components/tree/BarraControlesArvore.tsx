import {
  ArrowDown,
  ArrowUp,
  FileImage,
  GitFork,
  ListOrdered,
  Maximize2,
  Minus,
  Plus,
  Target,
  ZoomIn,
  ZoomOut,
} from 'lucide-react';
import { useI18n } from '../../i18n/I18nContext';

export type ModoVisaoArvore = 'completa' | 'ancestrais' | 'descendentes';

interface BarraControlesArvoreProps {
  modo: ModoVisaoArvore;
  onMudarModo: (modo: ModoVisaoArvore) => void;
  geracoes: number;
  onMudarGeracoes: (g: number) => void;
  onZoomIn: () => void;
  onZoomOut: () => void;
  onAjustarTela: () => void;
  onCentralizarRaiz: () => void;
  onAbrirAhnentafel?: () => void;
  onExportarPoster?: () => void;
  className?: string;
}

export function BarraControlesArvore({
  modo,
  onMudarModo,
  geracoes,
  onMudarGeracoes,
  onZoomIn,
  onZoomOut,
  onAjustarTela,
  onCentralizarRaiz,
  onAbrirAhnentafel,
  onExportarPoster,
  className = '',
}: BarraControlesArvoreProps) {
  const { t } = useI18n();

  return (
    <div
      className={`absolute bottom-5 left-1/2 -translate-x-1/2 bg-card/90 backdrop-blur-md border border-borda shadow-sombra rounded-raio px-3 py-2 flex items-center gap-3 z-30 transition-all text-xs select-none ${className}`}
    >
      {/* Modos de Visão */}
      <div className="flex items-center bg-sup rounded-raio-s p-0.5 border border-borda/60">
        <button
          type="button"
          onClick={() => onMudarModo('completa')}
          className={`px-2.5 py-1 rounded-raio-s text-[11px] font-semibold flex items-center gap-1.5 transition-colors cursor-pointer ${
            modo === 'completa'
              ? 'bg-acento text-acento-tinta shadow-2xs'
              : 'text-tinta2 hover:text-tinta'
          }`}
          title={t('arvore', 'visaoCompletaDesc')}
        >
          <GitFork className="w-3.5 h-3.5 rotate-180" />
          <span>{t('arvore', 'visaoCompleta')}</span>
        </button>

        <button
          type="button"
          onClick={() => onMudarModo('ancestrais')}
          className={`px-2.5 py-1 rounded-raio-s text-[11px] font-semibold flex items-center gap-1.5 transition-colors cursor-pointer ${
            modo === 'ancestrais'
              ? 'bg-acento text-acento-tinta shadow-2xs'
              : 'text-tinta2 hover:text-tinta'
          }`}
          title={t('arvore', 'visaoAncestraisDesc')}
        >
          <ArrowUp className="w-3.5 h-3.5" />
          <span>{t('arvore', 'visaoAncestrais')}</span>
        </button>

        <button
          type="button"
          onClick={() => onMudarModo('descendentes')}
          className={`px-2.5 py-1 rounded-raio-s text-[11px] font-semibold flex items-center gap-1.5 transition-colors cursor-pointer ${
            modo === 'descendentes'
              ? 'bg-acento text-acento-tinta shadow-2xs'
              : 'text-tinta2 hover:text-tinta'
          }`}
          title={t('arvore', 'visaoDescendentesDesc')}
        >
          <ArrowDown className="w-3.5 h-3.5" />
          <span>{t('arvore', 'visaoDescendentes')}</span>
        </button>
      </div>

      <div className="h-4 w-px bg-borda flex-none" />

      {/* Controle de Gerações */}
      <div className="flex items-center gap-1.5">
        <span className="text-xs text-tinta font-semibold mr-0.5">{t('arvore', 'profundidade')}:</span>
        <button
          type="button"
          onClick={() => onMudarGeracoes(Math.max(1, geracoes - 1))}
          disabled={geracoes <= 1}
          className="p-1 text-tinta hover:text-acento disabled:opacity-30 rounded hover:bg-sup cursor-pointer disabled:cursor-not-allowed transition-colors"
          title="-"
        >
          <Minus className="w-3.5 h-3.5" />
        </button>

        <span className="font-num font-bold text-xs text-tinta min-w-[36px] text-center bg-sup/80 px-1.5 py-0.5 rounded border border-borda/60">
          {geracoes} {t('arvore', 'geracoesAbrev')}
        </span>

        <button
          type="button"
          onClick={() => onMudarGeracoes(Math.min(12, geracoes + 1))}
          disabled={geracoes >= 12}
          className="p-1 text-tinta hover:text-acento disabled:opacity-30 rounded hover:bg-sup cursor-pointer disabled:cursor-not-allowed transition-colors"
          title="+"
        >
          <Plus className="w-3.5 h-3.5" />
        </button>
      </div>

      <div className="h-4 w-px bg-borda flex-none" />

      {/* Controles de Zoom e Enquadramento */}
      <div className="flex items-center gap-0.5">
        <button
          type="button"
          onClick={onZoomIn}
          className="p-1.5 text-tinta2 hover:text-tinta rounded hover:bg-sup cursor-pointer transition-colors"
          title={t('arvore', 'zoomMais')}
        >
          <ZoomIn className="w-3.5 h-3.5" />
        </button>

        <button
          type="button"
          onClick={onZoomOut}
          className="p-1.5 text-tinta2 hover:text-tinta rounded hover:bg-sup cursor-pointer transition-colors"
          title={t('arvore', 'zoomMenos')}
        >
          <ZoomOut className="w-3.5 h-3.5" />
        </button>

        <button
          type="button"
          onClick={onAjustarTela}
          className="p-1.5 text-tinta2 hover:text-tinta rounded hover:bg-sup cursor-pointer transition-colors"
          title={t('arvore', 'ajustarTela')}
        >
          <Maximize2 className="w-3.5 h-3.5" />
        </button>

        <button
          type="button"
          onClick={onCentralizarRaiz}
          className="p-1.5 text-tinta2 hover:text-acento rounded hover:bg-sup cursor-pointer transition-colors"
          title={t('arvore', 'centralizarRaiz')}
        >
          <Target className="w-3.5 h-3.5" />
        </button>
      </div>

      {onAbrirAhnentafel && (
        <>
          <div className="h-4 w-px bg-borda flex-none" />
          <button
            type="button"
            onClick={onAbrirAhnentafel}
            className="px-2 py-1 rounded bg-sup hover:bg-card border border-borda text-[11px] font-semibold text-tinta flex items-center gap-1.5 cursor-pointer shadow-2xs transition-colors"
            title={t('topo', 'visoesAuxiliares')}
          >
            <ListOrdered className="w-3.5 h-3.5 text-acento" />
            <span>{t('arvore', 'ahnentafel')}</span>
          </button>
        </>
      )}

      {onExportarPoster && (
        <>
          <div className="h-4 w-px bg-borda flex-none" />
          <button
            type="button"
            onClick={onExportarPoster}
            className="px-2 py-1 rounded bg-sup hover:bg-card border border-borda text-[11px] font-semibold text-tinta flex items-center gap-1.5 cursor-pointer shadow-2xs transition-colors"
            title={t('topo', 'posterArvoreDesc')}
          >
            <FileImage className="w-3.5 h-3.5 text-acento" />
            <span>{t('arvore', 'poster')}</span>
          </button>
        </>
      )}
    </div>
  );
}
