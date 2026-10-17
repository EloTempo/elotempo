import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import {
  Plus,
  Trash2,
  BookOpen,
  Building,
  ShieldCheck,
  CheckCircle2,
  AlertTriangle,
  HelpCircle,
  X,
  Scroll,
} from 'lucide-react';
import { Button } from '../../../components/ui/Button';
import { useI18n } from '../../../i18n/I18nContext';
import {
  listarCitacoesDoAlvo,
  listarFontes,
  criarCitacao,
  criarFonte,
  removerCitacao,
  type TipoFonte,
  type GrauConfianca,
  type NovaFonte,
  type NovaCitacao,
} from '../../../lib/api/fontes';

interface AbaFontesProps {
  pessoaId: string;
  nomePessoa: string;
}

const TIPOS_FONTE_OPCOES: { valor: TipoFonte; rotulo: string }[] = [
  { valor: 'certidao', rotulo: 'Certidão Civil (Nasc., Casam., Óbito)' },
  { valor: 'registro_paroquial', rotulo: 'Registro Paroquial / Eclesiástico (Batismo)' },
  { valor: 'censo', rotulo: 'Censo Demográfico / Lista de Famílias' },
  { valor: 'livro', rotulo: 'Livro Histórico / Genealogia Publicada' },
  { valor: 'jornal', rotulo: 'Jornal / Periódico de Época' },
  { valor: 'lapide', rotulo: 'Inscrição em Lápide / Cemitério' },
  { valor: 'correspondencia', rotulo: 'Correspondência / Carta / Diário' },
  { valor: 'entrevista', rotulo: 'Entrevista / Tradição Oral' },
  { valor: 'fotografia', rotulo: 'Fotografia Histórica com Inscrição' },
  { valor: 'outro', rotulo: 'Outro Documento de Arquivo' },
];

export function AbaFontes({ pessoaId, nomePessoa }: AbaFontesProps) {
  const { t } = useI18n();
  const qc = useQueryClient();

  const [modalAberto, setModalAberto] = useState(false);
  const [modoAbaModal, setModoAbaModal] = useState<'nova' | 'existente'>('nova');

  // Estados do formulário
  const [fonteIdSelecionada, setFonteIdSelecionada] = useState<string>('');
  const [titulo, setTitulo] = useState('');
  const [tipo, setTipo] = useState<TipoFonte>('certidao');
  const [autorOrgao, setAutorOrgao] = useState('');
  const [dataPublicacao, setDataPublicacao] = useState('');
  const [repositorio, setRepositorio] = useState('');
  const [referencia, setReferencia] = useState('');
  const [notaFonte, setNotaFonte] = useState('');

  // Detalhes da citação
  const [paginaFolha, setPaginaFolha] = useState('');
  const [confianca, setConfianca] = useState<GrauConfianca>('alta');
  const [transcricao, setTranscricao] = useState('');
  const [notaCitacao, setNotaCitacao] = useState('');

  const [erro, setErro] = useState<string | null>(null);

  // Queries
  const { data: citacoes = [], isLoading } = useQuery({
    queryKey: ['citacoes', 'pessoa', pessoaId],
    queryFn: () => listarCitacoesDoAlvo('pessoa', pessoaId),
  });

  const { data: todasFontes = [] } = useQuery({
    queryKey: ['fontes'],
    queryFn: () => listarFontes(),
  });

  // Mutations
  const mutationRemover = useMutation({
    mutationFn: (id: string) => removerCitacao(id),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['citacoes', 'pessoa', pessoaId] });
    },
  });

  const limparFormulario = () => {
    setTitulo('');
    setTipo('certidao');
    setAutorOrgao('');
    setDataPublicacao('');
    setRepositorio('');
    setReferencia('');
    setNotaFonte('');
    setPaginaFolha('');
    setConfianca('alta');
    setTranscricao('');
    setNotaCitacao('');
    setFonteIdSelecionada('');
    setErro(null);
  };

  const handleSalvar = async (e: React.FormEvent) => {
    e.preventDefault();
    setErro(null);

    try {
      let fId = fonteIdSelecionada;

      if (modoAbaModal === 'nova') {
        if (!titulo.trim()) {
          setErro('O título da fonte documental é obrigatório.');
          return;
        }

        const novaFontePayload: NovaFonte = {
          titulo: titulo.trim(),
          tipo,
          autor_orgao: autorOrgao.trim() || undefined,
          data_publicacao: dataPublicacao.trim() || undefined,
          repositorio: repositorio.trim() || undefined,
          referencia: referencia.trim() || undefined,
          nota: notaFonte.trim() || undefined,
        };

        const fonteCriada = await criarFonte(novaFontePayload);
        fId = fonteCriada.id;
        qc.invalidateQueries({ queryKey: ['fontes'] });
      } else {
        if (!fId) {
          setErro('Selecione uma fonte documental existente na lista.');
          return;
        }
      }

      const novaCitacaoPayload: NovaCitacao = {
        fonte_id: fId,
        alvo_tipo: 'pessoa',
        alvo_id: pessoaId,
        pagina_folha: paginaFolha.trim() || undefined,
        confianca,
        transcricao: transcricao.trim() || undefined,
        nota: notaCitacao.trim() || undefined,
      };

      await criarCitacao(novaCitacaoPayload);
      qc.invalidateQueries({ queryKey: ['citacoes', 'pessoa', pessoaId] });

      limparFormulario();
      setModalAberto(false);
    } catch (err) {
      setErro(err instanceof Error ? err.message : String(err));
    }
  };

  const obterBadgeConfianca = (grau?: GrauConfianca | null) => {
    switch (grau) {
      case 'alta':
        return (
          <span className="inline-flex items-center gap-1 text-[11px] font-semibold text-emerald-600 dark:text-emerald-400 bg-emerald-500/10 px-2 py-0.5 rounded-full border border-emerald-500/20">
            <CheckCircle2 className="w-3 h-3" />
            {t('perfil', 'certezaAlta')}
          </span>
        );
      case 'media':
        return (
          <span className="inline-flex items-center gap-1 text-[11px] font-semibold text-sky-600 dark:text-sky-400 bg-sky-500/10 px-2 py-0.5 rounded-full border border-sky-500/20">
            <ShieldCheck className="w-3 h-3" />
            {t('perfil', 'certezaMedia')}
          </span>
        );
      case 'baixa':
        return (
          <span className="inline-flex items-center gap-1 text-[11px] font-semibold text-amber-600 dark:text-amber-400 bg-amber-500/10 px-2 py-0.5 rounded-full border border-amber-500/20">
            <AlertTriangle className="w-3 h-3" />
            {t('perfil', 'certezaBaixa')}
          </span>
        );
      case 'questionavel':
        return (
          <span className="inline-flex items-center gap-1 text-[11px] font-semibold text-rose-600 dark:text-rose-400 bg-rose-500/10 px-2 py-0.5 rounded-full border border-rose-500/20">
            <HelpCircle className="w-3 h-3" />
            {t('perfil', 'certezaQuestionavel')}
          </span>
        );
      default:
        return null;
    }
  };

  return (
    <div className="space-y-6">
      {/* Cabeçalho da Seção */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 p-4 rounded-raio bg-sup/40 border border-borda/60">
        <div>
          <h3 className="text-sm font-bold text-tinta flex items-center gap-2">
            <Scroll className="w-4 h-4 text-acento" />
            {t('perfil', 'fontesTitulo')}
          </h3>
          <p className="text-xs text-tinta2 mt-0.5 max-w-xl">
            {t('perfil', 'fontesDescricao')}
          </p>
        </div>
        <Button
          variant="primary"
          size="sm"
          onClick={() => {
            limparFormulario();
            setModalAberto(true);
          }}
          className="flex items-center gap-1.5 cursor-pointer shadow-xs"
        >
          <Plus className="w-3.5 h-3.5" />
          <span>{t('perfil', 'adicionarFonte')}</span>
        </Button>
      </div>

      {/* Lista de Fontes e Citações */}
      {isLoading ? (
        <div className="py-8 text-center text-xs text-tinta2">
          Carregando fontes probatórias…
        </div>
      ) : citacoes.length === 0 ? (
        <div className="py-12 px-4 text-center rounded-raio border border-dashed border-borda/80 bg-card/40 flex flex-col items-center">
          <BookOpen className="w-10 h-10 text-tinta2/40 mb-3" />
          <h4 className="text-sm font-semibold text-tinta">
            {t('perfil', 'nenhumaFonte')}
          </h4>
          <p className="text-xs text-tinta2 mt-1 max-w-md">
            {t('perfil', 'nenhumaFonteDesc')}
          </p>
          <Button
            variant="secondary"
            size="sm"
            className="mt-4 flex items-center gap-1.5 cursor-pointer shadow-xs"
            onClick={() => {
              limparFormulario();
              setModalAberto(true);
            }}
          >
            <Plus className="w-3.5 h-3.5" />
            <span>{t('perfil', 'adicionarFonte')}</span>
          </Button>
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-4">
          {citacoes.map((c) => (
            <div
              key={c.id}
              className="p-4 rounded-raio bg-card border border-borda hover:border-borda-foco shadow-2xs transition-all space-y-3"
            >
              <div className="flex items-start justify-between gap-3">
                <div className="space-y-1">
                  <div className="flex flex-wrap items-center gap-2">
                    <span className="text-xs font-bold text-tinta">
                      {c.fonte_titulo}
                    </span>
                    {c.fonte_tipo && (
                      <span className="text-[10px] uppercase font-bold tracking-wider px-2 py-0.5 rounded bg-sup text-tinta2 border border-borda/60">
                        {c.fonte_tipo.replace('_', ' ')}
                      </span>
                    )}
                    {obterBadgeConfianca(c.confianca)}
                  </div>

                  {/* Detalhes do Repositório e Emissor */}
                  {(c.fonte_autor_orgao || c.fonte_repositorio || c.fonte_referencia) && (
                    <div className="text-[11px] text-tinta2 flex flex-wrap items-center gap-x-3 gap-y-1">
                      {c.fonte_autor_orgao && (
                        <span className="flex items-center gap-1">
                          <Building className="w-3 h-3 text-tinta2/60" />
                          {c.fonte_autor_orgao}
                        </span>
                      )}
                      {c.fonte_repositorio && (
                        <span>
                          Custódia: <strong>{c.fonte_repositorio}</strong>
                        </span>
                      )}
                      {c.fonte_referencia && (
                        <span className="font-mono text-[10.5px]">
                          Ref: {c.fonte_referencia}
                        </span>
                      )}
                    </div>
                  )}
                </div>

                <button
                  type="button"
                  onClick={() => mutationRemover.mutate(c.id)}
                  className="p-1.5 rounded text-tinta2 hover:text-rose-600 hover:bg-rose-500/10 transition-colors cursor-pointer"
                  title="Desvincular fonte desta pessoa"
                >
                  <Trash2 className="w-3.5 h-3.5" />
                </button>
              </div>

              {/* Informações da Citação Específica */}
              {c.pagina_folha && (
                <div className="text-xs text-tinta font-semibold bg-sup/50 px-2.5 py-1 rounded inline-block">
                  Localização: <span className="font-normal font-mono">{c.pagina_folha}</span>
                </div>
              )}

              {/* Transcrição Literal do Documento */}
              {c.transcricao && (
                <div className="p-3 rounded-raio-s bg-sup/30 border-l-2 border-acento text-xs text-tinta italic font-serif leading-relaxed">
                  "{c.transcricao}"
                </div>
              )}

              {/* Notas do Genealogista */}
              {c.nota && (
                <p className="text-xs text-tinta2 border-t border-borda/40 pt-2">
                  <strong className="text-tinta">Anotação:</strong> {c.nota}
                </p>
              )}
            </div>
          ))}
        </div>
      )}

      {/* Modal de Nova Fonte / Citação */}
      {modalAberto && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-xs animate-in fade-in duration-150">
          <div className="w-full max-w-xl bg-card border border-borda rounded-raio shadow-2xl overflow-hidden flex flex-col max-h-[90vh]">
            <div className="flex items-center justify-between px-4 py-3 border-b border-borda bg-sup/40">
              <div className="flex items-center gap-2">
                <Scroll className="w-4 h-4 text-acento" />
                <h4 className="text-sm font-bold text-tinta">
                  Vincular Fonte Comprobatória a {nomePessoa}
                </h4>
              </div>
              <button
                type="button"
                onClick={() => setModalAberto(false)}
                className="p-1 rounded text-tinta2 hover:text-tinta cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <form onSubmit={handleSalvar} className="flex-1 overflow-y-auto p-4 space-y-4">
              {erro && (
                <div className="p-2.5 rounded bg-rose-500/10 border border-rose-500/20 text-rose-600 dark:text-rose-400 text-xs font-semibold">
                  {erro}
                </div>
              )}

              {/* Alternador de Modo: Nova Fonte ou Existente */}
              <div className="flex rounded-raio-s bg-sup p-0.5 border border-borda text-xs">
                <button
                  type="button"
                  onClick={() => setModoAbaModal('nova')}
                  className={`flex-1 py-1.5 rounded-raio-s font-semibold transition-colors cursor-pointer ${
                    modoAbaModal === 'nova'
                      ? 'bg-card text-acento shadow-2xs'
                      : 'text-tinta2 hover:text-tinta'
                  }`}
                >
                  Cadastrar Nova Fonte Primária
                </button>
                <button
                  type="button"
                  onClick={() => setModoAbaModal('existente')}
                  className={`flex-1 py-1.5 rounded-raio-s font-semibold transition-colors cursor-pointer ${
                    modoAbaModal === 'existente'
                      ? 'bg-card text-acento shadow-2xs'
                      : 'text-tinta2 hover:text-tinta'
                  }`}
                >
                  Selecionar Fonte do Acervo ({todasFontes.length})
                </button>
              </div>

              {modoAbaModal === 'existente' ? (
                <div>
                  <label className="block text-xs font-semibold text-tinta mb-1">
                    Fonte Documental Cadastrada *
                  </label>
                  <select
                    value={fonteIdSelecionada}
                    onChange={(e) => setFonteIdSelecionada(e.target.value)}
                    className="w-full text-xs p-2 rounded bg-card border border-borda text-tinta focus:border-acento outline-hidden"
                  >
                    <option value="">Selecione uma fonte...</option>
                    {todasFontes.map((f) => (
                      <option key={f.id} value={f.id}>
                        {f.titulo} {f.repositorio ? `(${f.repositorio})` : ''}
                      </option>
                    ))}
                  </select>
                </div>
              ) : (
                <div className="space-y-3 p-3 rounded-raio-s bg-sup/30 border border-borda/60">
                  <div>
                    <label className="block text-xs font-semibold text-tinta mb-1">
                      Título da Fonte Documental *
                    </label>
                    <input
                      type="text"
                      value={titulo}
                      onChange={(e) => setTitulo(e.target.value)}
                      placeholder="Ex.: Certidão de Nascimento de João Silva, Livro de Batismos da Paróquia de Sintra..."
                      className="w-full text-xs p-2 rounded bg-card border border-borda text-tinta focus:border-acento outline-hidden"
                    />
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                      <label className="block text-xs font-semibold text-tinta mb-1">
                        Tipo de Fonte
                      </label>
                      <select
                        value={tipo}
                        onChange={(e) => setTipo(e.target.value as TipoFonte)}
                        className="w-full text-xs p-2 rounded bg-card border border-borda text-tinta focus:border-acento outline-hidden"
                      >
                        {TIPOS_FONTE_OPCOES.map((opt) => (
                          <option key={opt.valor} value={opt.valor}>
                            {opt.rotulo}
                          </option>
                        ))}
                      </select>
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-tinta mb-1">
                        Cartório / Paróquia / Órgão Emissor
                      </label>
                      <input
                        type="text"
                        value={autorOrgao}
                        onChange={(e) => setAutorOrgao(e.target.value)}
                        placeholder="Ex.: 1º Registro Civil, Cúria Metropolitana..."
                        className="w-full text-xs p-2 rounded bg-card border border-borda text-tinta focus:border-acento outline-hidden"
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                      <label className="block text-xs font-semibold text-tinta mb-1">
                        Repositório / Arquivo de Custódia
                      </label>
                      <input
                        type="text"
                        value={repositorio}
                        onChange={(e) => setRepositorio(e.target.value)}
                        placeholder="Ex.: Arquivo Nacional, FamilySearch, Torre do Tombo..."
                        className="w-full text-xs p-2 rounded bg-card border border-borda text-tinta focus:border-acento outline-hidden"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-tinta mb-1">
                        Cota Geral / URL / Identificador
                      </label>
                      <input
                        type="text"
                        value={referencia}
                        onChange={(e) => setReferencia(e.target.value)}
                        placeholder="Ex.: Fundo Ministério da Justiça, BR_AN_RIO_12..."
                        className="w-full text-xs p-2 rounded bg-card border border-borda text-tinta focus:border-acento outline-hidden"
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* Informações da Citação / Comprovação */}
              <div className="space-y-3 pt-2 border-t border-borda/60">
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div>
                    <label className="block text-xs font-semibold text-tinta mb-1">
                      Página / Folha / Assento / Termo
                    </label>
                    <input
                      type="text"
                      value={paginaFolha}
                      onChange={(e) => setPaginaFolha(e.target.value)}
                      placeholder="Ex.: Livro A-14, Fls. 88v, Assento nº 420"
                      className="w-full text-xs p-2 rounded bg-card border border-borda text-tinta focus:border-acento outline-hidden font-mono"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-semibold text-tinta mb-1">
                      Grau de Certeza Probatória
                    </label>
                    <select
                      value={confianca}
                      onChange={(e) => setConfianca(e.target.value as GrauConfianca)}
                      className="w-full text-xs p-2 rounded bg-card border border-borda text-tinta focus:border-acento outline-hidden"
                    >
                      <option value="alta">Certeza Alta (Fonte Primária Contemporânea)</option>
                      <option value="media">Certeza Média (Fonte Secundária / Censo)</option>
                      <option value="baixa">Certeza Baixa (Indireta / Tradição Oral)</option>
                      <option value="questionavel">Questionável / Em Investigação</option>
                    </select>
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-semibold text-tinta mb-1">
                    Transcrição Literal do Registro
                  </label>
                  <textarea
                    rows={3}
                    value={transcricao}
                    onChange={(e) => setTranscricao(e.target.value)}
                    placeholder="Copie trechos fiéis da certidão: 'Aos vinte e quatro dias do mês de março de mil oitocentos e...'"
                    className="w-full text-xs p-2 rounded bg-card border border-borda text-tinta focus:border-acento outline-hidden font-serif"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-tinta mb-1">
                    Anotação Genealógica
                  </label>
                  <input
                    type="text"
                    value={notaCitacao}
                    onChange={(e) => setNotaCitacao(e.target.value)}
                    placeholder="Ex.: Padrinhos de batismo confirmam parentesco com ramo materno."
                    className="w-full text-xs p-2 rounded bg-card border border-borda text-tinta focus:border-acento outline-hidden"
                  />
                </div>
              </div>

              <div className="flex items-center justify-end gap-2 pt-3 border-t border-borda">
                <Button
                  variant="secondary"
                  size="sm"
                  type="button"
                  onClick={() => setModalAberto(false)}
                >
                  Cancelar
                </Button>
                <Button variant="primary" size="sm" type="submit">
                  Salvar e Vincular
                </Button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
