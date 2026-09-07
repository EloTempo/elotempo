import { useState } from 'react';
import { useMutation, useQueryClient, useQuery } from '@tanstack/react-query';
import { Plus, Save, Trash2, User, UserPlus, X } from 'lucide-react';
import { Modal } from '../../../components/ui/Modal';
import { Button } from '../../../components/ui/Button';
import { Input } from '../../../components/ui/Input';
import { Select } from '../../../components/ui/Select';
import { CampoDeData, previaDoTexto } from '../../../components/ui/CampoDeData';
import {
  criarMarco,
  atualizarMarco,
  deletarMarco,
  buscarParticipantesMarco,
  adicionarParticipante,
  removerParticipante,
  listarLinhasDeContexto,
} from '../../../lib/api';
import { buscarPessoas } from '../../../lib/api/tree';
import { DATA_VAZIA, type DataEscolhida, type PersonNode } from '../../../types';

interface EditorMarcoProps {
  idOpcional?: string;
  linhaId?: string;
  valoresIniciais?: {
    linha_id?: string;
    data_periodo_texto: string;
    titulo: string;
    descricao?: string | null;
    relevancia: string;
    fonte_especifica?: string | null;
    ano_inicio?: number | null;
    ano_fim?: number | null;
  };
  onClose: () => void;
  onSuccess: (id: string) => void;
}

const OPCOES_RELEVANCIA = [
  { value: 'alta', label: 'Alta (Sempre visível na gaveta)' },
  { value: 'media', label: 'Média (Visível ao aproximar zoom)' },
  { value: 'detalhe', label: 'Detalhe (Apenas consulta pontual)' },
];

function dataInicialDe(valores?: EditorMarcoProps['valoresIniciais']): DataEscolhida {
  if (!valores) {
    return { ...DATA_VAZIA, qualificador: 'exata', ano: new Date().getFullYear() };
  }
  if (valores.ano_inicio != null) {
    if (valores.ano_fim != null && valores.ano_fim !== valores.ano_inicio) {
      return {
        ...DATA_VAZIA,
        qualificador: 'intervalo',
        ano: valores.ano_inicio,
        ano_fim: valores.ano_fim,
      };
    }
    return {
      ...DATA_VAZIA,
      qualificador: 'exata',
      ano: valores.ano_inicio,
    };
  }
  if (valores.data_periodo_texto) {
    return {
      ...DATA_VAZIA,
      qualificador: 'livre',
      texto_livre: valores.data_periodo_texto,
    };
  }
  return { ...DATA_VAZIA, qualificador: 'exata' };
}

export function EditorMarco({
  idOpcional,
  linhaId: linhaIdProp,
  valoresIniciais,
  onClose,
  onSuccess,
}: EditorMarcoProps) {
  const qc = useQueryClient();

  const { data: todasLinhas } = useQuery({
    queryKey: ['linhas-de-contexto'],
    queryFn: listarLinhasDeContexto,
  });

  const linhasUsuario = todasLinhas?.filter((l) => !l.is_bloqueada) ?? [];
  const [linhaSelecionada, setLinhaSelecionada] = useState<string>(
    linhaIdProp ?? valoresIniciais?.linha_id ?? linhasUsuario[0]?.id ?? ''
  );

  // Estado da data estruturada (menus suspensos)
  const [dataEscolhida, setDataEscolhida] = useState<DataEscolhida>(() =>
    dataInicialDe(valoresIniciais)
  );

  // Participantes
  const [novosParticipantes, setNovosParticipantes] = useState<
    { pessoaId: string; nome: string; papel: string }[]
  >([]);
  const [busca, setBusca] = useState('');
  const [pessoaSelecionada, setPessoaSelecionada] = useState<PersonNode | null>(null);
  const [papelAtual, setPapelAtual] = useState('');

  // Participantes do banco para marco existente
  const { data: participantesSalvos } = useQuery({
    queryKey: ['marco-participantes', idOpcional],
    queryFn: () => buscarParticipantesMarco(idOpcional!),
    enabled: !!idOpcional,
  });

  const { data: resultadosBusca } = useQuery({
    queryKey: ['busca-pessoas-modal', busca],
    queryFn: () => buscarPessoas(busca, 8),
    enabled: busca.trim().length >= 2 && !pessoaSelecionada,
  });

  const mRemoverParticipante = useMutation({
    mutationFn: (id: string) => removerParticipante(id),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['marco-participantes', idOpcional] }),
  });

  const mAdicionarParticipante = useMutation({
    mutationFn: (v: { marco_id: string; pessoa_id: string; papel: string }) =>
      adicionarParticipante({
        marco_id: v.marco_id,
        pessoa_id: v.pessoa_id,
        papel: v.papel || null,
        visivel_na_pessoa: true,
      }),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['marco-participantes', idOpcional] }),
  });

  const handleIncluirParticipante = () => {
    if (!pessoaSelecionada) return;
    const nomeCompleto = `${pessoaSelecionada.nome} ${pessoaSelecionada.sobrenome ?? ''}`.trim();
    const papel = papelAtual.trim();

    if (idOpcional) {
      mAdicionarParticipante.mutate({
        marco_id: idOpcional,
        pessoa_id: pessoaSelecionada.id,
        papel,
      });
    } else {
      if (!novosParticipantes.find((x) => x.pessoaId === pessoaSelecionada.id)) {
        setNovosParticipantes([
          ...novosParticipantes,
          { pessoaId: pessoaSelecionada.id, nome: nomeCompleto, papel },
        ]);
      }
    }
    setPessoaSelecionada(null);
    setPapelAtual('');
    setBusca('');
  };

  const mCriar = useMutation({
    mutationFn: async (v: any) => {
      const marcoId = await criarMarco(v);
      for (const part of novosParticipantes) {
        await adicionarParticipante({
          marco_id: marcoId,
          pessoa_id: part.pessoaId,
          papel: part.papel || null,
          visivel_na_pessoa: true,
        });
      }
      return marcoId;
    },
    onSuccess: (id) => {
      qc.invalidateQueries({ queryKey: ['marcos'] });
      qc.invalidateQueries({ queryKey: ['marco-participantes', id] });
      onSuccess(id);
    },
  });

  const mAtualizar = useMutation({
    mutationFn: (v: any) => atualizarMarco(idOpcional!, v),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['marcos'] });
      onSuccess(idOpcional!);
    },
  });

  const mDeletar = useMutation({
    mutationFn: () => deletarMarco(idOpcional!),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['marcos'] });
      onSuccess('');
    },
  });

  const onSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const data = new FormData(e.currentTarget);
    const textoData = previaDoTexto(dataEscolhida) || 'Sem data';

    const v = {
      linha_id: linhaSelecionada,
      data_periodo_texto: textoData,
      titulo: (data.get('titulo') as string).trim(),
      descricao: (data.get('descricao') as string)?.trim() || null,
      relevancia: data.get('relevancia') as string,
      fonte_especifica: (data.get('fonte_especifica') as string)?.trim() || null,
      ano_inicio: dataEscolhida.ano ?? null,
      ano_fim:
        dataEscolhida.qualificador === 'intervalo'
          ? (dataEscolhida.ano_fim ?? dataEscolhida.ano ?? null)
          : (dataEscolhida.ano ?? null),
    };

    if (idOpcional) mAtualizar.mutate(v);
    else mCriar.mutate(v);
  };

  return (
    <Modal
      isOpen={true}
      onClose={onClose}
      title={idOpcional ? 'Editar Marco na Linha do Tempo' : 'Novo Marco na Linha do Tempo'}
      className="max-w-xl"
    >
      <form onSubmit={onSubmit} className="flex flex-col gap-4">
        {!linhaIdProp && linhasUsuario.length > 0 && (
          <Select
            label="Linha do Tempo de Destino"
            options={linhasUsuario.map((l) => ({ value: l.id, label: l.titulo }))}
            value={linhaSelecionada}
            onChange={(e) => setLinhaSelecionada(e.target.value)}
          />
        )}

        <Input
          name="titulo"
          label="Título do Acontecimento"
          placeholder="Ex: Fundação da Fazenda Santa Clara, Chegada ao Porto de Santos..."
          defaultValue={valoresIniciais?.titulo ?? ''}
          required
          autoFocus
        />

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 items-start">
          {/* Menu suspenso de data estruturada com suporte a AC/DC */}
          <CampoDeData
            rotulo="Data / Período do Acontecimento"
            valor={dataEscolhida}
            aoMudar={setDataEscolhida}
            ajuda="Anos negativos representam o período Antes de Cristo (a.C.)."
          />

          <Select
            name="relevancia"
            label="Relevância no Eixo"
            options={OPCOES_RELEVANCIA}
            defaultValue={valoresIniciais?.relevancia ?? 'alta'}
          />
        </div>

        <div className="flex flex-col gap-1">
          <label className="block text-sm font-semibold text-tinta2">
            Descrição detalhada (Opcional)
          </label>
          <textarea
            name="descricao"
            rows={3}
            defaultValue={valoresIniciais?.descricao ?? ''}
            placeholder="Detalhes, memórias familiares e contexto deste acontecimento..."
            className="flex w-full rounded-raio-s border border-borda bg-card px-3 py-2 text-sm text-tinta placeholder:text-tinta3 focus:outline-none focus:ring-2 focus:ring-acento/50 resize-none"
          />
        </div>

        <Input
          name="fonte_especifica"
          label="Fonte ou Documento de Referência"
          placeholder="Ex: Certidão de óbito, Diário de bordo, Livro de Tombo..."
          defaultValue={valoresIniciais?.fonte_especifica ?? ''}
        />

        {/* ----- SEÇÃO DE PARTICIPANTES ----- */}
        <div className="mt-2 pt-4 border-t border-borda flex flex-col gap-3">
          <div className="flex items-center justify-between">
            <span className="text-sm font-semibold text-tinta flex items-center gap-1.5">
              <UserPlus className="w-4 h-4 text-acento" />
              Pessoas Participantes
            </span>
            <span className="text-xs text-tinta3">
              Quem esteve presente ou fez parte deste marco
            </span>
          </div>

          {/* Lista de participantes já vinculados */}
          <div className="flex flex-col gap-1.5 max-h-36 overflow-y-auto">
            {idOpcional ? (
              participantesSalvos && participantesSalvos.length > 0 ? (
                participantesSalvos.map((p) => (
                  <div
                    key={p.id}
                    className="flex items-center justify-between px-3 py-1.5 bg-sup border border-borda rounded-raio-s text-sm"
                  >
                    <div className="flex items-center gap-2">
                      <span className="font-semibold text-tinta">{p.nome}</span>
                      {p.papel && (
                        <span className="text-xs text-tinta3 bg-card px-1.5 py-0.5 rounded border border-borda2">
                          {p.papel}
                        </span>
                      )}
                    </div>
                    <button
                      type="button"
                      onClick={() => mRemoverParticipante.mutate(p.id)}
                      className="text-fem hover:underline text-xs flex items-center gap-0.5 p-1 cursor-pointer"
                      title="Remover participante"
                    >
                      <X className="w-3.5 h-3.5" />
                      Remover
                    </button>
                  </div>
                ))
              ) : (
                <p className="text-xs text-tinta3 italic py-1">Nenhum participante associado ainda.</p>
              )
            ) : novosParticipantes.length > 0 ? (
              novosParticipantes.map((p) => (
                <div
                  key={p.pessoaId}
                  className="flex items-center justify-between px-3 py-1.5 bg-sup border border-borda rounded-raio-s text-sm"
                >
                  <div className="flex items-center gap-2">
                    <span className="font-semibold text-tinta">{p.nome}</span>
                    {p.papel && (
                      <span className="text-xs text-tinta3 bg-card px-1.5 py-0.5 rounded border border-borda2">
                        {p.papel}
                      </span>
                    )}
                  </div>
                  <button
                    type="button"
                    onClick={() =>
                      setNovosParticipantes((n) => n.filter((x) => x.pessoaId !== p.pessoaId))
                    }
                    className="text-fem hover:underline text-xs flex items-center gap-0.5 p-1 cursor-pointer"
                  >
                    <X className="w-3.5 h-3.5" />
                    Remover
                  </button>
                </div>
              ))
            ) : (
              <p className="text-xs text-tinta3 italic py-1">Nenhum participante associado ainda.</p>
            )}
          </div>

          {/* Controles para selecionar pessoa, definir papel e clicar em Incluir */}
          <div className="p-2.5 rounded-raio-s border border-borda bg-card2/50 flex flex-col gap-2">
            <span className="text-[11px] font-semibold text-tinta2 uppercase tracking-wide">
              Adicionar Participante
            </span>

            <div className="flex flex-col sm:flex-row gap-2 items-center">
              {/* Seletor de Pessoa */}
              <div className="flex-1 w-full relative">
                {pessoaSelecionada ? (
                  <div className="flex items-center justify-between h-9 px-3 rounded-raio-s border border-acento/50 bg-acento/10 text-sm">
                    <span className="font-semibold text-tinta flex items-center gap-1.5 truncate">
                      <User className="w-3.5 h-3.5 text-acento flex-none" />
                      <span className="truncate">
                        {pessoaSelecionada.nome} {pessoaSelecionada.sobrenome}
                      </span>
                    </span>
                    <button
                      type="button"
                      onClick={() => setPessoaSelecionada(null)}
                      className="text-xs text-tinta3 hover:text-tinta ml-2 p-0.5 flex-none"
                      title="Escolher outra pessoa"
                    >
                      <X className="w-3.5 h-3.5" />
                    </button>
                  </div>
                ) : (
                  <>
                    <input
                      type="text"
                      placeholder="1. Buscar parente na árvore..."
                      value={busca}
                      onChange={(e) => setBusca(e.target.value)}
                      className="flex h-9 w-full rounded-raio-s border border-borda bg-card px-3 py-1.5 text-sm text-tinta placeholder:text-tinta3 focus:outline-none focus:ring-2 focus:ring-acento/50"
                    />

                    {resultadosBusca && resultadosBusca.length > 0 && busca.trim().length >= 2 && (
                      <div className="absolute top-10 left-0 w-full bg-card border border-borda rounded-raio shadow-sombra py-1 z-50 max-h-48 overflow-y-auto">
                        {resultadosBusca.map((r) => (
                          <button
                            key={r.id}
                            type="button"
                            onClick={() => {
                              setPessoaSelecionada(r);
                              setBusca('');
                            }}
                            className="w-full text-left px-3 py-2 text-sm hover:bg-sup text-tinta flex items-center justify-between transition-colors cursor-pointer gap-2 border-b border-borda/40 last:border-b-0"
                          >
                            <div className="flex flex-col min-w-0 flex-1">
                              <span className="font-semibold text-xs text-tinta truncate">
                                {r.nome} {r.sobrenome}
                              </span>
                              <span className="text-[10px] text-tinta3 truncate">
                                {r.ano_nascimento ? `* ${r.ano_nascimento}` : ''}{' '}
                                {r.ano_falecimento ? `✝ ${r.ano_falecimento}` : r.is_vivo ? '• vivo' : ''}{' '}
                                {r.arvore_nome ? `• ${r.arvore_nome}` : ''}
                              </span>
                            </div>
                            <span className="text-xs text-acento font-semibold flex-none px-2 py-0.5 rounded bg-acento/10">
                              + Escolher
                            </span>
                          </button>
                        ))}
                      </div>
                    )}
                  </>
                )}
              </div>

              {/* Campo do Papel */}
              <div className="flex-1 w-full">
                <input
                  type="text"
                  list="sugestoes-papeis"
                  placeholder="2. Papel (Fundador, Testemunha...)"
                  value={papelAtual}
                  onChange={(e) => setPapelAtual(e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter') {
                      e.preventDefault();
                      handleIncluirParticipante();
                    }
                  }}
                  className="flex h-9 w-full rounded-raio-s border border-borda bg-card px-3 py-1.5 text-sm text-tinta placeholder:text-tinta3 focus:outline-none focus:ring-2 focus:ring-acento/50"
                />
                <datalist id="sugestoes-papeis">
                  <option value="Fundador" />
                  <option value="Testemunha" />
                  <option value="Presente" />
                  <option value="Noivo / Noiva" />
                  <option value="Padrinho / Madrinha" />
                  <option value="Homenageado" />
                  <option value="Organizador" />
                  <option value="Participante" />
                </datalist>
              </div>

              {/* Botão Incluir explícito */}
              <Button
                type="button"
                variant="secondary"
                size="sm"
                disabled={!pessoaSelecionada}
                onClick={handleIncluirParticipante}
                className="h-9 px-4 flex-none gap-1 font-semibold"
              >
                <Plus className="w-4 h-4" />
                Incluir
              </Button>
            </div>
          </div>
        </div>

        {/* Ações do Formulário */}
        <div className="mt-4 flex items-center justify-between pt-4 border-t border-borda gap-3">
          {idOpcional ? (
            <Button
              type="button"
              variant="outline"
              size="sm"
              className="text-fem border-fem/40 hover:bg-fem/10"
              onClick={() => {
                if (confirm('Tem certeza de que deseja apagar este marco?')) {
                  mDeletar.mutate();
                }
              }}
              disabled={mDeletar.isPending}
            >
              <Trash2 className="w-4 h-4 mr-1.5" />
              Excluir Marco
            </Button>
          ) : <div />}

          <div className="flex items-center gap-2 ml-auto">
            <Button type="button" variant="ghost" size="sm" onClick={onClose}>
              Cancelar
            </Button>
            <Button
              type="submit"
              variant="primary"
              size="sm"
              disabled={mCriar.isPending || mAtualizar.isPending || !linhaSelecionada}
            >
              <Save className="w-4 h-4 mr-1.5" />
              {idOpcional ? 'Salvar Alterações' : 'Salvar Marco'}
            </Button>
          </div>
        </div>
      </form>
    </Modal>
  );
}
