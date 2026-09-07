import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import {
  obterStatusSeguranca,
  bloquearAcervo,
  desbloquearAcervo,
  ativarModoBlindado,
  desativarModoBlindado,
  recuperarAcervoComChave,
  gerarChaveRecuperacao,
  type StatusSeguranca,
} from '../../../lib/api';

export function useSeguranca() {
  const qc = useQueryClient();

  const query = useQuery<StatusSeguranca>({
    queryKey: ['status-seguranca'],
    queryFn: obterStatusSeguranca,
    staleTime: 5000,
  });

  const mutacaoBloquear = useMutation({
    mutationFn: bloquearAcervo,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['status-seguranca'] });
    },
  });

  const mutacaoDesbloquear = useMutation({
    mutationFn: (senhaOuPin: string) => desbloquearAcervo(senhaOuPin),
    onSuccess: () => {
      qc.invalidateQueries(); // Invalida todas as consultas para carregar os dados do banco liberado
    },
  });

  const mutacaoAtivar = useMutation({
    mutationFn: (params: { senhaMestra: string; pin: string | null; chaveRecuperacao: string }) =>
      ativarModoBlindado(params.senhaMestra, params.pin, params.chaveRecuperacao),
    onSuccess: () => {
      qc.invalidateQueries();
    },
  });

  const mutacaoDesativar = useMutation({
    mutationFn: (senha: string) => desativarModoBlindado(senha),
    onSuccess: () => {
      qc.invalidateQueries();
    },
  });

  const mutacaoRecuperar = useMutation({
    mutationFn: (params: { chave: string; novaSenha: string }) =>
      recuperarAcervoComChave(params.chave, params.novaSenha),
    onSuccess: () => {
      qc.invalidateQueries();
    },
  });

  return {
    status: query.data,
    isLoading: query.isLoading,
    isError: query.isError,
    error: query.error,
    refetch: query.refetch,
    bloquear: mutacaoBloquear.mutateAsync,
    isBloqueando: mutacaoBloquear.isPending,
    desbloquear: mutacaoDesbloquear.mutateAsync,
    isDesbloqueando: mutacaoDesbloquear.isPending,
    erroDesbloqueio: mutacaoDesbloquear.error,
    ativar: mutacaoAtivar.mutateAsync,
    isAtivando: mutacaoAtivar.isPending,
    desativar: mutacaoDesativar.mutateAsync,
    isDesativando: mutacaoDesativar.isPending,
    recuperar: mutacaoRecuperar.mutateAsync,
    isRecuperando: mutacaoRecuperar.isPending,
    gerarChave: gerarChaveRecuperacao,
  };
}
