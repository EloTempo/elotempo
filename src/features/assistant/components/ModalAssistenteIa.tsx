import { useEffect, useRef, useState } from 'react';
import { open } from '@tauri-apps/plugin-dialog';
import { useQueryClient } from '@tanstack/react-query';
import {
  AlertTriangle,
  Bot,
  CheckCircle2,
  Cpu,
  Download,
  FileEdit,
  FolderUp,
  GitBranch,
  History,
  Loader2,
  Play,
  Send,
  ShieldCheck,
  Sparkles,
  Square,
  Trash2,
  UserCheck,
  UserPlus,
  X,
} from 'lucide-react';
import { Button } from '../../../components/ui/Button';
import {
  calcularProgressoDownload,
  cancelarDownloadModeloIa,
  configurarEndpointIaLocal,
  consultarAssistenteIa,
  executarPropostaIa,
  formatarBytesModelo,
  importarModeloGgufLocal,
  iniciarDownloadModeloIa,
  iniciarMotorIaLocal,
  obterStatusIaLocal,
  pararMotorIaLocal,
  removerModeloIa,
  type CitacaoAcervoIa,
  type OpcaoNavegacaoIa,
  type PropostaAcaoIa,
  type RascunhoCadastroPessoaIa,
  type RespostaAssistenteIa,
  type StatusIaLocal,
} from '../../../lib/api';

interface ModalAssistenteIaProps {
  aberto: boolean;
  onFechar: () => void;
  onSelecionarPessoa?: (pessoaId: string, arvoreId?: string | null) => void;
  onAbrirLinhaTempo?: () => void;
  onAbrirFichaPessoa?: (pessoaId: string, arvoreId?: string | null) => void;
  onAbrirCadastroNovaPessoa?: (rascunho: RascunhoCadastroPessoaIa) => void;
  onArvoreCriada?: (arvoreId: string, raizPessoaId: string | null) => void;
  onLinhaTempoCriada?: (linhaId: string) => void;
}

interface ItemConversa {
  id: string;
  autor: 'usuario' | 'assistente';
  texto: string;
  resposta?: RespostaAssistenteIa;
  propostaExecutada?: boolean;
  mensagemExecucao?: string;
  avisosExecucao?: string[];
}

const EXEMPLOS_RAPIDOS = [
  {
    rotulo: 'Consultar Pessoa',
    texto: 'Quem foi Dom Pedro I, quando nasceu e quem foram seus filhos?',
  },
  {
    rotulo: 'Cadastrar Pessoa',
    texto:
      'Quero criar um cadastro para Helena Souza, nascida em 1920, professora e historiadora.',
  },
  {
    rotulo: 'Adicionar Parentesco',
    texto: 'Adicione Carlos Souza (1948) como filho de Helena Souza',
  },
  {
    rotulo: 'Entrevista Guiada',
    texto: 'Criar família passo a passo',
  },
  {
    rotulo: 'Auditar Cadastros',
    texto: 'Quais cadastros estão incompletos no acervo?',
  },
];

export function ModalAssistenteIa({
  aberto,
  onFechar,
  onSelecionarPessoa,
  onAbrirLinhaTempo,
  onAbrirFichaPessoa,
  onAbrirCadastroNovaPessoa,
  onArvoreCriada,
  onLinhaTempoCriada,
}: ModalAssistenteIaProps) {
  const qc = useQueryClient();
  const [abaAtiva, setAbaAtiva] = useState<'chat' | 'modelos'>('chat');
  const [entrada, setEntrada] = useState('');
  const [enviando, setEnviando] = useState(false);
  const [executandoId, setExecutandoId] = useState<string | null>(null);
  const [ativandoModeloId, setAtivandoModeloId] = useState<string | null>(null);
  const [statusIa, setStatusIa] = useState<StatusIaLocal | null>(null);
  const [endpointInput, setEndpointInput] = useState('http://127.0.0.1:18080');
  const [erroAcao, setErroAcao] = useState<string | null>(null);
  const fimChatRef = useRef<HTMLDivElement | null>(null);

  const [conversa, setConversa] = useState<ItemConversa[]>([
    {
      id: 'boas-vindas',
      autor: 'assistente',
      texto:
        'Olá! Sou o **Assistente Local do EloTempo**.\n\n' +
        '- **Pesquisa Universal e Rápida**: pergunte sobre qualquer pessoa, árvore, parentesco, local, obra, profissão, fonte ou evento do acervo. Respondo rápido no chat e **você escolhe** se quer abrir a Ficha de Informações ou a Árvore Genealógica.\n' +
        '- **Cadastros e Edições**: peça *"Quero cadastrar [Nome]..."* para **abrir a tela de cadastro já pré-preenchida**, ou peça para editar biografias, profissões, parentescos e linhas do tempo.\n' +
        '- **Escopo Estrito EloTempo**: respondo exclusivamente sobre os dados e recursos do EloTempo, sem usar conhecimentos externos de treinamento.',
    },
  ]);

  const carregarStatus = async () => {
    try {
      const st = await obterStatusIaLocal();
      setStatusIa(st);
      setEndpointInput(st.endpoint_local);
    } catch {
      /* ignora erro silencioso de polling */
    }
  };

  useEffect(() => {
    if (!aberto) return;
    carregarStatus();
    const timer = window.setInterval(carregarStatus, 1500);
    return () => window.clearInterval(timer);
  }, [aberto]);

  useEffect(() => {
    fimChatRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [conversa, enviando]);

  const sincronizarAmbienteComResposta = (resp: RespostaAssistenteIa) => {
    if (resp.foco_pessoa_id && onSelecionarPessoa) {
      onSelecionarPessoa(resp.foco_pessoa_id, resp.foco_arvore_id ?? null);
    }
    if (resp.abrir_linha_tempo && onAbrirLinhaTempo) {
      onAbrirLinhaTempo();
    }
    if (resp.abrir_ficha_pessoa_id && onAbrirFichaPessoa) {
      onAbrirFichaPessoa(resp.abrir_ficha_pessoa_id, resp.foco_arvore_id ?? null);
    }
    if (resp.rascunho_nova_pessoa && onAbrirCadastroNovaPessoa) {
      onAbrirCadastroNovaPessoa(resp.rascunho_nova_pessoa);
    }
  };

  const handleEnviar = async (textoCustom?: string) => {
    const pergunta = (textoCustom ?? entrada).trim();
    if (!pergunta || enviando) return;

    const msgUsuario: ItemConversa = {
      id: `usr-${Date.now()}`,
      autor: 'usuario',
      texto: pergunta,
    };

    setConversa((prev) => [...prev, msgUsuario]);
    if (!textoCustom) setEntrada('');
    setEnviando(true);
    setErroAcao(null);

    try {
      const resp = await consultarAssistenteIa(pergunta);
      const msgAssistente: ItemConversa = {
        id: `ast-${Date.now()}`,
        autor: 'assistente',
        texto: resp.resposta_markdown,
        resposta: resp,
      };
      setConversa((prev) => [...prev, msgAssistente]);
      sincronizarAmbienteComResposta(resp);
    } catch (err) {
      setConversa((prev) => [
        ...prev,
        {
          id: `err-${Date.now()}`,
          autor: 'assistente',
          texto: `Não foi possível processar a consulta: ${err instanceof Error ? err.message : String(err)}`,
        },
      ]);
    } finally {
      setEnviando(false);
    }
  };

  const handleExecutarOpcaoNavegacao = (op: OpcaoNavegacaoIa) => {
    if (op.acao === 'abrir_ficha_pessoa' && op.pessoa_id) {
      onAbrirFichaPessoa?.(op.pessoa_id, op.arvore_id ?? null);
    } else if (op.acao === 'abrir_arvore' && op.pessoa_id) {
      onSelecionarPessoa?.(op.pessoa_id, op.arvore_id ?? null);
    } else if (op.acao === 'abrir_linha_tempo') {
      if (op.pessoa_id) {
        onSelecionarPessoa?.(op.pessoa_id, op.arvore_id ?? null);
      }
      onAbrirLinhaTempo?.();
    } else if (op.acao === 'abrir_cadastro_pessoa' && op.rascunho_pessoa) {
      onAbrirCadastroNovaPessoa?.(op.rascunho_pessoa);
    } else if (op.acao === 'enviar_prompt' && op.prompt_sugerido) {
      handleEnviar(op.prompt_sugerido);
    }
  };

  const handleConfirmarProposta = async (itemId: string, proposta: PropostaAcaoIa) => {
    setExecutandoId(itemId);
    setErroAcao(null);
    try {
      const res = await executarPropostaIa(proposta);
      await qc.invalidateQueries({ queryKey: ['arvores'] });
      await qc.invalidateQueries({ queryKey: ['pessoas'] });
      await qc.invalidateQueries({ queryKey: ['arvore'] });
      await qc.invalidateQueries({ queryKey: ['linhas-contexto'] });
      await qc.invalidateQueries({ queryKey: ['pessoas-arvore-timeline'] });

      setConversa((prev) =>
        prev.map((item) =>
          item.id === itemId
            ? {
                ...item,
                propostaExecutada: true,
                mensagemExecucao: res.mensagem,
                avisosExecucao: res.avisos,
              }
            : item,
        ),
      );

      if (res.tipo === 'arvore' && onArvoreCriada) {
        onArvoreCriada(res.entidade_id, res.raiz_pessoa_id);
      } else if (res.tipo === 'linha_tempo' && onLinhaTempoCriada) {
        onLinhaTempoCriada(res.entidade_id);
      } else if (res.raiz_pessoa_id && onSelecionarPessoa) {
        onSelecionarPessoa(res.raiz_pessoa_id, null);
      }
    } catch (err) {
      setErroAcao(err instanceof Error ? err.message : String(err));
    } finally {
      setExecutandoId(null);
    }
  };

  const handleImportarGguf = async () => {
    try {
      const selecionado = await open({
        multiple: false,
        filters: [{ name: 'Modelo GGUF', extensions: ['gguf'] }],
      });
      if (typeof selecionado === 'string' && selecionado) {
        await importarModeloGgufLocal(selecionado);
        await carregarStatus();
      }
    } catch (err) {
      setErroAcao(err instanceof Error ? err.message : String(err));
    }
  };

  const handleSalvarEndpoint = async () => {
    try {
      const st = await configurarEndpointIaLocal(endpointInput);
      setStatusIa(st);
    } catch (err) {
      setErroAcao(err instanceof Error ? err.message : String(err));
    }
  };

  const renderTextoFormatado = (texto: string) => {
    return texto.split('\n').map((linha, idx) => {
      const partes = linha.split(/(\*\*.*?\*\*)/g);
      return (
        <p key={idx} className={linha.trim() === '' ? 'h-2' : 'leading-relaxed'}>
          {partes.map((parte, i) => {
            if (parte.startsWith('**') && parte.endsWith('**')) {
              return (
                <strong key={i} className="font-semibold text-tinta">
                  {parte.slice(2, -2)}
                </strong>
              );
            }
            return <span key={i}>{parte}</span>;
          })}
        </p>
      );
    });
  };

  const renderCardProposta = (item: ItemConversa, proposta: PropostaAcaoIa) => {
    const executando = executandoId === item.id;

    if (proposta.tipo_acao === 'criar_arvore') {
      const dados = proposta.dados;
      return (
        <div className="mt-3 rounded-lg border-2 border-acento/50 bg-papel p-3.5 shadow-xs">
          <div className="flex items-center justify-between gap-2 border-b border-borda/60 pb-2">
            <div className="flex items-center gap-2">
              <GitBranch className="h-4 w-4 text-acento" />
              <span className="font-bold text-tinta text-sm">
                Proposta de Árvore: {dados.nome_arvore}
              </span>
            </div>
            {dados.ancoragem_verificada && (
              <span className="inline-flex items-center gap-1 rounded-full bg-emerald-500/15 px-2 py-0.5 text-[11px] font-semibold text-emerald-700 dark:text-emerald-300">
                <ShieldCheck className="h-3.5 w-3.5" />
                Quote-and-Verify OK
              </span>
            )}
          </div>

          <div className="mt-2.5 space-y-2 text-xs">
            <div className="font-semibold text-tinta-suave">
              Pessoas extraídas do seu texto ({dados.pessoas.length}):
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-1.5">
              {dados.pessoas.map((p) => (
                <div
                  key={p.ref_id}
                  className="flex items-center justify-between rounded border border-borda/70 bg-fundo/60 px-2.5 py-1.5"
                >
                  <div>
                    <span className="font-semibold text-tinta">
                      {p.nome} {p.sobrenome ?? ''}
                    </span>
                    <span className="ml-1.5 text-tinta-suave">
                      ({p.sexo === 'F' ? 'Fem.' : 'Masc.'}
                      {p.ano_nascimento ? `, *${p.ano_nascimento}` : ''}
                      {p.ano_falecimento ? ` †${p.ano_falecimento}` : ''})
                    </span>
                  </div>
                  {p.pessoa_existente_id && (
                    <span
                      title="Pessoa já existente no banco reconhecida via Jaro-Winkler"
                      className="inline-flex items-center gap-1 rounded bg-acento/15 px-1.5 py-0.5 text-[10px] font-semibold text-acento"
                    >
                      <UserCheck className="h-3 w-3" />
                      Já no acervo
                    </span>
                  )}
                </div>
              ))}
            </div>

            {dados.alertas_auditoria.length > 0 && (
              <div className="mt-2 rounded border border-amber-500/40 bg-amber-500/10 p-2 text-[11px] text-amber-800 dark:text-amber-200">
                <div className="font-semibold flex items-center gap-1">
                  <AlertTriangle className="h-3.5 w-3.5" />
                  Auditoria Anti-Alucinação:
                </div>
                <ul className="list-disc pl-4 mt-1 space-y-0.5">
                  {dados.alertas_auditoria.map((al, i) => (
                    <li key={i}>{al}</li>
                  ))}
                </ul>
              </div>
            )}
          </div>

          <div className="mt-3 flex items-center justify-end gap-2 pt-2 border-t border-borda/50">
            {item.propostaExecutada ? (
              <div className="flex flex-col items-end gap-1.5">
                <div className="flex items-center gap-1.5 text-xs font-semibold text-emerald-600 dark:text-emerald-400">
                  <CheckCircle2 className="h-4 w-4" />
                  {item.mensagemExecucao ?? 'Árvore criada com sucesso no acervo!'}
                </div>
                {/* O usuário aprovou um card com os vínculos listados. Se o banco
                    recusou algum, dizer qual é o que mantém a árvore criada
                    igual à árvore prometida. */}
                {item.avisosExecucao && item.avisosExecucao.length > 0 && (
                  <ul className="list-disc space-y-0.5 pl-4 text-left text-xs text-amber-700 dark:text-amber-400">
                    {item.avisosExecucao.map((aviso, i) => (
                      <li key={i}>{aviso}</li>
                    ))}
                  </ul>
                )}
              </div>
            ) : (
              <Button
                variant="primary"
                size="sm"
                disabled={executando}
                onClick={() => handleConfirmarProposta(item.id, proposta)}
              >
                {executando ? (
                  <>
                    <Loader2 className="h-3.5 w-3.5 animate-spin mr-1.5" />
                    Gravando no SQLCipher...
                  </>
                ) : (
                  <>
                    <CheckCircle2 className="h-3.5 w-3.5 mr-1.5" />
                    Confirmar e Criar Árvore no Acervo
                  </>
                )}
              </Button>
            )}
          </div>
        </div>
      );
    }

    if (proposta.tipo_acao === 'editar_pessoa') {
      const dados = proposta.dados;
      return (
        <div className="mt-3 rounded-lg border-2 border-acento/50 bg-papel p-3.5 shadow-xs">
          <div className="flex items-center justify-between gap-2 border-b border-borda/60 pb-2">
            <div className="flex items-center gap-2">
              <FileEdit className="h-4 w-4 text-acento" />
              <span className="font-bold text-tinta text-sm">
                Atualização de Registro: {dados.pessoa_nome}
              </span>
            </div>
            <span className="inline-flex items-center gap-1 rounded-full bg-emerald-500/15 px-2 py-0.5 text-[11px] font-semibold text-emerald-700 dark:text-emerald-300">
              <ShieldCheck className="h-3.5 w-3.5" />
              Verificado
            </span>
          </div>

          <div className="mt-2.5 space-y-1 text-xs text-tinta">
            <ul className="list-disc pl-4 space-y-0.5 text-tinta-suave">
              {dados.resumo_alteracoes.map((alt, idx) => (
                <li key={idx}>{alt}</li>
              ))}
            </ul>
            <div className="grid grid-cols-1 gap-1 pt-1">
              {dados.ano_nascimento !== null && (
                <div>
                  <span className="font-semibold">Ano de nascimento:</span> {dados.ano_nascimento}
                </div>
              )}
              {dados.ano_falecimento !== null && (
                <div>
                  <span className="font-semibold">Ano de falecimento:</span> {dados.ano_falecimento}
                </div>
              )}
              {dados.nova_profissao && (
                <div>
                  <span className="font-semibold">Profissão:</span> {dados.nova_profissao}
                </div>
              )}
              {dados.nova_obra_titulo && (
                <div>
                  <span className="font-semibold">Obra Cultural:</span> {dados.nova_obra_titulo}{' '}
                  {dados.nova_obra_ano ? `(${dados.nova_obra_ano})` : ''}
                </div>
              )}
              {dados.novo_apelido && (
                <div>
                  <span className="font-semibold">Apelido:</span> {dados.novo_apelido}
                </div>
              )}
            </div>
          </div>

          <div className="mt-3 flex items-center justify-end gap-2 pt-2 border-t border-borda/50">
            {item.propostaExecutada ? (
              <div className="flex items-center gap-1.5 text-xs font-semibold text-emerald-600 dark:text-emerald-400">
                <CheckCircle2 className="h-4 w-4" />
                {item.mensagemExecucao ?? 'Alterações salvas com sucesso!'}
              </div>
            ) : (
              <Button
                variant="primary"
                size="sm"
                disabled={executando}
                onClick={() => handleConfirmarProposta(item.id, proposta)}
              >
                {executando ? (
                  <>
                    <Loader2 className="h-3.5 w-3.5 animate-spin mr-1.5" />
                    Gravando...
                  </>
                ) : (
                  <>
                    <CheckCircle2 className="h-3.5 w-3.5 mr-1.5" />
                    Confirmar e Salvar Alterações
                  </>
                )}
              </Button>
            )}
          </div>
        </div>
      );
    }

    if (proposta.tipo_acao === 'adicionar_parentesco') {
      const dados = proposta.dados;
      return (
        <div className="mt-3 rounded-lg border-2 border-acento/50 bg-papel p-3.5 shadow-xs">
          <div className="flex items-center justify-between gap-2 border-b border-borda/60 pb-2">
            <div className="flex items-center gap-2">
              <GitBranch className="h-4 w-4 text-acento" />
              <span className="font-bold text-tinta text-sm">
                Novo Vínculo Familiar ({dados.tipo_parentesco})
              </span>
            </div>
            <span className="inline-flex items-center gap-1 rounded-full bg-emerald-500/15 px-2 py-0.5 text-[11px] font-semibold text-emerald-700 dark:text-emerald-300">
              <ShieldCheck className="h-3.5 w-3.5" />
              Verificado
            </span>
          </div>

          <div className="mt-2.5 text-xs text-tinta space-y-1">
            <p className="font-medium">
              Vincular{' '}
              <strong>
                {dados.familiar_nome} {dados.familiar_sobrenome ?? ''}
              </strong>{' '}
              como <strong>{dados.tipo_parentesco}</strong> de{' '}
              <strong>{dados.pessoa_base_nome}</strong>
            </p>
            {dados.familiar_ano_nascimento && (
              <p className="text-tinta-suave">
                Nascimento: {dados.familiar_ano_nascimento}
                {dados.familiar_ano_falecimento ? ` — Óbito: ${dados.familiar_ano_falecimento}` : ''}
              </p>
            )}
          </div>

          <div className="mt-3 flex items-center justify-end gap-2 pt-2 border-t border-borda/50">
            {item.propostaExecutada ? (
              <div className="flex items-center gap-1.5 text-xs font-semibold text-emerald-600 dark:text-emerald-400">
                <CheckCircle2 className="h-4 w-4" />
                {item.mensagemExecucao ?? 'Vínculo registrado com sucesso!'}
              </div>
            ) : (
              <Button
                variant="primary"
                size="sm"
                disabled={executando}
                onClick={() => handleConfirmarProposta(item.id, proposta)}
              >
                {executando ? (
                  <>
                    <Loader2 className="h-3.5 w-3.5 animate-spin mr-1.5" />
                    Gravando...
                  </>
                ) : (
                  <>
                    <CheckCircle2 className="h-3.5 w-3.5 mr-1.5" />
                    Confirmar Parentesco
                  </>
                )}
              </Button>
            )}
          </div>
        </div>
      );
    }

    if (proposta.tipo_acao === 'editar_linha_tempo') {
      const dados = proposta.dados;
      return (
        <div className="mt-3 rounded-lg border-2 border-acento/50 bg-papel p-3.5 shadow-xs">
          <div className="flex items-center justify-between gap-2 border-b border-borda/60 pb-2">
            <div className="flex items-center gap-2">
              <History className="h-4 w-4 text-acento" />
              <span className="font-bold text-tinta text-sm">
                Atualizar Linha do Tempo: {dados.titulo_linha}
              </span>
            </div>
          </div>

          <div className="mt-2.5 space-y-1.5 text-xs">
            {dados.marcos_para_adicionar.map((m, i) => (
              <div
                key={i}
                className="flex items-start gap-2 rounded border border-borda/70 bg-fundo/60 px-2.5 py-1.5"
              >
                <span className="rounded bg-acento/15 px-1.5 py-0.5 font-mono font-bold text-acento">
                  {m.data_periodo_texto}
                </span>
                <span className="text-tinta">{m.titulo}</span>
              </div>
            ))}
          </div>

          <div className="mt-3 flex items-center justify-end gap-2 pt-2 border-t border-borda/50">
            {item.propostaExecutada ? (
              <div className="flex items-center gap-1.5 text-xs font-semibold text-emerald-600 dark:text-emerald-400">
                <CheckCircle2 className="h-4 w-4" />
                {item.mensagemExecucao ?? 'Linha do tempo atualizada!'}
              </div>
            ) : (
              <Button
                variant="primary"
                size="sm"
                disabled={executando}
                onClick={() => handleConfirmarProposta(item.id, proposta)}
              >
                {executando ? (
                  <>
                    <Loader2 className="h-3.5 w-3.5 animate-spin mr-1.5" />
                    Gravando...
                  </>
                ) : (
                  <>
                    <CheckCircle2 className="h-3.5 w-3.5 mr-1.5" />
                    Confirmar e Adicionar Marcos
                  </>
                )}
              </Button>
            )}
          </div>
        </div>
      );
    }

    const dados = proposta.dados;
    return (
      <div className="mt-3 rounded-lg border-2 border-acento/50 bg-papel p-3.5 shadow-xs">
        <div className="flex items-center justify-between gap-2 border-b border-borda/60 pb-2">
          <div className="flex items-center gap-2">
            <History className="h-4 w-4 text-acento" />
            <span className="font-bold text-tinta text-sm">
              Proposta de Linha do Tempo: {dados.titulo_linha}
            </span>
          </div>
          {dados.ancoragem_verificada && (
            <span className="inline-flex items-center gap-1 rounded-full bg-emerald-500/15 px-2 py-0.5 text-[11px] font-semibold text-emerald-700 dark:text-emerald-300">
              <ShieldCheck className="h-3.5 w-3.5" />
              Quote-and-Verify OK
            </span>
          )}
        </div>

        <div className="mt-2.5 space-y-1.5 text-xs">
          {dados.marcos.map((m, i) => (
            <div
              key={i}
              className="flex items-start gap-2 rounded border border-borda/70 bg-fundo/60 px-2.5 py-1.5"
            >
              <span className="rounded bg-acento/15 px-1.5 py-0.5 font-mono font-bold text-acento">
                {m.data_periodo_texto}
              </span>
              <span className="text-tinta">{m.titulo}</span>
            </div>
          ))}
        </div>

        <div className="mt-3 flex items-center justify-end gap-2 pt-2 border-t border-borda/50">
          {item.propostaExecutada ? (
            <div className="flex items-center gap-1.5 text-xs font-semibold text-emerald-600 dark:text-emerald-400">
              <CheckCircle2 className="h-4 w-4" />
              {item.mensagemExecucao ?? 'Linha do tempo criada com sucesso!'}
            </div>
          ) : (
            <Button
              variant="primary"
              size="sm"
              disabled={executando}
              onClick={() => handleConfirmarProposta(item.id, proposta)}
            >
              {executando ? (
                <>
                  <Loader2 className="h-3.5 w-3.5 animate-spin mr-1.5" />
                  Gravando...
                </>
              ) : (
                <>
                  <CheckCircle2 className="h-3.5 w-3.5 mr-1.5" />
                  Confirmar e Criar Linha do Tempo
                </>
              )}
            </Button>
          )}
        </div>
      </div>
    );
  };

  if (!aberto) return null;

  return (
    <aside
      aria-label="Assistente de IA Local & Motor Neuro-Simbólico"
      className="w-[400px] xl:w-[440px] flex-none border-l border-borda bg-sup flex flex-col min-h-0 shadow-xs z-20"
    >
      {/* Topo fixo do Painel Integrado ao Ambiente */}
      <div className="flex items-center justify-between gap-2 border-b border-borda bg-card px-3.5 py-2.5">
        <div className="flex items-center gap-2 min-w-0">
          <div className="flex h-7 w-7 shrink-0 items-center justify-center rounded-md bg-acento/15 text-acento border border-acento/30">
            <Bot className="h-4 w-4" />
          </div>
          <div className="min-w-0">
            <h2 className="font-tit font-bold text-sm text-tinta truncate m-0 leading-tight">
              Assistente de IA Local & Motor Neuro-Simbólico
            </h2>
            <div className="flex items-center gap-1.5 text-[10px] text-tinta-suave">
              <span
                className={`h-1.5 w-1.5 rounded-full ${
                  statusIa?.servidor_online ? 'bg-emerald-500' : 'bg-acento'
                }`}
              />
              <span className="truncate">
                {statusIa?.servidor_online
                  ? 'LLM Neural Local Ativa + Guardrails Rust'
                  : 'Motor Neuro-Simbólico Nativo Ativo (0 MB extras)'}
              </span>
            </div>
          </div>
        </div>
        <button
          type="button"
          onClick={onFechar}
          title="Fechar painel do Assistente IA"
          aria-label="Fechar"
          className="rounded-md p-1 text-tinta-suave hover:bg-fundo hover:text-tinta transition-colors cursor-pointer"
        >
          <X className="h-4 w-4" />
        </button>
      </div>

      <div className="flex flex-col flex-1 min-h-0 p-3">
        {/* Cabeçalho de Abas */}
        <div className="flex items-center gap-1.5 border-b border-borda pb-2.5 mb-2.5">
          <button
            type="button"
            onClick={() => setAbaAtiva('chat')}
            className={`flex-1 flex items-center justify-center gap-1.5 rounded-md px-2.5 py-1.5 text-xs font-semibold transition-colors cursor-pointer ${
              abaAtiva === 'chat'
                ? 'bg-acento text-acento-tinta shadow-xs'
                : 'bg-fundo text-tinta-suave hover:text-tinta border border-borda'
            }`}
          >
            <Sparkles className="h-3.5 w-3.5 shrink-0" />
            <span className="truncate">Conversa & Ambiente</span>
          </button>
          <button
            type="button"
            onClick={() => setAbaAtiva('modelos')}
            className={`flex-1 flex items-center justify-center gap-1.5 rounded-md px-2.5 py-1.5 text-xs font-semibold transition-colors cursor-pointer ${
              abaAtiva === 'modelos'
                ? 'bg-acento text-acento-tinta shadow-xs'
                : 'bg-fundo text-tinta-suave hover:text-tinta border border-borda'
            }`}
          >
            <Cpu className="h-3.5 w-3.5 shrink-0" />
            <span className="truncate">Modelos Locais (.GGUF)</span>
          </button>
        </div>

        {erroAcao && (
          <div className="mb-2.5 rounded-md border border-red-500/40 bg-red-500/10 px-3 py-2 text-xs text-red-700 dark:text-red-300">
            {erroAcao}
          </div>
        )}

        {abaAtiva === 'chat' ? (
          <div className="flex flex-col flex-1 min-h-0">
            {/* Atalhos rápidos */}
            <div className="flex flex-wrap items-center gap-1 mb-2">
              <span className="text-[10px] font-medium text-tinta-suave mr-0.5">Atalhos:</span>
              {EXEMPLOS_RAPIDOS.map((ex, i) => (
                <button
                  key={i}
                  type="button"
                  onClick={() => handleEnviar(ex.texto)}
                  disabled={enviando}
                  className="rounded-full border border-borda bg-fundo/80 px-2 py-0.5 text-[10px] text-tinta hover:border-acento hover:text-acento transition-colors cursor-pointer"
                >
                  {ex.rotulo}
                </button>
              ))}
            </div>

            {/* Histórico de mensagens */}
            <div className="flex-1 overflow-y-auto space-y-3 rounded-lg border border-borda bg-fundo/40 p-2.5">
              {conversa.map((msg) => (
                <div
                  key={msg.id}
                  className={`flex flex-col ${
                    msg.autor === 'usuario' ? 'items-end' : 'items-start'
                  }`}
                >
                  <div
                    className={`max-w-[95%] rounded-lg px-3 py-2.5 text-xs ${
                      msg.autor === 'usuario'
                        ? 'bg-acento text-acento-tinta'
                        : 'bg-papel border border-borda text-tinta shadow-2xs'
                    }`}
                  >
                    <div className="flex flex-wrap items-center gap-1.5 mb-1 opacity-80 text-[10px] font-semibold uppercase tracking-wider">
                      {msg.autor === 'usuario' ? (
                        <span>Você</span>
                      ) : (
                        <>
                          <Bot className="h-3.5 w-3.5 text-acento" />
                          <span>Assistente EloTempo</span>
                          {msg.resposta && (
                            <span className="ml-0.5 rounded bg-fundo px-1.5 py-0.5 text-[9px] font-normal text-tinta-suave border border-borda/60">
                              {msg.resposta.modo_execucao}
                            </span>
                          )}
                        </>
                      )}
                    </div>

                    <div className="space-y-1">{renderTextoFormatado(msg.texto)}</div>

                    {/* Ações Automáticas de Registro / Sincronização */}
                    {msg.resposta?.abrir_ficha_pessoa_id && (
                      <div className="mt-2.5 flex items-center justify-between gap-2 rounded-md border border-acento/50 bg-acento/10 px-2.5 py-2">
                        <div className="flex items-center gap-1.5 text-[11px] font-semibold text-tinta">
                          <FileEdit className="h-3.5 w-3.5 text-acento shrink-0" />
                          <span>Ficha de Registro sincronizada</span>
                        </div>
                        <Button
                          variant="primary"
                          size="sm"
                          onClick={() =>
                            onAbrirFichaPessoa?.(
                              msg.resposta!.abrir_ficha_pessoa_id!,
                              msg.resposta!.foco_arvore_id ?? null,
                            )
                          }
                        >
                          Abrir Ficha de Registro
                        </Button>
                      </div>
                    )}

                    {msg.resposta?.rascunho_nova_pessoa && (
                      <div className="mt-2.5 flex items-center justify-between gap-2 rounded-md border border-emerald-500/50 bg-emerald-500/10 px-2.5 py-2">
                        <div className="flex items-center gap-1.5 text-[11px] font-semibold text-emerald-800 dark:text-emerald-200">
                          <UserPlus className="h-3.5 w-3.5 shrink-0" />
                          <span>
                            Cadastro pré-preenchido: {msg.resposta.rascunho_nova_pessoa.nome}{' '}
                            {msg.resposta.rascunho_nova_pessoa.sobrenome ?? ''}
                          </span>
                        </div>
                        <Button
                          variant="primary"
                          size="sm"
                          onClick={() =>
                            onAbrirCadastroNovaPessoa?.(msg.resposta!.rascunho_nova_pessoa!)
                          }
                        >
                          Abrir Página de Registro
                        </Button>
                      </div>
                    )}

                    {/* Proposta de criação (Árvore, Linha do Tempo, Edição ou Parentesco) */}
                    {msg.resposta?.proposta_acao &&
                      renderCardProposta(msg, msg.resposta.proposta_acao)}

                    {/* Opções de navegação (perguntar se quer abrir informações, árvore genealógica ou criar cadastro) */}
                    {msg.resposta?.opcoes_navegacao && msg.resposta.opcoes_navegacao.length > 0 && (
                      <div className="mt-2.5 rounded-md border border-acento/40 bg-acento/5 p-2">
                        <div className="text-[10px] font-semibold text-tinta-suave mb-1.5">
                          {msg.resposta.abstencao
                            ? 'Ação rápida sugerida:'
                            : 'Deseja abrir alguma visualização para esta consulta?'}
                        </div>
                        <div className="flex flex-wrap gap-1.5">
                          {msg.resposta.opcoes_navegacao.map((op, idx) => (
                            <button
                              key={`${op.acao}-${idx}`}
                              type="button"
                              onClick={() => handleExecutarOpcaoNavegacao(op)}
                              className="inline-flex items-center gap-1 rounded-md border border-acento/50 bg-papel px-2 py-1 text-[11px] font-semibold text-tinta hover:bg-acento hover:text-acento-tinta hover:border-acento transition-colors cursor-pointer shadow-2xs"
                            >
                              {op.acao === 'abrir_ficha_pessoa' && (
                                <FileEdit className="h-3 w-3 text-acento shrink-0" />
                              )}
                              {op.acao === 'abrir_arvore' && (
                                <GitBranch className="h-3 w-3 text-acento shrink-0" />
                              )}
                              {op.acao === 'abrir_linha_tempo' && (
                                <History className="h-3 w-3 text-acento shrink-0" />
                              )}
                              {op.acao === 'abrir_cadastro_pessoa' && (
                                <UserPlus className="h-3 w-3 text-emerald-600 shrink-0" />
                              )}
                              <span>{op.rotulo}</span>
                            </button>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* Citações verificadas adicionais (exibidas apenas quando há múltiplos registros, limitadas a no máximo 3) */}
                    {msg.resposta && msg.resposta.citacoes.length > 1 && (
                      <div className="mt-2.5 pt-2 border-t border-borda/60">
                        <div className="text-[10px] font-semibold text-tinta-suave mb-1.5">
                          Principais registros relacionados ({Math.min(3, msg.resposta.citacoes.length)}):
                        </div>
                        <div className="space-y-1.5">
                          {msg.resposta.citacoes
                            .slice(0, 3)
                            .map((cit: CitacaoAcervoIa, idx: number) => (
                              <div
                                key={`${cit.id}-${idx}`}
                                className="flex flex-wrap items-center justify-between gap-1.5 rounded border border-acento/35 bg-acento/5 px-2 py-1 text-[11px]"
                              >
                                <button
                                  type="button"
                                  onClick={() => {
                                    if (cit.tipo === 'pessoa') {
                                      onSelecionarPessoa?.(cit.id, cit.arvore_id ?? null);
                                      onAbrirLinhaTempo?.();
                                    }
                                  }}
                                  title="Ver na Árvore Genealógica e Linha do Tempo"
                                  className="text-left hover:text-acento transition-colors cursor-pointer truncate max-w-[62%]"
                                >
                                  <span className="font-semibold text-tinta">{cit.titulo}</span>{' '}
                                  <span className="text-tinta-suave text-[10px]">({cit.detalhe})</span>
                                </button>

                                {cit.tipo === 'pessoa' && (
                                  <div className="flex items-center gap-1 shrink-0">
                                    <button
                                      type="button"
                                      onClick={() => {
                                        onSelecionarPessoa?.(cit.id, cit.arvore_id ?? null);
                                        onAbrirLinhaTempo?.();
                                      }}
                                      title="Focar na Árvore e abrir Linha do Tempo"
                                      className="inline-flex items-center gap-0.5 rounded border border-borda bg-papel px-1.5 py-0.5 text-[10px] font-medium text-tinta hover:border-acento hover:text-acento transition-colors cursor-pointer"
                                    >
                                      <GitBranch className="h-3 w-3 text-acento" />
                                      <span>Árvore + Linha</span>
                                    </button>
                                    <button
                                      type="button"
                                      onClick={() => {
                                        onAbrirFichaPessoa?.(cit.id, cit.arvore_id ?? null);
                                      }}
                                      title="Abrir Página de Registro (Ficha da Pessoa)"
                                      className="inline-flex items-center gap-0.5 rounded border border-acento/50 bg-acento/15 px-1.5 py-0.5 text-[10px] font-semibold text-acento hover:bg-acento/25 transition-colors cursor-pointer"
                                    >
                                      <FileEdit className="h-3 w-3" />
                                      <span>Registro</span>
                                    </button>
                                  </div>
                                )}
                              </div>
                            ))}
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              ))}
              {enviando && (
                <div className="flex items-center gap-2 text-xs text-tinta-suave px-2">
                  <Loader2 className="h-4 w-4 animate-spin text-acento" />
                  Consultando o banco SQLCipher e sincronizando ambiente...
                </div>
              )}
              <div ref={fimChatRef} />
            </div>

            {/* Caixa de envio */}
            <form
              onSubmit={(e) => {
                e.preventDefault();
                handleEnviar();
              }}
              className="mt-2.5 flex items-end gap-1.5"
            >
              <textarea
                rows={2}
                value={entrada}
                onChange={(e) => setEntrada(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    handleEnviar();
                  }
                }}
                placeholder="Pergunte sobre uma pessoa, peça 'Adicionar informações sobre [Nome]' ou 'Crie uma árvore: ...'"
                className="flex-1 resize-none rounded-lg border border-borda bg-papel px-2.5 py-2 text-xs text-tinta placeholder:text-tinta-suave/70 focus:border-acento focus:outline-none"
              />
              <Button type="submit" variant="primary" disabled={enviando || !entrada.trim()}>
                <Send className="h-4 w-4 mr-1" />
                Enviar
              </Button>
            </form>
          </div>
        ) : (
          /* Aba de Gerenciamento de Modelos Locais Sob Demanda */
          <div className="flex-1 overflow-y-auto space-y-4 pr-1 text-xs">
            {/* Esta caixa existe para evitar uma frustração concreta: baixar 1 GB
                e descobrir que o botão "Ativar" não tem o que ativar. O modelo
                são os pesos; quem os executa é um motor à parte, que o EloTempo
                não embarca. Dizer isso antes do download é o mínimo. */}
            <div className="rounded-lg border border-borda bg-fundo/50 p-3.5">
              <div className="flex items-start gap-2.5">
                <ShieldCheck className="h-5 w-5 text-emerald-600 dark:text-emerald-400 shrink-0 mt-0.5" />
                <div className="space-y-2">
                  <div className="font-bold text-tinta text-sm">
                    O assistente já funciona. Esta aba é opcional.
                  </div>
                  <p className="text-tinta-suave leading-relaxed">
                    Sem baixar nada, o EloTempo já responde perguntas sobre quem está no
                    seu acervo e já monta árvores e linhas do tempo a partir de um texto
                    colado no chat. Tudo isso roda dentro do programa, sem internet, e é o
                    que a maioria das pessoas vai usar.
                  </p>
                  <p className="text-tinta-suave leading-relaxed">
                    Um modelo de linguagem acrescenta <strong>respostas mais fluentes</strong> e
                    ajuda com textos biográficos longos e confusos. Ele nunca inventa fatos:
                    continua preso aos mesmos registros do seu acervo.
                  </p>
                </div>
              </div>
            </div>

            <div className="rounded-lg border border-amber-500/40 bg-amber-500/10 p-3.5">
              <div className="flex items-start gap-2.5">
                <AlertTriangle className="h-5 w-5 text-amber-600 dark:text-amber-400 shrink-0 mt-0.5" />
                <div className="space-y-2">
                  <div className="font-bold text-tinta text-sm">
                    Como funciona a ativação do modelo local (.GGUF)
                  </div>
                  <p className="text-tinta-suave leading-relaxed">
                    O arquivo <code>.gguf</code> contém os pesos do modelo. Ao clicar em{' '}
                    <strong>Ativar</strong> no Windows, o EloTempo inicia automaticamente o motor{' '}
                    <strong>llama-server</strong> (baixando-o sob demanda na primeira vez, ~19 MB)
                    na porta dedicada <code>127.0.0.1:18080</code> para não conflitar com outros
                    programas da sua máquina.
                  </p>
                  <p className="text-tinta-suave leading-relaxed">
                    Você também pode conectar o EloTempo ao <strong>Ollama</strong> (
                    <code>127.0.0.1:11434</code>) ou a uma instância própria do{' '}
                    <strong>llama-server</strong>. O endereço só aceita a sua própria máquina — é o
                    que garante que nome e data nenhuma saia do computador.
                  </p>
                </div>
              </div>
            </div>

            {/* Progresso de download ativo */}
            {statusIa?.download_em_andamento && (
              <div className="rounded-lg border-2 border-acento bg-acento/10 p-3.5 space-y-2">
                <div className="flex items-center justify-between">
                  <span className="font-bold text-tinta flex items-center gap-2">
                    <Loader2 className="h-4 w-4 animate-spin text-acento" />
                    Baixando modelo {statusIa.download_modelo_id}...
                  </span>
                  <span className="font-mono font-semibold text-acento">
                    {formatarBytesModelo(statusIa.download_bytes_atuais)} /{' '}
                    {formatarBytesModelo(statusIa.download_bytes_totais)} (
                    {calcularProgressoDownload(
                      statusIa.download_bytes_atuais,
                      statusIa.download_bytes_totais,
                    )}
                    %)
                  </span>
                </div>
                <div className="h-2.5 w-full overflow-hidden rounded-full bg-borda">
                  <div
                    className="h-full bg-acento transition-all duration-300"
                    style={{
                      width: `${calcularProgressoDownload(
                        statusIa.download_bytes_atuais,
                        statusIa.download_bytes_totais,
                      )}%`,
                    }}
                  />
                </div>
                <div className="flex justify-end">
                  <Button
                    variant="secondary"
                    size="sm"
                    onClick={() => cancelarDownloadModeloIa()}
                  >
                    <Square className="h-3.5 w-3.5 mr-1" />
                    Cancelar Download
                  </Button>
                </div>
              </div>
            )}

            {/* Catálogo de Modelos GGUF */}
            <div className="space-y-2.5">
              <div className="flex items-center justify-between">
                <span className="font-bold text-tinta text-sm">
                  Catálogo de Modelos Quantizados (GGUF)
                </span>
                <Button variant="secondary" size="sm" onClick={handleImportarGguf}>
                  <FolderUp className="h-3.5 w-3.5 mr-1.5" />
                  Importar arquivo .GGUF do disco
                </Button>
              </div>

              {statusIa?.modelos_catalogo.map((m) => {
                const esteAtivo =
                  Boolean(statusIa.servidor_online) && statusIa.modelo_ativo_id === m.id;
                const ativandoEste = ativandoModeloId === m.id;

                return (
                  <div
                    key={m.id}
                    className={`flex flex-col sm:flex-row sm:items-center justify-between gap-3 rounded-lg border p-3.5 ${
                      esteAtivo
                        ? 'border-emerald-500/60 bg-emerald-500/5'
                        : 'border-borda bg-papel'
                    }`}
                  >
                    <div className="space-y-1">
                      <div className="flex flex-wrap items-center gap-2">
                        <span className="font-bold text-tinta">{m.nome}</span>
                        {m.instalado && (
                          <span className="rounded-full bg-emerald-500/15 px-2 py-0.5 text-[10px] font-semibold text-emerald-700 dark:text-emerald-300">
                            Instalado ({formatarBytesModelo(m.tamanho_em_disco)})
                          </span>
                        )}
                        {esteAtivo && (
                          <span className="inline-flex items-center gap-1 rounded-full bg-emerald-600 px-2.5 py-0.5 text-[10px] font-bold text-white">
                            <CheckCircle2 className="h-3 w-3" />
                            Ativo na RAM ({statusIa.endpoint_local})
                          </span>
                        )}
                      </div>
                      <p className="text-tinta-suave">{m.descricao}</p>
                      <div className="text-[11px] text-tinta-suave/80 font-mono">
                        Tamanho estimado: {formatarBytesModelo(m.tamanho_bytes_estimado)} • RAM
                        mínima recomendada: {m.ram_recomendada_gb} GB
                      </div>
                    </div>

                    <div className="flex items-center gap-2 shrink-0">
                      {m.instalado ? (
                        <>
                          {esteAtivo ? (
                            <Button
                              variant="secondary"
                              size="sm"
                              onClick={() =>
                                pararMotorIaLocal()
                                  .then(setStatusIa)
                                  .catch((e) => setErroAcao(e.message))
                              }
                            >
                              <Square className="h-3.5 w-3.5 mr-1" />
                              Desativar
                            </Button>
                          ) : (
                            <Button
                              variant="primary"
                              size="sm"
                              disabled={ativandoModeloId !== null}
                              onClick={() => {
                                setErroAcao(null);
                                setAtivandoModeloId(m.id);
                                iniciarMotorIaLocal(m.id)
                                  .then(setStatusIa)
                                  .catch((e) => setErroAcao(e.message))
                                  .finally(() => setAtivandoModeloId(null));
                              }}
                            >
                              {ativandoEste ? (
                                <>
                                  <Loader2 className="h-3.5 w-3.5 animate-spin mr-1" />
                                  Ativando...
                                </>
                              ) : (
                                <>
                                  <Play className="h-3.5 w-3.5 mr-1" />
                                  Ativar
                                </>
                              )}
                            </Button>
                          )}
                          <Button
                            variant="secondary"
                            size="sm"
                            disabled={esteAtivo || ativandoEste}
                            onClick={() => removerModeloIa(m.id).then(carregarStatus)}
                            title="Remover arquivo GGUF do disco"
                          >
                            <Trash2 className="h-3.5 w-3.5" />
                          </Button>
                        </>
                      ) : (
                        <Button
                          variant="secondary"
                          size="sm"
                          disabled={statusIa?.download_em_andamento}
                          onClick={() =>
                            iniciarDownloadModeloIa(m.id)
                              .then(carregarStatus)
                              .catch((e) => setErroAcao(e.message))
                          }
                        >
                          <Download className="h-3.5 w-3.5 mr-1.5" />
                          Baixar Sob Demanda ({formatarBytesModelo(m.tamanho_bytes_estimado)})
                        </Button>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>

            {/* Configuração de Endpoint Local (llama-server / Ollama) */}
            <div className="rounded-lg border border-borda bg-papel p-3.5 space-y-2.5">
              <div className="font-bold text-tinta">
                Conexão com Servidor Local (llama-server / Ollama)
              </div>
              <p className="text-tinta-suave">
                O EloTempo utiliza por padrão a porta <code>18080</code> para o{' '}
                <code>llama-server</code> integrado, ou conecta-se ao <code>Ollama</code> (porta{' '}
                <code>11434</code>) em <code>127.0.0.1</code> sem enviar nenhum byte para a
                internet:
              </p>
              <div className="flex items-center gap-2">
                <input
                  type="text"
                  value={endpointInput}
                  onChange={(e) => setEndpointInput(e.target.value)}
                  className="flex-1 rounded border border-borda bg-fundo px-2.5 py-1.5 font-mono text-xs text-tinta"
                />
                <Button variant="secondary" size="sm" onClick={handleSalvarEndpoint}>
                  Testar e Salvar Porta
                </Button>
                {statusIa?.servidor_online && (
                  <Button
                    variant="secondary"
                    size="sm"
                    onClick={() => pararMotorIaLocal().then(setStatusIa)}
                  >
                    Descarregar da RAM
                  </Button>
                )}
              </div>
              {statusIa?.pasta_modelos && (
                <div className="text-[11px] text-tinta-suave font-mono">
                  Pasta local dos modelos: {statusIa.pasta_modelos}
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </aside>
  );
}
