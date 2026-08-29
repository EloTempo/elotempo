import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],

  // O Tauri controla o próprio console; limpar a tela apagaria os erros do Rust.
  clearScreen: false,

  server: {
    port: 1420,
    // Porta fixa: o `devUrl` do tauri.conf.json aponta para ela. Se o Vite
    // escolhesse outra ao encontrar a 1420 ocupada, a janela abriria em branco.
    strictPort: true,
  },

  envPrefix: ['VITE_', 'TAURI_'],

  build: {
    // Alvos dos webviews que o Tauri usa: WebView2 no Windows, WKWebView
    // no macOS e Linux.
    target: process.env.TAURI_PLATFORM === 'windows' ? 'chrome105' : 'safari13',
    // Vite 8 minifica com oxc; 'esbuild' foi removido.
    minify: process.env.TAURI_DEBUG ? false : 'oxc',
    sourcemap: !!process.env.TAURI_DEBUG,
  },
});
