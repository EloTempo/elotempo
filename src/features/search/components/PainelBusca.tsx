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

import { useState, useEffect, useMemo } from 'react';
import { useQuery } from '@tanstack/react-query';
import {
  ChevronDown,
  ChevronRight,
  ChevronsDown,
  ChevronsUp,
  Layers,
  List,
  PieChart,
  Search,
  SlidersHorizontal,
  Users,
  X,
  Folder,
  Check,
} from 'lucide-react';
import { IconeArvore } from '../../../components/icons';
import { Input } from '../../../components/ui/Input';
import { ImagemDoAcervo } from '../../../components/ui/ImagemDoAcervo';
import {
  buscarPessoasFiltrado,
  opcoesDeFiltro,
  listarArvores,
  type FiltrosBusca,
  type ArvoreInfo,
  type OpcaoDeFiltro,
} from '../../../lib/api';
import type { PersonNode } from '../../../types';
import { useI18n } from '../../../i18n/I18nContext';
import { PainelEstatisticas } from '../../statistics/components/PainelEstatisticas';

export interface PainelBuscaProps {
  selecionadaId: string | null;
  onEscolher: (id: string) => void;
  arvoreAtivaId?: string | null;
  onSelecionarArvore?: (arvore: ArvoreInfo) => void;
}

type EscopoBusca = 'atual' | 'meus' | 'publicos' | 'todos';

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
  rotuloQualquer = 'qualquer',
}: {
  rotulo: string;
  valor: string | null | undefined;
  opcoes: OpcaoDeFiltro[];
  onMudar: (v: string | null) => void;
  rotuloQualquer?: string;
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
        <option value="">{rotuloQualquer}</option>
        {opcoes.map((o) => (
          <option key={o.valor} value={o.valor}>
            {o.rotulo} ({o.quantas})
          </option>
        ))}
      </select>
    </label>
  );
}

export function PainelBusca({
  selecionadaId,
  onEscolher,
  arvoreAtivaId,
  onSelecionarArvore,
}: PainelBuscaProps) {
  const { t } = useI18n();

  const [escopo, setEscopo] = useState<EscopoBusca>(() =>
    arvoreAtivaId ? 'atual' : 'todos'
  );

  const [filtros, setFiltros] = useState<FiltrosBusca>(() => ({
    ...FILTROS_VAZIOS,
    arvore_id: arvoreAtivaId ? arvoreAtivaId : undefined,
  }));

  const [filtrosAbertos, setFiltrosAbertos] = useState(false);
  const [aba, setAba] = useState<'lista' | 'estatisticas'>('lista');
  const [modoAgrupamento, setModoAgrupamento] = useState<'arvore' | 'alfabetica'>('arvore');

  // Estado de recolhimento: vazio por padrão (recolhido se sem busca ativa)
  const [gruposAbertos, setGruposAbertos] = useState<Record<string, boolean>>({});
  const [categoriasAbertas, setCategoriasAbertas] = useState<Record<string, boolean>>({});

  const { data: todasArvores } = useQuery({
    queryKey: ['arvores'],
    queryFn: listarArvores,
    staleTime: 30_000,
  });

  const arvoreAtiva = useMemo(
    () => todasArvores?.find((a) => a.id === arvoreAtivaId) ?? null,
    [todasArvores, arvoreAtivaId]
  );

  // Sincroniza escopo 'atual' com a árvore ativa
  useEffect(() => {
    if (escopo === 'atual') {
      setFiltros((f) => ({
        ...f,
        arvore_id: arvoreAtivaId ? arvoreAtivaId : undefined,
        origem: undefined,
      }));
    }
  }, [arvoreAtivaId, escopo]);

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
  const temBuscaTexto = Boolean(filtros.texto && filtros.texto.trim().length > 0);

  const mudar = <C extends keyof FiltrosBusca>(campo: C, valor: FiltrosBusca[C]) =>
    setFiltros((f) => ({ ...f, [campo]: valor }));

  const mudarEscopo = (novoEscopo: EscopoBusca) => {
    setEscopo(novoEscopo);
    setFiltros((f) => ({
      ...f,
      arvore_id: novoEscopo === 'atual' ? (arvoreAtivaId ?? undefined) : undefined,
      origem:
        novoEscopo === 'meus'
          ? 'meus'
          : novoEscopo === 'publicos'
            ? 'publicos'
            : undefined,
    }));
  };

  const toggleGrupo = (nome: string) => {
    setGruposAbertos((prev) => {
      const atual = prev[nome] !== undefined ? prev[nome] : temBuscaTexto;
      return { ...prev, [nome]: !atual };
    });
  };

  const toggleCategoria = (cat: string) => {
    setCategoriasAbertas((prev) => {
      const atual = prev[cat] !== undefined ? prev[cat] : temBuscaTexto;
      return { ...prev, [cat]: !atual };
    });
  };

  const expandirTodos = (chavesArvores: string[], chavesCats: string[]) => {
    const novosGrupos: Record<string, boolean> = {};
    const novasCats: Record<string, boolean> = {};
    chavesArvores.forEach((c) => (novosGrupos[c] = true));
    chavesCats.forEach((c) => (novasCats[c] = true));
    setGruposAbertos(novosGrupos);
    setCategoriasAbertas(novasCats);
  };

  const recolherTodos = (chavesArvores: string[], chavesCats: string[]) => {
    const novosGrupos: Record<string, boolean> = {};
    const novasCats: Record<string, boolean> = {};
    chavesArvores.forEach((c) => (novosGrupos[c] = false));
    chavesCats.forEach((c) => (novasCats[c] = false));
    setGruposAbertos(novosGrupos);
    setCategoriasAbertas(novasCats);
  };

  const handleEscolherPessoa = (p: PersonNode) => {
    if (p.arvore_id && p.arvore_id !== arvoreAtivaId && onSelecionarArvore && todasArvores) {
      const arv = todasArvores.find((a) => a.id === p.arvore_id);
      if (arv) {
        onSelecionarArvore(arv);
      }
    }
    onEscolher(p.id);
  };

  const renderPessoaItem = (p: PersonNode) => (
    <li key={p.id}>
      <button
        type="button"
        onClick={() => handleEscolherPessoa(p)}
        className={`w-full text-left px-3 py-2 border-b border-borda/40 hover:bg-card transition-colors flex items-center gap-2.5 ${
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
          <span className="flex items-center gap-1.5 min-w-0">
            <span className="text-sm text-tinta truncate font-medium">
              {[p.nome, p.sobrenome].filter(Boolean).join(' ')}
            </span>
            {p.is_publico && (
              <span
                title="Registro de referência histórica pública"
                className="flex-none px-1 py-0.2 text-[9.5px] font-semibold rounded bg-acento/10 text-acento border border-acento/20"
              >
                Público
              </span>
            )}
          </span>
          <span className="block font-num text-[11px] text-tinta3">
            {p.ano_nascimento != null
              ? p.ano_nascimento < 0
                ? `n. ${Math.abs(p.ano_nascimento)} a.C.`
                : `n. ${p.ano_nascimento}`
              : 'sem data'}
            {p.ano_falecimento != null
              ? p.ano_falecimento < 0
                ? ` · † ${Math.abs(p.ano_falecimento)} a.C.`
                : ` · † ${p.ano_falecimento}`
              : ''}
          </span>
        </span>
      </button>
    </li>
  );

  // Mapeamento e agrupamento dos resultados
  const {
    pessoasPessoais,
    pessoasPublicas,
    gruposPessoais,
    categoriasPublicasMap,
    todasChavesArvores,
    todasChavesCategorias,
  } = useMemo(() => {
    const lista = resultados ?? [];
    const pessoais: PersonNode[] = [];
    const publicas: PersonNode[] = [];

    for (const p of lista) {
      if (p.is_publico) {
        publicas.push(p);
      } else {
        pessoais.push(p);
      }
    }

    // Grupos pessoais por nome da árvore
    const gPessoais = pessoais.reduce((acc, p) => {
      const chave = p.arvore_nome || 'Meus Registros Familiares';
      if (!acc[chave]) acc[chave] = [];
      acc[chave].push(p);
      return acc;
    }, {} as Record<string, PersonNode[]>);

    // Grupos públicos por Categoria Temática -> Árvore
    const catMap = publicas.reduce((acc, p) => {
      const arv = todasArvores?.find((a) => a.id === p.arvore_id || a.nome === p.arvore_nome);
      const cat = arv?.categoria || p.categoria || 'História Geral';
      const arvNome = p.arvore_nome || 'Árvore de Referência';
      if (!acc[cat]) acc[cat] = {};
      if (!acc[cat][arvNome]) acc[cat][arvNome] = [];
      acc[cat][arvNome].push(p);
      return acc;
    }, {} as Record<string, Record<string, PersonNode[]>>);

    const chavesArvs = [
      ...Object.keys(gPessoais),
      ...Object.values(catMap).flatMap((arvs) => Object.keys(arvs)),
    ];
    const chavesCats = Object.keys(catMap);

    return {
      pessoasPessoais: pessoais,
      pessoasPublicas: publicas,
      gruposPessoais: gPessoais,
      categoriasPublicasMap: catMap,
      todasChavesArvores: chavesArvs,
      todasChavesCategorias: chavesCats,
    };
  }, [resultados, todasArvores]);

  return (
    <>
      <div className="p-3 border-b border-borda flex flex-col gap-2 flex-none">
        {/* Campo de Texto de Busca */}
        <div className="relative">
          <Search className="w-4 h-4 absolute left-2.5 top-1/2 -translate-y-1/2 text-tinta3 pointer-events-none" />
          <Input
            id="campo-busca-pessoas"
            aria-label={t('busca', 'titulo')}
            placeholder={t('busca', 'placeholder')}
            value={filtros.texto ?? ''}
            onChange={(e) => mudar('texto', e.target.value || null)}
            className="pl-8"
          />
        </div>

        {/* Linha de filtros e limpeza */}
        <div className="flex items-center justify-between gap-2">
          <button
            type="button"
            onClick={() => setFiltrosAbertos((a) => !a)}
            className="text-[11px] text-tinta2 hover:text-tinta transition-colors flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
          >
            <SlidersHorizontal className="w-3.5 h-3.5" />
            {t('busca', 'filtros')}
            {ativos > 0 && (
              <span className="px-1.5 rounded-full bg-acento text-acento-tinta text-[10px] font-semibold">
                {ativos}
              </span>
            )}
          </button>

          {(ativos > 0 || filtros.texto || escopo !== (arvoreAtivaId ? 'atual' : 'todos')) && (
            <button
              type="button"
              onClick={() => {
                mudarEscopo(arvoreAtivaId ? 'atual' : 'todos');
                setFiltros({
                  ...FILTROS_VAZIOS,
                  arvore_id: arvoreAtivaId ? arvoreAtivaId : undefined,
                });
              }}
              className="text-[11px] text-tinta3 hover:text-fem transition-colors flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
            >
              <X className="w-3 h-3" />
              {t('busca', 'limparFiltros')}
            </button>
          )}
        </div>

        {/* Seletor de Escopo de 4 Níveis */}
        <div className="flex bg-sup p-0.5 rounded-raio-s border border-borda text-[11px] gap-0.5">
          {arvoreAtiva && (
            <button
              type="button"
              onClick={() => mudarEscopo('atual')}
              title={`Apenas a árvore ativa: ${arvoreAtiva.nome}`}
              className={`flex-1 py-1 px-1 rounded-[4px] transition-all text-center cursor-pointer truncate ${
                escopo === 'atual'
                  ? 'bg-card text-acento font-bold shadow-xs border border-borda'
                  : 'text-tinta3 hover:text-tinta'
              }`}
            >
              🌲 {t('busca', 'arvoreAtual')}
            </button>
          )}
          <button
            type="button"
            onClick={() => mudarEscopo('meus')}
            title={t('busca', 'minhasArvoresSecao')}
            className={`flex-1 py-1 px-1 rounded-[4px] transition-all text-center cursor-pointer truncate ${
              escopo === 'meus'
                ? 'bg-card text-tinta font-bold shadow-xs border border-borda'
                : 'text-tinta3 hover:text-tinta'
            }`}
          >
            👤 {t('busca', 'meusRegistros')}
          </button>
          <button
            type="button"
            onClick={() => mudarEscopo('publicos')}
            title={t('busca', 'acervoPublicoSecao')}
            className={`flex-1 py-1 px-1 rounded-[4px] transition-all text-center cursor-pointer truncate ${
              escopo === 'publicos'
                ? 'bg-card text-acento font-bold shadow-xs border border-borda'
                : 'text-tinta3 hover:text-tinta'
            }`}
          >
            🏛️ {t('busca', 'publicos')}
          </button>
          <button
            type="button"
            onClick={() => mudarEscopo('todos')}
            title={t('busca', 'todasAsArvores')}
            className={`flex-1 py-1 px-1 rounded-[4px] transition-all text-center cursor-pointer truncate ${
              escopo === 'todos'
                ? 'bg-card text-tinta font-bold shadow-xs border border-borda'
                : 'text-tinta3 hover:text-tinta'
            }`}
          >
            {t('busca', 'todosRegistros')}
          </button>
        </div>

        {filtrosAbertos && (
          <div className="flex flex-col gap-2 pt-2 border-t border-borda">
            <label className="flex flex-col gap-1">
              <span className="text-[10.5px] text-tinta2">{t('ficha', 'sobrenome')}</span>
              <input
                type="text"
                value={filtros.sobrenome ?? ''}
                onChange={(e) => mudar('sobrenome', e.target.value || null)}
                placeholder="para agrupar a linhagem"
                className="text-xs px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta w-full"
              />
            </label>

            <label className="flex flex-col gap-1">
              <span className="text-[10.5px] text-tinta2">{t('busca', 'decadaNascimento')}</span>
              <select
                value={filtros.decada ?? ''}
                onChange={(e) => mudar('decada', e.target.value ? Number(e.target.value) : null)}
                className="text-xs px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta w-full"
              >
                <option value="">{t('busca', 'qualquer')}</option>
                {opcoes?.decadas.map((d) => (
                  <option key={d.valor} value={d.valor}>
                    {d.rotulo} ({d.quantas})
                  </option>
                ))}
              </select>
            </label>

            <SeletorDeFiltro
              rotulo={t('busca', 'cidadeNascimento')}
              valor={filtros.local_id}
              opcoes={opcoes?.locais ?? []}
              onMudar={(v) => mudar('local_id', v)}
              rotuloQualquer={t('busca', 'qualquer')}
            />
            <SeletorDeFiltro
              rotulo={t('busca', 'nacionalidadeFiltro')}
              valor={filtros.pais_id}
              opcoes={opcoes?.paises ?? []}
              onMudar={(v) => mudar('pais_id', v)}
              rotuloQualquer={t('busca', 'qualquer')}
            />
            <SeletorDeFiltro
              rotulo={t('busca', 'religiaoFiltro')}
              valor={filtros.religiao}
              opcoes={opcoes?.religioes ?? []}
              onMudar={(v) => mudar('religiao', v)}
              rotuloQualquer={t('busca', 'qualquer')}
            />
            <SeletorDeFiltro
              rotulo={t('busca', 'profissaoFiltro')}
              valor={filtros.profissao}
              opcoes={opcoes?.profissoes ?? []}
              onMudar={(v) => mudar('profissao', v)}
              rotuloQualquer={t('busca', 'qualquer')}
            />
            <SeletorDeFiltro
              rotulo={t('busca', 'escolaridadeFiltro')}
              valor={filtros.escolaridade}
              opcoes={opcoes?.escolaridade ?? []}
              onMudar={(v) => mudar('escolaridade', v)}
              rotuloQualquer={t('busca', 'qualquer')}
            />
            <SeletorDeFiltro
              rotulo={t('busca', 'idiomaFiltro')}
              valor={filtros.idioma}
              opcoes={opcoes?.idiomas ?? []}
              onMudar={(v) => mudar('idioma', v)}
              rotuloQualquer={t('busca', 'qualquer')}
            />

            <label className="flex flex-col gap-1">
              <span className="text-[10.5px] text-tinta2">{t('busca', 'situacao')}</span>
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
                <option value="">{t('busca', 'qualquer')}</option>
                <option value="vivas">{t('busca', 'apenasVivas')}</option>
                <option value="falecidas">{t('busca', 'falecidas')}</option>
              </select>
            </label>
          </div>
        )}
      </div>

      {/* Abas: Lista de Pessoas vs Estatísticas */}
      <div className="flex border-b border-borda bg-sup/60 flex-none">
        <button
          type="button"
          onClick={() => setAba('lista')}
          className={`flex-1 py-1.5 text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors border-b-2 cursor-pointer ${
            aba === 'lista'
              ? 'border-acento text-acento bg-card'
              : 'border-transparent text-tinta3 hover:text-tinta'
          }`}
        >
          <Users className="w-3.5 h-3.5" />
          Lista ({(resultados ?? []).length})
        </button>

        <button
          type="button"
          onClick={() => setAba('estatisticas')}
          className={`flex-1 py-1.5 text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors border-b-2 cursor-pointer ${
            aba === 'estatisticas'
              ? 'border-acento text-acento bg-card'
              : 'border-transparent text-tinta3 hover:text-tinta'
          }`}
        >
          <PieChart className="w-3.5 h-3.5" />
          {t('topo', 'estatisticas')}
        </button>
      </div>

      <div className="flex-1 overflow-y-auto min-h-0">
        {aba === 'estatisticas' ? (
          <PainelEstatisticas
            filtros={filtros}
            onLimparFiltros={() => setFiltros(FILTROS_VAZIOS)}
            filtrosAtivosCount={ativos + (filtros.texto ? 1 : 0)}
            className="p-3"
          />
        ) : (
          <>
            {isLoading && <p className="p-3 text-sm text-tinta3 m-0">{t('comum', 'carregando')}</p>}

            {error && (
              <p role="alert" className="p-3 text-sm text-fem m-0">
                {error instanceof Error ? error.message : String(error)}
              </p>
            )}

            {!isLoading && !error && (resultados ?? []).length === 0 && (
              <div className="p-3 flex flex-col gap-2">
                <p className="text-sm text-tinta3 m-0">
                  {ativos > 0 || filtros.texto
                    ? t('busca', 'nenhumResultado')
                    : t('arvore', 'semPessoas')}
                </p>
                {(ativos > 0 || filtros.texto) && (
                  <button
                    type="button"
                    onClick={() => setFiltros(FILTROS_VAZIOS)}
                    className="self-start text-[11px] text-acento hover:text-tinta bg-transparent border-none cursor-pointer p-0"
                  >
                    {t('busca', 'limparFiltros')}
                  </button>
                )}
              </div>
            )}

            {(resultados ?? []).length > 0 && (
              <>
                <div className="px-3 pt-2 pb-1.5 flex items-center justify-between border-b border-borda/40 bg-sup/30">
                  <p className="font-num text-[10.5px] text-tinta3 m-0">
                    {resultados!.length} {resultados!.length === 1 ? 'pessoa' : 'pessoas'}
                  </p>

                  <div className="flex items-center gap-1.5">
                    {/* Botões Expandir Tudo / Recolher Tudo no modo Por Árvore (apenas ícones com tooltip) */}
                    {modoAgrupamento === 'arvore' && (
                      <div className="flex items-center gap-0.5 bg-sup p-0.5 rounded border border-borda">
                        <button
                          type="button"
                          onClick={() => expandirTodos(todasChavesArvores, todasChavesCategorias)}
                          title={t('busca', 'expandirTudo')}
                          className="p-1 rounded hover:bg-card text-tinta3 hover:text-tinta flex items-center justify-center cursor-pointer transition-colors"
                        >
                          <ChevronsDown className="w-3.5 h-3.5" />
                        </button>
                        <button
                          type="button"
                          onClick={() => recolherTodos(todasChavesArvores, todasChavesCategorias)}
                          title={t('busca', 'recolherTudo')}
                          className="p-1 rounded hover:bg-card text-tinta3 hover:text-tinta flex items-center justify-center cursor-pointer transition-colors"
                        >
                          <ChevronsUp className="w-3.5 h-3.5" />
                        </button>
                      </div>
                    )}

                    {/* Alternância: Por Árvore vs Alfabética */}
                    <div className="flex items-center gap-1 bg-sup p-0.5 rounded border border-borda text-[10px]">
                      <button
                        type="button"
                        onClick={() => setModoAgrupamento('arvore')}
                        title="Agrupar pessoas por linhagem e árvore"
                        className={`px-1.5 py-0.5 rounded flex items-center gap-1 cursor-pointer transition-colors whitespace-nowrap ${
                          modoAgrupamento === 'arvore'
                            ? 'bg-card text-tinta font-bold shadow-2xs'
                            : 'text-tinta3 hover:text-tinta'
                        }`}
                      >
                        <Layers className="w-3 h-3" />
                        <span>{t('busca', 'porArvore')}</span>
                      </button>
                      <button
                        type="button"
                        onClick={() => setModoAgrupamento('alfabetica')}
                        title="Lista alfabética simples"
                        className={`px-1.5 py-0.5 rounded flex items-center gap-1 cursor-pointer transition-colors whitespace-nowrap ${
                          modoAgrupamento === 'alfabetica'
                            ? 'bg-card text-tinta font-bold shadow-2xs'
                            : 'text-tinta3 hover:text-tinta'
                        }`}
                      >
                        <List className="w-3 h-3" />
                        <span>{t('busca', 'alfabetica')}</span>
                      </button>
                    </div>
                  </div>
                </div>

                {modoAgrupamento === 'arvore' ? (
                  // Visualização Agrupada e Categorizada por Árvore / Linhagem
                  <div className="flex flex-col divide-y divide-borda/40">
                    {/* SEÇÃO 1: Minhas Árvores Familiares */}
                    {Object.keys(gruposPessoais).length > 0 && (
                      <div className="flex flex-col">
                        <div className="px-3 py-1.5 bg-sup/80 text-[10px] font-bold text-tinta3 uppercase tracking-wider flex items-center justify-between border-b border-borda/30">
                          <span className="flex items-center gap-1.5">
                            <span>👤</span>
                            <span>{t('busca', 'minhasArvoresSecao')}</span>
                          </span>
                          <span className="font-num text-[10px] text-tinta3">
                            {pessoasPessoais.length}
                          </span>
                        </div>

                        {Object.entries(gruposPessoais).map(([arvNome, pessoas]) => {
                          const aberto = gruposAbertos[arvNome] !== undefined
                            ? gruposAbertos[arvNome]
                            : temBuscaTexto;
                          const arvObj = todasArvores?.find(
                            (a) => a.nome === arvNome || a.id === pessoas[0]?.arvore_id
                          );
                          const isAtiva = arvObj && arvObj.id === arvoreAtivaId;

                          return (
                            <div key={arvNome} className="flex flex-col border-b border-borda/30 last:border-b-0">
                              <div
                                onClick={() => toggleGrupo(arvNome)}
                                className="w-full px-3 py-2 bg-card hover:bg-sup/70 flex items-center justify-between gap-2 text-left cursor-pointer transition-colors"
                              >
                                <span className="flex items-center gap-1.5 min-w-0 text-xs font-semibold text-tinta">
                                  <IconeArvore className="w-3.5 h-3.5 text-acento flex-none" />
                                  <span className="truncate">{arvNome}</span>
                                </span>

                                <div className="flex items-center gap-1.5 flex-none">
                                  {isAtiva ? (
                                    <span className="px-1.5 py-0.2 rounded bg-acento/15 text-acento text-[9px] font-bold flex items-center gap-0.5">
                                      <Check className="w-2.5 h-2.5" />
                                      {t('busca', 'arvoreAtivaBadge')}
                                    </span>
                                  ) : (
                                    arvObj && onSelecionarArvore && (
                                      <button
                                        type="button"
                                        onClick={(e) => {
                                          e.stopPropagation();
                                          onSelecionarArvore(arvObj);
                                        }}
                                        title={t('busca', 'abrirArvore')}
                                        className="px-1.5 py-0.5 rounded bg-sup hover:bg-card border border-borda text-[9.5px] font-medium text-tinta3 hover:text-acento cursor-pointer transition-colors"
                                      >
                                        {t('busca', 'abrirArvore')}
                                      </button>
                                    )
                                  )}

                                  <span className="px-1.5 py-0.2 rounded-full bg-sup border border-borda text-[9.5px] font-bold text-tinta3 font-num">
                                    {pessoas.length}
                                  </span>

                                  {aberto ? (
                                    <ChevronDown className="w-3.5 h-3.5 text-tinta3" />
                                  ) : (
                                    <ChevronRight className="w-3.5 h-3.5 text-tinta3" />
                                  )}
                                </div>
                              </div>

                              {aberto && (
                                <ul className="list-none m-0 p-0 divide-y divide-borda/30 bg-sup/20">
                                  {pessoas.map((p) => renderPessoaItem(p))}
                                </ul>
                              )}
                            </div>
                          );
                        })}
                      </div>
                    )}

                    {/* SEÇÃO 2: Acervo Histórico de Referência Pública (Agrupado por Categoria Temática) */}
                    {Object.keys(categoriasPublicasMap).length > 0 && (
                      <div className="flex flex-col">
                        <div className="px-3 py-1.5 bg-acento/10 text-[10px] font-bold text-acento uppercase tracking-wider flex items-center justify-between border-b border-borda/40">
                          <span className="flex items-center gap-1.5">
                            <span>🏛️</span>
                            <span>{t('busca', 'acervoPublicoSecao')}</span>
                          </span>
                          <span className="font-num text-[10px] text-acento font-bold">
                            {pessoasPublicas.length}
                          </span>
                        </div>

                        {Object.entries(categoriasPublicasMap).map(([catNome, arvoresDaCat]) => {
                          const catAberta = categoriasAbertas[catNome] !== undefined
                            ? categoriasAbertas[catNome]
                            : temBuscaTexto;
                          const totalPessoasCat = Object.values(arvoresDaCat).reduce(
                            (sum, arr) => sum + arr.length,
                            0
                          );

                          return (
                            <div key={catNome} className="flex flex-col border-b border-borda/30">
                              {/* Cabeçalho da Categoria Temática */}
                              <div
                                onClick={() => toggleCategoria(catNome)}
                                className="w-full px-3 py-1.5 bg-sup/60 hover:bg-sup flex items-center justify-between gap-2 text-left cursor-pointer transition-colors border-b border-borda/20"
                              >
                                <span className="flex items-center gap-1.5 min-w-0 text-[11px] font-bold text-tinta2">
                                  <Folder className="w-3 h-3 text-acento flex-none" />
                                  <span className="truncate">{catNome}</span>
                                </span>

                                <div className="flex items-center gap-1.5 flex-none">
                                  <span className="px-1.5 py-0.2 rounded bg-card border border-borda text-[9px] font-semibold text-tinta3 font-num">
                                    {Object.keys(arvoresDaCat).length} {Object.keys(arvoresDaCat).length === 1 ? 'árvore' : 'árvores'} · {totalPessoasCat}
                                  </span>

                                  {catAberta ? (
                                    <ChevronDown className="w-3.5 h-3.5 text-tinta3" />
                                  ) : (
                                    <ChevronRight className="w-3.5 h-3.5 text-tinta3" />
                                  )}
                                </div>
                              </div>

                              {/* Árvores da Categoria */}
                              {catAberta && (
                                <div className="flex flex-col divide-y divide-borda/20 pl-2">
                                  {Object.entries(arvoresDaCat).map(([arvNome, pessoas]) => {
                                    const arvAberta = gruposAbertos[arvNome] !== undefined
                                      ? gruposAbertos[arvNome]
                                      : temBuscaTexto;
                                    const arvObj = todasArvores?.find(
                                      (a) => a.nome === arvNome || a.id === pessoas[0]?.arvore_id
                                    );
                                    const isAtiva = arvObj && arvObj.id === arvoreAtivaId;

                                    return (
                                      <div key={arvNome} className="flex flex-col bg-card/60">
                                        <div
                                          onClick={() => toggleGrupo(arvNome)}
                                          className="w-full px-3 py-1.5 hover:bg-sup flex items-center justify-between gap-2 text-left cursor-pointer transition-colors"
                                        >
                                          <div className="flex flex-col min-w-0 flex-1">
                                            <span className="text-xs font-medium text-tinta truncate">
                                              {arvNome}
                                            </span>
                                            {arvObj && (arvObj.pais || arvObj.periodo) && (
                                              <span className="text-[10px] text-tinta3 truncate">
                                                {[arvObj.pais, arvObj.periodo].filter(Boolean).join(' · ')}
                                              </span>
                                            )}
                                          </div>

                                          <div className="flex items-center gap-1.5 flex-none">
                                            {isAtiva ? (
                                              <span className="px-1.5 py-0.2 rounded bg-acento/15 text-acento text-[9px] font-bold flex items-center gap-0.5">
                                                <Check className="w-2.5 h-2.5" />
                                                {t('busca', 'arvoreAtivaBadge')}
                                              </span>
                                            ) : (
                                              arvObj && onSelecionarArvore && (
                                                <button
                                                  type="button"
                                                  onClick={(e) => {
                                                    e.stopPropagation();
                                                    onSelecionarArvore(arvObj);
                                                  }}
                                                  title={t('busca', 'abrirArvore')}
                                                  className="px-1.5 py-0.5 rounded bg-sup hover:bg-card border border-borda text-[9.5px] font-medium text-tinta3 hover:text-acento cursor-pointer transition-colors"
                                                >
                                                  {t('busca', 'abrirArvore')}
                                                </button>
                                              )
                                            )}

                                            <span className="px-1.5 py-0.2 rounded-full bg-sup border border-borda text-[9px] font-bold text-tinta3 font-num">
                                              {pessoas.length}
                                            </span>

                                            {arvAberta ? (
                                              <ChevronDown className="w-3 h-3 text-tinta3" />
                                            ) : (
                                              <ChevronRight className="w-3 h-3 text-tinta3" />
                                            )}
                                          </div>
                                        </div>

                                        {arvAberta && (
                                          <ul className="list-none m-0 p-0 divide-y divide-borda/30 bg-sup/30">
                                            {pessoas.map((p) => renderPessoaItem(p))}
                                          </ul>
                                        )}
                                      </div>
                                    );
                                  })}
                                </div>
                              )}
                            </div>
                          );
                        })}
                      </div>
                    )}
                  </div>
                ) : (
                  // Visualização Alfabética Simples
                  <ul className="list-none m-0 p-0 divide-y divide-borda/40">
                    {resultados!.map((p: PersonNode) => renderPessoaItem(p))}
                  </ul>
                )}
              </>
            )}
          </>
        )}
      </div>
    </>
  );
}
