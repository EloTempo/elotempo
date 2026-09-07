import { useState } from 'react';
import { Printer } from 'lucide-react';
import { Modal } from '../../../components/ui/Modal';
import { Button } from '../../../components/ui/Button';
import { Select } from '../../../components/ui/Select';
import { LinhaTempoAcademicPrintView } from './LinhaTempoAcademicPrintView';
import type { LinhaDeContexto, LinhaPessoal, Marco } from '../../../lib/api';

interface DialogoImprimirLinhaTempoProps {
  linhasContexto: LinhaDeContexto[];
  linhasAtivasIds: string[];
  linhasPessoais: LinhaPessoal[];
  marcos: Marco[];
  anoDeAtual: number;
  anoAteAtual: number;
  regiaoImpressao?: { de: number; ate: number } | null;
  coresPersonalizadas?: Record<string, string>;
  onClose: () => void;
}

export function DialogoImprimirLinhaTempo({
  linhasContexto,
  linhasAtivasIds,
  linhasPessoais,
  marcos,
  anoDeAtual,
  anoAteAtual,
  regiaoImpressao,
  coresPersonalizadas,
  onClose,
}: DialogoImprimirLinhaTempoProps) {
  const pessoaPrincipal = linhasPessoais[0];
  const temVida = pessoaPrincipal && pessoaPrincipal.ano_nascimento != null;

  const [escopo, setEscopo] = useState<'recorte' | 'janela' | 'vida' | 'personalizado'>(
    regiaoImpressao ? 'recorte' : 'janela'
  );
  const [anoDeCustom, setAnoDeCustom] = useState<number>(regiaoImpressao?.de ?? anoDeAtual);
  const [anoAteCustom, setAnoAteCustom] = useState<number>(regiaoImpressao?.ate ?? anoAteAtual);
  const [anosPorFaixa, setAnosPorFaixa] = useState<number>(40);

  // Calcula o intervalo efetivo de anos para impressão
  let de = anoDeAtual;
  let ate = anoAteAtual;

  if (escopo === 'recorte' && regiaoImpressao) {
    de = regiaoImpressao.de;
    ate = regiaoImpressao.ate;
  } else if (escopo === 'vida' && temVida) {
    de = pessoaPrincipal.ano_nascimento! - 2;
    ate =
      (pessoaPrincipal.ano_falecimento ??
        (pessoaPrincipal.is_vivo ? new Date().getFullYear() : pessoaPrincipal.ano_nascimento! + 80)) + 2;
  } else if (escopo === 'personalizado') {
    de = anoDeCustom;
    ate = anoAteCustom;
  }

  const handlePrint = () => {
    window.print();
  };

  return (
    <>
      <Modal
        isOpen={true}
        onClose={onClose}
        title="Imprimir Linha do Tempo"
        className="max-w-lg print:hidden"
      >
        <div className="flex flex-col gap-4 text-sm">
          <p className="text-tinta2 leading-relaxed">
            A linha do tempo será impressa em faixas sucessivas com o eixo de anos repetido e os
            acontecimentos numerados logo abaixo de cada período, otimizado para papel e PDF.
          </p>

          <Select
            label="Recorte Temporal"
            value={escopo}
            onChange={(e) => setEscopo(e.target.value as any)}
            options={[
              ...(regiaoImpressao
                ? [
                    {
                      value: 'recorte',
                      label: `✂ Recorte delimitado (${regiaoImpressao.de} a ${regiaoImpressao.ate})`,
                    },
                  ]
                : []),
              { value: 'janela', label: `Janela visível na tela (${anoDeAtual} a ${anoAteAtual})` },
              ...(temVida
                ? [
                    {
                      value: 'vida',
                      label: `Vida inteira de ${pessoaPrincipal.nome} (${pessoaPrincipal.ano_nascimento} a ${
                        pessoaPrincipal.ano_falecimento ?? (pessoaPrincipal.is_vivo ? 'atual' : 'fim')
                      })`,
                    },
                  ]
                : []),
              { value: 'personalizado', label: 'Definir anos manualmente...' },
            ]}
          />

          {escopo === 'personalizado' && (
            <div className="grid grid-cols-2 gap-3">
              <div>
                <label className="block text-xs font-semibold text-tinta2 mb-1">Ano Inicial</label>
                <input
                  type="number"
                  value={anoDeCustom}
                  onChange={(e) => setAnoDeCustom(Number(e.target.value))}
                  className="flex h-9 w-full rounded-raio-s border border-borda bg-card px-3 py-1.5 text-sm text-tinta font-num"
                />
              </div>
              <div>
                <label className="block text-xs font-semibold text-tinta2 mb-1">Ano Final</label>
                <input
                  type="number"
                  value={anoAteCustom}
                  onChange={(e) => setAnoAteCustom(Number(e.target.value))}
                  className="flex h-9 w-full rounded-raio-s border border-borda bg-card px-3 py-1.5 text-sm text-tinta font-num"
                />
              </div>
            </div>
          )}

          <Select
            label="Anos por Faixa na Folha"
            value={String(anosPorFaixa)}
            onChange={(e) => setAnosPorFaixa(Number(e.target.value))}
            options={[
              { value: '25', label: '25 anos por faixa (Mais espaçado e detalhado)' },
              { value: '40', label: '40 anos por faixa (Recomendado para páginas A4)' },
              { value: '60', label: '60 anos por faixa (Visão mais condensada)' },
            ]}
          />

          <div className="p-3 bg-sup border border-borda rounded-raio-s text-xs text-tinta2 flex flex-col gap-1">
            <span className="font-semibold text-tinta">Dica de Impressão:</span>
            <span>
              Para melhor legibilidade das faixas e régua de anos, escolha a orientação{' '}
              <strong>Paisagem (Horizontal)</strong> na janela de impressão do sistema.
            </span>
          </div>

          <div className="mt-2 flex items-center justify-end gap-2 pt-3 border-t border-borda">
            <Button variant="ghost" size="sm" onClick={onClose}>
              Cancelar
            </Button>
            <Button variant="primary" size="sm" onClick={handlePrint}>
              <Printer className="w-4 h-4 mr-1.5" />
              Imprimir / Salvar em PDF
            </Button>
          </div>
        </div>
      </Modal>

      {/* Renderizador oculto na tela, visível apenas no @media print */}
      <LinhaTempoAcademicPrintView
        dados={{
          linhasPessoais,
          linhasContexto,
          linhasAtivasIds,
          marcos,
          coresPersonalizadas: coresPersonalizadas ?? {},
          janelaAtual: { de: anoDeAtual, ate: anoAteAtual },
          regiaoImpressao: regiaoImpressao ?? null,
          calendarioAtivo: 'gregoriano',
        }}
        opcoes={{
          numeroFigura: '1',
          tituloFigura: 'Linha do Tempo Genealógica e Histórica',
          fonteTexto: 'Elaborado pelo autor com o software EloTempo (2026)',
          incluirQuadroMarcos: true,
          anosPorPagina: anosPorFaixa,
          anoDe: de,
          anoAte: ate,
        }}
        modoPreview={false}
      />
    </>
  );
}
