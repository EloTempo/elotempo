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
import { DATA_VAZIA, type DataEscolhida, type Person, type Sex } from '../../../types';

export interface DadosPessoaForm {
  nome: string;
  sobrenome: string;
  sexo: Sex;
  is_vivo: boolean;
  minibiografia: string;
  nascimento: DataEscolhida;
  falecimento: DataEscolhida;
}

interface PersonFormProps {
  inicial?: Partial<Person> & {
    nascimento?: DataEscolhida;
    falecimento?: DataEscolhida;
  };
  salvando?: boolean;
  erro?: unknown;
  onSalvar: (dados: DadosPessoaForm) => void;
  onCancelar?: () => void;
}

const OPCOES_SEXO = [
  { value: 'M', label: 'Masculino' },
  { value: 'F', label: 'Feminino' },
  { value: 'X', label: 'Não-binário / outro' },
  { value: 'U', label: 'Desconhecido' },
];

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo) return erro.message;
  if (erro instanceof Error) return erro.message;
  return String(erro);
}

export function PersonForm({ inicial, salvando, erro, onSalvar, onCancelar }: PersonFormProps) {
  const [dados, setDados] = useState<DadosPessoaForm>({
    nome: '',
    sobrenome: '',
    sexo: 'U',
    is_vivo: true,
    minibiografia: '',
    nascimento: { ...DATA_VAZIA },
    falecimento: { ...DATA_VAZIA },
  });
  const [erroLocal, setErroLocal] = useState<string | null>(null);

  useEffect(() => {
    if (!inicial) return;
    setDados({
      nome: inicial.nome ?? '',
      sobrenome: inicial.sobrenome ?? '',
      sexo: (inicial.sexo as Sex) ?? 'U',
      is_vivo: inicial.is_vivo ?? true,
      minibiografia: inicial.minibiografia ?? '',
      nascimento: inicial.nascimento ?? { ...DATA_VAZIA },
      falecimento: inicial.falecimento ?? { ...DATA_VAZIA },
    });
  }, [inicial]);

  const alterar = <C extends keyof DadosPessoaForm>(campo: C, valor: DadosPessoaForm[C]) =>
    setDados((d) => ({ ...d, [campo]: valor }));

  const enviar = (e: React.FormEvent) => {
    e.preventDefault();
    if (!dados.nome.trim()) {
      setErroLocal('O nome é obrigatório — é a única coisa que não dá para deixar em branco.');
      return;
    }
    setErroLocal(null);
    onSalvar({ ...dados, nome: dados.nome.trim(), sobrenome: dados.sobrenome.trim() });
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

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Input
          label="Nome *"
          placeholder="Ex: Joaquim"
          value={dados.nome}
          onChange={(e) => alterar('nome', e.target.value)}
          autoFocus
        />
        <Input
          label="Sobrenome"
          placeholder="Ex: Ferreira"
          value={dados.sobrenome}
          onChange={(e) => alterar('sobrenome', e.target.value)}
        />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Select
          label="Sexo"
          value={dados.sexo}
          onChange={(e) => alterar('sexo', e.target.value as Sex)}
          options={OPCOES_SEXO}
        />

        <div className="flex items-end pb-1">
          <label className="flex items-center gap-2 cursor-pointer text-sm font-semibold text-tinta2 hover:text-tinta transition-colors">
            <input
              type="checkbox"
              className="rounded border-borda text-acento focus:ring-acento/50"
              checked={dados.is_vivo}
              onChange={(e) => alterar('is_vivo', e.target.checked)}
            />
            Pessoa viva
            <span className="text-tinta3 font-normal text-xs">(ocultável na exportação)</span>
          </label>
        </div>
      </div>

      <fieldset className="border border-borda rounded-raio-s p-4 space-y-3">
        <legend className="px-2 text-sm font-semibold text-tinta2">Datas</legend>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <CampoDeData
            rotulo="Nascimento"
            valor={dados.nascimento}
            aoMudar={(v) => alterar('nascimento', v)}
          />
          <CampoDeData
            rotulo="Falecimento"
            valor={dados.falecimento}
            aoMudar={(v) => alterar('falecimento', v)}
          />
        </div>

        <p className="text-xs text-tinta3 leading-relaxed">
          Escolha só o que souber: ano sozinho basta, e “Sem data” também é uma resposta.
          Para o que não cabe em lista — “na época da guerra” — use “Só sei descrever”.
        </p>
      </fieldset>

      <div>
        <label
          htmlFor="minibiografia"
          className="block text-sm font-semibold mb-1 text-tinta2"
        >
          Minibiografia
        </label>
        <textarea
          id="minibiografia"
          className="flex w-full rounded-raio-s border border-borda bg-card px-3 py-2 text-sm text-tinta placeholder:text-tinta3 focus:outline-none focus:ring-2 focus:ring-acento/50 min-h-[96px] resize-y"
          placeholder="O que vale a pena lembrar sobre esta pessoa…"
          value={dados.minibiografia}
          onChange={(e) => alterar('minibiografia', e.target.value)}
        />
      </div>

      <div className="flex items-center justify-end gap-3 pt-4 border-t border-borda">
        {onCancelar && (
          <Button type="button" variant="ghost" onClick={onCancelar}>
            Cancelar
          </Button>
        )}
        <Button type="submit" disabled={salvando}>
          {salvando ? 'Salvando…' : inicial?.id ? 'Atualizar' : 'Criar pessoa'}
        </Button>
      </div>
    </form>
  );
}
