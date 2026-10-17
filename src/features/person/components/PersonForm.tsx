/**
 * Cadastro e edição de pessoa.
 *
 * Cobre o item 1 do MVP: pessoa com nascimento, falecimento e flag "vivo".
 * A data de morte é metade da identidade de um nó genealógico (seção 2.3), e
 * por isso está aqui e não escondida num editor de eventos separado.
 *
 * Nenhum campo de data bloqueia o salvamento (regra da seção 2.5). O que o
 * usuário escrever vai para `data_texto` como está; o backend deriva os anos.
 */

import { useEffect, useState } from 'react';
import { Input } from '../../../components/ui/Input';
import { Select } from '../../../components/ui/Select';
import { Button } from '../../../components/ui/Button';
import { ErroDoAcervo } from '../../../lib/api';
import { CampoDeData } from '../../../components/ui/CampoDeData';
import { SeletorDeLocal } from './SeletorDeLocal';
import { DATA_VAZIA, type DataEscolhida, type Person, type Place, type Sex, type TipoTempo } from '../../../types';
import { useI18n } from '../../../i18n/I18nContext';
import type { ArvoreInfo } from '../../../lib/api';

export interface DadosPessoaForm {
  nome: string;
  sobrenome: string;
  nome_completo?: string;
  sexo: Sex;
  is_vivo: boolean;
  minibiografia: string;
  nascimento: DataEscolhida;
  falecimento: DataEscolhida;
  tipo_tempo: TipoTempo;
  arvore_id?: string | null;
  localNascimento?: Place | null;
  rotuloHistoricoNascimento?: string | null;
  nacionalidadePaisId?: string | null;
}

interface PersonFormProps {
  inicial?: Partial<Person> & {
    nascimento?: DataEscolhida;
    falecimento?: DataEscolhida;
  };
  salvando?: boolean;
  erro?: unknown;
  arvoresDisponiveis?: ArvoreInfo[];
  arvoreAtivaId?: string | null;
  onSalvar: (dados: DadosPessoaForm) => void;
  onCancelar?: () => void;
}

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo) return erro.message;
  if (erro instanceof Error) return erro.message;
  return String(erro);
}

export function PersonForm({
  inicial,
  salvando,
  erro,
  arvoresDisponiveis,
  arvoreAtivaId,
  onSalvar,
  onCancelar,
}: PersonFormProps) {
  const { t } = useI18n();
  const opcoesSexo = [
    { value: 'M', label: t('ficha', 'masculino') },
    { value: 'F', label: t('ficha', 'feminino') },
  ];
  const [dados, setDados] = useState<DadosPessoaForm>({
    nome: '',
    sobrenome: '',
    nome_completo: '',
    sexo: 'M',
    is_vivo: true,
    minibiografia: '',
    nascimento: { ...DATA_VAZIA },
    falecimento: { ...DATA_VAZIA },
    tipo_tempo: 'real',
    arvore_id: inicial?.id ? null : (arvoreAtivaId ?? null),
  });
  const [erroLocal, setErroLocal] = useState<string | null>(null);

  useEffect(() => {
    if (!inicial) return;
    setDados({
      nome: inicial.nome ?? '',
      sobrenome: inicial.sobrenome ?? '',
      nome_completo: '',
      sexo: (inicial.sexo as Sex) ?? 'U',
      is_vivo: inicial.is_vivo ?? true,
      minibiografia: inicial.minibiografia ?? '',
      nascimento: inicial.nascimento ?? { ...DATA_VAZIA },
      falecimento: inicial.falecimento ?? { ...DATA_VAZIA },
      tipo_tempo: (inicial.tipo_tempo as TipoTempo) ?? 'real',
    });
  }, [inicial]);

  const alterar = <C extends keyof DadosPessoaForm>(campo: C, valor: DadosPessoaForm[C]) =>
    setDados((d) => ({ ...d, [campo]: valor }));

  const enviar = (e: React.FormEvent) => {
    e.preventDefault();
    if (!dados.nome.trim()) {
      setErroLocal(t('ficha', 'nomeObrigatorioErro'));
      return;
    }
    setErroLocal(null);
    onSalvar({
      ...dados,
      nome: dados.nome.trim(),
      sobrenome: dados.sobrenome.trim(),
      nome_completo: dados.nome_completo?.trim() || undefined,
    });
  };

  const mensagem = erroLocal ?? mensagemDeErro(erro);

  return (
    <form onSubmit={enviar} className="space-y-5">
      {mensagem && (
        <div
          role="alert"
          className="bg-fem/10 text-fem p-3 rounded-raio-s text-sm border border-fem/20"
        >
          {mensagem}
        </div>
      )}

      {/* Bloco de Nomes: Nome Público e Nome Completo */}
      <div className="p-3.5 bg-sup/30 rounded-raio-s border border-borda/60 space-y-3">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <Input
              label="Nome público *"
              placeholder={t('ficha', 'nomePlaceholder')}
              value={dados.nome}
              onChange={(e) => alterar('nome', e.target.value)}
              autoFocus
            />
            <span className="text-[11px] text-tinta3 mt-0.5 block">
              Como a pessoa aparece no card e na árvore
            </span>
          </div>
          <div>
            <Input
              label={t('ficha', 'sobrenome')}
              placeholder={t('ficha', 'sobrenomePlaceholder')}
              value={dados.sobrenome}
              onChange={(e) => alterar('sobrenome', e.target.value)}
            />
            <span className="text-[11px] text-tinta3 mt-0.5 block">
              Sobrenome da família (opcional)
            </span>
          </div>
        </div>

        <div>
          <Input
            label="Nome completo (certidão / registro civil)"
            placeholder="Ex: Alberto Santos-Dumont, Pedro de Alcântara João Carlos..."
            value={dados.nome_completo ?? ''}
            onChange={(e) => alterar('nome_completo', e.target.value)}
          />
          <span className="text-[11px] text-tinta3 mt-0.5 block">
            Nome oficial de registro ou batismo, se diferente do nome público
          </span>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Select
          label={t('ficha', 'sexo')}
          value={dados.sexo}
          onChange={(e) => alterar('sexo', e.target.value as Sex)}
          options={opcoesSexo}
        />

        {/* Situação Vital */}
        <div className="p-2.5 bg-sup/40 rounded-raio-s border border-borda flex flex-col gap-1.5">
          <span className="text-xs font-semibold text-tinta">{t('ficha', 'situacaoVital')}</span>
          <div className="grid grid-cols-2 gap-2">
            <button
              type="button"
              onClick={() => {
                setDados((d) => ({ ...d, is_vivo: true, falecimento: { ...DATA_VAZIA } }));
              }}
              className={`py-1.5 px-3 rounded-raio-s text-xs font-medium border flex items-center justify-center gap-1.5 transition-all cursor-pointer ${
                dados.is_vivo
                  ? 'bg-emerald-500/15 text-emerald-800 dark:text-emerald-200 border-emerald-500/50 font-bold ring-1 ring-emerald-500/30'
                  : 'bg-card text-tinta2 border-borda hover:border-borda2 hover:text-tinta'
              }`}
            >
              <span>🌱</span> {t('ficha', 'viva')}
            </button>
            <button
              type="button"
              onClick={() => {
                setDados((d) => ({ ...d, is_vivo: false }));
              }}
              className={`py-1.5 px-3 rounded-raio-s text-xs font-medium border flex items-center justify-center gap-1.5 transition-all cursor-pointer ${
                !dados.is_vivo
                  ? 'bg-stone-500/15 text-stone-800 dark:text-stone-200 border-stone-500/50 font-bold ring-1 ring-stone-500/30'
                  : 'bg-card text-tinta2 border-borda hover:border-borda2 hover:text-tinta'
              }`}
            >
              <span>🕊️</span> {t('ficha', 'falecida')}
            </button>
          </div>
        </div>
      </div>

      <fieldset className="border border-borda rounded-raio-s p-4 space-y-3">
        <legend className="px-2 text-sm font-semibold text-tinta2">{t('ficha', 'datas')}</legend>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <CampoDeData
            rotulo={t('ficha', 'nascimentoLabel')}
            valor={dados.nascimento}
            aoMudar={(v) => alterar('nascimento', v)}
          />
          {!dados.is_vivo ? (
            <CampoDeData
              rotulo={t('ficha', 'falecimentoOpcional')}
              valor={dados.falecimento}
              aoMudar={(v) => alterar('falecimento', v)}
            />
          ) : (
            <div className="flex flex-col justify-center p-3 rounded-raio-s bg-sup/30 border border-dashed border-borda text-xs text-tinta3">
              <span className="font-semibold text-tinta2 flex items-center gap-1">
                <span>🌱</span> {t('ficha', 'pessoaMarcadaComoViva')}
              </span>
              <span className="mt-0.5">
                {t('ficha', 'paraRegistrarFalecimentoDica')}
              </span>
            </div>
          )}
        </div>

        {/* Local de Nascimento com IBGE */}
        <div className="pt-2 border-t border-borda/40">
          <span className="text-xs font-semibold text-tinta2 block mb-1.5">
            {t('ficha', 'localNascimentoIBGE')}
          </span>
          <SeletorDeLocal
            local={dados.localNascimento ?? null}
            onEscolher={(l) => {
              alterar('localNascimento', l);
              if (l?.pais_id === 'br' && !dados.nacionalidadePaisId) {
                alterar('nacionalidadePaisId', 'br');
              }
            }}
            rotuloHistorico={dados.rotuloHistoricoNascimento ?? ''}
            onMudarRotulo={(v) => alterar('rotuloHistoricoNascimento', v)}
          />
        </div>

        <p className="text-xs text-tinta3 leading-relaxed">
          {t('ficha', 'dicaDatas')}
        </p>
      </fieldset>

      {/* Confirmação e Isolamento da Árvore Genealógica (ao criar nova pessoa) */}
      {!inicial?.id && (
        <div className="p-3.5 bg-fundo/40 rounded-raio-s border border-borda/70 space-y-2.5">
          <label className="block text-sm font-semibold text-tinta2">
            🌳 {t('arvore', 'arvoresDoAcervo') || 'Árvore Genealógica / Família'}
          </label>
          <div className="flex flex-col gap-2">
            {arvoresDisponiveis && arvoresDisponiveis.length > 0 ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                {arvoresDisponiveis.map((arv) => (
                  <label
                    key={arv.id}
                    className={`flex items-center gap-2 p-2.5 rounded-raio-s border cursor-pointer transition-all text-xs ${
                      dados.arvore_id === arv.id
                        ? 'bg-acento/10 border-acento/60 text-tinta font-medium ring-1 ring-acento/30'
                        : 'bg-card border-borda/80 text-tinta2 hover:border-borda hover:text-tinta'
                    }`}
                  >
                    <input
                      type="radio"
                      name="arvore_destino"
                      value={arv.id}
                      checked={dados.arvore_id === arv.id}
                      onChange={() => alterar('arvore_id', arv.id)}
                      className="text-acento focus:ring-acento/50"
                    />
                    <span className="truncate font-medium">{arv.nome}</span>
                  </label>
                ))}
                <label
                  className={`flex items-center gap-2 p-2.5 rounded-raio-s border cursor-pointer transition-all text-xs ${
                    dados.arvore_id === null
                      ? 'bg-acento/10 border-acento/60 text-tinta font-medium ring-1 ring-acento/30'
                      : 'bg-card border-borda/80 text-tinta2 hover:border-borda hover:text-tinta'
                  }`}
                >
                  <input
                    type="radio"
                    name="arvore_destino"
                    value=""
                    checked={dados.arvore_id === null}
                    onChange={() => alterar('arvore_id', null)}
                    className="text-acento focus:ring-acento/50"
                  />
                  <span className="truncate italic text-tinta2">Nenhuma árvore (Pessoa Avulsa / Nova Família)</span>
                </label>
              </div>
            ) : (
              <p className="text-xs text-tinta3">
                Esta pessoa será cadastrada como pessoa inicial/avulsa no acervo.
              </p>
            )}
            <p className="text-[11px] text-tinta3 leading-tight">
              Garante o isolamento familiar: ter o mesmo sobrenome não significa ser da mesma família.
            </p>
          </div>
        </div>
      )}

      <div className="p-3.5 bg-fundo/40 rounded-raio-s border border-borda/70 space-y-2.5">
        <label className="block text-sm font-semibold text-tinta2">
          {t('ficha', 'naturezaCronologia')}
        </label>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
          <label
            className={`flex items-start gap-2.5 p-3 rounded-raio-s border cursor-pointer transition-all ${
              dados.tipo_tempo === 'real'
                ? 'bg-acento/10 border-acento/60 text-tinta font-medium ring-1 ring-acento/30'
                : 'bg-card border-borda/80 text-tinta2 hover:border-borda hover:text-tinta'
            }`}
          >
            <input
              type="radio"
              name="tipo_tempo"
              value="real"
              checked={dados.tipo_tempo === 'real'}
              onChange={() => alterar('tipo_tempo', 'real')}
              className="mt-0.5 text-acento focus:ring-acento/50"
            />
            <div>
              <div className="text-xs font-bold text-tinta flex items-center gap-1.5">
                <span>🌍 {t('ficha', 'tempoRealTitulo')}</span>
              </div>
              <p className="text-[11px] text-tinta3 mt-0.5 leading-snug">
                {t('ficha', 'tempoRealDesc')}
              </p>
            </div>
          </label>

          <label
            className={`flex items-start gap-2.5 p-3 rounded-raio-s border cursor-pointer transition-all ${
              dados.tipo_tempo === 'ficticio'
                ? 'bg-purple-500/10 border-purple-500/60 text-tinta font-medium ring-1 ring-purple-500/30'
                : 'bg-card border-borda/80 text-tinta2 hover:border-borda hover:text-tinta'
            }`}
          >
            <input
              type="radio"
              name="tipo_tempo"
              value="ficticio"
              checked={dados.tipo_tempo === 'ficticio'}
              onChange={() => alterar('tipo_tempo', 'ficticio')}
              className="mt-0.5 text-purple-600 focus:ring-purple-500/50"
            />
            <div>
              <div className="text-xs font-bold text-tinta flex items-center gap-1.5">
                <span>✨ {t('ficha', 'tempoFicticioTitulo')}</span>
              </div>
              <p className="text-[11px] text-tinta3 mt-0.5 leading-snug">
                {t('ficha', 'tempoFicticioDesc')}
              </p>
            </div>
          </label>
        </div>
      </div>

      <div>
        <label
          htmlFor="minibiografia"
          className="block text-sm font-semibold mb-1 text-tinta2"
        >
          {t('ficha', 'minibiografia')}
        </label>
        <textarea
          id="minibiografia"
          className="flex w-full rounded-raio-s border border-borda bg-card px-3 py-2 text-sm text-tinta placeholder:text-tinta3 focus:outline-none focus:ring-2 focus:ring-acento/50 min-h-[96px] resize-y"
          placeholder={t('ficha', 'minibiografiaPlaceholder')}
          value={dados.minibiografia}
          onChange={(e) => alterar('minibiografia', e.target.value)}
        />
      </div>

      <div className="flex items-center justify-end gap-3 pt-4 border-t border-borda">
        {onCancelar && (
          <Button type="button" variant="ghost" onClick={onCancelar}>
            {t('comum', 'cancelar')}
          </Button>
        )}
        <Button type="submit" disabled={salvando}>
          {salvando ? t('comum', 'salvando') : inicial?.id ? t('ficha', 'atualizar') : t('ficha', 'criarPessoa')}
        </Button>
      </div>
    </form>
  );
}
