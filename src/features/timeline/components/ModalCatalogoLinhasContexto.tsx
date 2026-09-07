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
} from 'lucide-react';
import { Modal } from '../../../components/ui/Modal';
import { LinhaDeContexto } from '../../../lib/api/linhasTempo';

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
  const [busca, setBusca] = useState('');
  const [escopoSelecionado, setEscopoSelecionado] = useState('todos');
  const [categoriaSelecionada, setCategoriaSelecionada] = useState('todas');
  const [apenasAtivas, setApenasAtivas] = useState(false);

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
  }, [linhas, ativas, apenasAtivas, escopoSelecionado, categoriaSelecionada, busca]);

  const totalAtivas = ativas.length;

  return (
    <Modal
      isOpen={aberto}
      onClose={aoFechar}
      title="Catálogo Histórico de Linhas de Contexto"
      className="max-w-5xl"
    >
      <div className="flex flex-col gap-4">
        {/* Cabeçalho explicativo e botão de criação */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-sup/50 p-3.5 rounded-raio border border-borda">
          <div className="flex items-start gap-2.5">
            <div className="p-2 rounded-raio-s bg-acento/10 text-acento mt-0.5">
              <Compass className="w-5 h-5" />
            </div>
            <div>
              <h3 className="text-sm font-semibold text-tinta m-0">
                Acervo Cronológico Curado ({linhas.length} trilhas temáticas e territoriais)
              </h3>
              <p className="text-xs text-tinta2 m-0 mt-0.5">
                Ative simultaneamente acontecimentos mundiais, moedas, governantes, guerras e ciências para situar qualquer biografia no tempo.
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
              className="flex-none px-3 py-2 text-xs font-semibold bg-acento text-acento-tinta hover:bg-acento/90 rounded-raio-s flex items-center gap-1.5 transition-colors cursor-pointer shadow-sm"
              title="Abrir Estúdio para criar uma linha do tempo autoral"
            >
              <Plus className="w-4 h-4" />
              <span>Criar Nova Linha...</span>
            </button>
          )}
        </div>

        {/* Barra de Busca e Filtros de Escopo */}
        <div className="flex flex-col gap-2.5">
          <div className="flex flex-col sm:flex-row gap-2">
            {/* Campo de Busca */}
            <div className="relative flex-1">
              <Search className="w-4 h-4 absolute left-3 top-3 text-tinta3" />
              <input
                type="text"
                placeholder="Pesquise por tema, acontecimento, governante ou país (ex: Roma, Moedas, Guerra, Café, Brasil)..."
                value={busca}
                onChange={(e) => setBusca(e.target.value)}
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

            {/* Seletor de Categoria */}
            <div className="sm:w-56">
              <select
                value={categoriaSelecionada}
                onChange={(e) => setCategoriaSelecionada(e.target.value)}
                className="h-10 w-full rounded-raio border border-borda bg-card px-3 text-xs text-tinta focus:outline-none focus:ring-2 focus:ring-acento/50"
              >
                <option value="todas">Todas as categorias ({categorias.length})</option>
                {categorias.map((cat) => (
                  <option key={cat} value={cat}>
                    {cat}
                  </option>
                ))}
              </select>
            </div>
          </div>

          {/* Abas / Pílulas de Escopo Territorial */}
          <div className="flex items-center gap-1.5 overflow-x-auto pb-1 text-xs no-scrollbar">
            {ESCOPOS_PREDEFINIDOS.map((esc) => {
              const selecionado = escopoSelecionado === esc.id;
              const count =
                esc.id === 'todos'
                  ? linhas.length
                  : linhas.filter((l) => (l.escopo || 'Mundo') === esc.id).length;

              return (
                <button
                  key={esc.id}
                  type="button"
                  onClick={() => setEscopoSelecionado(esc.id)}
                  className={`flex items-center gap-1 px-2.5 py-1.5 rounded-raio-s transition-colors flex-none border ${
                    selecionado
                      ? 'bg-acento text-acento-tinta border-acento font-semibold shadow-xs'
                      : 'bg-card hover:bg-sup text-tinta2 border-borda'
                  }`}
                >
                  <span>{esc.icone}</span>
                  <span>{esc.label}</span>
                  <span
                    className={`text-[10px] ml-0.5 px-1 rounded-full ${
                      selecionado ? 'bg-black/20 text-acento-tinta' : 'bg-sup text-tinta3'
                    }`}
                  >
                    {count}
                  </span>
                </button>
              );
            })}
          </div>
        </div>

        {/* Barra de Status e Controles Rápidos */}
        <div className="flex items-center justify-between text-xs py-1 border-y border-borda text-tinta2">
          <div className="flex items-center gap-2">
            <span>
              Mostrando <strong>{linhasFiltradas.length}</strong> de {linhas.length} linhas
            </span>
            {busca && (
              <span className="text-tinta3 italic">
                (filtrado por "{busca}")
              </span>
            )}
          </div>

          <div className="flex items-center gap-3">
            <button
              type="button"
              onClick={() => setApenasAtivas(!apenasAtivas)}
              className={`flex items-center gap-1.5 px-2 py-1 rounded transition-colors ${
                apenasAtivas
                  ? 'bg-acento/15 text-acento font-semibold'
                  : 'text-tinta3 hover:text-tinta hover:bg-sup'
              }`}
            >
              {apenasAtivas ? <Eye className="w-3.5 h-3.5" /> : <EyeOff className="w-3.5 h-3.5" />}
              <span>Apenas ativas ({totalAtivas})</span>
            </button>

            {totalAtivas > 0 && onDesativarTodas && (
              <button
                type="button"
                onClick={onDesativarTodas}
                className="text-vermelho hover:underline text-xs"
              >
                Desativar todas
              </button>
            )}
          </div>
        </div>

        {/* Grade de Cards das Linhas de Contexto */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3 max-h-[52vh] overflow-y-auto pr-1">
          {linhasFiltradas.length === 0 ? (
            <div className="col-span-full py-12 text-center text-tinta3 flex flex-col items-center gap-2">
              <Layers className="w-8 h-8 opacity-30" />
              <p className="text-sm font-medium">Nenhuma linha histórica encontrada para este filtro.</p>
              <button
                type="button"
                onClick={() => {
                  setBusca('');
                  setEscopoSelecionado('todos');
                  setCategoriaSelecionada('todas');
                  setApenasAtivas(false);
                }}
                className="text-xs text-acento hover:underline mt-1"
              >
                Limpar todos os filtros de pesquisa
              </button>
            </div>
          ) : (
            linhasFiltradas.map((linha) => {
              const estaAtiva = ativas.includes(linha.id);
              const icone = linha.icone || '📌';
              const escopo = linha.escopo || 'Mundo';

              return (
                <div
                  key={linha.id}
                  className={`group relative flex flex-col justify-between p-3.5 rounded-raio border transition-all ${
                    estaAtiva
                      ? 'bg-acento/5 border-acento/60 shadow-xs ring-1 ring-acento/30'
                      : 'bg-card hover:bg-sup/40 border-borda hover:border-acento/40'
                  }`}
                >
                  <div className="flex flex-col gap-2">
                    {/* Linha de topo: Ícone + Título + Trava */}
                    <div className="flex items-start gap-2.5">
                      <div className="text-xl flex-none w-8 h-8 rounded-raio-s bg-sup flex items-center justify-center border border-borda group-hover:scale-105 transition-transform">
                        {icone}
                      </div>

                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-1.5 flex-wrap">
                          <span className="text-[10px] uppercase font-bold tracking-wider px-1.5 py-0.5 rounded bg-sup text-tinta3 border border-borda">
                            {escopo}
                          </span>
                          <span className="text-[10px] text-tinta3 truncate max-w-[120px]">
                            {linha.categoria}
                          </span>
                          {linha.is_bloqueada && (
                            <span title="Linha oficial curada e protegida">
                              <Lock className="w-3 h-3 text-tinta3 flex-none" />
                            </span>
                          )}
                        </div>

                        <h4 className="text-xs font-semibold text-tinta mt-1 leading-snug line-clamp-2">
                          {linha.titulo}
                        </h4>
                      </div>
                    </div>

                    {/* Metadados: Período e Contagem */}
                    <div className="flex items-center gap-3 text-[11px] text-tinta3 mt-1 pt-1.5 border-t border-borda/60">
                      <div className="flex items-center gap-1" title="Extensão temporal">
                        <Calendar className="w-3 h-3 text-tinta3 flex-none" />
                        <span className="truncate">{formatarPeriodo(linha.ano_min, linha.ano_max)}</span>
                      </div>

                      <div className="flex items-center gap-1 ml-auto flex-none" title="Total de marcos">
                        <Sparkles className="w-3 h-3 text-tinta3 flex-none" />
                        <span>
                          <strong>{linha.marcos_total}</strong> marcos
                        </span>
                      </div>
                    </div>

                    {/* Descrição / Fonte de referência */}
                    {linha.fonte_referencia && (
                      <p className="text-[11px] text-tinta2 line-clamp-2 m-0 mt-0.5 leading-relaxed">
                        {linha.fonte_referencia}
                      </p>
                    )}
                  </div>

                  {/* Botão de Ação / Ativação */}
                  <div className="mt-3 pt-2.5 border-t border-borda/60">
                    <button
                      type="button"
                      onClick={() => onAlternarLinha(linha.id)}
                      className={`w-full py-1.5 px-3 text-xs rounded-raio-s flex items-center justify-center gap-1.5 transition-colors font-medium cursor-pointer ${
                        estaAtiva
                          ? 'bg-acento text-acento-tinta hover:bg-acento/90 shadow-xs'
                          : 'bg-sup hover:bg-card border border-borda text-tinta hover:border-acento/60'
                      }`}
                    >
                      {estaAtiva ? (
                        <>
                          <Check className="w-3.5 h-3.5" />
                          <span>Ativa na Gaveta</span>
                        </>
                      ) : (
                        <>
                          <Plus className="w-3.5 h-3.5" />
                          <span>Ativar na Linha do Tempo</span>
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
        <div className="flex items-center justify-between pt-3 border-t border-borda mt-1">
          <span className="text-[11px] text-tinta3">
            💡 <strong>Dica:</strong> As linhas ativas aparecem como faixas paralelas na gaveta temporal, comparando governantes, moedas e guerras com as pessoas da sua árvore.
          </span>

          <button
            type="button"
            onClick={aoFechar}
            className="px-4 py-2 text-xs font-semibold bg-sup hover:bg-card border border-borda rounded-raio-s text-tinta transition-colors cursor-pointer"
          >
            Concluir Seleção
          </button>
        </div>
      </div>
    </Modal>
  );
}
