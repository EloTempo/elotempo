import { useState } from 'react';
import { Button } from './components/ui/Button';
import { Input } from './components/ui/Input';
import { Modal } from './components/ui/Modal';
import { NodeCard } from './components/tree/NodeCard';
import { PersonForm } from './features/person/PersonForm';
import { TreeGraphViewer } from './components/tree/TreeGraphViewer';
import type { PersonNode, Person, TreeGraph } from './types';

function App() {
  const [tema, setTema] = useState('classico-claro');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [activeTab, setActiveTab] = useState<'components' | 'tree'>('tree');

  const mockPerson: PersonNode = {
    id: '1',
    nome: 'Machado',
    sobrenome: 'de Assis',
    sexo: 'M',
    is_vivo: false,
    is_placeholder: false,
    ano_nascimento: '1839',
  };

  const mockPlaceholder: PersonNode = {
    id: '2',
    nome: 'Carolina',
    sobrenome: 'Augusta',
    sexo: 'F',
    is_vivo: false,
    is_placeholder: false,
  };

  const mockTree: TreeGraph = {
    nodes: [mockPerson, mockPlaceholder],
    unions: [{ id: 'u1', estado_vinculo: 'casamento', data_casamento: '1869' }],
    links: [
      { source: '1', target: 'u1', tipo: 'pai_uniao' },
      { source: '2', target: 'u1', tipo: 'mae_uniao' }
    ]
  };

  const handlePersonSaved = (person: Person) => {
    console.log('Pessoa salva com sucesso:', person);
    alert(`Salvo com sucesso: ${person.nome}`);
    setIsModalOpen(false);
  };

  return (
    <div data-tema={tema} className="min-h-screen bg-mesa flex flex-col items-center p-4 md:p-8 font-corpo">
      <h1 className="text-3xl font-tit font-bold mb-4 text-tinta">Árvore Genealógica</h1>
      
      <div className="flex gap-4 mb-8">
        <Button variant={activeTab === 'tree' ? 'primary' : 'outline'} onClick={() => setActiveTab('tree')}>
          Ver Árvore
        </Button>
        <Button variant={activeTab === 'components' ? 'primary' : 'outline'} onClick={() => setActiveTab('components')}>
          Componentes UI
        </Button>
      </div>

      <div className="w-full max-w-6xl">
        {activeTab === 'tree' ? (
          <div className="bg-card shadow-sombra p-4 md:p-6 rounded-raio border border-borda">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-xl font-tit font-bold">Visualização D3</h2>
              <Button className="bg-masc text-white hover:opacity-90" onClick={() => setIsModalOpen(true)}>
                Nova Pessoa
              </Button>
            </div>
            <TreeGraphViewer 
              data={mockTree} 
              onPersonClick={(p) => console.log('Clicou em:', p.nome)} 
            />
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 w-full">
            {/* Tema */}
            <div className="bg-card shadow-sombra p-6 rounded-raio border border-borda">
              <h2 className="text-xl font-tit mb-4 font-bold">Tema Visual</h2>
              <div className="flex flex-wrap gap-2 mb-6">
                <Button variant={tema === 'classico-claro' ? 'primary' : 'secondary'} size="sm" onClick={() => setTema('classico-claro')}>Clássico Claro</Button>
                <Button variant={tema === 'classico-escuro' ? 'primary' : 'secondary'} size="sm" onClick={() => setTema('classico-escuro')}>Clássico Escuro</Button>
                <Button variant={tema === 'moderno-claro' ? 'primary' : 'secondary'} size="sm" onClick={() => setTema('moderno-claro')}>Moderno Claro</Button>
                <Button variant={tema === 'moderno-escuro' ? 'primary' : 'secondary'} size="sm" onClick={() => setTema('moderno-escuro')}>Moderno Escuro</Button>
              </div>
            </div>

            {/* Inputs */}
            <div className="bg-card shadow-sombra p-6 rounded-raio border border-borda space-y-4 hidden md:block">
              <h2 className="text-xl font-tit mb-4 font-bold">Preview de Inputs</h2>
              <Input label="Nome" placeholder="Ex: Machado" defaultValue="Machado" />
              <Input label="Sobrenome" placeholder="Ex: de Assis" />
            </div>

            {/* Cards */}
            <div className="bg-card shadow-sombra p-6 rounded-raio border border-borda md:col-span-2">
              <h2 className="text-xl font-tit mb-4 font-bold">Nós da Árvore (NodeCards)</h2>
              <div className="flex flex-wrap gap-8 items-center bg-bg p-8 rounded-raio-s border border-borda shadow-inner">
                <NodeCard person={mockPerson} hasBio hasDocuments />
                
                <div className="w-px h-16 bg-linha"></div>
                
                <NodeCard person={mockPlaceholder} />
              </div>
            </div>
          </div>
        )}
      </div>

      <Modal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)}
        title="Cadastrar Nova Pessoa"
      >
        <PersonForm 
          onSuccess={handlePersonSaved}
          onCancel={() => setIsModalOpen(false)}
        />
      </Modal>
    </div>
  );
}

export default App;
