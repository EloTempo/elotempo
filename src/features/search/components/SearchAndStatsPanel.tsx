// src/features/search/components/SearchAndStatsPanel.tsx
import { useState } from 'react';

interface SearchAndStatsPanelProps {
  onClose: () => void;
}

export function SearchAndStatsPanel({ onClose }: SearchAndStatsPanelProps) {
  const [searchTerm, setSearchTerm] = useState('Silva');
  const [sexFilter, setSexFilter] = useState('todos');
  
  return (
    <div className="flex flex-col w-full h-full bg-bg absolute inset-0 z-40">
      
      {/* Cabeçalho do Painel */}
      <div className="h-[38px] flex items-stretch justify-between bg-sup border-b border-borda flex-none">
        <div className="flex items-center gap-3 pl-3.5">
          <span className="w-4 h-4 rounded-[3px] bg-acento block"></span>
          <span className="text-[13px] text-tinta2">Pesquisa — Acervo Familiar</span>
        </div>
        <button onClick={onClose} className="touch-manipulation w-[46px] grid place-items-center text-[13px] text-tinta2 hover:bg-card">
          ✕
        </button>
      </div>

      <div className="flex flex-1 min-h-0">
        
        {/* COLUNA 1: Filtros (Esquerda) */}
        <div className="w-[292px] border-r border-borda bg-sup flex flex-col flex-none overflow-y-auto min-h-0">
          <div className="p-4 border-b border-borda flex flex-col gap-3 flex-none">
            <div className="flex items-baseline justify-between">
              <span className="font-tit font-fw7 text-[17px] tracking-tit text-tinta">Critérios</span>
              <button className="touch-manipulation text-[12.5px] text-acento font-fw6">limpar</button>
            </div>
            <div className="flex items-center gap-2 p-2 border border-borda2 rounded-full bg-card">
              <span className="text-[13px] text-tinta3 pl-2">⌕</span>
              <input 
                type="text" 
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="bg-transparent border-none outline-none text-base text-tinta w-full"
                placeholder="nome, sobrenome..."
              />
            </div>
          </div>

          <div className="p-4 border-b border-borda flex flex-col gap-2.5">
            <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Período de nascimento</span>
            <div className="grid grid-cols-[1fr_14px_1fr] gap-2 items-center">
              <input type="text" defaultValue="1940" className="p-2 border border-borda2 rounded-raio-s bg-card font-num text-[13px] text-tinta text-center w-full focus:border-acento outline-none" />
              <span className="text-xs text-tinta3 text-center">–</span>
              <input type="text" defaultValue="1980" className="p-2 border border-borda2 rounded-raio-s bg-card font-num text-[13px] text-tinta text-center w-full focus:border-acento outline-none" />
            </div>
          </div>

          <div className="p-4 border-b border-borda flex flex-col gap-2.5">
            <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Local (nasc. ou óbito)</span>
            <div className="flex gap-2 flex-wrap items-center p-2 border border-borda2 rounded-raio-s bg-card">
              <span className="text-[12.5px] px-2.5 py-1 rounded-full bg-acento text-acento-tinta flex items-center gap-1 cursor-pointer">Campos ✕</span>
              <span className="text-[12.5px] px-2.5 py-1 rounded-full bg-acento text-acento-tinta flex items-center gap-1 cursor-pointer">Macaé ✕</span>
              <span className="text-[13px] text-tinta3 px-2">＋</span>
            </div>
          </div>

          <div className="p-4 border-b border-borda flex flex-col gap-2.5">
            <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Sexo</span>
            <div className="flex border border-borda2 rounded-raio-s overflow-hidden bg-card">
              {['todos', 'M', 'F', 'X/U'].map(s => (
                <button 
                  key={s}
                  onClick={() => setSexFilter(s)}
                  className={`touch-manipulation flex-1 py-2 text-center font-num text-[12.5px] ${sexFilter === s ? 'bg-acento text-acento-tinta font-fw6' : 'text-tinta2 border-l border-borda first:border-l-0'}`}
                >
                  {s}
                </button>
              ))}
            </div>
          </div>

          <div className="p-4 border-b border-borda flex flex-col gap-2.5">
            <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Atributos</span>
            <div className="flex flex-col gap-2">
              <div className="flex justify-between items-center text-[13.5px] text-tinta">
                Religião <select className="px-2 py-1 border border-borda2 rounded-md bg-card text-[12.5px] text-tinta2 outline-none"><option>qualquer</option></select>
              </div>
              <div className="flex justify-between items-center text-[13.5px] text-tinta">
                Escolaridade <select className="px-2 py-1 border border-acento rounded-md bg-card text-[12.5px] text-tinta outline-none"><option>médio ou +</option></select>
              </div>
            </div>
          </div>

          <div className="p-4 flex flex-col gap-2.5 mt-auto border-t border-borda bg-sup">
            <span className="text-[12.5px] text-tinta2 leading-relaxed">Critérios combinam por <span className="font-num text-tinta font-fw6">E</span>. Salve a combinação como consulta nomeada.</span>
            <button className="touch-manipulation text-[12.5px] text-acento font-fw6 text-left">Salvar consulta</button>
          </div>
        </div>

        {/* COLUNA 2: Lista de Resultados (Centro) */}
        <div className="flex-1 flex flex-col min-w-0 bg-bg">
          <div className="h-[64px] border-b border-borda flex items-center justify-between px-6 flex-none">
            <div className="flex items-baseline gap-3">
              <span className="font-tit font-fw7 text-[22px] tracking-tit text-tinta">12 pessoas</span>
              <span className="text-[13.5px] text-tinta2">de 20 no acervo · 4 critérios ativos</span>
            </div>
            <div className="flex items-center gap-2">
              <button className="touch-manipulation text-[12.5px] px-3 py-1.5 rounded-full bg-card border border-borda text-tinta2 hover:border-tinta transition-colors">Ordenar: nascimento ▾</button>
              <button className="touch-manipulation text-[12.5px] px-3 py-1.5 rounded-full bg-card border border-borda text-tinta2 hover:border-tinta transition-colors">Destacar na árvore</button>
            </div>
          </div>

          <div className="flex-1 flex flex-col min-w-0 overflow-y-auto">
            {/* Títulos das colunas */}
            <div className="grid grid-cols-[1.5fr_90px_1.1fr_1.2fr_1fr] gap-3.5 px-6 py-3 border-b border-borda bg-sup flex-none">
              <span className="font-num text-[10.5px] tracking-[0.1em] uppercase text-tinta3">Pessoa</span>
              <span className="font-num text-[10.5px] tracking-[0.1em] uppercase text-tinta3">Nasc.</span>
              <span className="font-num text-[10.5px] tracking-[0.1em] uppercase text-tinta3">Local</span>
              <span className="font-num text-[10.5px] tracking-[0.1em] uppercase text-tinta3">Escolaridade</span>
              <span className="font-num text-[10.5px] tracking-[0.1em] uppercase text-tinta3">Profissão</span>
            </div>

            {/* Itens (Mockados para exibir o design system) */}
            {[
              { nome: "José Silva", masc: true, nasc: "1945", local: "Campos", esc: "Técnico", prof: "Contador" },
              { nome: "Ana Silva", masc: false, nasc: "1948", local: "Campos", esc: "Médio", prof: "Professora" },
              { nome: "Gabriel Silva", masc: true, nasc: "1968", local: "Campos", esc: "Superior", prof: "Professor" },
            ].map((d, i) => (
              <div key={i} className="grid grid-cols-[1.5fr_90px_1.1fr_1.2fr_1fr] gap-3.5 px-6 py-3.5 border-b border-borda hover:bg-card cursor-pointer items-center transition-colors">
                <span className="flex items-center gap-2.5 min-w-0">
                  <span className={`w-[3px] h-[22px] rounded-[2px] ${d.masc ? 'bg-masc' : 'bg-fem'} flex-none block`}></span>
                  <span className="text-[14.5px] text-tinta truncate">{d.nome}</span>
                </span>
                <span className="font-num text-[13px] text-tinta2">{d.nasc}</span>
                <span className="text-[13.5px] text-tinta2 truncate">{d.local}</span>
                <span className="text-[13.5px] text-tinta2 truncate">{d.esc}</span>
                <span className="text-[13.5px] text-tinta2 truncate">{d.prof}</span>
              </div>
            ))}
            
            {/* Item Placeholder / Ausente */}
            <div className="grid grid-cols-[1.5fr_90px_1.1fr_1.2fr_1fr] gap-3.5 px-6 py-3.5 border-b border-borda items-center opacity-60">
              <span className="flex items-center gap-2.5 min-w-0">
                <span className="w-[3px] h-[22px] rounded-[2px] bg-fem opacity-60 flex-none block"></span>
                <span className="text-[14.5px] text-tinta2 italic truncate">Desconhecida</span>
              </span>
              <span className="font-num text-[13px] text-tinta3">c. 1947</span>
              <span className="text-[13.5px] text-tinta3">Campos</span>
              <span className="text-[13.5px] text-tinta3 italic">sem registro</span>
              <span className="text-[13.5px] text-tinta3 italic">sem registro</span>
            </div>
          </div>
        </div>

        {/* COLUNA 3: Estatísticas (Direita) */}
        <div className="w-[392px] bg-sup flex flex-col border-l border-borda flex-none overflow-y-auto min-h-0">
          
          <div className="p-4 md:p-5 border-b border-borda flex flex-col gap-1 flex-none">
            <span className="font-tit font-fw7 text-[17px] tracking-tit text-tinta">Estatísticas do recorte</span>
            <span className="text-[12.5px] text-tinta3">base: as 12 pessoas filtradas</span>
          </div>

          {/* Gráfico de Sexo (Rosca com CSS) */}
          <div className="p-4 md:p-5 border-b border-borda flex flex-col gap-3.5">
            <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Sexo</span>
            <div className="flex items-center gap-5">
              {/* O conic-gradient divide a proporção 58.3% (M) e 41.7% (F) */}
              <div 
                className="w-[104px] h-[104px] rounded-full flex-none grid place-items-center shadow-sm"
                style={{ background: 'conic-gradient(var(--masc) 0 58.3%, var(--fem) 58.3% 100%)' }}
              >
                <div className="w-[52px] h-[52px] rounded-full bg-sup grid place-items-center font-num text-[15px] text-tinta font-fw6">
                  12
                </div>
              </div>
              <div className="flex flex-col gap-2.5 flex-1 min-w-0">
                <span className="flex items-center gap-2.5 text-[13.5px] text-tinta2">
                  <span className="w-3 h-3 rounded-[3px] bg-masc flex-none block"></span>
                  masculino <span className="ml-auto font-num text-tinta">7 · 58%</span>
                </span>
                <span className="flex items-center gap-2.5 text-[13.5px] text-tinta2">
                  <span className="w-3 h-3 rounded-[3px] bg-fem flex-none block"></span>
                  feminino <span className="ml-auto font-num text-tinta">5 · 42%</span>
                </span>
              </div>
            </div>
          </div>

          {/* Gráfico de Barras: Escolaridade */}
          <div className="p-4 md:p-5 border-b border-borda flex flex-col gap-3">
            <div className="flex items-baseline justify-between">
              <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Escolaridade</span>
              <span className="font-num text-[10.5px] text-tinta3">11 com registro</span>
            </div>
            <div className="flex flex-col gap-2.5">
              {[
                { label: 'Superior', count: '5', pct: '45%' },
                { label: 'Médio', count: '4', pct: '36%' },
                { label: 'Técnico', count: '2', pct: '18%' }
              ].map(d => (
                <div key={d.label} className="flex flex-col gap-1.5">
                  <span className="flex justify-between text-[13px] text-tinta2">
                    {d.label} <span className="font-num text-tinta">{d.count} · {d.pct}</span>
                  </span>
                  <div className="h-[9px] rounded-full bg-chip overflow-hidden">
                    <div className="h-full bg-acento" style={{ width: d.pct }}></div>
                  </div>
                </div>
              ))}
              <div className="flex flex-col gap-1.5 mt-1">
                <span className="flex justify-between text-[13px] text-tinta3">
                  Sem registro <span className="font-num">1</span>
                </span>
                <div className="h-[9px] rounded-full bg-chip overflow-hidden">
                  <div className="h-full bg-tinta3 opacity-60" style={{ width: '8%' }}></div>
                </div>
              </div>
            </div>
          </div>

          {/* Longevidade (Média sem registro de datas vazias) */}
          <div className="p-4 md:p-5 flex flex-col gap-3">
            <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Longevidade</span>
            <div className="grid grid-cols-2 gap-3">
              <div className="p-3 border border-borda rounded-raio-s bg-card flex flex-col gap-1">
                <span className="font-num text-[22px] text-tinta">71</span>
                <span className="text-xs text-tinta2 leading-snug">idade média ao falecer · 4 pessoas</span>
              </div>
              <div className="p-3 border border-borda rounded-raio-s bg-card flex flex-col gap-1">
                <span className="font-num text-[22px] text-tinta">8</span>
                <span className="text-xs text-tinta2 leading-snug">vivas no recorte</span>
              </div>
            </div>
            <p className="m-0 text-[12.5px] text-tinta3 leading-relaxed mt-2 text-pretty">
              Médias ignoram datas ausentes e informam a base. Nenhum gráfico esconde o “sem registro” — ele é uma fatia como as outras.
            </p>
          </div>

        </div>
      </div>
    </div>
  );
}