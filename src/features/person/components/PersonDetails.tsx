import { useState, useEffect } from 'react';
import {
  X,
  Users,
  Pencil,
  Clock,
  Briefcase,
  ImagePlus,
  UserCheck,
  Globe,
  Compass,
} from 'lucide-react';
import { IconeArvore, IconeRelacoes } from '../../../components/icons';
import { Button } from '../../../components/ui/Button';
import { FotoPerfilPessoa } from './FotoPerfilPessoa';
import { useI18n } from '../../../i18n/I18nContext';
import { obterRotuloNacionalidade } from '../taxonomias';
import {
  usePessoa,
  useEventos,
  useParticipacoesPessoa,
  useNomes,
  useDocumentos,
  apelidos,
  profissoes,
  escolaridade,
  nacionalidades,
  idiomas,
  religioes,
} from '../hooks/useFicha';
import { useTrajetoriaPessoa } from '../hooks/useTrajetoria';
import { useConexoes } from '../../union/hooks/useConexoes';
import { AbaVisaoGeral } from './AbaVisaoGeral';
import { AbaLinhaTempo } from './AbaLinhaTempo';
import { AbaTrajetoria } from './AbaTrajetoria';
import { AbaGaleria } from './AbaGaleria';
import { MapaTrajetoriaVida } from './MapaTrajetoriaVida';
import { ModalEditarIdentidade } from './ModalEditarIdentidade';
import { ModalAdicionarEventoVida } from '../../timeline/components/ModalAdicionarEventoVida';
import { ErroDoAcervo } from '../../../lib/api';

interface PersonDetailsProps {
  pessoaId: string;
  onFechar: () => void;
  onDefinirComoRaiz?: (pessoaId: string) => void;
  onCalcularParentesco?: (pessoaId: string) => void;
  onFundirPessoa?: (pessoaId: string) => void;
  isRaizAtual?: boolean;
}

type AbaTipo = 'visao_geral' | 'linha_tempo' | 'mapa' | 'trajetoria' | 'galeria';

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo || erro instanceof Error) return erro.message;
  return String(erro);
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
  const [idPessoaAtiva, setIdPessoaAtiva] = useState(pessoaId);
  const [abaAtiva, setAbaAtiva] = useState<AbaTipo>('visao_geral');
  const [eventoFocoMapaId, setEventoFocoMapaId] = useState<string | null>(null);

  const handleIrParaMapa = (eventoId?: string) => {
    setEventoFocoMapaId(eventoId ?? null);
    setAbaAtiva('mapa');
  };

  // Modais auxiliares
  const [modalEditarAberto, setModalEditarAberto] = useState(false);
  const [modalVincularMarcoAberto, setModalVincularMarcoAberto] = useState(false);
  const [formularioNovoEventoAberto, setFormularioNovoEventoAberto] = useState(false);

  // Sincroniza se a prop mudar
  useEffect(() => {
    setIdPessoaAtiva(pessoaId);
    setEventoFocoMapaId(null);
  }, [pessoaId]);

  // Queries de dados
  const { data: pessoa, isLoading, error } = usePessoa(idPessoaAtiva);
  const { data: eventos } = useEventos(idPessoaAtiva);
  const { data: participacoes } = useParticipacoesPessoa(idPessoaAtiva);
  const { data: conexoes } = useConexoes(idPessoaAtiva);
  const { data: trajetoria } = useTrajetoriaPessoa(idPessoaAtiva);
  const listaNomes = useNomes(idPessoaAtiva);
  const listaApelidos = apelidos.useLista(idPessoaAtiva);
  const listaDocumentos = useDocumentos(idPessoaAtiva);

  // Atributos para contadores
  const listaProfissoes = profissoes.useLista(idPessoaAtiva);
  const listaEscolaridade = escolaridade.useLista(idPessoaAtiva);
  const listaNacionalidades = nacionalidades.useLista(idPessoaAtiva);
  const listaIdiomas = idiomas.useLista(idPessoaAtiva);
  const listaReligioes = religioes.useLista(idPessoaAtiva);

  if (isLoading) {
    return (
      <div className="p-12 text-center text-sm text-tinta3">
        {t('perfil', 'carregandoPessoa')}
      </div>
    );
  }

  if (error || !pessoa) {
    return (
      <div className="p-12 text-center text-sm text-fem">
        {mensagemDeErro(error) ?? t('perfil', 'erroCarregarPessoa')}
      </div>
    );
  }

  const nomeCompleto = [pessoa.nome, pessoa.sobrenome].filter(Boolean).join(' ');

  // Cálculo da Linha Vital
  const eventoNasc = (eventos ?? []).find((e) => e.tipo_evento === 'nascimento');
  const eventoObito = (eventos ?? []).find((e) => e.tipo_evento === 'falecimento');
  const anoNasc = eventoNasc?.ano_inicio;
  const anoObito = eventoObito?.ano_inicio;
  const localNasc = eventoNasc?.rotulo_historico_livre || eventoNasc?.local_nome;
  const localObito = eventoObito?.rotulo_historico_livre || eventoObito?.local_nome;

  let resumoVital = '';
  if (anoNasc && anoObito) {
    const idade = Math.max(0, anoObito - anoNasc);
    resumoVital = `* ${anoNasc}${localNasc ? ` (${localNasc})` : ''} — † ${anoObito}${localObito ? ` (${localObito})` : ''} · ${idade} ${t('arvore', 'anos')}`;
  } else if (anoNasc && pessoa.is_vivo) {
    const anoAtual = new Date().getFullYear();
    const idade = Math.max(0, anoAtual - anoNasc);
    resumoVital = `* ${anoNasc}${localNasc ? ` (${localNasc})` : ''} · ${idade} ${t('arvore', 'anos')} (${t('perfil', 'pessoaViva')})`;
  } else if (anoNasc) {
    resumoVital = `* ${anoNasc}${localNasc ? ` (${localNasc})` : ''}`;
  } else if (anoObito) {
    resumoVital = `† ${anoObito}${localObito ? ` (${localObito})` : ''}`;
  } else {
    resumoVital = pessoa.is_vivo
      ? t('perfil', 'pessoaViva')
      : pessoa.sexo === 'F'
      ? t('ficha', 'falecida')
      : t('ficha', 'falecido');
  }

  // Determina a nacionalidade de nascimento
  const primeiraNacId = listaNacionalidades.data?.[0]?.pais_id;
  const ehNascBrasil =
    eventoNasc?.local_nome?.includes(', ') ||
    eventoNasc?.rotulo_historico_livre?.toLowerCase().includes('brasil');
  const nacIdEfetivo = primeiraNacId || (ehNascBrasil ? 'br' : null);
  const infoNacionalidade = obterRotuloNacionalidade(nacIdEfetivo, pessoa.sexo);

  const totalAtributos =
    (listaProfissoes.data?.length ?? 0) +
    (listaEscolaridade.data?.length ?? 0) +
    (listaNacionalidades.data?.length ?? 0) +
    (listaIdiomas.data?.length ?? 0) +
    (listaReligioes.data?.length ?? 0);

  const totalMarcosCronologicos = (eventos?.length ?? 0) + (participacoes?.length ?? 0);

  return (
    <div className="flex flex-col h-full overflow-hidden bg-bg">
      {/* ---------------- HERO HEADER (Fixo no Topo) ---------------- */}
      <header className="flex items-start gap-4 p-4 border-b border-borda bg-card2 flex-none">
        <FotoPerfilPessoa
          pessoaId={idPessoaAtiva}
          fotoUrl={pessoa.foto_url}
          nome={nomeCompleto}
          tamanho="lg"
          mostrarBotaoTexto={true}
        />

        <div className="flex-1 min-w-0 flex flex-col gap-2">
          <div className="flex items-center gap-2.5 flex-wrap">
            <h2 className="font-tit font-bold text-xl md:text-2xl text-tinta m-0 truncate">
              {nomeCompleto}
            </h2>

            {/* Badge de Sexo */}
            {pessoa.sexo === 'M' ? (
              <span className="px-3 py-1 text-xs sm:text-[13px] font-semibold rounded-full bg-masc/15 text-masc border border-masc/40 flex items-center gap-1.5 select-none shadow-2xs">
                <span className="text-sm font-bold">♂</span> {t('ficha', 'masculino')}
              </span>
            ) : (
              <span className="px-3 py-1 text-xs sm:text-[13px] font-semibold rounded-full bg-fem/15 text-fem border border-fem/40 flex items-center gap-1.5 select-none shadow-2xs">
                <span className="text-sm font-bold">♀</span> {t('ficha', 'feminino')}
              </span>
            )}

            {/* Badge Vivo / Falecido (clicável para alterar rápido) */}
            <button
              type="button"
              onClick={() => setModalEditarAberto(true)}
              title="Clique para alterar a situação vital (viva ou falecida)"
              className={`px-3 py-1 text-xs sm:text-[13px] font-semibold rounded-full border flex items-center gap-1.5 select-none cursor-pointer transition-all hover:scale-105 active:scale-95 shadow-2xs ${
                pessoa.is_vivo
                  ? 'bg-emerald-500/15 text-emerald-800 dark:text-emerald-200 border-emerald-500/40 hover:bg-emerald-500/25'
                  : 'bg-stone-500/15 text-stone-800 dark:text-stone-200 border-stone-500/40 hover:bg-stone-500/25'
              }`}
            >
              <span className="text-sm">{pessoa.is_vivo ? '🌱' : '🕊️'}</span>
              <span>{pessoa.is_vivo ? t('ficha', 'viva') : pessoa.sexo === 'F' ? t('ficha', 'falecida') : t('ficha', 'falecido')}</span>
              <Pencil className="w-3 h-3 opacity-60 ml-0.5" />
            </button>

            {/* Badge de Nacionalidade de Nascimento */}
            {infoNacionalidade ? (
              <button
                type="button"
                onClick={() => setAbaAtiva('trajetoria')}
                title={`Nacionalidade de nascimento: ${infoNacionalidade.texto}. Clique para gerenciar.`}
                className="px-3 py-1 text-xs sm:text-[13px] font-semibold rounded-full bg-amber-500/15 text-amber-900 dark:text-amber-200 border border-amber-500/40 hover:bg-amber-500/25 flex items-center gap-1.5 select-none shadow-2xs cursor-pointer transition-all hover:scale-105 active:scale-95"
              >
                <span className="text-sm">{infoNacionalidade.flag}</span>
                <span>{infoNacionalidade.texto}</span>
              </button>
            ) : (
              <button
                type="button"
                onClick={() => setAbaAtiva('trajetoria')}
                className="px-2.5 py-1 text-xs font-medium rounded-full bg-sup hover:bg-card text-tinta3 hover:text-tinta border border-dashed border-borda hover:border-acento transition-all flex items-center gap-1 cursor-pointer shadow-2xs"
                title="Adicionar nacionalidade de nascimento"
              >
                <Globe className="w-3.5 h-3.5 text-acento/70" />
                <span>{t('perfil', 'adicionarNacionalidade')}</span>
              </button>
            )}

            {/* Badge Cronologia */}
            {pessoa.tipo_tempo === 'ficticio' ? (
              <span className="px-3 py-1 text-xs sm:text-[13px] font-bold rounded-full bg-purple-500/15 text-purple-800 dark:text-purple-200 border border-purple-500/40 flex items-center gap-1.5 select-none shadow-2xs">
                <span className="text-sm">✨</span> {t('perfil', 'tempoFicticio')}
              </span>
            ) : (
              <span className="px-3 py-1 text-xs sm:text-[13px] font-medium rounded-full bg-sky-500/15 text-sky-800 dark:text-sky-200 border border-sky-500/40 flex items-center gap-1.5 select-none shadow-2xs">
                <span className="text-sm">🌍</span> {t('perfil', 'tempoReal')}
              </span>
            )}
          </div>

          {/* Subtítulo Vital Calculado */}
          <p className="font-num text-sm font-medium text-tinta2 m-0 flex items-center gap-1.5 truncate mt-0.5">
            {resumoVital}
          </p>
        </div>

        {/* Ações Rápidas no Canto Superior */}
        <div className="flex items-center gap-1.5 flex-wrap justify-end ml-2 flex-none">
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() => setModalEditarAberto(true)}
            className="text-xs font-semibold text-tinta border-borda2 hover:bg-sup cursor-pointer shadow-2xs"
            title="Editar dados básicos de identidade e biografia"
          >
            <Pencil className="w-3.5 h-3.5 text-acento" />
            {t('comum', 'editar')}
          </Button>

          {onCalcularParentesco && (
            <button
              type="button"
              onClick={() => onCalcularParentesco(idPessoaAtiva)}
              className="px-2.5 py-1 text-xs font-semibold rounded-raio-s border border-borda2 bg-card text-tinta hover:bg-sup transition-colors flex items-center gap-1.5 cursor-pointer shadow-2xs"
              title={t('topo', 'parentescoDesc')}
            >
              <IconeRelacoes className="w-3.5 h-3.5 text-acento" />
              <span className="hidden sm:inline">{t('topo', 'parentesco')}</span>
            </button>
          )}

          {onFundirPessoa && (
            <button
              type="button"
              onClick={() => onFundirPessoa(idPessoaAtiva)}
              className="px-2.5 py-1 text-xs font-semibold rounded-raio-s border border-borda2 bg-card text-tinta hover:bg-sup transition-colors flex items-center gap-1.5 cursor-pointer shadow-2xs"
              title="Fundir ou mesclar este registro com outro duplicado"
            >
              <Users className="w-3.5 h-3.5 text-acento" />
              <span className="hidden sm:inline">{t('topo', 'mesclarPessoas')}</span>
            </button>
          )}

          {onDefinirComoRaiz && (
            <button
              type="button"
              onClick={() => onDefinirComoRaiz(idPessoaAtiva)}
              disabled={isRaizAtual}
              className={`px-2.5 py-1 text-xs font-semibold rounded-raio-s border transition-colors flex items-center gap-1.5 ${
                isRaizAtual
                  ? 'bg-sup text-tinta3 border-borda cursor-default'
                  : 'bg-card text-tinta hover:bg-sup border-borda2 cursor-pointer shadow-2xs'
              }`}
              title={
                isRaizAtual
                  ? 'Esta pessoa já é o foco da árvore ativa'
                  : 'Focar a árvore genealógica nesta pessoa'
              }
            >
              <IconeArvore className="w-3.5 h-3.5 text-acento" />
              <span className="hidden sm:inline">
                {isRaizAtual ? t('arvore', 'raizAtual') : t('arvore', 'definirComoRaiz')}
              </span>
            </button>
          )}

          <button
            type="button"
            onClick={onFechar}
            aria-label={t('comum', 'fechar')}
            className="text-tinta3 hover:text-tinta p-1 rounded-raio-s hover:bg-sup transition-colors flex-none cursor-pointer border-none bg-transparent"
          >
            <X className="w-5 h-5" />
          </button>
        </div>
      </header>

      {/* ---------------- TAB BAR (Navegação em Abas) ---------------- */}
      <nav className="flex-none px-4 py-2 border-b border-borda/60 bg-card flex items-center gap-2 overflow-x-auto select-none">
        <button
          type="button"
          onClick={() => setAbaAtiva('visao_geral')}
          className={`px-3 py-1.5 rounded-raio-s text-xs font-semibold transition-all flex items-center gap-1.5 cursor-pointer border ${
            abaAtiva === 'visao_geral'
              ? 'bg-acento text-acento-tinta border-acento shadow-xs'
              : 'bg-sup/40 text-tinta2 hover:text-tinta hover:bg-sup border-borda/60'
          }`}
        >
          <UserCheck className="w-3.5 h-3.5" />
          <span>{t('perfil', 'abaVisaoGeral')}</span>
        </button>

        <button
          type="button"
          onClick={() => setAbaAtiva('linha_tempo')}
          className={`px-3 py-1.5 rounded-raio-s text-xs font-semibold transition-all flex items-center gap-1.5 cursor-pointer border ${
            abaAtiva === 'linha_tempo'
              ? 'bg-acento text-acento-tinta border-acento shadow-xs'
              : 'bg-sup/40 text-tinta2 hover:text-tinta hover:bg-sup border-borda/60'
          }`}
        >
          <Clock className="w-3.5 h-3.5" />
          <span>{t('perfil', 'abaLinhaTempo')}</span>
          {totalMarcosCronologicos > 0 && (
            <span
              className={`text-[10px] font-num px-1.5 py-0.2 rounded-full ${
                abaAtiva === 'linha_tempo'
                  ? 'bg-black/20 text-white'
                  : 'bg-acento/10 text-acento'
              }`}
            >
              {totalMarcosCronologicos}
            </span>
          )}
        </button>

        <button
          type="button"
          onClick={() => handleIrParaMapa()}
          className={`px-3 py-1.5 rounded-raio-s text-xs font-semibold transition-all flex items-center gap-1.5 cursor-pointer border ${
            abaAtiva === 'mapa'
              ? 'bg-acento text-acento-tinta border-acento shadow-xs'
              : 'bg-sup/40 text-tinta2 hover:text-tinta hover:bg-sup border-borda/60'
          }`}
        >
          <Compass className="w-3.5 h-3.5" />
          <span>{t('perfil', 'abaMapa')}</span>
          {(trajetoria?.total_pontos ?? 0) > 0 && (
            <span
              className={`text-[10px] font-num px-1.5 py-0.2 rounded-full ${
                abaAtiva === 'mapa'
                  ? 'bg-black/20 text-white'
                  : 'bg-acento/10 text-acento'
              }`}
            >
              {trajetoria?.total_pontos}
            </span>
          )}
        </button>

        <button
          type="button"
          onClick={() => setAbaAtiva('trajetoria')}
          className={`px-3 py-1.5 rounded-raio-s text-xs font-semibold transition-all flex items-center gap-1.5 cursor-pointer border ${
            abaAtiva === 'trajetoria'
              ? 'bg-acento text-acento-tinta border-acento shadow-xs'
              : 'bg-sup/40 text-tinta2 hover:text-tinta hover:bg-sup border-borda/60'
          }`}
        >
          <Briefcase className="w-3.5 h-3.5" />
          <span>{t('perfil', 'abaTrajetoria')}</span>
          {totalAtributos > 0 && (
            <span
              className={`text-[10px] font-num px-1.5 py-0.2 rounded-full ${
                abaAtiva === 'trajetoria'
                  ? 'bg-black/20 text-white'
                  : 'bg-acento/10 text-acento'
              }`}
            >
              {totalAtributos}
            </span>
          )}
        </button>

        <button
          type="button"
          onClick={() => setAbaAtiva('galeria')}
          className={`px-3 py-1.5 rounded-raio-s text-xs font-semibold transition-all flex items-center gap-1.5 cursor-pointer border ${
            abaAtiva === 'galeria'
              ? 'bg-acento text-acento-tinta border-acento shadow-xs'
              : 'bg-sup/40 text-tinta2 hover:text-tinta hover:bg-sup border-borda/60'
          }`}
        >
          <ImagePlus className="w-3.5 h-3.5" />
          <span>{t('perfil', 'abaGaleria')}</span>
          {(listaDocumentos.data?.length ?? 0) > 0 && (
            <span
              className={`text-[10px] font-num px-1.5 py-0.2 rounded-full ${
                abaAtiva === 'galeria'
                  ? 'bg-black/20 text-white'
                  : 'bg-acento/10 text-acento'
              }`}
            >
              {listaDocumentos.data?.length}
            </span>
          )}
        </button>
      </nav>

      {/* ---------------- CORPO DAS ABAS (Scroll Suave) ---------------- */}
      <div className="flex-1 overflow-y-auto min-h-0 p-4">
        {abaAtiva === 'visao_geral' && (
          <AbaVisaoGeral
            pessoa={pessoa}
            eventos={eventos ?? []}
            nomes={listaNomes.data ?? []}
            apelidos={listaApelidos.data ?? []}
            conexoes={conexoes}
            nacionalidadesLista={listaNacionalidades.data ?? []}
            onAbrirEditarIdentidade={() => setModalEditarAberto(true)}
            onNavegarParaPessoa={(id) => setIdPessoaAtiva(id)}
            onAdicionarEvento={() => {
              setFormularioNovoEventoAberto(true);
              setAbaAtiva('linha_tempo');
            }}
            onIrParaLinhaTempo={() => setAbaAtiva('linha_tempo')}
            onIrParaTrajetoria={() => setAbaAtiva('trajetoria')}
            onIrParaMapa={(eventoId) => handleIrParaMapa(eventoId)}
          />
        )}

        {abaAtiva === 'linha_tempo' && (
          <AbaLinhaTempo
            pessoaId={idPessoaAtiva}
            nomePessoa={nomeCompleto}
            eventos={eventos ?? []}
            onAbrirVincularMarco={() => setModalVincularMarcoAberto(true)}
            formularioCriarAberto={formularioNovoEventoAberto}
            onAlternarFormularioCriar={() => setFormularioNovoEventoAberto((a) => !a)}
            onVerNoMapa={(eventoId) => handleIrParaMapa(eventoId)}
          />
        )}

        {abaAtiva === 'mapa' && (
          <MapaTrajetoriaVida
            pessoaId={idPessoaAtiva}
            nomePessoa={nomeCompleto}
            eventoInicialId={eventoFocoMapaId ?? undefined}
          />
        )}

        {abaAtiva === 'trajetoria' && <AbaTrajetoria pessoaId={idPessoaAtiva} />}

        {abaAtiva === 'galeria' && <AbaGaleria pessoa={pessoa} />}
      </div>

      {/* ---------------- Modais e Formulários Flutuantes ---------------- */}
      {modalEditarAberto && (
        <ModalEditarIdentidade
          pessoa={pessoa}
          aberto={modalEditarAberto}
          aoFechar={() => setModalEditarAberto(false)}
        />
      )}

      {modalVincularMarcoAberto && (
        <ModalAdicionarEventoVida
          aberto={modalVincularMarcoAberto}
          aoFechar={() => setModalVincularMarcoAberto(false)}
          pessoaIdInicial={idPessoaAtiva}
        />
      )}
    </div>
  );
}
