import React, { useState } from 'react';
import {
  Shield,
  ShieldCheck,
  Lock,
  Unlock,
  AlertTriangle,
} from 'lucide-react';
import { Modal } from '../../../components/ui/Modal';
import { Button } from '../../../components/ui/Button';
import { useSeguranca } from '../hooks/useSeguranca';
import { WizardAtivacaoBlindagem } from './WizardAtivacaoBlindagem';
import { useI18n } from '../../../i18n/I18nContext';

interface ModalGerenciarSegurancaProps {
  isOpen: boolean;
  onClose: () => void;
}

export function ModalGerenciarSeguranca({ isOpen, onClose }: ModalGerenciarSegurancaProps) {
  const { t } = useI18n();
  const { status, bloquear, isBloqueando, desativar, isDesativando } = useSeguranca();

  const [wizardAberto, setWizardAberto] = useState(false);
  const [desativandoConfirmacao, setDesativandoConfirmacao] = useState(false);
  const [senhaDesativar, setSenhaDesativar] = useState('');
  const [erroDesativar, setErroDesativar] = useState<string | null>(null);

  const isBlindado = status?.modo_blindado ?? false;

  const handleBloquearAgora = async () => {
    try {
      await bloquear();
      onClose();
    } catch {}
  };

  const handleDesativarModoBlindado = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!senhaDesativar.trim()) {
      setErroDesativar(t('seguranca', 'senhaObrigatoria'));
      return;
    }

    setErroDesativar(null);
    try {
      await desativar(senhaDesativar.trim());
      setDesativandoConfirmacao(false);
      setSenhaDesativar('');
    } catch (err: unknown) {
      setErroDesativar(err instanceof Error ? err.message : String(err));
    }
  };

  return (
    <>
      <Modal
        isOpen={isOpen}
        onClose={onClose}
        title={t('seguranca', 'titulo')}
        className="max-w-lg"
      >
        <div className="flex flex-col gap-4">
          {/* Status Atual */}
          <div
            className={`flex items-start gap-3 p-4 rounded-raio-s border ${
              isBlindado
                ? 'border-acento/30 bg-acento/5'
                : 'border-borda bg-card2'
            }`}
          >
            {isBlindado ? (
              <ShieldCheck className="w-6 h-6 text-acento flex-none mt-0.5" />
            ) : (
              <Shield className="w-6 h-6 text-tinta3 flex-none mt-0.5" />
            )}
            <div>
              <h3 className="font-tit font-bold text-base m-0 text-tinta">
                {isBlindado
                  ? t('seguranca', 'statusProtegido')
                  : t('seguranca', 'modoAberto')}
              </h3>
              <p className="text-xs text-tinta2 m-0 mt-0.5 leading-relaxed">
                {isBlindado
                  ? t('seguranca', 'modoBlindadoDesc')
                  : t('seguranca', 'modoAbertoDesc')}
              </p>
              {isBlindado && status?.data_ativacao && (
                <p className="text-[11px] text-tinta3 m-0 mt-1">
                  Ativado em: {new Date(status.data_ativacao).toLocaleDateString()}
                </p>
              )}
            </div>
          </div>

          {!isBlindado ? (
            /* Modo Aberto -> Opção para Blindar */
            <div className="flex flex-col gap-3 py-2">
              <div className="text-xs text-tinta2 leading-relaxed">
                No <strong>Modo Blindado</strong>, o EloTempo criptografa todo o banco de dados
                e mídias usando chaves derivadas por <strong>Argon2id</strong> e cifra <strong>AES-256-GCM</strong>.
                Mesmo que alguém copie os arquivos do seu computador, nenhuma biografia, foto ou dado genealógico
                poderá ser lido sem a sua Senha Mestra ou Chave Física de Recuperação.
              </div>

              <div className="flex justify-end pt-3 border-t border-borda">
                <Button
                  onClick={() => {
                    setWizardAberto(true);
                  }}
                  className="font-semibold shadow-xs"
                >
                  <ShieldCheck className="w-4 h-4 mr-1 text-acento" />
                  {t('seguranca', 'ativarBlindagem')}
                </Button>
              </div>
            </div>
          ) : !desativandoConfirmacao ? (
            /* Modo Blindado -> Ações de Bloqueio e Desativação */
            <div className="flex flex-col gap-3 py-2">
              <div className="flex flex-col gap-2">
                <Button
                  variant="secondary"
                  onClick={handleBloquearAgora}
                  disabled={isBloqueando}
                  className="justify-start py-2.5"
                >
                  <Lock className="w-4 h-4 mr-2 text-acento" />
                  {t('seguranca', 'bloquearAgora')}
                </Button>

                <Button
                  variant="ghost"
                  onClick={() => {
                    setDesativandoConfirmacao(true);
                    setErroDesativar(null);
                    setSenhaDesativar('');
                  }}
                  className="justify-start py-2.5 text-fem hover:text-fem hover:bg-fem/10"
                >
                  <Unlock className="w-4 h-4 mr-2" />
                  {t('seguranca', 'desativarBlindagem')}
                </Button>
              </div>
            </div>
          ) : (
            /* Confirmação de Desativação */
            <form onSubmit={handleDesativarModoBlindado} className="flex flex-col gap-3 py-2">
              <div className="flex items-start gap-2 p-3 rounded-raio-s border border-fem/30 bg-fem/10 text-xs text-fem">
                <AlertTriangle className="w-4 h-4 flex-none mt-0.5" />
                <span>
                  Ao desativar o Modo Blindado, o cofre criptográfico será revertido para um banco
                  SQLite comum no Modo Aberto.
                </span>
              </div>

              {erroDesativar && (
                <p className="text-xs text-fem bg-fem/10 border border-fem/20 rounded-raio-s p-2 m-0">
                  {erroDesativar}
                </p>
              )}

              <div className="flex flex-col gap-1">
                <label className="text-xs font-semibold text-tinta">
                  Digite sua Senha Mestra para confirmar:
                </label>
                <input
                  type="password"
                  value={senhaDesativar}
                  onChange={(e) => setSenhaDesativar(e.target.value)}
                  placeholder="Senha Mestra"
                  autoFocus
                  className="w-full text-sm px-3 py-2 rounded-raio-s border border-borda bg-card text-tinta focus:outline-hidden focus:ring-1 focus:ring-acento"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2 border-t border-borda">
                <Button
                  type="button"
                  variant="ghost"
                  onClick={() => setDesativandoConfirmacao(false)}
                  disabled={isDesativando}
                >
                  {t('comum', 'cancelar')}
                </Button>
                <Button
                  type="submit"
                  variant="ghost" className="text-fem hover:text-fem hover:bg-fem/10 border border-fem/30"
                  disabled={isDesativando || !senhaDesativar.trim()}
                >
                  {isDesativando ? t('comum', 'carregando') : 'Confirmar e Desativar'}
                </Button>
              </div>
            </form>
          )}
        </div>
      </Modal>

      <WizardAtivacaoBlindagem
        isOpen={wizardAberto}
        onClose={() => setWizardAberto(false)}
        onConcluido={() => {
          setWizardAberto(false);
        }}
      />
    </>
  );
}
