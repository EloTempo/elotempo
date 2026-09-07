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
  { value: 'X', label: 'Não-binário / outro' },
  { value: 'U', label: 'Desconhecido' },
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
  const [sexo, setSexo] = useState<Sex>('U');
  const [nascimento, setNascimento] = useState<DataEscolhida>({ ...DATA_VAZIA });
  const [erroLocal, setErroLocal] = useState<string | null>(null);
  const criar = useCriarPessoa();

  // Aba "acervo"
  const [busca, setBusca] = useState('');
  const { data: pessoas, isLoading } = usePessoas(busca);
  const candidatos = (pessoas ?? []).filter((p) => !excluir.includes(p.id));

  const criarEEscolher = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!nome.trim()) {
      setErroLocal('O nome é obrigatório.');
      return;
    }
    setErroLocal(null);

    const id = await criar.mutateAsync({
      nome: nome.trim(),
      sobrenome: sobrenome.trim(),
      sexo,
      is_vivo: false,
      minibiografia: '',
      nascimento,
      falecimento: { ...DATA_VAZIA },
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
    </div>
  );
}
