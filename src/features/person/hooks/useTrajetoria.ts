import { useQuery } from '@tanstack/react-query';
import { obterTrajetoriaPessoa } from '../../../lib/api/trajetoria';

export function useTrajetoriaPessoa(pessoaId: string) {
  return useQuery({
    queryKey: ['trajetoria', pessoaId],
    queryFn: () => obterTrajetoriaPessoa(pessoaId),
    enabled: Boolean(pessoaId),
    staleTime: 1000 * 60 * 5, // 5 minutos
  });
}
