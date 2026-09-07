import React, { useState, useEffect } from 'react';
import { useGatekeeper } from '../../security';
import { useI18n } from '../../../i18n/I18nContext';
import {
  X,
  Search,
  ArrowRightLeft,
  Check,
  AlertTriangle,
  Sparkles,
  Users,
  Layers,
  ArrowRight,
  ShieldCheck,
  UserCheck,
  UserMinus,
  RefreshCw,
} from 'lucide-react';
import { useQueryClient } from '@tanstack/react-query';
import { buscarPessoas } from '../../../lib/api/tree';
import {
  fundirPessoas,
  buscarDuplicatasPotenciais,
  type CandidatoDuplicata,
  type ResumoFusao,
} from '../../../lib/api/fusao';
import type { PersonNode } from '../../../types';

interface ModalFusaoPessoasProps {
  aberto: boolean;
  aoFechar: () => void;
  pessoaInicialId?: string | null;
  onFusaoConcluida?: (idMestre: string) => void;
}

export const ModalFusaoPessoas: React.FC<ModalFusaoPessoasProps> = ({
  aberto,
  aoFechar,
  pessoaInicialId,
  onFusaoConcluida,
}) => {
  const queryClient = useQueryClient();
  const { t } = useI18n();
  const { executarComGatekeeper } = useGatekeeper();

  const [aba, setAba] = useState<'comparar' | 'sugestoes'>('comparar');

  const [pessoaMestre, setPessoaMestre] = useState<PersonNode | null>(null);
  const [pessoaAbsorver, setPessoaAbsorver] = useState<PersonNode | null>(null);

  const [buscaMestre, setBuscaMestre] = useState('');
  const [buscaAbsorver, setBuscaAbsorver] = useState('');
  const [resultadosMestre, setResultadosMestre] = useState<PersonNode[]>([]);
  const [resultadosAbsorver, setResultadosAbsorver] = useState<PersonNode[]>([]);

  const [duplicatas, setDuplicatas] = useState<CandidatoDuplicata[]>([]);
  const [carregandoDuplicatas, setCarregandoDuplicatas] = useState(false);

  const [executando, setExecutando] = useState(false);
  const [confirmando, setConfirmando] = useState(false);
  const [resumoSucesso, setResumoSucesso] = useState<ResumoFusao | null>(null);
  const [erro, setErro] = useState<string | null>(null);

  // Inicializa a pessoa mestre com a pessoa fornecida (ex.: pela ficha)
  useEffect(() => {
    if (aberto && pessoaInicialId) {
      buscarPessoas(pessoaInicialId, 5).then((lista) => {
        const encontrada = lista.find((p) => p.id === pessoaInicialId);
        if (encontrada) {
          setPessoaMestre(encontrada);
        }
      });
    }
  }, [aberto, pessoaInicialId]);

  // Carrega sugestões de duplicatas
  const carregarSugestoes = () => {
    setCarregandoDuplicatas(true);
    setErro(null);
    buscarDuplicatasPotenciais(30)
      .then((lista) => {
        setDuplicatas(lista);
      })
      .catch((err) => {
        console.error('Erro ao buscar duplicatas:', err);
      })
      .finally(() => {
        setCarregandoDuplicatas(false);
      });
  };

  useEffect(() => {
    if (aberto && aba === 'sugestoes') {
      carregarSugestoes();
    }
  }, [aberto, aba]);

  // Busca de pessoas para Mestre
  useEffect(() => {
    if (buscaMestre.trim().length >= 2) {
      const timer = setTimeout(() => {
        buscarPessoas(buscaMestre.trim(), 10).then(setResultadosMestre);
      }, 200);
      return () => clearTimeout(timer);
    } else {
      setResultadosMestre([]);
    }
  }, [buscaMestre]);

  // Busca de pessoas para Absorver
  useEffect(() => {
    if (buscaAbsorver.trim().length >= 2) {
      const timer = setTimeout(() => {
        buscarPessoas(buscaAbsorver.trim(), 10).then(setResultadosAbsorver);
      }, 200);
      return () => clearTimeout(timer);
    } else {
      setResultadosAbsorver([]);
    }
  }, [buscaAbsorver]);

  if (!aberto) return null;

  const handleInverter = () => {
    const temp = pessoaMestre;
    setPessoaMestre(pessoaAbsorver);
    setPessoaAbsorver(temp);
    setConfirmando(false);
    setErro(null);
  };

  const handleSelecionarSugestao = (sugestao: CandidatoDuplicata) => {
    setPessoaMestre(sugestao.pessoa_a);
    setPessoaAbsorver(sugestao.pessoa_b);
    setAba('comparar');
    setConfirmando(false);
    setErro(null);
  };

  const handleExecutarFusao = async () => {
    if (!pessoaMestre || !pessoaAbsorver) return;

    if (pessoaMestre.id === pessoaAbsorver.id) {
      setErro('Você selecionou o mesmo registro para ambos os lados.');
      return;
    }

    await executarComGatekeeper(t('seguranca', 'gatekeeperDescFusao'), async (ticket: string) => {
      setExecutando(true);
      setErro(null);

      try {
        const resumo = await fundirPessoas(pessoaMestre.id, pessoaAbsorver.id, ticket);
        setResumoSucesso(resumo);
        setConfirmando(false);

        // Invalida caches do React Query para remontar a árvore e ficha atualizadas
        await queryClient.invalidateQueries({ queryKey: ['pessoas'] });
        await queryClient.invalidateQueries({ queryKey: ['arvore'] });
        await queryClient.invalidateQueries({ queryKey: ['estatisticas'] });
        await queryClient.invalidateQueries({ queryKey: ['arvores'] });
        await queryClient.invalidateQueries({ queryKey: ['pessoa'] });

        if (onFusaoConcluida) {
          onFusaoConcluida(pessoaMestre.id);
        }
      } catch (err) {
        console.error('Falha na fusão de pessoas:', err);
        setErro(err instanceof Error ? err.message : String(err));
      } finally {
        setExecutando(false);
      }
    });
  };

  const reiniciar = () => {
    setPessoaAbsorver(null);
    setResumoSucesso(null);
    setConfirmando(false);
    setErro(null);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-in fade-in">
      <div className="bg-card border border-borda rounded-raio shadow-sombra w-full max-w-4xl max-h-[92vh] flex flex-col overflow-hidden text-tinta">
        {/* Cabeçalho */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-borda bg-sup/50">
          <div className="flex items-center gap-2.5">
            <div className="p-2 rounded-raio-s bg-acento/10 text-acento">
              <Users className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base font-serif font-bold text-tinta">
                Fusão de Pessoas Duplicadas
              </h2>
              <p className="text-xs text-tinta3">
                Unifique registros duplicados, transferindo automaticamente filiações, uniões, filhos, eventos e documentos.
              </p>
            </div>
          </div>
          <button
            type="button"
            onClick={aoFechar}
            className="p-1.5 rounded-raio-s text-tinta3 hover:text-tinta hover:bg-sup transition-colors cursor-pointer"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Abas de Navegação */}
        <div className="flex items-center gap-2 px-6 pt-3 border-b border-borda bg-sup/20 text-xs font-semibold">
          <button
            type="button"
            onClick={() => setAba('comparar')}
            className={`pb-2.5 px-3 border-b-2 transition-colors cursor-pointer flex items-center gap-1.5 ${
              aba === 'comparar'
                ? 'border-acento text-acento font-bold'
                : 'border-transparent text-tinta3 hover:text-tinta'
            }`}
          >
            <Layers className="w-3.5 h-3.5" />
            <span>Comparar & Fundir Registros</span>
          </button>

          <button
            type="button"
            onClick={() => setAba('sugestoes')}
            className={`pb-2.5 px-3 border-b-2 transition-colors cursor-pointer flex items-center gap-1.5 ${
              aba === 'sugestoes'
                ? 'border-acento text-acento font-bold'
                : 'border-transparent text-tinta3 hover:text-tinta'
            }`}
          >
            <Sparkles className="w-3.5 h-3.5" />
            <span>Sugestões Automáticas</span>
            {duplicatas.length > 0 && (
              <span className="px-1.5 py-0.2 rounded-full bg-acento/20 text-acento text-[10px]">
                {duplicatas.length}
              </span>
            )}
          </button>
        </div>

        {/* Corpo do Modal */}
        <div className="p-6 overflow-y-auto flex-1 flex flex-col gap-6">
          {/* ABA 1: SUGESTÕES AUTOMÁTICAS */}
          {aba === 'sugestoes' && (
            <div className="flex flex-col gap-4">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-xs font-bold text-tinta">
                    Duplicatas Potenciais Detectadas no Acervo
                  </h3>
                  <p className="text-[11px] text-tinta3">
                    Algoritmo inteligente de detecção por similaridade de nomes e coincidência de datas de nascimento e falecimento.
                  </p>
                </div>
                <button
                  type="button"
                  onClick={carregarSugestoes}
                  disabled={carregandoDuplicatas}
                  className="px-2.5 py-1 rounded bg-sup hover:bg-card border border-borda text-xs text-tinta flex items-center gap-1.5 cursor-pointer disabled:opacity-50 transition-colors"
                >
                  <RefreshCw className={`w-3.5 h-3.5 ${carregandoDuplicatas ? 'animate-spin' : ''}`} />
                  <span>Atualizar Varredura</span>
                </button>
              </div>

              {carregandoDuplicatas ? (
                <div className="py-12 flex flex-col items-center justify-center gap-2 text-tinta3">
                  <div className="w-6 h-6 border-2 border-acento border-t-transparent rounded-full animate-spin" />
                  <span className="text-xs">Varrendo acervo em busca de possíveis duplicatas...</span>
                </div>
              ) : duplicatas.length === 0 ? (
                <div className="py-12 text-center text-xs text-tinta3 bg-sup/30 rounded-raio border border-dashed border-borda">
                  Nenhuma duplicata óbvia encontrada no acervo. Você pode comparar e fundir registros manualmente na aba "Comparar & Fundir".
                </div>
              ) : (
                <div className="flex flex-col gap-2.5 max-h-[50vh] overflow-y-auto pr-1">
                  {duplicatas.map((cand, idx) => (
                    <div
                      key={idx}
                      className="p-3.5 rounded-raio bg-sup/40 border border-borda hover:border-acento/40 flex items-center justify-between gap-4 transition-all"
                    >
                      <div className="flex items-center gap-4 flex-1 min-w-0">
                        {/* Pessoa A */}
                        <div className="flex items-center gap-2.5 flex-1 min-w-0">
                          <div className="w-7 h-7 rounded-full bg-card border border-borda flex items-center justify-center text-xs font-bold flex-none text-acento">
                            {cand.pessoa_a.nome[0]}
                          </div>
                          <div className="min-w-0">
                            <div className="text-xs font-semibold text-tinta truncate">
                              {cand.pessoa_a.nome} {cand.pessoa_a.sobrenome ?? ''}
                            </div>
                            <div className="text-[10px] text-tinta3">
                              {cand.pessoa_a.sexo === 'M' ? 'Masculino' : cand.pessoa_a.sexo === 'F' ? 'Feminino' : 'Outro'}
                            </div>
                          </div>
                        </div>

                        {/* Indicador de Similaridade */}
                        <div className="flex flex-col items-center flex-none">
                          <span className="text-[11px] font-bold text-acento">
                            {cand.score}% compatível
                          </span>
                          <span className="text-[10px] text-tinta3 max-w-[200px] truncate text-center" title={cand.motivo}>
                            {cand.motivo}
                          </span>
                        </div>

                        {/* Pessoa B */}
                        <div className="flex items-center gap-2.5 flex-1 min-w-0">
                          <div className="w-7 h-7 rounded-full bg-card border border-borda flex items-center justify-center text-xs font-bold flex-none text-acento">
                            {cand.pessoa_b.nome[0]}
                          </div>
                          <div className="min-w-0">
                            <div className="text-xs font-semibold text-tinta truncate">
                              {cand.pessoa_b.nome} {cand.pessoa_b.sobrenome ?? ''}
                            </div>
                            <div className="text-[10px] text-tinta3">
                              {cand.pessoa_b.sexo === 'M' ? 'Masculino' : cand.pessoa_b.sexo === 'F' ? 'Feminino' : 'Outro'}
                            </div>
                          </div>
                        </div>
                      </div>

                      <button
                        type="button"
                        onClick={() => handleSelecionarSugestao(cand)}
                        className="px-3 py-1.5 rounded-raio-s bg-acento/10 hover:bg-acento/20 border border-acento/30 text-acento text-xs font-semibold flex items-center gap-1.5 flex-none cursor-pointer transition-colors"
                      >
                        <span>Revisar</span>
                        <ArrowRight className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* ABA 2: COMPARAR & FUNDIR REGISTROS */}
          {aba === 'comparar' && (
            <>
              {/* Resumo de Sucesso */}
              {resumoSucesso && (
                <div className="p-4 rounded-raio bg-emerald-500/10 border border-emerald-500/30 text-emerald-700 dark:text-emerald-400 flex flex-col gap-2">
                  <div className="flex items-center gap-2 font-bold text-xs">
                    <Check className="w-4 h-4" />
                    <span>Fusão de registros realizada com sucesso!</span>
                  </div>
                  <p className="text-xs text-tinta2">
                    O registro <strong>{resumoSucesso.nome_mestre}</strong> absorveu todas as dependências da duplicata.
                  </p>
                  <div className="flex items-center gap-4 text-xs font-semibold mt-1">
                    <span>• {resumoSucesso.unioes_afetadas} união(ões) atualizada(s)</span>
                    <span>• {resumoSucesso.eventos_transferidos} evento(s) transferido(s)</span>
                    <span>• {resumoSucesso.documentos_transferidos} documento(s) transferido(s)</span>
                  </div>
                  <div className="mt-2 flex justify-end">
                    <button
                      type="button"
                      onClick={reiniciar}
                      className="px-3 py-1.5 bg-card border border-borda text-xs rounded font-semibold text-tinta hover:bg-sup cursor-pointer"
                    >
                      Realizar Nova Fusão
                    </button>
                  </div>
                </div>
              )}

              {/* Mensagem de Erro */}
              {erro && (
                <div className="p-3.5 rounded-raio bg-erro/10 border border-erro/30 text-erro text-xs flex items-center gap-2.5">
                  <AlertTriangle className="w-4 h-4 flex-none" />
                  <span>{erro}</span>
                </div>
              )}

              {/* Seletor Lado a Lado */}
              <div className="grid grid-cols-1 md:grid-cols-[1fr,auto,1fr] gap-4 items-start">
                {/* LADO ESQUERDO: REGISTRO MESTRE (MANTIDO) */}
                <div className="flex flex-col gap-3 p-4 rounded-raio border-2 border-emerald-500/40 bg-emerald-500/5">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-1.5 text-xs font-bold text-emerald-600 dark:text-emerald-400">
                      <UserCheck className="w-4 h-4" />
                      <span>Registro Mestre (Será Mantido)</span>
                    </div>
                    {pessoaMestre && (
                      <span className="text-[10px] px-1.5 py-0.5 rounded bg-emerald-500/20 text-emerald-700 dark:text-emerald-300 font-bold">
                        PRESERVADO
                      </span>
                    )}
                  </div>

                  {pessoaMestre ? (
                    <div className="flex flex-col gap-3 p-3.5 rounded-raio bg-card border border-borda">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-2.5">
                          <div className="w-10 h-10 rounded-full bg-sup border border-borda flex items-center justify-center font-bold text-sm text-emerald-600">
                            {pessoaMestre.nome[0]}
                          </div>
                          <div>
                            <div className="text-xs font-bold text-tinta">
                              {pessoaMestre.nome} {pessoaMestre.sobrenome ?? ''}
                            </div>
                            <div className="text-[11px] text-tinta3">
                              ID: {pessoaMestre.id}
                            </div>
                          </div>
                        </div>
                        <button
                          type="button"
                          onClick={() => {
                            setPessoaMestre(null);
                            setConfirmando(false);
                          }}
                          className="p-1 rounded text-tinta3 hover:text-erro hover:bg-sup cursor-pointer text-xs"
                          title="Trocar pessoa"
                        >
                          <X className="w-4 h-4" />
                        </button>
                      </div>

                      <div className="text-xs text-tinta2 flex flex-col gap-1 border-t border-borda/60 pt-2">
                        <div className="flex items-center justify-between">
                          <span>
                            <span className="text-tinta3">Sexo: </span>
                            <span className="font-semibold">
                              {pessoaMestre.sexo === 'M' ? 'Masculino' : pessoaMestre.sexo === 'F' ? 'Feminino' : 'Outro'}
                            </span>
                          </span>
                          <span className="text-[11px] text-tinta3">
                            {pessoaMestre.arvore_nome ?? 'Acervo Principal'}
                          </span>
                        </div>
                        <div className="flex items-center gap-3 text-[11px] text-tinta2">
                          <span>Nasc: <strong>{pessoaMestre.ano_nascimento ?? '—'}</strong></span>
                          <span>Falec: <strong>{pessoaMestre.ano_falecimento ?? (pessoaMestre.is_vivo ? 'Vivo' : '—')}</strong></span>
                        </div>
                        <div className="text-[10px] text-tinta3 mt-0.5">
                          {pessoaMestre.tem_biografia ? '✓ Biografia' : '✗ Sem bio'} • {pessoaMestre.tem_documentos ? '✓ Documentos' : '✗ Sem docs'}
                        </div>
                      </div>
                    </div>
                  ) : (
                    <div className="flex flex-col gap-2">
                      <div className="relative">
                        <Search className="w-3.5 h-3.5 absolute left-3 top-2.5 text-tinta3" />
                        <input
                          type="text"
                          value={buscaMestre}
                          onChange={(e) => setBuscaMestre(e.target.value)}
                          placeholder="Digite nome para buscar pessoa mestre..."
                          className="w-full pl-8 pr-3 py-1.5 text-xs bg-card border border-borda rounded-raio-s text-tinta focus:outline-none focus:ring-1 focus:ring-emerald-500"
                        />
                      </div>
                      {resultadosMestre.length > 0 && (
                        <div className="max-h-40 overflow-y-auto flex flex-col gap-1 bg-card border border-borda rounded-raio-s p-1 shadow-md">
                          {resultadosMestre.map((p) => (
                            <button
                              key={p.id}
                              type="button"
                              onClick={() => {
                                setPessoaMestre(p);
                                setBuscaMestre('');
                                setResultadosMestre([]);
                              }}
                              className="text-left px-2.5 py-1.5 rounded hover:bg-sup text-xs flex items-center justify-between cursor-pointer"
                            >
                              <span className="font-semibold text-tinta">
                                {p.nome} {p.sobrenome ?? ''}
                              </span>
                              <span className="text-[10px] text-tinta3">{p.sexo}</span>
                            </button>
                          ))}
                        </div>
                      )}
                    </div>
                  )}
                </div>

                {/* BOTÃO CENTRAL: INVERTER */}
                <div className="flex flex-col items-center justify-center pt-8">
                  <button
                    type="button"
                    onClick={handleInverter}
                    disabled={!pessoaMestre && !pessoaAbsorver}
                    className="p-2.5 rounded-full bg-card hover:bg-sup border border-borda shadow-xs text-tinta2 hover:text-acento cursor-pointer disabled:opacity-30 transition-all"
                    title="Inverter: trocar registro mestre com o absorvido"
                  >
                    <ArrowRightLeft className="w-4 h-4" />
                  </button>
                </div>

                {/* LADO DIREITO: REGISTRO A ABSORVER (SERÁ EXCLUÍDO) */}
                <div className="flex flex-col gap-3 p-4 rounded-raio border-2 border-amber-500/40 bg-amber-500/5">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-1.5 text-xs font-bold text-amber-600 dark:text-amber-400">
                      <UserMinus className="w-4 h-4" />
                      <span>Registro a Absorver (Será Excluído)</span>
                    </div>
                    {pessoaAbsorver && (
                      <span className="text-[10px] px-1.5 py-0.5 rounded bg-amber-500/20 text-amber-700 dark:text-amber-300 font-bold">
                        SERÁ ELIMINADO
                      </span>
                    )}
                  </div>

                  {pessoaAbsorver ? (
                    <div className="flex flex-col gap-3 p-3.5 rounded-raio bg-card border border-borda">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-2.5">
                          <div className="w-10 h-10 rounded-full bg-sup border border-borda flex items-center justify-center font-bold text-sm text-amber-600">
                            {pessoaAbsorver.nome[0]}
                          </div>
                          <div>
                            <div className="text-xs font-bold text-tinta">
                              {pessoaAbsorver.nome} {pessoaAbsorver.sobrenome ?? ''}
                            </div>
                            <div className="text-[11px] text-tinta3">
                              ID: {pessoaAbsorver.id}
                            </div>
                          </div>
                        </div>
                        <button
                          type="button"
                          onClick={() => {
                            setPessoaAbsorver(null);
                            setConfirmando(false);
                          }}
                          className="p-1 rounded text-tinta3 hover:text-erro hover:bg-sup cursor-pointer text-xs"
                          title="Trocar pessoa"
                        >
                          <X className="w-4 h-4" />
                        </button>
                      </div>

                      <div className="text-xs text-tinta2 flex flex-col gap-1 border-t border-borda/60 pt-2">
                        <div className="flex items-center justify-between">
                          <span>
                            <span className="text-tinta3">Sexo: </span>
                            <span className="font-semibold">
                              {pessoaAbsorver.sexo === 'M' ? 'Masculino' : pessoaAbsorver.sexo === 'F' ? 'Feminino' : 'Outro'}
                            </span>
                          </span>
                          <span className="text-[11px] text-tinta3">
                            {pessoaAbsorver.arvore_nome ?? 'Acervo Principal'}
                          </span>
                        </div>
                        <div className="flex items-center gap-3 text-[11px] text-tinta2">
                          <span>Nasc: <strong>{pessoaAbsorver.ano_nascimento ?? '—'}</strong></span>
                          <span>Falec: <strong>{pessoaAbsorver.ano_falecimento ?? (pessoaAbsorver.is_vivo ? 'Vivo' : '—')}</strong></span>
                        </div>
                        <div className="text-[10px] text-tinta3 mt-0.5">
                          {pessoaAbsorver.tem_biografia ? '✓ Biografia' : '✗ Sem bio'} • {pessoaAbsorver.tem_documentos ? '✓ Documentos' : '✗ Sem docs'}
                        </div>
                      </div>
                    </div>
                  ) : (
                    <div className="flex flex-col gap-2">
                      <div className="relative">
                        <Search className="w-3.5 h-3.5 absolute left-3 top-2.5 text-tinta3" />
                        <input
                          type="text"
                          value={buscaAbsorver}
                          onChange={(e) => setBuscaAbsorver(e.target.value)}
                          placeholder="Digite nome para buscar registro a absorver..."
                          className="w-full pl-8 pr-3 py-1.5 text-xs bg-card border border-borda rounded-raio-s text-tinta focus:outline-none focus:ring-1 focus:ring-amber-500"
                        />
                      </div>
                      {resultadosAbsorver.length > 0 && (
                        <div className="max-h-40 overflow-y-auto flex flex-col gap-1 bg-card border border-borda rounded-raio-s p-1 shadow-md">
                          {resultadosAbsorver.map((p) => (
                            <button
                              key={p.id}
                              type="button"
                              onClick={() => {
                                setPessoaAbsorver(p);
                                setBuscaAbsorver('');
                                setResultadosAbsorver([]);
                              }}
                              className="text-left px-2.5 py-1.5 rounded hover:bg-sup text-xs flex items-center justify-between cursor-pointer"
                            >
                              <span className="font-semibold text-tinta">
                                {p.nome} {p.sobrenome ?? ''}
                              </span>
                              <span className="text-[10px] text-tinta3">{p.sexo}</span>
                            </button>
                          ))}
                        </div>
                      )}
                    </div>
                  )}
                </div>
              </div>

              {/* Informações da Ação de Fusão */}
              {pessoaMestre && pessoaAbsorver && !resumoSucesso && (
                <div className="p-4 rounded-raio bg-sup/40 border border-borda flex flex-col gap-2.5 text-xs">
                  <div className="font-semibold text-tinta flex items-center gap-1.5">
                    <ShieldCheck className="w-4 h-4 text-acento" />
                    <span>Garantias de Integridade Relacional:</span>
                  </div>
                  <ul className="text-tinta2 flex flex-col gap-1 list-disc list-inside text-[11px]">
                    <li>
                      <strong>Filiações e Uniões:</strong> Todos os filhos e casamentos da pessoa absorvida serão unificados e reatribuídos para a pessoa mestre.
                    </li>
                    <li>
                      <strong>Eventos e Fontes:</strong> Nascimentos, batismos, falecimentos e marcos históricos serão migrados integralmente.
                    </li>
                    <li>
                      <strong>Fotos e Mídias:</strong> Miniaturas e documentos anexados passarão para o acervo da pessoa mestre.
                    </li>
                    <li>
                      <strong>Histórico de Grafia:</strong> Se o nome da pessoa absorvida tiver grafia diferente, será preservado como nome alternativo.
                    </li>
                  </ul>
                </div>
              )}
            </>
          )}
        </div>

        {/* Rodapé */}
        <div className="px-6 py-4 border-t border-borda bg-sup/30 flex items-center justify-between gap-3">
          <button
            type="button"
            onClick={aoFechar}
            className="px-4 py-2 rounded-raio-s bg-sup hover:bg-card border border-borda text-xs font-semibold text-tinta transition-colors cursor-pointer"
          >
            Fechar
          </button>

          {aba === 'comparar' && pessoaMestre && pessoaAbsorver && !resumoSucesso && (
            <div className="flex items-center gap-3">
              {confirmando ? (
                <>
                  <span className="text-xs text-amber-600 dark:text-amber-400 font-semibold flex items-center gap-1">
                    <AlertTriangle className="w-3.5 h-3.5" />
                    Tem certeza? Esta ação é irreversível.
                  </span>
                  <button
                    type="button"
                    onClick={() => setConfirmando(false)}
                    className="px-3 py-1.5 rounded-raio-s bg-sup hover:bg-card border border-borda text-xs text-tinta cursor-pointer"
                  >
                    Cancelar
                  </button>
                  <button
                    type="button"
                    onClick={handleExecutarFusao}
                    disabled={executando}
                    className="px-4 py-2 rounded-raio-s bg-erro hover:bg-erro/90 text-white text-xs font-semibold flex items-center gap-1.5 cursor-pointer disabled:opacity-50"
                  >
                    {executando ? 'Fundindo...' : 'Sim, Confirmar Fusão'}
                  </button>
                </>
              ) : (
                <button
                  type="button"
                  onClick={() => setConfirmando(true)}
                  className="px-4 py-2 rounded-raio-s bg-acento hover:bg-acento/90 text-acento-tinta text-xs font-semibold flex items-center gap-1.5 cursor-pointer shadow-xs"
                >
                  <Users className="w-4 h-4" />
                  <span>Iniciar Fusão</span>
                </button>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
