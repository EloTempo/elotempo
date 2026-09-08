import { useState, useMemo } from 'react';
import { useQuery } from '@tanstack/react-query';
import {
  BarChart3,
  Calendar,
  CheckCircle2,
  GraduationCap,
  Heart,
  MapPin,
  PieChart,
  RefreshCw,
  Scale,
  Sparkles,
  Users,
} from 'lucide-react';
import { IconeArvore } from '../../../components/icons';
import { GraficoRosca } from '../../../components/charts/GraficoRosca';
import { GraficoBarras } from '../../../components/charts/GraficoBarras';
import { SeletorArvoreEstatistica } from './SeletorArvoreEstatistica';
import { calcularEstatisticas, listarArvores, type FiltrosBusca } from '../../../lib/api';
import { useI18n } from '../../../i18n/I18nContext';

interface PainelEstatisticasProps {
  filtros?: FiltrosBusca;
  onLimparFiltros?: () => void;
  filtrosAtivosCount?: number;
  className?: string;
}

type SecaoEstatistica = 'geral' | 'decadas' | 'sobrenomes' | 'locais' | 'cultural';

export function PainelEstatisticas({
  filtros,
  onLimparFiltros,
  filtrosAtivosCount = 0,
  className = '',
}: PainelEstatisticasProps) {
  const { t } = useI18n();
  const [secaoAtiva, setSecaoAtiva] = useState<SecaoEstatistica>('geral');
  const [arvoreIdFiltro, setArvoreIdFiltro] = useState<string | null>(filtros?.arvore_id ?? null);
  const [modoComparacao, setModoComparacao] = useState(false);
  const [arvoreComparacaoId, setArvoreComparacaoId] = useState<string | null>(null);

  const { data: arvores } = useQuery({
    queryKey: ['arvores'],
    queryFn: listarArvores,
    staleTime: 60_000,
  });

  const filtrosEfetivos: FiltrosBusca = {
    ...filtros,
    arvore_id: arvoreIdFiltro ?? undefined,
    incluir_placeholders: filtros?.incluir_placeholders ?? false,
  };

  const { data: stats, isLoading, error } = useQuery({
    queryKey: ['estatisticas-acervo', filtrosEfetivos],
    queryFn: () => calcularEstatisticas(filtrosEfetivos),
    staleTime: 30_000,
  });

  // Query secundária para a árvore de comparação
  const { data: statsB } = useQuery({
    queryKey: ['estatisticas-comparacao', arvoreComparacaoId],
    queryFn: () => calcularEstatisticas({ arvore_id: arvoreComparacaoId, incluir_placeholders: false }),
    enabled: modoComparacao && !!arvoreComparacaoId,
    staleTime: 30_000,
  });

  // Destaques e cálculos para o Dashboard
  const destaques = useMemo(() => {
    if (!stats) return null;

    // Gênero predominante
    const fem = stats.distribuicao_sexo.find((s) => s.chave.toLowerCase().includes('fem'))?.contagem ?? 0;
    const masc = stats.distribuicao_sexo.find((s) => s.chave.toLowerCase().includes('masc'))?.contagem ?? 0;
    let generoDestaque = t('estatisticasModal', 'equilibrado');
    if (fem > masc) {
      generoDestaque = `${t('estatisticasModal', 'predominioFeminino')} (${Math.round((fem / (stats.total_pessoas || 1)) * 100)}%)`;
    } else if (masc > fem) {
      generoDestaque = `${t('estatisticasModal', 'predominioMasculino')} (${Math.round((masc / (stats.total_pessoas || 1)) * 100)}%)`;
    }

    // Sobrenome mais frequente
    const topSobrenome = stats.distribuicao_sobrenomes[0] ?? null;

    // Década pico de nascimentos
    const topDecada = [...stats.distribuicao_decadas].sort((a, b) => b.contagem - a.contagem)[0] ?? null;

    // Porcentagem de vivas / falecidas
    const pctVivas = Math.round((stats.total_vivas / (stats.total_pessoas || 1)) * 100);
    const pctFalecidas = Math.round((stats.total_falecidas / (stats.total_pessoas || 1)) * 100);
    const pctNascimento = Math.round((stats.total_com_nascimento / (stats.total_pessoas || 1)) * 100);

    return {
      generoDestaque,
      topSobrenome,
      topDecada,
      pctVivas,
      pctFalecidas,
      pctNascimento,
    };
  }, [stats, t]);

  if (isLoading) {
    return (
      <div className={`flex flex-col items-center justify-center p-8 text-tinta3 text-sm gap-2 ${className}`}>
        <RefreshCw className="w-5 h-5 animate-spin text-acento" />
        <span>{t('estatisticasModal', 'calculando')}</span>
      </div>
    );
  }

  if (error || !stats) {
    return (
      <div className={`p-6 text-center text-sm text-fem ${className}`}>
        {t('estatisticasModal', 'erroCarregar')}
      </div>
    );
  }

  const arvoreA = arvores?.find((a) => a.id === arvoreIdFiltro);
  const arvoreB = arvores?.find((a) => a.id === arvoreComparacaoId);
  const temPessoas = stats.total_pessoas > 0;

  const formatarAno = (ano?: number | null) => {
    if (ano == null) return '—';
    return ano < 0 ? `${Math.abs(ano)} ${t('estatisticasModal', 'antesDeCristo')}` : String(ano);
  };

  const spanAnos =
    stats.ano_mais_antigo != null && stats.ano_mais_recente != null
      ? Math.max(0, stats.ano_mais_recente - stats.ano_mais_antigo)
      : null;

  return (
    <div className={`flex flex-col gap-3.5 ${className}`}>
      {/* 1. SELETOR DE ESCOPO DE ÁRVORE (Pesquisável & Categorizado) & COMPARAÇÃO */}
      <div className="relative z-30 p-3 bg-card border border-borda rounded-raio flex flex-col gap-2 shadow-2xs">
        <div className="flex items-center justify-between text-xs">
          <span className="font-semibold text-tinta flex items-center gap-1.5">
            <IconeArvore className="w-4 h-4 text-acento flex-none" />
            <span>{t('estatisticasModal', 'arvoreAnalisada')}</span>
          </span>
          <button
            type="button"
            onClick={() => {
              setModoComparacao((m) => !m);
              if (!modoComparacao && !arvoreComparacaoId && arvores && arvores.length > 1) {
                const outra = arvores.find((a) => a.id !== arvoreIdFiltro) ?? arvores[1];
                if (outra) setArvoreComparacaoId(outra.id);
              }
            }}
            className="text-[11px] text-acento hover:underline font-semibold flex items-center gap-1 cursor-pointer"
          >
            <Scale className="w-3.5 h-3.5" />
            {modoComparacao ? t('estatisticasModal', 'fecharComparacao') : t('estatisticasModal', 'compararArvores')}
          </button>
        </div>

        {/* Seletor Pesquisável */}
        <SeletorArvoreEstatistica
          arvoreId={arvoreIdFiltro}
          onSelecionar={setArvoreIdFiltro}
          arvores={arvores}
          permitirTodoAcervo={true}
        />
      </div>

      {/* PAINEL DE COMPARAÇÃO ATIVO */}
      {modoComparacao && (
        <div className="relative z-20 p-3 bg-acento/5 border border-acento/30 rounded-raio flex flex-col gap-2.5 animate-in fade-in duration-150">
          <div className="flex items-center justify-between text-xs">
            <span className="font-bold text-acento flex items-center gap-1">
              <Scale className="w-3.5 h-3.5" />
              {t('estatisticasModal', 'compararComOutra')}
            </span>
          </div>

          <SeletorArvoreEstatistica
            arvoreId={arvoreComparacaoId}
            onSelecionar={setArvoreComparacaoId}
            arvores={arvores}
            desabilitarId={arvoreIdFiltro}
            permitirTodoAcervo={false}
            labelPlaceholder={t('estatisticasModal', 'selecionarSegundaArvore')}
          />

          {statsB && (
            <div className="flex flex-col gap-2 pt-1 border-t border-acento/20 text-xs">
              <div className="grid grid-cols-2 gap-2 text-center">
                <div className="p-2.5 rounded bg-card border border-borda shadow-xs">
                  <span className="block text-[10px] text-tinta3 font-bold truncate">
                    {arvoreA ? arvoreA.nome : t('estatisticasModal', 'acervoCompleto')}
                  </span>
                  <span className="block text-base font-bold font-num text-tinta mt-0.5">
                    {stats.total_pessoas} {t('estatisticasModal', 'pessoas')}
                  </span>
                  <span className="block text-[10.5px] text-tinta2">
                    {stats.idade_media_falecimento != null
                      ? `${stats.idade_media_falecimento} ${t('estatisticasModal', 'anosMedia')}`
                      : t('estatisticasModal', 'longevidadeSemDados')}
                  </span>
                </div>

                <div className="p-2.5 rounded bg-card border border-borda shadow-xs">
                  <span className="block text-[10px] text-tinta3 font-bold truncate">
                    {arvoreB ? arvoreB.nome : t('estatisticasModal', 'segundaArvore')}
                  </span>
                  <span className="block text-base font-bold font-num text-acento mt-0.5">
                    {statsB.total_pessoas} {t('estatisticasModal', 'pessoas')}
                  </span>
                  <span className="block text-[10.5px] text-tinta2">
                    {statsB.idade_media_falecimento != null
                      ? `${statsB.idade_media_falecimento} ${t('estatisticasModal', 'anosMedia')}`
                      : t('estatisticasModal', 'longevidadeSemDados')}
                  </span>
                </div>
              </div>

              <div className="p-2.5 bg-card rounded border border-borda text-[11px] text-tinta2 flex flex-col gap-1 shadow-xs">
                <div className="flex justify-between">
                  <span className="text-tinta3">{t('estatisticasModal', 'periodoA')}</span>
                  <strong className="font-num">
                    {formatarAno(stats.ano_mais_antigo)} – {formatarAno(stats.ano_mais_recente)}
                  </strong>
                </div>
                <div className="flex justify-between">
                  <span className="text-tinta3">{t('estatisticasModal', 'periodoB')}</span>
                  <strong className="font-num text-acento">
                    {formatarAno(statsB.ano_mais_antigo)} – {formatarAno(statsB.ano_mais_recente)}
                  </strong>
                </div>
              </div>
            </div>
          )}
        </div>
      )}

      {/* ALERTA DE FILTRO ATIVO */}
      {filtrosAtivosCount > 0 && (
        <div className="flex items-center justify-between px-3 py-2 rounded-raio-s bg-acento/10 border border-acento/30 text-xs text-tinta">
          <span>
            {t('estatisticasModal', 'exibindoEstatisticasDe')}{' '}
            <strong>{stats.total_pessoas}</strong>{' '}
            {stats.total_pessoas === 1
              ? t('estatisticasModal', 'pessoaFiltrada')
              : t('estatisticasModal', 'pessoasFiltradas')}.
          </span>
          {onLimparFiltros && (
            <button
              type="button"
              onClick={onLimparFiltros}
              className="text-acento font-semibold hover:underline cursor-pointer"
            >
              {t('estatisticasModal', 'verAcervoCompleto')}
            </button>
          )}
        </div>
      )}

      {/* 2. DASHBOARD: 4 CARTÕES DE INDICADORES CHAVE (KPI STRIP) EM 2 COLUNAS */}
      <div className="grid grid-cols-2 gap-2">
        {/* Total Analisado */}
        <div className="p-2.5 bg-card border border-borda rounded-raio flex flex-col justify-between gap-1 shadow-xs hover:border-acento/40 transition-colors">
          <div className="flex items-center justify-between">
            <span className="text-[10.5px] text-tinta3 font-bold uppercase tracking-wider truncate">
              {t('estatisticasModal', 'kpiTotal')}
            </span>
            <Users className="w-3.5 h-3.5 text-acento flex-none" />
          </div>
          <div className="flex flex-col">
            <span className="text-xl font-bold font-num text-tinta leading-tight">
              {stats.total_pessoas}
            </span>
            <span className="text-[10px] text-tinta2 leading-tight truncate">
              {stats.total_vivas} {t('estatisticasModal', 'vivas')} · {stats.total_falecidas} {t('estatisticasModal', 'falecidas')}
            </span>
          </div>
        </div>

        {/* Longevidade Média */}
        <div className="p-2.5 bg-card border border-borda rounded-raio flex flex-col justify-between gap-1 shadow-xs hover:border-fem/40 transition-colors">
          <div className="flex items-center justify-between">
            <span className="text-[10.5px] text-tinta3 font-bold uppercase tracking-wider truncate">
              {t('estatisticasModal', 'kpiLongevidade')}
            </span>
            <Heart className="w-3.5 h-3.5 text-fem flex-none" />
          </div>
          <div className="flex flex-col">
            <span className="text-xl font-bold font-num text-tinta leading-tight">
              {stats.idade_media_falecimento != null
                ? `${stats.idade_media_falecimento} ${t('estatisticasModal', 'anos')}`
                : '—'}
            </span>
            <span className="text-[10.5px] text-tinta2 leading-tight truncate">
              {t('estatisticasModal', 'mediaAoFalecer')}
            </span>
          </div>
        </div>

        {/* Período Histórico */}
        <div className="p-2.5 bg-card border border-borda rounded-raio flex flex-col justify-between gap-1 shadow-xs hover:border-acento/40 transition-colors">
          <div className="flex items-center justify-between">
            <span className="text-[10.5px] text-tinta3 font-bold uppercase tracking-wider truncate">
              {t('estatisticasModal', 'kpiPeriodo')}
            </span>
            <Calendar className="w-3.5 h-3.5 text-acento flex-none" />
          </div>
          <div className="flex flex-col">
            <span className="text-xs font-bold font-num text-tinta truncate leading-tight mt-0.5">
              {formatarAno(stats.ano_mais_antigo)} – {formatarAno(stats.ano_mais_recente)}
            </span>
            <span className="text-[10px] text-tinta2 leading-tight truncate">
              {spanAnos != null
                ? `${spanAnos} ${t('estatisticasModal', 'anosDeAlcance')}`
                : t('estatisticasModal', 'datasNaoInformadas')}
            </span>
          </div>
        </div>

        {/* Completude de Registros */}
        <div className="p-2.5 bg-card border border-borda rounded-raio flex flex-col justify-between gap-1 shadow-xs hover:border-emerald-500/40 transition-colors">
          <div className="flex items-center justify-between">
            <span className="text-[10.5px] text-tinta3 font-bold uppercase tracking-wider truncate">
              {t('estatisticasModal', 'kpiCompletude')}
            </span>
            <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600 dark:text-emerald-400 flex-none" />
          </div>
          <div className="flex flex-col">
            <span className="text-xl font-bold font-num text-tinta leading-tight">
              {destaques?.pctNascimento ?? 0}%
            </span>
            <span className="text-[10px] text-tinta2 leading-tight truncate">
              {stats.total_com_nascimento} {t('estatisticasModal', 'de')} {stats.total_pessoas} {t('estatisticasModal', 'comData')}
            </span>
          </div>
        </div>
      </div>

      {/* 3. NAVEGAÇÃO POR ABAS TEMÁTICAS */}
      <div className="flex items-center gap-1 border-b border-borda pb-1 overflow-x-auto text-[11px] font-semibold [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
        <button
          type="button"
          onClick={() => setSecaoAtiva('geral')}
          className={`px-2.5 py-1 rounded-raio-s transition-all flex items-center gap-1 cursor-pointer whitespace-nowrap flex-none ${
            secaoAtiva === 'geral'
              ? 'bg-card text-acento border border-acento/40 font-bold shadow-xs'
              : 'text-tinta2 hover:text-tinta hover:bg-card/50'
          }`}
        >
          <PieChart className="w-3 h-3" />
          {t('estatisticasModal', 'abaDemografia')}
        </button>

        <button
          type="button"
          onClick={() => setSecaoAtiva('decadas')}
          className={`px-2.5 py-1 rounded-raio-s transition-all flex items-center gap-1 cursor-pointer whitespace-nowrap flex-none ${
            secaoAtiva === 'decadas'
              ? 'bg-card text-acento border border-acento/40 font-bold shadow-xs'
              : 'text-tinta2 hover:text-tinta hover:bg-card/50'
          }`}
        >
          <Calendar className="w-3 h-3" />
          {t('estatisticasModal', 'abaNascimentos')}
        </button>

        <button
          type="button"
          onClick={() => setSecaoAtiva('sobrenomes')}
          className={`px-2.5 py-1 rounded-raio-s transition-all flex items-center gap-1 cursor-pointer whitespace-nowrap flex-none ${
            secaoAtiva === 'sobrenomes'
              ? 'bg-card text-acento border border-acento/40 font-bold shadow-xs'
              : 'text-tinta2 hover:text-tinta hover:bg-card/50'
          }`}
        >
          <BarChart3 className="w-3 h-3" />
          {t('estatisticasModal', 'abaSobrenomes')}
        </button>

        <button
          type="button"
          onClick={() => setSecaoAtiva('locais')}
          className={`px-2.5 py-1 rounded-raio-s transition-all flex items-center gap-1 cursor-pointer whitespace-nowrap flex-none ${
            secaoAtiva === 'locais'
              ? 'bg-card text-acento border border-acento/40 font-bold shadow-xs'
              : 'text-tinta2 hover:text-tinta hover:bg-card/50'
          }`}
        >
          <MapPin className="w-3 h-3" />
          {t('estatisticasModal', 'abaGeografia')}
        </button>

        <button
          type="button"
          onClick={() => setSecaoAtiva('cultural')}
          className={`px-2.5 py-1 rounded-raio-s transition-all flex items-center gap-1 cursor-pointer whitespace-nowrap flex-none ${
            secaoAtiva === 'cultural'
              ? 'bg-card text-acento border border-acento/40 font-bold shadow-xs'
              : 'text-tinta2 hover:text-tinta hover:bg-card/50'
          }`}
        >
          <GraduationCap className="w-3 h-3" />
          {t('estatisticasModal', 'abaSocial')}
        </button>
      </div>

      {!temPessoas ? (
        <div className="p-8 text-center text-sm text-tinta3 italic bg-card border border-borda rounded-raio">
          {t('estatisticasModal', 'semPessoasCriterios')}
        </div>
      ) : (
        <div className="flex flex-col gap-3.5">
          {/* 4. ABA DEMOGRAFIA: PAINEL DASHBOARD COMPACTO E ORGANIZADO */}
          {secaoAtiva === 'geral' && (
            <div className="flex flex-col gap-3">
              {/* Gráficos Donut Empilhados para a Barra Lateral */}
              <div className="flex flex-col gap-3">
                <GraficoRosca
                  titulo={t('estatisticasModal', 'distribuicaoSexo')}
                  itens={stats.distribuicao_sexo}
                  totalGeral={stats.total_pessoas}
                />
                <GraficoRosca
                  titulo={t('estatisticasModal', 'situacaoVida')}
                  itens={stats.distribuicao_situacao}
                  totalGeral={stats.total_pessoas}
                />
              </div>

              {/* Cartão de Destaques e Síntese Demográfica */}
              <div className="p-3 bg-card border border-borda rounded-raio flex flex-col gap-2 shadow-xs">
                <div className="flex items-center gap-1.5 text-xs font-bold text-tinta uppercase tracking-wider border-b border-borda/40 pb-1.5">
                  <Sparkles className="w-3.5 h-3.5 text-acento flex-none" />
                  <span>{t('estatisticasModal', 'sinteseDestaques')}</span>
                </div>
                <div className="flex flex-col gap-1.5 text-xs">
                  {/* Destaque 1: Gênero */}
                  <div className="p-2 rounded bg-sup/60 border border-borda/60 flex items-center justify-between gap-2">
                    <span className="text-[10px] text-tinta3 font-bold uppercase tracking-wider flex-none">
                      {t('estatisticasModal', 'equilibrioGenero')}
                    </span>
                    <span className="font-semibold text-tinta text-right truncate">
                      {destaques?.generoDestaque}
                    </span>
                  </div>

                  {/* Destaque 2: Preservação */}
                  <div className="p-2 rounded bg-sup/60 border border-borda/60 flex items-center justify-between gap-2">
                    <span className="text-[10px] text-tinta3 font-bold uppercase tracking-wider flex-none">
                      {t('estatisticasModal', 'statusVital')}
                    </span>
                    <span className="font-semibold text-tinta text-right truncate">
                      {stats.total_vivas > 0
                        ? `${stats.total_vivas} ${t('estatisticasModal', 'vivasEmAtividade')}`
                        : t('estatisticasModal', 'historicoFalecidos')}
                    </span>
                  </div>

                  {/* Destaque 3: Sobrenome Top */}
                  <div className="p-2 rounded bg-sup/60 border border-borda/60 flex items-center justify-between gap-2">
                    <span className="text-[10px] text-tinta3 font-bold uppercase tracking-wider flex-none">
                      {t('estatisticasModal', 'troncoPrincipal')}
                    </span>
                    <span className="font-semibold text-tinta text-right truncate">
                      {destaques?.topSobrenome
                        ? `${destaques.topSobrenome.chave} (${destaques.topSobrenome.contagem}p)`
                        : t('estatisticasModal', 'diversificado')}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* 5. ABA NASCIMENTOS: DÉCADAS */}
          {secaoAtiva === 'decadas' && (
            <div className="flex flex-col gap-3">
              <GraficoBarras
                titulo={t('estatisticasModal', 'nascimentosDecada')}
                itens={stats.distribuicao_decadas}
                totalGeral={stats.total_pessoas}
                limite={30}
                corBarra="#3d5a80"
              />
              {destaques?.topDecada && (
                <div className="p-2.5 bg-card border border-borda rounded-raio text-xs flex items-center justify-between text-tinta2 shadow-2xs">
                  <span className="flex items-center gap-1.5 font-medium">
                    <Calendar className="w-3.5 h-3.5 text-acento" />
                    <span>{t('estatisticasModal', 'decadaDeOuro')}</span>
                  </span>
                  <span className="font-bold font-num text-tinta">
                    {t('estatisticasModal', 'decadaDe')} {destaques.topDecada.chave} ({destaques.topDecada.contagem} {t('estatisticasModal', 'nascimentos')})
                  </span>
                </div>
              )}
            </div>
          )}

          {/* 6. ABA SOBRENOMES: LINHAGENS */}
          {secaoAtiva === 'sobrenomes' && (
            <GraficoBarras
              titulo={t('estatisticasModal', 'linhagensSobrenome')}
              itens={stats.distribuicao_sobrenomes}
              totalGeral={stats.total_pessoas}
              limite={15}
              corBarra="var(--acento)"
            />
          )}

          {/* 7. ABA GEOGRAFIA: CIDADES E PAÍSES */}
          {secaoAtiva === 'locais' && (
            <div className="flex flex-col gap-3.5">
              <GraficoBarras
                titulo={t('estatisticasModal', 'cidadesFrequentes')}
                itens={stats.distribuicao_cidades}
                totalGeral={stats.total_pessoas}
                limite={10}
                corBarra="#4a7c59"
              />
              <GraficoRosca
                titulo={t('estatisticasModal', 'nacionalidadesPaises')}
                itens={stats.distribuicao_paises}
                totalGeral={stats.total_pessoas}
              />
            </div>
          )}

          {/* 8. ABA SOCIAL & CULTURAL */}
          {secaoAtiva === 'cultural' && (
            <div className="flex flex-col gap-3.5">
              <GraficoRosca
                titulo={t('estatisticasModal', 'religioesDeclaradas')}
                itens={stats.distribuicao_religioes}
                totalGeral={stats.total_pessoas}
              />
              <GraficoBarras
                titulo={t('estatisticasModal', 'profissoesOcupacoes')}
                itens={stats.distribuicao_profissoes}
                totalGeral={stats.total_pessoas}
                corBarra="#e07a5f"
              />
              <GraficoBarras
                titulo={t('estatisticasModal', 'grauEscolaridade')}
                itens={stats.distribuicao_escolaridade}
                totalGeral={stats.total_pessoas}
                corBarra="#6b705c"
              />
            </div>
          )}
        </div>
      )}
    </div>
  );
}
