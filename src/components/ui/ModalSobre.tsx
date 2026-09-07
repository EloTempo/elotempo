import { Modal } from './Modal';
import { useI18n } from '../../i18n/I18nContext';
import { HardDrive, ShieldCheck, HeartHandshake, Layers } from 'lucide-react';
import { IconeAplicativo } from '../icons';

interface ModalSobreProps {
  aberto: boolean;
  aoFechar: () => void;
}

export function ModalSobre({ aberto, aoFechar }: ModalSobreProps) {
  const { t } = useI18n();

  return (
    <Modal
      isOpen={aberto}
      onClose={aoFechar}
      title={t('sobreModal', 'titulo')}
      className="max-w-xl"
    >
      <div className="flex flex-col gap-5 text-sm">
        {/* Cabeçalho do App com Símbolo Oficial e Fonte Sora */}
        <div className="flex items-start gap-4 pb-4 border-b border-borda">
          <IconeAplicativo size={52} className="flex-none rounded-[13px] shadow-xs" />
          <div className="flex flex-col min-w-0">
            <div className="flex items-baseline gap-2.5 flex-wrap">
              <h3 className="font-marca font-medium text-2xl text-tinta leading-tight tracking-[-0.025em]">
                {t('topo', 'tituloApp')}
              </h3>
              <span className="text-xs font-semibold px-2 py-0.5 rounded-full bg-masc/15 text-masc border border-masc/25 shadow-2xs font-num">
                v0.1.0
              </span>
            </div>
            <span className="font-marca text-[10px] text-masc font-semibold tracking-[0.2em] uppercase mt-1">
              Histórias que conectam gerações
            </span>
            <p className="text-xs text-tinta3 mt-1.5 m-0 leading-relaxed">
              {t('sobreModal', 'subtitulo')}
            </p>
            <span className="text-[11px] text-tinta3 font-medium mt-1">
              {t('sobreModal', 'fase')}
            </span>
          </div>
        </div>

        {/* Metadados de Autoria e Concepção */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5 p-3 rounded-raio bg-sup border border-borda text-xs">
          <div>
            <span className="text-tinta3 block text-[11px] font-medium uppercase tracking-wider">
              {t('sobreModal', 'autor')}:
            </span>
            <span className="text-tinta font-semibold">Gabriel Nascimento</span>
          </div>
          <div>
            <span className="text-tinta3 block text-[11px] font-medium uppercase tracking-wider">
              {t('sobreModal', 'concepcao')}:
            </span>
            <span className="text-tinta font-semibold">
              {t('sobreModal', 'concepcaoData')}
            </span>
          </div>
          <div className="sm:col-span-2 pt-2 border-t border-borda/60">
            <span className="text-tinta3 block text-[11px] font-medium uppercase tracking-wider">
              {t('sobreModal', 'licenca')}:
            </span>
            <span className="text-tinta font-semibold block">
              {t('sobreModal', 'licencaTipo')}
            </span>
            <p className="text-tinta2 text-[11.5px] mt-1 m-0 leading-relaxed">
              {t('sobreModal', 'direitosUsuario')}
            </p>
          </div>
        </div>

        {/* Pilares e Garantias */}
        <div className="flex flex-col gap-2.5">
          <div className="flex items-start gap-3 p-2.5 rounded-raio border border-borda bg-card2/50">
            <ShieldCheck className="w-5 h-5 text-emerald-600 dark:text-emerald-400 flex-none mt-0.5" />
            <div className="min-w-0">
              <span className="font-semibold text-tinta text-xs block">
                {t('sobreModal', 'localFirstTitulo')}
              </span>
              <span className="text-xs text-tinta2 leading-relaxed">
                {t('sobreModal', 'localFirstDesc')}
              </span>
            </div>
          </div>

          <div className="flex items-start gap-3 p-2.5 rounded-raio border border-borda bg-card2/50">
            <HardDrive className="w-5 h-5 text-acento flex-none mt-0.5" />
            <div className="min-w-0">
              <span className="font-semibold text-tinta text-xs block">
                {t('sobreModal', 'gedcomTitulo')}
              </span>
              <span className="text-xs text-tinta2 leading-relaxed">
                {t('sobreModal', 'gedcomDesc')}
              </span>
            </div>
          </div>

          <div className="flex items-start gap-3 p-2.5 rounded-raio border border-borda bg-card2/50">
            <Layers className="w-5 h-5 text-sky-600 dark:text-sky-400 flex-none mt-0.5" />
            <div className="min-w-0">
              <span className="font-semibold text-tinta text-xs block">
                {t('sobreModal', 'tecnologiasTitulo')}
              </span>
              <span className="text-xs text-tinta2 leading-relaxed">
                {t('sobreModal', 'tecnologiasDesc')}
              </span>
            </div>
          </div>
        </div>

        {/* Rodapé com Fechamento */}
        <div className="flex items-center justify-between pt-3 border-t border-borda mt-1">
          <div className="flex items-center gap-1.5 text-xs text-tinta3">
            <HeartHandshake className="w-4 h-4 text-acento" />
            <span>Preservando histórias de vida</span>
          </div>
          <button
            type="button"
            onClick={aoFechar}
            className="px-4 py-1.5 text-xs font-semibold rounded-raio-s bg-sup hover:bg-card border border-borda text-tinta cursor-pointer transition-colors shadow-2xs"
          >
            {t('comum', 'fechar')}
          </button>
        </div>
      </div>
    </Modal>
  );
}
