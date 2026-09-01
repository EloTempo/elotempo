/**
 * Casca do aplicativo.
 *
 * Antes esta tela renderizava um `mockTree` fixo com Machado de Assis e não
 * tocava no banco. Agora lê o acervo de verdade: escolhe uma raiz, monta o
 * grafo pelo Rust e desenha com o layout vertical.
 *
 * O que ainda não está ligado (editor de união, detalhes, relatórios, linhas
 * do tempo) segue como protótipo visual em `src/features/` — ver CLAUDE.md.
 */

import { useEffect, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { FileDown, FileText, FileUp, Plus, TreeDeciduous } from 'lucide-react';
import { Button } from './components/ui/Button';
import { Modal } from './components/ui/Modal';
import { TreeCanvas } from './components/tree/TreeCanvas';
import { PersonForm } from './features/person/components/PersonForm';
import { PersonDetails } from './features/person/components/PersonDetails';
import { PainelConexoes } from './features/union/components/PainelConexoes';
import { PainelBusca } from './features/search/components/PainelBusca';
import { DialogoRelatorio } from './features/reports/components/DialogoRelatorio';
import { DialogoExportar } from './features/export/components/DialogoExportar';
import { DialogoImportar } from './features/import/components/DialogoImportar';
import { GavetaLinhaTempo } from './features/timeline/components/GavetaLinhaTempo';
import { useCriarPessoa, usePessoas } from './features/person/hooks/usePessoas';
import { buscarGrafoArvore } from './lib/api';

type Tema = 'classico-claro' | 'classico-escuro' | 'moderno-claro' | 'moderno-escuro';

const TEMAS: Array<{ id: Tema; rotulo: string }> = [
  { id: 'classico-claro', rotulo: 'Clássico claro' },
  { id: 'classico-escuro', rotulo: 'Clássico escuro' },
  { id: 'moderno-claro', rotulo: 'Moderno claro' },
  { id: 'moderno-escuro', rotulo: 'Moderno escuro' },
];

/** Lê o tema salvo. Falha em silêncio: tema é conforto, não dado do acervo. */
function temaInicial(): Tema {
  try {
    const salvo = localStorage.getItem('tema');
    if (salvo && TEMAS.some((t) => t.id === salvo)) return salvo as Tema;
  } catch {
    /* modo privado ou storage bloqueado */
  }
  return 'classico-claro';
}

export default function App() {
  const [tema, setTema] = useState<Tema>(temaInicial);
  // Consulta sem filtro, só para decidir a raiz inicial e detectar acervo
  // vazio. A busca de verdade mora no PainelBusca, com estado próprio.
  const termoBusca = '';
  const [raizId, setRaizId] = useState<string | null>(null);
  const [selecionadaId, setSelecionadaId] = useState<string | null>(null);
  const [formAberto, setFormAberto] = useState(false);
  const [fichaAberta, setFichaAberta] = useState<string | null>(null);
  const [relatorioAberto, setRelatorioAberto] = useState(false);
  const [exportarAberto, setExportarAberto] = useState(false);
  const [importarAberto, setImportarAberto] = useState(false);
  // Vem da linha do tempo: quem estava vivo no marco clicado. `null` = sem
  // destaque ativo, que é diferente de lista vazia.
  const [destacadosIds, setDestacadosIds] = useState<string[] | null>(null);

  const { data: pessoas, isLoading: carregandoPessoas, error: erroPessoas } = usePessoas(termoBusca);
  const criar = useCriarPessoa();

  // O tema tem de ir no <html>: as variáveis de cor são declaradas em
  // `:root[data-tema="…"]` (globals.css). Posto numa div, o seletor nunca
  // casava e o seletor de temas não mudava nada — os quatro temas existiam no
  // CSS mas só o clássico claro chegava à tela.
  useEffect(() => {
    document.documentElement.dataset.tema = tema;
    try {
      localStorage.setItem('tema', tema);
    } catch {
      /* sem persistência é aceitável; o tema volta ao padrão na próxima abertura */
    }
  }, [tema]);

  // Sem raiz escolhida, adota a primeira pessoa do acervo — assim o programa
  // abre mostrando alguma coisa em vez de uma tela vazia.
  useEffect(() => {
    if (!raizId && pessoas && pessoas.length > 0) {
      setRaizId(pessoas[0].id);
    }
  }, [pessoas, raizId]);

  const {
    data: grafo,
    isLoading: carregandoArvore,
    error: erroArvore,
  } = useQuery({
    queryKey: ['arvore', raizId],
    queryFn: () => buscarGrafoArvore(raizId!),
    enabled: !!raizId,
  });

  // Só é "vazio" quando a consulta deu certo e não achou ninguém. Sem o teste
  // de erro, uma falha ao ler o acervo apareceria como a tela de boas-vindas —
  // e o usuário concluiria que perdeu os dados.
  const acervoVazio =
    !carregandoPessoas && !erroPessoas && (pessoas?.length ?? 0) === 0 && !termoBusca;

  return (
    <div className="h-screen flex flex-col bg-mesa text-tinta font-corpo">
      {/* Barra superior */}
      <header className="flex items-center gap-3 px-4 py-2.5 bg-sup border-b border-borda flex-none">
        <TreeDeciduous className="w-5 h-5 text-acento flex-none" />
        <h1 className="font-tit font-bold text-base tracking-tit m-0 flex-none">
          Árvore Genealógica
        </h1>

        <div className="flex-1" />

        <select
          aria-label="Tema visual"
          value={tema}
          onChange={(e) => setTema(e.target.value as Tema)}
          className="text-xs px-2 py-1.5 rounded-raio-s border border-borda2 bg-card text-tinta2"
        >
          {TEMAS.map((t) => (
            <option key={t.id} value={t.id}>
              {t.rotulo}
            </option>
          ))}
        </select>

        <Button size="sm" variant="secondary" onClick={() => setRelatorioAberto(true)}>
          <FileText className="w-4 h-4 mr-1" />
          Relatório
        </Button>

        <Button size="sm" variant="secondary" onClick={() => setImportarAberto(true)}>
          <FileUp className="w-4 h-4 mr-1" />
          Importar
        </Button>

        <Button size="sm" variant="secondary" onClick={() => setExportarAberto(true)}>
          <FileDown className="w-4 h-4 mr-1" />
          Exportar
        </Button>

        <Button size="sm" onClick={() => setFormAberto(true)}>
          <Plus className="w-4 h-4 mr-1" />
          Nova pessoa
        </Button>
      </header>

      <div className="flex flex-1 min-h-0">
        {/* Busca multicritério: escolher aqui centraliza a pessoa na árvore. */}
        <aside className="w-72 flex-none border-r border-borda bg-sup flex flex-col min-h-0">
          <PainelBusca
            selecionadaId={raizId}
            onEscolher={(id) => {
              setRaizId(id);
              setSelecionadaId(id);
            }}
          />
        </aside>

        {/* Palco da árvore */}
        <main className="flex-1 min-w-0 relative">
          {acervoVazio && (
            <div className="absolute inset-0 grid place-items-center p-8 text-center">
              <div className="max-w-md flex flex-col gap-3 items-center">
                <TreeDeciduous className="w-10 h-10 text-tinta3" />
                <h2 className="font-tit font-bold text-xl m-0">Comece pela pessoa mais nova</h2>
                <p className="text-sm text-tinta2 m-0 leading-relaxed">
                  Cadastre você mesmo, ou o parente mais recente que conhecer, e vá subindo. Se
                  não souber o nome de um dos pais, o programa cria um nó “desconhecido” no
                  lugar — e você troca pelo nome real quando descobrir, sem perder os filhos já
                  pendurados nele.
                </p>
                <Button onClick={() => setFormAberto(true)}>
                  <Plus className="w-4 h-4 mr-1" />
                  Cadastrar a primeira pessoa
                </Button>
              </div>
            </div>
          )}

          {!acervoVazio && carregandoArvore && (
            <div className="absolute inset-0 grid place-items-center">
              <span className="font-num text-sm text-tinta3">Montando a árvore…</span>
            </div>
          )}

          {!acervoVazio && erroArvore && (
            <div className="absolute inset-0 grid place-items-center p-8">
              <p className="text-sm text-fem text-center max-w-sm">
                {erroArvore instanceof Error
                  ? erroArvore.message
                  : 'Não foi possível montar a árvore.'}
              </p>
            </div>
          )}

          {!acervoVazio && grafo && !carregandoArvore && (
            <TreeCanvas
              grafo={grafo}
              pessoaSelecionadaId={selecionadaId}
              destacadosIds={destacadosIds}
              onSelecionarPessoa={setSelecionadaId}
              onAbrirDetalhes={setFichaAberta}
            />
          )}
        </main>

        {/* Painel de conexões da pessoa selecionada */}
        {selecionadaId && !acervoVazio && (
          <PainelConexoes
            key={selecionadaId}
            pessoaId={selecionadaId}
            onSelecionarPessoa={setSelecionadaId}
            onFechar={() => setSelecionadaId(null)}
            onPessoaRemovida={(id) => {
              setSelecionadaId(null);
              // Se a raiz foi apagada, solta a referência: o efeito acima
              // escolhe outra pessoa e a árvore se remonta sozinha.
              if (raizId === id) setRaizId(null);
            }}
          />
        )}
      </div>

      {/* A gaveta divide a tela com a árvore — split, não overlay (seção 8). */}
      {!acervoVazio && (
        <GavetaLinhaTempo
          pessoaSelecionadaId={selecionadaId}
          onDestacar={setDestacadosIds}
        />
      )}

      {importarAberto && (
        <DialogoImportar
          onFechar={() => setImportarAberto(false)}
          onImportado={() => {
            // A raiz pode ter deixado de fazer sentido: soltando-a, o efeito
            // que escolhe a primeira pessoa remonta a árvore sozinho.
            setSelecionadaId(null);
            setRaizId(null);
          }}
        />
      )}

      {exportarAberto && (
        <DialogoExportar raizId={raizId} onFechar={() => setExportarAberto(false)} />
      )}

      {relatorioAberto && (
        <DialogoRelatorio raizId={raizId} onFechar={() => setRelatorioAberto(false)} />
      )}

      {/* Ficha completa — o que o botão "Detalhes" do card abre. */}
      {fichaAberta && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm">
          <div
            className="absolute inset-0"
            onClick={() => setFichaAberta(null)}
            aria-hidden
          />
          <div className="relative w-full max-w-4xl bg-card rounded-raio border border-borda shadow-sombra overflow-hidden">
            <PersonDetails pessoaId={fichaAberta} onFechar={() => setFichaAberta(null)} />
          </div>
        </div>
      )}

      <Modal
        isOpen={formAberto}
        onClose={() => setFormAberto(false)}
        title="Cadastrar pessoa"
        className="max-w-2xl"
      >
        <PersonForm
          salvando={criar.isPending}
          erro={criar.error}
          onCancelar={() => setFormAberto(false)}
          onSalvar={(dados) =>
            criar.mutate(dados, {
              onSuccess: (id) => {
                setFormAberto(false);
                setSelecionadaId(id);
                if (!raizId) setRaizId(id);
              },
            })
          }
        />
      </Modal>
    </div>
  );
}
