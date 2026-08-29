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
import { Plus, Search, TreeDeciduous } from 'lucide-react';
import { Button } from './components/ui/Button';
import { Input } from './components/ui/Input';
import { Modal } from './components/ui/Modal';
import { TreeCanvas } from './components/tree/TreeCanvas';
import { PersonForm } from './features/person/components/PersonForm';
import { PainelConexoes } from './features/union/components/PainelConexoes';
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
  const [termoBusca, setTermoBusca] = useState('');
  const [raizId, setRaizId] = useState<string | null>(null);
  const [selecionadaId, setSelecionadaId] = useState<string | null>(null);
  const [formAberto, setFormAberto] = useState(false);

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

        <Button size="sm" onClick={() => setFormAberto(true)}>
          <Plus className="w-4 h-4 mr-1" />
          Nova pessoa
        </Button>
      </header>

      <div className="flex flex-1 min-h-0">
        {/* Painel lateral: busca e escolha da raiz */}
        <aside className="w-72 flex-none border-r border-borda bg-sup flex flex-col min-h-0">
          <div className="p-3 border-b border-borda">
            <div className="relative">
              <Search className="w-4 h-4 absolute left-2.5 top-1/2 -translate-y-1/2 text-tinta3 pointer-events-none" />
              <Input
                aria-label="Buscar pessoa"
                placeholder="Buscar por nome ou sobrenome"
                value={termoBusca}
                onChange={(e) => setTermoBusca(e.target.value)}
                className="pl-8"
              />
            </div>
          </div>

          <div className="flex-1 overflow-y-auto min-h-0">
            {carregandoPessoas && (
              <p className="p-3 text-sm text-tinta3">Lendo o acervo…</p>
            )}

            {erroPessoas && (
              <div role="alert" className="m-3 p-3 rounded-raio-s bg-fem/10 border border-fem/20">
                <p className="text-sm text-fem m-0 font-semibold">Não foi possível ler o acervo</p>
                <p className="text-xs text-tinta2 mt-1 mb-0 leading-relaxed">
                  {erroPessoas instanceof Error ? erroPessoas.message : String(erroPessoas)}
                </p>
              </div>
            )}

            {!carregandoPessoas && !erroPessoas && pessoas?.length === 0 && (
              <p className="p-3 text-sm text-tinta3">
                {termoBusca ? 'Ninguém com esse nome.' : 'O acervo está vazio.'}
              </p>
            )}

            <ul className="list-none m-0 p-0">
              {pessoas?.map((p) => (
                <li key={p.id}>
                  <button
                    type="button"
                    onClick={() => {
                      setRaizId(p.id);
                      setSelecionadaId(p.id);
                    }}
                    className={`w-full text-left px-3 py-2 border-b border-borda/60 hover:bg-card transition-colors ${
                      raizId === p.id ? 'bg-card border-l-2 border-l-acento' : ''
                    }`}
                  >
                    <span className="block text-sm text-tinta truncate">
                      {[p.nome, p.sobrenome].filter(Boolean).join(' ')}
                      {p.is_placeholder && (
                        <span className="text-tinta3 italic"> · placeholder</span>
                      )}
                    </span>
                    <span className="block font-num text-[11px] text-tinta3">
                      {p.ano_nascimento ? `n. ${p.ano_nascimento}` : 'sem data'}
                      {p.ano_falecimento ? ` · † ${p.ano_falecimento}` : ''}
                    </span>
                  </button>
                </li>
              ))}
            </ul>
          </div>
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
              onSelecionarPessoa={setSelecionadaId}
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
