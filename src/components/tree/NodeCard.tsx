/**
 * O nó da árvore (seção 10).
 *
 * Miniatura à esquerda, faixa de sexo antes do nome, dados-chave numa linha
 * (`n.` nascimento, `†` falecimento) e a fileira de ícones de presença, que
 * mostram o que existe de informação sem obrigar a abrir os detalhes.
 */

import { User, FileText, Image as ImageIcon, Book, Info } from 'lucide-react';
import type { PersonNode } from '../../types';
import { cn } from '../ui/Button';

interface NodeCardProps {
  person: PersonNode;
  selecionado?: boolean;
  onClick?: () => void;
  onDetalhes?: () => void;
}

function faixaDeSexo(sexo: string): string {
  if (sexo === 'M') return 'bg-masc';
  if (sexo === 'F') return 'bg-fem';
  if (sexo === 'X') return 'bg-gradient-to-b from-masc to-fem';
  return 'bg-tinta3';
}

export function NodeCard({ person, selecionado, onClick, onDetalhes }: NodeCardProps) {
  const nomeCompleto = [person.nome, person.sobrenome].filter(Boolean).join(' ');

  // Placeholder: borda tracejada e identidade em aberto. Continua clicável —
  // é assim que se promove o nó a ancestral real quando o nome aparece.
  if (person.is_placeholder) {
    return (
      <button
        type="button"
        onClick={onClick}
        className={cn(
          'w-full h-full rounded-raio border-2 border-dashed border-borda2 bg-card/50',
          'flex flex-col items-center justify-center gap-0.5 px-3 cursor-pointer',
          'hover:border-acento hover:bg-card transition-colors text-center',
          selecionado && 'border-acento ring-2 ring-acento/40',
        )}
        title="Ancestral desconhecido — clique para dar um nome"
      >
        <span className="text-tinta2 italic text-[13px] leading-tight truncate w-full">
          {person.sexo === 'F' ? 'Desconhecida' : 'Desconhecido'}
        </span>
        <span className="text-tinta3 text-[10.5px] detail-text">clique para identificar</span>
      </button>
    );
  }

  return (
    <div
      onClick={onClick}
      className={cn(
        'w-full h-full bg-card rounded-raio border border-borda shadow-sombra',
        'flex items-stretch overflow-hidden cursor-pointer node-card node-content',
        'hover:border-borda2 transition-colors',
        selecionado && 'border-acento ring-2 ring-acento/40',
      )}
    >
      <div className={cn('w-1.5 flex-none', faixaDeSexo(person.sexo))} aria-hidden />

      <div className="flex items-center gap-2.5 px-2.5 py-2 min-w-0 flex-1">
        <div className="w-10 h-10 rounded-raio-s bg-chip flex-none grid place-items-center overflow-hidden border border-borda2 detail-text">
          {person.tem_foto ? (
            <ImageIcon className="w-4 h-4 text-tinta3" />
          ) : (
            <User className="w-4 h-4 text-tinta3" />
          )}
        </div>

        <div className="flex flex-col min-w-0 flex-1 gap-0.5">
          <span className="font-tit font-bold text-[13.5px] text-tinta truncate leading-tight">
            {nomeCompleto}
          </span>

          <span className="font-num text-[11px] text-tinta2 truncate detail-text">
            {person.ano_nascimento ? `n. ${person.ano_nascimento}` : 'n. s/d'}
            {person.ano_falecimento ? ` · † ${person.ano_falecimento}` : ''}
            {!person.ano_falecimento && !person.is_vivo ? ' · †' : ''}
          </span>

          {/* Ícones de presença: só aparecem quando há o que indicar. */}
          <div className="flex gap-1 text-tinta3 detail-text">
            {person.tem_documentos && (
              <span title="Documentos anexos">
                <FileText className="w-3 h-3" />
              </span>
            )}
            {person.tem_religiao && (
              <span title="Registro religioso">
                <Book className="w-3 h-3" />
              </span>
            )}
            {person.tem_biografia && (
              <span title="Minibiografia">
                <Info className="w-3 h-3" />
              </span>
            )}
          </div>
        </div>

        {onDetalhes && (
          <button
            type="button"
            onClick={(e) => {
              e.stopPropagation();
              onDetalhes();
            }}
            className="text-[11px] font-semibold text-acento hover:text-tinta transition-colors bg-transparent border-none cursor-pointer flex-none detail-text"
          >
            Detalhes
          </button>
        )}
      </div>
    </div>
  );
}
