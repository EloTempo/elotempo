import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Check, Search, UserPlus, X } from 'lucide-react';
import { Modal } from '../../../components/ui/Modal';
import { buscarPessoas } from '../../../lib/api/tree';
import { useI18n } from '../../../i18n/I18nContext';

export interface PessoaItemComparar {
  id: string;
  nome: string;
  sobrenome?: string | null;
  sexo?: string | null;
  ano_nascimento?: number | null;
  ano_falecimento?: number | null;
  is_vivo?: boolean;
  arvore_nome?: string | null;
}

interface ModalCompararVidasProps {
  aberto: boolean;
  aoFechar: () => void;
  vidasJaAbertas: string[];
  pessoasDaArvore?: PessoaItemComparar[];
  onAdicionarVida: (pessoaId: string) => void;
  onRemoverVida?: (pessoaId: string) => void;
  onAdicionarTodas?: () => void;
  onRemoverTodas?: () => void;
}

const ANO_CORRENTE = new Date().getFullYear();

export function ModalCompararVidas({
  aberto,
  aoFechar,
  vidasJaAbertas,
  pessoasDaArvore,
  onAdicionarVida,
  onRemoverVida,
  onAdicionarTodas,
  onRemoverTodas,
}: ModalCompararVidasProps) {
  const { t } = useI18n();
  const [busca, setBusca] = useState('');

  const { data: resultados, isLoading } = useQuery({
    queryKey: ['busca-pessoas-comparar', busca],
    queryFn: () => buscarPessoas(busca, 25),
    enabled: aberto && busca.trim().length >= 1,
  });

  return (
    <Modal
      isOpen={aberto}
      onClose={aoFechar}
      title={t('linhaTempo', 'compararVidasModal')}
      className="max-w-xl"
    >
      <div className="flex flex-col gap-4">
        <p className="text-xs text-tinta2 m-0 leading-relaxed">
          Adicione parentes e personalidades da árvore ao mesmo eixo horizontal para
          comparar contemporaneidade, idades e acontecimentos históricos lado a lado.
        </p>

        {/* Campo de Busca Espaçoso */}
        <div className="relative">
          <Search className="w-4 h-4 absolute left-3 top-3 text-tinta3" />
          <input
            type="text"
            placeholder={t('linhaTempo', 'buscarPessoaParaComparar')}
            value={busca}
            onChange={(e) => setBusca(e.target.value)}
            autoFocus
            className="flex h-10 w-full rounded-raio border border-borda bg-card pl-9 pr-8 text-sm text-tinta placeholder:text-tinta3 focus:outline-none focus:ring-2 focus:ring-acento/50"
          />
          {busca && (
            <button
              type="button"
              onClick={() => setBusca('')}
              className="absolute right-2.5 top-2.5 text-tinta3 hover:text-tinta p-1 rounded-full hover:bg-sup"
              title="Limpar busca"
            >
              <X className="w-3.5 h-3.5" />
            </button>
          )}
        </div>

        {/* Lista de Resultados / Pessoas da Árvore */}
        <div className="flex flex-col gap-1.5 max-h-72 overflow-y-auto pr-1">
          {isLoading ? (
            <div className="text-center py-6 text-xs text-tinta3">
              Buscando pessoas no acervo...
            </div>
          ) : busca.trim().length === 0 ? (
            pessoasDaArvore && pessoasDaArvore.length > 0 ? (
              <div className="flex flex-col gap-2">
                <div className="flex items-center justify-between px-1 py-1 border-b border-borda/60 text-xs">
                  <span className="font-semibold text-tinta">
                    Pessoas desta Árvore ({pessoasDaArvore.length})
                  </span>
                  <div className="flex items-center gap-2">
                    {onAdicionarTodas && (
                      <button
                        type="button"
                        onClick={onAdicionarTodas}
                        className="px-2.5 py-1 rounded text-[11px] font-semibold bg-acento/10 hover:bg-acento text-acento hover:text-acento-tinta transition-colors cursor-pointer"
                      >
                        + Adicionar Todas
                      </button>
                    )}
                    {onRemoverTodas && vidasJaAbertas.length > 0 && (
                      <button
                        type="button"
                        onClick={onRemoverTodas}
                        className="px-2 py-1 rounded text-[11px] font-medium text-tinta3 hover:text-rose-600 transition-colors cursor-pointer"
                      >
                        Limpar Todas
                      </button>
                    )}
                  </div>
                </div>
                {pessoasDaArvore.map((p) => {
                  const jaAberta = vidasJaAbertas.includes(p.id);
                  const cor =
                    p.sexo === 'M'
                      ? 'var(--masc)'
                      : p.sexo === 'F'
                      ? 'var(--fem)'
                      : 'var(--anel)';

                  const idade =
                    p.ano_nascimento != null
                      ? (p.ano_falecimento ?? (p.is_vivo ? ANO_CORRENTE : null)) != null
                        ? (p.ano_falecimento ?? (p.is_vivo ? ANO_CORRENTE : null))! -
                          p.ano_nascimento
                        : null
                      : null;

                  return (
                    <div
                      key={p.id}
                      className={`flex items-center justify-between p-2.5 rounded-raio border transition-all ${
                        jaAberta
                          ? 'bg-acento/5 border-acento/30'
                          : 'bg-card border-borda hover:bg-sup/70 hover:border-borda2'
                      }`}
                    >
                      <div className="flex items-center gap-2.5 min-w-0 flex-1">
                        <div
                          className="w-8 h-8 rounded-full flex items-center justify-center flex-none font-bold text-xs text-white shadow-2xs"
                          style={{ background: cor }}
                        >
                          {p.nome.charAt(0).toUpperCase()}
                        </div>

                        <div className="flex flex-col min-w-0 flex-1">
                          <div className="flex items-center gap-2">
                            <span className="font-semibold text-xs text-tinta truncate">
                              {p.nome} {p.sobrenome}
                            </span>
                            {p.arvore_nome && (
                              <span className="text-[10px] px-1.5 py-0.2 rounded bg-sup text-tinta3 border border-borda/60 flex-none">
                                {p.arvore_nome}
                              </span>
                            )}
                          </div>

                          <div className="flex items-center gap-2 text-[11px] text-tinta2 font-num">
                            <span>
                              {p.ano_nascimento ? `* ${p.ano_nascimento}` : 'Data nasc. desconhecida'}
                            </span>
                            <span>•</span>
                            <span>
                              {p.ano_falecimento
                                ? `✝ ${p.ano_falecimento}`
                                : p.is_vivo
                                ? 'vivo(a)'
                                : 'falecido(a)'}
                            </span>
                            {idade != null && (
                              <span className="font-semibold text-acento">
                                ({idade} anos{p.is_vivo ? ' atual' : ''})
                              </span>
                            )}
                          </div>
                        </div>
                      </div>

                      <div className="ml-3 flex-none">
                        {jaAberta ? (
                          <div className="flex items-center gap-1.5">
                            <span className="text-[11px] font-semibold text-emerald-600 dark:text-emerald-400 flex items-center gap-1 px-2 py-1 rounded bg-emerald-500/10">
                              <Check className="w-3 h-3" />
                              No Eixo
                            </span>
                            {onRemoverVida && (
                              <button
                                type="button"
                                onClick={() => onRemoverVida(p.id)}
                                className="text-xs text-tinta3 hover:text-red-500 p-1 rounded hover:bg-sup cursor-pointer"
                                title="Remover do eixo"
                              >
                                <X className="w-3.5 h-3.5" />
                              </button>
                            )}
                          </div>
                        ) : (
                          <button
                            type="button"
                            onClick={() => {
                              onAdicionarVida(p.id);
                            }}
                            className="px-2.5 py-1 text-xs font-semibold rounded-raio-s bg-acento text-acento-tinta hover:bg-acento/90 flex items-center gap-1 shadow-2xs cursor-pointer transition-all hover:scale-105"
                          >
                            <UserPlus className="w-3.5 h-3.5" />
                            <span>{t('linhaTempo', 'compararVida')}</span>
                          </button>
                        )}
                      </div>
                    </div>
                  );
                })}
              </div>
            ) : (
              <div className="text-center py-8 text-xs text-tinta3 flex flex-col items-center gap-2">
                <UserPlus className="w-8 h-8 text-tinta3/50" />
                <span>Digite pelo menos uma letra para buscar pessoas no acervo.</span>
              </div>
            )
          ) : !resultados || resultados.length === 0 ? (
            <div className="text-center py-6 text-xs text-tinta3">
              Nenhuma pessoa encontrada com "{busca}".
            </div>
          ) : (
            resultados.map((p) => {
              const jaAberta = vidasJaAbertas.includes(p.id);
              const cor =
                p.sexo === 'M'
                  ? 'var(--masc)'
                  : p.sexo === 'F'
                  ? 'var(--fem)'
                  : 'var(--anel)';

              const idade =
                p.ano_nascimento != null
                  ? (p.ano_falecimento ?? (p.is_vivo ? ANO_CORRENTE : null)) != null
                    ? (p.ano_falecimento ?? (p.is_vivo ? ANO_CORRENTE : null))! -
                      p.ano_nascimento
                    : null
                  : null;

              return (
                <div
                  key={p.id}
                  className={`flex items-center justify-between p-2.5 rounded-raio border transition-all ${
                    jaAberta
                      ? 'bg-acento/5 border-acento/30'
                      : 'bg-card border-borda hover:bg-sup/70 hover:border-borda2'
                  }`}
                >
                  <div className="flex items-center gap-2.5 min-w-0 flex-1">
                    {/* Avatar com cor do sexo */}
                    <div
                      className="w-8 h-8 rounded-full flex items-center justify-center flex-none font-bold text-xs text-white shadow-2xs"
                      style={{ background: cor }}
                    >
                      {p.nome.charAt(0).toUpperCase()}
                    </div>

                    <div className="flex flex-col min-w-0 flex-1">
                      <div className="flex items-center gap-2">
                        <span className="font-semibold text-xs text-tinta truncate">
                          {p.nome} {p.sobrenome}
                        </span>
                        {p.arvore_nome && (
                          <span className="text-[10px] px-1.5 py-0.2 rounded bg-sup text-tinta3 border border-borda/60 flex-none">
                            {p.arvore_nome}
                          </span>
                        )}
                      </div>

                      <div className="flex items-center gap-2 text-[11px] text-tinta2 font-num">
                        <span>
                          {p.ano_nascimento ? `* ${p.ano_nascimento}` : 'Data nasc. desconhecida'}
                        </span>
                        <span>•</span>
                        <span>
                          {p.ano_falecimento
                            ? `✝ ${p.ano_falecimento}`
                            : p.is_vivo
                            ? 'vivo(a)'
                            : 'falecido(a)'}
                        </span>
                        {idade != null && (
                          <span className="font-semibold text-acento">
                            ({idade} anos{p.is_vivo ? ' atual' : ''})
                          </span>
                        )}
                      </div>
                    </div>
                  </div>

                  <div className="ml-3 flex-none">
                    {jaAberta ? (
                      <div className="flex items-center gap-1.5">
                        <span className="text-[11px] font-semibold text-emerald-600 dark:text-emerald-400 flex items-center gap-1 px-2 py-1 rounded bg-emerald-500/10">
                          <Check className="w-3 h-3" />
                          No Eixo
                        </span>
                        {onRemoverVida && (
                          <button
                            type="button"
                            onClick={() => onRemoverVida(p.id)}
                            className="text-xs text-tinta3 hover:text-red-500 p-1 rounded hover:bg-sup cursor-pointer"
                            title="Remover do eixo"
                          >
                            <X className="w-3.5 h-3.5" />
                          </button>
                        )}
                      </div>
                    ) : (
                      <button
                        type="button"
                        onClick={() => {
                          onAdicionarVida(p.id);
                        }}
                        className="px-2.5 py-1 text-xs font-semibold rounded-raio-s bg-acento text-acento-tinta hover:bg-acento/90 flex items-center gap-1 shadow-2xs cursor-pointer transition-all hover:scale-105"
                      >
                        <UserPlus className="w-3.5 h-3.5" />
                        <span>{t('linhaTempo', 'compararVida')}</span>
                      </button>
                    )}
                  </div>
                </div>
              );
            })
          )}
        </div>

        {/* Rodapé Informativo */}
        <div className="flex items-center justify-between pt-2 border-t border-borda text-xs text-tinta3">
          <span>
            {vidasJaAbertas.length} {vidasJaAbertas.length === 1 ? 'vida aberta' : 'vidas abertas'} no eixo temporal
          </span>
          <button
            type="button"
            onClick={aoFechar}
            className="px-3 py-1 text-xs rounded-raio-s bg-sup hover:bg-card border border-borda text-tinta font-semibold cursor-pointer"
          >
            {t('comum', 'fechar')}
          </button>
        </div>
      </div>
    </Modal>
  );
}
