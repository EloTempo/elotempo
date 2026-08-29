// src/features/reports/components/ReportGenerator.tsx
import { useState } from 'react';

type PrintMode = 'hierarquia' | 'texto' | 'combinado';

interface ReportGeneratorProps {
  onClose: () => void;
}

export function ReportGenerator({ onClose }: ReportGeneratorProps) {
  const [printMode, setPrintMode] = useState<PrintMode>('combinado');
  const [hideLiving, setHideLiving] = useState(true);

  return (
    <div className="flex flex-col w-full h-full bg-bg absolute inset-0 z-40">
      
      {/* Cabeçalho */}
      <div className="h-[38px] flex items-stretch justify-between bg-sup border-b border-borda flex-none">
        <div className="flex items-center gap-3 pl-3.5">
          <span className="w-4 h-4 rounded-[3px] bg-acento block"></span>
          <span className="text-[13px] text-tinta2">Relatório — Silva · Campos</span>
        </div>
        <button onClick={onClose} className="touch-manipulation w-[46px] grid place-items-center text-[13px] text-tinta2 hover:bg-card">
          ✕
        </button>
      </div>

      <div className="flex flex-1 min-h-0">
        
        {/* COLUNA ESQUERDA: Configurações */}
        <div className="w-[300px] border-r border-borda bg-sup flex flex-col flex-none overflow-y-auto min-h-0">
          
          <div className="p-4 border-b border-borda flex flex-col gap-3">
            <span className="font-tit font-fw7 text-[17px] tracking-tit text-tinta">Modo de impressão</span>
            <div className="flex flex-col gap-2">
              {[
                { id: 'hierarquia', label: 'Só hierarquia', desc: 'o diagrama · 2 páginas' },
                { id: 'texto', label: 'Só texto', desc: 'fichas corridas · 9 páginas' },
                { id: 'combinado', label: 'Combinado', desc: 'diagrama + fichas · 11 páginas' }
              ].map(mode => (
                <button
                  key={mode.id}
                  onClick={() => setPrintMode(mode.id as PrintMode)}
                  className={`touch-manipulation flex gap-3 items-center p-2.5 border rounded-raio-s transition-all ${
                    printMode === mode.id ? 'border-2 border-acento bg-card' : 'border border-borda bg-card hover:border-borda2'
                  }`}
                >
                  <div className={`w-8 h-10 border rounded-[3px] flex-none ${printMode === mode.id ? 'border-acento bg-bg' : 'border-borda2 bg-bg'}`}>
                    {/* Ícone simplificado de página para visualização */}
                    <div className="w-full h-full p-1 flex flex-col gap-1 opacity-50">
                      <div className={`h-0.5 w-full ${printMode === mode.id ? 'bg-acento' : 'bg-tinta3'}`}></div>
                      <div className={`h-0.5 w-3/4 ${printMode === mode.id ? 'bg-acento' : 'bg-tinta3'}`}></div>
                    </div>
                  </div>
                  <div className="flex flex-col gap-0.5 text-left">
                    <span className={`text-[13.5px] ${printMode === mode.id ? 'font-fw6 text-tinta' : 'text-tinta'}`}>{mode.label}</span>
                    <span className="font-num text-[11px] text-tinta3">{mode.desc}</span>
                  </div>
                </button>
              ))}
            </div>
          </div>

          <div className="p-4 border-b border-borda flex flex-col gap-3">
            <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Escopo</span>
            <div className="flex flex-col gap-2.5 text-[13.5px] text-tinta">
              <label className="flex items-center justify-between">
                Raiz
                <select className="p-1.5 border border-borda2 rounded-md bg-card text-[12.5px] text-tinta2 outline-none">
                  <option>Antônio Silva</option>
                </select>
              </label>
              <label className="flex items-center justify-between">
                Gerações
                <select className="p-1.5 border border-borda2 rounded-md bg-card font-num text-[12.5px] text-tinta2 outline-none">
                  <option>todas (4)</option>
                </select>
              </label>
              <label className="flex items-center gap-2.5 mt-1 cursor-pointer">
                <input type="checkbox" defaultChecked className="accent-acento w-4 h-4 rounded border-borda2" />
                Incluir placeholders
              </label>
              <label className="flex items-center gap-2.5 cursor-pointer">
                <input type="checkbox" defaultChecked className="accent-acento w-4 h-4 rounded border-borda2" />
                Marcos de contexto nas fichas
              </label>
              <label className="flex items-center gap-2.5 cursor-pointer">
                <input type="checkbox" className="accent-acento w-4 h-4 rounded border-borda2" />
                Minibiografias completas
              </label>
            </div>
          </div>

          <div className="p-4 border-b border-borda flex flex-col gap-3">
            <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Privacidade</span>
            <div className="flex items-center justify-between p-3 border border-borda rounded-raio-s bg-card">
              <div className="flex flex-col gap-1">
                <span className="text-[13.5px] text-tinta">Ocultar dados de vivos</span>
                <span className="text-xs text-tinta3">só nome e ano de nascimento</span>
              </div>
              <button 
                onClick={() => setHideLiving(!hideLiving)}
                className={`touch-manipulation w-9 h-5 rounded-full relative transition-colors ${hideLiving ? 'bg-acento' : 'bg-chip border border-borda2'}`}
              >
                <span className={`absolute top-0.5 w-4 h-4 rounded-full transition-transform ${hideLiving ? 'right-0.5 bg-acento-tinta' : 'left-0.5 bg-tinta3'}`}></span>
              </button>
            </div>
          </div>

          <div className="p-4 flex flex-col gap-2.5 mt-auto">
            <button className="touch-manipulation p-3 rounded-raio-s border border-acento bg-acento text-acento-tinta font-corpo text-sm font-fw6">
              Exportar PDF
            </button>
            <button className="touch-manipulation p-3 rounded-raio-s border border-borda2 bg-card text-tinta font-corpo text-sm">
              Imprimir...
            </button>
            <span className="text-[12.5px] text-tinta3 leading-relaxed mt-1">
              A4 retrato · margens de 18 mm · o diagrama quebra por ramo, nunca no meio de um card[cite: 2].
            </span>
          </div>
        </div>

        {/* COLUNA DIREITA: Pré-visualização do PDF */}
        <div className="flex-1 flex flex-col min-w-0 bg-mesa overflow-hidden">
          
          <div className="h-[52px] border-b border-borda bg-bg flex items-center justify-between px-6 flex-none shadow-sm z-10">
            <span className="text-[13.5px] text-tinta2">Pré-visualização · modo combinado · <span className="font-num">11 páginas</span></span>
            <div className="flex items-center gap-2.5">
              <span className="font-num text-[12.5px] text-tinta3">página 1 e 3 de 11</span>
              <div className="flex items-center border border-borda rounded-full bg-card overflow-hidden">
                <button className="touch-manipulation px-3 py-1.5 text-[13px] text-tinta2 hover:bg-card2">−</button>
                <span className="px-2 font-num text-[12px] text-tinta border-l border-r border-borda">55%</span>
                <button className="touch-manipulation px-3 py-1.5 text-[13px] text-tinta2 hover:bg-card2">＋</button>
              </div>
            </div>
          </div>

          {/* Área de Visualização (Scroll isolado) */}
          <div className="flex-1 overflow-y-auto p-6 flex flex-wrap justify-center gap-7 items-start">
            
            {/* Mockup da Folha 1 (O Diagrama de Hierarquia) */}
            <div 
              className="w-[436px] h-[616px] flex-none bg-[#fdfcf8] border border-[#cfc7b4] shadow-[0_8px_28px_rgba(0,0,0,.22)] p-8 flex flex-col"
              style={{ fontFamily: "'Libre Baskerville', Georgia, serif", color: "#2b2318" }}
            >
              <div className="flex items-baseline justify-between border-b border-[#d9d1bf] pb-2">
                <span style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="text-[9px] tracking-[0.14em] uppercase text-[#8a7f6a]">
                  Acervo Familiar · Silva · Campos
                </span>
                <span style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="text-[9px] text-[#8a7f6a]">1 / 11</span>
              </div>
              
              <div className="flex flex-col gap-1 mt-4">
                <span className="text-[17px] font-fw7 leading-tight">Descendência de Antônio Silva</span>
                <span style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="text-[10px] text-[#6d6252]">4 gerações · 20 pessoas · levantamento atual</span>
              </div>

              {/* Renderização Simplificada do Grafo Print-Friendly */}
              <div className="relative h-[398px] mt-4 text-[9px] font-fw7">
                {/* Linhas ortogonais SVG ou CSS */}
                <div className="absolute left-[110px] top-0 w-[120px] h-4 border-t-2 border-r-2 border-[#a89a80] rounded-tr"></div>
                <div className="absolute left-[230px] top-4 w-4 h-4 rounded-full bg-[#8a7654] -translate-x-1/2 -translate-y-1/2"></div>
                
                {/* Node: Pai */}
                <div className="absolute left-[20px] top-[10px] w-[96px] p-1.5 border border-[#b9ab91] border-l-4 border-l-[#3c5a78] bg-white">
                  Antônio Silva
                  <div style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="text-[7.5px] text-[#6d6252] font-normal">1918–1994</div>
                </div>
                
                {/* Node: Mãe */}
                <div className="absolute left-[160px] top-[10px] w-[96px] p-1.5 border border-[#b9ab91] border-l-4 border-l-[#8f3f4e] bg-white">
                  Maria Ferreira
                  <div style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="text-[7.5px] text-[#6d6252] font-normal">1921–2003</div>
                </div>

                {/* Node: Filho */}
                <div className="absolute left-[90px] top-[70px] w-[96px] p-1.5 border border-[#b9ab91] border-l-4 border-l-[#3c5a78] bg-white">
                  José Silva
                  <div style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="text-[7.5px] text-[#6d6252] font-normal">1945–2012</div>
                </div>
              </div>

              <div className="mt-auto flex items-center justify-between border-t border-[#d9d1bf] pt-2 text-[8px] text-[#8a7f6a]" style={{ fontFamily: "'Source Serif 4', Georgia, serif" }}>
                <span>⚭ casamento · ⚯ união estável · ⚮ dissolvida · tracejado: sem registro[cite: 2]</span>
                <span>gerado localmente</span>
              </div>
            </div>

            {/* Mockup da Folha 3 (Fichas em Texto) */}
            <div 
              className="w-[436px] h-[616px] flex-none bg-[#fdfcf8] border border-[#cfc7b4] shadow-[0_8px_28px_rgba(0,0,0,.22)] p-8 flex flex-col"
              style={{ fontFamily: "'Libre Baskerville', Georgia, serif", color: "#2b2318" }}
            >
              <div className="flex items-baseline justify-between border-b border-[#d9d1bf] pb-2">
                <span style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="text-[9px] tracking-[0.14em] uppercase text-[#8a7f6a]">
                  Fichas individuais · geração II
                </span>
                <span style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="text-[9px] text-[#8a7f6a]">3 / 11</span>
              </div>

              <div className="flex flex-col gap-2.5 mt-4">
                <div className="flex items-baseline gap-2">
                  <span style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="text-[9px] text-[#8a7f6a]">II.1</span>
                  <span className="text-[15px] font-fw7 leading-tight">José <span className="uppercase tracking-[0.04em]">Silva</span></span>
                </div>
                
                <div style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="grid grid-cols-[66px_1fr] gap-x-2.5 gap-y-1 text-[9.5px] leading-relaxed">
                  <span className="text-[#8a7f6a]">Nascimento</span><span>12 de março de 1945 · Campos dos Goytacazes, RJ</span>
                  <span className="text-[#8a7f6a]">Batismo</span><span>c. 1945 · Igreja de São Salvador, católica</span>
                  <span className="text-[#8a7f6a]">União</span><span>⚭ 1967 · com <i className="text-[#6d6252]">Desconhecida</i> · 2 filhos</span>
                  <span className="text-[#8a7f6a]">Falecimento</span><span>agosto de 2012 · Macaé, RJ · aos 67 anos</span>
                  <span className="text-[#8a7f6a]">Pais</span><span>Antônio Silva e Maria Ferreira</span>
                  <span className="text-[#8a7f6a]">Filhos</span><span>Gabriel Silva (1968) · Marta Silva (c. 1971, adotada)</span>
                  <span className="text-[#8a7f6a]">Religião</span><span>católica 1945–1979 · espírita 1979–2012</span>
                </div>

                <p style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="m-0 mt-1 text-[9.5px] leading-relaxed text-[#3d3529] text-pretty">
                  Nasceu na zona rural de Campos, filho mais velho de Antônio e Maria. Trabalhou na usina até se mudar para Macaé no começo dos anos 1970, quando passou a atuar como contador.
                </p>

                <div className="p-2 bg-[#f6f2e8] border-l-2 border-[#b9ab91] flex flex-col gap-1 mt-1">
                  <span style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="text-[8px] tracking-[0.1em] uppercase text-[#8a7f6a]">A vida no contexto</span>
                  <span style={{ fontFamily: "'Source Serif 4', Georgia, serif" }} className="text-[9px] leading-relaxed text-[#3d3529]">
                    15 anos na inauguração de Brasília · 19 no golpe militar de 1964 · 49 no Plano Real.
                  </span>
                </div>
              </div>

              <div className="mt-auto flex items-center justify-between border-t border-[#d9d1bf] pt-2 text-[8px] text-[#8a7f6a]" style={{ fontFamily: "'Source Serif 4', Georgia, serif" }}>
                <span>Ausência de dado é registrada como “sem registro”, nunca como campo vazio[cite: 2]</span>
                <span>gerado localmente</span>
              </div>
            </div>

          </div>
        </div>
      </div>
    </div>
  );
}