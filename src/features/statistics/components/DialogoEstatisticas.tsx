import { Modal } from '../../../components/ui/Modal';
import { PainelEstatisticas } from './PainelEstatisticas';
import { useI18n } from '../../../i18n/I18nContext';

interface DialogoEstatisticasProps {
  onClose: () => void;
}

export function DialogoEstatisticas({ onClose }: DialogoEstatisticasProps) {
  const { t } = useI18n();

  return (
    <Modal
      isOpen={true}
      onClose={onClose}
      title={t('estatisticasModal', 'titulo')}
      className="max-w-4xl w-[92vw] max-h-[90vh]"
    >
      <PainelEstatisticas />
    </Modal>
  );
}
