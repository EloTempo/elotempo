import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import {
  Check,
  Edit2,
  Plus,
  Trash2,
  User,
  X,
  AlertTriangle,
  Search,
} from 'lucide-react';
import { IconeArvore } from '../../../components/icons';
import { Modal } from '../../../components/ui/Modal';
import { useGatekeeper } from '../../security';
import { useI18n } from '../../../i18n/I18nContext';
import { Button } from '../../../components/ui/Button';
import { Input } from '../../../components/ui/Input';
import {
  listarArvores,
  criarArvore,
  atualizarArvore,
  deletarArvore,
  buscarPessoasFiltrado,
  type ArvoreInfo,
} from '../../../lib/api';
import type { PersonNode } from '../../../types';

interface ModalGerenciarArvoresProps {
  isOpen: boolean;
  onClose: () => void;
  arvoreAtivaId: string | null;
  onSelecionarArvore: (arvore: ArvoreInfo) => void;
}

export function ModalGerenciarArvores({
  isOpen,
  onClose,
  arvoreAtivaId,
  onSelecionarArvore,
}: ModalGerenciarArvoresProps) {
  const { t } = useI18n();
  const { executarComGatekeeper } = useGatekeeper();
  const qc = useQueryClient();
  const [editando, setEditando] = useState<ArvoreInfo | 'nova' | null>(null);
  const [nome, setNome] = useState('');
  const [descricao, setDescricao] = useState('');
  const [categoria, setCategoria] = useState('');
  const [pais, setPais] = useState('');
  const [periodo, setPeriodo] = useState('');
  const [raizPessoaId, setRaizPessoaId] = useState<string | null>(null);
  const [buscaPessoa, setBuscaPessoa] = useState('');
  const [buscaArvore, setBuscaArvore] = useState('');
  const [abaFiltro, setAbaFiltro] = useState<'publicas' | 'pessoais' | 'todas'>('publicas');
  const [pessoaEscolhida, setPessoaEscolhida] = useState<{ id: string; nome: string } | null>(null);
  const [erroForm, setErroForm] = useState<string | null>(null);
  const [confirmarExclusaoId, setConfirmarExclusaoId] = useState<string | null>(null);

  const { data: arvores, isLoading } = useQuery({
    queryKey: ['arvores'],
    queryFn: listarArvores,
    enabled: isOpen,
  });

  const { data: buscaResultados } = useQuery({
    queryKey: ['busca-pessoa-raiz', buscaPessoa],
    queryFn: () => buscarPessoasFiltrado({ texto: buscaPessoa, incluir_placeholders: false }, 6),
    enabled: buscaPessoa.trim().length >= 2,
  });

  const criarMut = useMutation({
    mutationFn: criarArvore,
    onSuccess: (nova) => {
      qc.invalidateQueries({ queryKey: ['arvores'] });
      setEditando(null);
      onSelecionarArvore(nova);
    },
    onError: (err: any) => setErroForm(err.message || 'Erro ao criar árvore'),
  });

  const atualizarMut = useMutation({
    mutationFn: atualizarArvore,
    onSuccess: (atualizada) => {
      qc.invalidateQueries({ queryKey: ['arvores'] });
      setEditando(null);
      if (arvoreAtivaId === atualizada.id) {
        onSelecionarArvore(atualizada);
      }
    },
    onError: (err: any) => setErroForm(err.message || 'Erro ao atualizar árvore'),
  });

  const deletarMut = useMutation({
    mutationFn: ({ id, ticket }: { id: string; ticket?: string | null }) => deletarArvore(id, ticket),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['arvores'] });
      setConfirmarExclusaoId(null);
    },
    onError: (err: any) => setErroForm(err.message || 'Erro ao excluir árvore'),
  });

  const iniciarCriacao = () => {
    setNome('');
    setDescricao('');
    setCategoria('');
    setPais('');
    setPeriodo('');
    setRaizPessoaId(null);
    setPessoaEscolhida(null);
    setBuscaPessoa('');
    setErroForm(null);
    setEditando('nova');
  };

  const iniciarEdicao = (a: ArvoreInfo) => {
    setNome(a.nome);
    setDescricao(a.descricao ?? '');
    setCategoria(a.categoria ?? '');
    setPais(a.pais ?? '');
    setPeriodo(a.periodo ?? '');
    setRaizPessoaId(a.raiz_pessoa_id ?? null);
    setPessoaEscolhida(
      a.raiz_pessoa_id && a.raiz_pessoa_nome
        ? { id: a.raiz_pessoa_id, nome: a.raiz_pessoa_nome }
        : null,
    );
    setBuscaPessoa('');
    setErroForm(null);
    setEditando(a);
  };

  const salvar = (e: React.FormEvent) => {
    e.preventDefault();
    setErroForm(null);
    const n = nome.trim();
    if (!n) {
      setErroForm('O nome da árvore é obrigatório.');
      return;
    }

    if (editando === 'nova') {
      criarMut.mutate({
        nome: n,
        descricao: descricao.trim() || null,
        raiz_pessoa_id: raizPessoaId,
        categoria: categoria.trim() || null,
        pais: pais.trim() || null,
        periodo: periodo.trim() || null,
      });
    } else if (editando && typeof editando === 'object') {
      atualizarMut.mutate({
        id: editando.id,
        nome: n,
        descricao: descricao.trim() || null,
        raiz_pessoa_id: raizPessoaId,
        categoria: categoria.trim() || null,
        pais: pais.trim() || null,
        periodo: periodo.trim() || null,
      });
    }
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Gerenciar Árvores Genealógicas"
      className="max-w-2xl"
    >
      <div className="flex flex-col gap-4">
        <p className="text-xs text-tinta2 m-0 leading-relaxed">
          Cada árvore representa uma <strong>visão nomeada e enraizada</strong> do acervo comum.
          Pessoas e uniões podem pertencer a várias árvores ao mesmo tempo. Excluir uma árvore remove apenas a visão, preservando todos os parentes intactos no banco de dados.
        </p>

        {/* Formulário de Criação / Edição */}
        {editando && (
          <form
            onSubmit={salvar}
            className="p-4 rounded-raio border border-acento/30 bg-card flex flex-col gap-3 shadow-xs animate-in fade-in duration-150"
          >
            <div className="flex items-center justify-between border-b border-borda/60 pb-2">
              <h4 className="font-semibold text-sm text-tinta flex items-center gap-1.5 m-0">
                <IconeArvore className="w-4 h-4 text-acento" />
                {editando === 'nova' ? 'Nova Árvore' : `Editar "${editando.nome}"`}
              </h4>
              <button
                type="button"
                onClick={() => setEditando(null)}
                className="text-tinta3 hover:text-tinta p-1 rounded hover:bg-sup cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {erroForm && (
              <p className="text-xs text-fem bg-fem/10 p-2 rounded border border-fem/20 m-0">
                {erroForm}
              </p>
            )}

            <div className="flex flex-col gap-1">
              <label className="text-xs font-semibold text-tinta">Nome da árvore *</label>
              <Input
                placeholder="Ex.: Família Silva, Ramo Materno, Linhagem Real..."
                value={nome}
                onChange={(e) => setNome(e.target.value)}
                required
                autoFocus
              />
            </div>

            <div className="flex flex-col gap-1">
              <label className="text-xs font-semibold text-tinta">Descrição (opcional)</label>
              <textarea
                placeholder="Breve anotação sobre o foco ou origem desta árvore..."
                value={descricao}
                onChange={(e) => setDescricao(e.target.value)}
                rows={2}
                className="w-full text-xs p-2 rounded-raio-s border border-borda bg-bg text-tinta focus:outline-none focus:ring-1 focus:ring-acento resize-none"
              />
            </div>

            <div className="grid grid-cols-3 gap-2">
              <div className="flex flex-col gap-1">
                <label className="text-xs font-semibold text-tinta">Categoria</label>
                <Input
                  placeholder="Ex.: Famílias Reais"
                  value={categoria}
                  onChange={(e) => setCategoria(e.target.value)}
                />
              </div>

              <div className="flex flex-col gap-1">
                <label className="text-xs font-semibold text-tinta">País</label>
                <Input
                  placeholder="Ex.: Brasil"
                  value={pais}
                  onChange={(e) => setPais(e.target.value)}
                />
              </div>

              <div className="flex flex-col gap-1">
                <label className="text-xs font-semibold text-tinta">Período / Época</label>
                <Input
                  placeholder="Ex.: Século XIX"
                  value={periodo}
                  onChange={(e) => setPeriodo(e.target.value)}
                />
              </div>
            </div>

            {/* Seleção da Pessoa Raiz */}
            <div className="flex flex-col gap-1 relative">
              <label className="text-xs font-semibold text-tinta">
                Pessoa Raiz (foco inicial da árvore)
              </label>

              {pessoaEscolhida ? (
                <div className="flex items-center justify-between p-2 rounded bg-sup border border-borda text-xs">
                  <span className="flex items-center gap-1.5 font-medium text-tinta">
                    <User className="w-3.5 h-3.5 text-acento" />
                    {pessoaEscolhida.nome}
                  </span>
                  <button
                    type="button"
                    onClick={() => {
                      setPessoaEscolhida(null);
                      setRaizPessoaId(null);
                    }}
                    className="text-tinta3 hover:text-fem p-0.5"
                    title="Remover raiz"
                  >
                    <X className="w-3.5 h-3.5" />
                  </button>
                </div>
              ) : (
                <div className="relative">
                  <Input
                    placeholder="Digite o nome da pessoa para buscar no acervo..."
                    value={buscaPessoa}
                    onChange={(e) => setBuscaPessoa(e.target.value)}
                  />
                  {buscaResultados && buscaResultados.length > 0 && buscaPessoa.trim().length >= 2 && (
                    <div className="absolute top-full left-0 right-0 mt-1 bg-card border border-borda rounded-raio shadow-sombra py-1 z-50 max-h-40 overflow-y-auto">
                      {buscaResultados.map((p: PersonNode) => (
                        <button
                          key={p.id}
                          type="button"
                          onClick={() => {
                            const nomeCompleto = [p.nome, p.sobrenome].filter(Boolean).join(' ');
                            setPessoaEscolhida({ id: p.id, nome: nomeCompleto });
                            setRaizPessoaId(p.id);
                            setBuscaPessoa('');
                          }}
                          className="w-full text-left px-3 py-1.5 text-xs hover:bg-sup text-tinta flex items-center justify-between cursor-pointer"
                        >
                          <span>{[p.nome, p.sobrenome].filter(Boolean).join(' ')}</span>
                          <span className="text-[10px] text-tinta3 font-num">
                            {p.ano_nascimento ? `n. ${p.ano_nascimento}` : ''}
                          </span>
                        </button>
                      ))}
                    </div>
                  )}
                </div>
              )}
            </div>

            <div className="flex items-center justify-end gap-2 pt-2 border-t border-borda/40">
              <Button
                type="button"
                variant="secondary"
                size="sm"
                onClick={() => setEditando(null)}
              >
                Cancelar
              </Button>
              <Button
                type="submit"
                size="sm"
                disabled={criarMut.isPending || atualizarMut.isPending}
              >
                {criarMut.isPending || atualizarMut.isPending ? 'Salvando...' : 'Salvar Árvore'}
              </Button>
            </div>
          </form>
        )}

        {/* Barra Superior da Lista: Busca e Botão Nova Árvore */}
        {!editando && (
          <div className="flex flex-col gap-2">
            <div className="flex items-center justify-between gap-2">
              <div className="relative flex-1">
                <Search className="w-3.5 h-3.5 absolute left-2.5 top-1/2 -translate-y-1/2 text-tinta3" />
                <Input
                  placeholder="Filtrar árvores por nome, país, época ou categoria..."
                  value={buscaArvore}
                  onChange={(e) => setBuscaArvore(e.target.value)}
                  className="pl-8 text-xs py-1 h-8"
                />
              </div>
              <Button size="sm" onClick={iniciarCriacao} className="flex-none">
                <Plus className="w-3.5 h-3.5 mr-1" />
                Nova Árvore
              </Button>
            </div>

            {/* Abas Rápidas de Filtro */}
            <div className="flex items-center gap-1.5 text-xs font-semibold">
              <button
                type="button"
                onClick={() => setAbaFiltro('publicas')}
                className={`px-2.5 py-1 rounded cursor-pointer transition-colors flex items-center gap-1 ${
                  abaFiltro === 'publicas'
                    ? 'bg-acento text-acento-tinta font-bold'
                    : 'bg-card border border-borda text-tinta2 hover:text-tinta hover:bg-sup'
                }`}
              >
                <span>🏛️ Públicas</span>
                <span>({arvores?.filter((a) => a.is_publico).length ?? 0})</span>
              </button>
              <button
                type="button"
                onClick={() => setAbaFiltro('pessoais')}
                className={`px-2.5 py-1 rounded cursor-pointer transition-colors ${
                  abaFiltro === 'pessoais'
                    ? 'bg-acento text-acento-tinta font-bold'
                    : 'bg-card border border-borda text-tinta2 hover:text-tinta hover:bg-sup'
                }`}
              >
                Minhas ({arvores?.filter((a) => !a.is_publico).length ?? 0})
              </button>
              <button
                type="button"
                onClick={() => setAbaFiltro('todas')}
                className={`px-2.5 py-1 rounded cursor-pointer transition-colors ${
                  abaFiltro === 'todas'
                    ? 'bg-acento text-acento-tinta font-bold'
                    : 'bg-card border border-borda text-tinta2 hover:text-tinta hover:bg-sup'
                }`}
              >
                Todas ({arvores?.length ?? 0})
              </button>
            </div>
          </div>
        )}

        {/* Lista de Árvores Cadastradas */}
        <div className="flex flex-col gap-2 max-h-80 overflow-y-auto">
          {isLoading && (
            <p className="p-4 text-center text-xs text-tinta3">Carregando árvores...</p>
          )}

          {arvores
            ?.filter((a) => {
              if (abaFiltro === 'publicas' && !a.is_publico) return false;
              if (abaFiltro === 'pessoais' && a.is_publico) return false;
              if (!buscaArvore.trim()) return true;
              const t = buscaArvore.toLowerCase();
              return (
                a.nome.toLowerCase().includes(t) ||
                (a.descricao?.toLowerCase().includes(t) ?? false) ||
                (a.pais?.toLowerCase().includes(t) ?? false) ||
                (a.periodo?.toLowerCase().includes(t) ?? false) ||
                (a.categoria?.toLowerCase().includes(t) ?? false) ||
                (a.raiz_pessoa_nome?.toLowerCase().includes(t) ?? false)
              );
            })
            .map((a) => {
            const isAtiva = a.id === arvoreAtivaId;
            const isConfirmando = confirmarExclusaoId === a.id;

            return (
              <div
                key={a.id}
                className={`p-3 rounded-raio border transition-colors flex flex-col gap-2 ${
                  isAtiva
                    ? 'border-acento bg-sup/50 shadow-xs'
                    : 'border-borda bg-card hover:border-borda2'
                }`}
              >
                <div className="flex items-start justify-between gap-3">
                  <div className="flex items-start gap-2.5 min-w-0 flex-1">
                    <IconeArvore
                      className={`w-5 h-5 flex-none mt-0.5 ${
                        isAtiva ? 'text-acento' : 'text-tinta3'
                      }`}
                    />
                    <div className="min-w-0 flex-1">
                      <div className="flex items-center gap-2 flex-wrap">
                        <span className="font-semibold text-sm text-tinta truncate">
                          {a.nome}
                        </span>
                        {a.is_publico && (
                          <span className="px-1.5 py-0.2 text-[10px] font-semibold rounded bg-acento/10 text-acento border border-acento/20 flex items-center gap-1">
                            🏛️ Referência Histórica
                          </span>
                        )}
                        {isAtiva && (
                          <span className="px-1.5 py-0.2 text-[10px] font-bold rounded-full bg-acento text-acento-tinta">
                            Ativa
                          </span>
                        )}
                      </div>

                      {a.descricao && (
                        <p className="text-xs text-tinta2 m-0 mt-0.5 truncate">
                          {a.descricao}
                        </p>
                      )}

                      <div className="flex items-center gap-2 mt-1.5 text-[11px] text-tinta3 flex-wrap">
                        {a.categoria && (
                          <span className="px-1.5 py-0.2 rounded bg-sup border border-borda text-[10px] font-medium text-tinta2">
                            🏷️ {a.categoria}
                          </span>
                        )}
                        {a.pais && (
                          <span className="px-1.5 py-0.2 rounded bg-sup border border-borda text-[10px] font-medium text-tinta2">
                            🌍 {a.pais}
                          </span>
                        )}
                        {a.periodo && (
                          <span className="px-1.5 py-0.2 rounded bg-sup border border-borda text-[10px] font-medium text-tinta2">
                            ⏳ {a.periodo}
                          </span>
                        )}
                        <span className="flex items-center gap-1">
                          <User className="w-3 h-3 text-acento" />
                          Raiz: <strong className="text-tinta2">{a.raiz_pessoa_nome || 'Não definida'}</strong>
                        </span>
                        {a.total_membros > 0 && (
                          <span>· {a.total_membros} membros vinculados</span>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Ações da Árvore */}
                  <div className="flex items-center gap-1 flex-none">
                    {!isAtiva && (
                      <Button
                        size="sm"
                        variant="secondary"
                        onClick={() => {
                          onSelecionarArvore(a);
                          onClose();
                        }}
                        title="Ativar e visualizar esta árvore"
                      >
                        <Check className="w-3.5 h-3.5 mr-1" />
                        Ativar
                      </Button>
                    )}

                    <button
                      type="button"
                      onClick={() => iniciarEdicao(a)}
                      className="p-1.5 text-tinta3 hover:text-tinta rounded hover:bg-sup cursor-pointer transition-colors"
                      title="Editar árvore"
                    >
                      <Edit2 className="w-4 h-4" />
                    </button>

                    {!a.is_publico && arvores.length > 1 && (
                      <button
                        type="button"
                        onClick={() => setConfirmarExclusaoId(isConfirmando ? null : a.id)}
                        className="p-1.5 text-tinta3 hover:text-fem rounded hover:bg-sup cursor-pointer transition-colors"
                        title="Excluir árvore"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    )}
                  </div>
                </div>

                {/* Confirmação de Exclusão */}
                {isConfirmando && (
                  <div className="p-2.5 rounded bg-fem/10 border border-fem/20 flex items-center justify-between gap-2 text-xs text-fem mt-1">
                    <div className="flex items-center gap-1.5">
                      <AlertTriangle className="w-4 h-4 flex-none" />
                      <span>Excluir apenas esta visão? Nenhum parente será apagado.</span>
                    </div>
                    <div className="flex items-center gap-1.5">
                      <button
                        type="button"
                        onClick={() => executarComGatekeeper(t('seguranca', 'gatekeeperDescDeletarArvore'), (ticket) => deletarMut.mutate({ id: a.id, ticket }))}
                        disabled={deletarMut.isPending}
                        className="px-2 py-1 rounded bg-fem text-white font-semibold hover:bg-fem/90 cursor-pointer"
                      >
                        Confirmar
                      </button>
                      <button
                        type="button"
                        onClick={() => setConfirmarExclusaoId(null)}
                        className="px-2 py-1 rounded bg-sup text-tinta hover:bg-sup/80 cursor-pointer"
                      >
                        Cancelar
                      </button>
                    </div>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </Modal>
  );
}
