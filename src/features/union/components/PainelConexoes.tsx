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
import {
  Baby,
  HeartHandshake,
  Pencil,
  Trash2,
  Unlink,
  User,
  UserRoundPlus,
  X,
} from 'lucide-react';
import { IconeRelacoes } from '../../../components/icons';
import { Button, cn } from '../../../components/ui/Button';
import { Input } from '../../../components/ui/Input';
import { Modal } from '../../../components/ui/Modal';
import { EscolherPessoa } from './EscolherPessoa';
import { CasamentoDaUniao } from './CasamentoDaUniao';
import { PerfilResumoPessoa } from '../../person/components/PerfilResumoPessoa';
import { useI18n } from '../../../i18n/I18nContext';
import {
  useConexoes,
  useAdicionarPais,
  useAdicionarConjuge,
  useAdicionarFilho,
  useDesvincularFilho,
  useAtualizarUniao,
  usePromoverPlaceholder,
  useRemoverPessoa,
  useRemoverUniao,
} from '../hooks/useConexoes';
import { ErroDoAcervo } from '../../../lib/api';
import {
  sugerirSobrenomeDeFilho,
  sugerirSobrenomeDoPai,
  sugerirSobrenomeDaMae,
} from '../../../lib/nomes';
import { conjugeDe, type PersonSummary, type UnionStatus } from '../../../types';

interface PainelConexoesProps {
  pessoaId: string;
  onSelecionarPessoa: (id: string) => void;
  onFechar: () => void;
  /** Chamado depois que a pessoa é apagada, para a tela soltar a seleção. */
  onPessoaRemovida?: (id: string) => void;
  onAbrirEdicao?: (id: string) => void;
  onDefinirComoRaiz?: (id: string) => void;
  isRaizAtual?: boolean;
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

export function PainelConexoes({
  pessoaId,
  onSelecionarPessoa,
  onFechar,
  onPessoaRemovida,
  onAbrirEdicao,
  onDefinirComoRaiz,
  isRaizAtual,
}: PainelConexoesProps) {
  const { t } = useI18n();
  const { data: conexoes, isLoading, error } = useConexoes(pessoaId);
  const [aba, setAba] = useState<'perfil' | 'conexoes'>('perfil');

  const adicionarPais = useAdicionarPais();
  const adicionarConjuge = useAdicionarConjuge();
  const adicionarFilho = useAdicionarFilho();
  const desvincular = useDesvincularFilho();
  const atualizarUniao = useAtualizarUniao();
  const promover = usePromoverPlaceholder();
  const removerPessoa = useRemoverPessoa();
  const removerUniao = useRemoverUniao();

  // Qual diálogo está aberto. `sobrenomeSugerido` viaja junto porque depende
  // do parentesco em jogo, que só se conhece na hora de abrir.
  const [dialogo, setDialogo] = useState<
    | { tipo: 'conjuge' }
    | { tipo: 'filho'; uniaoId: string | null; sobrenomeSugerido: string; explicacao: string }
    | { tipo: 'identificar'; pessoa: PersonSummary; sobrenomeSugerido: string; explicacao: string }
    | { tipo: 'excluir-pessoa' }
    | { tipo: 'excluir-uniao'; uniaoId: string; comFilhos: number }
    | null
  >(null);

  const [nomeNovo, setNomeNovo] = useState('');
  const [sobrenomeNovo, setSobrenomeNovo] = useState('');

  if (isLoading) {
    return (
      <aside className="w-80 flex-none border-l border-borda bg-sup p-4">
        <p className="text-sm text-tinta3">{t('comum', 'carregando')}</p>
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
    mensagemDeErro(promover.error) ??
    mensagemDeErro(removerPessoa.error) ??
    mensagemDeErro(removerUniao.error);

  /**
   * Palpite de sobrenome ao identificar um placeholder.
   *
   * O caminho é o inverso do usual: em vez de deduzir o filho a partir dos
   * pais, deduz-se o pai a partir do filho. Pelo costume brasileiro o último
   * sobrenome do filho veio do pai e o primeiro veio da mãe.
   */
  const palpiteParaPlaceholder = (p: PersonSummary): { sobrenome: string; explicacao: string } => {
    // Placeholder que é pai/mãe da pessoa aberta: usa o sobrenome dela.
    const ehProgenitor =
      origem && (origem.masculino.id === p.id || origem.feminino.id === p.id);

    if (ehProgenitor) {
      const sobrenome =
        p.sexo === 'F'
          ? sugerirSobrenomeDaMae(pessoa.sobrenome)
          : sugerirSobrenomeDoPai(pessoa.sobrenome);
      return {
        sobrenome,
        explicacao: sobrenome
          ? `Sugerido a partir de ${nomeDe(pessoa)}: pelo costume brasileiro o ${
              p.sexo === 'F' ? 'primeiro' : 'último'
            } sobrenome vem d${p.sexo === 'F' ? 'a mãe' : 'o pai'}.`
          : '',
      };
    }

    // Placeholder que é cônjuge: os filhos da união é que dão a pista.
    const uniao = unioes.find((u) => u.masculino.id === p.id || u.feminino.id === p.id);
    const primeiroFilho = uniao?.filhos[0];
    if (primeiroFilho) {
      const sobrenome =
        p.sexo === 'F'
          ? sugerirSobrenomeDaMae(primeiroFilho.sobrenome)
          : sugerirSobrenomeDoPai(primeiroFilho.sobrenome);
      return {
        sobrenome,
        explicacao: sobrenome ? `Sugerido a partir de ${nomeDe(primeiroFilho)}.` : '',
      };
    }

    return { sobrenome: '', explicacao: '' };
  };

  const abrirIdentificacao = (p: PersonSummary) => {
    const palpite = palpiteParaPlaceholder(p);
    setNomeNovo('');
    setSobrenomeNovo(palpite.sobrenome);
    setDialogo({
      tipo: 'identificar',
      pessoa: p,
      sobrenomeSugerido: palpite.sobrenome,
      explicacao: palpite.explicacao,
    });
  };

  const aoClicarEmRelacionado = (p: PersonSummary) => {
    if (p.is_placeholder) abrirIdentificacao(p);
    else onSelecionarPessoa(p.id);
  };

  /** Palpite de sobrenome para um filho novo: materno + paterno. */
  const palpiteParaFilho = (uniaoId: string | null): { sobrenome: string; explicacao: string } => {
    const uniao = uniaoId ? unioes.find((u) => u.id === uniaoId) : undefined;

    if (uniao) {
      const sobrenome = sugerirSobrenomeDeFilho(
        uniao.masculino.sobrenome,
        uniao.feminino.sobrenome,
      );
      return {
        sobrenome,
        explicacao: sobrenome
          ? 'Composto a partir dos pais, na ordem brasileira: sobrenome da mãe, depois o do pai.'
          : '',
      };
    }

    // Sem união ainda: só se sabe o lado da pessoa aberta.
    const sobrenome =
      pessoa.sexo === 'F'
        ? sugerirSobrenomeDeFilho(null, pessoa.sobrenome)
        : sugerirSobrenomeDeFilho(pessoa.sobrenome, null);
    return {
      sobrenome,
      explicacao: sobrenome ? `Herdado de ${nomeDe(pessoa)}.` : '',
    };
  };

  return (
    <aside className="w-80 flex-none border-l border-borda bg-sup flex flex-col min-h-0">
      <header className="flex items-start gap-2 p-3 border-b border-borda flex-none bg-card">
        <div className="flex-1 min-w-0">
          <span className="block font-num text-[10px] uppercase tracking-wider text-tinta3 font-semibold">
            {aba === 'perfil' && !pessoa.is_placeholder ? t('conexoes', 'tituloInformacoes') : t('conexoes', 'tituloGerenciar')}
          </span>
          <h2 className="font-tit font-bold text-base text-tinta m-0 truncate" title={nomeDe(pessoa)}>
            {nomeDe(pessoa)}
          </h2>
        </div>
        {/* Exclusão fica no cabeçalho */}
        <button
          type="button"
          onClick={() => setDialogo({ tipo: 'excluir-pessoa' })}
          aria-label={t('conexoes', 'excluirPessoa')}
          title={t('conexoes', 'excluirPessoa')}
          className="text-tinta3 hover:text-fem p-1 rounded-raio-s hover:bg-sup transition-colors flex-none cursor-pointer"
        >
          <Trash2 className="w-4 h-4" />
        </button>
        <button
          type="button"
          onClick={onFechar}
          aria-label={t('comum', 'fechar')}
          className="text-tinta3 hover:text-tinta p-1 rounded-raio-s hover:bg-sup transition-colors flex-none cursor-pointer"
        >
          <X className="w-4 h-4" />
        </button>
      </header>

      {/* Abas de Navegação: Informações Salvas vs Conexões Familiares */}
      {!pessoa.is_placeholder && (
        <div className="flex border-b border-borda bg-card flex-none">
          <button
            type="button"
            onClick={() => setAba('perfil')}
            className={cn(
              "flex-1 py-2 text-xs font-semibold flex items-center justify-center gap-1.5 border-b-2 transition-colors cursor-pointer",
              aba === 'perfil'
                ? "border-acento text-tinta bg-sup/60 font-bold"
                : "border-transparent text-tinta3 hover:text-tinta hover:bg-sup/30"
            )}
          >
            <User className="w-3.5 h-3.5" />
            <span>{t('perfil', 'informacoes')}</span>
          </button>
          <button
            type="button"
            onClick={() => setAba('conexoes')}
            className={cn(
              "flex-1 py-2 text-xs font-semibold flex items-center justify-center gap-1.5 border-b-2 transition-colors cursor-pointer",
              aba === 'conexoes'
                ? "border-acento text-tinta bg-sup/60 font-bold"
                : "border-transparent text-tinta3 hover:text-tinta hover:bg-sup/30"
            )}
          >
            <IconeRelacoes className="w-3.5 h-3.5" />
            <span>{t('perfil', 'conexoes')}</span>
          </button>
        </div>
      )}

      {aba === 'perfil' && !pessoa.is_placeholder ? (
        <PerfilResumoPessoa
          pessoaId={pessoaId}
          conexoes={conexoes}
          onSelecionarPessoa={onSelecionarPessoa}
          onAbrirEdicao={onAbrirEdicao ?? onSelecionarPessoa}
          onAlternarParaConexoes={() => setAba('conexoes')}
          onDefinirComoRaiz={onDefinirComoRaiz}
          isRaizAtual={isRaizAtual}
        />
      ) : (
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
            {t('perfil', 'pais')}
          </h3>

          {origem ? (
            <div className="flex flex-col gap-2">
              <Ficha
                pessoa={origem.masculino}
                papel={t('perfil', 'pai')}
                onAbrir={() => aoClicarEmRelacionado(origem.masculino)}
              />
              <Ficha
                pessoa={origem.feminino}
                papel={t('perfil', 'mae')}
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
                {t('conexoes', 'desvincular')}
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
                {adicionarPais.isPending ? t('comum', 'carregando') : t('conexoes', 'adicionarPais')}
              </Button>
            </>
          )}
        </section>

        {/* ---------------- Uniões ---------------- */}
        <section className="flex flex-col gap-2">
          <h3 className="font-num text-[10.5px] uppercase tracking-wider text-tinta3 m-0">
            {t('perfil', 'conjuges')}
          </h3>

          {unioes.length === 0 && (
            <p className="text-xs text-tinta3 m-0">{t('conexoes', 'semConexoes')}</p>
          )}

          {unioes.map((u) => {
            const conjuge = conjugeDe(u);
            return (
            <div key={u.id} className="flex flex-col gap-2 p-2.5 rounded-raio-s border border-borda bg-card">
              <Ficha
                pessoa={conjuge}
                papel={u.slot_da_pessoa === 'masculino' ? t('perfil', 'esposa') : t('perfil', 'marido')}
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

              {/* Data e local do casamento — gravados na união, para valerem
                  na linha do tempo dos dois. */}
              <CasamentoDaUniao uniaoId={u.id} conjuge={nomeDe(conjuge)} />

              {u.filhos.length > 0 && (
                <ul className="list-none m-0 p-0 flex flex-col gap-1">
                  {u.filhos.map((f) => (
                    <li key={f.id}>
                      <button
                        type="button"
                        onClick={() => aoClicarEmRelacionado(f)}
                        className="w-full text-left px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-xs hover:border-acento transition-colors flex items-center justify-between group"
                      >
                        <span className="truncate">{nomeDe(f)}</span>
                        <span className="text-[10px] text-tinta3 group-hover:text-tinta">
                          {f.sexo === 'F' ? t('perfil', 'filha') : t('perfil', 'filho')}
                        </span>
                      </button>
                    </li>
                  ))}
                </ul>
              )}

              <Button
                size="sm"
                variant="ghost"
                onClick={() => {
                  const palpite = palpiteParaFilho(u.id);
                  setDialogo({
                    tipo: 'filho',
                    uniaoId: u.id,
                    sobrenomeSugerido: palpite.sobrenome,
                    explicacao: palpite.explicacao,
                  });
                }}
              >
                <Baby className="w-4 h-4 mr-1" />
                {t('conexoes', 'adicionarFilho')}
              </Button>

              <button
                type="button"
                onClick={() =>
                  setDialogo({ tipo: 'excluir-uniao', uniaoId: u.id, comFilhos: u.filhos.length })
                }
                className="self-start text-[11px] text-tinta3 hover:text-fem transition-colors flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
              >
                <Trash2 className="w-3 h-3" />
                {t('comum', 'excluir')}
              </button>
            </div>
            );
          })}

          <Button size="sm" variant="secondary" onClick={() => setDialogo({ tipo: 'conjuge' })}>
            <HeartHandshake className="w-4 h-4 mr-1" />
            {t('conexoes', 'adicionarConjuge')}
          </Button>

          {unioes.length === 0 && (
            <Button
              size="sm"
              variant="ghost"
              onClick={() => {
                const palpite = palpiteParaFilho(null);
                setDialogo({
                  tipo: 'filho',
                  uniaoId: null,
                  sobrenomeSugerido: palpite.sobrenome,
                  explicacao: palpite.explicacao,
                });
              }}
            >
              <Baby className="w-4 h-4 mr-1" />
              {t('conexoes', 'adicionarFilho')}
            </Button>
          )}
        </section>
      </div>
    )}

      {/* ---------------- Diálogos ---------------- */}

      <Modal
        isOpen={dialogo?.tipo === 'conjuge' || dialogo?.tipo === 'filho'}
        onClose={() => setDialogo(null)}
        title={dialogo?.tipo === 'conjuge' ? t('conexoes', 'adicionarConjuge') : t('conexoes', 'adicionarFilho')}
        className="max-w-xl"
      >
        {(dialogo?.tipo === 'conjuge' || dialogo?.tipo === 'filho') && (
          <EscolherPessoa
            excluir={[pessoa.id]}
            rotuloConfirmar={dialogo.tipo === 'conjuge' ? 'Criar união' : 'Anexar como filho'}
            sobrenomeSugerido={dialogo.tipo === 'filho' ? dialogo.sobrenomeSugerido : ''}
            explicacaoSugestao={dialogo.tipo === 'filho' ? dialogo.explicacao : undefined}
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

            {dialogo.explicacao && sobrenomeNovo === dialogo.sobrenomeSugerido && (
              <p className="text-xs text-tinta2 m-0 -mt-1 leading-relaxed">
                {dialogo.explicacao} Se não for o caso, é só escrever por cima.
              </p>
            )}

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

      {/* Exclusão de pessoa — confirmada, porque não há desfazer ainda. */}
      <Modal
        isOpen={dialogo?.tipo === 'excluir-pessoa'}
        onClose={() => setDialogo(null)}
        title="Excluir pessoa"
      >
        <div className="flex flex-col gap-4">
          <p className="text-sm text-tinta m-0 leading-relaxed">
            Excluir <strong>{nomeDe(pessoa)}</strong> do acervo? As datas, os atributos e os
            documentos ligados a ela vão junto.
          </p>

          {unioes.length > 0 && (
            <p className="text-sm text-tinta2 m-0 leading-relaxed bg-sup border border-borda rounded-raio-s p-3">
              Esta pessoa ocupa um slot em {unioes.length}{' '}
              {unioes.length === 1 ? 'união' : 'uniões'}. A união é sempre binária, então o
              programa vai recusar enquanto ela estiver ali — exclua a união primeiro.
            </p>
          )}

          <p className="text-xs text-tinta3 m-0">
            Não há como desfazer. Se a ideia é só tirá-la de um lugar errado, use
            “desvincular” em vez de excluir.
          </p>

          <div className="flex justify-end gap-3 pt-3 border-t border-borda">
            <Button type="button" variant="ghost" onClick={() => setDialogo(null)}>
              {t('comum', 'cancelar')}
            </Button>
            <Button
              type="button"
              className="bg-fem text-white hover:opacity-90"
              disabled={removerPessoa.isPending}
              onClick={() =>
                removerPessoa.mutate(pessoa.id, {
                  onSuccess: () => {
                    setDialogo(null);
                    onPessoaRemovida?.(pessoa.id);
                  },
                })
              }
            >
              {removerPessoa.isPending ? t('comum', 'carregando') : t('comum', 'excluir')}
            </Button>
          </div>
        </div>
      </Modal>

      {/* Exclusão de união */}
      <Modal
        isOpen={dialogo?.tipo === 'excluir-uniao'}
        onClose={() => setDialogo(null)}
        title="Excluir união"
      >
        {dialogo?.tipo === 'excluir-uniao' && (
          <div className="flex flex-col gap-4">
            <p className="text-sm text-tinta m-0 leading-relaxed">
              Desfazer esta união? As pessoas continuam no acervo — o que se apaga é a ligação
              entre elas.
            </p>

            {dialogo.comFilhos > 0 && (
              <p className="text-sm text-tinta2 m-0 leading-relaxed bg-sup border border-borda rounded-raio-s p-3">
                {dialogo.comFilhos} {dialogo.comFilhos === 1 ? 'filho fica' : 'filhos ficam'} sem
                pais registrados. {dialogo.comFilhos === 1 ? 'Ele continua' : 'Eles continuam'} no
                acervo, mas solt{dialogo.comFilhos === 1 ? 'o' : 'os'} na árvore até você
                {dialogo.comFilhos === 1 ? ' religá-lo' : ' religá-los'}.
              </p>
            )}

            <p className="text-xs text-tinta3 m-0">
              Pais “desconhecidos” que existirem só por causa desta união são removidos junto —
              eles seguravam o slot e não têm mais função.
            </p>

            <div className="flex justify-end gap-3 pt-3 border-t border-borda">
              <Button type="button" variant="ghost" onClick={() => setDialogo(null)}>
                Cancelar
              </Button>
              <Button
                type="button"
                className="bg-fem text-white hover:opacity-90"
                disabled={removerUniao.isPending}
                onClick={() =>
                  removerUniao.mutate(dialogo.uniaoId, { onSuccess: () => setDialogo(null) })
                }
              >
                {removerUniao.isPending ? 'Excluindo…' : 'Excluir união'}
              </Button>
            </div>
          </div>
        )}
      </Modal>
    </aside>
  );
}
