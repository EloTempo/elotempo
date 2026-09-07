import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { ToastNotificacao, type ToastMensagem } from '../components/ui/ToastNotificacao';

export interface AcaoHistorico {
  id: string;
  descricao: string;
  timestamp: Date;
  desfazer: () => Promise<void>;
  refazer: () => Promise<void>;
}

interface HistoricoContextData {
  registrarAcao: (acao: {
    descricao: string;
    desfazer: () => Promise<void>;
    refazer: () => Promise<void>;
  }) => void;
  desfazer: () => Promise<void>;
  refazer: () => Promise<void>;
  podeDesfazer: boolean;
  podeRefazer: boolean;
  proximoDesfazer: string | null;
  proximoRefazer: string | null;
  pilhaDesfazer: AcaoHistorico[];
  pilhaRefazer: AcaoHistorico[];
  emExecucao: boolean;
}

const HistoricoContext = createContext<HistoricoContextData | null>(null);

const LIMITE_PILHA = 30;

export function HistoricoProvider({ children }: { children: React.ReactNode }) {
  const [pilhaDesfazer, setPilhaDesfazer] = useState<AcaoHistorico[]>([]);
  const [pilhaRefazer, setPilhaRefazer] = useState<AcaoHistorico[]>([]);
  const [emExecucao, setEmExecucao] = useState(false);
  const [toasts, setToasts] = useState<ToastMensagem[]>([]);

  const dispararToast = useCallback(
    (tipo: 'desfazer' | 'refazer' | 'info', texto: string) => {
      const id = Math.random().toString(36).substring(2, 9);
      setToasts((prev) => [...prev, { id, tipo, texto }]);
    },
    [],
  );

  const removerToast = useCallback((id: string) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  }, []);

  const registrarAcao = useCallback(
    (nova: {
      descricao: string;
      desfazer: () => Promise<void>;
      refazer: () => Promise<void>;
    }) => {
      const item: AcaoHistorico = {
        id: Math.random().toString(36).substring(2, 9),
        descricao: nova.descricao,
        timestamp: new Date(),
        desfazer: nova.desfazer,
        refazer: nova.refazer,
      };

      setPilhaDesfazer((prev) => [item, ...prev].slice(0, LIMITE_PILHA));
      // Nova ação limpa a pilha de refazer (comportamento canônico de undo/redo)
      setPilhaRefazer([]);
    },
    [],
  );

  const desfazer = useCallback(async () => {
    if (pilhaDesfazer.length === 0 || emExecucao) return;
    setEmExecucao(true);

    const [acao, ...restoDesfazer] = pilhaDesfazer;
    try {
      await acao.desfazer();
      setPilhaDesfazer(restoDesfazer);
      setPilhaRefazer((prev) => [acao, ...prev].slice(0, LIMITE_PILHA));
      dispararToast('desfazer', `Desfeito: ${acao.descricao}`);
    } catch (err: any) {
      console.error('Erro ao desfazer ação:', err);
      dispararToast('info', `Falha ao desfazer: ${err?.message || 'erro desconhecido'}`);
    } finally {
      setEmExecucao(false);
    }
  }, [pilhaDesfazer, emExecucao, dispararToast]);

  const refazer = useCallback(async () => {
    if (pilhaRefazer.length === 0 || emExecucao) return;
    setEmExecucao(true);

    const [acao, ...restoRefazer] = pilhaRefazer;
    try {
      await acao.refazer();
      setPilhaRefazer(restoRefazer);
      setPilhaDesfazer((prev) => [acao, ...prev].slice(0, LIMITE_PILHA));
      dispararToast('refazer', `Refeito: ${acao.descricao}`);
    } catch (err: any) {
      console.error('Erro ao refazer ação:', err);
      dispararToast('info', `Falha ao refazer: ${err?.message || 'erro desconhecido'}`);
    } finally {
      setEmExecucao(false);
    }
  }, [pilhaRefazer, emExecucao, dispararToast]);

  // Captura global de atalhos Ctrl+Z e Ctrl+Y / Ctrl+Shift+Z
  useEffect(() => {
    function handleKeyDown(e: KeyboardEvent) {
      const target = e.target as HTMLElement | null;
      const tag = target?.tagName?.toLowerCase();
      const isInput =
        tag === 'input' ||
        tag === 'textarea' ||
        tag === 'select' ||
        target?.isContentEditable;

      // Se o usuário está digitando num campo de texto, deixa o browser cuidar do undo do texto
      if (isInput) return;

      const isModifier = e.ctrlKey || e.metaKey;
      if (!isModifier) return;

      const key = e.key.toLowerCase();

      if (key === 'z' && !e.shiftKey) {
        e.preventDefault();
        desfazer();
      } else if (key === 'y' || (key === 'z' && e.shiftKey)) {
        e.preventDefault();
        refazer();
      }
    }

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [desfazer, refazer]);

  const podeDesfazer = pilhaDesfazer.length > 0 && !emExecucao;
  const podeRefazer = pilhaRefazer.length > 0 && !emExecucao;
  const proximoDesfazer = pilhaDesfazer[0]?.descricao ?? null;
  const proximoRefazer = pilhaRefazer[0]?.descricao ?? null;

  return (
    <HistoricoContext.Provider
      value={{
        registrarAcao,
        desfazer,
        refazer,
        podeDesfazer,
        podeRefazer,
        proximoDesfazer,
        proximoRefazer,
        pilhaDesfazer,
        pilhaRefazer,
        emExecucao,
      }}
    >
      {children}
      <ToastNotificacao toasts={toasts} onRemover={removerToast} />
    </HistoricoContext.Provider>
  );
}

export function useHistorico() {
  const ctx = useContext(HistoricoContext);
  if (!ctx) {
    throw new Error('useHistorico deve ser usado dentro de um HistoricoProvider');
  }
  return ctx;
}
