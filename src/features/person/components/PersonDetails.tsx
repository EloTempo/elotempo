/**
 * Ficha da pessoa — o registro completo (seção 10).
 *
 * Era o protótipo com "José Silva" fixo; agora lê e escreve no acervo. É aqui
 * que os atributos de vida da seção 2.5 finalmente ganham tela: eles existiam
 * no schema e nos comandos desde o começo, sem nenhuma forma de cadastrar.
 *
 * Duas regras atravessam a tela inteira:
 *   - **Data nunca bloqueia o salvamento.** Todo campo de data e período é
 *     opcional, e o que a pessoa escreve é o que fica guardado e exibido.
 *   - **Taxonomia é sugestão.** Religião, escolaridade e idioma vêm com lista,
 *     mas aceitam qualquer texto.
 */

import { useEffect, useState } from 'react';
import {
  FileText,
  ImagePlus,
  Pencil,
  Star,
  User,
  X,
  Users,
} from 'lucide-react';
import { IconeArvore, IconeRelacoes } from '../../../components/icons';
import { Button } from '../../../components/ui/Button';
import { Input } from '../../../components/ui/Input';
import { Select } from '../../../components/ui/Select';
import { ImagemDoAcervo } from '../../../components/ui/ImagemDoAcervo';
import { CampoDeData } from '../../../components/ui/CampoDeData';
import { escolherArquivo } from '../../../lib/api';
import { useI18n } from '../../../i18n/I18nContext';
import { SecaoAtributo, CampoCurto, type ItemDeLista } from './SecaoAtributo';
import { SecaoNomes } from './SecaoNomes';
import {
  usePessoa,
  useSalvarPessoa,
  useEventos,
  useCriarEvento,
  useRemoverEvento,
  usePaises,
  useNomes,
  useAdicionarNome,
  useRemoverNome,
  useUsarNomeNaArvore,
  useDocumentos,
  useAnexarDocumento,
  useRemoverDocumento,
  useDefinirFotoPrincipal,
  religioes,
  profissoes,
  idiomas,
  escolaridade,
  apelidos,
  nacionalidades,
} from '../hooks/useFicha';
import {
  RELIGIOES,
  NIVEIS_ESCOLARIDADE,
  IDIOMAS,
  TIPOS_DE_EVENTO,
  rotuloDoTipo,
  rotuloDoTipoDeNome,
} from '../taxonomias';
import { ErroDoAcervo } from '../../../lib/api';
import { SeletorDeLocal } from './SeletorDeLocal';
import { DATA_VAZIA, type DataEscolhida, type Person, type Place, type Sex } from '../../../types';

interface PersonDetailsProps {
  pessoaId: string;
  onFechar: () => void;
  onDefinirComoRaiz?: (pessoaId: string) => void;
  onCalcularParentesco?: (pessoaId: string) => void;
  onFundirPessoa?: (pessoaId: string) => void;
  isRaizAtual?: boolean;
}

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo || erro instanceof Error) return erro.message;
  return String(erro);
}


/**
 * Concorda com o sexo em vez de fixar o feminino.
 *
 * Estava escrito "Falecida" direto, o que fazia D. João VI aparecer no
 * feminino. Para `X` e `U` usa-se a forma que se apoia em "pessoa", substantivo
 * feminino, e que por isso não atribui gênero a quem não o declarou.
 */
function situacaoDeFalecimento(sexo: string): string {
  if (sexo === 'M') return 'Falecido';
  if (sexo === 'F') return 'Falecida';
  return 'Pessoa falecida';
}

export function PersonDetails({
  pessoaId,
  onFechar,
  onDefinirComoRaiz,
  onCalcularParentesco,
  onFundirPessoa,
  isRaizAtual = false,
}: PersonDetailsProps) {
  const { t } = useI18n();
  const { data: pessoa, isLoading, error } = usePessoa(pessoaId);
  const salvar = useSalvarPessoa(pessoaId);

  const { data: eventos, isLoading: carregandoEventos } = useEventos(pessoaId);
  const criarEvento = useCriarEvento(pessoaId);
  const removerEvento = useRemoverEvento(pessoaId);

  const { data: paises } = usePaises();

  const listaReligioes = religioes.useLista(pessoaId);
  const addReligiao = religioes.useAdicionar(pessoaId);
  const delReligiao = religioes.useRemover(pessoaId);

  const listaProfissoes = profissoes.useLista(pessoaId);
  const addProfissao = profissoes.useAdicionar(pessoaId);
  const delProfissao = profissoes.useRemover(pessoaId);

  const listaIdiomas = idiomas.useLista(pessoaId);
  const addIdioma = idiomas.useAdicionar(pessoaId);
  const delIdioma = idiomas.useRemover(pessoaId);

  const listaEscolaridade = escolaridade.useLista(pessoaId);
  const addEscolaridade = escolaridade.useAdicionar(pessoaId);
  const delEscolaridade = escolaridade.useRemover(pessoaId);

  const listaApelidos = apelidos.useLista(pessoaId);
  const addApelido = apelidos.useAdicionar(pessoaId);
  const delApelido = apelidos.useRemover(pessoaId);

  const listaNacionalidades = nacionalidades.useLista(pessoaId);
  const addNacionalidade = nacionalidades.useAdicionar(pessoaId);
  const delNacionalidade = nacionalidades.useRemover(pessoaId);

  const listaNomes = useNomes(pessoaId);
  const addNome = useAdicionarNome(pessoaId);
  const delNome = useRemoverNome(pessoaId);
  const usarNome = useUsarNomeNaArvore(pessoaId);

  const listaDocumentos = useDocumentos(pessoaId);
  const anexar = useAnexarDocumento(pessoaId);
  const delDocumento = useRemoverDocumento(pessoaId);
  const definirRetrato = useDefinirFotoPrincipal(pessoaId);

  // --- Edição dos campos básicos ---
  const [editando, setEditando] = useState(false);
  const [rascunho, setRascunho] = useState<Person | null>(null);

  useEffect(() => {
    if (pessoa) setRascunho(pessoa);
  }, [pessoa]);

  // --- Formulários das listas ---
  const [novoEvento, setNovoEvento] = useState({ tipo: 'nascimento', local: '', nota: '' });
  const [dataDoEvento, setDataDoEvento] = useState<DataEscolhida>({ ...DATA_VAZIA });
  const [localDoEvento, setLocalDoEvento] = useState<Place | null>(null);
  const [novaReligiao, setNovaReligiao] = useState({ denominacao: '', periodo: '' });
  const [novaProfissao, setNovaProfissao] = useState({ ocupacao: '', empregador: '', periodo: '' });
  const [novoIdioma, setNovoIdioma] = useState('');
  const [novaEscolaridade, setNovaEscolaridade] = useState({ nivel: '', instituicao: '', periodo: '' });
  const [novoApelido, setNovoApelido] = useState('');
  const [novaNacionalidade, setNovaNacionalidade] = useState('');

  if (isLoading) {
    return (
      <div className="p-8 text-center text-sm text-tinta3">Carregando a ficha…</div>
    );
  }

  if (error || !pessoa || !rascunho) {
    return (
      <div className="p-8 text-center text-sm text-fem">
        {mensagemDeErro(error) ?? 'Não foi possível abrir a ficha.'}
      </div>
    );
  }

  const nomeCompleto = [pessoa.nome, pessoa.sobrenome].filter(Boolean).join(' ');
  const faixaSexo =
    pessoa.sexo === 'M' ? 'bg-masc' : pessoa.sexo === 'F' ? 'bg-fem' : 'bg-tinta3';

  const nomeDoPais = (paisId: string) => paises?.find((p) => p.id === paisId)?.nome ?? paisId;

  const itensEventos: ItemDeLista[] = (eventos ?? []).map((e) => ({
    id: e.id,
    principal: rotuloDoTipo(e.tipo_evento),
    // O texto original do usuário, nunca o ano derivado. O rótulo histórico
    // vem antes do município: se a pessoa se deu ao trabalho de escrever
    // "Vila de São Salvador", é isso que ela quer ler.
    secundario:
      [e.data_texto, e.rotulo_historico_livre || e.local_nome, e.nota]
        .filter(Boolean)
        .join(' · ') || 'sem data',
  }));

  return (
    <div className="flex flex-col max-h-[80vh]">
      {/* Cabeçalho */}
      <header className="flex items-start gap-4 p-4 border-b border-borda bg-card2 flex-none">
        <div className="w-16 h-16 rounded-raio-s bg-sup border border-borda flex-none grid place-items-center text-tinta3 overflow-hidden">
          <ImagemDoAcervo
            caminhoRelativo={pessoa.foto_url}
            alt={`Retrato de ${nomeCompleto}`}
            className="w-full h-full object-cover"
            alternativo={<User className="w-7 h-7" />}
          />
        </div>

        <div className="flex-1 min-w-0 flex flex-col gap-1">
          <div className="flex items-center gap-2 flex-wrap">
            <span className={`w-1 h-5 rounded-sm flex-none ${faixaSexo}`} aria-hidden />
            <h2 className="font-tit font-bold text-xl text-tinta m-0 truncate">
              {nomeCompleto}
            </h2>
            {pessoa.tipo_tempo === 'ficticio' ? (
              <span className="px-2 py-0.5 text-[10px] font-bold rounded-full bg-purple-500/15 text-purple-700 dark:text-purple-300 border border-purple-500/30 flex items-center gap-1">
                <span>✨</span> Fictício / Literário
              </span>
            ) : (
              <span className="px-2 py-0.5 text-[10px] font-medium rounded-full bg-acento/10 text-tinta2 border border-acento/20 flex items-center gap-1">
                <span>🌍</span> Tempo Real
              </span>
            )}
          </div>
          {/* Os outros nomes ficam à vista no cabeçalho.
              A seção que os edita fica logo abaixo da identidade, mas some da
              vista quando o formulário de edição está aberto — e o ponto da
              fatia 02 é justamente que o nome de exibição não é o único. */}
          {listaNomes.data && listaNomes.data.length > 0 && (
            <p className="text-sm text-tinta2 m-0 leading-snug">
              {listaNomes.data.map((n, i) => (
                <span key={n.id}>
                  {i > 0 && ' · '}
                  <span className="text-tinta">
                    {[n.prefixo, n.nome, n.sufixo, n.sobrenome].filter(Boolean).join(' ')}
                  </span>
                  <span className="text-tinta3"> ({rotuloDoTipoDeNome(n.tipo)})</span>
                </span>
              ))}
            </p>
          )}

          {listaApelidos.data && listaApelidos.data.length > 0 && (
            <p className="text-sm text-tinta2 m-0 truncate">
              conhecido como {listaApelidos.data.map((a) => a.apelido).join(', ')}
            </p>
          )}
          <p className="font-num text-[12.5px] text-tinta2 m-0">
            {pessoa.is_vivo ? t('perfil', 'pessoaViva') : situacaoDeFalecimento(pessoa.sexo)}
          </p>
        </div>

        <div className="flex items-center gap-1.5 flex-wrap justify-end ml-3 flex-none">
          {onCalcularParentesco && (
            <button
              type="button"
              onClick={() => onCalcularParentesco(pessoaId)}
              className="px-2.5 py-1 text-xs font-semibold rounded-raio-s border border-borda2 bg-card text-tinta hover:bg-sup transition-colors flex items-center gap-1.5 cursor-pointer shadow-2xs"
              title={t('topo', 'parentescoDesc')}
            >
              <IconeRelacoes className="w-3.5 h-3.5 text-acento" />
              {t('topo', 'parentesco')}
            </button>
          )}

          {onFundirPessoa && (
            <button
              type="button"
              onClick={() => onFundirPessoa(pessoaId)}
              className="px-2.5 py-1 text-xs font-semibold rounded-raio-s border border-borda2 bg-card text-tinta hover:bg-sup transition-colors flex items-center gap-1.5 cursor-pointer shadow-2xs"
              title="Fundir/mesclar este registro com outro duplicado no acervo"
            >
              <Users className="w-3.5 h-3.5 text-acento" />
              {t('topo', 'mesclarPessoas')}
            </button>
          )}

          {onDefinirComoRaiz && (
            <button
              type="button"
              onClick={() => onDefinirComoRaiz(pessoaId)}
              disabled={isRaizAtual}
              className={`px-2.5 py-1 text-xs font-semibold rounded-raio-s border transition-colors flex items-center gap-1.5 ${
                isRaizAtual
                  ? 'bg-sup text-tinta3 border-borda cursor-default'
                  : 'bg-card text-tinta hover:bg-sup border-borda2 cursor-pointer shadow-2xs'
              }`}
              title={
                isRaizAtual
                  ? 'Esta pessoa já é o foco/raiz da árvore ativa'
                  : 'Focar a árvore ativa nesta pessoa'
              }
            >
              <IconeArvore className="w-3.5 h-3.5 text-acento" />
              {isRaizAtual ? t('arvore', 'raizAtual') : t('arvore', 'definirComoRaiz')}
            </button>
          )}

          <button
            type="button"
            onClick={onFechar}
            aria-label={t('comum', 'fechar')}
            className="text-tinta3 hover:text-tinta p-1 rounded-raio-s hover:bg-sup transition-colors flex-none"
          >
            <X className="w-5 h-5" />
          </button>
        </div>
      </header>

      {/* Corpo */}
      <div className="flex-1 overflow-y-auto min-h-0 p-4 grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">
        {/* ---------------- Identidade ---------------- */}
        <section className="md:col-span-2 flex flex-col gap-3">
          <div className="flex items-center justify-between">
            <h3 className="font-num text-[10.5px] uppercase tracking-wider text-tinta3 m-0">
              {t('ficha', 'identidade')}
            </h3>
            {!editando && (
              <button
                type="button"
                onClick={() => setEditando(true)}
                className="text-[11px] text-acento hover:text-tinta transition-colors flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
              >
                <Pencil className="w-3 h-3" />
                {t('comum', 'editar')}
              </button>
            )}
          </div>

          {mensagemDeErro(salvar.error) && (
            <p role="alert" className="text-xs text-fem m-0 bg-fem/10 border border-fem/20 rounded-raio-s p-2">
              {mensagemDeErro(salvar.error)}
            </p>
          )}

          {editando ? (
            <form
              className="flex flex-col gap-4"
              onSubmit={(e) => {
                e.preventDefault();
                salvar.mutate(rascunho, { onSuccess: () => setEditando(false) });
              }}
            >
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <Input
                  label={t('ficha', 'nome')}
                  value={rascunho.nome}
                  onChange={(e) => setRascunho({ ...rascunho, nome: e.target.value })}
                  required
                />
                <Input
                  label={t('ficha', 'sobrenome')}
                  value={rascunho.sobrenome ?? ''}
                  onChange={(e) => setRascunho({ ...rascunho, sobrenome: e.target.value })}
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <Select
                  label={t('ficha', 'sexo')}
                  value={rascunho.sexo}
                  onChange={(e) => setRascunho({ ...rascunho, sexo: e.target.value as Sex })}
                  options={[
                    { value: 'M', label: t('ficha', 'masculino') },
                    { value: 'F', label: t('ficha', 'feminino') },
                    { value: 'X', label: t('ficha', 'outro') },
                    { value: 'U', label: t('ficha', 'desconhecido') },
                  ]}
                />
                <div className="flex flex-col justify-end gap-2 pb-1">
                  <label className="flex items-center gap-2 cursor-pointer text-xs text-tinta">
                    <input
                      type="checkbox"
                      checked={rascunho.is_publico}
                      onChange={(e) => setRascunho({ ...rascunho, is_publico: e.target.checked })}
                      className="rounded border-borda"
                    />
                    <span>{t('ficha', 'isPublico')}</span>
                  </label>
                  <label className="flex items-center gap-2 cursor-pointer text-xs text-tinta">
                    <input
                      type="checkbox"
                      checked={rascunho.is_vivo}
                      onChange={(e) => setRascunho({ ...rascunho, is_vivo: e.target.checked })}
                      className="rounded border-borda"
                    />
                    <span>{t('ficha', 'isVivo')}</span>
                  </label>
                </div>
              </div>

              <div className="p-2.5 bg-fundo/40 rounded-raio-s border border-borda/60 flex flex-col gap-1.5">
                <span className="text-xs font-semibold text-tinta">Cronologia / Natureza do Tempo</span>
                <div className="flex items-center gap-4 text-xs">
                  <label className="flex items-center gap-1.5 cursor-pointer text-tinta">
                    <input
                      type="radio"
                      name="rascunho_tipo_tempo"
                      value="real"
                      checked={rascunho.tipo_tempo !== 'ficticio'}
                      onChange={() => setRascunho({ ...rascunho, tipo_tempo: 'real' })}
                      className="text-acento"
                    />
                    <span>🌍 Tempo Real / Histórico</span>
                  </label>
                  <label className="flex items-center gap-1.5 cursor-pointer text-tinta">
                    <input
                      type="radio"
                      name="rascunho_tipo_tempo"
                      value="ficticio"
                      checked={rascunho.tipo_tempo === 'ficticio'}
                      onChange={() => setRascunho({ ...rascunho, tipo_tempo: 'ficticio' })}
                      className="text-purple-600"
                    />
                    <span>✨ Tempo Fictício / Literário</span>
                  </label>
                </div>
              </div>

              <label className="flex flex-col gap-1.5">
                <span className="text-xs font-semibold text-tinta">{t('ficha', 'minibiografia')}</span>
                <textarea
                  value={rascunho.minibiografia ?? ''}
                  onChange={(e) => setRascunho({ ...rascunho, minibiografia: e.target.value })}
                  placeholder="O que vale a pena lembrar sobre esta pessoa…"
                  className="w-full rounded-raio-s border border-borda bg-card px-3 py-2 text-sm text-tinta min-h-[88px] resize-y focus:outline-none focus:ring-2 focus:ring-acento/50"
                />
              </label>

              <div className="flex justify-end gap-3">
                <Button
                  type="button"
                  variant="ghost"
                  size="sm"
                  onClick={() => {
                    setRascunho(pessoa);
                    setEditando(false);
                  }}
                >
                  {t('comum', 'cancelar')}
                </Button>
                <Button type="submit" size="sm" disabled={salvar.isPending}>
                  {salvar.isPending ? t('comum', 'carregando') : t('comum', 'salvar')}
                </Button>
              </div>
            </form>
          ) : (
            pessoa.minibiografia && (
              <p className="text-sm text-tinta leading-relaxed m-0 whitespace-pre-wrap">
                {pessoa.minibiografia}
              </p>
            )
          )}
        </section>

        {/* ---------------- Nomes ---------------- */}
        <SecaoNomes
          pessoaId={pessoaId}
          nomePublico={nomeCompleto}
          nomes={listaNomes.data ?? []}
          carregando={listaNomes.isLoading}
          erro={addNome.error ?? delNome.error ?? usarNome.error}
          adicionando={addNome.isPending}
          removendo={delNome.isPending}
          onAdicionar={(novo) =>
            addNome.mutate({
              pessoa_id: pessoaId,
              tipo: novo.tipo,
              nome: novo.nome,
              sobrenome: novo.sobrenome,
              periodo: novo.periodo,
            })
          }
          onRemover={(id) => delNome.mutate(id)}
          onUsarNaArvore={(id) => usarNome.mutate(id)}
        />

        {/* ---------------- Eventos ---------------- */}
        <section className="md:col-span-2">
          <SecaoAtributo
            titulo="Eventos de vida"
            vazio="Nenhum evento registrado."
            itens={itensEventos}
            carregando={carregandoEventos}
            erro={mensagemDeErro(criarEvento.error) ?? mensagemDeErro(removerEvento.error)}
            onRemover={(id) => removerEvento.mutate(id)}
            removendo={removerEvento.isPending}
            adicionando={criarEvento.isPending}
            podeAdicionar={!!novoEvento.tipo}
            onAdicionar={() =>
              criarEvento.mutate(
                {
                  pessoa_id: pessoaId,
                  tipo_evento: novoEvento.tipo,
                  data: dataDoEvento,
                  local_id: localDoEvento?.id ?? null,
                  rotulo_historico_livre: novoEvento.local.trim() || null,
                  nota: novoEvento.nota.trim() || null,
                },
                {
                  onSuccess: () => {
                    setNovoEvento({ tipo: 'nascimento', local: '', nota: '' });
                    setDataDoEvento({ ...DATA_VAZIA });
                    setLocalDoEvento(null);
                  },
                },
              )
            }
          >
            <label className="flex flex-col gap-1">
              <span className="text-[11px] text-tinta2">Tipo</span>
              <select
                value={novoEvento.tipo}
                onChange={(e) => setNovoEvento({ ...novoEvento, tipo: e.target.value })}
                className="text-sm px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta"
              >
                {TIPOS_DE_EVENTO.map((t) => (
                  <option key={t.valor} value={t.valor}>
                    {t.rotulo}
                  </option>
                ))}
              </select>
            </label>

            <CampoDeData
              rotulo="Data"
              valor={dataDoEvento}
              aoMudar={setDataDoEvento}
            />
            <SeletorDeLocal
              local={localDoEvento}
              onEscolher={setLocalDoEvento}
              rotuloHistorico={novoEvento.local}
              onMudarRotulo={(v) => setNovoEvento({ ...novoEvento, local: v })}
            />
            <CampoCurto
              rotulo="Nota"
              valor={novoEvento.nota}
              aoMudar={(v) => setNovoEvento({ ...novoEvento, nota: v })}
              placeholder="opcional"
            />

            <p className="text-[11px] text-tinta3 m-0 leading-relaxed">
              Nada aqui é obrigatório além do tipo. O texto da data fica guardado
              exatamente como você escrever.
            </p>
          </SecaoAtributo>
        </section>

        {/* ---------------- Apelidos ---------------- */}
        <SecaoAtributo
          titulo="Apelidos"
          vazio="Nenhum apelido registrado."
          itens={(listaApelidos.data ?? []).map((a) => ({ id: a.id, principal: a.apelido }))}
          carregando={listaApelidos.isLoading}
          erro={mensagemDeErro(addApelido.error)}
          onRemover={(id) => delApelido.mutate(id)}
          removendo={delApelido.isPending}
          adicionando={addApelido.isPending}
          podeAdicionar={!!novoApelido.trim()}
          onAdicionar={() =>
            addApelido.mutate([novoApelido.trim()], { onSuccess: () => setNovoApelido('') })
          }
        >
          <CampoCurto
            rotulo="Apelido"
            valor={novoApelido}
            aoMudar={setNovoApelido}
            placeholder="como a família o chamava"
          />
        </SecaoAtributo>

        {/* ---------------- Nacionalidades ---------------- */}
        <SecaoAtributo
          titulo="Nacionalidades"
          vazio="Nenhuma nacionalidade registrada."
          itens={(listaNacionalidades.data ?? []).map((n) => ({
            id: n.id,
            principal: nomeDoPais(n.pais_id),
          }))}
          carregando={listaNacionalidades.isLoading}
          erro={mensagemDeErro(addNacionalidade.error)}
          onRemover={(id) => delNacionalidade.mutate(id)}
          removendo={delNacionalidade.isPending}
          adicionando={addNacionalidade.isPending}
          podeAdicionar={!!novaNacionalidade}
          onAdicionar={() =>
            addNacionalidade.mutate([novaNacionalidade], {
              onSuccess: () => setNovaNacionalidade(''),
            })
          }
        >
          <label className="flex flex-col gap-1">
            <span className="text-[11px] text-tinta2">País</span>
            <select
              value={novaNacionalidade}
              onChange={(e) => setNovaNacionalidade(e.target.value)}
              className="text-sm px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta"
            >
              <option value="">Escolha…</option>
              {paises?.map((p) => (
                <option key={p.id} value={p.id}>
                  {p.nome}
                </option>
              ))}
            </select>
          </label>
        </SecaoAtributo>

        {/* ---------------- Religiões ---------------- */}
        <SecaoAtributo
          titulo="Religiões"
          vazio="Nenhuma religião registrada."
          itens={(listaReligioes.data ?? []).map((r) => ({
            id: r.id,
            principal: r.denominacao,
            secundario: r.periodo,
          }))}
          carregando={listaReligioes.isLoading}
          erro={mensagemDeErro(addReligiao.error)}
          onRemover={(id) => delReligiao.mutate(id)}
          removendo={delReligiao.isPending}
          adicionando={addReligiao.isPending}
          podeAdicionar={!!novaReligiao.denominacao.trim()}
          onAdicionar={() =>
            addReligiao.mutate(
              [novaReligiao.denominacao.trim(), novaReligiao.periodo.trim() || null],
              { onSuccess: () => setNovaReligiao({ denominacao: '', periodo: '' }) },
            )
          }
        >
          <CampoCurto
            rotulo="Denominação"
            valor={novaReligiao.denominacao}
            aoMudar={(v) => setNovaReligiao({ ...novaReligiao, denominacao: v })}
            sugestoes={RELIGIOES}
            idSugestoes="sugestoes-religiao"
            placeholder="escolha ou escreva"
          />
          <CampoCurto
            rotulo="Período (opcional)"
            valor={novaReligiao.periodo}
            aoMudar={(v) => setNovaReligiao({ ...novaReligiao, periodo: v })}
            placeholder="a partir de 1950, até 1972…"
          />
        </SecaoAtributo>

        {/* ---------------- Escolaridade ---------------- */}
        <SecaoAtributo
          titulo="Escolaridade"
          vazio="Nenhuma escolaridade registrada."
          itens={(listaEscolaridade.data ?? []).map((e) => ({
            id: e.id,
            principal: e.nivel,
            secundario: [e.instituicao, e.periodo].filter(Boolean).join(' · ') || null,
          }))}
          carregando={listaEscolaridade.isLoading}
          erro={mensagemDeErro(addEscolaridade.error)}
          onRemover={(id) => delEscolaridade.mutate(id)}
          removendo={delEscolaridade.isPending}
          adicionando={addEscolaridade.isPending}
          podeAdicionar={!!novaEscolaridade.nivel.trim()}
          onAdicionar={() =>
            addEscolaridade.mutate(
              [
                novaEscolaridade.nivel.trim(),
                novaEscolaridade.instituicao.trim() || null,
                novaEscolaridade.periodo.trim() || null,
              ],
              { onSuccess: () => setNovaEscolaridade({ nivel: '', instituicao: '', periodo: '' }) },
            )
          }
        >
          <CampoCurto
            rotulo="Nível"
            valor={novaEscolaridade.nivel}
            aoMudar={(v) => setNovaEscolaridade({ ...novaEscolaridade, nivel: v })}
            sugestoes={NIVEIS_ESCOLARIDADE}
            idSugestoes="sugestoes-escolaridade"
          />
          <CampoCurto
            rotulo="Instituição (opcional)"
            valor={novaEscolaridade.instituicao}
            aoMudar={(v) => setNovaEscolaridade({ ...novaEscolaridade, instituicao: v })}
          />
          <CampoCurto
            rotulo="Período (opcional)"
            valor={novaEscolaridade.periodo}
            aoMudar={(v) => setNovaEscolaridade({ ...novaEscolaridade, periodo: v })}
          />
        </SecaoAtributo>

        {/* ---------------- Profissões ---------------- */}
        <SecaoAtributo
          titulo="Profissões"
          vazio="Nenhuma profissão registrada."
          itens={(listaProfissoes.data ?? []).map((p) => ({
            id: p.id,
            principal: p.ocupacao,
            secundario: [p.empregador_local, p.periodo].filter(Boolean).join(' · ') || null,
          }))}
          carregando={listaProfissoes.isLoading}
          erro={mensagemDeErro(addProfissao.error)}
          onRemover={(id) => delProfissao.mutate(id)}
          removendo={delProfissao.isPending}
          adicionando={addProfissao.isPending}
          podeAdicionar={!!novaProfissao.ocupacao.trim()}
          onAdicionar={() =>
            addProfissao.mutate(
              [
                novaProfissao.ocupacao.trim(),
                novaProfissao.empregador.trim() || null,
                novaProfissao.periodo.trim() || null,
              ],
              { onSuccess: () => setNovaProfissao({ ocupacao: '', empregador: '', periodo: '' }) },
            )
          }
        >
          <CampoCurto
            rotulo="Ocupação"
            valor={novaProfissao.ocupacao}
            aoMudar={(v) => setNovaProfissao({ ...novaProfissao, ocupacao: v })}
            placeholder="lavrador, ferroviária, costureira…"
          />
          <CampoCurto
            rotulo="Empregador ou local (opcional)"
            valor={novaProfissao.empregador}
            aoMudar={(v) => setNovaProfissao({ ...novaProfissao, empregador: v })}
          />
          <CampoCurto
            rotulo="Período (opcional)"
            valor={novaProfissao.periodo}
            aoMudar={(v) => setNovaProfissao({ ...novaProfissao, periodo: v })}
          />
        </SecaoAtributo>

        {/* ---------------- Idiomas ---------------- */}
        <SecaoAtributo
          titulo="Idiomas"
          vazio="Nenhum idioma registrado."
          itens={(listaIdiomas.data ?? []).map((i) => ({ id: i.id, principal: i.idioma }))}
          carregando={listaIdiomas.isLoading}
          erro={mensagemDeErro(addIdioma.error)}
          onRemover={(id) => delIdioma.mutate(id)}
          removendo={delIdioma.isPending}
          adicionando={addIdioma.isPending}
          podeAdicionar={!!novoIdioma.trim()}
          onAdicionar={() =>
            addIdioma.mutate([novoIdioma.trim()], { onSuccess: () => setNovoIdioma('') })
          }
        >
          <CampoCurto
            rotulo="Idioma"
            valor={novoIdioma}
            aoMudar={setNovoIdioma}
            sugestoes={IDIOMAS}
            idSugestoes="sugestoes-idioma"
            placeholder="escolha ou escreva"
          />
        </SecaoAtributo>

        {/* ---------------- Fotos e documentos ---------------- */}
        <section className="md:col-span-2 flex flex-col gap-2 pt-2 border-t border-borda">
          <div className="flex items-center justify-between gap-2">
            <h3 className="font-num text-[10.5px] uppercase tracking-wider text-tinta3 m-0">
              Fotos e documentos
            </h3>
            <button
              type="button"
              disabled={anexar.isPending}
              onClick={async () => {
                const caminho = await escolherArquivo();
                if (caminho) {
                  anexar.mutate({ pessoa_id: pessoaId, caminho_origem: caminho });
                }
              }}
              className="text-[11px] text-acento hover:text-tinta transition-colors flex items-center gap-1 bg-transparent border-none cursor-pointer p-0 disabled:opacity-50"
            >
              <ImagePlus className="w-3.5 h-3.5" />
              {anexar.isPending ? 'Copiando…' : 'Anexar arquivo'}
            </button>
          </div>

          {(mensagemDeErro(anexar.error) ??
            mensagemDeErro(delDocumento.error) ??
            mensagemDeErro(definirRetrato.error)) && (
            <p role="alert" className="text-xs text-fem m-0">
              {mensagemDeErro(anexar.error) ??
                mensagemDeErro(delDocumento.error) ??
                mensagemDeErro(definirRetrato.error)}
            </p>
          )}

          {listaDocumentos.isLoading ? (
            <p className="text-xs text-tinta3 m-0">Carregando…</p>
          ) : (listaDocumentos.data ?? []).length === 0 ? (
            <p className="text-xs text-tinta3 m-0 leading-relaxed">
              Nenhum anexo. Uma foto do rosto vale mais que três campos de texto — é o
              gatilho de memória mais forte que existe.
            </p>
          ) : (
            <ul className="list-none m-0 p-0 grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-2">
              {(listaDocumentos.data ?? []).map((d) => {
                const ehRetrato = pessoa.foto_url === d.caminho_relativo;
                const rotulo = d.titulo || d.nome_original || 'Anexo';
                return (
                  <li
                    key={d.id}
                    className={`relative rounded-raio-s border overflow-hidden bg-card group ${
                      ehRetrato ? 'border-acento ring-1 ring-acento/40' : 'border-borda'
                    }`}
                  >
                    <div className="aspect-square bg-sup grid place-items-center text-tinta3 overflow-hidden">
                      {d.tipo_midia === 'imagem' ? (
                        <ImagemDoAcervo
                          caminhoRelativo={d.caminho_relativo}
                          alt={rotulo}
                          className="w-full h-full object-cover"
                          alternativo={<ImagePlus className="w-6 h-6" />}
                        />
                      ) : (
                        <FileText className="w-7 h-7" />
                      )}
                    </div>

                    <div className="px-2 py-1.5">
                      <span className="block text-[11px] text-tinta truncate" title={rotulo}>
                        {rotulo}
                      </span>
                      {d.data_documento && (
                        <span className="block font-num text-[10px] text-tinta3 truncate">
                          {d.data_documento}
                        </span>
                      )}
                    </div>

                    {/* Ações aparecem no hover para não poluir a grade. */}
                    <div className="absolute top-1 right-1 flex gap-1 opacity-0 group-hover:opacity-100 focus-within:opacity-100 transition-opacity">
                      {d.tipo_midia === 'imagem' && (
                        <button
                          type="button"
                          title={ehRetrato ? 'Deixar de ser o retrato' : 'Usar como retrato'}
                          aria-label={ehRetrato ? 'Deixar de ser o retrato' : 'Usar como retrato'}
                          disabled={definirRetrato.isPending}
                          onClick={() => definirRetrato.mutate(ehRetrato ? null : d.id)}
                          className={`p-1 rounded-raio-s border cursor-pointer transition-colors ${
                            ehRetrato
                              ? 'bg-acento text-acento-tinta border-acento'
                              : 'bg-card/90 text-tinta2 border-borda2 hover:text-acento'
                          }`}
                        >
                          <Star className="w-3 h-3" />
                        </button>
                      )}
                      <button
                        type="button"
                        title="Remover anexo"
                        aria-label={`Remover ${rotulo}`}
                        disabled={delDocumento.isPending}
                        onClick={() => delDocumento.mutate(d.id)}
                        className="p-1 rounded-raio-s border border-borda2 bg-card/90 text-tinta2 hover:text-fem cursor-pointer transition-colors"
                      >
                        <X className="w-3 h-3" />
                      </button>
                    </div>
                  </li>
                );
              })}
            </ul>
          )}

          <p className="text-[11px] text-tinta3 m-0 leading-relaxed">
            O arquivo é copiado para a pasta do programa — o original em Downloads pode ser
            movido ou apagado sem quebrar o acervo. A estrela marca o retrato que aparece na
            árvore.
          </p>
        </section>
      </div>
    </div>
  );
}
