/**
 * Painel de busca da barra lateral (fatia 06, seção 7).
 *
 * O campo de texto fica sempre visível; os demais critérios ficam atrás de
 * "Filtros", que abre quando se precisa. A maioria das buscas num acervo
 * familiar é "onde está o tio Zé" — cobrar sete campos para isso seria pior.
 *
 * Os seletores oferecem **só o que existe no acervo**, com a contagem ao lado.
 * Escolher "Budista" num acervo sem budistas e receber lista vazia parece
 * defeito do programa, e não é.
 */

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Search, SlidersHorizontal, X } from 'lucide-react';
import { Input } from '../../../components/ui/Input';
import { ImagemDoAcervo } from '../../../components/ui/ImagemDoAcervo';
import { buscarPessoasFiltrado, opcoesDeFiltro, type FiltrosBusca } from '../../../lib/api';
import type { OpcaoDeFiltro } from '../../../lib/api';
import type { PersonNode } from '../../../types';

interface PainelBuscaProps {
  selecionadaId: string | null;
  onEscolher: (id: string) => void;
}

const FILTROS_VAZIOS: FiltrosBusca = { incluir_placeholders: false };

/** Quantos critérios além do texto estão ativos. */
function contarFiltros(f: FiltrosBusca): number {
  return [
    f.sobrenome,
    f.local_id,
    f.pais_id,
    f.decada,
    f.religiao,
    f.profissao,
    f.idioma,
    f.escolaridade,
    f.apenas_vivas,
  ].filter((v) => v !== null && v !== undefined && v !== '').length;
}

function SeletorDeFiltro({
  rotulo,
  valor,
  opcoes,
  onMudar,
}: {
  rotulo: string;
  valor: string | null | undefined;
  opcoes: OpcaoDeFiltro[];
  onMudar: (v: string | null) => void;
}) {
  // Um critério sem nenhum valor no acervo não vira campo: seria uma caixa
  // vazia pedindo uma escolha impossível.
  if (opcoes.length === 0) return null;

  return (
    <label className="flex flex-col gap-1">
      <span className="text-[10.5px] text-tinta2">{rotulo}</span>
      <select
        value={valor ?? ''}
        onChange={(e) => onMudar(e.target.value || null)}
        className="text-xs px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta w-full"
      >
        <option value="">qualquer</option>
        {opcoes.map((o) => (
          <option key={o.valor} value={o.valor}>
            {o.rotulo} ({o.quantas})
          </option>
        ))}
      </select>
    </label>
  );
}

export function PainelBusca({ selecionadaId, onEscolher }: PainelBuscaProps) {
  const [filtros, setFiltros] = useState<FiltrosBusca>(FILTROS_VAZIOS);
  const [filtrosAbertos, setFiltrosAbertos] = useState(false);

  const { data: opcoes } = useQuery({
    queryKey: ['opcoes-de-filtro'],
    queryFn: opcoesDeFiltro,
    staleTime: 60_000,
  });

  const {
    data: resultados,
    isLoading,
    error,
  } = useQuery({
    queryKey: ['pessoas', filtros],
    queryFn: () => buscarPessoasFiltrado(filtros),
    staleTime: 30_000,
  });

  const ativos = contarFiltros(filtros);
  const mudar = <C extends keyof FiltrosBusca>(campo: C, valor: FiltrosBusca[C]) =>
    setFiltros((f) => ({ ...f, [campo]: valor }));

  return (
    <>
      <div className="p-3 border-b border-borda flex flex-col gap-2 flex-none">
        <div className="relative">
          <Search className="w-4 h-4 absolute left-2.5 top-1/2 -translate-y-1/2 text-tinta3 pointer-events-none" />
          <Input
            aria-label="Buscar pessoa"
            placeholder="Nome ou sobrenome"
            value={filtros.texto ?? ''}
            onChange={(e) => mudar('texto', e.target.value || null)}
            className="pl-8"
          />
        </div>

        <div className="flex items-center justify-between gap-2">
          <button
            type="button"
            onClick={() => setFiltrosAbertos((a) => !a)}
            className="text-[11px] text-tinta2 hover:text-tinta transition-colors flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
          >
            <SlidersHorizontal className="w-3.5 h-3.5" />
            Filtros
            {ativos > 0 && (
              <span className="px-1.5 rounded-full bg-acento text-acento-tinta text-[10px] font-semibold">
                {ativos}
              </span>
            )}
          </button>

          {(ativos > 0 || filtros.texto) && (
            <button
              type="button"
              onClick={() => setFiltros(FILTROS_VAZIOS)}
              className="text-[11px] text-tinta3 hover:text-fem transition-colors flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
            >
              <X className="w-3 h-3" />
              Limpar
            </button>
          )}
        </div>

        {filtrosAbertos && (
          <div className="flex flex-col gap-2 pt-2 border-t border-borda">
            <label className="flex flex-col gap-1">
              <span className="text-[10.5px] text-tinta2">Sobrenome</span>
              <input
                type="text"
                value={filtros.sobrenome ?? ''}
                onChange={(e) => mudar('sobrenome', e.target.value || null)}
                placeholder="para agrupar a linhagem"
                className="text-xs px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta w-full"
              />
            </label>

            <label className="flex flex-col gap-1">
              <span className="text-[10.5px] text-tinta2">Década de nascimento</span>
              <select
                value={filtros.decada ?? ''}
                onChange={(e) => mudar('decada', e.target.value ? Number(e.target.value) : null)}
                className="text-xs px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta w-full"
              >
                <option value="">qualquer</option>
                {opcoes?.decadas.map((d) => (
                  <option key={d.valor} value={d.valor}>
                    {d.rotulo} ({d.quantas})
                  </option>
                ))}
              </select>
            </label>

            <SeletorDeFiltro
              rotulo="Cidade de nascimento"
              valor={filtros.local_id}
              opcoes={opcoes?.locais ?? []}
              onMudar={(v) => mudar('local_id', v)}
            />
            <SeletorDeFiltro
              rotulo="Nacionalidade"
              valor={filtros.pais_id}
              opcoes={opcoes?.paises ?? []}
              onMudar={(v) => mudar('pais_id', v)}
            />
            <SeletorDeFiltro
              rotulo="Religião"
              valor={filtros.religiao}
              opcoes={opcoes?.religioes ?? []}
              onMudar={(v) => mudar('religiao', v)}
            />
            <SeletorDeFiltro
              rotulo="Profissão"
              valor={filtros.profissao}
              opcoes={opcoes?.profissoes ?? []}
              onMudar={(v) => mudar('profissao', v)}
            />
            <SeletorDeFiltro
              rotulo="Escolaridade"
              valor={filtros.escolaridade}
              opcoes={opcoes?.escolaridade ?? []}
              onMudar={(v) => mudar('escolaridade', v)}
            />
            <SeletorDeFiltro
              rotulo="Idioma"
              valor={filtros.idioma}
              opcoes={opcoes?.idiomas ?? []}
              onMudar={(v) => mudar('idioma', v)}
            />

            <label className="flex flex-col gap-1">
              <span className="text-[10.5px] text-tinta2">Situação</span>
              <select
                value={
                  filtros.apenas_vivas === null || filtros.apenas_vivas === undefined
                    ? ''
                    : filtros.apenas_vivas
                      ? 'vivas'
                      : 'falecidas'
                }
                onChange={(e) =>
                  mudar(
                    'apenas_vivas',
                    e.target.value === '' ? null : e.target.value === 'vivas',
                  )
                }
                className="text-xs px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta w-full"
              >
                <option value="">qualquer</option>
                <option value="vivas">só pessoas vivas</option>
                <option value="falecidas">só falecidas</option>
              </select>
            </label>
          </div>
        )}
      </div>

      <div className="flex-1 overflow-y-auto min-h-0">
        {isLoading && <p className="p-3 text-sm text-tinta3 m-0">Procurando…</p>}

        {error && (
          <p role="alert" className="p-3 text-sm text-fem m-0">
            {error instanceof Error ? error.message : String(error)}
          </p>
        )}

        {!isLoading && !error && (resultados ?? []).length === 0 && (
          <div className="p-3 flex flex-col gap-2">
            <p className="text-sm text-tinta3 m-0">
              {ativos > 0 || filtros.texto
                ? 'Ninguém com esses critérios.'
                : 'O acervo está vazio.'}
            </p>
            {(ativos > 0 || filtros.texto) && (
              <button
                type="button"
                onClick={() => setFiltros(FILTROS_VAZIOS)}
                className="self-start text-[11px] text-acento hover:text-tinta bg-transparent border-none cursor-pointer p-0"
              >
                Limpar os filtros
              </button>
            )}
          </div>
        )}

        {(resultados ?? []).length > 0 && (
          <>
            <p className="px-3 pt-2 pb-1 font-num text-[10.5px] text-tinta3 m-0">
              {resultados!.length} {resultados!.length === 1 ? 'pessoa' : 'pessoas'}
            </p>
            <ul className="list-none m-0 p-0">
              {resultados!.map((p: PersonNode) => (
                <li key={p.id}>
                  <button
                    type="button"
                    onClick={() => onEscolher(p.id)}
                    className={`w-full text-left px-3 py-2 border-b border-borda/60 hover:bg-card transition-colors flex items-center gap-2.5 ${
                      selecionadaId === p.id ? 'bg-card border-l-2 border-l-acento' : ''
                    }`}
                  >
                    <div className="w-7 h-7 rounded-raio-s bg-chip flex-none grid place-items-center overflow-hidden border border-borda2">
                      <ImagemDoAcervo
                        caminhoRelativo={p.foto_url}
                        alt=""
                        className="w-full h-full object-cover"
                        alternativo={
                          <span className="text-[10px] text-tinta3">
                            {p.nome.charAt(0).toLocaleUpperCase('pt-BR')}
                          </span>
                        }
                      />
                    </div>

                    <span className="flex-1 min-w-0">
                      <span className="block text-sm text-tinta truncate">
                        {[p.nome, p.sobrenome].filter(Boolean).join(' ')}
                      </span>
                      <span className="block font-num text-[11px] text-tinta3">
                        {p.ano_nascimento ? `n. ${p.ano_nascimento}` : 'sem data'}
                        {p.ano_falecimento ? ` · † ${p.ano_falecimento}` : ''}
                      </span>
                    </span>
                  </button>
                </li>
              ))}
            </ul>
          </>
        )}
      </div>
    </>
  );
}
