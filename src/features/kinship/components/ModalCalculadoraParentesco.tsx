import React, { useState, useEffect } from 'react';
import {
  X,
  Search,
  ArrowRight,
  Crown,
  RotateCcw,
  Sparkles,
  HeartHandshake,
  AlertCircle,
  HelpCircle,
} from 'lucide-react';
import { IconeRelacoes } from '../../../components/icons';
import { buscarPessoas } from '../../../lib/api/tree';
import { calcularParentesco, type ParentescoResultado } from '../../../lib/api/parentesco';
import type { PersonNode } from '../../../types';

interface ModalCalculadoraParentescoProps {
  aberto: boolean;
  aoFechar: () => void;
  pessoaInicialId?: string | null;
}

export const ModalCalculadoraParentesco: React.FC<ModalCalculadoraParentescoProps> = ({
  aberto,
  aoFechar,
  pessoaInicialId,
}) => {
  const [pessoaA, setPessoaA] = useState<PersonNode | null>(null);
  const [pessoaB, setPessoaB] = useState<PersonNode | null>(null);

  const [buscaA, setBuscaA] = useState('');
  const [buscaB, setBuscaB] = useState('');
  const [resultadosA, setResultadosA] = useState<PersonNode[]>([]);
  const [resultadosB, setResultadosB] = useState<PersonNode[]>([]);

  const [carregando, setCarregando] = useState(false);
  const [resultado, setResultado] = useState<ParentescoResultado | null>(null);
  const [erro, setErro] = useState<string | null>(null);

  // Inicializa Pessoa A com a pessoa selecionada atualmente
  useEffect(() => {
    if (aberto && pessoaInicialId) {
      buscarPessoas(pessoaInicialId, 5).then((lista) => {
        const encontrada = lista.find((p) => p.id === pessoaInicialId);
        if (encontrada) {
          setPessoaA(encontrada);
        }
      });
    }
  }, [aberto, pessoaInicialId]);

  // Busca para seletor de Pessoa A
  useEffect(() => {
    if (buscaA.trim().length >= 2) {
      const timer = setTimeout(() => {
        buscarPessoas(buscaA.trim(), 10).then(setResultadosA);
      }, 200);
      return () => clearTimeout(timer);
    } else {
      setResultadosA([]);
    }
  }, [buscaA]);

  // Busca para seletor de Pessoa B
  useEffect(() => {
    if (buscaB.trim().length >= 2) {
      const timer = setTimeout(() => {
        buscarPessoas(buscaB.trim(), 10).then(setResultadosB);
      }, 200);
      return () => clearTimeout(timer);
    } else {
      setResultadosB([]);
    }
  }, [buscaB]);

  // Executa o cruzamento quando ambas as pessoas estão definidas
  useEffect(() => {
    if (!pessoaA || !pessoaB) {
      setResultado(null);
      setErro(null);
      return;
    }

    let cancelado = false;
    setCarregando(true);
    setErro(null);

    calcularParentesco(pessoaA.id, pessoaB.id)
      .then((res) => {
        if (!cancelado) {
          setResultado(res);
          setCarregando(false);
        }
      })
      .catch((err) => {
        if (!cancelado) {
          setErro(typeof err === 'string' ? err : 'Erro ao calcular parentesco.');
          setCarregando(false);
        }
      });

    return () => {
      cancelado = true;
    };
  }, [pessoaA, pessoaB]);

  if (!aberto) return null;

  const inverterPessoas = () => {
    const temp = pessoaA;
    setPessoaA(pessoaB);
    setPessoaB(temp);
  };

  const limparSelecao = () => {
    setPessoaA(null);
    setPessoaB(null);
    setResultado(null);
    setBuscaA('');
    setBuscaB('');
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-in fade-in">
      <div className="bg-card border border-borda rounded-raio shadow-sombra w-full max-w-3xl max-h-[90vh] flex flex-col overflow-hidden text-tinta">
        {/* Cabeçalho */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-borda bg-sup/50">
          <div className="flex items-center gap-2.5">
            <div className="p-2 rounded-raio-s bg-acento/10 text-acento">
              <IconeRelacoes className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base font-serif font-bold text-tinta">
                Cruzamento de Linhagens e Parentesco
              </h2>
              <p className="text-xs text-tinta3">
                Calcule o grau de parentesco biológico ou afinidade entre quaisquer duas pessoas do acervo.
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

        {/* Corpo do Modal */}
        <div className="p-6 overflow-y-auto flex flex-col gap-6">
          {/* Seletores de Pessoa A e Pessoa B */}
          <div className="grid grid-cols-1 md:grid-cols-[1fr,auto,1fr] gap-4 items-center">
            {/* Seletor Pessoa A */}
            <div className="flex flex-col gap-2">
              <label className="text-xs font-semibold text-tinta2 flex items-center gap-1.5">
                <span className="w-2 h-2 rounded-full bg-acento" />
                1ª Pessoa (Origem)
              </label>

              {pessoaA ? (
                <div className="flex items-center justify-between p-3 rounded-raio-s bg-sup border border-borda">
                  <div className="flex items-center gap-2.5 truncate">
                    <div className="w-8 h-8 rounded-full bg-card border border-borda flex items-center justify-center text-tinta2 flex-none font-bold text-xs">
                      {pessoaA.nome[0]}
                    </div>
                    <div className="truncate">
                      <div className="text-xs font-semibold truncate">
                        {pessoaA.nome} {pessoaA.sobrenome ?? ''}
                      </div>
                      <div className="text-[11px] text-tinta3 truncate">
                        {pessoaA.arvore_nome ?? 'Árvore Principal'}
                      </div>
                    </div>
                  </div>
                  <button
                    type="button"
                    onClick={() => setPessoaA(null)}
                    className="p-1 rounded text-tinta3 hover:text-erro hover:bg-card ml-2 cursor-pointer"
                    title="Remover seleção"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>
              ) : (
                <div className="relative">
                  <div className="relative">
                    <Search className="w-4 h-4 absolute left-3 top-2.5 text-tinta3" />
                    <input
                      type="text"
                      placeholder="Buscar por nome ou sobrenome..."
                      value={buscaA}
                      onChange={(e) => setBuscaA(e.target.value)}
                      className="w-full pl-9 pr-3 py-2 text-xs bg-sup border border-borda rounded-raio-s text-tinta placeholder:text-tinta3 focus:outline-none focus:ring-1 focus:ring-acento"
                    />
                  </div>

                  {resultadosA.length > 0 && (
                    <div className="absolute top-full left-0 w-full mt-1 bg-card/95 backdrop-blur-md border border-borda rounded-raio-s shadow-sombra max-h-48 overflow-y-auto z-30 py-1">
                      {resultadosA.map((p) => (
                        <button
                          key={p.id}
                          type="button"
                          onClick={() => {
                            setPessoaA(p);
                            setBuscaA('');
                            setResultadosA([]);
                          }}
                          className="w-full px-3 py-2 text-left hover:bg-sup flex items-center justify-between gap-2 text-xs cursor-pointer border-b border-borda/40 last:border-b-0"
                        >
                          <div className="truncate">
                            <span className="font-semibold text-tinta">
                              {p.nome} {p.sobrenome ?? ''}
                            </span>
                            {p.arvore_nome && (
                              <span className="text-[10px] text-tinta3 ml-2">
                                ({p.arvore_nome})
                              </span>
                            )}
                          </div>
                          {p.is_publico && (
                            <span className="text-[10px] px-1.5 py-0.5 rounded bg-amber-500/10 text-amber-600 dark:text-amber-400 font-medium">
                              Pública
                            </span>
                          )}
                        </button>
                      ))}
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* Botão de Inversão */}
            <div className="flex justify-center pt-2 md:pt-6">
              <button
                type="button"
                onClick={inverterPessoas}
                disabled={!pessoaA && !pessoaB}
                title="Inverter posições"
                className="p-2 rounded-full border border-borda bg-sup hover:bg-card text-tinta2 hover:text-acento transition-colors disabled:opacity-40 cursor-pointer shadow-xs"
              >
                <RotateCcw className="w-4 h-4" />
              </button>
            </div>

            {/* Seletor Pessoa B */}
            <div className="flex flex-col gap-2">
              <label className="text-xs font-semibold text-tinta2 flex items-center gap-1.5">
                <span className="w-2 h-2 rounded-full bg-blue-500" />
                2ª Pessoa (Comparação)
              </label>

              {pessoaB ? (
                <div className="flex items-center justify-between p-3 rounded-raio-s bg-sup border border-borda">
                  <div className="flex items-center gap-2.5 truncate">
                    <div className="w-8 h-8 rounded-full bg-card border border-borda flex items-center justify-center text-tinta2 flex-none font-bold text-xs">
                      {pessoaB.nome[0]}
                    </div>
                    <div className="truncate">
                      <div className="text-xs font-semibold truncate">
                        {pessoaB.nome} {pessoaB.sobrenome ?? ''}
                      </div>
                      <div className="text-[11px] text-tinta3 truncate">
                        {pessoaB.arvore_nome ?? 'Árvore Principal'}
                      </div>
                    </div>
                  </div>
                  <button
                    type="button"
                    onClick={() => setPessoaB(null)}
                    className="p-1 rounded text-tinta3 hover:text-erro hover:bg-card ml-2 cursor-pointer"
                    title="Remover seleção"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>
              ) : (
                <div className="relative">
                  <div className="relative">
                    <Search className="w-4 h-4 absolute left-3 top-2.5 text-tinta3" />
                    <input
                      type="text"
                      placeholder="Buscar por nome ou sobrenome..."
                      value={buscaB}
                      onChange={(e) => setBuscaB(e.target.value)}
                      className="w-full pl-9 pr-3 py-2 text-xs bg-sup border border-borda rounded-raio-s text-tinta placeholder:text-tinta3 focus:outline-none focus:ring-1 focus:ring-acento"
                    />
                  </div>

                  {resultadosB.length > 0 && (
                    <div className="absolute top-full left-0 w-full mt-1 bg-card/95 backdrop-blur-md border border-borda rounded-raio-s shadow-sombra max-h-48 overflow-y-auto z-30 py-1">
                      {resultadosB.map((p) => (
                        <button
                          key={p.id}
                          type="button"
                          onClick={() => {
                            setPessoaB(p);
                            setBuscaB('');
                            setResultadosB([]);
                          }}
                          className="w-full px-3 py-2 text-left hover:bg-sup flex items-center justify-between gap-2 text-xs cursor-pointer border-b border-borda/40 last:border-b-0"
                        >
                          <div className="truncate">
                            <span className="font-semibold text-tinta">
                              {p.nome} {p.sobrenome ?? ''}
                            </span>
                            {p.arvore_nome && (
                              <span className="text-[10px] text-tinta3 ml-2">
                                ({p.arvore_nome})
                              </span>
                            )}
                          </div>
                          {p.is_publico && (
                            <span className="text-[10px] px-1.5 py-0.5 rounded bg-amber-500/10 text-amber-600 dark:text-amber-400 font-medium">
                              Pública
                            </span>
                          )}
                        </button>
                      ))}
                    </div>
                  )}
                </div>
              )}
            </div>
          </div>

          {/* Estado de Carregando */}
          {carregando && (
            <div className="flex flex-col items-center justify-center p-8 text-tinta3 gap-2">
              <Sparkles className="w-6 h-6 animate-pulse text-acento" />
              <span className="text-xs font-medium">Cruzando linhagens no acervo...</span>
            </div>
          )}

          {/* Erro */}
          {erro && (
            <div className="p-3.5 rounded-raio-s bg-erro/10 border border-erro/30 text-erro text-xs flex items-center gap-2">
              <AlertCircle className="w-4 h-4 flex-none" />
              <span>{erro}</span>
            </div>
          )}

          {/* Resultado do Cálculo */}
          {resultado && !carregando && (
            <div className="flex flex-col gap-4">
              {/* Cartão de Parentesco Principal */}
              <div
                className={`p-4 rounded-raio border flex flex-col md:flex-row items-start md:items-center justify-between gap-4 ${
                  resultado.tem_parentesco
                    ? resultado.tipo_relacao === 'consanguineo'
                      ? 'bg-acento/10 border-acento/30'
                      : 'bg-blue-500/10 border-blue-500/30'
                    : 'bg-sup border-borda'
                }`}
              >
                <div className="flex items-center gap-3">
                  <div
                    className={`p-3 rounded-full flex-none ${
                      resultado.tem_parentesco
                        ? resultado.tipo_relacao === 'consanguineo'
                          ? 'bg-acento text-acento-tinta'
                          : 'bg-blue-600 text-white'
                        : 'bg-sup border border-borda text-tinta3'
                    }`}
                  >
                    {resultado.tem_parentesco ? (
                      resultado.tipo_relacao === 'consanguineo' ? (
                        <Crown className="w-6 h-6" />
                      ) : (
                        <HeartHandshake className="w-6 h-6" />
                      )
                    ) : (
                      <HelpCircle className="w-6 h-6" />
                    )}
                  </div>
                  <div>
                    <div className="text-[11px] font-semibold uppercase tracking-wider text-tinta3">
                      {resultado.tipo_relacao === 'consanguineo'
                        ? 'Parentesco Consanguíneo (Biológico)'
                        : resultado.tipo_relacao === 'afim'
                        ? 'Vínculo Familiar por Afinidade'
                        : resultado.tipo_relacao === 'mesma_pessoa'
                        ? 'Mesmo Indivíduo'
                        : 'Sem Parentesco Detectado'}
                    </div>
                    <div className="text-lg font-serif font-bold text-tinta">
                      {resultado.descricao_parentesco}
                    </div>
                    {resultado.grau_consanguinidade !== null && resultado.grau_consanguinidade !== undefined && (
                      <div className="text-xs text-tinta2 mt-0.5">
                        Grau de distância genealógica: <strong>{resultado.grau_consanguinidade}</strong>{' '}
                        (A: {resultado.distancia_geracoes_a} ger., B: {resultado.distancia_geracoes_b} ger.)
                      </div>
                    )}
                  </div>
                </div>

                {resultado.ancestral_comum && (
                  <div className="p-3 rounded-raio-s bg-card border border-borda text-xs flex flex-col gap-1 w-full md:w-auto">
                    <span className="text-[11px] font-semibold text-tinta3">
                      Ancestral Comum Mais Próximo:
                    </span>
                    <span className="font-bold text-acento">
                      {resultado.ancestral_comum.nome}{' '}
                      {resultado.ancestral_comum.sobrenome ?? ''}
                    </span>
                  </div>
                )}
              </div>

              {/* Caminho Genealógico Passo a Passo */}
              {resultado.caminho && resultado.caminho.length > 0 && (
                <div className="flex flex-col gap-2.5">
                  <div className="text-xs font-semibold text-tinta2 uppercase tracking-wider">
                    Caminho de Conexão no Acervo
                  </div>

                  <div className="flex flex-wrap items-center gap-2 p-4 rounded-raio bg-sup/50 border border-borda">
                    {resultado.caminho.map((passo, idx) => {
                      const isOrigem = idx === 0;
                      const isDestino = idx === resultado.caminho.length - 1;
                      const isLCA =
                        resultado.ancestral_comum &&
                        passo.pessoa_id === resultado.ancestral_comum.pessoa_id;

                      return (
                        <React.Fragment key={passo.pessoa_id + idx}>
                          <div
                            className={`flex flex-col items-center px-3 py-2 rounded-raio-s border text-center transition-all ${
                              isLCA
                                ? 'bg-acento/15 border-acento shadow-xs'
                                : isOrigem || isDestino
                                ? 'bg-card border-borda font-semibold'
                                : 'bg-card/70 border-borda/60'
                            }`}
                          >
                            <span className="text-[10px] text-tinta3 font-medium uppercase">
                              {passo.papel}
                            </span>
                            <span className="text-xs font-bold text-tinta">
                              {passo.nome} {passo.sobrenome ?? ''}
                            </span>
                          </div>

                          {idx < resultado.caminho.length - 1 && (
                            <ArrowRight className="w-4 h-4 text-tinta3 flex-none" />
                          )}
                        </React.Fragment>
                      );
                    })}
                  </div>
                </div>
              )}
            </div>
          )}

          {/* Dica Informativa quando ainda não selecionou as duas */}
          {(!pessoaA || !pessoaB) && (
            <div className="p-4 rounded-raio bg-sup/40 border border-dashed border-borda text-xs text-tinta2 flex items-start gap-3">
              <Sparkles className="w-4 h-4 text-acento flex-none mt-0.5" />
              <div>
                <strong>Dica de Uso:</strong> Você pode comparar qualquer antepassado da sua família com
                figuras históricas públicas registradas (como a <em>Família Imperial do Brasil</em>, os{' '}
                <em>Reis de Portugal</em> ou a <em>Casa de Windsor</em>) para verificar se há algum elo de
                ancestralidade comum ou casamento registrado no acervo.
              </div>
            </div>
          )}
        </div>

        {/* Rodapé */}
        <div className="px-6 py-3 border-t border-borda bg-sup/30 flex items-center justify-between">
          <button
            type="button"
            onClick={limparSelecao}
            disabled={!pessoaA && !pessoaB}
            className="text-xs text-tinta3 hover:text-tinta disabled:opacity-30 cursor-pointer"
          >
            Limpar Seleções
          </button>
          <button
            type="button"
            onClick={aoFechar}
            className="px-4 py-1.5 rounded-raio-s bg-sup hover:bg-card border border-borda text-xs font-semibold text-tinta transition-colors cursor-pointer"
          >
            Fechar
          </button>
        </div>
      </div>
    </div>
  );
};
