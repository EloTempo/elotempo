/**
 * Painel de conexões da pessoa selecionada.
 *
 * É por aqui que a árvore deixa de ser uma lista de pessoas soltas. Três
 * gestos cobrem toda a construção de uma família:
 *
 *   - **Adicionar pais** — cria a união acima com dois desconhecidos, que se
 *     identificam depois, um de cada vez.
 *   - **Adicionar cônjuge** — abre uma união ao lado.
 *   - **Adicionar filho** — pendura na união; se ainda não houver uma, ela é
 *     criada com o outro lado em placeholder.
 *
 * Nenhuma regra de parentesco é decidida aqui: tudo passa pelos comandos do
 * Rust, e quando uma invariante barra a ação, a mensagem que aparece é a do
 * domínio (`ErroDominio`), não uma reescrita local que poderia divergir.
 */

import { useState } from 'react';
import { Baby, HeartHandshake, Pencil, Unlink, UserRoundPlus, X } from 'lucide-react';
import { Button } from '../../../components/ui/Button';
import { Input } from '../../../components/ui/Input';
import { Modal } from '../../../components/ui/Modal';
import { EscolherPessoa } from './EscolherPessoa';
import {
  useConexoes,
  useAdicionarPais,
  useAdicionarConjuge,
  useAdicionarFilho,
  useDesvincularFilho,
  useAtualizarUniao,
  usePromoverPlaceholder,
} from '../hooks/useConexoes';
import { ErroDoAcervo } from '../../../lib/api';
import { conjugeDe, type PersonSummary, type UnionStatus } from '../../../types';

interface PainelConexoesProps {
  pessoaId: string;
  onSelecionarPessoa: (id: string) => void;
  onFechar: () => void;
}

const ESTADOS: Array<{ id: UnionStatus; rotulo: string }> = [
  { id: 'casamento', rotulo: 'Casamento' },
  { id: 'estavel', rotulo: 'União estável' },
  { id: 'dissolvida', rotulo: 'Dissolvida' },
  { id: 'nao_informado', rotulo: 'Sem registro' },
];

function nomeDe(p: PersonSummary): string {
  if (p.is_placeholder) return p.sexo === 'F' ? 'Desconhecida' : 'Desconhecido';
  return [p.nome, p.sobrenome].filter(Boolean).join(' ');
}

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo || erro instanceof Error) return erro.message;
  return String(erro);
}

/** Botão que abre uma pessoa relacionada, com marca visual para placeholder. */
function Ficha({
  pessoa,
  papel,
  onAbrir,
}: {
  pessoa: PersonSummary;
  papel: string;
  onAbrir: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onAbrir}
      className={`w-full text-left px-3 py-2 rounded-raio-s border transition-colors hover:border-acento ${
        pessoa.is_placeholder
          ? 'border-dashed border-borda2 bg-card2/50'
          : 'border-borda bg-card'
      }`}
    >
      <span className="block font-num text-[10.5px] uppercase tracking-wider text-tinta3">
        {papel}
      </span>
      <span
        className={`block text-sm truncate ${
          pessoa.is_placeholder ? 'text-tinta2 italic' : 'text-tinta'
        }`}
      >
        {nomeDe(pessoa)}
      </span>
      {pessoa.is_placeholder && (
        <span className="block text-[11px] text-acento">clique para identificar</span>
      )}
    </button>
  );
}

export function PainelConexoes({ pessoaId, onSelecionarPessoa, onFechar }: PainelConexoesProps) {
  const { data: conexoes, isLoading, error } = useConexoes(pessoaId);

  const adicionarPais = useAdicionarPais();
  const adicionarConjuge = useAdicionarConjuge();
  const adicionarFilho = useAdicionarFilho();
  const desvincular = useDesvincularFilho();
  const atualizarUniao = useAtualizarUniao();
  const promover = usePromoverPlaceholder();

  // Qual diálogo está aberto: escolher cônjuge, escolher filho de qual união,
  // ou identificar um placeholder.
  const [dialogo, setDialogo] = useState<
    | { tipo: 'conjuge' }
    | { tipo: 'filho'; uniaoId: string | null }
    | { tipo: 'identificar'; pessoa: PersonSummary }
    | null
  >(null);

  const [nomeNovo, setNomeNovo] = useState('');
  const [sobrenomeNovo, setSobrenomeNovo] = useState('');

  if (isLoading) {
    return (
      <aside className="w-80 flex-none border-l border-borda bg-sup p-4">
        <p className="text-sm text-tinta3">Carregando conexões…</p>
      </aside>
    );
  }

  if (error || !conexoes) {
    return (
      <aside className="w-80 flex-none border-l border-borda bg-sup p-4">
        <p className="text-sm text-fem">{mensagemDeErro(error) ?? 'Erro ao ler as conexões.'}</p>
      </aside>
    );
  }

  const { pessoa, uniao_de_origem: origem, unioes } = conexoes;
  const erroAcao =
    mensagemDeErro(adicionarPais.error) ??
    mensagemDeErro(adicionarConjuge.error) ??
    mensagemDeErro(adicionarFilho.error) ??
    mensagemDeErro(desvincular.error) ??
    mensagemDeErro(promover.error);

  const abrirIdentificacao = (p: PersonSummary) => {
    setNomeNovo('');
    setSobrenomeNovo('');
    setDialogo({ tipo: 'identificar', pessoa: p });
  };

  const aoClicarEmRelacionado = (p: PersonSummary) => {
    if (p.is_placeholder) abrirIdentificacao(p);
    else onSelecionarPessoa(p.id);
  };

  return (
    <aside className="w-80 flex-none border-l border-borda bg-sup flex flex-col min-h-0">
      <header className="flex items-start gap-2 p-3 border-b border-borda flex-none">
        <div className="flex-1 min-w-0">
          <span className="block font-num text-[10.5px] uppercase tracking-wider text-tinta3">
            Conexões
          </span>
          <h2 className="font-tit font-bold text-base text-tinta m-0 truncate">
            {nomeDe(pessoa)}
          </h2>
        </div>
        <button
          type="button"
          onClick={onFechar}
          aria-label="Fechar painel"
          className="text-tinta3 hover:text-tinta p-1 rounded-raio-s hover:bg-card transition-colors"
        >
          <X className="w-4 h-4" />
        </button>
      </header>

      <div className="flex-1 overflow-y-auto min-h-0 p-3 flex flex-col gap-5">
        {erroAcao && (
          <div
            role="alert"
            className="bg-fem/10 text-fem p-3 rounded-raio-s text-xs border border-fem/20 leading-relaxed"
          >
            {erroAcao}
          </div>
        )}

        {pessoa.is_placeholder && (
          <Button size="sm" onClick={() => abrirIdentificacao(pessoa)}>
            <Pencil className="w-4 h-4 mr-1" />
            Identificar esta pessoa
          </Button>
        )}

        {/* ---------------- Pais ---------------- */}
        <section className="flex flex-col gap-2">
          <h3 className="font-num text-[10.5px] uppercase tracking-wider text-tinta3 m-0">
            Pais
          </h3>

          {origem ? (
            <div className="flex flex-col gap-2">
              <Ficha
                pessoa={origem.masculino}
                papel="pai"
                onAbrir={() => aoClicarEmRelacionado(origem.masculino)}
              />
              <Ficha
                pessoa={origem.feminino}
                papel="mãe"
                onAbrir={() => aoClicarEmRelacionado(origem.feminino)}
              />
              {origem.filhos.length > 1 && (
                <p className="text-[11px] text-tinta3 m-0">
                  {origem.filhos.length - 1}{' '}
                  {origem.filhos.length - 1 === 1 ? 'irmão' : 'irmãos'} nesta união
                </p>
              )}
              <button
                type="button"
                onClick={() => desvincular.mutate(pessoa.id)}
                disabled={desvincular.isPending}
                className="self-start text-[11px] text-tinta3 hover:text-fem transition-colors flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
              >
                <Unlink className="w-3 h-3" />
                Desvincular destes pais
              </button>
            </div>
          ) : (
            <>
              <p className="text-xs text-tinta3 m-0 leading-relaxed">
                Ninguém acima. Adicionar os pais cria um pai e uma mãe
                desconhecidos — você dá nome a eles quando descobrir, e os filhos
                continuam pendurados.
              </p>
              <Button
                size="sm"
                variant="secondary"
                onClick={() => adicionarPais.mutate(pessoa.id)}
                disabled={adicionarPais.isPending}
              >
                <UserRoundPlus className="w-4 h-4 mr-1" />
                {adicionarPais.isPending ? 'Criando…' : 'Adicionar pais'}
              </Button>
            </>
          )}
        </section>

        {/* ---------------- Uniões ---------------- */}
        <section className="flex flex-col gap-2">
          <h3 className="font-num text-[10.5px] uppercase tracking-wider text-tinta3 m-0">
            Uniões
          </h3>

          {unioes.length === 0 && (
            <p className="text-xs text-tinta3 m-0">Nenhuma união registrada.</p>
          )}

          {unioes.map((u) => {
            const conjuge = conjugeDe(u);
            return (
            <div key={u.id} className="flex flex-col gap-2 p-2.5 rounded-raio-s border border-borda bg-card">
              <Ficha
                pessoa={conjuge}
                papel={u.slot_da_pessoa === 'masculino' ? 'esposa' : 'marido'}
                onAbrir={() => aoClicarEmRelacionado(conjuge)}
              />

              <select
                aria-label="Estado do vínculo"
                value={u.estado_vinculo}
                onChange={(e) =>
                  atualizarUniao.mutate({ id: u.id, estado: e.target.value as UnionStatus })
                }
                className="text-xs px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta2 w-full"
              >
                {ESTADOS.map((e) => (
                  <option key={e.id} value={e.id}>
                    {e.rotulo}
                  </option>
                ))}
              </select>

              {u.filhos.length > 0 && (
                <ul className="list-none m-0 p-0 flex flex-col gap-1">
                  {u.filhos.map((f) => (
                    <li key={f.id}>
                      <button
                        type="button"
                        onClick={() => aoClicarEmRelacionado(f)}
                        className="w-full text-left text-xs text-tinta2 hover:text-tinta px-2 py-1 rounded-raio-s hover:bg-sup transition-colors flex items-center gap-1.5"
                      >
                        <Baby className="w-3 h-3 flex-none text-tinta3" />
                        <span className="truncate">{nomeDe(f)}</span>
                      </button>
                    </li>
                  ))}
                </ul>
              )}

              <Button
                size="sm"
                variant="ghost"
                onClick={() => setDialogo({ tipo: 'filho', uniaoId: u.id })}
              >
                <Baby className="w-4 h-4 mr-1" />
                Adicionar filho
              </Button>
            </div>
            );
          })}

          <Button size="sm" variant="secondary" onClick={() => setDialogo({ tipo: 'conjuge' })}>
            <HeartHandshake className="w-4 h-4 mr-1" />
            Adicionar cônjuge
          </Button>

          {unioes.length === 0 && (
            <Button
              size="sm"
              variant="ghost"
              onClick={() => setDialogo({ tipo: 'filho', uniaoId: null })}
            >
              <Baby className="w-4 h-4 mr-1" />
              Adicionar filho
            </Button>
          )}
        </section>
      </div>

      {/* ---------------- Diálogos ---------------- */}

      <Modal
        isOpen={dialogo?.tipo === 'conjuge' || dialogo?.tipo === 'filho'}
        onClose={() => setDialogo(null)}
        title={dialogo?.tipo === 'conjuge' ? 'Adicionar cônjuge' : 'Adicionar filho'}
        className="max-w-xl"
      >
        {(dialogo?.tipo === 'conjuge' || dialogo?.tipo === 'filho') && (
          <EscolherPessoa
            excluir={[pessoa.id]}
            rotuloConfirmar={dialogo.tipo === 'conjuge' ? 'Criar união' : 'Anexar como filho'}
            salvando={adicionarConjuge.isPending || adicionarFilho.isPending}
            erro={adicionarConjuge.error ?? adicionarFilho.error}
            onCancelar={() => setDialogo(null)}
            onEscolher={(escolhida) => {
              if (dialogo.tipo === 'conjuge') {
                adicionarConjuge.mutate(
                  { pessoa, conjuge: escolhida, estado: 'casamento' },
                  { onSuccess: () => setDialogo(null) },
                );
              } else {
                adicionarFilho.mutate(
                  {
                    uniaoId: dialogo.uniaoId,
                    pessoa,
                    filhoId: escolhida.id,
                    tipoVinculo: 'biologico',
                  },
                  { onSuccess: () => setDialogo(null) },
                );
              }
            }}
          />
        )}
      </Modal>

      <Modal
        isOpen={dialogo?.tipo === 'identificar'}
        onClose={() => setDialogo(null)}
        title="Identificar pessoa"
      >
        {dialogo?.tipo === 'identificar' && (
          <form
            className="flex flex-col gap-4"
            onSubmit={(e) => {
              e.preventDefault();
              if (!nomeNovo.trim()) return;
              promover.mutate(
                {
                  pessoaId: dialogo.pessoa.id,
                  nome: nomeNovo.trim(),
                  sobrenome: sobrenomeNovo.trim() || null,
                },
                { onSuccess: () => setDialogo(null) },
              );
            }}
          >
            <p className="text-sm text-tinta2 m-0 leading-relaxed">
              Este nó foi criado como desconhecido para segurar o lugar. Ao dar um nome,
              ele vira a pessoa real — e tudo que já está pendurado nele permanece.
            </p>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              <Input
                label="Nome *"
                value={nomeNovo}
                onChange={(e) => setNomeNovo(e.target.value)}
                autoFocus
              />
              <Input
                label="Sobrenome"
                value={sobrenomeNovo}
                onChange={(e) => setSobrenomeNovo(e.target.value)}
              />
            </div>

            <div className="flex justify-end gap-3 pt-3 border-t border-borda">
              <Button type="button" variant="ghost" onClick={() => setDialogo(null)}>
                Cancelar
              </Button>
              <Button type="submit" disabled={promover.isPending || !nomeNovo.trim()}>
                {promover.isPending ? 'Salvando…' : 'Identificar'}
              </Button>
            </div>
          </form>
        )}
      </Modal>
    </aside>
  );
}
