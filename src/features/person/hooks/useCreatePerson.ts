// src/features/person/hooks/useCreatePerson.ts
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { createPerson } from '../../../lib/api/person';
import type { Person } from '../../../types';

export const useCreatePerson = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (newPerson: Person) => createPerson(newPerson),
    onSuccess: () => {
      // Invalida o cache da árvore para forçar o React a buscar os dados atualizados do SQLite
      queryClient.invalidateQueries({ queryKey: ['familyTree'] });
      // Invalida estatísticas do recorte
      queryClient.invalidateQueries({ queryKey: ['treeStatistics'] });
    },
    onError: (error: any) => {
      // Aqui você pode plugar um sistema de toast ou exibir a mensagem de erro do Rust
      console.error("Falha ao criar pessoa:", error);
    }
  });
};