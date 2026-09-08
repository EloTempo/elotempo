/**
 * Escolher quem entra do outro lado de uma conexão.
 *
 * Duas portas, porque as duas situações são igualmente comuns na prática:
 * a pessoa **já está no acervo** (uma prima que aparece em dois ramos) ou é
 * **nova** (o bisavô que ninguém tinha cadastrado ainda).
 */

import { useState } from 'react';
import { UserPlus, Users } from 'lucide-react';
import { Button } from '../../../components/ui/Button';
import { Input } from '../../../components/ui/Input';
import { Select } from '../../../components/ui/Select';
import { usePessoas, useCriarPessoa } from '../../person/hooks/usePessoas';
import { ErroDoAcervo } from '../../../lib/api';
import { CampoDeData } from '../../../components/ui/CampoDeData';
import { DATA_VAZIA, type DataEscolhida, type PersonSummary, type Sex } from '../../../types';

interface EscolherPessoaProps {
  /** Ids que não podem ser escolhidos — normalmente a própria pessoa. */
  excluir?: string[];
  /** Texto do botão de confirmação, para o diálogo dizer o que vai acontecer. */
  rotuloConfirmar: string;
  /**
   * Sobrenome já preenchido no formulário, deduzido do parentesco. É palpite,
   * não imposição: o campo continua livre.
   */
  sobrenomeSugerido?: string;
  /** De onde veio o palpite, para explicar ao usuário em uma linha. */
  explicacaoSugestao?: string;
  salvando?: boolean;
  erro?: unknown;
  onEscolher: (pessoa: PersonSummary) => void;
  onCancelar: () => void;
}

const OPCOES_SEXO = [
  { value: 'M', label: 'Masculino' },
  { value: 'F', label: 'Feminino' },
];

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo || erro instanceof Error) return erro.message;
  return String(erro);
}

export function EscolherPessoa({
  excluir = [],
  rotuloConfirmar,
  sobrenomeSugerido = '',
  explicacaoSugestao,
  salvando,
  erro,
  onEscolher,
  onCancelar,
}: EscolherPessoaProps) {
  const [aba, setAba] = useState<'nova' | 'acervo'>('nova');

  // Aba "nova". O sobrenome já nasce com o palpite do parentesco; o usuário
  // apaga ou troca sem cerimônia.
  const [nome, setNome] = useState('');
  const [sobrenome, setSobrenome] = useState(sobrenomeSugerido);
  const [sexo, setSexo] = useState<Sex>('M');
  const [nascimento, setNascimento] = useState<DataEscolhida>({ ...DATA_VAZIA });
  const [falecimento, setFalecimento] = useState<DataEscolhida>({ ...DATA_VAZIA });
  const [statusVital, setStatusVital] = useState<'vivo' | 'falecido' | 'pendente'>('pendente');
  const [modalConfirmarStatusAberto, setModalConfirmarStatusAberto] = useState(false);
  const [erroLocal, setErroLocal] = useState<string | null>(null);
  const criar = useCriarPessoa();

  // Aba "acervo"
  const [busca, setBusca] = useState('');
  const { data: pessoas, isLoading } = usePessoas(busca);
  const candidatos = (pessoas ?? []).filter((p) => !excluir.includes(p.id));

  const temData = (d: DataEscolhida): boolean => d.ano != null || !!d.texto_livre?.trim();

  const submeterComStatus = async (isVivo: boolean, dataFalecimento?: DataEscolhida) => {
    const id = await criar.mutateAsync({
      nome: nome.trim(),
      sobrenome: sobrenome.trim(),
      sexo,
      is_vivo: isVivo,
      minibiografia: '',
      nascimento,
      falecimento: isVivo ? { ...DATA_VAZIA } : (dataFalecimento ?? falecimento),
      tipo_tempo: 'real',
    });

    onEscolher({
      id,
      nome: nome.trim(),
      sobrenome: sobrenome.trim() || null,
      sexo,
      is_placeholder: false,
    });
  };

  const criarEEscolher = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!nome.trim()) {
      setErroLocal('O nome é obrigatório.');
      return;
    }
    setErroLocal(null);

    // 1. Se informou data de falecimento, é falecida com certeza
    if (temData(falecimento)) {
      await submeterComStatus(false, falecimento);
      return;
    }

    // 2. Se marcou explicitamente como viva
    if (statusVital === 'vivo') {
      await submeterComStatus(true);
      return;
    }

    // 3. Se marcou explicitamente como falecida (mesmo sem data exata de morte)
    if (statusVital === 'falecido') {
      await submeterComStatus(false);
      return;
    }

    // 4. Se não marcou (pendente), pergunta antes de concluir!
    setModalConfirmarStatusAberto(true);
  };

  const mensagem = erroLocal ?? mensagemDeErro(erro) ?? mensagemDeErro(criar.error);
  const ocupado = salvando || criar.isPending;

  return (
    <div className="flex flex-col gap-4">
      {mensagem && (
        <div
          role="alert"
          className="bg-fem/10 text-fem p-3 rounded-raio-s text-sm border border-fem/20"
        >
          {mensagem}
        </div>
      )}

      <div className="flex gap-1 p-1 bg-sup rounded-raio-s border border-borda">
        {(
          [
            { id: 'nova', rotulo: 'Cadastrar nova', icone: UserPlus },
            { id: 'acervo', rotulo: 'Buscar no acervo', icone: Users },
          ] as const
        ).map(({ id, rotulo, icone: Icone }) => (
          <button
            key={id}
            type="button"
            onClick={() => setAba(id)}
            className={`flex-1 flex items-center justify-center gap-2 py-2 text-sm rounded-raio-s transition-colors ${
              aba === id ? 'bg-card text-tinta font-semibold shadow-sm' : 'text-tinta2 hover:text-tinta'
            }`}
          >
            <Icone className="w-4 h-4" />
            {rotulo}
          </button>
        ))}
      </div>

      {aba === 'nova' ? (
        <form onSubmit={criarEEscolher} className="flex flex-col gap-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            <Input
              label="Nome *"
              value={nome}
              onChange={(e) => setNome(e.target.value)}
              placeholder="Ex: Joaquim"
              autoFocus
            />
            <Input
              label="Sobrenome"
              value={sobrenome}
              onChange={(e) => setSobrenome(e.target.value)}
              placeholder="Ex: Ferreira"
            />
          </div>

          {explicacaoSugestao && sobrenome === sobrenomeSugerido && sobrenomeSugerido !== '' && (
            <p className="text-xs text-tinta2 m-0 -mt-2 leading-relaxed">
              {explicacaoSugestao} Se não for o caso, é só escrever por cima.
            </p>
          )}

          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            <Select
              label="Sexo"
              value={sexo}
              onChange={(e) => setSexo(e.target.value as Sex)}
              options={OPCOES_SEXO}
            />
            <CampoDeData
              rotulo="Nascimento"
              valor={nascimento}
              aoMudar={setNascimento}
            />
          </div>

          {/* Situação Vital */}
          <div className="flex flex-col gap-1.5 p-3 rounded-raio-s bg-sup/40 border border-borda">
            <span className="text-xs font-semibold text-tinta">Situação Vital</span>
            <div className="grid grid-cols-2 gap-2">
              <button
                type="button"
                onClick={() => {
                  setStatusVital('vivo');
                  setFalecimento({ ...DATA_VAZIA });
                }}
                className={`py-2 px-3 rounded-raio-s text-xs font-medium border flex items-center justify-center gap-1.5 transition-all cursor-pointer ${
                  statusVital === 'vivo'
                    ? 'bg-emerald-500/15 text-emerald-800 dark:text-emerald-200 border-emerald-500/50 font-bold ring-1 ring-emerald-500/30'
                    : 'bg-card text-tinta2 border-borda hover:border-borda2 hover:text-tinta'
                }`}
              >
                <span>🌱</span> Pessoa viva
              </button>
              <button
                type="button"
                onClick={() => setStatusVital('falecido')}
                className={`py-2 px-3 rounded-raio-s text-xs font-medium border flex items-center justify-center gap-1.5 transition-all cursor-pointer ${
                  statusVital === 'falecido'
                    ? 'bg-stone-500/15 text-stone-800 dark:text-stone-200 border-stone-500/50 font-bold ring-1 ring-stone-500/30'
                    : 'bg-card text-tinta2 border-borda hover:border-borda2 hover:text-tinta'
                }`}
              >
                <span>🕊️</span> Pessoa falecida
              </button>
            </div>

            {statusVital === 'falecido' && (
              <div className="mt-2 pt-2 border-t border-borda/50">
                <CampoDeData
                  rotulo="Falecimento (opcional)"
                  valor={falecimento}
                  aoMudar={(novaData) => {
                    setFalecimento(novaData);
                    setStatusVital('falecido');
                  }}
                />
              </div>
            )}
          </div>

          <p className="text-xs text-tinta3 m-0">
            Só o nome é obrigatório. O resto dá para completar depois, na ficha da pessoa.
          </p>

          <div className="flex justify-end gap-3 pt-3 border-t border-borda">
            <Button type="button" variant="ghost" onClick={onCancelar}>
              Cancelar
            </Button>
            <Button type="submit" disabled={ocupado}>
              {ocupado ? 'Salvando…' : rotuloConfirmar}
            </Button>
          </div>
        </form>
      ) : (
        <div className="flex flex-col gap-3">
          <Input
            label="Buscar"
            value={busca}
            onChange={(e) => setBusca(e.target.value)}
            placeholder="Nome ou sobrenome"
            autoFocus
          />

          <div className="max-h-72 overflow-y-auto border border-borda rounded-raio-s divide-y divide-borda">
            {isLoading && <p className="p-3 text-sm text-tinta3 m-0">Buscando…</p>}

            {!isLoading && candidatos.length === 0 && (
              <p className="p-3 text-sm text-tinta3 m-0">
                {busca ? 'Ninguém com esse nome.' : 'O acervo ainda não tem outras pessoas.'}
              </p>
            )}

            {candidatos.map((p) => (
              <button
                key={p.id}
                type="button"
                disabled={ocupado}
                onClick={() =>
                  onEscolher({
                    id: p.id,
                    nome: p.nome,
                    sobrenome: p.sobrenome ?? null,
                    sexo: p.sexo as Sex,
                    is_placeholder: p.is_placeholder,
                  })
                }
                className="w-full text-left px-3 py-2 hover:bg-sup transition-colors disabled:opacity-50"
              >
                <span className="block text-sm text-tinta">
                  {[p.nome, p.sobrenome].filter(Boolean).join(' ')}
                  {p.is_placeholder && <span className="text-tinta3 italic"> · placeholder</span>}
                </span>
                <span className="block font-num text-[11px] text-tinta3">
                  {p.ano_nascimento ? `n. ${p.ano_nascimento}` : 'sem data'}
                  {p.ano_falecimento ? ` · † ${p.ano_falecimento}` : ''}
                </span>
              </button>
            ))}
          </div>

          <div className="flex justify-end pt-1">
            <Button type="button" variant="ghost" onClick={onCancelar}>
              Cancelar
            </Button>
          </div>
        </div>
      )}

      {/* Modal de Confirmação quando o status vital não foi especificado */}
      {modalConfirmarStatusAberto && (
        <div className="fixed inset-0 z-[90] flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs">
          <div
            className="absolute inset-0"
            onClick={() => setModalConfirmarStatusAberto(false)}
            aria-hidden
          />
          <div className="relative w-full max-w-md bg-card rounded-raio border border-borda shadow-sombra p-5 flex flex-col gap-4">
            <div>
              <h4 className="font-tit font-bold text-base text-tinta m-0">
                {nome.trim()} está viva ou falecida?
              </h4>
              <p className="text-sm text-tinta2 mt-1.5 mb-0 leading-relaxed">
                Você preencheu o cadastro sem indicar a situação vital. Para garantir que os símbolos e cálculos da árvore fiquem corretos, confirme:
              </p>
            </div>

            <div className="flex flex-col gap-2.5">
              <button
                type="button"
                disabled={ocupado}
                onClick={async () => {
                  setModalConfirmarStatusAberto(false);
                  await submeterComStatus(true);
                }}
                className="w-full py-3 px-4 rounded-raio-s bg-emerald-500/10 hover:bg-emerald-500/20 text-emerald-800 dark:text-emerald-200 border border-emerald-500/40 text-sm font-semibold flex items-center justify-center gap-2 transition-colors cursor-pointer"
              >
                <span>🌱</span> É uma Pessoa Viva
              </button>

              <button
                type="button"
                disabled={ocupado}
                onClick={async () => {
                  setModalConfirmarStatusAberto(false);
                  await submeterComStatus(false);
                }}
                className="w-full py-3 px-4 rounded-raio-s bg-stone-500/10 hover:bg-stone-500/20 text-stone-800 dark:text-stone-200 border border-stone-500/40 text-sm font-semibold flex items-center justify-center gap-2 transition-colors cursor-pointer"
              >
                <span>🕊️</span> É uma Pessoa Falecida
              </button>
            </div>

            <div className="flex justify-end pt-1 border-t border-borda/40">
              <Button
                type="button"
                variant="ghost"
                size="sm"
                onClick={() => setModalConfirmarStatusAberto(false)}
              >
                Voltar e editar
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
