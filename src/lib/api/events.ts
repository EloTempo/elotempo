import { chamar } from './index';
import type { Event, NewEvent } from '../../types';

/**
 * Cria o evento.
 *
 * A data é texto livre: o backend interpreta e preenche `data_qualificador`,
 * `ano_inicio` e `ano_fim`, mas o que o usuário escreveu fica intacto em
 * `data_texto`. Evento sem data é aceito — a regra da seção 2.5 é que a data
 * nunca bloqueia o salvamento.
 */
export const criarEvento = (novo: NewEvent): Promise<string> =>
  chamar<string>('criar_evento', { novo });

export const atualizarEvento = (evento: Event): Promise<void> =>
  chamar<void>('atualizar_evento', { evento });

export const removerEvento = (id: string): Promise<void> =>
  chamar<void>('remover_evento', { id });

/** Eventos da pessoa, já em ordem cronológica (sem data vai para o fim). */
export const listarEventosPessoa = (pessoaId: string): Promise<Event[]> =>
  chamar<Event[]>('listar_eventos_pessoa', { pessoaId });
