/**
 * Resumo do perfil da pessoa selecionada para o painel lateral direito.
 *
 * Apresenta todas as informações básicas já salvas: foto, nome completo,
 * cidade natal/local de nascimento, país, datas vitais com idade, minibiografia,
 * pais, cônjuge(s) e filhos, com links para navegar na árvore e botões
 * diretos para editar a ficha completa ou gerenciar conexões.
 */

import {
  Calendar,
  ChevronRight,
  Crown,
  Globe,
  MapPin,
  Pencil,
  Sparkles,
  User,
  Users,
} from 'lucide-react';
import { IconeRelacoes } from '../../../components/icons';
import { Button } from '../../../components/ui/Button';
import { ImagemDoAcervo } from '../../../components/ui/ImagemDoAcervo';
import { usePessoa, useEventos, nacionalidades, usePaises } from '../hooks/useFicha';
import { formatarAno } from '../../../lib/tree/layout';
import { useI18n } from '../../../i18n/I18nContext';
import {
  conjugeDe,
  type PersonConnections,
  type PersonSummary,
  type UnionSummary,
} from '../../../types';

interface PerfilResumoPessoaProps {
  pessoaId: string;
  conexoes: PersonConnections;
  onSelecionarPessoa: (id: string) => void;
  onAbrirEdicao: (id: string) => void;
  onAlternarParaConexoes: () => void;
  onDefinirComoRaiz?: (id: string) => void;
  isRaizAtual?: boolean;
}

function faixaDeSexo(sexo: string): string {
  if (sexo === 'M') return 'bg-masc';
  if (sexo === 'F') return 'bg-fem';
  if (sexo === 'X') return 'bg-gradient-to-b from-masc to-fem';
  return 'bg-tinta3';
}

function FichaParente({
  pessoa,
  papel,
  onClick,
}: {
  pessoa: PersonSummary;
  papel: string;
  onClick: () => void;
}) {
  const nome = [pessoa.nome, pessoa.sobrenome].filter(Boolean).join(' ');
  const texto = pessoa.is_placeholder
    ? pessoa.sexo === 'F'
      ? 'Mãe Desconhecida'
      : 'Pai Desconhecido'
    : nome;

  return (
    <button
      type="button"
      onClick={onClick}
      className={`w-full text-left p-2 rounded-raio-s border transition-all flex items-center gap-2.5 ${
        pessoa.is_placeholder
          ? 'border-dashed border-borda2 bg-card/40 hover:border-acento cursor-pointer'
          : 'border-borda bg-card hover:border-acento hover:shadow-xs cursor-pointer'
      }`}
    >
      <div className={`w-1.5 self-stretch rounded-full flex-none ${faixaDeSexo(pessoa.sexo)}`} />
      <div className="flex-1 min-w-0">
        <span className="block text-[10px] uppercase font-bold text-tinta3 tracking-wider">
          {papel}
        </span>
        <span
          className={`block text-xs font-semibold truncate ${
            pessoa.is_placeholder ? 'text-tinta3 italic' : 'text-tinta'
          }`}
        >
          {texto}
        </span>
      </div>
      <ChevronRight className="w-3.5 h-3.5 text-tinta3 flex-none" />
    </button>
  );
}

export function PerfilResumoPessoa({
  pessoaId,
  conexoes,
  onSelecionarPessoa,
  onAbrirEdicao,
  onAlternarParaConexoes,
  onDefinirComoRaiz,
  isRaizAtual,
}: PerfilResumoPessoaProps) {
  const { t } = useI18n();
  const { data: pessoa, isLoading: carregandoPessoa } = usePessoa(pessoaId);
  const { data: eventos, isLoading: carregandoEventos } = useEventos(pessoaId);
  const { data: listaNacionalidades } = nacionalidades.useLista(pessoaId);
  const { data: paises } = usePaises();

  if (carregandoPessoa || carregandoEventos) {
    return (
      <div className="flex-1 p-4 flex flex-col items-center justify-center gap-2 text-tinta3 text-xs">
        <div className="w-5 h-5 border-2 border-acento border-t-transparent rounded-full animate-spin" />
        <span>{t('comum', 'carregando')}</span>
      </div>
    );
  }

  if (!pessoa) {
    return (
      <div className="flex-1 p-4 text-xs text-fem">
        Pessoa não encontrada no acervo.
      </div>
    );
  }

  const nomeCompleto = [pessoa.nome, pessoa.sobrenome].filter(Boolean).join(' ');

  // Dados vitais e eventos calculados a partir dos eventos registrados
  const nascEvento = eventos?.find((e) => e.tipo_evento === 'nascimento');
  const falecEvento = eventos?.find((e) => e.tipo_evento === 'falecimento');

  const anoNasc = nascEvento?.ano_inicio ?? null;
  const anoFalec = falecEvento?.ano_inicio ?? null;

  const anoNascFmt = anoNasc != null ? formatarAno(anoNasc) : null;
  const anoFalecFmt = anoFalec != null ? formatarAno(anoFalec) : null;

  let idadeAoFalecer =
    anoNasc != null && anoFalec != null ? anoFalec - anoNasc : null;
  if (anoNasc != null && anoFalec != null) {
    if (anoNasc < 0 && anoFalec > 0) {
      idadeAoFalecer = anoFalec - anoNasc - 1;
    } else if (anoNasc === 1 && anoFalec === 33) {
      idadeAoFalecer = 33;
    }
  }
  const idadeAtual =
    pessoa.is_vivo && anoNasc != null
      ? new Date().getFullYear() - anoNasc
      : null;

  const dataNascTexto = nascEvento?.data_texto || anoNascFmt;
  const localNascTexto = nascEvento?.local_nome;

  const dataFalecTexto = falecEvento?.data_texto || anoFalecFmt;
  const localFalecTexto = falecEvento?.local_nome;

  // Nacionalidades e Países
  const nomesPaises = listaNacionalidades
    ?.map((n) => paises?.find((p) => p.id === n.pais_id)?.nome)
    .filter(Boolean) as string[] | undefined;

  // Família
  const pai = conexoes.uniao_de_origem?.masculino;
  const mae = conexoes.uniao_de_origem?.feminino;
  const temPais = pai != null || mae != null;

  const unioes: UnionSummary[] = conexoes.unioes ?? [];
  const filhos: PersonSummary[] = unioes.flatMap((u: UnionSummary) => u.filhos);

  return (
    <div className="flex-1 overflow-y-auto min-h-0 p-3 flex flex-col gap-4">
      {/* 1. Cabeçalho de Identificação */}
      <div className="flex items-start gap-3 p-3 rounded-raio bg-card border border-borda shadow-xs">
        <div className="w-16 h-16 rounded-raio-s bg-chip flex-none grid place-items-center overflow-hidden border border-borda2 shadow-2xs">
          <ImagemDoAcervo
            caminhoRelativo={pessoa.foto_url}
            alt=""
            className="w-full h-full object-cover"
            alternativo={<User className="w-8 h-8 text-tinta3" />}
          />
        </div>

        <div className="flex-1 min-w-0 flex flex-col gap-1">
          <div className="flex items-center gap-1.5 flex-wrap">
            {isRaizAtual && (
              <span className="inline-flex items-center gap-1 text-[9.5px] font-bold px-1.5 py-0.2 rounded bg-amber-500/15 text-amber-900 dark:text-amber-200 border border-amber-500/30">
                <Crown className="w-2.5 h-2.5" /> Raiz
              </span>
            )}
            {pessoa.categoria && (
              <span className="text-[9.5px] font-semibold px-1.5 py-0.2 rounded bg-sup text-tinta2 border border-borda">
                {pessoa.categoria}
              </span>
            )}
            {pessoa.is_publico && (
              <span className="text-[9px] font-semibold px-1 py-0.2 rounded bg-sup text-tinta3 border border-borda/60">
                Público
              </span>
            )}
          </div>

          <h3 className="font-tit font-bold text-base text-tinta leading-snug m-0 break-words">
            {nomeCompleto || 'Sem nome'}
          </h3>

          <div className="flex items-center gap-1.5 text-xs text-tinta2 font-num font-medium">
            <span>
              {anoNascFmt ? `★ ${anoNascFmt}` : '★ s/d'}
              {anoFalecFmt ? ` · ✝ ${anoFalecFmt}` : pessoa.is_vivo ? ' (vivo)' : ' · ✝'}
            </span>
            {idadeAoFalecer != null && (
              <span className="text-tinta3 font-normal">({idadeAoFalecer} anos)</span>
            )}
            {idadeAtual != null && (
              <span className="text-emerald-700 dark:text-emerald-400 font-bold font-sans text-[11px]">
                ({idadeAtual} anos)
              </span>
            )}
          </div>
        </div>
      </div>

      {/* 2. Dados Vitais e Origem (Locais e Datas Salvas) */}
      <div className="flex flex-col gap-2 p-3 rounded-raio bg-card border border-borda shadow-xs text-xs">
        <span className="text-[10.5px] uppercase font-bold text-tinta3 tracking-wider flex items-center gap-1">
          <Calendar className="w-3 h-3 text-acento" /> {t('perfil', 'dadosVitais')}
        </span>

        {/* Nascimento */}
        <div className="flex flex-col gap-0.5 border-b border-borda/50 pb-2">
          <span className="text-[11px] font-semibold text-tinta flex items-center gap-1.5">
            <span className="w-1.5 h-1.5 rounded-full bg-emerald-600" /> {t('perfil', 'nascimento')}:
          </span>
          <span className="text-tinta2 pl-3">
            {dataNascTexto ? dataNascTexto : t('perfil', 'dataNaoInformada')}
          </span>
          {localNascTexto ? (
            <span className="text-tinta font-medium pl-3 flex items-center gap-1 text-[11.5px] mt-0.5 break-words">
              <MapPin className="w-3 h-3 text-acento flex-none" />
              <span>{localNascTexto}</span>
            </span>
          ) : (
            <span className="text-tinta3 italic pl-3 text-[11px]">
              {t('perfil', 'cidadeNatalNaoRegistrada')}
            </span>
          )}
        </div>

        {/* Falecimento ou Estado */}
        <div className="flex flex-col gap-0.5 border-b border-borda/50 pb-2">
          <span className="text-[11px] font-semibold text-tinta flex items-center gap-1.5">
            <span className="w-1.5 h-1.5 rounded-full bg-tinta3" /> {t('perfil', 'falecimento')}:
          </span>
          {pessoa.is_vivo ? (
            <span className="text-emerald-700 dark:text-emerald-400 font-semibold pl-3">
              {t('perfil', 'pessoaViva')} {idadeAtual != null ? `(${idadeAtual} ${t('arvore', 'anos')})` : ''}
            </span>
          ) : (
            <>
              <span className="text-tinta2 pl-3">
                {dataFalecTexto ? dataFalecTexto : t('perfil', 'dataNaoInformada')}
                {idadeAoFalecer != null ? ` — aos ${idadeAoFalecer} ${t('arvore', 'anos')}` : ''}
              </span>
              {localFalecTexto && (
                <span className="text-tinta font-medium pl-3 flex items-center gap-1 text-[11.5px] mt-0.5 break-words">
                  <MapPin className="w-3 h-3 text-acento flex-none" />
                  <span>{localFalecTexto}</span>
                </span>
              )}
            </>
          )}
        </div>

        {/* Nacionalidade / Países */}
        {nomesPaises && nomesPaises.length > 0 && (
          <div className="flex items-center gap-1.5 pt-0.5 text-[11.5px] flex-wrap">
            <Globe className="w-3 h-3 text-acento flex-none" />
            <span className="font-semibold text-tinta">{t('perfil', 'paisNacionalidade')}:</span>
            <span className="text-tinta2">{nomesPaises.join(', ')}</span>
          </div>
        )}
      </div>

      {/* 3. Minibiografia */}
      <div className="flex flex-col gap-1.5 p-3 rounded-raio bg-card border border-borda shadow-xs text-xs">
        <div className="flex items-center justify-between">
          <span className="text-[10.5px] uppercase font-bold text-tinta3 tracking-wider flex items-center gap-1">
            <Sparkles className="w-3 h-3 text-acento" /> {t('perfil', 'minibiografia')}
          </span>
          {!pessoa.minibiografia && (
            <button
              type="button"
              onClick={() => onAbrirEdicao(pessoaId)}
              className="text-[10.5px] text-acento hover:underline font-semibold cursor-pointer"
            >
              {t('perfil', 'adicionarMinibiografia')}
            </button>
          )}
        </div>

        {pessoa.minibiografia ? (
          <div className="text-tinta text-[11.5px] leading-relaxed font-sans whitespace-pre-wrap select-text bg-sup/40 p-2.5 rounded-raio-s border border-borda/60 max-h-48 overflow-y-auto">
            {pessoa.minibiografia}
          </div>
        ) : (
          <p className="text-tinta3 italic text-[11px] m-0">
            {t('perfil', 'semMinibiografia')}
          </p>
        )}
      </div>

      {/* 4. Família Imediata (Resumo com Links Clicáveis) */}
      <div className="flex flex-col gap-2.5 p-3 rounded-raio bg-card border border-borda shadow-xs text-xs">
        <div className="flex items-center justify-between">
          <span className="text-[10.5px] uppercase font-bold text-tinta3 tracking-wider flex items-center gap-1">
            <Users className="w-3 h-3 text-acento" /> {t('perfil', 'familiaRegistrada')}
          </span>
          <button
            type="button"
            onClick={onAlternarParaConexoes}
            className="text-[10.5px] text-acento hover:underline font-semibold cursor-pointer"
          >
            {t('perfil', 'gerenciar')}
          </button>
        </div>

        {/* Pais */}
        <div className="flex flex-col gap-1.5">
          <span className="text-[10.5px] font-semibold text-tinta">{t('perfil', 'pais')}:</span>
          {temPais ? (
            <div className="flex flex-col gap-1">
              {pai && <FichaParente pessoa={pai} papel={t('perfil', 'pai')} onClick={() => onSelecionarPessoa(pai.id)} />}
              {mae && <FichaParente pessoa={mae} papel={t('perfil', 'mae')} onClick={() => onSelecionarPessoa(mae.id)} />}
            </div>
          ) : (
            <div className="flex items-center justify-between p-2 rounded-raio-s bg-sup/40 border border-dashed border-borda text-[11px] text-tinta3">
              <span>{t('perfil', 'paisNaoCadastrados')}</span>
              <button
                type="button"
                onClick={onAlternarParaConexoes}
                className="text-acento font-semibold hover:underline cursor-pointer"
              >
                {t('perfil', 'adicionarPais')}
              </button>
            </div>
          )}
        </div>

        {/* Cônjuge(s) */}
        <div className="flex flex-col gap-1.5 pt-1 border-t border-borda/40">
          <span className="text-[10.5px] font-semibold text-tinta">{t('perfil', 'conjuges')}:</span>
          {unioes.length > 0 ? (
            <div className="flex flex-col gap-1">
              {unioes.map((u: UnionSummary) => {
                const conj = conjugeDe(u);
                if (!conj) return null;
                const papel =
                  conj.sexo === 'M' ? t('perfil', 'marido') : conj.sexo === 'F' ? t('perfil', 'esposa') : t('perfil', 'conjuges');
                return (
                  <FichaParente
                    key={u.id}
                    pessoa={conj}
                    papel={papel}
                    onClick={() => onSelecionarPessoa(conj.id)}
                  />
                );
              })}
            </div>
          ) : (
            <div className="flex items-center justify-between p-2 rounded-raio-s bg-sup/40 border border-dashed border-borda text-[11px] text-tinta3">
              <span>{t('perfil', 'semConjuge')}</span>
              <button
                type="button"
                onClick={onAlternarParaConexoes}
                className="text-acento font-semibold hover:underline cursor-pointer"
              >
                {t('perfil', 'adicionarConjuge')}
              </button>
            </div>
          )}
        </div>

        {/* Filhos */}
        <div className="flex flex-col gap-1.5 pt-1 border-t border-borda/40">
          <div className="flex items-center justify-between">
            <span className="text-[10.5px] font-semibold text-tinta">
              {t('perfil', 'filhos')} ({filhos.length}):
            </span>
          </div>
          {filhos.length > 0 ? (
            <div className="flex flex-col gap-1 max-h-44 overflow-y-auto pr-0.5">
              {filhos.map((filho: PersonSummary) => (
                <FichaParente
                  key={filho.id}
                  pessoa={filho}
                  papel={filho.sexo === 'F' ? t('perfil', 'filha') : t('perfil', 'filho')}
                  onClick={() => onSelecionarPessoa(filho.id)}
                />
              ))}
            </div>
          ) : (
            <div className="flex items-center justify-between p-2 rounded-raio-s bg-sup/40 border border-dashed border-borda text-[11px] text-tinta3">
              <span>{t('perfil', 'semFilhos')}</span>
              <button
                type="button"
                onClick={onAlternarParaConexoes}
                className="text-acento font-semibold hover:underline cursor-pointer"
              >
                {t('perfil', 'adicionarFilho')}
              </button>
            </div>
          )}
        </div>
      </div>

      {/* 5. Ações da Ficha */}
      <div className="flex flex-col gap-2 pt-2 border-t border-borda">
        <Button
          variant="primary"
          size="sm"
          className="w-full flex items-center justify-center gap-1.5 font-bold shadow-xs py-2 cursor-pointer"
          onClick={() => onAbrirEdicao(pessoaId)}
        >
          <Pencil className="w-4 h-4" />
          <span>{t('perfil', 'editarFichaCompleta')}</span>
        </Button>

        <Button
          variant="outline"
          size="sm"
          className="w-full flex items-center justify-center gap-1.5 text-tinta font-semibold py-2 cursor-pointer"
          onClick={onAlternarParaConexoes}
        >
          <IconeRelacoes className="w-4 h-4 text-acento" />
          <span>{t('perfil', 'gerenciarConexoesFamiliares')}</span>
        </Button>

        {onDefinirComoRaiz && !isRaizAtual && (
          <Button
            variant="outline"
            size="sm"
            className="w-full flex items-center justify-center gap-1.5 text-xs text-tinta2 hover:text-tinta cursor-pointer"
            onClick={() => onDefinirComoRaiz(pessoaId)}
          >
            <Crown className="w-3.5 h-3.5 text-amber-600" />
            <span>{t('perfil', 'tornarRaizDaArvore')}</span>
          </Button>
        )}
      </div>
    </div>
  );
}
