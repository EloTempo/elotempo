import { useMemo, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import {
  ExternalLink,
} from 'lucide-react';
import { IconeArvore } from '../../../components/icons';
import { Modal } from '../../../components/ui/Modal';
import { Input } from '../../../components/ui/Input';
import { buscarGrafoArvore } from '../../../lib/api';
import type { PersonNode, TreeGraph } from '../../../types';

interface ModalAhnentafelProps {
  isOpen: boolean;
  onClose: () => void;
  raizId: string | null;
  onFocarPessoa?: (id: string) => void;
  onAbrirFicha?: (id: string) => void;
}

export interface ItemAhnentafel {
  numero: number;
  geracao: number;
  grauParentesco: string;
  pessoa: PersonNode;
}

const NUMEROS_ROMANOS = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'];

/**
 * Calcula o parentesco tradicional com base no número Ahnentafel (Sosa-Stradonitz).
 */
export function rotuloParentescoAhnentafel(n: number): string {
  if (n === 1) return 'Pessoa Foco (Raiz)';
  if (n === 2) return 'Pai';
  if (n === 3) return 'Mãe';
  if (n === 4) return 'Avô Paterno';
  if (n === 5) return 'Avó Paterna';
  if (n === 6) return 'Avô Materno';
  if (n === 7) return 'Avó Materna';
  if (n >= 8 && n <= 15) {
    return n % 2 === 0 ? 'Bisavô' : 'Bisavó';
  }
  if (n >= 16 && n <= 31) {
    return n % 2 === 0 ? 'Trisavô' : 'Trisavó';
  }
  if (n >= 32 && n <= 63) {
    return n % 2 === 0 ? 'Tetravô' : 'Tetravó';
  }
  return n % 2 === 0 ? 'Ascendente Masculino' : 'Ascendente Feminino';
}

/**
 * Monta a lista genealógica Ahnentafel a partir do grafo de ancestrais.
 */
export function montarAhnentafel(
  grafo: TreeGraph | null | undefined,
  raizId: string | null,
): ItemAhnentafel[] {
  if (!grafo || !raizId) return [];

  const pessoas = new Map(grafo.nodes.map((p) => [p.id, p]));
  const unioes = new Map(grafo.unions.map((u) => [u.id, u]));

  // Mapa de filho -> união dos pais
  const uniaoDosPais = new Map<string, string>();
  for (const l of grafo.links) {
    if (l.tipo === 'uniao_filho') {
      uniaoDosPais.set(l.target, l.source);
    }
  }

  const raiz = pessoas.get(raizId);
  if (!raiz) return [];

  const itens: ItemAhnentafel[] = [];
  const fila: Array<{ id: string; numero: number; geracao: number }> = [
    { id: raizId, numero: 1, geracao: 1 },
  ];

  while (fila.length > 0) {
    const { id, numero, geracao } = fila.shift()!;
    const p = pessoas.get(id);
    if (!p) continue;

    itens.push({
      numero,
      geracao,
      grauParentesco: rotuloParentescoAhnentafel(numero),
      pessoa: p,
    });

    const uid = uniaoDosPais.get(id);
    if (uid) {
      const u = unioes.get(uid);
      if (u) {
        if (u.slot_masculino_id && pessoas.has(u.slot_masculino_id)) {
          fila.push({
            id: u.slot_masculino_id,
            numero: numero * 2,
            geracao: geracao + 1,
          });
        }
        if (u.slot_feminino_id && pessoas.has(u.slot_feminino_id)) {
          fila.push({
            id: u.slot_feminino_id,
            numero: numero * 2 + 1,
            geracao: geracao + 1,
          });
        }
      }
    }
  }

  // Ordena por número Ahnentafel crescente
  itens.sort((a, b) => a.numero - b.numero);
  return itens;
}

export function ModalAhnentafel({
  isOpen,
  onClose,
  raizId,
  onFocarPessoa,
  onAbrirFicha,
}: ModalAhnentafelProps) {
  const [busca, setBusca] = useState('');

  // Busca até 8 gerações acima (ancestrais puros)
  const { data: grafo, isLoading } = useQuery({
    queryKey: ['ahnentafel-grafo', raizId],
    queryFn: () => (raizId ? buscarGrafoArvore(raizId, 8, 0) : null),
    enabled: isOpen && !!raizId,
  });

  const todosItens = useMemo(() => montarAhnentafel(grafo, raizId), [grafo, raizId]);

  const itensFiltrados = useMemo(() => {
    const termo = busca.trim().toLowerCase();
    if (!termo) return todosItens;
    return todosItens.filter((item) => {
      const nomeCompleto = [item.pessoa.nome, item.pessoa.sobrenome]
        .filter(Boolean)
        .join(' ')
        .toLowerCase();
      return (
        nomeCompleto.includes(termo) ||
        item.grauParentesco.toLowerCase().includes(termo) ||
        String(item.numero) === termo
      );
    });
  }, [todosItens, busca]);

  // Agrupa por geração
  const porGeracao = useMemo(() => {
    const mapa = new Map<number, ItemAhnentafel[]>();
    for (const item of itensFiltrados) {
      const lista = mapa.get(item.geracao) ?? [];
      lista.push(item);
      mapa.set(item.geracao, lista);
    }
    return Array.from(mapa.entries()).sort(([g1], [g2]) => g1 - g2);
  }, [itensFiltrados]);

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Tabela de Ancestrais (Ahnentafel / Sosa-Stradonitz)"
      className="max-w-3xl"
    >
      <div className="flex flex-col gap-4">
        <div className="flex items-start justify-between gap-4">
          <p className="text-xs text-tinta2 m-0 leading-relaxed flex-1">
            O sistema <strong>Ahnentafel</strong> é o padrão universal da genealogia para numeração matemática de ascendentes diretos:
            o pai é sempre o <em>dobro do número do filho (2n)</em> e a mãe é o <em>dobro mais um (2n + 1)</em>.
          </p>
          <div className="w-56 flex-none">
            <Input
              placeholder="Buscar por nome, grau ou nº..."
              value={busca}
              onChange={(e) => setBusca(e.target.value)}
            />
          </div>
        </div>

        {isLoading && (
          <p className="p-8 text-center text-xs text-tinta3">
            Calculando linhagem matemática de ancestrais...
          </p>
        )}

        {!isLoading && todosItens.length === 0 && (
          <p className="p-8 text-center text-xs text-tinta3">
            Nenhum ancestral cadastrado para a raiz selecionada.
          </p>
        )}

        <div className="flex flex-col gap-4 max-h-[60vh] overflow-y-auto pr-1">
          {porGeracao.map(([geracao, lista]) => {
            const rotuloRomano = NUMEROS_ROMANOS[geracao - 1] ?? String(geracao);
            return (
              <div key={geracao} className="flex flex-col gap-2">
                <div className="flex items-center gap-2 border-b border-borda/60 pb-1 pt-2">
                  <span className="px-2 py-0.5 text-[10px] font-bold rounded bg-acento/10 text-acento font-num">
                    Geração {rotuloRomano}
                  </span>
                  <span className="text-xs text-tinta3 font-medium">
                    {lista.length} {lista.length === 1 ? 'ancestral' : 'ancestrais'} nesta geração
                  </span>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
                  {lista.map((item) => {
                    const p = item.pessoa;
                    const nomeCompleto = [p.nome, p.sobrenome].filter(Boolean).join(' ');
                    const pontoSexoCor =
                      p.sexo === 'M'
                        ? 'bg-masc'
                        : p.sexo === 'F'
                        ? 'bg-fem'
                        : 'bg-tinta3';

                    return (
                      <div
                        key={item.numero}
                        className="p-2.5 rounded-raio-s border border-borda bg-card hover:border-borda2 transition-colors flex items-center justify-between gap-2 text-xs shadow-2xs"
                      >
                        <div className="flex items-center gap-2.5 min-w-0 flex-1">
                          <div className="flex-none w-7 h-7 rounded-full bg-sup border border-borda flex items-center justify-center font-num font-bold text-xs text-tinta text-center">
                            {item.numero}
                          </div>

                          <div className="flex flex-col min-w-0 flex-1">
                            <div className="flex items-center gap-1.5 truncate">
                              <span
                                className={`w-1.5 h-1.5 rounded-full flex-none ${pontoSexoCor}`}
                                title={`Sexo: ${p.sexo}`}
                              />
                              <span className="font-semibold text-tinta truncate">
                                {nomeCompleto}
                              </span>
                            </div>

                            <div className="flex items-center gap-2 text-[11px] text-tinta3 mt-0.5">
                              <span className="text-acento font-medium">
                                {item.grauParentesco}
                              </span>
                              {(p.ano_nascimento != null || p.ano_falecimento != null) && (
                                <span className="font-num">
                                  {p.ano_nascimento ? `✳ ${p.ano_nascimento}` : ''}
                                  {p.ano_nascimento && p.ano_falecimento ? ' · ' : ''}
                                  {p.ano_falecimento ? `† ${p.ano_falecimento}` : ''}
                                </span>
                              )}
                            </div>
                          </div>
                        </div>

                        {/* Botões de Ação */}
                        <div className="flex items-center gap-1 flex-none">
                          {onAbrirFicha && (
                            <button
                              type="button"
                              onClick={() => {
                                onAbrirFicha(p.id);
                              }}
                              className="p-1.5 text-tinta3 hover:text-tinta rounded hover:bg-sup cursor-pointer transition-colors"
                              title="Ver ficha completa"
                            >
                              <ExternalLink className="w-3.5 h-3.5" />
                            </button>
                          )}

                          {onFocarPessoa && (
                            <button
                              type="button"
                              onClick={() => {
                                onFocarPessoa(p.id);
                                onClose();
                              }}
                              className="p-1.5 text-tinta3 hover:text-acento rounded hover:bg-sup cursor-pointer transition-colors"
                              title="Focar e centralizar árvore nesta pessoa"
                            >
                              <IconeArvore className="w-3.5 h-3.5" />
                            </button>
                          )}
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </Modal>
  );
}
