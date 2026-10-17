import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import {
  criarPessoa,
  atualizarPessoa,
  criarEvento,
  buscarPessoas,
  removerPessoa,
  restaurarPessoa,
  adicionarNacionalidade,
  adicionarNome,
} from '../../../lib/api';
import { useHistorico } from '../../../contexts/HistoricoContext';
import { TIPOS_EVENTO, type DataEscolhida } from '../../../types';

/** Houve alguma escolha de data? Ano ou descrição bastam. */
function temData(d: DataEscolhida): boolean {
  return d.ano != null || !!d.texto_livre?.trim();
}
import type { DadosPessoaForm } from '../components/PersonForm';

/** Tudo que depende do acervo é invalidado junto — a árvore, a busca, as estatísticas. */
function invalidarAcervo(queryClient: ReturnType<typeof useQueryClient>) {
  queryClient.invalidateQueries({ queryKey: ['arvore'] });
  queryClient.invalidateQueries({ queryKey: ['pessoas'] });
  queryClient.invalidateQueries({ queryKey: ['estatisticas'] });
}

/**
 * Cria a pessoa e, se houver datas, os eventos de nascimento e falecimento.
 *
 * Os eventos são gravados depois da pessoa porque dependem do id que o backend
 * gera. Se um deles falhar, a pessoa permanece — é o comportamento certo aqui:
 * perder o cadastro inteiro por causa de uma data seria pior do que ficar com
 * a data faltando, que o usuário corrige depois.
 */
export function useCriarPessoa() {
  const queryClient = useQueryClient();
  const { registrarAcao } = useHistorico();

  return useMutation({
    mutationFn: async (dados: DadosPessoaForm) => {
      const id = await criarPessoa({
        nome: dados.nome,
        sobrenome: dados.sobrenome || null,
        sexo: dados.sexo,
        minibiografia: dados.minibiografia || null,
        is_vivo: dados.is_vivo,
        foto_url: null,
        tipo_tempo: dados.tipo_tempo ?? 'real',
        arvore_id: dados.arvore_id ?? null,
      });

      // Cria o evento de nascimento quando há data ou local
      if (temData(dados.nascimento) || dados.localNascimento || dados.rotuloHistoricoNascimento) {
        await criarEvento({
          pessoa_id: id,
          tipo_evento: TIPOS_EVENTO.nascimento,
          data: dados.nascimento,
          local_id: dados.localNascimento?.id ?? null,
          rotulo_historico_livre: dados.rotuloHistoricoNascimento?.trim() || null,
        });

        const paisId =
          dados.nacionalidadePaisId ||
          (dados.localNascimento?.pais_id === 'br' ? 'br' : null);
        if (paisId) {
          try {
            await adicionarNacionalidade(id, paisId);
          } catch {
            // tolera duplicação
          }
        }
      }

      if (temData(dados.falecimento)) {
        await criarEvento({
          pessoa_id: id,
          tipo_evento: TIPOS_EVENTO.falecimento,
          data: dados.falecimento,
        });
      }

      if (dados.nome_completo?.trim()) {
        try {
          await adicionarNome({
            pessoa_id: id,
            tipo: 'nascimento',
            nome: dados.nome_completo.trim(),
            sobrenome: null,
            periodo: null,
          });
        } catch {
          // tolera duplicação/falha silenciosa para não travar a criação
        }
      }

      registrarAcao({
        descricao: `Criar ${dados.nome}`,
        desfazer: async () => {
          await removerPessoa(id);
          invalidarAcervo(queryClient);
        },
        refazer: async () => {
          await restaurarPessoa({
            id,
            nome: dados.nome,
            sobrenome: dados.sobrenome || null,
            sexo: dados.sexo,
            minibiografia: dados.minibiografia || null,
            is_vivo: dados.is_vivo,
            is_placeholder: false,
            foto_url: null,
          });
          invalidarAcervo(queryClient);
        },
      });

      return id;
    },
    onSuccess: () => invalidarAcervo(queryClient),
  });
}

export function useAtualizarPessoa() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: atualizarPessoa,
    onSuccess: () => invalidarAcervo(queryClient),
  });
}

/** Busca por nome ou sobrenome. Com termo vazio, devolve o começo do acervo. */
export function usePessoas(termo: string) {
  return useQuery({
    queryKey: ['pessoas', termo],
    queryFn: () => buscarPessoas(termo),
    staleTime: 30_000,
  });
}
