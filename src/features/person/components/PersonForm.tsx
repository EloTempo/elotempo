// src/features/person/components/PersonForm.tsx
import { useState } from 'react';
import type { Person, Sex } from '../../../types';

interface PersonFormProps {
  initialData?: Partial<Person>;
  onSave: (data: Partial<Person>) => void;
  onCancel: () => void;
}

export function PersonForm({ initialData, onSave, onCancel }: PersonFormProps) {
  const [nome, setNome] = useState(initialData?.nome || '');
  const [sobrenome, setSobrenome] = useState(initialData?.sobrenome || '');
  const [sexo, setSexo] = useState<Sex>(initialData?.sexo || 'M');
  const [isVivo, setIsVivo] = useState(initialData?.is_vivo ?? true);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSave({ nome, sobrenome, sexo, is_vivo: isVivo });
  };

  return (
    <form onSubmit={handleSubmit} className="flex flex-col w-full h-full bg-bg">
      {/* Cabeçalho */}
      <div className="flex items-center justify-between p-4 bg-sup border-b border-borda flex-none">
        <h2 className="font-tit font-fw7 text-xl text-tinta tracking-tit">
          Nova pessoa
        </h2>
        <button type="button" onClick={onCancel} className="touch-manipulation text-tinta2 text-lg">✕</button>
      </div>

      {/* Corpo do formulário com scroll */}
      <div className="flex-1 overflow-y-auto p-4 md:p-8 flex flex-col gap-6">
        
        {/* Seção: Identidade */}
        <section className="flex flex-col gap-4">
          <h3 className="font-tit font-fw7 text-lg tracking-tit text-tinta">Identidade</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <label className="flex flex-col gap-1.5">
              <span className="text-sm text-tinta2">Nome</span>
              <input 
                type="text" 
                required
                value={nome}
                onChange={(e) => setNome(e.target.value)}
                className="text-base p-2.5 border border-borda2 rounded-raio-s bg-card text-tinta w-full focus:outline-none focus:border-acento" 
              />
            </label>
            <label className="flex flex-col gap-1.5">
              <span className="text-sm text-tinta2">Sobrenome</span>
              <input 
                type="text" 
                value={sobrenome}
                onChange={(e) => setSobrenome(e.target.value)}
                className="text-base p-2.5 border border-borda2 rounded-raio-s bg-card text-tinta w-full focus:outline-none focus:border-acento" 
              />
            </label>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="flex flex-col gap-1.5">
              <span className="text-sm text-tinta2">Sexo</span>
              <div className="flex border border-borda2 rounded-raio-s overflow-hidden bg-card">
                {(['M', 'F', 'X', 'U'] as Sex[]).map((s) => (
                  <button
                    key={s}
                    type="button"
                    onClick={() => setSexo(s)}
                    className={`touch-manipulation flex-1 py-2 text-center font-num text-sm transition-colors ${
                      sexo === s 
                        ? s === 'M' ? 'bg-masc text-white' : s === 'F' ? 'bg-fem text-white' : 'bg-acento text-acento-tinta'
                        : 'text-tinta2 border-l border-borda first:border-l-0'
                    }`}
                  >
                    {s}
                  </button>
                ))}
              </div>
            </div>

            {/* Controle de Privacidade */}
            <div className="flex items-center justify-between p-3 border border-borda rounded-raio-s bg-card2">
              <div className="flex flex-col gap-1">
                <span className="text-sm text-tinta font-fw6">Pessoa viva</span>
                <span className="text-xs text-tinta3">Ocultável na exportação</span>
              </div>
              <button 
                type="button" 
                onClick={() => setIsVivo(!isVivo)}
                className={`touch-manipulation w-10 h-6 rounded-full relative transition-colors ${isVivo ? 'bg-acento' : 'bg-chip border border-borda2'}`}
              >
                <span className={`absolute top-1 w-4 h-4 rounded-full transition-transform ${isVivo ? 'right-1 bg-acento-tinta' : 'left-1 bg-tinta3'}`}></span>
              </button>
            </div>
          </div>
        </section>

        {/* Separador */}
        <hr className="border-t border-borda" />

        {/* Seção: Eventos de Vida (Exemplo de Flexibilidade) */}
        <section className="flex flex-col gap-4">
          <h3 className="font-tit font-fw7 text-lg tracking-tit text-tinta">Eventos de vida</h3>
          
          <div className="flex flex-col gap-3 p-4 border border-borda rounded-raio-s bg-card">
            <span className="text-sm font-fw6 text-tinta">Nascimento</span>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
              <select className="text-base p-2 border border-borda2 rounded-raio-s bg-bg text-tinta2 font-num">
                <option>exata</option>
                <option>cerca de</option>
                <option>antes de</option>
                <option>após</option>
              </select>
              <input 
                type="text" 
                placeholder="Ex: 1968 ou 12/03/1968"
                className="text-base p-2 border border-borda2 rounded-raio-s bg-bg text-tinta font-num md:col-span-2 focus:outline-none focus:border-acento" 
              />
            </div>
            <input 
              type="text" 
              placeholder="Local (ex: Campos dos Goytacazes, RJ)"
              className="text-base p-2 border border-acento rounded-raio-s bg-bg text-tinta mt-2 focus:outline-none focus:ring-1 focus:ring-acento" 
            />
            <span className="text-xs text-tinta3 mt-1 leading-relaxed">
              O local busca no IBGE, mas aceita texto livre para rótulos históricos. A data nunca bloqueia o salvamento.
            </span>
          </div>
        </section>

      </div>

      {/* Rodapé de Ações */}
      <div className="p-4 border-t border-borda bg-sup flex items-center justify-end gap-3 flex-none">
        <button 
          type="button" 
          onClick={onCancel}
          className="touch-manipulation px-4 py-2.5 rounded-raio-s border border-borda2 bg-card text-tinta font-corpo text-sm"
        >
          Cancelar
        </button>
        <button 
          type="submit" 
          className="touch-manipulation px-6 py-2.5 rounded-raio-s border border-acento bg-acento text-acento-tinta font-corpo text-sm font-fw6"
        >
          Salvar pessoa
        </button>
      </div>
    </form>
  );
}