import { useState } from 'react';
import {
  Baby,
  Heart,
  Cross,
  Calendar,
  BookOpen,
  Pencil,
  FileText,
  Users,
  Tag,
  ArrowRight,
  Plus,
  Compass,
  MapPin,
} from 'lucide-react';
import type { Event, Nickname, Person, PersonConnections, PersonName, PersonSummary } from '../../../types';
import { rotuloDoTipoDeNome, obterRotuloNacionalidade } from '../taxonomias';
import { ModalEditarFatoVital } from './ModalEditarFatoVital';
import { useI18n } from '../../../i18n/I18nContext';

interface AbaVisaoGeralProps {
  pessoa: Person;
  eventos: Event[];
  nomes: PersonName[];
  apelidos: Nickname[];
  conexoes?: PersonConnections;
  nacionalidadesLista?: { id: string; pais_id: string }[];
  onAbrirEditarIdentidade: () => void;
  onNavegarParaPessoa?: (pessoaId: string) => void;
  onAdicionarEvento: () => void;
  onIrParaLinhaTempo: () => void;
  onIrParaTrajetoria?: () => void;
  onIrParaMapa?: (eventoId?: string) => void;
}

export function AbaVisaoGeral({
  pessoa,
  eventos,
  nomes,
  apelidos,
  conexoes,
  nacionalidadesLista = [],
  onAbrirEditarIdentidade,
  onNavegarParaPessoa,
  onAdicionarEvento,
  onIrParaLinhaTempo,
  onIrParaTrajetoria,
  onIrParaMapa,
}: AbaVisaoGeralProps) {
  const { t } = useI18n();
  const nomeCompleto = [pessoa.nome, pessoa.sobrenome].filter(Boolean).join(' ');

  // Encontrar eventos vitais principais
  const eventoNasc = eventos.find((e) => e.tipo_evento === 'nascimento');
  const eventoBatismo = eventos.find((e) => e.tipo_evento === 'batismo');
  const eventoCasamento = eventos.find((e) => e.tipo_evento === 'casamento');
  const eventoObito = eventos.find((e) => e.tipo_evento === 'falecimento');
  const eventoSepultamento = eventos.find((e) => e.tipo_evento === 'sepultamento');

  const fatosVitais = [
    { tipo: 'nascimento', rotulo: t('perfil', 'nascimentoFato'), icone: Baby, cor: 'text-emerald-600 dark:text-emerald-400', evento: eventoNasc },
    { tipo: 'batismo', rotulo: t('perfil', 'batismoFato'), icone: Compass, cor: 'text-blue-500', evento: eventoBatismo },
    { tipo: 'casamento', rotulo: t('perfil', 'casamentoFato'), icone: Heart, cor: 'text-rose-500', evento: eventoCasamento },
    { tipo: 'falecimento', rotulo: t('perfil', 'falecimentoFato'), icone: Cross, cor: 'text-stone-500', evento: eventoObito },
    { tipo: 'sepultamento', rotulo: t('perfil', 'sepultamentoFato'), icone: Calendar, cor: 'text-amber-600', evento: eventoSepultamento },
  ];

  // Identificar pais a partir da união de origem
  const pai = conexoes?.uniao_de_origem?.masculino;
  const mae = conexoes?.uniao_de_origem?.feminino;

  // Identificar cônjuges e filhos
  const unioes = conexoes?.unioes ?? [];
  const filhosMap = new Map<string, PersonSummary>();
  unioes.forEach((u) => {
    u.filhos.forEach((f) => filhosMap.set(f.id, f));
  });
  const filhos = Array.from(filhosMap.values());

  const nomeRegistro = nomes.find((n) => n.tipo === 'nascimento');
  const outrosNomes = nomes.filter((n) => n.tipo !== 'nascimento');

  // Modal para editar/registrar fatos vitais com suporte a IBGE
  const [modalFatoVital, setModalFatoVital] = useState<{
    aberto: boolean;
    tipo: string;
    rotulo: string;
    evento?: Event | null;
  }>({
    aberto: false,
    tipo: 'nascimento',
    rotulo: t('perfil', 'nascimentoFato'),
    evento: null,
  });

  // Determina a nacionalidade de nascimento para a ficha
  const primeiraNacId = nacionalidadesLista[0]?.pais_id;
  const ehNascBrasil =
    eventoNasc?.local_nome?.includes(', ') ||
    eventoNasc?.rotulo_historico_livre?.toLowerCase().includes('brasil');
  const nacIdEfetivo = primeiraNacId || (ehNascBrasil ? 'br' : null);
  const infoNacionalidade = obterRotuloNacionalidade(nacIdEfetivo, pessoa.sexo);

  return (
    <div className="grid grid-cols-1 lg:grid-cols-12 gap-5">
      {/* ---------------- Coluna Esquerda: Fatos Vitais & Biografia (7 de 12) ---------------- */}
      <div className="lg:col-span-7 flex flex-col gap-4">
        {/* Card: Fatos Vitais Principais */}
        <div className="p-4 rounded-raio bg-card border border-borda shadow-2xs flex flex-col gap-3">
          <div className="flex items-center justify-between gap-2 border-b border-borda/50 pb-2.5">
            <div className="flex items-center gap-2">
              <Calendar className="w-4 h-4 text-acento" />
              <h3 className="font-tit font-bold text-sm text-tinta m-0">{t('perfil', 'fatosVitais')}</h3>
            </div>
            <div className="flex items-center gap-1.5">
              {onIrParaMapa && (
                <button
                  type="button"
                  onClick={() => onIrParaMapa()}
                  className="text-xs font-semibold px-2 py-1 rounded-raio-s bg-sup hover:bg-card border border-borda hover:border-acento text-tinta2 hover:text-tinta transition-colors flex items-center gap-1 cursor-pointer"
                  title={t('perfil', 'abaMapa')}
                >
                  <Compass className="w-3 h-3 text-acento" />
                  <span>{t('perfil', 'abaMapa')}</span>
                </button>
              )}
              <button
                type="button"
                onClick={onAdicionarEvento}
                className="text-xs font-semibold px-2.5 py-1 rounded-raio-s bg-acento/10 hover:bg-acento/20 text-acento border border-acento/30 transition-colors flex items-center gap-1 cursor-pointer"
              >
                <Plus className="w-3 h-3" />
                {t('perfil', 'adicionarFato')}
              </button>
            </div>
          </div>

          <div className="flex flex-col divide-y divide-borda/40">
            {fatosVitais.map(({ tipo, rotulo, icone: Icone, cor, evento }) => {
              if (!evento) {
                return (
                  <div key={rotulo} className="py-2.5 flex items-center justify-between text-xs text-tinta3">
                    <div className="flex items-center gap-2.5">
                      <Icone className={`w-3.5 h-3.5 ${cor} opacity-50`} />
                      <span className="font-medium text-tinta2">{rotulo}</span>
                    </div>
                    <button
                      type="button"
                      onClick={() =>
                        setModalFatoVital({ aberto: true, tipo, rotulo, evento: null })
                      }
                      className="text-xs font-semibold px-2 py-1 rounded-raio-s bg-sup hover:bg-card border border-borda hover:border-acento text-acento transition-colors flex items-center gap-1 cursor-pointer"
                    >
                      <Plus className="w-3 h-3" />
                      {t('perfil', 'registrarFato').replace('{tipo}', rotulo)}
                    </button>
                  </div>
                );
              }

              const localFormatado = evento.rotulo_historico_livre || evento.local_nome;

              return (
                <div key={rotulo} className="py-2.5 flex items-start justify-between gap-3 group">
                  <div className="flex items-start gap-2.5 flex-1 min-w-0">
                    <div className="mt-0.5 p-1 rounded bg-sup/80 border border-borda/60">
                      <Icone className={`w-3.5 h-3.5 ${cor}`} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <span className="text-xs font-semibold text-tinta block">{rotulo}</span>
                      <span className="font-num text-xs font-medium text-tinta2 block mt-0.5">
                        {evento.data_texto || (evento.ano_inicio ? String(evento.ano_inicio) : t('perfil', 'dataNaoInformada'))}
                      </span>
                      {localFormatado ? (
                        <div className="text-[11px] text-tinta2 mt-0.5 flex items-center gap-2 flex-wrap">
                          <span className="flex items-center gap-1 truncate">
                            <MapPin className="w-3 h-3 text-acento flex-none" />
                            <span className="truncate">{localFormatado}</span>
                          </span>
                          {onIrParaMapa && (
                            <button
                              type="button"
                              onClick={() => onIrParaMapa(evento.id)}
                              className="text-[10.5px] font-semibold text-acento hover:underline flex items-center gap-0.5 cursor-pointer bg-transparent border-none p-0 flex-none"
                              title={t('perfil', 'verNoMapa')}
                            >
                              <Compass className="w-3 h-3" />
                              <span>{t('perfil', 'verNoMapa')}</span>
                            </button>
                          )}
                        </div>
                      ) : (
                        <button
                          type="button"
                          onClick={() =>
                            setModalFatoVital({ aberto: true, tipo, rotulo, evento })
                          }
                          className="text-[11px] font-semibold text-acento hover:underline flex items-center gap-1 mt-1 bg-transparent border-none cursor-pointer p-0"
                        >
                          <MapPin className="w-3 h-3" />
                          {t('perfil', 'associarCidadeIbge')}
                        </button>
                      )}
                      {evento.nota && (
                        <span className="text-[11px] text-tinta3 italic block mt-0.5">“{evento.nota}”</span>
                      )}
                    </div>
                  </div>

                  <button
                    type="button"
                    onClick={() =>
                      setModalFatoVital({ aberto: true, tipo, rotulo, evento })
                    }
                    className="p-1 rounded-raio-s text-tinta3 hover:text-tinta hover:bg-sup transition-colors cursor-pointer border-none bg-transparent"
                    title={`${t('comum', 'editar')} ${rotulo}`}
                  >
                    <Pencil className="w-3.5 h-3.5" />
                  </button>
                </div>
              );
            })}
          </div>

          {eventos.length > 3 && (
            <div className="pt-2 border-t border-borda/40 text-center">
              <button
                type="button"
                onClick={onIrParaLinhaTempo}
                className="text-xs font-medium text-acento hover:underline inline-flex items-center gap-1 cursor-pointer bg-transparent border-none"
              >
                {t('perfil', 'verAcontecimentosLinhaTempo').replace('{total}', String(eventos.length))}
                <ArrowRight className="w-3 h-3" />
              </button>
            </div>
          )}
        </div>

        {/* Card: Biografia e Memórias */}
        <div className="p-4 rounded-raio bg-card border border-borda shadow-2xs flex flex-col gap-3">
          <div className="flex items-center justify-between gap-2 border-b border-borda/50 pb-2.5">
            <div className="flex items-center gap-2">
              <BookOpen className="w-4 h-4 text-acento" />
              <h3 className="font-tit font-bold text-sm text-tinta m-0">{t('perfil', 'biografiaEMemorias')}</h3>
            </div>
            <button
              type="button"
              onClick={onAbrirEditarIdentidade}
              className="text-xs font-semibold px-2 py-0.5 rounded-raio-s text-acento hover:text-acento/80 bg-acento/10 hover:bg-acento/15 border border-acento/30 transition-colors flex items-center gap-1 cursor-pointer"
            >
              <Pencil className="w-3.5 h-3.5" />
              {t('comum', 'editar')}
            </button>
          </div>

          {pessoa.minibiografia ? (
            <p className="text-sm text-tinta leading-relaxed whitespace-pre-wrap m-0 font-sans">
              {pessoa.minibiografia}
            </p>
          ) : (
            <div
              onClick={onAbrirEditarIdentidade}
              className="p-4 rounded-raio-s border border-dashed border-borda hover:border-acento/60 bg-sup/30 hover:bg-sup/50 transition-colors cursor-pointer text-center"
            >
              <p className="text-xs text-tinta3 m-0 leading-relaxed">
                {t('perfil', 'semBiografiaDica')}
              </p>
            </div>
          )}
        </div>
      </div>

      {/* ---------------- Coluna Direita: Identidade & Família (5 de 12) ---------------- */}
      <div className="lg:col-span-5 flex flex-col gap-4">
        {/* Card: Nomes & Apelidos */}
        <div className="p-4 rounded-raio bg-card border border-borda shadow-2xs flex flex-col gap-3">
          <div className="flex items-center justify-between gap-2 border-b border-borda/50 pb-2.5">
            <div className="flex items-center gap-2">
              <FileText className="w-4 h-4 text-acento" />
              <h3 className="font-tit font-bold text-sm text-tinta m-0">{t('perfil', 'nomesIdentidade')}</h3>
            </div>
          </div>

          <div className="flex flex-col gap-2.5">
            {/* Nome de Exibição */}
            <div>
              <span className="text-[10px] font-num uppercase tracking-wider text-tinta3 block">
                {t('perfil', 'nomeUsual')}
              </span>
              <span className="text-sm font-semibold text-tinta block">{nomeCompleto}</span>
            </div>

            {/* Nome de Registro Civil */}
            {nomeRegistro && (
              <div className="pt-2 border-t border-borda/40">
                <span className="text-[10px] font-num uppercase tracking-wider text-tinta3 block">
                  {t('perfil', 'nomeCompletoRegistro')}
                </span>
                <span className="text-xs font-medium text-tinta block mt-0.5">
                  {[nomeRegistro.prefixo, nomeRegistro.nome, nomeRegistro.sufixo, nomeRegistro.sobrenome]
                    .filter(Boolean)
                    .join(' ')}
                </span>
              </div>
            )}

            {/* Nomes Alternativos */}
            {outrosNomes.length > 0 && (
              <div className="pt-2 border-t border-borda/40">
                <span className="text-[10px] font-num uppercase tracking-wider text-tinta3 block mb-1">
                  {t('perfil', 'nomesAlternativos')}
                </span>
                <div className="flex flex-col gap-1.5">
                  {outrosNomes.map((n) => (
                    <div key={n.id} className="text-xs flex items-center justify-between gap-2">
                      <span className="text-tinta font-medium truncate">
                        {[n.prefixo, n.nome, n.sufixo, n.sobrenome].filter(Boolean).join(' ')}
                      </span>
                      <span className="text-[10px] text-tinta3 px-1.5 py-0.2 rounded bg-sup border border-borda flex-none">
                        {rotuloDoTipoDeNome(n.tipo)}
                      </span>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Apelidos */}
            {apelidos.length > 0 && (
              <div className="pt-2 border-t border-borda/40">
                <span className="text-[10px] font-num uppercase tracking-wider text-tinta3 block mb-1.5">
                  {t('perfil', 'apelidosFamilia')}
                </span>
                <div className="flex flex-wrap gap-1.5">
                  {apelidos.map((a) => (
                    <span
                      key={a.id}
                      className="px-2 py-0.5 text-xs font-medium rounded-full bg-sup border border-borda text-tinta flex items-center gap-1"
                    >
                      <Tag className="w-3 h-3 text-acento" />
                      {a.apelido}
                    </span>
                  ))}
                </div>
              </div>
            )}

            {/* Nacionalidade de Nascimento */}
            <div className="pt-2 border-t border-borda/40 flex items-center justify-between">
              <div>
                <span className="text-[10px] font-num uppercase tracking-wider text-tinta3 block">
                  {t('perfil', 'nacionalidadeNascimento')}
                </span>
                <span className="text-xs font-semibold text-tinta flex items-center gap-1.5 mt-0.5">
                  <span>{infoNacionalidade?.flag || '🌐'}</span>
                  <span>{infoNacionalidade?.texto || t('perfil', 'naoInformada')}</span>
                </span>
              </div>
              {onIrParaTrajetoria && (
                <button
                  type="button"
                  onClick={onIrParaTrajetoria}
                  className="text-[11px] font-medium text-acento hover:underline bg-transparent border-none cursor-pointer p-0"
                >
                  {infoNacionalidade ? t('perfil', 'gerenciar') : `+ ${t('comum', 'editar')}`}
                </button>
              )}
            </div>
          </div>
        </div>

        {/* Card: Família Imediata */}
        <div className="p-4 rounded-raio bg-card border border-borda shadow-2xs flex flex-col gap-3">
          <div className="flex items-center justify-between gap-2 border-b border-borda/50 pb-2.5">
            <div className="flex items-center gap-2">
              <Users className="w-4 h-4 text-acento" />
              <h3 className="font-tit font-bold text-sm text-tinta m-0">{t('perfil', 'familiaImediata')}</h3>
            </div>
          </div>

          <div className="flex flex-col gap-3">
            {/* Pais */}
            <div>
              <span className="text-[10px] font-num uppercase tracking-wider text-tinta3 block mb-1">
                {t('perfil', 'pais')}
              </span>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                {/* Pai */}
                <div
                  onClick={() => pai && !pai.is_placeholder && onNavegarParaPessoa?.(pai.id)}
                  className={`p-2 rounded-raio-s border flex items-center gap-2 ${
                    pai && !pai.is_placeholder
                      ? 'bg-sup/50 border-borda hover:border-acento cursor-pointer transition-colors'
                      : 'bg-sup/20 border-borda/50 text-tinta3'
                  }`}
                >
                  <span className="w-6 h-6 rounded-full bg-masc/15 text-masc text-xs flex items-center justify-center font-bold">
                    ♂
                  </span>
                  <div className="min-w-0 flex-1">
                    <span className="text-[10px] text-tinta3 block leading-none">{t('perfil', 'pai')}</span>
                    <span className="text-xs font-medium text-tinta truncate block mt-0.5">
                      {pai && !pai.is_placeholder
                        ? [pai.nome, pai.sobrenome].filter(Boolean).join(' ')
                        : t('perfil', 'naoIdentificado')}
                    </span>
                  </div>
                </div>

                {/* Mãe */}
                <div
                  onClick={() => mae && !mae.is_placeholder && onNavegarParaPessoa?.(mae.id)}
                  className={`p-2 rounded-raio-s border flex items-center gap-2 ${
                    mae && !mae.is_placeholder
                      ? 'bg-sup/50 border-borda hover:border-acento cursor-pointer transition-colors'
                      : 'bg-sup/20 border-borda/50 text-tinta3'
                  }`}
                >
                  <span className="w-6 h-6 rounded-full bg-fem/15 text-fem text-xs flex items-center justify-center font-bold">
                    ♀
                  </span>
                  <div className="min-w-0 flex-1">
                    <span className="text-[10px] text-tinta3 block leading-none">{t('perfil', 'mae')}</span>
                    <span className="text-xs font-medium text-tinta truncate block mt-0.5">
                      {mae && !mae.is_placeholder
                        ? [mae.nome, mae.sobrenome].filter(Boolean).join(' ')
                        : t('perfil', 'naoIdentificada')}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            {/* Cônjuges */}
            {unioes.length > 0 && (
              <div className="pt-2 border-t border-borda/40">
                <span className="text-[10px] font-num uppercase tracking-wider text-tinta3 block mb-1">
                  {t('perfil', 'conjuges')}
                </span>
                <div className="flex flex-col gap-1.5">
                  {unioes.map((u) => {
                    const conjuge = u.slot_da_pessoa === 'masculino' ? u.feminino : u.masculino;
                    const ehPlaceholder = conjuge.is_placeholder;

                    return (
                      <div
                        key={u.id}
                        onClick={() => !ehPlaceholder && onNavegarParaPessoa?.(conjuge.id)}
                        className={`p-2 rounded-raio-s border flex items-center justify-between gap-2 ${
                          !ehPlaceholder
                            ? 'bg-sup/50 border-borda hover:border-acento cursor-pointer transition-colors'
                            : 'bg-sup/20 border-borda/50 text-tinta3'
                        }`}
                      >
                        <div className="flex items-center gap-2 min-w-0">
                          <Heart className="w-3.5 h-3.5 text-rose-500 flex-none" />
                          <span className="text-xs font-medium text-tinta truncate">
                            {ehPlaceholder
                              ? t('perfil', 'conjugeDesconhecido')
                              : [conjuge.nome, conjuge.sobrenome].filter(Boolean).join(' ')}
                          </span>
                        </div>
                        {u.filhos.length > 0 && (
                          <span className="text-[10px] text-tinta3 font-num flex-none">
                            {u.filhos.length} {u.filhos.length === 1 ? t('perfil', 'filhoOuFilha') : t('perfil', 'filhos').toLowerCase()}
                          </span>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            )}

            {/* Filhos */}
            {filhos.length > 0 && (
              <div className="pt-2 border-t border-borda/40">
                <span className="text-[10px] font-num uppercase tracking-wider text-tinta3 block mb-1">
                  {t('perfil', 'filhos')} ({filhos.length})
                </span>
                <div className="flex flex-col gap-1 max-h-36 overflow-y-auto pr-1">
                  {filhos.map((filho) => (
                    <div
                      key={filho.id}
                      onClick={() => !filho.is_placeholder && onNavegarParaPessoa?.(filho.id)}
                      className="px-2 py-1.5 rounded-raio-s bg-sup/40 hover:bg-sup border border-borda/60 hover:border-acento flex items-center justify-between text-xs cursor-pointer transition-colors"
                    >
                      <div className="flex items-center gap-1.5 min-w-0">
                        <span className={`text-[10px] font-bold ${filho.sexo === 'M' ? 'text-masc' : 'text-fem'}`}>
                          {filho.sexo === 'M' ? '♂' : '♀'}
                        </span>
                        <span className="text-tinta font-medium truncate">
                          {[filho.nome, filho.sobrenome].filter(Boolean).join(' ')}
                        </span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Modal para Editar ou Registrar Fato Vital (Nascimento, etc.) com IBGE */}
      {modalFatoVital.aberto && (
        <ModalEditarFatoVital
          aberto={modalFatoVital.aberto}
          aoFechar={() =>
            setModalFatoVital((prev) => ({ ...prev, aberto: false }))
          }
          pessoaId={pessoa.id}
          tipoEvento={modalFatoVital.tipo}
          rotuloEvento={modalFatoVital.rotulo}
          eventoExistente={modalFatoVital.evento}
        />
      )}
    </div>
  );
}
