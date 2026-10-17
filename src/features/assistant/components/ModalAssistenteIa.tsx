import { useEffect, useRef, useState } from 'react';
import { open } from '@tauri-apps/plugin-dialog';
import { useQueryClient } from '@tanstack/react-query';
import {
  AlertTriangle,
  Bot,
  CheckCircle2,
  Cpu,
  Download,
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
} from 'lucide-react';
import { Modal } from '../../../components/ui/Modal';
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
  type PropostaAcaoIa,
  type RespostaAssistenteIa,
  type StatusIaLocal,
} from '../../../lib/api';

interface ModalAssistenteIaProps {
  aberto: boolean;
  onFechar: () => void;
  onSelecionarPessoa?: (pessoaId: string) => void;
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
    rotulo: 'Filhos de D. Pedro II',
    texto: 'Quem foram os filhos e a esposa de D. Pedro II?',
  },
  {
    rotulo: 'Resumo do Acervo',
    texto: 'Quantas pessoas e quantas árvores existem no resumo do acervo?',
  },
  {
    rotulo: 'Criar Árvore (Cenário A)',
    texto:
      'Crie uma árvore genealógica: Giuseppe Rossi (1882-1954) casou-se em 1905 com Teresa Bianchi (1885-1962). Tiveram os filhos Luigi Rossi (1906), Anna Rossi (1908) e Marco Rossi (1912).',
  },
  {
    rotulo: 'Criar Linha do Tempo (Cenário A)',
    texto:
      'Crie uma linha do tempo da família Rossi: Em 1905 casamento de Giuseppe e Teresa em Gênova; Em 1914 desembarque da família no Porto de Santos; Em 1928 inauguração da padaria familiar em São Paulo.',
  },
];

export function ModalAssistenteIa({
  aberto,
  onFechar,
  onSelecionarPessoa,
  onArvoreCriada,
  onLinhaTempoCriada,
}: ModalAssistenteIaProps) {
  const qc = useQueryClient();
  const [abaAtiva, setAbaAtiva] = useState<'chat' | 'modelos'>('chat');
  const [entrada, setEntrada] = useState('');
  const [enviando, setEnviando] = useState(false);
  const [executandoId, setExecutandoId] = useState<string | null>(null);
  const [statusIa, setStatusIa] = useState<StatusIaLocal | null>(null);
  const [endpointInput, setEndpointInput] = useState('http://127.0.0.1:8080');
  const [erroAcao, setErroAcao] = useState<string | null>(null);
  const fimChatRef = useRef<HTMLDivElement | null>(null);

  const [conversa, setConversa] = useState<ItemConversa[]>([
    {
      id: 'boas-vindas',
      autor: 'assistente',
      texto:
        'Olá! Sou o **Assistente Local do EloTempo**.\n\n' +
        'Opero com **Fidelidade Factual Estrita (Cenário A)**:\n' +
        '- Respondo perguntas usando **exclusivamente** os registros do seu banco de dados SQLCipher.\n' +
        '- Posso estruturar e criar **novas Árvores Genealógicas** ou **Linhas do Tempo** a partir de textos biográficos que você colar aqui no chat, validando cada nome e data com o verificador anti-alucinação **Quote-and-Verify**.\n' +
        '- Se você perguntar sobre algo que não está no banco nem na conversa, avisarei com transparência que não possuo esses dados.',
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

  const handleConfirmarProposta = async (itemId: string, proposta: PropostaAcaoIa) => {
    setExecutandoId(itemId);
    setErroAcao(null);
    try {
      const res = await executarPropostaIa(proposta);
      await qc.invalidateQueries({ queryKey: ['arvores'] });
      await qc.invalidateQueries({ queryKey: ['pessoas'] });
      await qc.invalidateQueries({ queryKey: ['linhas-contexto'] });

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

  return (
    <Modal
      isOpen={aberto}
      onClose={onFechar}
      title="Assistente de IA Local & Motor Neuro-Simbólico"
      className="max-w-4xl"
    >

      <div className="flex flex-col h-[72vh] max-h-[680px]">
        {/* Cabeçalho de Abas e Status */}
        <div className="flex flex-wrap items-center justify-between gap-2 border-b border-borda pb-3 mb-3">
          <div className="flex items-center gap-1.5">
            <button
              type="button"
              onClick={() => setAbaAtiva('chat')}
              className={`flex items-center gap-1.5 rounded-md px-3 py-1.5 text-xs font-semibold transition-colors ${
                abaAtiva === 'chat'
                  ? 'bg-acento text-acento-tinta shadow-xs'
                  : 'bg-fundo text-tinta-suave hover:text-tinta border border-borda'
              }`}
            >
              <Sparkles className="h-3.5 w-3.5" />
              Conversa & Criação Guiada (Cenário A)
            </button>
            <button
              type="button"
              onClick={() => setAbaAtiva('modelos')}
              className={`flex items-center gap-1.5 rounded-md px-3 py-1.5 text-xs font-semibold transition-colors ${
                abaAtiva === 'modelos'
                  ? 'bg-acento text-acento-tinta shadow-xs'
                  : 'bg-fundo text-tinta-suave hover:text-tinta border border-borda'
              }`}
            >
              <Cpu className="h-3.5 w-3.5" />
              Modelos Locais Sob Demanda (.GGUF)
            </button>
          </div>

          <div className="flex items-center gap-2 text-[11px]">
            <span
              className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 font-medium border ${
                statusIa?.servidor_online
                  ? 'border-emerald-500/40 bg-emerald-500/10 text-emerald-700 dark:text-emerald-300'
                  : 'border-acento/40 bg-acento/10 text-tinta'
              }`}
            >
              <span
                className={`h-2 w-2 rounded-full ${
                  statusIa?.servidor_online ? 'bg-emerald-500' : 'bg-acento'
                }`}
              />
              {statusIa?.servidor_online
                ? 'LLM Neural Local Ativa + Guardrails Rust'
                : 'Motor Neuro-Simbólico Nativo Ativo (0 MB extras)'}
            </span>
          </div>
        </div>

        {erroAcao && (
          <div className="mb-3 rounded-md border border-red-500/40 bg-red-500/10 px-3 py-2 text-xs text-red-700 dark:text-red-300">
            {erroAcao}
          </div>
        )}

        {abaAtiva === 'chat' ? (
          <div className="flex flex-col flex-1 min-h-0">
            {/* Atalhos rápidos */}
            <div className="flex flex-wrap items-center gap-1.5 mb-2.5">
              <span className="text-[11px] font-medium text-tinta-suave mr-1">Exemplos:</span>
              {EXEMPLOS_RAPIDOS.map((ex, i) => (
                <button
                  key={i}
                  type="button"
                  onClick={() => handleEnviar(ex.texto)}
                  disabled={enviando}
                  className="rounded-full border border-borda bg-fundo/80 px-2.5 py-1 text-[11px] text-tinta hover:border-acento hover:text-acento transition-colors"
                >
                  {ex.rotulo}
                </button>
              ))}
            </div>

            {/* Histórico de mensagens */}
            <div className="flex-1 overflow-y-auto space-y-3 rounded-lg border border-borda bg-fundo/40 p-3">
              {conversa.map((msg) => (
                <div
                  key={msg.id}
                  className={`flex flex-col ${
                    msg.autor === 'usuario' ? 'items-end' : 'items-start'
                  }`}
                >
                  <div
                    className={`max-w-[90%] rounded-lg px-3.5 py-2.5 text-xs ${
                      msg.autor === 'usuario'
                        ? 'bg-acento text-acento-tinta'
                        : 'bg-papel border border-borda text-tinta shadow-2xs'
                    }`}
                  >
                    <div className="flex items-center gap-1.5 mb-1 opacity-80 text-[10px] font-semibold uppercase tracking-wider">
                      {msg.autor === 'usuario' ? (
                        <span>Você</span>
                      ) : (
                        <>
                          <Bot className="h-3.5 w-3.5 text-acento" />
                          <span>Assistente EloTempo</span>
                          {msg.resposta && (
                            <span className="ml-1 rounded bg-fundo px-1.5 py-0.5 text-[10px] font-normal text-tinta-suave border border-borda/60">
                              {msg.resposta.modo_execucao}
                            </span>
                          )}
                        </>
                      )}
                    </div>

                    <div className="space-y-1">{renderTextoFormatado(msg.texto)}</div>

                    {/* Proposta de criação (Árvore ou Linha do Tempo) */}
                    {msg.resposta?.proposta_acao &&
                      renderCardProposta(msg, msg.resposta.proposta_acao)}

                    {/* Citações verificadas do banco */}
                    {msg.resposta && msg.resposta.citacoes.length > 0 && (
                      <div className="mt-2.5 pt-2 border-t border-borda/60">
                        <div className="text-[10px] font-semibold text-tinta-suave mb-1">
                          Registros verificados no SQLCipher ({msg.resposta.citacoes.length}):
                        </div>
                        <div className="flex flex-wrap gap-1.5">
                          {msg.resposta.citacoes.map((cit: CitacaoAcervoIa, idx: number) => (
                            <button
                              key={`${cit.id}-${idx}`}
                              type="button"
                              onClick={() => {
                                if (cit.tipo === 'pessoa' && onSelecionarPessoa) {
                                  onSelecionarPessoa(cit.id);
                                  onFechar();
                                }
                              }}
                              className="inline-flex items-center gap-1 rounded border border-acento/40 bg-acento/10 px-2 py-0.5 text-[11px] font-medium text-tinta hover:bg-acento/20 transition-colors"
                            >
                              <span className="font-semibold">{cit.titulo}</span>
                              <span className="text-tinta-suave">({cit.detalhe})</span>
                            </button>
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
                  Consultando o banco SQLCipher e verificando ancoragem factual...
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
              className="mt-3 flex items-end gap-2"
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
                placeholder="Pergunte sobre pessoas do acervo ou cole um texto biográfico dizendo 'Crie uma árvore: ...' ou 'Crie uma linha do tempo: ...'"
                className="flex-1 resize-none rounded-lg border border-borda bg-papel px-3 py-2 text-xs text-tinta placeholder:text-tinta-suave/70 focus:border-acento focus:outline-none"
              />
              <Button type="submit" variant="primary" disabled={enviando || !entrada.trim()}>
                <Send className="h-4 w-4 mr-1.5" />
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
                    Antes de baixar: o modelo sozinho não roda
                  </div>
                  <p className="text-tinta-suave leading-relaxed">
                    O arquivo <code>.gguf</code> são os pesos do modelo. Para usá-lo é preciso
                    um <strong>motor de execução</strong> instalado à parte, que o EloTempo não
                    acompanha. Sem ele, o download ocupa espaço e o botão{' '}
                    <strong>Ativar</strong> não tem o que ativar.
                  </p>
                  <p className="text-tinta-suave leading-relaxed">
                    Os dois motores compatíveis são o <strong>Ollama</strong> e o{' '}
                    <strong>llama-server</strong>, do projeto llama.cpp. Instalado qualquer um
                    dos dois, o EloTempo o encontra sozinho em{' '}
                    <code>127.0.0.1:11434</code> ou <code>127.0.0.1:8080</code>. O endereço só
                    aceita a sua própria máquina — é o que garante que nome e data nenhuma
                    saia do computador.
                  </p>
                  <p className="text-tinta-suave leading-relaxed">
                    Se não quiser instalar nada, pode fechar esta aba sem perder recurso
                    algum: o assistente continua respondendo e criando árvores.
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

              {statusIa?.modelos_catalogo.map((m) => (
                <div
                  key={m.id}
                  className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 rounded-lg border border-borda bg-papel p-3.5"
                >
                  <div className="space-y-1">
                    <div className="flex items-center gap-2">
                      <span className="font-bold text-tinta">{m.nome}</span>
                      {m.instalado && (
                        <span className="rounded-full bg-emerald-500/15 px-2 py-0.5 text-[10px] font-semibold text-emerald-700 dark:text-emerald-300">
                          Instalado ({formatarBytesModelo(m.tamanho_em_disco)})
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
                        <Button
                          variant="primary"
                          size="sm"
                          onClick={() => iniciarMotorIaLocal(m.id).then(setStatusIa).catch((e) => setErroAcao(e.message))}
                        >
                          <Play className="h-3.5 w-3.5 mr-1" />
                          Ativar
                        </Button>
                        <Button
                          variant="secondary"
                          size="sm"
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
              ))}
            </div>

            {/* Configuração de Endpoint Local (llama-server / Ollama) */}
            <div className="rounded-lg border border-borda bg-papel p-3.5 space-y-2.5">
              <div className="font-bold text-tinta">
                Conexão com Servidor Local (llama-server / Ollama)
              </div>
              <p className="text-tinta-suave">
                Se você já executa <code>llama-server</code> (porta 8080) ou <code>Ollama</code>{' '}
                (porta 11434) na sua máquina, o EloTempo conecta-se automaticamente em{' '}
                <code>127.0.0.1</code> sem enviar nenhum byte para a internet:
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
    </Modal>
  );
}
