/**
 * PROTÓTIPO VISUAL — não ligado ao banco.
 *
 * Editor de união. Implementa o desenho da seções 2.2 e 3 — os dois slots e o placeholder, com dados fixos
 * escritos no próprio componente. Nenhum dado real passa por aqui ainda: é a
 * maquete aprovada do layout, guardada no código para não se perder e para
 * continuar sendo verificada pelo TypeScript.
 *
 * Previsto para: MVP (item 2).
 *
 * Ao ligar de verdade: trocar os valores fixos por `useQuery` sobre os
 * comandos de `src/lib/api`, e apagar este aviso.
 */
import { useState } from 'react';

// Tipagem simplificada para o exemplo
type UnionState = 'casamento' | 'estavel' | 'dissolvida' | 'nao_informado';

interface UnionEditorProps {
  unionId?: string;
  maleSlot: { id: string; nome: string; isPlaceholder: boolean };
  femaleSlot: { id: string; nome: string; isPlaceholder: boolean };
}

export function UnionEditor({ maleSlot, femaleSlot }: UnionEditorProps) {
  const [estadoVinculo, setEstadoVinculo] = useState<UnionState>('nao_informado');

  return (
    <div className="flex flex-col gap-6 w-full max-w-4xl mx-auto p-4 md:p-8">
      
      {/* Cabeçalho da União */}
      <div className="flex flex-col md:flex-row md:items-start justify-between gap-6">
        <div className="flex flex-col gap-1.5">
          <span className="font-num text-xs tracking-[0.14em] uppercase text-tinta3">Editor de União</span>
          <h3 className="m-0 font-tit font-fw7 text-2xl tracking-tit text-tinta">
            {maleSlot.isPlaceholder ? 'Desconhecido' : maleSlot.nome} <span className="text-tinta3 font-normal">e</span> {femaleSlot.isPlaceholder ? 'Desconhecida' : femaleSlot.nome}
          </h3>
        </div>
        <button className="touch-manipulation px-4 py-2.5 rounded-raio-s border border-acento bg-acento text-acento-tinta font-corpo text-sm font-fw6 self-start">
          Salvar união
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 items-start">
        
        {/* Coluna Principal: Slots e Estado */}
        <div className="lg:col-span-2 flex flex-col gap-6">
          
          {/* Os Dois Slots da União */}
          <section className="flex flex-col gap-3">
            <span className="font-num text-xs tracking-[0.14em] uppercase text-tinta3">Os dois slots</span>
            
            <div className="grid grid-cols-[1fr_60px_1fr] items-center gap-0">
              {/* Slot Masculino */}
              <div className={`flex items-center gap-3 p-3 rounded-raio border ${maleSlot.isPlaceholder ? 'bg-card2 border-dashed border-borda2' : 'bg-card border-borda2 shadow-sombra'}`}>
                <div className={`w-1 h-11 rounded-sm ${maleSlot.isPlaceholder ? 'bg-masc/60' : 'bg-masc'} flex-none`}></div>
                <div className="flex flex-col gap-0.5 flex-1 min-w-0">
                  <span className={`font-tit font-fw7 text-base tracking-tit ${maleSlot.isPlaceholder ? 'text-tinta2' : 'text-tinta'}`}>
                    {maleSlot.isPlaceholder ? 'Desconhecido' : maleSlot.nome}
                  </span>
                  <span className="font-num text-xs text-tinta3">slot masculino {maleSlot.isPlaceholder && '· placeholder'}</span>
                </div>
                {maleSlot.isPlaceholder && (
                  <button className="touch-manipulation text-xs font-fw6 text-acento px-2 py-1 border border-acento rounded-md">Identificar</button>
                )}
              </div>

              {/* Marcador Central (Anel) */}
              <div className="flex justify-center">
                <span className="w-8 h-8 rounded-full border-2 border-anel bg-anel block"></span>
              </div>

              {/* Slot Feminino */}
              <div className={`flex items-center gap-3 p-3 rounded-raio border ${femaleSlot.isPlaceholder ? 'bg-card2 border-dashed border-borda2' : 'bg-card border-borda2 shadow-sombra'}`}>
                <div className={`w-1 h-11 rounded-sm ${femaleSlot.isPlaceholder ? 'bg-fem/60' : 'bg-fem'} flex-none`}></div>
                <div className="flex flex-col gap-0.5 flex-1 min-w-0">
                  <span className={`font-tit font-fw7 text-base tracking-tit ${femaleSlot.isPlaceholder ? 'text-tinta2' : 'text-tinta'}`}>
                    {femaleSlot.isPlaceholder ? 'Desconhecida' : femaleSlot.nome}
                  </span>
                  <span className="font-num text-xs text-tinta3">slot feminino {femaleSlot.isPlaceholder && '· placeholder'}</span>
                </div>
                {femaleSlot.isPlaceholder && (
                  <button className="touch-manipulation text-xs font-fw6 text-acento px-2 py-1 border border-acento rounded-md">Identificar</button>
                )}
              </div>
            </div>
            <p className="text-xs text-tinta3 leading-relaxed mt-1">
              O slot nunca fica vazio no banco: sem nome, ele guarda um placeholder com sexo definido — e ao ser identificado, os filhos permanecem pendurados nele.
            </p>
          </section>

          {/* Estado do Vínculo */}
          <section className="flex flex-col gap-3">
            <span className="font-num text-xs tracking-[0.14em] uppercase text-tinta3">Estado do vínculo</span>
            
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
              {[
                { id: 'casamento', label: 'Casamento', desc: '⚭ · MARR' },
                { id: 'estavel', label: 'União estável', desc: '⚯ · sem MARR' },
                { id: 'dissolvida', label: 'Dissolvida', desc: '⚮ · DIV' },
                { id: 'nao_informado', label: 'Só parental', desc: 'não informado' }
              ].map((estado) => (
                <button
                  key={estado.id}
                  type="button"
                  onClick={() => setEstadoVinculo(estado.id as UnionState)}
                  className={`touch-manipulation flex flex-col gap-2 p-3 text-left border rounded-raio-s transition-all ${
                    estadoVinculo === estado.id 
                      ? 'border-2 border-acento bg-card' 
                      : 'border border-borda bg-card hover:border-borda2'
                  }`}
                >
                  <span className="text-sm font-fw6 text-tinta">{estado.label}</span>
                  <span className="font-num text-xs text-tinta3">{estado.desc}</span>
                </button>
              ))}
            </div>
          </section>

        </div>

        {/* Coluna Lateral: Filhos e Validações */}
        <div className="flex flex-col gap-6 p-6 border border-borda rounded-raio bg-card2">
          <section className="flex flex-col gap-3">
            <span className="font-num text-xs tracking-[0.14em] uppercase text-tinta3">Filhos ancorados</span>
            <div className="flex flex-col gap-2">
               {/* Exemplo de lista de filhos */}
               <div className="flex items-center gap-3 p-2 bg-card border border-borda rounded-md">
                 <span className="w-1 h-5 rounded-sm bg-masc block"></span>
                 <span className="text-sm text-tinta flex-1">Gabriel Silva</span>
                 <span className="text-xs text-tinta2 border border-borda2 px-2 py-1 rounded-md bg-bg">biológico ▾</span>
               </div>
            </div>
            <button className="touch-manipulation text-sm text-acento font-fw6 text-left mt-2">
              ＋ Adicionar filho
            </button>
          </section>

          <hr className="border-t border-borda" />

          <section className="flex flex-col gap-3">
            <span className="font-num text-xs tracking-[0.14em] uppercase text-tinta3">Invariantes verificadas</span>
            <div className="flex flex-col gap-2 text-xs text-tinta2 leading-relaxed">
              <span className="flex gap-2"><span className="text-masc">✓</span> Exatamente um slot masculino e um feminino</span>
              <span className="flex gap-2"><span className="text-masc">✓</span> Filhos pertencem a uma única união</span>
            </div>
          </section>
        </div>

      </div>
    </div>
  );
}