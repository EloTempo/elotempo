import { User, FileText, Image as ImageIcon, Book, Info } from 'lucide-react';
import type { PersonNode } from '../../types';
import { cn } from '../ui/Button';

interface NodeCardProps {
  person: PersonNode;
  onDetailsClick?: (id: string) => void;
  hasDocuments?: boolean;
  hasReligion?: boolean;
  hasBio?: boolean;
}

export function NodeCard({ person, onDetailsClick, hasDocuments, hasReligion, hasBio }: NodeCardProps) {
  if (person.is_placeholder) {
    return (
      <div className="w-64 h-24 rounded-raio border-2 border-dashed border-borda2 bg-card/50 flex items-center justify-center p-3 shadow-sm">
        <span className="text-tinta2 italic text-sm">Adicionar Ancestral</span>
      </div>
    );
  }

  // Cor do ponto de sexo
  const sexColor = person.sexo === 'M' ? 'bg-masc' : person.sexo === 'F' ? 'bg-fem' : 'bg-tinta3';

  return (
    <div className="w-64 bg-card rounded-raio border border-borda shadow-sombra overflow-hidden flex flex-col node-card">
      <div className="flex p-3 gap-3">
        {/* Mininatura */}
        <div className="w-12 h-12 rounded-raio-s bg-chip flex-shrink-0 flex items-center justify-center overflow-hidden border border-borda2">
          {/* Se houvesse foto seria um <img src={person.foto_url} /> */}
          <User className="w-6 h-6 text-tinta3" />
        </div>

        {/* Info principal */}
        <div className="flex flex-col flex-1 min-w-0">
          <div className="flex items-center gap-1.5 mb-0.5">
            <span className={cn("w-2 h-2 rounded-full flex-shrink-0", sexColor)} />
            <h3 className="font-tit text-sm font-bold truncate leading-tight">
              {person.nome} {person.sobrenome}
            </h3>
          </div>
          
          <div className="text-xs text-tinta2 flex flex-col gap-0.5">
            {person.ano_nascimento && (
              <span className="truncate">n. {person.ano_nascimento}</span>
            )}
            {!person.is_vivo && (
              <span className="truncate">† Falecido</span>
            )}
          </div>
        </div>
      </div>

      {/* Rodapé: Ícones de presença e botão detalhes */}
      <div className="bg-card2 px-3 py-2 border-t border-borda flex items-center justify-between">
        <div className="flex gap-1.5 text-tinta3">
          <span title="Possui foto"><ImageIcon className="w-3.5 h-3.5" /></span>
          {hasDocuments && <span title="Possui documentos anexos"><FileText className="w-3.5 h-3.5" /></span>}
          {hasReligion && <span title="Registro religioso"><Book className="w-3.5 h-3.5" /></span>}
          {hasBio && <span title="Minibiografia"><Info className="w-3.5 h-3.5" /></span>}
        </div>
        
        <button 
          onClick={() => onDetailsClick?.(person.id)}
          className="text-xs font-semibold text-acento hover:text-tinta transition-colors bg-transparent border-none cursor-pointer"
        >
          Detalhes
        </button>
      </div>
    </div>
  );
}
