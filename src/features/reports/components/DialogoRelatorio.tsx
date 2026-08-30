/**
 * Escolha do modo e das opções antes de imprimir (fatia 05).
 *
 * O PDF sai pelo `window.print()`: a webview do Tauri abre o diálogo do
 * sistema, que traz "Salvar como PDF" junto da impressão direta. Não há
 * geração de PDF em Rust — uma biblioteca para isso pesaria no binário e
 * duplicaria o motor de layout que a webview já tem.
 */

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Printer } from 'lucide-react';
import { Button } from '../../../components/ui/Button';
import { montarRelatorio, buscarGrafoArvore, ErroDoAcervo } from '../../../lib/api';
import { RelatorioView, type ModoImpressao, type OpcoesImpressao } from './RelatorioView';

interface DialogoRelatorioProps {
  /** Raiz da árvore atual, quando houver. */
  raizId: string | null;
  onFechar: () => void;
}

const MODOS: Array<{ id: ModoImpressao; rotulo: string; descricao: string }> = [
  {
    id: 'hierarquia',
    rotulo: 'Só hierarquia',
    descricao: 'O diagrama da família, sem o texto. É o mapa.',
  },
  {
    id: 'texto',
    rotulo: 'Só texto',
    descricao: 'Fichas corridas, do mais antigo ao mais recente. Barato de imprimir.',
  },
  {
    id: 'combinado',
    rotulo: 'Combinado',
    descricao: 'O diagrama e, abaixo dele, as fichas.',
  },
];

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo || erro instanceof Error) return erro.message;
  return String(erro);
}

export function DialogoRelatorio({ raizId, onFechar }: DialogoRelatorioProps) {
  const [modo, setModo] = useState<ModoImpressao>('combinado');
  const [escopoArvore, setEscopoArvore] = useState(!!raizId);
  const [ocultarVivas, setOcultarVivas] = useState(false);
  const [incluirMiniaturas, setIncluirMiniaturas] = useState(false);
  const [quebrarPorGeracao, setQuebrarPorGeracao] = useState(true);

  const raizEfetiva = escopoArvore ? raizId : null;

  const { data: relatorio, isLoading, error } = useQuery({
    queryKey: ['relatorio', raizEfetiva, ocultarVivas],
    queryFn: () =>
      montarRelatorio({
        raiz_id: raizEfetiva,
        ocultar_vivas: ocultarVivas,
        incluir_placeholders: false,
      }),
  });

  // O diagrama precisa do grafo, que só existe com uma raiz escolhida.
  const { data: grafo } = useQuery({
    queryKey: ['arvore', raizId],
    queryFn: () => buscarGrafoArvore(raizId!),
    enabled: !!raizId && modo !== 'texto',
  });

  const opcoes: OpcoesImpressao = { modo, incluirMiniaturas, quebrarPorGeracao };
  const titulo = escopoArvore && raizId ? 'Árvore genealógica' : 'Acervo genealógico completo';

  return (
    <>
      {/* A tela de opções. Some na impressão — o @media print esconde tudo
          que não seja #print-container. */}
      <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm print:hidden">
        <div className="absolute inset-0" onClick={onFechar} aria-hidden />

        <div className="relative w-full max-w-lg bg-card rounded-raio border border-borda shadow-sombra overflow-hidden flex flex-col max-h-[85vh]">
          <header className="p-4 border-b border-borda bg-card2">
            <h2 className="font-tit font-bold text-lg m-0">Relatório</h2>
            <p className="text-xs text-tinta2 m-0 mt-0.5">
              A4 retrato · margens de 18 mm · salvável em PDF pelo diálogo de impressão
            </p>
          </header>

          <div className="flex-1 overflow-y-auto min-h-0 p-4 flex flex-col gap-5">
            {mensagemDeErro(error) && (
              <p role="alert" className="text-sm text-fem m-0 bg-fem/10 border border-fem/20 rounded-raio-s p-3">
                {mensagemDeErro(error)}
              </p>
            )}

            <fieldset className="flex flex-col gap-2 border-none p-0 m-0">
              <legend className="font-num text-[10.5px] uppercase tracking-wider text-tinta3 mb-1 p-0">
                Modo de impressão
              </legend>
              {MODOS.map((m) => (
                <label
                  key={m.id}
                  className={`flex gap-2.5 p-2.5 rounded-raio-s border cursor-pointer transition-colors ${
                    modo === m.id ? 'border-acento bg-card2' : 'border-borda hover:border-borda2'
                  }`}
                >
                  <input
                    type="radio"
                    name="modo"
                    checked={modo === m.id}
                    onChange={() => setModo(m.id)}
                    className="mt-0.5 accent-[var(--acento)]"
                  />
                  <span className="flex flex-col gap-0.5">
                    <span className="text-sm font-semibold text-tinta">{m.rotulo}</span>
                    <span className="text-xs text-tinta2 leading-relaxed">{m.descricao}</span>
                  </span>
                </label>
              ))}
            </fieldset>

            <fieldset className="flex flex-col gap-2 border-none p-0 m-0">
              <legend className="font-num text-[10.5px] uppercase tracking-wider text-tinta3 mb-1 p-0">
                Escopo e opções
              </legend>

              <label className="flex items-start gap-2 text-sm text-tinta2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={escopoArvore}
                  disabled={!raizId}
                  onChange={(e) => setEscopoArvore(e.target.checked)}
                  className="mt-0.5 rounded border-borda accent-[var(--acento)]"
                />
                <span>
                  Só a árvore em volta da pessoa selecionada
                  {!raizId && (
                    <span className="block text-xs text-tinta3">
                      Escolha alguém na lista para habilitar.
                    </span>
                  )}
                </span>
              </label>

              <label className="flex items-start gap-2 text-sm text-tinta2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={ocultarVivas}
                  onChange={(e) => setOcultarVivas(e.target.checked)}
                  className="mt-0.5 rounded border-borda accent-[var(--acento)]"
                />
                <span>
                  Ocultar pessoas vivas
                  <span className="block text-xs text-tinta3">
                    Para circular o documento fora da família.
                  </span>
                </span>
              </label>

              <label className="flex items-start gap-2 text-sm text-tinta2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={incluirMiniaturas}
                  onChange={(e) => setIncluirMiniaturas(e.target.checked)}
                  className="mt-0.5 rounded border-borda accent-[var(--acento)]"
                />
                <span>
                  Incluir miniaturas
                  <span className="block text-xs text-tinta3">Fotos encarecem a impressão.</span>
                </span>
              </label>

              <label className="flex items-start gap-2 text-sm text-tinta2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={quebrarPorGeracao}
                  onChange={(e) => setQuebrarPorGeracao(e.target.checked)}
                  className="mt-0.5 rounded border-borda accent-[var(--acento)]"
                />
                <span>Começar cada geração numa página nova</span>
              </label>
            </fieldset>

            <p className="text-xs text-tinta3 m-0 leading-relaxed border-t border-borda pt-3">
              {isLoading
                ? 'Montando o documento…'
                : relatorio
                  ? `${relatorio.total} ${relatorio.total === 1 ? 'pessoa' : 'pessoas'} no documento` +
                    (relatorio.omitidas_vivas > 0
                      ? ` · ${relatorio.omitidas_vivas} viva(s) omitida(s)`
                      : '')
                  : ''}
            </p>
          </div>

          <footer className="p-4 border-t border-borda flex justify-end gap-3 flex-none">
            <Button variant="ghost" onClick={onFechar}>
              Fechar
            </Button>
            <Button onClick={() => window.print()} disabled={isLoading || !relatorio}>
              <Printer className="w-4 h-4 mr-1" />
              Imprimir ou salvar em PDF
            </Button>
          </footer>
        </div>
      </div>

      {/* Fica montado o tempo todo, invisível na tela e visível na impressão. */}
      {relatorio && (
        <RelatorioView
          relatorio={relatorio}
          grafo={grafo ?? null}
          opcoes={opcoes}
          titulo={titulo}
        />
      )}
    </>
  );
}
