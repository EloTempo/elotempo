// src/features/import/components/GedcomImportWizard.tsx
import { useState } from 'react';

export function GedcomImportWizard() {
  const [currentConflict, setCurrentConflict] = useState(1);
  const [step, setStep] = useState(1);

  return (
    <div className="flex flex-col w-full max-w-[708px] h-[742px] border border-borda2 rounded-[10px] bg-bg shadow-sombra overflow-hidden mx-auto mt-10">
      
      {/* Cabeçalho da Janela */}
      <div className="h-[38px] flex items-stretch justify-between bg-sup border-b border-borda flex-none">
        <div className="flex items-center gap-3 pl-3.5">
          <span className="w-4 h-4 rounded-[3px] bg-acento block"></span>
          <span className="text-[13px] text-tinta2">Importar GEDCOM — {step} de 4</span>
        </div>
        <button className="touch-manipulation w-[46px] grid place-items-center text-[13px] text-tinta2 hover:bg-card">✕</button>
      </div>

      {/* Título e Progresso */}
      <div className="p-5 md:px-6 border-b border-borda flex flex-col gap-3.5 flex-none">
        <div className="flex items-center gap-2.5 text-[12.5px] overflow-x-auto hide-scrollbar">
          <span className="flex items-center gap-2 flex-none"><span className="w-5 h-5 rounded-full bg-acento text-acento-tinta font-num text-[11px] grid place-items-center">✓</span><span className="text-tinta2">Arquivo</span></span>
          <span className="flex-1 h-px bg-borda min-w-[20px]"></span>
          <span className="flex items-center gap-2 flex-none"><span className="w-5 h-5 rounded-full bg-acento text-acento-tinta font-num text-[11px] grid place-items-center">✓</span><span className="text-tinta2">Leitura</span></span>
          <span className="flex-1 h-px bg-borda min-w-[20px]"></span>
          <span className="flex items-center gap-2 flex-none"><span className="w-5 h-5 rounded-full border-2 border-acento text-acento font-num text-[11px] grid place-items-center">3</span><span className="text-tinta font-fw6">Conflitos</span></span>
          <span className="flex-1 h-px bg-borda min-w-[20px]"></span>
          <span className="flex items-center gap-2 flex-none opacity-50"><span className="w-5 h-5 rounded-full border border-borda2 text-tinta3 font-num text-[11px] grid place-items-center">4</span><span className="text-tinta3">Aplicar</span></span>
        </div>
        <div className="flex items-center justify-between mt-2">
          <div className="flex flex-col gap-1">
            <span className="font-tit font-fw7 text-[19px] tracking-tit text-tinta">7 conflitos a resolver</span>
            <span className="text-[13px] text-tinta2">rangel-familia.ged · GEDCOM 7.0 · 31 pessoas, 11 uniões</span>
          </div>
          <button className="touch-manipulation text-[12.5px] px-3 py-1.5 rounded-full bg-card border border-borda text-tinta2 hover:border-tinta transition-colors">
            Aplicar a todos os semelhantes
          </button>
        </div>
      </div>

      {/* Lista de Conflitos (Scroll) */}
      <div className="flex-1 flex flex-col min-h-0 overflow-y-auto">
        
        {/* Conflito 1: Pessoa Duplicada */}
        <div className="p-5 md:px-6 border-b border-borda flex flex-col gap-3.5">
          <div className="flex items-center gap-2.5">
            <span className="font-num text-[11px] px-2.5 py-1 rounded-full bg-chip text-tinta2">{currentConflict} / 7</span>
            <span className="text-sm text-tinta font-fw6">Pessoa possivelmente duplicada</span>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            <div className="p-3 border-2 border-acento rounded-raio-s bg-card flex flex-col gap-2">
              <span className="font-num text-[10.5px] tracking-[0.1em] uppercase text-tinta3">No acervo</span>
              <span className="font-tit font-fw7 text-[15px] tracking-tit">Otávio Rangel</span>
              <span className="font-num text-xs text-tinta2 leading-relaxed">n. 1944 · Macaé<br/>união com Ana Silva · 2 filhos<br/>3 documentos</span>
            </div>
            <div className="p-3 border border-borda2 rounded-raio-s bg-card flex flex-col gap-2">
              <span className="font-num text-[10.5px] tracking-[0.1em] uppercase text-tinta3">No arquivo</span>
              <span className="font-tit font-fw7 text-[15px] tracking-tit">Otavio Rangel de Souza</span>
              <span className="font-num text-xs text-tinta2 leading-relaxed">n. 12/07/1944 · Macaé<br/>união com Ana Silva · 2 filhos<br/>1 documento</span>
            </div>
          </div>
          <div className="flex gap-2 flex-wrap mt-1">
            <button className="touch-manipulation px-3.5 py-2 rounded-raio-s border border-acento bg-acento text-acento-tinta font-corpo text-[13px] font-fw6">Mesclar, mantendo o mais completo</button>
            <button className="touch-manipulation px-3.5 py-2 rounded-raio-s border border-borda2 bg-card text-tinta font-corpo text-[13px] hover:bg-card2">Manter as duas</button>
            <button className="touch-manipulation px-3.5 py-2 rounded-raio-s border border-borda2 bg-card text-tinta font-corpo text-[13px] hover:bg-card2">Ignorar a do arquivo</button>
          </div>
          <span className="text-[12.5px] text-tinta3 leading-relaxed">Ao mesclar, o nome mais completo entra como principal e o outro fica como variante. Nenhum documento é descartado.</span>
        </div>

        {/* Conflito 2: Regra de Domínio (Slots do mesmo sexo) */}
        <div className="p-5 md:px-6 border-b border-borda flex flex-col gap-3">
          <div className="flex items-center gap-2.5">
            <span className="font-num text-[11px] px-2.5 py-1 rounded-full bg-chip text-tinta2">3 / 7</span>
            <span className="text-sm text-tinta font-fw6">União com dois slots do mesmo sexo</span>
          </div>
          <span className="text-[13.5px] text-tinta2 leading-relaxed">O arquivo declara <span className="font-num text-[12.5px] text-tinta">FAM @F17@</span> com dois cônjuges masculinos. O modelo exige um slot masculino e um feminino.</span>
          <div className="flex gap-2 flex-wrap mt-1">
            <button className="touch-manipulation px-3.5 py-2 rounded-raio-s border border-acento bg-acento text-acento-tinta font-corpo text-[13px] font-fw6">Importar como vínculo parental</button>
            <button className="touch-manipulation px-3.5 py-2 rounded-raio-s border border-borda2 bg-card text-tinta font-corpo text-[13px] hover:bg-card2">Descartar a união</button>
          </div>
          <span className="text-[12.5px] text-tinta3 leading-relaxed">Os filhos são preservados em qualquer opção; só o elo entre os adultos muda.</span>
        </div>

      </div>

      {/* Rodapé de Ações */}
      <div className="p-4 border-t border-borda bg-sup flex items-center justify-between flex-none">
        <span className="text-[12.5px] text-tinta3 hidden md:inline">Nada é gravado até a última etapa · desfazer completo depois</span>
        <div className="flex gap-2.5 ml-auto">
          <button className="touch-manipulation px-4 py-2.5 rounded-raio-s border border-borda2 bg-card text-tinta font-corpo text-[13.5px] hover:bg-card2 transition-colors">Cancelar</button>
          <button onClick={() => { setCurrentConflict(c => c + 1); setStep(3); }} className="touch-manipulation px-4 py-2.5 rounded-raio-s border border-acento bg-acento text-acento-tinta font-corpo text-[13.5px] font-fw6">
            Próximo conflito
          </button>
        </div>
      </div>
      
    </div>
  );
}