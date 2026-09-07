/**
 * API do Sistema de Segurança, Modo Híbrido Flexível e Gatekeeper (EloTempo).
 */

import { chamar } from './index';

export interface StatusSeguranca {
  modo_blindado: boolean;
  bloqueado: boolean;
  tem_pin: boolean;
  data_ativacao: string | null;
  gatekeeper_ativo: boolean;
}

export interface ChaveRecuperacaoDto {
  palavras: string;
}

export interface ResumoMigracao {
  total_arvores: number;
  total_pessoas: number;
  total_unioes: number;
  total_eventos: number;
  total_midias: number;
  backup_criado: string;
  vault_gerado: string;
}

export const obterStatusSeguranca = (): Promise<StatusSeguranca> =>
  chamar<StatusSeguranca>('obter_status_seguranca');

export const gerarChaveRecuperacao = (): Promise<ChaveRecuperacaoDto> =>
  chamar<ChaveRecuperacaoDto>('gerar_chave_recuperacao');

export const ativarModoBlindado = (
  senhaMestra: string,
  pin: string | null,
  chaveRecuperacao: string,
): Promise<ResumoMigracao> =>
  chamar<ResumoMigracao>('ativar_modo_blindado', {
    senhaMestra,
    pin,
    chaveRecuperacao,
  });

export const desativarModoBlindado = (senhaConfirmacao: string): Promise<void> =>
  chamar<void>('desativar_modo_blindado', { senhaConfirmacao });

export const desbloquearAcervo = (senhaOuPin: string): Promise<void> =>
  chamar<void>('desbloquear_acervo', { senhaOuPin });

export const bloquearAcervo = (): Promise<void> =>
  chamar<void>('bloquear_acervo');

export const validarSenhaGatekeeper = (senhaOuPin: string): Promise<string> =>
  chamar<string>('validar_senha_gatekeeper', { senhaOuPin });

export const recuperarAcervoComChave = (
  chaveRecuperacao: string,
  novaSenha: string,
): Promise<void> =>
  chamar<void>('recuperar_acervo_com_chave', { chaveRecuperacao, novaSenha });
