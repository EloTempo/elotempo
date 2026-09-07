import { Modal } from '../../../components/ui/Modal';
import { PainelEstatisticas } from './PainelEstatisticas';

interface DialogoEstatisticasProps {
  onClose: () => void;
}

export function DialogoEstatisticas({ onClose }: DialogoEstatisticasProps) {
  return (
    <Modal
      isOpen={true}
      onClose={onClose}
      title="Estatísticas e Demografia da Família"
      className="max-w-4xl w-[92vw] max-h-[90vh]"
    >
      <PainelEstatisticas />
    </Modal>
  );
}
