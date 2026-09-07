import React, { useState } from 'react';
import {
  Lock,
  Eye,
  EyeOff,
  KeyRound,
  RefreshCw,
  AlertCircle,
} from 'lucide-react';
import { MarcaAssinaturaHorizontal } from '../../../components/icons';
import { Button } from '../../../components/ui/Button';
import { useSeguranca } from '../hooks/useSeguranca';
import { useI18n } from '../../../i18n/I18nContext';

export function TelaDesbloqueio() {
  const { t } = useI18n();
  const { desbloquear, isDesbloqueando, recuperar, isRecuperando } = useSeguranca();

  const [senha, setSenha] = useState('');
  const [mostrarSenha, setMostrarSenha] = useState(false);
  const [erro, setErro] = useState<string | null>(null);

  // Modo de recuperação com as 24 palavras
  const [modoRecuperacao, setModoRecuperacao] = useState(false);
  const [palavrasChave, setPalavrasChave] = useState('');
  const [novaSenha, setNovaSenha] = useState('');
  const [confirmarNovaSenha, setConfirmarNovaSenha] = useState('');

  const handleDesbloquear = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!senha.trim()) {
      setErro(t('seguranca', 'senhaObrigatoria'));
      return;
    }

    setErro(null);
    try {
      await desbloquear(senha.trim());
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : String(err);
      if (msg.toLowerCase().includes('incorret') || msg.toLowerCase().includes('inválid')) {
        setErro(t('seguranca', 'erroSenhaIncorreta'));
      } else {
        setErro(msg || t('seguranca', 'erroSenhaIncorreta'));
      }
    }
  };

  const handleRecuperar = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!palavrasChave.trim()) {
      setErro(t('seguranca', 'chaveInvalida'));
      return;
    }
    if (novaSenha.length < 8) {
      setErro(t('seguranca', 'senhaCurta'));
      return;
    }
    if (novaSenha !== confirmarNovaSenha) {
      setErro(t('seguranca', 'senhasNaoConferem'));
      return;
    }

    setErro(null);
    try {
      await recuperar({ chave: palavrasChave.trim(), novaSenha: novaSenha.trim() });
      setModoRecuperacao(false);
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : String(err);
      setErro(msg || t('seguranca', 'chaveInvalida'));
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-mesa text-tinta select-none animate-in fade-in duration-300">
      <div className="w-full max-w-md bg-card border border-borda rounded-raio shadow-sombra p-6 flex flex-col items-center">
        {/* Logo / Assinatura da Marca */}
        <div className="mb-3 pt-2">
          <MarcaAssinaturaHorizontal tamanho="md" />
        </div>
        <p className="text-xs text-tinta3 uppercase tracking-widest font-mono mb-6">
          {t('seguranca', 'statusProtegido')}
        </p>

        {erro && (
          <div className="w-full flex items-start gap-2.5 p-3 rounded-raio-s border border-fem/30 bg-fem/10 text-fem text-xs mb-4 animate-in fade-in">
            <AlertCircle className="w-4 h-4 flex-none mt-0.5" />
            <span>{erro}</span>
          </div>
        )}

        {!modoRecuperacao ? (
          /* Formulário de Desbloqueio Padrão (Senha / PIN) */
          <form onSubmit={handleDesbloquear} className="w-full flex flex-col gap-4">
            <div className="flex flex-col gap-1.5">
              <label className="text-xs font-semibold text-tinta2">
                {t('seguranca', 'senhaMestra')} ou PIN:
              </label>
              <div className="relative flex items-center">
                <input
                  type={mostrarSenha ? 'text' : 'password'}
                  value={senha}
                  onChange={(e) => {
                    setSenha(e.target.value);
                    setErro(null);
                  }}
                  autoFocus
                  placeholder="••••••••"
                  disabled={isDesbloqueando}
                  className="w-full text-base px-3.5 py-2.5 pr-10 rounded-raio-s border border-borda bg-sup text-tinta focus:outline-hidden focus:ring-2 focus:ring-acento/50"
                />
                <button
                  type="button"
                  onClick={() => setMostrarSenha((prev) => !prev)}
                  className="absolute right-3 p-1 text-tinta3 hover:text-tinta cursor-pointer"
                  tabIndex={-1}
                  title={mostrarSenha ? 'Ocultar' : 'Mostrar'}
                >
                  {mostrarSenha ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
            </div>

            <Button
              type="submit"
              size="lg"
              disabled={isDesbloqueando || !senha.trim()}
              className="w-full mt-2 font-semibold shadow-xs"
            >
              {isDesbloqueando ? (
                <>
                  <RefreshCw className="w-4 h-4 mr-2 animate-spin text-acento" />
                  {t('comum', 'carregando')}
                </>
              ) : (
                <>
                  <Lock className="w-4 h-4 mr-2 text-acento" />
                  {t('seguranca', 'desbloquearAcervo')}
                </>
              )}
            </Button>

            <button
              type="button"
              onClick={() => {
                setModoRecuperacao(true);
                setErro(null);
              }}
              className="text-xs text-tinta3 hover:text-acento text-center mt-3 cursor-pointer underline underline-offset-4 transition-colors"
            >
              {t('seguranca', 'recuperarConta')}
            </button>
          </form>
        ) : (
          /* Formulário de Recuperação com 24 palavras */
          <form onSubmit={handleRecuperar} className="w-full flex flex-col gap-3.5">
            <div className="flex items-start gap-2 p-2.5 rounded-raio-s border border-borda bg-sup text-xs text-tinta2">
              <KeyRound className="w-4 h-4 text-acento flex-none mt-0.5" />
              <span>{t('seguranca', 'recuperarContaInstrucao')}</span>
            </div>

            <div className="flex flex-col gap-1">
              <label className="text-xs font-semibold text-tinta2">24 Palavras BIP-39:</label>
              <textarea
                value={palavrasChave}
                onChange={(e) => setPalavrasChave(e.target.value)}
                rows={3}
                placeholder="palavra1 palavra2 palavra3 ..."
                className="w-full text-xs font-mono p-2.5 rounded-raio-s border border-borda bg-sup text-tinta resize-none focus:outline-hidden focus:ring-1 focus:ring-acento"
              />
            </div>

            <div className="flex flex-col gap-1">
              <label className="text-xs font-semibold text-tinta2">
                {t('seguranca', 'novaSenhaAposRecuperacao')}:
              </label>
              <input
                type="password"
                value={novaSenha}
                onChange={(e) => setNovaSenha(e.target.value)}
                placeholder="Mínimo 8 caracteres"
                className="w-full text-sm px-3 py-2 rounded-raio-s border border-borda bg-sup text-tinta focus:outline-hidden focus:ring-1 focus:ring-acento"
              />
            </div>

            <div className="flex flex-col gap-1">
              <label className="text-xs font-semibold text-tinta2">
                {t('seguranca', 'confirmarSenha')}:
              </label>
              <input
                type="password"
                value={confirmarNovaSenha}
                onChange={(e) => setConfirmarNovaSenha(e.target.value)}
                placeholder="Repita a nova senha"
                className="w-full text-sm px-3 py-2 rounded-raio-s border border-borda bg-sup text-tinta focus:outline-hidden focus:ring-1 focus:ring-acento"
              />
            </div>

            <div className="flex gap-2 pt-2">
              <Button
                type="button"
                variant="ghost"
                onClick={() => {
                  setModoRecuperacao(false);
                  setErro(null);
                }}
                className="flex-1"
              >
                {t('comum', 'voltar')}
              </Button>
              <Button
                type="submit"
                disabled={isRecuperando || !palavrasChave.trim()}
                className="flex-1"
              >
                {isRecuperando ? t('comum', 'carregando') : t('seguranca', 'restaurarComChave')}
              </Button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
}
