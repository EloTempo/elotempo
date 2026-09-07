/**
 * Modal de Criação e Edição de Marcador Temporal com Comentário / Anotação (estilo DaVinci Resolve Marker).
 */

import React, { useState, useEffect } from 'react';
import { Bookmark, Trash2, X } from 'lucide-react';
import {
  type MarcadorLinhaTempo,
  criarMarcador,
  atualizarMarcador,
  deletarMarcador,
} from '../../../lib/api/marcadores';
import { useI18n } from '../../../i18n/I18nContext';

export interface ModalMarcadorComentarioProps {
  aberto: boolean;
  anoInicial?: number;
  marcadorParaEditar?: MarcadorLinhaTempo | null;
  aoFechar: () => void;
  aoSalvar: () => void;
}

const CORES_MARCADOR = [
  { id: 'azul', nome: 'Azul', hex: '#3b82f6' },
  { id: 'verde', nome: 'Verde', hex: '#10b981' },
  { id: 'amarelo', nome: 'Amarelo', hex: '#f59e0b' },
  { id: 'vermelho', nome: 'Vermelho', hex: '#ef4444' },
  { id: 'roxo', nome: 'Roxo', hex: '#8b5cf6' },
  { id: 'ciano', nome: 'Ciano', hex: '#06b6d4' },
];

export const ModalMarcadorComentario: React.FC<ModalMarcadorComentarioProps> = ({
  aberto,
  anoInicial = new Date().getFullYear(),
  marcadorParaEditar,
  aoFechar,
  aoSalvar,
}) => {
  const { t } = useI18n();
  const [ano, setAno] = useState<number>(anoInicial);
  const [titulo, setTitulo] = useState<string>('');
  const [comentario, setComentario] = useState<string>('');
  const [cor, setCor] = useState<string>('azul');
  const [salvando, setSalvando] = useState<boolean>(false);
  const [erro, setErro] = useState<string | null>(null);

  useEffect(() => {
    if (marcadorParaEditar) {
      setAno(marcadorParaEditar.ano);
      setTitulo(marcadorParaEditar.titulo);
      setComentario(marcadorParaEditar.comentario ?? '');
      setCor(marcadorParaEditar.cor ?? 'azul');
    } else {
      setAno(anoInicial);
      setTitulo('');
      setComentario('');
      setCor('azul');
    }
    setErro(null);
  }, [marcadorParaEditar, anoInicial, aberto]);

  if (!aberto) return null;

  const handleSalvar = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!titulo.trim()) {
      setErro('Por favor, informe um título para o marcador.');
      return;
    }

    setSalvando(true);
    setErro(null);
    try {
      if (marcadorParaEditar) {
        await atualizarMarcador({
          id: marcadorParaEditar.id,
          ano: Number(ano),
          titulo: titulo.trim(),
          comentario: comentario.trim() || null,
          cor,
        });
      } else {
        await criarMarcador({
          ano: Number(ano),
          titulo: titulo.trim(),
          comentario: comentario.trim() || null,
          cor,
        });
      }
      aoSalvar();
      aoFechar();
    } catch (err: any) {
      setErro(err?.message ?? 'Erro ao salvar o marcador.');
    } finally {
      setSalvando(false);
    }
  };

  const handleExcluir = async () => {
    if (!marcadorParaEditar) return;
    if (!confirm('Deseja excluir este marcador temporal?')) return;

    setSalvando(true);
    try {
      await deletarMarcador(marcadorParaEditar.id);
      aoSalvar();
      aoFechar();
    } catch (err: any) {
      setErro(err?.message ?? 'Erro ao excluir o marcador.');
    } finally {
      setSalvando(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-xs select-none">
      <div className="bg-card border border-borda rounded-raio shadow-sombra max-w-md w-full overflow-hidden flex flex-col animate-in fade-in zoom-in-95 duration-150">
        {/* Cabeçalho */}
        <div className="px-5 py-3.5 border-b border-borda flex items-center justify-between bg-card2/50">
          <div className="flex items-center gap-2">
            <Bookmark className="w-4 h-4 text-acento" />
            <h3 className="font-semibold text-sm text-tinta m-0">
              {marcadorParaEditar ? t('linhaTempo', 'editarMarcador') : t('linhaTempo', 'adicionarMarcador')}
            </h3>
          </div>
          <button
            type="button"
            onClick={aoFechar}
            className="p-1 rounded hover:bg-sup text-tinta3 hover:text-tinta cursor-pointer"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Formulário */}
        <form onSubmit={handleSalvar} className="p-5 flex flex-col gap-4">
          {erro && (
            <div className="p-2.5 rounded bg-fem/10 border border-fem/30 text-fem text-xs font-medium">
              {erro}
            </div>
          )}

          <div className="grid grid-cols-3 gap-3">
            {/* Ano */}
            <div className="flex flex-col gap-1.5">
              <label className="text-xs font-semibold text-tinta2 flex items-center justify-between">
                <span>{t('linhaTempo', 'anoMarcador')}</span>
                {!marcadorParaEditar && (
                  <span className="text-[10px] font-normal text-rose-500 flex items-center gap-0.5">
                    📍 Agulha
                  </span>
                )}
              </label>
              <input
                type="number"
                value={ano}
                onChange={(e) => setAno(Number(e.target.value))}
                className="px-3 py-1.5 rounded-raio-s border border-borda bg-sup text-tinta text-xs font-num focus:border-acento focus:outline-none"
                required
              />
            </div>

            {/* Cor */}
            <div className="col-span-2 flex flex-col gap-1.5">
              <label className="text-xs font-semibold text-tinta2">
                {t('linhaTempo', 'corMarcador')}
              </label>
              <div className="flex items-center gap-1.5 pt-1">
                {CORES_MARCADOR.map((c) => (
                  <button
                    key={c.id}
                    type="button"
                    onClick={() => setCor(c.id)}
                    className={`w-6 h-6 rounded-full transition-transform cursor-pointer relative ${
                      cor === c.id ? 'scale-115 ring-2 ring-tinta ring-offset-2 ring-offset-card' : 'hover:scale-105 opacity-80 hover:opacity-100'
                    }`}
                    style={{ backgroundColor: c.hex }}
                    title={c.nome}
                  />
                ))}
              </div>
            </div>
          </div>

          {/* Título */}
          <div className="flex flex-col gap-1.5">
            <label className="text-xs font-semibold text-tinta2">
              {t('linhaTempo', 'tituloMarcador')}
            </label>
            <input
              type="text"
              value={titulo}
              onChange={(e) => setTitulo(e.target.value)}
              placeholder="Ex: Chegada da Família ao Brasil, Mudança de Cidade..."
              className="px-3 py-1.5 rounded-raio-s border border-borda bg-sup text-tinta text-xs focus:border-acento focus:outline-none"
              autoFocus
              required
            />
          </div>

          {/* Comentário / Observações */}
          <div className="flex flex-col gap-1.5">
            <label className="text-xs font-semibold text-tinta2">
              {t('linhaTempo', 'comentarioMarcador')}
            </label>
            <textarea
              rows={4}
              value={comentario}
              onChange={(e) => setComentario(e.target.value)}
              placeholder="Escreva anotações sobre este ponto na história, reflexões ou notas biográficas..."
              className="px-3 py-2 rounded-raio-s border border-borda bg-sup text-tinta text-xs resize-none focus:border-acento focus:outline-none leading-relaxed"
            />
          </div>

          {/* Rodapé e Ações */}
          <div className="flex items-center justify-between gap-2 pt-2 border-t border-borda mt-1">
            {marcadorParaEditar ? (
              <button
                type="button"
                onClick={handleExcluir}
                disabled={salvando}
                className="px-3 py-1.5 rounded-raio-s text-xs font-semibold text-fem hover:bg-fem/10 transition-colors flex items-center gap-1.5 cursor-pointer disabled:opacity-50"
              >
                <Trash2 className="w-3.5 h-3.5" />
                <span>{t('linhaTempo', 'excluirMarcador')}</span>
              </button>
            ) : (
              <div />
            )}

            <div className="flex items-center gap-2">
              <button
                type="button"
                onClick={aoFechar}
                disabled={salvando}
                className="px-3 py-1.5 rounded-raio-s border border-borda bg-sup hover:bg-card text-tinta2 hover:text-tinta text-xs font-medium transition-colors cursor-pointer"
              >
                Cancelar
              </button>
              <button
                type="submit"
                disabled={salvando}
                className="px-4 py-1.5 rounded-raio-s bg-acento text-acento-tinta hover:bg-acento/90 text-xs font-semibold transition-colors shadow-xs cursor-pointer disabled:opacity-50"
              >
                {salvando ? 'Salvando...' : 'Salvar Marcador'}
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
};
