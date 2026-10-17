import { useState, useEffect } from 'react';
import { X, User, Sparkles, Globe, Check } from 'lucide-react';
import { useQueryClient } from '@tanstack/react-query';
import { Button } from '../../../components/ui/Button';
import { Input } from '../../../components/ui/Input';
import { Select } from '../../../components/ui/Select';
import { CampoDeData, previaDoTexto } from '../../../components/ui/CampoDeData';
import { SeletorDeLocal } from './SeletorDeLocal';
import { useSalvarPessoa, useEventos, nacionalidades, usePaises, useNomes } from '../hooks/useFicha';
import {
  ErroDoAcervo,
  criarEvento,
  atualizarEvento,
  obterLocal,
  adicionarNacionalidade,
  adicionarNome,
  removerNome,
} from '../../../lib/api';
import { DATA_VAZIA, type DataEscolhida, type Person, type Place, type Sex, type TipoTempo } from '../../../types';

interface ModalEditarIdentidadeProps {
  pessoa: Person;
  aberto: boolean;
  aoFechar: () => void;
}

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo || erro instanceof Error) return erro.message;
  return String(erro);
}

export function ModalEditarIdentidade({ pessoa, aberto, aoFechar }: ModalEditarIdentidadeProps) {
  const queryClient = useQueryClient();
  const [rascunho, setRascunho] = useState<Person>({ ...pessoa });
  const salvar = useSalvarPessoa(pessoa.id);
  const { data: eventos } = useEventos(pessoa.id);
  const { data: listaNomes } = useNomes(pessoa.id);
  const listaNacs = nacionalidades.useLista(pessoa.id);
  const { data: paises } = usePaises();

  const eventoNasc = eventos?.find((e) => e.tipo_evento === 'nascimento');
  const nomeRegistroExistente = listaNomes?.find((n) => n.tipo === 'nascimento');

  const [nomeCompletoRegistro, setNomeCompletoRegistro] = useState('');
  const [dataNasc, setDataNasc] = useState<DataEscolhida>({ ...DATA_VAZIA });
  const [localNasc, setLocalNasc] = useState<Place | null>(null);
  const [rotuloHistoricoNasc, setRotuloHistoricoNasc] = useState('');
  const [nacionalidadeId, setNacionalidadeId] = useState('');
  const [salvandoTudo, setSalvandoTudo] = useState(false);
  const [erroExtra, setErroExtra] = useState<string | null>(null);

  useEffect(() => {
    if (aberto) {
      setRascunho({ ...pessoa });
      setErroExtra(null);

      // Carrega nome completo de certidão/nascimento
      const nomeReg = listaNomes?.find((n) => n.tipo === 'nascimento');
      if (nomeReg) {
        setNomeCompletoRegistro(
          [nomeReg.prefixo, nomeReg.nome, nomeReg.sufixo, nomeReg.sobrenome].filter(Boolean).join(' ')
        );
      } else {
        setNomeCompletoRegistro('');
      }

      // Carrega data de nascimento inicial
      if (eventoNasc) {
        if (eventoNasc.ano_inicio != null) {
          setDataNasc({
            ...DATA_VAZIA,
            qualificador: (eventoNasc.data_qualificador as DataEscolhida['qualificador']) || 'exata',
            ano: eventoNasc.ano_inicio,
            ano_fim: eventoNasc.ano_fim ?? null,
            dia: eventoNasc.dia_inicio ?? null,
            mes: eventoNasc.mes_inicio ?? null,
          });
        } else if (eventoNasc.data_texto) {
          setDataNasc({
            ...DATA_VAZIA,
            qualificador: 'livre',
            texto_livre: eventoNasc.data_texto,
          });
        }
        setRotuloHistoricoNasc(eventoNasc.rotulo_historico_livre ?? '');
        if (eventoNasc.local_id) {
          obterLocal(eventoNasc.local_id)
            .then(setLocalNasc)
            .catch(() => setLocalNasc(null));
        } else {
          setLocalNasc(null);
        }
      } else {
        setDataNasc({ ...DATA_VAZIA });
        setLocalNasc(null);
        setRotuloHistoricoNasc('');
      }

      // Carrega nacionalidade inicial
      const primeiraNac = listaNacs.data?.[0]?.pais_id;
      if (primeiraNac) {
        setNacionalidadeId(primeiraNac);
      } else if (eventoNasc?.local_nome?.includes(', ')) {
        setNacionalidadeId('br');
      } else {
        setNacionalidadeId('');
      }
    }
  }, [aberto, pessoa, eventoNasc, listaNacs.data, listaNomes]);

  if (!aberto) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSalvandoTudo(true);
    setErroExtra(null);

    try {
      // 1. Salva a identidade da pessoa
      await salvar.mutateAsync(rascunho);

      // 2. Salva nascimento (data e local IBGE) se algum campo foi preenchido
      const temDataNasc = dataNasc.ano != null || !!dataNasc.texto_livre?.trim();
      if (temDataNasc || localNasc || rotuloHistoricoNasc.trim()) {
        const textoData = previaDoTexto(dataNasc);
        if (eventoNasc?.id) {
          await atualizarEvento({
            ...eventoNasc,
            data_texto: textoData || null,
            local_id: localNasc?.id ?? null,
            rotulo_historico_livre: rotuloHistoricoNasc.trim() || null,
          });
        } else {
          await criarEvento({
            pessoa_id: pessoa.id,
            tipo_evento: 'nascimento',
            data: dataNasc,
            local_id: localNasc?.id ?? null,
            rotulo_historico_livre: rotuloHistoricoNasc.trim() || null,
          });
        }
      }

      // 3. Salva nacionalidade
      const paisFinal = nacionalidadeId || (localNasc?.pais_id === 'br' ? 'br' : null);
      if (paisFinal && !listaNacs.data?.some((n) => n.pais_id === paisFinal)) {
        try {
          await adicionarNacionalidade(pessoa.id, paisFinal);
        } catch {
          // tolera duplicação
        }
      }

      // 4. Salva ou atualiza o nome completo de registro civil / certidão
      const nomeCompletoLimpo = nomeCompletoRegistro.trim();
      const nomeCompletoAnterior = nomeRegistroExistente
        ? [nomeRegistroExistente.prefixo, nomeRegistroExistente.nome, nomeRegistroExistente.sufixo, nomeRegistroExistente.sobrenome].filter(Boolean).join(' ')
        : '';

      if (nomeCompletoLimpo !== nomeCompletoAnterior) {
        if (nomeRegistroExistente) {
          await removerNome(nomeRegistroExistente.id);
        }
        if (nomeCompletoLimpo) {
          await adicionarNome({
            pessoa_id: pessoa.id,
            tipo: 'nascimento',
            nome: nomeCompletoLimpo,
            sobrenome: null,
            periodo: null,
          });
        }
      }

      // Invalida caches pertinentes
      queryClient.invalidateQueries({ queryKey: ['pessoa', pessoa.id] });
      queryClient.invalidateQueries({ queryKey: ['nomes', pessoa.id] });
      queryClient.invalidateQueries({ queryKey: ['eventos', pessoa.id] });
      queryClient.invalidateQueries({ queryKey: ['nacionalidades', pessoa.id] });
      queryClient.invalidateQueries({ queryKey: ['arvore'] });

      aoFechar();
    } catch (err) {
      setErroExtra(err instanceof Error ? err.message : String(err));
    } finally {
      setSalvandoTudo(false);
    }
  };

  const ocupado = salvar.isPending || salvandoTudo;
  const erroExibicao = erroExtra ?? mensagemDeErro(salvar.error);

  return (
    <div className="fixed inset-0 z-[80] flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs">
      <div className="absolute inset-0" onClick={aoFechar} aria-hidden />
      <div className="relative w-full max-w-lg bg-card rounded-raio border border-borda shadow-sombra overflow-hidden flex flex-col max-h-[90vh]">
        {/* Cabeçalho */}
        <div className="flex items-center justify-between px-5 py-3.5 border-b border-borda bg-card2 flex-none">
          <div className="flex items-center gap-2">
            <User className="w-4 h-4 text-acento" />
            <h3 className="font-tit font-bold text-base text-tinta m-0">
              Editar Identidade & Nomes
            </h3>
          </div>
          <button
            type="button"
            onClick={aoFechar}
            className="p-1 rounded-raio-s text-tinta3 hover:text-tinta hover:bg-sup transition-colors cursor-pointer border-none bg-transparent"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Formulário */}
        <form onSubmit={handleSubmit} className="p-5 flex flex-col gap-4 overflow-y-auto min-h-0">
          {erroExibicao && (
            <p role="alert" className="text-xs text-fem m-0 p-2.5 rounded-raio-s bg-fem/10 border border-fem/20">
              {erroExibicao}
            </p>
          )}

          {/* Nomes: Nome Público e Nome Completo */}
          <div className="p-3.5 bg-sup/40 rounded-raio-s border border-borda flex flex-col gap-3">
            <span className="text-xs font-semibold text-tinta flex items-center gap-1.5">
              <User className="w-3.5 h-3.5 text-acento" />
              Identificação e Nomes
            </span>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div>
                <Input
                  label="Nome público *"
                  value={rascunho.nome}
                  onChange={(e) => setRascunho({ ...rascunho, nome: e.target.value })}
                  required
                  placeholder="Ex: Santos Dumont, D. Pedro II, Maria"
                />
                <span className="text-[11px] text-tinta3 mt-1 block">
                  Como a pessoa aparece no card e na árvore
                </span>
              </div>
              <div>
                <Input
                  label="Sobrenome"
                  value={rascunho.sobrenome ?? ''}
                  onChange={(e) => setRascunho({ ...rascunho, sobrenome: e.target.value })}
                  placeholder="Ex: Silva, Ferreira (opcional)"
                />
                <span className="text-[11px] text-tinta3 mt-1 block">
                  Sobrenome da família (opcional)
                </span>
              </div>
            </div>

            <div>
              <Input
                label="Nome completo (certidão / registro civil)"
                value={nomeCompletoRegistro}
                onChange={(e) => setNomeCompletoRegistro(e.target.value)}
                placeholder="Ex: Alberto Santos-Dumont, Pedro de Alcântara João Carlos..."
              />
              <span className="text-[11px] text-tinta3 mt-1 block">
                Nome oficial de certidão civil ou batismo, se diferente do nome público
              </span>
            </div>
          </div>

          {/* Sexo e Visibilidade */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <Select
              label="Sexo"
              value={rascunho.sexo}
              onChange={(e) => setRascunho({ ...rascunho, sexo: e.target.value as Sex })}
              options={[
                { value: 'M', label: 'Masculino' },
                { value: 'F', label: 'Feminino' },
              ]}
            />
            <div className="flex items-center pb-1">
              <label className="flex items-center gap-2 cursor-pointer text-xs font-medium text-tinta select-none">
                <input
                  type="checkbox"
                  checked={rascunho.is_publico}
                  onChange={(e) => setRascunho({ ...rascunho, is_publico: e.target.checked })}
                  className="rounded border-borda text-acento focus:ring-acento"
                />
                <span>Registro público no acervo</span>
              </label>
            </div>
          </div>

          {/* Situação Vital */}
          <div className="p-3 bg-sup/40 rounded-raio-s border border-borda flex flex-col gap-2">
            <span className="text-xs font-semibold text-tinta">Situação Vital</span>
            <div className="grid grid-cols-2 gap-2">
              <button
                type="button"
                onClick={() => setRascunho({ ...rascunho, is_vivo: true })}
                className={`py-2 px-3 rounded-raio-s text-xs font-medium border flex items-center justify-center gap-1.5 transition-all cursor-pointer ${
                  rascunho.is_vivo
                    ? 'bg-emerald-500/15 text-emerald-800 dark:text-emerald-200 border-emerald-500/50 font-bold ring-1 ring-emerald-500/30'
                    : 'bg-card text-tinta2 border-borda hover:border-borda2 hover:text-tinta'
                }`}
              >
                <span>🌱</span> Pessoa viva
              </button>
              <button
                type="button"
                onClick={() => setRascunho({ ...rascunho, is_vivo: false })}
                className={`py-2 px-3 rounded-raio-s text-xs font-medium border flex items-center justify-center gap-1.5 transition-all cursor-pointer ${
                  !rascunho.is_vivo
                    ? 'bg-stone-500/15 text-stone-800 dark:text-stone-200 border-stone-500/50 font-bold ring-1 ring-stone-500/30'
                    : 'bg-card text-tinta2 border-borda hover:border-borda2 hover:text-tinta'
                }`}
              >
                <span>🕊️</span> Pessoa falecida
              </button>
            </div>
          </div>

          {/* Nascimento & Localidade (com IBGE) */}
          <div className="p-3 bg-sup/40 rounded-raio-s border border-borda flex flex-col gap-3">
            <span className="text-xs font-semibold text-tinta flex items-center gap-1.5">
              <span>⭐</span> Nascimento & Localidade
            </span>

            <CampoDeData
              rotulo="Data de Nascimento"
              valor={dataNasc}
              aoMudar={setDataNasc}
              ajuda="Ano sozinho basta; dia e mês são opcionais."
            />

            <SeletorDeLocal
              local={localNasc}
              onEscolher={(l) => {
                setLocalNasc(l);
                if (l?.pais_id === 'br' && !nacionalidadeId) {
                  setNacionalidadeId('br');
                }
              }}
              rotuloHistorico={rotuloHistoricoNasc}
              onMudarRotulo={setRotuloHistoricoNasc}
            />
            {localNasc?.codigo_ibge && (
              <p className="text-[11px] text-emerald-700 dark:text-emerald-300 font-medium m-0 flex items-center gap-1">
                <Check className="w-3.5 h-3.5" />
                Município oficial do IBGE ({localNasc.nome} - {localNasc.uf}) associado ao nascimento.
              </p>
            )}
          </div>

          {/* Nacionalidade de Nascimento */}
          <div className="p-3 bg-sup/40 rounded-raio-s border border-borda flex flex-col gap-2">
            <label className="flex flex-col gap-1">
              <span className="text-xs font-semibold text-tinta flex items-center gap-1.5">
                <Globe className="w-3.5 h-3.5 text-acento" />
                Nacionalidade de Nascimento
              </span>
              <select
                value={nacionalidadeId}
                onChange={(e) => setNacionalidadeId(e.target.value)}
                className="text-xs px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta focus:outline-none focus:border-acento"
              >
                <option value="">Não informada / Escolha um país…</option>
                {paises?.map((p) => (
                  <option key={p.id} value={p.id}>
                    {p.nome} {p.id === 'br' ? '(Brasil)' : ''}
                  </option>
                ))}
              </select>
            </label>
          </div>

          {/* Natureza da Cronologia */}
          <div className="p-3 bg-sup/40 rounded-raio-s border border-borda flex flex-col gap-2">
            <span className="text-xs font-semibold text-tinta">Cronologia / Natureza do Registro</span>
            <div className="flex items-center gap-4 text-xs">
              <label className="flex items-center gap-1.5 cursor-pointer text-tinta select-none">
                <input
                  type="radio"
                  name="edit_tipo_tempo"
                  value="real"
                  checked={rascunho.tipo_tempo !== 'ficticio'}
                  onChange={() => setRascunho({ ...rascunho, tipo_tempo: 'real' as TipoTempo })}
                  className="text-acento"
                />
                <Globe className="w-3.5 h-3.5 text-acento" />
                <span>Tempo Real / Histórico</span>
              </label>
              <label className="flex items-center gap-1.5 cursor-pointer text-tinta select-none">
                <input
                  type="radio"
                  name="edit_tipo_tempo"
                  value="ficticio"
                  checked={rascunho.tipo_tempo === 'ficticio'}
                  onChange={() => setRascunho({ ...rascunho, tipo_tempo: 'ficticio' as TipoTempo })}
                  className="text-purple-600"
                />
                <Sparkles className="w-3.5 h-3.5 text-purple-600" />
                <span>Fictício / Literário</span>
              </label>
            </div>
          </div>

          {/* Biografia */}
          <label className="flex flex-col gap-1.5">
            <span className="text-xs font-semibold text-tinta">Biografia / Memórias</span>
            <textarea
              value={rascunho.minibiografia ?? ''}
              onChange={(e) => setRascunho({ ...rascunho, minibiografia: e.target.value })}
              placeholder="Histórias, memórias, origens e fatos marcantes sobre esta pessoa…"
              rows={4}
              className="w-full rounded-raio-s border border-borda bg-card px-3 py-2 text-sm text-tinta resize-y focus:outline-none focus:border-acento"
            />
          </label>

          <div className="flex justify-end gap-2.5 pt-2 border-t border-borda/40">
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={aoFechar}
              disabled={ocupado}
            >
              Cancelar
            </Button>
            <Button
              type="submit"
              size="sm"
              disabled={ocupado || !rascunho.nome.trim()}
            >
              {ocupado ? 'Salvando…' : 'Salvar Alterações'}
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}
