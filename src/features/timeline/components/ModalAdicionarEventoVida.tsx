import { useState, useEffect } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import {
  User,
  Compass,
  Clock,
  ShieldAlert,
} from 'lucide-react';
import { Modal } from '../../../components/ui/Modal';
import { Button } from '../../../components/ui/Button';
import { CampoDeData } from '../../../components/ui/CampoDeData';
import { SeletorDeLocal } from '../../person/components/SeletorDeLocal';
import { criarEvento } from '../../../lib/api/events';
import {
  adicionarParticipante,
  buscarMarcos,
  listarLinhasDeContexto,
  type LinhaDeContexto,
} from '../../../lib/api/linhasTempo';
import { DATA_VAZIA, type DataEscolhida, type Place } from '../../../types';

export const TIPOS_EVENTO_VIDA = [
  { valor: 'nascimento', rotulo: '⭐ Nascimento' },
  { valor: 'batismo', rotulo: '💧 Batismo' },
  { valor: 'casamento', rotulo: '💍 Casamento' },
  { valor: 'residencia', rotulo: '🏠 Residência / Mudança' },
  { valor: 'educacao', rotulo: '🎓 Educação / Formatura' },
  { valor: 'profissao', rotulo: '💼 Profissão / Ocupação' },
  { valor: 'militar', rotulo: '⚔️ Serviço Militar / Combate' },
  { valor: 'imigracao', rotulo: '🚢 Imigração / Emigração' },
  { valor: 'viagem', rotulo: '✈️ Viagem Notável' },
  { valor: 'falecimento', rotulo: '✝ Falecimento' },
  { valor: 'sepultamento', rotulo: '🏛️ Sepultamento' },
  { valor: 'outro', rotulo: '📍 Outro (personalizado)' },
];

const PAPEIS_SUGERIDOS = [
  'Combatente',
  'Soldado',
  'Oficial',
  'Testemunha',
  'Voluntário',
  'Imigrante',
  'Pioneiro',
  'Líder Comunitário',
  'Enfermeiro(a)',
  'Cidadão',
];

export interface PessoaOpcao {
  id: string;
  nome: string;
  sobrenome?: string | null;
  ano_nascimento?: number | null;
  ano_falecimento?: number | null;
  is_vivo?: boolean;
}

export interface ModalAdicionarEventoVidaProps {
  aberto: boolean;
  aoFechar: () => void;
  pessoaIdInicial?: string | null;
  pessoasDisponiveis?: PessoaOpcao[];
  linhasContexto?: LinhaDeContexto[];
  linhasAtivasIds?: string[];
  aoSalvarSucesso?: () => void;
}

export function ModalAdicionarEventoVida({
  aberto,
  aoFechar,
  pessoaIdInicial,
  pessoasDisponiveis = [],
  linhasContexto: propLinhasContexto,
  linhasAtivasIds = [],
  aoSalvarSucesso,
}: ModalAdicionarEventoVidaProps) {
  const qc = useQueryClient();

  // Pessoa selecionada
  const [pessoaSelecionadaId, setPessoaSelecionadaId] = useState<string>(
    pessoaIdInicial ?? pessoasDisponiveis[0]?.id ?? ''
  );

  useEffect(() => {
    if (pessoaIdInicial) {
      setPessoaSelecionadaId(pessoaIdInicial);
    } else if (pessoasDisponiveis.length > 0 && !pessoaSelecionadaId) {
      setPessoaSelecionadaId(pessoasDisponiveis[0].id);
    }
  }, [pessoaIdInicial, pessoasDisponiveis]);

  // Tipo do evento
  const [tipoEvento, setTipoEvento] = useState('residencia');
  const [tipoPersonalizado, setTipoPersonalizado] = useState('');

  // Data
  const [dataEscolhida, setDataEscolhida] = useState<DataEscolhida>({
    ...DATA_VAZIA,
    qualificador: 'exata',
  });

  // Local
  const [local, setLocal] = useState<Place | null>(null);
  const [rotuloHistorico, setRotuloHistorico] = useState('');

  // Nota / Detalhes
  const [nota, setNota] = useState('');

  // Conexão com Linha de Contexto
  const [conectarContexto, setConectarContexto] = useState(false);
  const [linhaContextoId, setLinhaContextoId] = useState<string>('');
  const [marcoContextoId, setMarcoContextoId] = useState<string>('');
  const [papelParticipacao, setPapelParticipacao] = useState('');
  const [visivelNaPessoa, setVisivelNaPessoa] = useState(true);

  // Consulta todas as linhas caso não tenham sido passadas por props
  const { data: todasLinhas } = useQuery({
    queryKey: ['linhas-de-contexto'],
    queryFn: listarLinhasDeContexto,
    enabled: aberto && (!propLinhasContexto || propLinhasContexto.length === 0),
  });

  const linhas = propLinhasContexto && propLinhasContexto.length > 0 ? propLinhasContexto : (todasLinhas ?? []);

  // Ao ativar conexão com contexto, define linha padrão
  useEffect(() => {
    if (conectarContexto && !linhaContextoId) {
      const primeiraLinha =
        linhasAtivasIds.length > 0
          ? linhas.find((l) => linhasAtivasIds.includes(l.id))?.id ?? linhas[0]?.id
          : linhas[0]?.id;
      if (primeiraLinha) setLinhaContextoId(primeiraLinha);
    }
  }, [conectarContexto, linhaContextoId, linhasAtivasIds, linhas]);

  // Busca marcos da linha selecionada
  const { data: marcosDaLinha, isLoading: carregandoMarcos } = useQuery({
    queryKey: ['marcos-linha-modal', linhaContextoId],
    queryFn: () => buscarMarcos([linhaContextoId], null, null, false, 'detalhe'),
    enabled: aberto && conectarContexto && !!linhaContextoId,
  });

  // Resetar marco quando a linha de contexto muda
  useEffect(() => {
    if (marcosDaLinha && marcosDaLinha.length > 0) {
      setMarcoContextoId(marcosDaLinha[0].id);
    } else {
      setMarcoContextoId('');
    }
  }, [marcosDaLinha]);

  // Mutação para salvar evento e opcionalmente ligar ao marco
  const [erroAoSalvar, setErroAoSalvar] = useState<string | null>(null);

  const mSalvar = useMutation({
    mutationFn: async () => {
      setErroAoSalvar(null);
      if (!pessoaSelecionadaId) {
        throw new Error('Selecione uma pessoa para registrar o evento.');
      }

      const tipoFinal =
        tipoEvento === 'outro'
          ? (tipoPersonalizado.trim() || 'Evento')
          : tipoEvento;

      // 1. Cria o evento biográfico na pessoa
      const eventoId = await criarEvento({
        pessoa_id: pessoaSelecionadaId,
        tipo_evento: tipoFinal,
        data: dataEscolhida,
        local_id: local?.id ?? null,
        rotulo_historico_livre: rotuloHistorico.trim() || null,
        nota: nota.trim() || null,
      });

      // 2. Se optou por conectar a um marco histórico, inclui o participante
      if (conectarContexto && marcoContextoId) {
        await adicionarParticipante({
          marco_id: marcoContextoId,
          pessoa_id: pessoaSelecionadaId,
          papel: papelParticipacao.trim() || null,
          visivel_na_pessoa: visivelNaPessoa,
        });
      }

      return eventoId;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['linha-pessoal'] });
      qc.invalidateQueries({ queryKey: ['linha-pessoal', pessoaSelecionadaId] });
      qc.refetchQueries({ queryKey: ['linha-pessoal'] });
      qc.invalidateQueries({ queryKey: ['eventos', pessoaSelecionadaId] });
      qc.invalidateQueries({ queryKey: ['participacoes-pessoa', pessoaSelecionadaId] });
      qc.invalidateQueries({ queryKey: ['marco-participantes'] });
      qc.invalidateQueries({ queryKey: ['marcos'] });
      qc.invalidateQueries({ queryKey: ['pessoa', pessoaSelecionadaId] });
      qc.invalidateQueries({ queryKey: ['arvore'] });

      aoSalvarSucesso?.();
      aoFechar();
    },
    onError: (err: any) => {
      setErroAoSalvar(err?.message ?? 'Ocorreu um erro ao salvar o evento.');
    },
  });

  if (!aberto) return null;

  const marcoSelecionado = marcosDaLinha?.find((m) => m.id === marcoContextoId);

  // Ordena linhas de contexto colocando as ativas na linha do tempo no topo
  const linhasOrdenadas = [...linhas].sort((a, b) => {
    const aAtiva = linhasAtivasIds.includes(a.id);
    const bAtiva = linhasAtivasIds.includes(b.id);
    if (aAtiva && !bAtiva) return -1;
    if (!aAtiva && bAtiva) return 1;
    return a.titulo.localeCompare(b.titulo);
  });

  return (
    <Modal
      isOpen={aberto}
      onClose={aoFechar}
      title="Registrar Evento de Vida na Linha do Tempo"
      className="max-w-2xl"
    >
      <form
        onSubmit={(e) => {
          e.preventDefault();
          mSalvar.mutate();
        }}
        className="flex flex-col gap-4 text-sm text-tinta"
      >
        {/* Escolha da Pessoa */}
        <div className="flex flex-col gap-1">
          <label className="text-xs font-semibold text-tinta flex items-center gap-1.5">
            <User className="w-3.5 h-3.5 text-acento" />
            <span>Familiar / Pessoa da Árvore</span>
          </label>
          <select
            value={pessoaSelecionadaId}
            onChange={(e) => setPessoaSelecionadaId(e.target.value)}
            required
            className="px-3 py-2 text-sm bg-card border border-borda rounded-raio-s text-tinta font-medium focus:outline-none focus:border-acento"
          >
            {pessoasDisponiveis.map((p) => {
              const periodo = [
                p.ano_nascimento ? `* ${p.ano_nascimento}` : null,
                p.ano_falecimento ? `✝ ${p.ano_falecimento}` : p.is_vivo ? '• vivo' : null,
              ]
                .filter(Boolean)
                .join(' ');
              return (
                <option key={p.id} value={p.id}>
                  {p.nome} {p.sobrenome ?? ''} {periodo ? `(${periodo})` : ''}
                </option>
              );
            })}
          </select>
        </div>

        {/* Tipo de Evento */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div className="flex flex-col gap-1">
            <label className="text-xs font-semibold text-tinta">Tipo de Acontecimento</label>
            <select
              value={tipoEvento}
              onChange={(e) => setTipoEvento(e.target.value)}
              className="px-3 py-2 text-sm bg-card border border-borda rounded-raio-s text-tinta focus:outline-none focus:border-acento"
            >
              {TIPOS_EVENTO_VIDA.map((t) => (
                <option key={t.valor} value={t.valor}>
                  {t.rotulo}
                </option>
              ))}
            </select>
          </div>

          {tipoEvento === 'outro' && (
            <div className="flex flex-col gap-1 animate-in fade-in">
              <label className="text-xs font-semibold text-tinta">Nome do Evento Personalizado</label>
              <input
                type="text"
                placeholder="Ex: Ordenação Religiosa, Condecoração..."
                value={tipoPersonalizado}
                onChange={(e) => setTipoPersonalizado(e.target.value)}
                required={tipoEvento === 'outro'}
                className="px-3 py-2 text-sm bg-card border border-borda rounded-raio-s text-tinta focus:outline-none focus:border-acento"
              />
            </div>
          )}
        </div>

        {/* Campo Estruturado de Data */}
        <div className="p-3 bg-sup/50 border border-borda/70 rounded-raio flex flex-col gap-2">
          <CampoDeData
            rotulo="Data do Acontecimento"
            valor={dataEscolhida}
            aoMudar={setDataEscolhida}
            ajuda="A data posiciona o evento com precisão na linha de vida da pessoa."
          />
        </div>

        {/* Campo Estruturado de Localidade */}
        <div className="p-3 bg-sup/50 border border-borda/70 rounded-raio flex flex-col gap-2">
          <SeletorDeLocal
            local={local}
            onEscolher={setLocal}
            rotuloHistorico={rotuloHistorico}
            onMudarRotulo={setRotuloHistorico}
          />
        </div>

        {/* Nota / Detalhes */}
        <div className="flex flex-col gap-1">
          <label className="text-xs font-semibold text-tinta">
            Descrição / Detalhes / Memória (Opcional)
          </label>
          <textarea
            rows={2}
            value={nota}
            onChange={(e) => setNota(e.target.value)}
            placeholder="Ex: Mudou-se para a capital para abrir sua primeira oficina mecânica..."
            className="px-3 py-2 text-xs bg-card border border-borda rounded-raio-s text-tinta focus:outline-none focus:border-acento placeholder:text-tinta3/60"
          />
        </div>

        {/* Seção Destacada: Conexão com Linha de Contexto / Marco Histórico */}
        <div className="border border-acento/30 bg-acento/5 rounded-raio p-3.5 flex flex-col gap-3">
          <label className="flex items-center gap-2 cursor-pointer select-none">
            <input
              type="checkbox"
              checked={conectarContexto}
              onChange={(e) => setConectarContexto(e.target.checked)}
              className="rounded text-acento focus:ring-acento w-4 h-4 cursor-pointer"
            />
            <div className="flex items-center gap-1.5 font-semibold text-xs text-tinta">
              <Compass className="w-3.5 h-3.5 text-acento" />
              <span>Conectar a uma Linha de Contexto ou Marco Histórico</span>
            </div>
          </label>

          {conectarContexto && (
            <div className="flex flex-col gap-3 pt-2 border-t border-acento/20 animate-in fade-in duration-150">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                {/* Linha de Contexto */}
                <div className="flex flex-col gap-1">
                  <span className="text-[11px] font-semibold text-tinta2">Linha de Contexto</span>
                  <select
                    value={linhaContextoId}
                    onChange={(e) => setLinhaContextoId(e.target.value)}
                    className="px-2.5 py-1.5 text-xs bg-card border border-borda rounded-raio-s text-tinta focus:outline-none focus:border-acento"
                  >
                    {linhasOrdenadas.map((l) => {
                      const ativa = linhasAtivasIds.includes(l.id);
                      return (
                        <option key={l.id} value={l.id}>
                          {ativa ? '★ ' : ''}{l.titulo} {ativa ? '(Ativa na gaveta)' : ''}
                        </option>
                      );
                    })}
                  </select>
                </div>

                {/* Marco Histórico da Linha */}
                <div className="flex flex-col gap-1">
                  <span className="text-[11px] font-semibold text-tinta2">Marco / Acontecimento</span>
                  <select
                    value={marcoContextoId}
                    onChange={(e) => setMarcoContextoId(e.target.value)}
                    disabled={carregandoMarcos || !marcosDaLinha || marcosDaLinha.length === 0}
                    className="px-2.5 py-1.5 text-xs bg-card border border-borda rounded-raio-s text-tinta focus:outline-none focus:border-acento disabled:opacity-50"
                  >
                    {carregandoMarcos && <option>Carregando marcos...</option>}
                    {!carregandoMarcos && (!marcosDaLinha || marcosDaLinha.length === 0) && (
                      <option value="">Nenhum marco nesta linha</option>
                    )}
                    {marcosDaLinha?.map((m) => (
                      <option key={m.id} value={m.id}>
                        {m.data_periodo_texto ? `${m.data_periodo_texto}: ` : ''}{m.titulo}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              {/* Botão de Atalho para puxar ano do marco */}
              {marcoSelecionado && (marcoSelecionado.ano_inicio != null || marcoSelecionado.ano_fim != null) && (
                <div className="flex items-center gap-2">
                  <button
                    type="button"
                    onClick={() => {
                      const ano = marcoSelecionado.ano_inicio ?? marcoSelecionado.ano_fim;
                      if (ano != null) {
                        setDataEscolhida({
                          ...DATA_VAZIA,
                          qualificador: 'exata',
                          ano,
                        });
                      }
                    }}
                    className="text-[11px] text-acento hover:underline flex items-center gap-1 font-semibold cursor-pointer"
                  >
                    <Clock className="w-3 h-3" />
                    <span>Usar ano do marco histórico ({marcoSelecionado.data_periodo_texto || marcoSelecionado.ano_inicio})</span>
                  </button>
                </div>
              )}

              {/* Papel / Função da pessoa */}
              <div className="flex flex-col gap-1">
                <span className="text-[11px] font-semibold text-tinta2">
                  Papel ou Participação da Pessoa (ex: Combatente, Testemunha, Voluntário)
                </span>
                <input
                  type="text"
                  placeholder="Ex: Soldado da Força Expedicionária Brasileira..."
                  value={papelParticipacao}
                  onChange={(e) => setPapelParticipacao(e.target.value)}
                  className="px-2.5 py-1.5 text-xs bg-card border border-borda rounded-raio-s text-tinta focus:outline-none focus:border-acento"
                />

                {/* Chips de Sugestões de Papéis */}
                <div className="flex items-center gap-1.5 flex-wrap pt-1">
                  <span className="text-[10px] text-tinta3 font-medium">Sugestões:</span>
                  {PAPEIS_SUGERIDOS.map((sugestao) => (
                    <button
                      key={sugestao}
                      type="button"
                      onClick={() => setPapelParticipacao(sugestao)}
                      className="px-2 py-0.5 rounded-full text-[10px] bg-card hover:bg-acento hover:text-acento-tinta border border-borda/60 text-tinta2 transition-colors cursor-pointer"
                    >
                      {sugestao}
                    </button>
                  ))}
                </div>
              </div>

              {/* Checkbox: Visível na linha de vida da pessoa */}
              <label className="flex items-center gap-2 cursor-pointer pt-1">
                <input
                  type="checkbox"
                  checked={visivelNaPessoa}
                  onChange={(e) => setVisivelNaPessoa(e.target.checked)}
                  className="rounded text-acento focus:ring-acento w-3.5 h-3.5 cursor-pointer"
                />
                <span className="text-xs text-tinta2">
                  Exibir o chip desta participação diretamente na linha de vida da pessoa
                </span>
              </label>
            </div>
          )}
        </div>

        {/* Mensagem de Erro */}
        {erroAoSalvar && (
          <div className="p-2.5 bg-fem/10 border border-fem/30 text-fem rounded-raio-s text-xs flex items-center gap-2">
            <ShieldAlert className="w-4 h-4 flex-none" />
            <span>{erroAoSalvar}</span>
          </div>
        )}

        {/* Rodapé de Ações */}
        <div className="flex items-center justify-end gap-2 pt-2 border-t border-borda">
          <Button type="button" variant="outline" onClick={aoFechar} disabled={mSalvar.isPending}>
            Cancelar
          </Button>
          <Button
            type="submit"
            variant="primary"
            disabled={mSalvar.isPending || !pessoaSelecionadaId}
            className="flex items-center gap-1.5"
          >
            {mSalvar.isPending ? 'Salvando...' : 'Adicionar Evento de Vida'}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
