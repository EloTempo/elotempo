/**
 * Data e local do casamento, gravados **na união**.
 *
 * Existe por causa de um defeito: o programa oferecia "Casamento" só na ficha
 * da pessoa, onde o evento sai preso a um `pessoa_id`. O casamento ficava sendo
 * do marido *ou* da esposa, e a linha do tempo do outro não sabia dele.
 *
 * Um casamento é evento da união — a tabela `eventos` sempre soube disso, com
 * `pessoa_id` E `uniao_id` e um `CHECK` exigindo um dos dois. Gravando aqui, o
 * mesmo fato aparece na vida dos dois, que é o que ele é.
 */

import { useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { CalendarPlus, Church, Trash2 } from 'lucide-react';
import { Button } from '../../../components/ui/Button';
import { CampoDeData } from '../../../components/ui/CampoDeData';
import { SeletorDeLocal } from '../../person/components/SeletorDeLocal';
import {
  criarEvento,
  listarEventosUniao,
  removerEvento,
  ErroDoAcervo,
} from '../../../lib/api';
import { DATA_VAZIA, TIPOS_EVENTO, type DataEscolhida, type Place } from '../../../types';

interface CasamentoDaUniaoProps {
  uniaoId: string;
  /** Nome do cônjuge, só para a frase de ajuda. */
  conjuge: string;
}

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo || erro instanceof Error) return erro.message;
  return String(erro);
}

export function CasamentoDaUniao({ uniaoId, conjuge }: CasamentoDaUniaoProps) {
  const qc = useQueryClient();
  const [abrindo, setAbrindo] = useState(false);
  const [data, setData] = useState<DataEscolhida>({ ...DATA_VAZIA });
  const [local, setLocal] = useState<Place | null>(null);
  const [rotulo, setRotulo] = useState('');

  const { data: eventos, isLoading } = useQuery({
    queryKey: ['eventos-uniao', uniaoId],
    queryFn: () => listarEventosUniao(uniaoId),
  });

  // A linha do tempo dos dois cônjuges muda quando isto muda, e não há como
  // saber daqui quem são: invalidar a chave inteira é o certo.
  const invalidar = () => {
    qc.invalidateQueries({ queryKey: ['eventos-uniao', uniaoId] });
    qc.invalidateQueries({ queryKey: ['linha-pessoal'] });
  };

  const criar = useMutation({
    mutationFn: () =>
      criarEvento({
        uniao_id: uniaoId,
        tipo_evento: TIPOS_EVENTO.casamento,
        data,
        local_id: local?.id ?? null,
        rotulo_historico_livre: rotulo.trim() || null,
      }),
    onSuccess: () => {
      setAbrindo(false);
      setData({ ...DATA_VAZIA });
      setLocal(null);
      setRotulo('');
      invalidar();
    },
  });

  const remover = useMutation({
    mutationFn: (id: string) => removerEvento(id),
    onSuccess: invalidar,
  });

  const casamentos = (eventos ?? []).filter((e) => e.tipo_evento === TIPOS_EVENTO.casamento);
  const erro = mensagemDeErro(criar.error) ?? mensagemDeErro(remover.error);

  return (
    <div className="flex flex-col gap-1.5 pt-1.5 border-t border-borda">
      {erro && (
        <p role="alert" className="text-[11px] text-fem m-0">
          {erro}
        </p>
      )}

      {casamentos.map((e) => (
        <div key={e.id} className="flex items-start gap-1.5 text-xs text-tinta2">
          <Church className="w-3.5 h-3.5 flex-none mt-0.5 text-tinta3" />
          <span className="flex-1 min-w-0">
            {/* O texto do usuário, nunca o ano derivado. */}
            {e.data_texto ?? 'sem data'}
            {(e.local_nome || e.rotulo_historico_livre) && (
              <span className="text-tinta3">
                {' · '}
                {e.rotulo_historico_livre || e.local_nome}
              </span>
            )}
          </span>
          <button
            type="button"
            aria-label="Remover data do casamento"
            onClick={() => remover.mutate(e.id)}
            disabled={remover.isPending}
            className="flex-none text-tinta3 hover:text-fem transition-colors bg-transparent border-none cursor-pointer p-0"
          >
            <Trash2 className="w-3 h-3" />
          </button>
        </div>
      ))}

      {!isLoading && casamentos.length === 0 && !abrindo && (
        <button
          type="button"
          onClick={() => setAbrindo(true)}
          className="self-start text-[11px] text-tinta3 hover:text-acento transition-colors flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
        >
          <CalendarPlus className="w-3 h-3" />
          Registrar data do casamento
        </button>
      )}

      {abrindo && (
        <div className="flex flex-col gap-2 p-2 rounded-raio-s bg-sup border border-borda">
          <CampoDeData
            rotulo="Data do casamento"
            valor={data}
            aoMudar={setData}
            ajuda={`Aparece na linha do tempo de vocês dois — a sua e a de ${conjuge}.`}
          />
          <SeletorDeLocal
            local={local}
            onEscolher={setLocal}
            rotuloHistorico={rotulo}
            onMudarRotulo={setRotulo}
          />
          <div className="flex gap-2 justify-end">
            <Button size="sm" variant="ghost" onClick={() => setAbrindo(false)}>
              Cancelar
            </Button>
            <Button size="sm" onClick={() => criar.mutate()} disabled={criar.isPending}>
              {criar.isPending ? 'Salvando…' : 'Salvar'}
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}
