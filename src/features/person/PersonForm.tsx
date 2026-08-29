import { useState, useEffect } from 'react';
import { Input } from '../../components/ui/Input';
import { Select } from '../../components/ui/Select';
import { Button } from '../../components/ui/Button';
import type { Person, Sex } from '../../types';
import { createPerson, updatePerson } from '../../lib/api';

interface PersonFormProps {
  initialData?: Person;
  onSuccess?: (person: Person) => void;
  onCancel?: () => void;
}

export function PersonForm({ initialData, onSuccess, onCancel }: PersonFormProps) {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [formData, setFormData] = useState<Partial<Person>>({
    nome: '',
    sobrenome: '',
    sexo: 'U',
    is_vivo: true,
    is_placeholder: false,
    minibiografia: '',
  });

  useEffect(() => {
    if (initialData) {
      setFormData(initialData);
    }
  }, [initialData]);

  const handleChange = (field: keyof Person, value: any) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.nome || formData.nome.trim() === '') {
      setError('O nome é obrigatório.');
      return;
    }
    
    setLoading(true);
    setError(null);

    try {
      const isEditing = !!initialData?.id;
      
      const personToSave: Person = {
        id: isEditing ? initialData!.id : crypto.randomUUID(),
        nome: formData.nome!.trim(),
        sobrenome: formData.sobrenome?.trim() || undefined,
        sexo: formData.sexo as Sex,
        is_vivo: formData.is_vivo ?? true,
        is_placeholder: formData.is_placeholder ?? false,
        minibiografia: formData.minibiografia?.trim() || undefined,
        foto_url: formData.foto_url,
      };

      if (isEditing) {
        await updatePerson(personToSave);
      } else {
        await createPerson(personToSave);
      }

      onSuccess?.(personToSave);
    } catch (err: any) {
      console.error(err);
      setError(err?.toString() || 'Ocorreu um erro ao salvar a pessoa.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      {error && (
        <div className="bg-fem/10 text-fem p-3 rounded-raio-s text-sm border border-fem/20">
          {error}
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Input 
          label="Nome *" 
          placeholder="Ex: João" 
          value={formData.nome || ''}
          onChange={(e) => handleChange('nome', e.target.value)}
          required
        />
        <Input 
          label="Sobrenome" 
          placeholder="Ex: Silva" 
          value={formData.sobrenome || ''}
          onChange={(e) => handleChange('sobrenome', e.target.value)}
        />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Select
          label="Sexo *"
          value={formData.sexo || 'U'}
          onChange={(e) => handleChange('sexo', e.target.value)}
          options={[
            { value: 'M', label: 'Masculino' },
            { value: 'F', label: 'Feminino' },
            { value: 'X', label: 'Não-binário/Outro' },
            { value: 'U', label: 'Desconhecido' },
          ]}
        />

        <div className="flex flex-col justify-end pb-2">
          <label className="flex items-center gap-2 cursor-pointer text-sm font-semibold text-tinta2 hover:text-tinta transition-colors">
            <input 
              type="checkbox" 
              className="rounded border-borda text-acento focus:ring-acento/50"
              checked={formData.is_vivo}
              onChange={(e) => handleChange('is_vivo', e.target.checked)}
            />
            Pessoa viva
          </label>
        </div>
      </div>

      <div>
        <label className="block text-sm font-semibold mb-1 text-tinta2">Minibiografia</label>
        <textarea
          className="flex w-full rounded-raio-s border border-borda bg-card px-3 py-2 text-sm text-tinta placeholder:text-tinta3 focus:outline-none focus:ring-2 focus:ring-acento/50 min-h-[100px] resize-y"
          placeholder="Notas breves sobre a vida..."
          value={formData.minibiografia || ''}
          onChange={(e) => handleChange('minibiografia', e.target.value)}
        />
      </div>
      
      {/* Escondendo a checkbox de placeholder pois normalmente isso é gerenciado pelas regras de união, mas mantendo caso precisem forçar */}
      <div className="hidden">
        <label className="flex items-center gap-2 text-sm text-tinta2">
          <input 
            type="checkbox" 
            checked={formData.is_placeholder}
            onChange={(e) => handleChange('is_placeholder', e.target.checked)}
          />
          É um Placeholder (Pai/Mãe desconhecido)
        </label>
      </div>

      <div className="flex items-center justify-end gap-3 pt-4 border-t border-borda mt-6">
        {onCancel && (
          <Button type="button" variant="ghost" onClick={onCancel}>
            Cancelar
          </Button>
        )}
        <Button type="submit" disabled={loading}>
          {loading ? 'Salvando...' : (initialData?.id ? 'Atualizar' : 'Criar Pessoa')}
        </Button>
      </div>
    </form>
  );
}
