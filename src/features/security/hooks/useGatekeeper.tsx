import React, { createContext, useContext, useState, useCallback } from 'react';
import { useSeguranca } from './useSeguranca';
import { ModalGatekeeper } from '../components/ModalGatekeeper';
import type { StatusSeguranca } from '../../../lib/api';

interface GatekeeperContextValue {
  executarComGatekeeper: (
    descricao: string,
    acao: (ticket: string) => Promise<void> | void,
  ) => Promise<void>;
  status: StatusSeguranca | undefined;
  isLoading: boolean;
}

const GatekeeperContext = createContext<GatekeeperContextValue | null>(null);

export function GatekeeperProvider({ children }: { children: React.ReactNode }) {
  const { status, isLoading } = useSeguranca();
  const [modalAberto, setModalAberto] = useState(false);
  const [descricaoAtual, setDescricaoAtual] = useState('');
  const [acaoPendente, setAcaoPendente] = useState<((ticket: string) => Promise<void> | void) | null>(null);

  const executarComGatekeeper = useCallback(
    async (descricao: string, acao: (ticket: string) => Promise<void> | void) => {
      // Se não estiver no modo blindado ou o gatekeeper não estiver ativo, executa direto!
      if (!status?.modo_blindado || !status?.gatekeeper_ativo) {
        await acao('');
        return;
      }

      setDescricaoAtual(descricao);
      setAcaoPendente(() => acao);
      setModalAberto(true);
    },
    [status],
  );

  const handleConfirmar = async (ticket: string) => {
    setModalAberto(false);
    if (acaoPendente) {
      try {
        await acaoPendente(ticket);
      } finally {
        setAcaoPendente(null);
      }
    }
  };

  const handleCancelar = () => {
    setModalAberto(false);
    setAcaoPendente(null);
  };

  return (
    <GatekeeperContext.Provider value={{ executarComGatekeeper, status, isLoading }}>
      {children}
      <ModalGatekeeper
        isOpen={modalAberto}
        descricao={descricaoAtual}
        onConfirmar={handleConfirmar}
        onCancelar={handleCancelar}
      />
    </GatekeeperContext.Provider>
  );
}

export function useGatekeeper() {
  const context = useContext(GatekeeperContext);
  if (!context) {
    throw new Error('useGatekeeper deve ser usado dentro de um GatekeeperProvider');
  }
  return context;
}
