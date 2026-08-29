/**
 * PROTÓTIPO VISUAL — não ligado ao banco.
 *
 * Gaveta de linha do tempo. Implementa o desenho da seção 8 — camadas de contexto sobre a vida da pessoa, com dados fixos
 * escritos no próprio componente. Nenhum dado real passa por aqui ainda: é a
 * maquete aprovada do layout, guardada no código para não se perder e para
 * continuar sendo verificada pelo TypeScript.
 *
 * Previsto para: Depois do MVP.
 *
 * Ao ligar de verdade: trocar os valores fixos por `useQuery` sobre os
 * comandos de `src/lib/api`, e apagar este aviso.
 */
import { useState, useRef, useEffect, MouseEvent as ReactMouseEvent } from 'react';

interface TimelineDrawerProps {
  personName: string;
  birthYear: number;
  deathYear?: number;
  onClose?: () => void;
  onOpenStudio?: () => void;
}

export function TimelineDrawer({ personName, birthYear, deathYear, onClose, onOpenStudio }: TimelineDrawerProps) {
  // Controle da altura da gaveta arrastável
  const [height, setHeight] = useState(380);
  const isDragging = useRef(false);
  const startY = useRef(0);
  const startHeight = useRef(0);

  // Manipuladores do Drag/Split (Mouse e Touch)
  const handlePointerDown = (e: React.MouseEvent | React.TouchEvent) => {
    isDragging.current = true;
    const clientY = 'touches' in e ? e.touches[0].clientY : (e as ReactMouseEvent).clientY;
    startY.current = clientY;
    startHeight.current = height;
    document.body.style.cursor = 'row-resize';
    document.body.style.userSelect = 'none';
  };

  useEffect(() => {
    const handlePointerMove = (e: MouseEvent | TouchEvent) => {
      if (!isDragging.current) return;
      const clientY = 'touches' in e ? e.touches[0].clientY : e.clientY;
      const deltaY = startY.current - clientY;
      // Limites: mínima de 200px, máxima de 800px (ou 80% da tela)
      const newHeight = Math.max(200, Math.min(window.innerHeight * 0.8, startHeight.current + deltaY));
      setHeight(newHeight);
    };

    const handlePointerUp = () => {
      isDragging.current = false;
      document.body.style.cursor = 'default';
      document.body.style.userSelect = 'auto';
    };

    window.addEventListener('mousemove', handlePointerMove);
    window.addEventListener('mouseup', handlePointerUp);
    window.addEventListener('touchmove', handlePointerMove);
    window.addEventListener('touchend', handlePointerUp);

    return () => {
      window.removeEventListener('mousemove', handlePointerMove);
      window.removeEventListener('mouseup', handlePointerUp);
      window.removeEventListener('touchmove', handlePointerMove);
      window.removeEventListener('touchend', handlePointerUp);
    };
  }, []);

  return (
    <div style={{ height: `${height}px` }} className="flex flex-col w-full bg-sup border-t border-borda shrink-0 transition-none z-10 relative shadow-[0_-4px_16px_rgba(0,0,0,0.05)]">
      
      {/* Alça de redimensionamento (Split arrastável) */}
      <div 
        onMouseDown={handlePointerDown}
        onTouchStart={handlePointerDown}
        className="h-3 bg-sup flex items-center justify-center border-b border-borda cursor-row-resize touch-none flex-none hover:bg-card transition-colors"
      >
        <span className="w-12 h-1 rounded-full bg-borda2 block pointer-events-none"></span>
      </div>

      {/* Cabeçalho da Gaveta */}
      <div className="h-[52px] border-b border-borda bg-bg flex items-center justify-between px-5 gap-4 flex-none">
        <div className="flex items-center gap-2.5">
          <span className="font-tit font-fw7 text-base tracking-tit text-tinta">Linha do tempo</span>
          <span className="text-xs px-2.5 py-1 rounded-full bg-chip text-tinta2 font-num">3 / 3 camadas</span>
        </div>
        <div className="flex items-center gap-2">
          <button className="touch-manipulation text-[12.5px] px-3 py-1.5 rounded-full bg-card border border-borda text-tinta2 hover:border-tinta3 transition-colors">
            ＋ Camada
          </button>
          <span className="w-[1px] h-5 bg-borda mx-1"></span>
          <div className="flex items-center border border-borda rounded-full bg-card overflow-hidden font-num text-xs">
            <button className="touch-manipulation px-3 py-1.5 text-tinta3 hover:bg-sup">século</button>
            <button className="touch-manipulation px-3 py-1.5 bg-acento text-acento-tinta font-fw6">década</button>
            <button className="touch-manipulation px-3 py-1.5 text-tinta3 hover:bg-sup">ano</button>
          </div>
          <span className="w-[1px] h-5 bg-borda mx-1"></span>
          <button onClick={onOpenStudio} className="touch-manipulation text-[12.5px] px-3 py-1.5 rounded-full bg-card border border-borda text-tinta2 hover:text-tinta transition-colors">
            Estúdio ↗
          </button>
          {onClose && (
            <button onClick={onClose} className="touch-manipulation text-[12.5px] w-8 h-8 rounded-full bg-card border border-borda text-tinta2 flex items-center justify-center hover:bg-fem hover:text-white hover:border-fem ml-1 transition-colors">
              ✕
            </button>
          )}
        </div>
      </div>

      {/* Área Principal de Dados */}
      <div className="flex-1 flex min-h-0">
        
        {/* Coluna Esquerda: Títulos das Camadas */}
        <div className="w-[196px] border-r border-borda flex flex-col bg-sup z-10 shadow-[2px_0_8px_rgba(0,0,0,0.02)] flex-none">
          {/* Espaço morto para alinhar com o eixo de tempo */}
          <div className="h-[34px] border-b border-borda flex-none bg-bg"></div>
          
          <div className="h-[62px] border-b border-borda px-4 flex flex-col justify-center gap-0.5 bg-card">
            <span className="text-[13.5px] font-fw6 text-tinta truncate">{personName}</span>
            <span className="font-num text-[11px] text-tinta3">vida · sempre visível</span>
          </div>
          
          <div className="h-[56px] border-b border-borda px-4 flex items-center justify-between hover:bg-card transition-colors">
            <div className="flex flex-col gap-0.5 min-w-0">
              <span className="text-[13.5px] text-tinta truncate">História do Brasil</span>
              <span className="font-num text-[10.5px] text-tinta3 truncate">🔒 contexto</span>
            </div>
            {/* Toggle Switch ativo */}
            <span className="w-[26px] h-[15px] rounded-full bg-acento relative block shrink-0"><span className="absolute right-[2px] top-[2px] w-[11px] h-[11px] rounded-full bg-acento-tinta block"></span></span>
          </div>
          
          <div className="h-[56px] border-b border-borda px-4 flex items-center justify-between hover:bg-card transition-colors">
            <div className="flex flex-col gap-0.5 min-w-0">
              <span className="text-[13.5px] text-tinta truncate">Moeda</span>
              <span className="font-num text-[10.5px] text-tinta3 truncate">🔒 contexto</span>
            </div>
            <span className="w-[26px] h-[15px] rounded-full bg-acento relative block shrink-0"><span className="absolute right-[2px] top-[2px] w-[11px] h-[11px] rounded-full bg-acento-tinta block"></span></span>
          </div>
        </div>

        {/* Coluna Direita: Eixo do Tempo e Eventos (Área de scroll horizontal / Pan-Zoom) */}
        <div className="flex-1 relative min-w-0 overflow-x-auto overflow-y-hidden bg-bg">
          {/* Grid de fundo para guiar a visão temporal */}
          <div className="absolute inset-0 bg-[linear-gradient(to_right,var(--borda)_1px,transparent_1px)] bg-[size:16.6%_100%] opacity-40 pointer-events-none"></div>

          <div className="min-w-[1200px] h-full relative">
            
            {/* Eixo do tempo superior */}
            <div className="h-[34px] border-b border-borda relative bg-bg/80 backdrop-blur-sm sticky top-0 z-10">
              <span className="absolute left-[0%] top-2 font-num text-[11px] text-tinta3 pl-2">1940</span>
              <span className="absolute left-[16.6%] top-2 font-num text-[11px] text-tinta3 pl-2">1955</span>
              <span className="absolute left-[33.3%] top-2 font-num text-[11px] text-tinta3 pl-2">1970</span>
              <span className="absolute left-[50%] top-2 font-num text-[11px] text-tinta3 pl-2">1985</span>
              <span className="absolute left-[66.6%] top-2 font-num text-[11px] text-tinta3 pl-2">2000</span>
              
              {/* Marcador Vertical do Evento Selecionado (ex: Golpe Militar) */}
              <div className="absolute left-[26.6%] top-0 bottom-[-800px] w-px bg-acento opacity-75 z-0 pointer-events-none"></div>
              <div className="absolute left-[26.6%] top-0 h-5 -translate-x-1/2 px-2 rounded-b-md bg-acento text-acento-tinta font-num text-[11px] flex items-center justify-center shadow-md">
                1964
              </div>
            </div>

            {/* Linha 1: A vida da pessoa selecionada */}
            <div className="absolute left-0 right-0 top-[34px] h-[62px] border-b border-borda bg-card flex items-center relative hover:bg-card2 transition-colors">
              {/* Barra de vida - Nascimento ao Falecimento (posicionamento hipotético percentual) */}
              <div className="absolute left-[5.5%] right-[20%] top-[20px] h-4 rounded-full border border-masc bg-masc/20 block"></div>
              
              <span className="absolute left-[5.5%] top-[14px] w-2.5 h-2.5 rounded-full bg-masc -translate-x-1 mt-[7px]"></span>
              <span className="absolute left-[5.5%] top-[40px] font-num text-[10.5px] text-tinta2 -translate-x-1.5">n. {birthYear}</span>
              
              <span className="absolute left-[33%] top-[14px] w-2.5 h-2.5 rounded-full bg-fem mt-[7px]"></span>
              <span className="absolute left-[33%] top-[40px] font-num text-[10.5px] text-tinta2 -translate-x-3.5">⚭ 1967</span>
              
              <span className="absolute left-[80%] top-[14px] w-2.5 h-2.5 rounded-full bg-tinta2 mt-[7px]"></span>
              <span className="absolute left-[80%] top-[40px] font-num text-[10.5px] text-tinta2 -translate-x-2">† {deathYear || '2012'}</span>
            </div>

            {/* Linha 2: História do Brasil */}
            <div className="absolute left-0 right-0 top-[96px] h-[56px] border-b border-borda relative hover:bg-card2 transition-colors">
              <span className="absolute left-[22%] top-[16px] px-2.5 py-1 rounded-full bg-chip border border-borda2 text-[11.5px] text-tinta -translate-x-1/2 whitespace-nowrap cursor-pointer hover:border-tinta transition-colors">1960 Brasília</span>
              
              {/* Evento Selecionado em Destaque */}
              <span className="absolute left-[26.6%] top-[38px] w-2 h-2 rounded-full bg-acento -translate-x-1/2 block ring-4 ring-acento/20"></span>
              
              <span className="absolute left-[45%] top-[16px] px-2.5 py-1 rounded-full bg-chip border border-borda2 text-[11.5px] text-tinta -translate-x-1/2 whitespace-nowrap cursor-pointer hover:border-tinta transition-colors">7 marcos</span>
              <span className="absolute left-[63.5%] top-[16px] px-2.5 py-1 rounded-full bg-chip border border-borda2 text-[11.5px] text-tinta -translate-x-1/2 whitespace-nowrap cursor-pointer hover:border-tinta transition-colors">1988 Constituição</span>
            </div>

            {/* Linha 3: Moeda (Períodos de duração) */}
            <div className="absolute left-0 right-0 top-[152px] h-[56px] border-b border-borda relative hover:bg-card2 transition-colors">
              <span className="absolute left-[0%] w-[15%] top-[20px] h-[15px] rounded border border-borda2 bg-tinta2/20 flex items-center justify-center font-num text-[9.5px] text-tinta2 cursor-pointer hover:border-tinta">cruzeiro</span>
              <span className="absolute left-[16%] w-[22%] top-[20px] h-[15px] rounded border border-borda2 bg-tinta2/20 flex items-center justify-center font-num text-[9.5px] text-tinta2 cursor-pointer hover:border-tinta">cruzeiro novo</span>
              <span className="absolute left-[64%] right-0 top-[20px] h-[15px] rounded border border-acento bg-acento/25 flex items-center justify-center font-num text-[9.5px] text-tinta cursor-pointer hover:bg-acento/35">real · desde 1994</span>
            </div>

          </div>
        </div>

      </div>
    </div>
  );
}