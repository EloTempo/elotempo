import React from 'react';
import ReactDOM from 'react-dom/client';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import App from './App';
import { HistoricoProvider } from './contexts/HistoricoContext';
import { I18nProvider } from './i18n/I18nContext';
import { GatekeeperProvider } from './features/security';
import './assets/globals.css';

/**
 * O provider faltava.
 *
 * Vários componentes já usavam `useQuery`/`useMutation` e teriam lançado
 * exceção no primeiro render — só não quebravam porque nenhum deles estava
 * montado. Agora que a árvore lê do banco de verdade, ele é obrigatório.
 *
 * Os padrões são calibrados para um app local: não há rede para falhar, o
 * SQLite responde em milissegundos, então re-tentar e revalidar ao focar a
 * janela só geraria trabalho inútil.
 */
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: false,
      refetchOnWindowFocus: false,
      staleTime: 60_000,
    },
  },
});

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <HistoricoProvider>
        <I18nProvider>
          <GatekeeperProvider>
            <App />
          </GatekeeperProvider>
        </I18nProvider>
      </HistoricoProvider>
    </QueryClientProvider>
  </React.StrictMode>,
);
