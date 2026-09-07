import { useMutation, useQueryClient } from '@tanstack/react-query';
import { Save, Trash2 } from 'lucide-react';
import { Modal } from '../../../components/ui/Modal';
import { Button } from '../../../components/ui/Button';
import { Input } from '../../../components/ui/Input';
import { Select } from '../../../components/ui/Select';
import { criarLinhaTempo, atualizarLinhaTempo, deletarLinhaTempo } from '../../../lib/api';

interface EditorLinhaTempoProps {
  idOpcional?: string;
  valoresIniciais?: {
    categoria: string;
    titulo: string;
    fonte_referencia?: string | null;
  };
  onClose: () => void;
  onSuccess: (id: string) => void;
}

const OPCOES_CATEGORIA = [
  { value: 'projeto', label: 'Pessoal / Projeto da Família' },
  { value: 'historia', label: 'História' },
  { value: 'politica', label: 'Política' },
  { value: 'moeda', label: 'Moeda e Economia' },
  { value: 'tecnologia', label: 'Tecnologia' },
];

export function EditorLinhaTempo({ idOpcional, valoresIniciais, onClose, onSuccess }: EditorLinhaTempoProps) {
  const qc = useQueryClient();

  const mCriar = useMutation({
    mutationFn: (v: { categoria: string; titulo: string; fonte_referencia: string | null }) =>
      criarLinhaTempo(v),
    onSuccess: (id) => {
      qc.invalidateQueries({ queryKey: ['linhas-de-contexto'] });
      onSuccess(id);
    },
  });

  const mAtualizar = useMutation({
    mutationFn: (v: { categoria: string; titulo: string; fonte_referencia: string | null }) =>
      atualizarLinhaTempo(idOpcional!, v),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['linhas-de-contexto'] });
      onSuccess(idOpcional!);
    },
  });

  const mDeletar = useMutation({
    mutationFn: () => deletarLinhaTempo(idOpcional!),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['linhas-de-contexto'] });
      onSuccess('');
    },
  });

  const onSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const data = new FormData(e.currentTarget);
    const v = {
      titulo: (data.get('titulo') as string).trim(),
      categoria: data.get('categoria') as string,
      fonte_referencia: (data.get('fonte_referencia') as string)?.trim() || null,
    };
    if (idOpcional) mAtualizar.mutate(v);
    else mCriar.mutate(v);
  };

  return (
    <Modal
      isOpen={true}
      onClose={onClose}
      title={idOpcional ? 'Editar Linha do Tempo' : 'Nova Linha do Tempo'}
      className="max-w-md"
    >
      <form onSubmit={onSubmit} className="flex flex-col gap-4">
        <Input
          name="titulo"
          label="Título da Linha"
          placeholder="Ex: Fazenda Santa Clara, Imigração Italiana..."
          defaultValue={valoresIniciais?.titulo ?? ''}
          required
          autoFocus
        />

        <Select
          name="categoria"
          label="Categoria"
          options={OPCOES_CATEGORIA}
          defaultValue={valoresIniciais?.categoria ?? 'projeto'}
        />

        <div className="flex flex-col gap-1">
          <label className="block text-sm font-semibold text-tinta2">
            Descrição / Fonte de Referência (Opcional)
          </label>
          <textarea
            name="fonte_referencia"
            rows={3}
            defaultValue={valoresIniciais?.fonte_referencia ?? ''}
            placeholder="Anotações sobre a linha do tempo ou livros de referência..."
            className="flex w-full rounded-raio-s border border-borda bg-card px-3 py-2 text-sm text-tinta placeholder:text-tinta3 focus:outline-none focus:ring-2 focus:ring-acento/50 resize-none"
          />
        </div>

        <div className="mt-4 flex items-center justify-between pt-4 border-t border-borda gap-3">
          {idOpcional ? (
            <Button
              type="button"
              variant="outline"
              size="sm"
              className="text-fem border-fem/40 hover:bg-fem/10"
              onClick={() => {
                if (confirm('Tem certeza de que deseja excluir esta linha do tempo e todos os seus marcos?')) {
                  mDeletar.mutate();
                }
              }}
              disabled={mDeletar.isPending}
            >
              <Trash2 className="w-4 h-4 mr-1.5" />
              Excluir Linha
            </Button>
          ) : <div />}

          <div className="flex items-center gap-2 ml-auto">
            <Button type="button" variant="ghost" size="sm" onClick={onClose}>
              Cancelar
            </Button>
            <Button
              type="submit"
              variant="primary"
              size="sm"
              disabled={mCriar.isPending || mAtualizar.isPending}
            >
              <Save className="w-4 h-4 mr-1.5" />
              {idOpcional ? 'Salvar Alterações' : 'Criar Linha'}
            </Button>
          </div>
        </div>
      </form>
    </Modal>
  );
}
