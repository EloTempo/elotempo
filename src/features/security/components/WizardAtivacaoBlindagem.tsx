import { useState, useEffect } from 'react';
import {
  ShieldCheck,
  Copy,
  Check,
  AlertTriangle,
  ChevronRight,
  RefreshCw,
} from 'lucide-react';
import { Modal } from '../../../components/ui/Modal';
import { Button } from '../../../components/ui/Button';
import { useSeguranca } from '../hooks/useSeguranca';
import { useI18n } from '../../../i18n/I18nContext';
import type { ResumoMigracao } from '../../../lib/api';

interface WizardAtivacaoBlindagemProps {
  isOpen: boolean;
  onClose: () => void;
  onConcluido?: () => void;
}

export function WizardAtivacaoBlindagem({
  isOpen,
  onClose,
  onConcluido,
}: WizardAtivacaoBlindagemProps) {
  const { t } = useI18n();
  const { gerarChave, ativar, isAtivando } = useSeguranca();

  const [passo, setPasso] = useState<1 | 2 | 3>(1);
  const [senhaMestra, setSenhaMestra] = useState('');
  const [confirmarSenha, setConfirmarSenha] = useState('');
  const [pin, setPin] = useState('');
  const [chavePalavras, setChavePalavras] = useState<string[]>([]);
  const [copiado, setCopiado] = useState(false);
  const [ciente, setCiente] = useState(false);
  const [erro, setErro] = useState<string | null>(null);
  const [resumoMigracao, setResumoMigracao] = useState<ResumoMigracao | null>(null);

  useEffect(() => {
    if (isOpen) {
      setPasso(1);
      setSenhaMestra('');
      setConfirmarSenha('');
      setPin('');
      setCiente(false);
      setErro(null);
      setCopiado(false);
      setResumoMigracao(null);
      // Gera nova chave de 24 palavras
      gerarChave().then((dto) => {
        setChavePalavras(dto.palavras.split(' '));
      });
    }
  }, [isOpen]);

  const avancarParaPasso2 = () => {
    if (senhaMestra.length < 8) {
      setErro(t('seguranca', 'senhaCurta'));
      return;
    }
    if (senhaMestra !== confirmarSenha) {
      setErro(t('seguranca', 'senhasNaoConferem'));
      return;
    }
    if (pin && (pin.length < 4 || pin.length > 8 || !/^\d+$/.test(pin))) {
      setErro('O PIN deve ter entre 4 e 8 números.');
      return;
    }
    setErro(null);
    setPasso(2);
  };

  const copiarChave = async () => {
    try {
      await navigator.clipboard.writeText(chavePalavras.join(' '));
      setCopiado(true);
      setTimeout(() => setCopiado(false), 3000);
    } catch {}
  };

  const executarAtivacao = async () => {
    if (!ciente) return;
    setErro(null);
    try {
      const resumo = await ativar({
        senhaMestra: senhaMestra.trim(),
        pin: pin.trim() ? pin.trim() : null,
        chaveRecuperacao: chavePalavras.join(' '),
      });
      setResumoMigracao(resumo);
      setPasso(3);
    } catch (err: unknown) {
      setErro(err instanceof Error ? err.message : String(err));
    }
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={passo === 3 ? onClose : onClose}
      title={t('seguranca', 'ativarBlindagem')}
      className="max-w-xl"
    >
      <div className="flex flex-col gap-4">
        {/* Marcador de passos */}
        <div className="flex items-center justify-between pb-3 border-b border-borda text-xs">
          <span
            className={`font-semibold ${
              passo === 1 ? 'text-acento' : 'text-tinta2'
            }`}
          >
            1. Definir Senhas
          </span>
          <ChevronRight className="w-3.5 h-3.5 text-tinta3" />
          <span
            className={`font-semibold ${
              passo === 2 ? 'text-acento' : 'text-tinta2'
            }`}
          >
            2. Chave Física de Recuperação
          </span>
          <ChevronRight className="w-3.5 h-3.5 text-tinta3" />
          <span
            className={`font-semibold ${
              passo === 3 ? 'text-acento' : 'text-tinta2'
            }`}
          >
            3. Conclusão
          </span>
        </div>

        {erro && (
          <p
            role="alert"
            className="text-xs text-fem bg-fem/10 border border-fem/20 rounded-raio-s p-2.5 m-0"
          >
            {erro}
          </p>
        )}

        {/* PASSO 1: SENHAS */}
        {passo === 1 && (
          <div className="flex flex-col gap-3.5">
            <p className="text-xs text-tinta2 m-0 leading-relaxed">
              Crie uma Senha Mestra segura. Ela será usada para derivar a chave de criptografia
              AES-256 do seu acervo através do algoritmo Argon2id.
            </p>

            <div className="flex flex-col gap-1">
              <label className="text-xs font-semibold text-tinta">
                {t('seguranca', 'senhaMestra')} (mínimo 8 caracteres):
              </label>
              <input
                type="password"
                value={senhaMestra}
                onChange={(e) => {
                  setSenhaMestra(e.target.value);
                  setErro(null);
                }}
                placeholder="Crie uma senha mestra forte"
                className="w-full text-sm px-3 py-2 rounded-raio-s border border-borda bg-card text-tinta focus:outline-hidden focus:ring-1 focus:ring-acento"
              />
            </div>

            <div className="flex flex-col gap-1">
              <label className="text-xs font-semibold text-tinta">
                {t('seguranca', 'confirmarSenha')}:
              </label>
              <input
                type="password"
                value={confirmarSenha}
                onChange={(e) => {
                  setConfirmarSenha(e.target.value);
                  setErro(null);
                }}
                placeholder="Repita a senha mestra"
                className="w-full text-sm px-3 py-2 rounded-raio-s border border-borda bg-card text-tinta focus:outline-hidden focus:ring-1 focus:ring-acento"
              />
            </div>

            <div className="flex flex-col gap-1 pt-2 border-t border-borda">
              <label className="text-xs font-semibold text-tinta flex items-center justify-between">
                <span>{t('seguranca', 'pinOpcional')}</span>
                <span className="text-[11px] font-normal text-tinta3">Opcional</span>
              </label>
              <input
                type="text"
                inputMode="numeric"
                maxLength={8}
                value={pin}
                onChange={(e) => {
                  const val = e.target.value.replace(/\D/g, '');
                  setPin(val);
                }}
                placeholder="Ex: 1234"
                className="w-full text-sm font-mono px-3 py-2 rounded-raio-s border border-borda bg-card text-tinta focus:outline-hidden focus:ring-1 focus:ring-acento"
              />
              <p className="text-[11px] text-tinta3 m-0 leading-relaxed">
                {t('seguranca', 'pinDica')}
              </p>
            </div>

            <div className="flex justify-end gap-2 pt-3 border-t border-borda">
              <Button variant="ghost" onClick={onClose}>
                {t('comum', 'cancelar')}
              </Button>
              <Button onClick={avancarParaPasso2}>
                {t('comum', 'avancar')}
                <ChevronRight className="w-4 h-4 ml-1" />
              </Button>
            </div>
          </div>
        )}

        {/* PASSO 2: CHAVE FÍSICA BIP-39 */}
        {passo === 2 && (
          <div className="flex flex-col gap-3.5">
            <div className="flex items-start gap-2.5 p-3 rounded-raio-s border border-fem/30 bg-fem/10 text-xs text-fem leading-relaxed">
              <AlertTriangle className="w-4 h-4 flex-none mt-0.5" />
              <span>{t('seguranca', 'chaveRecuperacaoAviso')}</span>
            </div>

            <div className="grid grid-cols-4 sm:grid-cols-6 gap-1.5 p-3 rounded-raio-s border border-borda bg-card2 select-all">
              {chavePalavras.map((palavra, idx) => (
                <div
                  key={idx}
                  className="flex items-center gap-1.5 px-2 py-1 bg-card rounded border border-borda text-xs font-mono"
                >
                  <span className="text-[10px] text-tinta3">{idx + 1}.</span>
                  <span className="text-tinta font-semibold">{palavra}</span>
                </div>
              ))}
            </div>

            <div className="flex justify-end">
              <Button size="sm" variant="secondary" onClick={copiarChave}>
                {copiado ? (
                  <>
                    <Check className="w-3.5 h-3.5 mr-1 text-acento" />
                    {t('seguranca', 'chaveCopiada')}
                  </>
                ) : (
                  <>
                    <Copy className="w-3.5 h-3.5 mr-1" />
                    {t('comum', 'copiar')} Chave
                  </>
                )}
              </Button>
            </div>

            <label className="flex items-start gap-2 text-xs text-tinta cursor-pointer pt-2 border-t border-borda">
              <input
                type="checkbox"
                checked={ciente}
                onChange={(e) => setCiente(e.target.checked)}
                className="mt-0.5 rounded border-borda accent-[var(--acento)]"
              />
              <span className="leading-relaxed">
                {t('seguranca', 'confirmacaoCienciaChave')}
              </span>
            </label>

            <div className="flex justify-end gap-2 pt-3 border-t border-borda">
              <Button variant="ghost" onClick={() => setPasso(1)} disabled={isAtivando}>
                {t('comum', 'voltar')}
              </Button>
              <Button onClick={executarAtivacao} disabled={!ciente || isAtivando}>
                {isAtivando ? (
                  <>
                    <RefreshCw className="w-4 h-4 mr-2 animate-spin text-acento" />
                    Criptografando acervo...
                  </>
                ) : (
                  <>
                    <ShieldCheck className="w-4 h-4 mr-1 text-acento" />
                    Criptografar e Ativar Modo Blindado
                  </>
                )}
              </Button>
            </div>
          </div>
        )}

        {/* PASSO 3: CONCLUSÃO */}
        {passo === 3 && (
          <div className="flex flex-col gap-4 py-2">
            <div className="flex items-center gap-3 p-4 rounded-raio-s border border-acento/30 bg-acento/5">
              <ShieldCheck className="w-8 h-8 text-acento flex-none" />
              <div>
                <h3 className="font-tit font-bold text-base m-0 text-tinta">
                  Modo Blindado Ativado com Sucesso!
                </h3>
                <p className="text-xs text-tinta2 m-0 mt-0.5 leading-relaxed">
                  Seu acervo agora reside num cofre criptografado seguro (Argon2id + AES-256-GCM).
                </p>
              </div>
            </div>

            {resumoMigracao && (
              <div className="p-3 rounded-raio-s border border-borda bg-card2 text-xs text-tinta2 flex flex-col gap-1.5">
                <div className="font-semibold text-tinta mb-0.5">Resumo da Migração Segura:</div>
                <div>• Árvores protegidas: {resumoMigracao.total_arvores}</div>
                <div>• Pessoas no cofre: {resumoMigracao.total_pessoas}</div>
                <div>• Uniões e conexões: {resumoMigracao.total_unioes}</div>
                <div>• Eventos históricos: {resumoMigracao.total_eventos}</div>
                <div>• Mídias registradas: {resumoMigracao.total_midias}</div>
                <div className="text-[11px] text-tinta3 mt-1 break-all">
                  Backup de segurança gravado em: {resumoMigracao.backup_criado}
                </div>
              </div>
            )}

            <div className="flex justify-end pt-3 border-t border-borda">
              <Button
                onClick={() => {
                  onClose();
                  if (onConcluido) onConcluido();
                }}
              >
                Concluir
              </Button>
            </div>
          </div>
        )}
      </div>
    </Modal>
  );
}
