/**
 * PROTÓTIPO VISUAL — não ligado ao banco.
 *
 * Exportação GEDZip. Implementa o desenho da seção 4 — o .ged mais a pasta de mídia num zip, com dados fixos
 * escritos no próprio componente. Nenhum dado real passa por aqui ainda: é a
 * maquete aprovada do layout, guardada no código para não se perder e para
 * continuar sendo verificada pelo TypeScript.
 *
 * Previsto para: Depois do MVP.
 *
 * Ao ligar de verdade: trocar os valores fixos por `useQuery` sobre os
 * comandos de `src/lib/api`, e apagar este aviso.
 */
import { useState } from 'react';

interface ExportGedzipDialogProps {
  onClose: () => void;
  onExport: (options: ExportOptions) => void;
}

export interface ExportOptions {
  scope: string;
  includeMedia: boolean;
  hideLiving: boolean;
  includeTranscripts: boolean;
}

export function ExportGedzipDialog({ onClose, onExport }: ExportGedzipDialogProps) {
  const [includeMedia, setIncludeMedia] = useState(true);
  const [hideLiving, setHideLiving] = useState(true);
  const [includeTranscripts, setIncludeTranscripts] = useState(false);

  const handleExport = () => {
    onExport({ scope: 'all', includeMedia, hideLiving, includeTranscripts });
  };

  return (
    <div className="flex flex-col gap-5 w-full max-w-[560px] border border-borda2 rounded-raio bg-card shadow-sombra overflow-hidden mx-auto mt-10">
      <div className="p-5 md:px-6 border-b border-borda flex flex-col gap-1.5">
        <span className="font-tit font-fw7 text-lg tracking-tit text-tinta">Exportar GEDZip</span>
        <span className="text-[13px] text-tinta2">
          Um zip com o <span className="font-num text-[12.5px]">.ged</span> e a pasta de mídia — o formato para levar o acervo para outro programa ou outra máquina.
        </span>
      </div>

      <div className="px-5 md:px-6 pb-5 flex flex-col gap-4">
        
        <label className="flex flex-col gap-2">
          <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Escopo</span>
          <select className="p-2.5 border border-borda2 rounded-raio-s bg-bg text-sm text-tinta outline-none focus:border-acento">
            <option>Acervo inteiro · 4 árvores</option>
            <option>Somente árvore atual</option>
          </select>
        </label>

        <div className="flex flex-col gap-2.5 mt-2">
          <label className="flex items-center gap-2.5 text-[13.5px] text-tinta cursor-pointer group">
            <div className={`w-4 h-4 rounded flex items-center justify-center flex-none transition-colors ${includeMedia ? 'bg-acento border-acento' : 'border border-borda2 group-hover:border-borda'}`}>
              {includeMedia && <span className="text-[10px] text-acento-tinta font-fw6">✓</span>}
            </div>
            <input type="checkbox" className="sr-only" checked={includeMedia} onChange={(e) => setIncludeMedia(e.target.checked)} />
            Incluir mídia <span className="font-num text-xs text-tinta3 ml-1">96 arquivos · 412 MB</span>
          </label>

          <label className="flex items-center gap-2.5 text-[13.5px] text-tinta cursor-pointer group">
            <div className={`w-4 h-4 rounded flex items-center justify-center flex-none transition-colors ${hideLiving ? 'bg-acento border-acento' : 'border border-borda2 group-hover:border-borda'}`}>
              {hideLiving && <span className="text-[10px] text-acento-tinta font-fw6">✓</span>}
            </div>
            <input type="checkbox" className="sr-only" checked={hideLiving} onChange={(e) => setHideLiving(e.target.checked)} />
            Ocultar dados de pessoas vivas
          </label>

          <label className="flex items-center gap-2.5 text-[13.5px] text-tinta cursor-pointer group">
            <div className={`w-4 h-4 rounded flex items-center justify-center flex-none transition-colors ${includeTranscripts ? 'bg-acento border-acento' : 'border border-borda2 group-hover:border-borda'}`}>
              {includeTranscripts && <span className="text-[10px] text-acento-tinta font-fw6">✓</span>}
            </div>
            <input type="checkbox" className="sr-only" checked={includeTranscripts} onChange={(e) => setIncludeTranscripts(e.target.checked)} />
            Incluir transcrições nas notas
          </label>
        </div>

        <div className="p-3 border border-borda rounded-raio-s bg-bg flex flex-col gap-1.5 mt-2">
          <span className="flex justify-between text-[13px] text-tinta2">Saída <span className="font-num text-[12.5px] text-tinta">acervo-2026-08-28.gdz</span></span>
          <span className="flex justify-between text-[13px] text-tinta2">Tamanho estimado <span className="font-num text-[12.5px] text-tinta">{includeMedia ? '418 MB' : '1.2 MB'}</span></span>
          <span className="flex justify-between text-[13px] text-tinta2">Padrão <span className="font-num text-[12.5px] text-tinta">GEDCOM 7.0</span></span>
        </div>

        <div className="flex gap-2.5 justify-end mt-2">
          <button type="button" onClick={onClose} className="touch-manipulation px-4 py-2.5 rounded-raio-s border border-borda2 bg-bg text-tinta font-corpo text-sm hover:bg-card transition-colors">
            Cancelar
          </button>
          <button type="button" onClick={handleExport} className="touch-manipulation px-4 py-2.5 rounded-raio-s border border-acento bg-acento text-acento-tinta font-corpo text-sm font-fw6">
            Exportar
          </button>
        </div>
      </div>
    </div>
  );
}