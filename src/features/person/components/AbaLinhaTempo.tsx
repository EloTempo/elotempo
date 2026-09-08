import { useState } from 'react';
import {
  Calendar,
  Compass,
  Plus,
  Trash2,
  Eye,
  EyeOff,
  MapPin,
} from 'lucide-react';
import { Button } from '../../../components/ui/Button';
import { CampoDeData } from '../../../components/ui/CampoDeData';
import { CampoCurto } from './SecaoAtributo';
import { SeletorDeLocal } from './SeletorDeLocal';
import {
  useCriarEvento,
  useRemoverEvento,
  useParticipacoesPessoa,
  useToggleVisibilidadeParticipacao,
  useRemoverParticipacao,
} from '../hooks/useFicha';
import { TIPOS_DE_EVENTO, rotuloDoTipo } from '../taxonomias';
import { DATA_VAZIA, type DataEscolhida, type Event, type Place } from '../../../types';

interface AbaLinhaTempoProps {
  pessoaId: string;
  nomePessoa: string;
  eventos: Event[];
  onAbrirVincularMarco: () => void;
  formularioCriarAberto?: boolean;
  onAlternarFormularioCriar?: () => void;
}

export function AbaLinhaTempo({
  pessoaId,
  nomePessoa,
  eventos,
  onAbrirVincularMarco,
  formularioCriarAberto: formAbertoProp,
  onAlternarFormularioCriar,
}: AbaLinhaTempoProps) {
  const [formLocalAberto, setFormLocalAberto] = useState(false);
  const formAberto = formAbertoProp !== undefined ? formAbertoProp : formLocalAberto;
  const toggleForm = onAlternarFormularioCriar ?? (() => setFormLocalAberto((a) => !a));

  const criarEvento = useCriarEvento(pessoaId);
  const removerEvento = useRemoverEvento(pessoaId);

  const { data: participacoes } = useParticipacoesPessoa(pessoaId);
  const toggleVisibilidadePart = useToggleVisibilidadeParticipacao(pessoaId);
  const removerPart = useRemoverParticipacao(pessoaId);

  // Estado do formulário de novo evento
  const [novoEvento, setNovoEvento] = useState({ tipo: 'nascimento', local: '', nota: '' });
  const [dataDoEvento, setDataDoEvento] = useState<DataEscolhida>({ ...DATA_VAZIA });
  const [localDoEvento, setLocalDoEvento] = useState<Place | null>(null);

  // Unificar eventos e participações em um fluxo cronológico
  type ItemLinhaTempo =
    | { tipo: 'evento'; id: string; ano: number; item: Event }
    | { tipo: 'participacao'; id: string; ano: number; item: NonNullable<typeof participacoes>[number] };

  const itensCronologicos: ItemLinhaTempo[] = [
    ...eventos.map((e) => ({
      tipo: 'evento' as const,
      id: `ev-${e.id}`,
      ano: e.ano_inicio ?? 9999,
      item: e,
    })),
    ...(participacoes ?? []).map((p) => ({
      tipo: 'participacao' as const,
      id: `part-${p.id}`,
      ano: p.ano_inicio ?? 9999,
      item: p,
    })),
  ].sort((a, b) => a.ano - b.ano);

  const handleSalvarEvento = (e: React.FormEvent) => {
    e.preventDefault();
    criarEvento.mutate(
      {
        pessoa_id: pessoaId,
        tipo_evento: novoEvento.tipo,
        data: dataDoEvento,
        local_id: localDoEvento?.id ?? null,
        rotulo_historico_livre: novoEvento.local.trim() || null,
        nota: novoEvento.nota.trim() || null,
      },
      {
        onSuccess: () => {
          setNovoEvento({ tipo: 'nascimento', local: '', nota: '' });
          setDataDoEvento({ ...DATA_VAZIA });
          setLocalDoEvento(null);
          toggleForm();
        },
      },
    );
  };

  return (
    <div className="flex flex-col gap-4">
      {/* Barra de Ações Superior */}
      <div className="flex items-center justify-between gap-2 flex-wrap p-3.5 rounded-raio bg-card border border-borda shadow-2xs">
        <div>
          <h3 className="font-tit font-bold text-sm text-tinta m-0">
            Linha do Tempo & Marcos Históricos
          </h3>
          <span className="text-[11px] text-tinta3">
            História de vida cronológica integrada aos acontecimentos do mundo
          </span>
        </div>
        <div className="flex items-center gap-2 flex-wrap">
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={onAbrirVincularMarco}
            className="text-xs text-acento border-acento/30 hover:bg-acento/10 cursor-pointer"
          >
            <Compass className="w-3.5 h-3.5" />
            Vincular Marco
          </Button>
          <Button
            type="button"
            size="sm"
            onClick={toggleForm}
            className="text-xs font-semibold cursor-pointer"
          >
            <Plus className="w-3.5 h-3.5" />
            {formAberto ? 'Fechar Formulário' : 'Evento de Vida'}
          </Button>
        </div>
      </div>

      {/* Formulário Expansível de Novo Evento */}
      {formAberto && (
        <form
          onSubmit={handleSalvarEvento}
          className="p-4 rounded-raio bg-card2 border border-acento/30 shadow-xs flex flex-col gap-3"
        >
          <div className="flex items-center justify-between border-b border-borda/40 pb-2">
            <span className="font-tit font-bold text-xs text-tinta">Novo Evento de Vida</span>
            <span className="text-[10.5px] text-tinta3">Apenas o tipo é obrigatório</span>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <label className="flex flex-col gap-1">
              <span className="text-[11px] font-medium text-tinta2">Tipo de Evento</span>
              <select
                value={novoEvento.tipo}
                onChange={(e) => setNovoEvento({ ...novoEvento, tipo: e.target.value })}
                className="text-sm px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta focus:outline-none focus:border-acento"
              >
                {TIPOS_DE_EVENTO.map((t) => (
                  <option key={t.valor} value={t.valor}>
                    {t.rotulo}
                  </option>
                ))}
              </select>
            </label>

            <CampoDeData rotulo="Data" valor={dataDoEvento} aoMudar={setDataDoEvento} />
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <SeletorDeLocal
              local={localDoEvento}
              onEscolher={setLocalDoEvento}
              rotuloHistorico={novoEvento.local}
              onMudarRotulo={(v) => setNovoEvento({ ...novoEvento, local: v })}
            />
            <CampoCurto
              rotulo="Nota / Observação"
              valor={novoEvento.nota}
              aoMudar={(v) => setNovoEvento({ ...novoEvento, nota: v })}
              placeholder="Ex: Igreja Matriz, testemunhas, causas…"
            />
          </div>

          <div className="flex justify-end gap-2 pt-2 border-t border-borda/40">
            <Button type="button" variant="outline" size="sm" onClick={toggleForm}>
              Cancelar
            </Button>
            <Button type="submit" size="sm" disabled={criarEvento.isPending}>
              {criarEvento.isPending ? 'Salvando…' : 'Salvar Evento'}
            </Button>
          </div>
        </form>
      )}

      {/* Fluxo Cronológico */}
      {itensCronologicos.length === 0 ? (
        <div className="p-8 text-center rounded-raio border border-dashed border-borda bg-card shadow-2xs flex flex-col items-center gap-2">
          <Calendar className="w-8 h-8 text-tinta3 opacity-40" />
          <h4 className="text-sm font-semibold text-tinta m-0">Nenhum marco cronológico registrado</h4>
          <p className="text-xs text-tinta3 max-w-sm m-0 leading-relaxed">
            Adicione nascimentos, batismos, casamentos ou vincule acontecimentos históricos mundiais para enriquecer a narrativa desta pessoa.
          </p>
          <div className="flex gap-2 mt-2">
            <Button type="button" size="sm" onClick={toggleForm}>
              <Plus className="w-3.5 h-3.5" />
              Adicionar Primeiro Evento
            </Button>
          </div>
        </div>
      ) : (
        <div className="relative pl-6 before:content-[''] before:absolute before:left-2.5 before:top-2 before:bottom-2 before:w-0.5 before:bg-borda">
          <div className="flex flex-col gap-3">
            {itensCronologicos.map((item) => {
              if (item.tipo === 'evento') {
                const ev = item.item;
                const local = ev.rotulo_historico_livre || ev.local_nome;

                return (
                  <div key={item.id} className="relative group">
                    {/* Marcador na linha vertical */}
                    <div className="absolute -left-6 top-3 w-3 h-3 rounded-full bg-acento border-2 border-card shadow-xs" />

                    <div className="p-3 rounded-raio-s bg-card border border-borda hover:border-acento/50 transition-colors shadow-2xs flex items-start justify-between gap-3">
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-2 flex-wrap">
                          <span className="text-xs font-bold text-tinta">
                            {rotuloDoTipo(ev.tipo_evento)}
                          </span>
                          <span className="font-num text-xs font-medium px-2 py-0.5 rounded bg-acento/10 text-acento border border-acento/20">
                            {ev.data_texto || (ev.ano_inicio ? String(ev.ano_inicio) : 'Sem data')}
                          </span>
                        </div>

                        {local && (
                          <div className="flex items-center gap-1 text-[11px] text-tinta3 mt-1">
                            <MapPin className="w-3 h-3 text-acento/70 flex-none" />
                            <span className="truncate">{local}</span>
                          </div>
                        )}

                        {ev.nota && (
                          <p className="text-xs text-tinta2 italic m-0 mt-1 leading-snug">
                            “{ev.nota}”
                          </p>
                        )}
                      </div>

                      <button
                        type="button"
                        onClick={() => {
                          if (confirm(`Remover evento de ${rotuloDoTipo(ev.tipo_evento)}?`)) {
                            removerEvento.mutate(ev.id);
                          }
                        }}
                        disabled={removerEvento.isPending}
                        className="opacity-0 group-hover:opacity-100 p-1 text-tinta3 hover:text-fem transition-all rounded hover:bg-sup border-none bg-transparent cursor-pointer"
                        title="Remover evento"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  </div>
                );
              }

              // Participação em marco histórico
              const part = item.item;

              return (
                <div key={item.id} className="relative group">
                  {/* Marcador na linha vertical com ícone de marco */}
                  <div className="absolute -left-6 top-3 w-3 h-3 rounded-full bg-purple-600 border-2 border-card shadow-xs" />

                  <div className="p-3 rounded-raio-s bg-sup/40 border border-purple-500/20 hover:border-purple-500/40 transition-colors shadow-2xs flex items-start justify-between gap-3">
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap">
                        <span className="text-xs font-bold text-tinta truncate">
                          🏛️ {part.titulo}
                        </span>
                        <span className="text-[10px] px-1.5 py-0.5 rounded bg-purple-500/10 text-purple-700 dark:text-purple-300 font-medium border border-purple-500/20">
                          {part.linha_titulo}
                        </span>
                        {part.papel && (
                          <span className="text-[10px] px-1.5 py-0.5 rounded bg-acento/10 text-acento font-medium border border-acento/20">
                            Papel: {part.papel}
                          </span>
                        )}
                      </div>

                      <div className="flex items-center gap-3 font-num text-[11px] text-tinta3 mt-1">
                        <span>
                          {part.data_periodo_texto || (part.ano_inicio ? String(part.ano_inicio) : 'Sem data')}
                        </span>
                        {!part.visivel_na_pessoa && (
                          <span className="text-fem font-sans italic text-[10.5px]">
                            (Oculto na linha do tempo principal)
                          </span>
                        )}
                      </div>
                    </div>

                    <div className="flex items-center gap-1 flex-none">
                      <button
                        type="button"
                        title={
                          part.visivel_na_pessoa
                            ? 'Visível na timeline (clique para ocultar)'
                            : 'Oculto da timeline (clique para exibir)'
                        }
                        onClick={() =>
                          toggleVisibilidadePart.mutate({
                            id: part.id,
                            visivel: !part.visivel_na_pessoa,
                          })
                        }
                        className="p-1 text-tinta3 hover:text-acento transition-colors cursor-pointer rounded hover:bg-card border-none bg-transparent"
                      >
                        {part.visivel_na_pessoa ? (
                          <Eye className="w-3.5 h-3.5 text-emerald-600" />
                        ) : (
                          <EyeOff className="w-3.5 h-3.5 text-tinta3" />
                        )}
                      </button>
                      <button
                        type="button"
                        title="Desvincular marco"
                        onClick={() => {
                          if (confirm(`Desvincular ${nomePessoa} do marco "${part.titulo}"?`)) {
                            removerPart.mutate(part.id);
                          }
                        }}
                        className="p-1 text-tinta3 hover:text-fem transition-colors cursor-pointer rounded hover:bg-card border-none bg-transparent"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}
