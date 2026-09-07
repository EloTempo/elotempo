import { useEffect } from 'react';
import { CheckCircle2, RotateCcw, RotateCw, X } from 'lucide-react';

export interface ToastMensagem {
  id: string;
  tipo: 'desfazer' | 'refazer' | 'info';
  texto: string;
}

interface ToastNotificacaoProps {
  toasts: ToastMensagem[];
  onRemover: (id: string) => void;
}

export function ToastNotificacao({ toasts, onRemover }: ToastNotificacaoProps) {
  return (
    <div className="fixed bottom-6 right-6 z-50 flex flex-col gap-2 pointer-events-none">
      {toasts.map((t) => (
        <ToastItem key={t.id} toast={t} onRemover={onRemover} />
      ))}
    </div>
  );
}

function ToastItem({
  toast,
  onRemover,
}: {
  toast: ToastMensagem;
  onRemover: (id: string) => void;
}) {
  useEffect(() => {
    const timer = setTimeout(() => {
      onRemover(toast.id);
    }, 3200);
    return () => clearTimeout(timer);
  }, [toast.id, onRemover]);

  const Icone =
    toast.tipo === 'desfazer'
      ? RotateCcw
      : toast.tipo === 'refazer'
      ? RotateCw
      : CheckCircle2;

  return (
    <div className="pointer-events-auto flex items-center gap-2.5 px-3.5 py-2.5 rounded-raio bg-card/95 backdrop-blur-md border border-borda shadow-sombra text-xs text-tinta animate-in slide-in-from-bottom-2 fade-in duration-200 min-w-[240px] max-w-sm">
      <Icone className="w-4 h-4 text-acento flex-none" />
      <span className="flex-1 font-medium">{toast.texto}</span>
      <button
        type="button"
        onClick={() => onRemover(toast.id)}
        className="text-tinta3 hover:text-tinta p-0.5 rounded hover:bg-sup cursor-pointer flex-none"
      >
        <X className="w-3.5 h-3.5" />
      </button>
    </div>
  );
}
