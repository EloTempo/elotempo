import { useState, useMemo } from 'react';
import {
  Search,
  X,
  Lock,
  Check,
  Plus,
  Compass,
  Layers,
  Sparkles,
  Calendar,
  Eye,
  EyeOff,
  RotateCcw,
} from 'lucide-react';
import { Modal } from '../../../components/ui/Modal';
import { LinhaDeContexto } from '../../../lib/api/linhasTempo';
import { useI18n } from '../../../i18n/I18nContext';

interface ModalCatalogoLinhasContextoProps {
  aberto: boolean;
  aoFechar: () => void;
  linhas: LinhaDeContexto[];
  ativas: string[];
  onAlternarLinha: (id: string) => void;
  onCriarNovaLinha?: () => void;
  onDesativarTodas?: () => void;
}

function formatarPeriodo(min?: number | null, max?: number | null): string {
  if (min == null && max == null) return 'Período amplo';
  const fmt = (ano: number) => (ano < 0 ? `${Math.abs(ano)} a.C.` : `${ano}`);
  if (min != null && max != null) {
    if (min === max) return fmt(min);
    return `${fmt(min)} — ${fmt(max)}`;
  }
  if (min != null) return `A partir de ${fmt(min)}`;
  return `Até ${fmt(max!)}`;
}

const ESCOPOS_PREDEFINIDOS = [
  { id: 'todos', label: 'Todos os Escopos', icone: '🌐' },
  { id: 'Brasil', label: 'Brasil', icone: '🇧🇷' },
  { id: 'Mundo', label: 'Mundo', icone: '🌍' },
  { id: 'Estados Unidos', label: 'Estados Unidos', icone: '🇺🇸' },
  { id: 'Europa', label: 'Europa', icone: '🇪🇺' },
  { id: 'Rússia', label: 'Rússia', icone: '🇷🇺' },
  { id: 'Oriente Próximo', label: 'Oriente Próximo / Bíblico', icone: '📜' },
  { id: 'América Latina', label: 'América Latina', icone: '🌎' },
];

export function ModalCatalogoLinhasContexto({
  aberto,
  aoFechar,
  linhas,
  ativas,
  onAlternarLinha,
  onCriarNovaLinha,
  onDesativarTodas,
}: ModalCatalogoLinhasContextoProps) {
  const { t } = useI18n();
  const [filtroOrigem, setFiltroOrigem] = useState<'todas' | 'minhas' | 'curadas'>('todas');
  const [busca, setBusca] = useState('');
  const [escopoSelecionado, setEscopoSelecionado] = useState('todos');
  const [categoriaSelecionada, setCategoriaSelecionada] = useState('todas');
  const [apenasAtivas, setApenasAtivas] = useState(false);

  // Totais para badges dos seletores
  const totalLinhas = linhas.length;
  const totalMinhas = useMemo(() => linhas.filter((l) => !l.is_bloqueada).length, [linhas]);
  const totalCuradas = useMemo(() => linhas.filter((l) => l.is_bloqueada).length, [linhas]);
  const totalAtivas = ativas.length;

  // Extrai todas as categorias presentes nas linhas
  const categorias = useMemo(() => {
    const cats = new Set<string>();
    linhas.forEach((l) => {
      if (l.categoria) cats.add(l.categoria);
    });
    return Array.from(cats).sort();
  }, [linhas]);

  // Filtra as linhas conforme os critérios
  const linhasFiltradas = useMemo(() => {
    return linhas.filter((linha) => {
      // Filtro de origem (minhas linhas autorais vs acervo curado do sistema)
      if (filtroOrigem === 'minhas' && linha.is_bloqueada) return false;
      if (filtroOrigem === 'curadas' && !linha.is_bloqueada) return false;

      // Filtro de ativas
      if (apenasAtivas && !ativas.includes(linha.id)) {
        return false;
      }

      // Filtro de escopo
      if (escopoSelecionado !== 'todos') {
        if ((linha.escopo || 'Mundo') !== escopoSelecionado) {
          return false;
        }
      }

      // Filtro de categoria
      if (categoriaSelecionada !== 'todas') {
        if (linha.categoria !== categoriaSelecionada) {
          return false;
        }
      }

      // Filtro textual
      if (busca.trim().length > 0) {
        const termo = busca.toLowerCase();
        const noTitulo = linha.titulo.toLowerCase().includes(termo);
        const naCategoria = linha.categoria.toLowerCase().includes(termo);
        const noEscopo = (linha.escopo || '').toLowerCase().includes(termo);
        const naFonte = (linha.fonte_referencia || '').toLowerCase().includes(termo);
        if (!noTitulo && !naCategoria && !noEscopo && !naFonte) {
          return false;
        }
      }

      return true;
    });
  }, [linhas, filtroOrigem, ativas, apenasAtivas, escopoSelecionado, categoriaSelecionada, busca]);

  const temFiltroAtivo =
    filtroOrigem !== 'todas' ||
    escopoSelecionado !== 'todos' ||
    categoriaSelecionada !== 'todas' ||
    busca.trim().length > 0 ||
    apenasAtivas;

  const limparTodosFiltros = () => {
    setFiltroOrigem('todas');
    setBusca('');
    setEscopoSelecionado('todos');
    setCategoriaSelecionada('todas');
    setApenasAtivas(false);
  };

  return (
    <Modal
      isOpen={aberto}
      onClose={aoFechar}
      title={t('catalogoContexto', 'tituloModal')}
      className="max-w-5xl"
    >
      <div className="flex flex-col gap-3.5">
        {/* Cabeçalho Compacto com Ação Principal */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-3 border-b border-borda">
          <div className="flex items-center gap-2.5">
            <div className="p-2 rounded-raio-s bg-acento/10 text-acento flex-none">
              <Compass className="w-5 h-5" />
            </div>
            <div>
              <p className="text-xs text-tinta2 m-0 leading-relaxed">
                {t('catalogoContexto', 'subtituloModal')}
              </p>
            </div>
          </div>

          {onCriarNovaLinha && (
            <button
              type="button"
              onClick={() => {
                aoFechar();
                onCriarNovaLinha();
              }}
              className="flex-none px-3.5 py-1.5 text-xs font-semibold bg-acento text-acento-tinta hover:bg-acento/90 rounded-raio-s flex items-center gap-1.5 transition-colors cursor-pointer shadow-xs"
              title={t('catalogoContexto', 'criarNovaLinha')}
            >
              <Plus className="w-4 h-4" />
              <span>{t('catalogoContexto', 'criarNovaLinha')}</span>
            </button>
          )}
        </div>

        {/* Controles Principais: Abas de Origem + Busca + Categoria */}
        <div className="flex flex-col gap-2.5">
          <div className="flex flex-col md:flex-row items-stretch md:items-center justify-between gap-2.5">
            {/* Seletor Segmentado de Origem (Todas / Minhas Linhas / Acervo Curado) */}
            <div className="flex items-center p-0.5 rounded-raio-s bg-card2 border border-borda2 text-xs self-start md:self-auto shadow-2xs">
              <button
                type="button"
                onClick={() => setFiltroOrigem('todas')}
                className={`px-3 py-1.5 rounded-raio-s transition-all flex items-center gap-1.5 font-medium cursor-pointer ${
                  filtroOrigem === 'todas'
                    ? 'bg-card text-tinta font-bold shadow-xs border border-borda/60'
                    : 'text-tinta2 hover:text-tinta'
                }`}
              >
                <span>{t('catalogoContexto', 'todasAsLinhas')}</span>
                <span
                  className={`text-[10px] font-num px-1.5 py-0.2 rounded-full ${
                    filtroOrigem === 'todas'
                      ? 'bg-acento/15 text-acento font-bold'
                      : 'bg-sup text-tinta3'
                  }`}
                >
                  {totalLinhas}
                </span>
              </button>

              <button
                type="button"
                onClick={() => setFiltroOrigem('minhas')}
                className={`px-3 py-1.5 rounded-raio-s transition-all flex items-center gap-1.5 font-medium cursor-pointer ${
                  filtroOrigem === 'minhas'
                    ? 'bg-card text-tinta font-bold shadow-xs border border-borda/60'
                    : 'text-tinta2 hover:text-tinta'
                }`}
              >
                <span className="text-amber-500 text-xs">⭐</span>
                <span>{t('catalogoContexto', 'minhasLinhas')}</span>
                <span
                  className={`text-[10px] font-num px-1.5 py-0.2 rounded-full ${
                    totalMinhas > 0
                      ? 'bg-amber-500/20 text-amber-700 dark:text-amber-300 font-bold'
                      : filtroOrigem === 'minhas'
                        ? 'bg-acento/15 text-acento font-bold'
                        : 'bg-sup text-tinta3'
                  }`}
                >
                  {totalMinhas}
                </span>
              </button>

              <button
                type="button"
                onClick={() => setFiltroOrigem('curadas')}
                className={`px-3 py-1.5 rounded-raio-s transition-all flex items-center gap-1.5 font-medium cursor-pointer ${
                  filtroOrigem === 'curadas'
                    ? 'bg-card text-tinta font-bold shadow-xs border border-borda/60'
                    : 'text-tinta2 hover:text-tinta'
                }`}
              >
                <Lock className="w-3 h-3 text-tinta3" />
                <span>{t('catalogoContexto', 'acervoCurado')}</span>
                <span
                  className={`text-[10px] font-num px-1.5 py-0.2 rounded-full ${
                    filtroOrigem === 'curadas'
                      ? 'bg-acento/15 text-acento font-bold'
                      : 'bg-sup text-tinta3'
                  }`}
                >
                  {totalCuradas}
                </span>
              </button>
            </div>

            {/* Busca Rápida e Categoria */}
            <div className="flex items-center gap-2 flex-1 md:max-w-md">
              <div className="relative flex-1">
                <Search className="w-3.5 h-3.5 absolute left-2.5 top-2.5 text-tinta3" />
                <input
                  type="text"
                  placeholder={t('catalogoContexto', 'buscarPlaceholder')}
                  value={busca}
                  onChange={(e) => setBusca(e.target.value)}
                  className="w-full h-8.5 rounded-raio-s border border-borda bg-card pl-8 pr-7 text-xs text-tinta placeholder:text-tinta3 focus:outline-none focus:ring-1 focus:ring-acento"
                />
                {busca && (
                  <button
                    type="button"
                    onClick={() => setBusca('')}
                    className="absolute right-2 top-2 text-tinta3 hover:text-tinta p-0.5 cursor-pointer"
                    title={t('comum', 'limpar')}
                  >
                    <X className="w-3 h-3" />
                  </button>
                )}
              </div>

              <div className="w-48 flex-none">
                <select
                  value={categoriaSelecionada}
                  onChange={(e) => setCategoriaSelecionada(e.target.value)}
                  className="h-8.5 w-full rounded-raio-s border border-borda bg-card px-2 text-xs text-tinta focus:outline-none focus:ring-1 focus:ring-acento cursor-pointer font-medium"
                >
                  <option value="todas">
                    {t('catalogoContexto', 'todasCategorias')} ({categorias.length})
                  </option>
                  {categorias.map((cat) => (
                    <option key={cat} value={cat}>
                      {cat}
                    </option>
                  ))}
                </select>
              </div>
            </div>
          </div>

          {/* Pílulas de Escopo Territorial */}
          <div className="flex items-center gap-1.5 overflow-x-auto pb-1 text-xs no-scrollbar pt-0.5">
            {ESCOPOS_PREDEFINIDOS.map((esc) => {
              const selecionado = escopoSelecionado === esc.id;
              const count =
                esc.id === 'todos'
                  ? filtroOrigem === 'minhas'
                    ? totalMinhas
                    : filtroOrigem === 'curadas'
                      ? totalCuradas
                      : totalLinhas
                  : linhas.filter((l) => {
                      if (filtroOrigem === 'minhas' && l.is_bloqueada) return false;
                      if (filtroOrigem === 'curadas' && !l.is_bloqueada) return false;
                      return (l.escopo || 'Mundo') === esc.id;
                    }).length;

              return (
                <button
                  key={esc.id}
                  type="button"
                  onClick={() => setEscopoSelecionado(esc.id)}
                  className={`flex items-center gap-1.5 px-2.5 py-1 rounded-raio-s transition-all flex-none border text-xs cursor-pointer ${
                    selecionado
                      ? 'bg-acento text-acento-tinta border-acento font-bold shadow-xs'
                      : 'bg-card hover:bg-sup text-tinta2 hover:text-tinta border-borda'
                  }`}
                >
                  <span className="text-xs">{esc.icone}</span>
                  <span className="font-medium">{esc.label}</span>
                  <span
                    className={`text-[10px] font-num px-1.5 py-0.2 rounded-full ${
                      selecionado ? 'bg-black/25 text-acento-tinta font-bold' : 'bg-card2 text-tinta3'
                    }`}
                  >
                    {count}
                  </span>
                </button>
              );
            })}
          </div>
        </div>

        {/* Barra de Status e Controles de Exibição */}
        <div className="flex items-center justify-between text-xs py-1.5 border-y border-borda text-tinta2">
          <div className="flex items-center gap-2 flex-wrap">
            <span className="font-medium text-tinta">
              {t('catalogoContexto', 'mostrandoLinhas', {
                visiveis: linhasFiltradas.length,
                total: linhas.length,
              })}
            </span>

            {temFiltroAtivo && (
              <button
                type="button"
                onClick={limparTodosFiltros}
                className="text-[11px] text-acento hover:underline font-semibold flex items-center gap-1 cursor-pointer"
              >
                <RotateCcw className="w-3 h-3" />
                <span>{t('catalogoContexto', 'limparFiltros')}</span>
              </button>
            )}
          </div>

          <div className="flex items-center gap-3">
            <button
              type="button"
              onClick={() => setApenasAtivas(!apenasAtivas)}
              className={`flex items-center gap-1.5 px-2.5 py-1 rounded-raio-s transition-colors text-xs font-medium cursor-pointer border ${
                apenasAtivas
                  ? 'bg-acento/15 text-acento border-acento/40 font-bold'
                  : 'bg-card hover:bg-sup text-tinta2 border-borda hover:border-borda2'
              }`}
            >
              {apenasAtivas ? (
                <Eye className="w-3.5 h-3.5 text-acento" />
              ) : (
                <EyeOff className="w-3.5 h-3.5 text-tinta3" />
              )}
              <span>
                {t('catalogoContexto', 'apenasAtivas')} ({totalAtivas})
              </span>
            </button>

            {totalAtivas > 0 && onDesativarTodas && (
              <button
                type="button"
                onClick={onDesativarTodas}
                className="text-vermelho hover:underline text-xs font-semibold cursor-pointer"
              >
                {t('catalogoContexto', 'desativarTodas')}
              </button>
            )}
          </div>
        </div>

        {/* Grade de Cards das Linhas de Contexto */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3 max-h-[50vh] overflow-y-auto pr-1">
          {linhasFiltradas.length === 0 ? (
            filtroOrigem === 'minhas' && totalMinhas === 0 ? (
              <div className="col-span-full py-12 px-4 text-center flex flex-col items-center gap-3 bg-sup/20 rounded-raio border border-dashed border-borda2">
                <div className="w-12 h-12 rounded-full bg-amber-500/10 text-amber-500 flex items-center justify-center">
                  <Sparkles className="w-6 h-6" />
                </div>
                <div>
                  <h4 className="text-sm font-bold text-tinta m-0">
                    {t('catalogoContexto', 'nenhumaMinhaLinha')}
                  </h4>
                  <p className="text-xs text-tinta2 max-w-md mt-1 m-0 leading-relaxed">
                    {t('catalogoContexto', 'nenhumaMinhaLinhaDesc')}
                  </p>
                </div>
                {onCriarNovaLinha && (
                  <button
                    type="button"
                    onClick={() => {
                      aoFechar();
                      onCriarNovaLinha();
                    }}
                    className="px-4 py-2 text-xs font-bold bg-acento text-acento-tinta hover:bg-acento/90 rounded-raio-s flex items-center gap-1.5 transition-colors cursor-pointer shadow-xs mt-1"
                  >
                    <Plus className="w-4 h-4" />
                    <span>{t('catalogoContexto', 'criarPrimeiraLinha')}</span>
                  </button>
                )}
              </div>
            ) : (
              <div className="col-span-full py-12 text-center text-tinta3 flex flex-col items-center gap-2">
                <Layers className="w-8 h-8 opacity-30" />
                <p className="text-sm font-medium text-tinta2">
                  {t('catalogoContexto', 'nenhumaEncontrada')}
                </p>
                <button
                  type="button"
                  onClick={limparTodosFiltros}
                  className="text-xs text-acento hover:underline font-semibold mt-1 cursor-pointer"
                >
                  {t('catalogoContexto', 'limparFiltros')}
                </button>
              </div>
            )
          ) : (
            linhasFiltradas.map((linha) => {
              const estaAtiva = ativas.includes(linha.id);
              const icone = linha.icone || '📌';
              const escopo = linha.escopo || 'Mundo';
              const isAutoral = !linha.is_bloqueada;

              // Filtra descrição genérica repetitiva para manter o layout limpo e direto
              const temDescricaoUtil =
                linha.fonte_referencia &&
                !linha.fonte_referencia.startsWith('Acervo histórico curado do EloTempo');

              return (
                <div
                  key={linha.id}
                  className={`group relative flex flex-col justify-between p-3.5 rounded-raio border transition-all ${
                    estaAtiva
                      ? 'bg-acento/[0.08] border-acento shadow-xs ring-1 ring-acento/40'
                      : 'bg-card hover:bg-card2 border-borda hover:border-borda2 hover:shadow-2xs'
                  }`}
                >
                  <div className="flex flex-col gap-2">
                    {/* Linha de Topo: Ícone + Tags + Status Ativo */}
                    <div className="flex items-start gap-2.5">
                      <div className="text-xl flex-none w-8 h-8 rounded-raio-s bg-sup flex items-center justify-center border border-borda shadow-2xs group-hover:scale-105 transition-transform">
                        {icone}
                      </div>

                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-1.5 flex-wrap">
                          {isAutoral ? (
                            <span className="text-[10px] font-bold px-1.5 py-0.5 rounded bg-amber-500/15 text-amber-700 dark:text-amber-300 border border-amber-500/30 flex items-center gap-0.5">
                              ⭐ {t('catalogoContexto', 'minhaLinhaBadge')}
                            </span>
                          ) : (
                            <span className="text-[10px] uppercase font-bold tracking-wider px-1.5 py-0.5 rounded bg-sup text-tinta border border-borda2 flex items-center gap-1">
                              <Lock className="w-2.5 h-2.5 text-tinta3" />
                              {escopo}
                            </span>
                          )}

                          <span
                            className="text-[11px] text-tinta2 font-medium truncate max-w-[130px]"
                            title={linha.categoria}
                          >
                            {linha.categoria}
                          </span>
                        </div>

                        <h4 className="text-sm font-serif font-bold text-tinta mt-1 leading-snug line-clamp-2">
                          {linha.titulo}
                        </h4>
                      </div>
                    </div>

                    {/* Metadados: Período Temporal & Contagem de Marcos */}
                    <div className="flex items-center justify-between text-xs text-tinta2 mt-1.5 pt-2 border-t border-borda/60">
                      <div
                        className="flex items-center gap-1 text-tinta font-num font-semibold"
                        title="Extensão temporal"
                      >
                        <Calendar className="w-3.5 h-3.5 text-acento/90 flex-none" />
                        <span className="truncate">{formatarPeriodo(linha.ano_min, linha.ano_max)}</span>
                      </div>

                      <div
                        className="flex items-center gap-1 text-tinta font-num"
                        title="Total de marcos"
                      >
                        <Sparkles className="w-3.5 h-3.5 text-acento/80 flex-none" />
                        <span>
                          <strong className="font-bold">{linha.marcos_total}</strong>{' '}
                          {t('catalogoContexto', 'marcos')}
                        </span>
                      </div>
                    </div>

                    {/* Descrição / Fonte se for informativa */}
                    {temDescricaoUtil && (
                      <p className="text-[11px] text-tinta2 line-clamp-2 m-0 mt-0.5 leading-relaxed italic bg-sup/40 p-1.5 rounded-raio-s border border-borda/40">
                        {linha.fonte_referencia}
                      </p>
                    )}
                  </div>

                  {/* Botão de Ação / Ativação */}
                  <div className="mt-3 pt-2.5 border-t border-borda/60">
                    <button
                      type="button"
                      onClick={() => onAlternarLinha(linha.id)}
                      className={`w-full py-1.5 px-3 text-xs rounded-raio-s flex items-center justify-center gap-1.5 transition-colors font-bold cursor-pointer ${
                        estaAtiva
                          ? 'bg-acento text-acento-tinta hover:bg-acento/90 shadow-xs'
                          : 'bg-sup hover:bg-card border border-borda2 text-tinta hover:border-acento hover:text-acento shadow-2xs'
                      }`}
                    >
                      {estaAtiva ? (
                        <>
                          <Check className="w-3.5 h-3.5 stroke-[2.5]" />
                          <span>{t('catalogoContexto', 'ativaNaGaveta')}</span>
                        </>
                      ) : (
                        <>
                          <Plus className="w-3.5 h-3.5" />
                          <span>{t('catalogoContexto', 'ativarNaLinhaTempo')}</span>
                        </>
                      )}
                    </button>
                  </div>
                </div>
              );
            })
          )}
        </div>

        {/* Rodapé do Modal */}
        <div className="flex flex-col sm:flex-row items-center justify-between gap-3 pt-3 border-t border-borda mt-1">
          <span className="text-xs text-tinta2 flex items-center gap-1.5">
            <span className="text-sm">💡</span>
            <span>{t('catalogoContexto', 'dicaRodape')}</span>
          </span>

          <button
            type="button"
            onClick={aoFechar}
            className="w-full sm:w-auto px-5 py-2 text-xs font-bold bg-acento text-acento-tinta hover:bg-acento/90 rounded-raio-s transition-colors cursor-pointer shadow-xs"
          >
            {t('catalogoContexto', 'concluirSelecao')}
          </button>
        </div>
      </div>
    </Modal>
  );
}
