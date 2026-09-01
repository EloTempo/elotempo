/**
 * Assistente de importação GEDCOM (fatia 09).
 *
 * Substitui o protótipo `GedcomImportWizard`, que desenhou este fluxo com dados
 * fixos. As quatro etapas dele continuam: arquivo, leitura, conflitos, aplicar.
 *
 * A política de conflito é a decidida em 30/08/2026: **perguntar caso a caso**,
 * com nome e contexto, em vez de decidir sozinho ou entregar um relatório para
 * conferir depois. É mais trabalho e é o certo — nada se perde em silêncio, e a
 * decisão é tomada olhando os nomes, não um log.
 */

import { useState } from 'react';
import { useQueryClient } from '@tanstack/react-query';
import { AlertTriangle, Check, FileUp, FolderOpen, Info } from 'lucide-react';
import { Button } from '../../../components/ui/Button';
import {
  analisarGedcom,
  escolherGedcom,
  importarGedcom,
  ErroDoAcervo,
  type AnalisePrevia,
  type ResumoImportacao,
} from '../../../lib/api';

interface DialogoImportarProps {
  onFechar: () => void;
  /** Chamado depois de aplicar, para a tela recarregar a árvore. */
  onImportado: () => void;
}

type Etapa = 'arquivo' | 'leitura' | 'conflitos' | 'pronto';

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo || erro instanceof Error) return erro.message;
  return String(erro);
}

const PASSOS: Array<{ id: Etapa; rotulo: string }> = [
  { id: 'arquivo', rotulo: 'Arquivo' },
  { id: 'leitura', rotulo: 'Leitura' },
  { id: 'conflitos', rotulo: 'Conflitos' },
  { id: 'pronto', rotulo: 'Aplicar' },
];

export function DialogoImportar({ onFechar, onImportado }: DialogoImportarProps) {
  const qc = useQueryClient();
  const [etapa, setEtapa] = useState<Etapa>('arquivo');
  const [caminho, setCaminho] = useState<string | null>(null);
  const [analise, setAnalise] = useState<AnalisePrevia | null>(null);
  const [decisoes, setDecisoes] = useState<Record<string, string>>({});
  const [indice, setIndice] = useState(0);
  const [resumo, setResumo] = useState<ResumoImportacao | null>(null);
  const [ocupado, setOcupado] = useState(false);
  const [erro, setErro] = useState<string | null>(null);

  const escolher = async () => {
    setErro(null);
    try {
      const escolhido = await escolherGedcom();
      if (!escolhido) return; // cancelou, o que é normal

      setOcupado(true);
      setCaminho(escolhido);
      const a = await analisarGedcom(escolhido);
      setAnalise(a);
      // A resposta começa no padrão de cada conflito: o assistente sugere, e a
      // pessoa muda o que quiser. Sugerir não é decidir por ela.
      setDecisoes(Object.fromEntries(a.conflitos.map((c) => [c.id, c.padrao])));
      setIndice(0);
      setEtapa('leitura');
    } catch (e) {
      setErro(mensagemDeErro(e));
      setCaminho(null);
    } finally {
      setOcupado(false);
    }
  };

  const aplicar = async () => {
    if (!caminho) return;
    setErro(null);
    setOcupado(true);
    try {
      const r = await importarGedcom(caminho, decisoes);
      setResumo(r);
      setEtapa('pronto');
      // O acervo mudou inteiro: árvore, busca, linhas do tempo.
      qc.invalidateQueries();
      onImportado();
    } catch (e) {
      setErro(mensagemDeErro(e));
    } finally {
      setOcupado(false);
    }
  };

  const conflitos = analise?.conflitos ?? [];
  const atual = conflitos[indice];
  const etapaAtiva = PASSOS.findIndex((p) => p.id === etapa);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm print:hidden">
      <div className="absolute inset-0" onClick={onFechar} aria-hidden />

      <div className="relative w-full max-w-2xl bg-card rounded-raio border border-borda shadow-sombra overflow-hidden flex flex-col max-h-[88vh]">
        <header className="p-4 border-b border-borda bg-card2 flex items-start gap-3 flex-none">
          <FileUp className="w-5 h-5 text-acento flex-none mt-0.5" />
          <div className="min-w-0">
            <h2 className="font-tit font-bold text-lg m-0">Importar GEDCOM</h2>
            <p className="text-xs text-tinta2 m-0 mt-0.5 leading-relaxed">
              Traz uma árvore feita em outro programa. Aceita GEDCOM 5.5.1 e 7.0.
            </p>
          </div>
        </header>

        {/* Trilha das quatro etapas */}
        <div className="px-4 py-2.5 border-b border-borda flex items-center gap-2 text-[11.5px] flex-none overflow-x-auto">
          {PASSOS.map((p, i) => (
            <div key={p.id} className="flex items-center gap-2 flex-none">
              {i > 0 && <span className="w-5 h-px bg-borda" />}
              <span
                className={`w-5 h-5 rounded-full grid place-items-center font-num text-[10px] ${
                  i < etapaAtiva
                    ? 'bg-acento text-acento-tinta'
                    : i === etapaAtiva
                      ? 'border-2 border-acento text-acento'
                      : 'border border-borda2 text-tinta3'
                }`}
              >
                {i < etapaAtiva ? '✓' : i + 1}
              </span>
              <span className={i === etapaAtiva ? 'text-tinta font-semibold' : 'text-tinta3'}>
                {p.rotulo}
              </span>
            </div>
          ))}
        </div>

        <div className="flex-1 overflow-y-auto min-h-0 p-4 flex flex-col gap-4">
          {erro && (
            <p
              role="alert"
              className="text-sm text-fem m-0 bg-fem/10 border border-fem/20 rounded-raio-s p-3"
            >
              {erro}
            </p>
          )}

          {/* ---------------- Escolher o arquivo ---------------- */}
          {etapa === 'arquivo' && (
            <div className="flex flex-col gap-3 items-start">
              <p className="text-sm text-tinta2 m-0 leading-relaxed">
                Escolha o arquivo <code className="font-num text-xs">.ged</code> ou o pacote{' '}
                <code className="font-num text-xs">.gdz</code>. Nada é gravado até você conferir o
                que vem — a leitura é só leitura.
              </p>
              <Button onClick={escolher} disabled={ocupado}>
                <FolderOpen className="w-4 h-4 mr-1" />
                {ocupado ? 'Lendo…' : 'Escolher arquivo'}
              </Button>
            </div>
          )}

          {/* ---------------- O que o arquivo tem ---------------- */}
          {etapa === 'leitura' && analise && (
            <div className="flex flex-col gap-3">
              <ul className="list-none m-0 p-0 text-sm text-tinta2 flex flex-col gap-1">
                <li>
                  <span className="font-num text-tinta">{analise.pessoas}</span>{' '}
                  {analise.pessoas === 1 ? 'pessoa' : 'pessoas'} ·{' '}
                  <span className="font-num text-tinta">{analise.unioes}</span>{' '}
                  {analise.unioes === 1 ? 'união' : 'uniões'}
                </li>
                <li className="text-xs text-tinta3">
                  GEDCOM {analise.versao} · codificação {analise.codificacao}
                </li>
              </ul>

              {analise.avisos.map((a, i) => (
                <p key={i} className="text-xs text-tinta2 m-0 flex items-start gap-1.5">
                  <Info className="w-3.5 h-3.5 flex-none mt-0.5 text-tinta3" />
                  {a}
                </p>
              ))}

              {conflitos.length === 0 ? (
                <p className="text-sm text-tinta2 m-0 leading-relaxed border-t border-borda pt-3">
                  Nada a decidir: o arquivo cabe inteiro nas regras do acervo.
                </p>
              ) : (
                <p className="text-sm text-tinta m-0 leading-relaxed border-t border-borda pt-3 flex items-start gap-2">
                  <AlertTriangle className="w-4 h-4 flex-none mt-0.5 text-acento" />
                  <span>
                    <strong className="font-num">{conflitos.length}</strong>{' '}
                    {conflitos.length === 1 ? 'ponto precisa' : 'pontos precisam'} da sua decisão. O
                    GEDCOM permite coisas que este acervo não permite — e as regras de conexão não
                    se afrouxam para caber um arquivo.
                  </span>
                </p>
              )}
            </div>
          )}

          {/* ---------------- Conflito a conflito ---------------- */}
          {etapa === 'conflitos' && atual && (
            <div className="flex flex-col gap-3">
              <span className="font-num text-[10.5px] px-2.5 py-1 rounded-full bg-chip text-tinta2 self-start">
                {indice + 1} / {conflitos.length}
              </span>

              <div>
                <h3 className="font-tit font-bold text-base m-0">{atual.titulo}</h3>
                <p className="text-xs text-tinta2 m-0 mt-1 leading-relaxed">{atual.explicacao}</p>
              </div>

              <div className="flex flex-col gap-1.5">
                {atual.opcoes.map((o) => (
                  <label
                    key={o.valor}
                    className={`flex items-start gap-2 text-sm p-2.5 rounded-raio-s border cursor-pointer transition-colors ${
                      decisoes[atual.id] === o.valor
                        ? 'border-acento bg-card2 text-tinta'
                        : 'border-borda text-tinta2 hover:border-borda2'
                    }`}
                  >
                    <input
                      type="radio"
                      name={atual.id}
                      checked={decisoes[atual.id] === o.valor}
                      onChange={() => setDecisoes((d) => ({ ...d, [atual.id]: o.valor }))}
                      className="mt-0.5 accent-[var(--acento)]"
                    />
                    <span>{o.rotulo}</span>
                  </label>
                ))}
              </div>
            </div>
          )}

          {/* ---------------- O que entrou ---------------- */}
          {etapa === 'pronto' && resumo && (
            <div className="flex flex-col gap-3">
              <div className="flex items-start gap-2 p-3 rounded-raio-s border border-acento bg-card2">
                <Check className="w-4 h-4 text-acento flex-none mt-0.5" />
                <p className="text-sm text-tinta m-0 font-semibold">Importação concluída</p>
              </div>

              <ul className="list-none m-0 p-0 text-sm text-tinta2 flex flex-col gap-1">
                <li>
                  {resumo.pessoas} {resumo.pessoas === 1 ? 'pessoa' : 'pessoas'} · {resumo.unioes}{' '}
                  {resumo.unioes === 1 ? 'união' : 'uniões'} · {resumo.filhos}{' '}
                  {resumo.filhos === 1 ? 'filiação' : 'filiações'}
                </li>
                {resumo.placeholders > 0 && (
                  <li>
                    {resumo.placeholders}{' '}
                    {resumo.placeholders === 1 ? 'lado desconhecido criado' : 'lados desconhecidos criados'}{' '}
                    — slot de união nunca fica vazio
                  </li>
                )}
                <li className="text-xs text-tinta3">
                  {resumo.eventos} eventos · {resumo.nomes} nomes · {resumo.atributos} atributos
                </li>
              </ul>

              {resumo.descartados.length > 0 && (
                <div className="border-t border-borda pt-3 flex flex-col gap-1.5">
                  <p className="font-num text-[10.5px] uppercase tracking-wider text-tinta3 m-0">
                    O que não coube
                  </p>
                  {resumo.descartados.map((d, i) => (
                    <p key={i} className="text-xs text-tinta2 m-0 leading-relaxed">
                      {d}
                    </p>
                  ))}
                </div>
              )}
            </div>
          )}
        </div>

        <footer className="p-4 border-t border-borda flex justify-between gap-3 flex-none">
          <Button variant="ghost" onClick={onFechar}>
            {etapa === 'pronto' ? 'Fechar' : 'Cancelar'}
          </Button>

          <div className="flex gap-2">
            {etapa === 'conflitos' && indice > 0 && (
              <Button variant="secondary" onClick={() => setIndice((i) => i - 1)}>
                Anterior
              </Button>
            )}

            {/* Sem conflito não há o que perguntar: a etapa some, em vez de
                virar uma tela vazia com um botão. */}
            {etapa === 'leitura' && conflitos.length > 0 && (
              <Button onClick={() => setEtapa('conflitos')}>Resolver conflitos</Button>
            )}

            {etapa === 'leitura' && conflitos.length === 0 && (
              <Button onClick={aplicar} disabled={ocupado}>
                {ocupado ? 'Importando…' : 'Importar'}
              </Button>
            )}

            {etapa === 'conflitos' && indice < conflitos.length - 1 && (
              <Button onClick={() => setIndice((i) => i + 1)}>Próximo</Button>
            )}

            {etapa === 'conflitos' && indice >= conflitos.length - 1 && (
              <Button onClick={aplicar} disabled={ocupado}>
                {ocupado ? 'Importando…' : 'Importar'}
              </Button>
            )}
          </div>
        </footer>
      </div>
    </div>
  );
}
