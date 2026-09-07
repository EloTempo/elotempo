import React, { useState, useEffect, useRef } from 'react';
import { Lock, Eye, EyeOff, ShieldAlert } from 'lucide-react';
import { Modal } from '../../../components/ui/Modal';
import { Button } from '../../../components/ui/Button';
import { validarSenhaGatekeeper } from '../../../lib/api';
import { useI18n } from '../../../i18n/I18nContext';

interface ModalGatekeeperProps {
  isOpen: boolean;
  descricao?: string;
  onConfirmar: (ticket: string) => void;
  onCancelar: () => void;
}

export function ModalGatekeeper({
  isOpen,
  descricao,
  onConfirmar,
  onCancelar,
}: ModalGatekeeperProps) {
  const { t } = useI18n();
  const [senha, setSenha] = useState('');
  const [mostrarSenha, setMostrarSenha] = useState(false);
  const [carregando, setCarregando] = useState(false);
  const [erro, setErro] = useState<string | null>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (isOpen) {
      setSenha('');
      setErro(null);
      setCarregando(false);
      setTimeout(() => inputRef.current?.focus(), 50);
    }
  }, [isOpen]);

  const handleSubmit = async (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (!senha.trim()) {
      setErro(t('seguranca', 'senhaObrigatoria'));
      return;
    }

    setCarregando(true);
    setErro(null);

    try {
      const ticket = await validarSenhaGatekeeper(senha.trim());
      setSenha('');
      onConfirmar(ticket);
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : String(err);
      if (msg.toLowerCase().includes('incorret') || msg.toLowerCase().includes('inválid')) {
        setErro(t('seguranca', 'erroSenhaIncorreta'));
      } else {
        setErro(msg || t('seguranca', 'erroSenhaIncorreta'));
      }
    } finally {
      setCarregando(false);
    }
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onCancelar}
      title={t('seguranca', 'gatekeeperTitulo')}
      className="max-w-md"
    >
      <form onSubmit={handleSubmit} className="flex flex-col gap-4">
        <div className="flex items-start gap-3 p-3 rounded-raio-s border border-acento/30 bg-acento/5">
          <ShieldAlert className="w-5 h-5 text-acento flex-none mt-0.5" />
          <p className="text-xs text-tinta2 m-0 leading-relaxed">
            {descricao || t('seguranca', 'gatekeeperDescGenerico')}
          </p>
        </div>

        {erro && (
          <p
            role="alert"
            className="text-xs text-fem bg-fem/10 border border-fem/20 rounded-raio-s p-2.5 m-0"
          >
            {erro}
          </p>
        )}

        <div className="flex flex-col gap-1.5">
          <label className="text-xs font-semibold text-tinta">
            {t('seguranca', 'senhaMestra')} ou PIN:
          </label>
          <div className="relative flex items-center">
            <input
              ref={inputRef}
              type={mostrarSenha ? 'text' : 'password'}
              value={senha}
              onChange={(e) => {
                setSenha(e.target.value);
                setErro(null);
              }}
              placeholder="••••••••"
              disabled={carregando}
              className="w-full text-sm px-3 py-2 pr-10 rounded-raio-s border border-borda bg-card text-tinta focus:outline-hidden focus:ring-1 focus:ring-acento"
            />
            <button
              type="button"
              onClick={() => setMostrarSenha((prev) => !prev)}
              className="absolute right-2 p-1 text-tinta3 hover:text-tinta cursor-pointer"
              tabIndex={-1}
              title={mostrarSenha ? 'Ocultar senha' : 'Ver senha'}
            >
              {mostrarSenha ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
            </button>
          </div>
        </div>

        <div className="flex justify-end gap-2 pt-2 border-t border-borda">
          <Button type="button" variant="ghost" onClick={onCancelar} disabled={carregando}>
            {t('comum', 'cancelar')}
          </Button>
          <Button type="submit" disabled={carregando || !senha.trim()}>
            {carregando ? (
              t('comum', 'carregando')
            ) : (
              <>
                <Lock className="w-4 h-4 mr-1 text-acento" />
                {t('comum', 'confirmar')}
              </>
            )}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
