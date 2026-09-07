import { Clock, History, RotateCcw, RotateCw } from 'lucide-react';
import { Modal } from '../../../components/ui/Modal';
import { Button } from '../../../components/ui/Button';
import { useHistorico } from '../../../contexts/HistoricoContext';

interface ModalHistoricoAcoesProps {
  isOpen: boolean;
  onClose: () => void;
}

export function ModalHistoricoAcoes({ isOpen, onClose }: ModalHistoricoAcoesProps) {
  const { pilhaDesfazer, pilhaRefazer, desfazer, refazer, podeDesfazer, podeRefazer } =
    useHistorico();

  const todasAcoes = [
    ...pilhaDesfazer.map((a) => ({ ...a, estado: 'aplicada' as const })),
    ...pilhaRefazer.map((a) => ({ ...a, estado: 'desfeita' as const })),
  ];

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Histórico de Ações da Sessão"
      className="max-w-xl"
    >
      <div className="flex flex-col gap-4">
        <div className="flex items-center justify-between gap-2 border-b border-borda/60 pb-3">
          <p className="text-xs text-tinta2 m-0 leading-relaxed">
            Acompanhe a trilha de modificações realizadas nesta sessão. Você pode desfazer ou refazer alterações a qualquer momento.
          </p>

          <div className="flex items-center gap-1.5 flex-none">
            <Button
              size="sm"
              variant="secondary"
              onClick={desfazer}
              disabled={!podeDesfazer}
              title="Desfazer última alteração (Ctrl+Z)"
            >
              <RotateCcw className="w-3.5 h-3.5 mr-1" />
              Desfazer
            </Button>
            <Button
              size="sm"
              variant="secondary"
              onClick={refazer}
              disabled={!podeRefazer}
              title="Refazer última alteração (Ctrl+Y)"
            >
              <RotateCw className="w-3.5 h-3.5 mr-1" />
              Refazer
            </Button>
          </div>
        </div>

        {todasAcoes.length === 0 ? (
          <div className="p-8 text-center flex flex-col items-center gap-2 text-tinta3">
            <History className="w-8 h-8 opacity-40" />
            <p className="text-xs m-0">Nenhuma ação registrada nesta sessão ainda.</p>
          </div>
        ) : (
          <div className="flex flex-col gap-2 max-h-80 overflow-y-auto pr-1">
            {todasAcoes.map((acao, index) => {
              const hora = acao.timestamp.toLocaleTimeString([], {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
              });
              const isAplicada = acao.estado === 'aplicada';

              return (
                <div
                  key={`${acao.id}-${index}`}
                  className={`p-2.5 rounded-raio-s border transition-colors flex items-center justify-between gap-3 text-xs ${
                    isAplicada
                      ? 'bg-card border-borda hover:border-borda2'
                      : 'bg-sup/40 border-borda/40 opacity-60'
                  }`}
                >
                  <div className="flex items-center gap-2.5 min-w-0 flex-1">
                    {isAplicada ? (
                      <div className="w-2 h-2 rounded-full bg-acento flex-none" />
                    ) : (
                      <div className="w-2 h-2 rounded-full border border-tinta3 flex-none" />
                    )}

                    <span
                      className={`truncate ${
                        isAplicada ? 'font-medium text-tinta' : 'line-through text-tinta3'
                      }`}
                    >
                      {acao.descricao}
                    </span>
                  </div>

                  <div className="flex items-center gap-2 flex-none text-[11px] text-tinta3 font-num">
                    <Clock className="w-3 h-3" />
                    <span>{hora}</span>
                    <span className="px-1.5 py-0.2 text-[9.5px] rounded bg-sup font-sans">
                      {isAplicada ? 'Aplicada' : 'Desfeita'}
                    </span>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </Modal>
  );
}
