import { ReactNode } from 'react';
import { X } from 'lucide-react';
import { cn } from './Button';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: ReactNode;
  className?: string;
}

export function Modal({ isOpen, onClose, title, children, className }: ModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm animate-in fade-in duration-200">
      <div 
        className={cn(
          "bg-card w-full max-w-lg rounded-raio shadow-sombra overflow-hidden border border-borda flex flex-col max-h-[90vh]",
          className
        )}
      >
        <div className="flex items-center justify-between p-4 border-b border-borda bg-card2">
          <h2 className="text-xl font-tit font-bold text-tinta">{title}</h2>
          <button 
            onClick={onClose}
            className="text-tinta2 hover:text-tinta transition-colors rounded-full p-1 hover:bg-sup"
          >
            <X className="w-5 h-5" />
          </button>
        </div>
        
        <div className="p-6 overflow-y-auto">
          {children}
        </div>
      </div>
    </div>
  );
}
