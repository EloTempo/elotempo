/**
 * Exportar o acervo histórico público para o portal web.
 *
 * Ferramenta de manutenção do acervo público, e não de uso diário: gera os
 * arquivos JSON que o site elotempo.org/acervo consome. Fica no menu GEDCOM
 * por ser uma exportação, mas o rótulo e esta tela repetem em dois lugares
 * que ela **não** inclui a família do usuário — quem clica num menu chamado
 * "GEDCOM" está pensando nos próprios dados, e a confusão custaria caro.
 *
 * Não passa pelo gatekeeper: o que sai daqui é o acervo público embutido no
 * programa, igual em toda instalação, e não há dado pessoal a proteger.
 */

import { useState } from 'react';
import { Check, Globe, TriangleAlert } from 'lucide-react';
import { Button } from '../../../components/ui/Button';
import { ErroDoAcervo } from '../../../lib/api';
import {
  exportarAcervoWeb,
  formatarBytes,
  type RelatorioExportacao,
} from '../../../lib/api/acervoWeb';

interface Props {
  onFechar: () => void;
}

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo || erro instanceof Error) return erro.message;
  return String(erro);
}

export function DialogoExportarAcervoWeb({ onFechar }: Props) {
  const [exportando, setExportando] = useState(false);
  const [relatorio, setRelatorio] = useState<RelatorioExportacao | null>(null);
  const [erro, setErro] = useState<string | null>(null);

  const exportar = async () => {
    setErro(null);
    try {
      setExportando(true);
      const r = await exportarAcervoWeb();
      // `null` significa que o usuário fechou o seletor de pasta. Cancelar não
      // é falha e não vira mensagem de erro.
      if (r) setRelatorio(r);
    } catch (e) {
      setErro(mensagemDeErro(e));
    } finally {
      setExportando(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm print:hidden">
      <div className="absolute inset-0" onClick={onFechar} aria-hidden />

      <div className="relative w-full max-w-lg bg-card rounded-raio border border-borda shadow-sombra overflow-hidden flex flex-col max-h-[85vh]">
        <header className="p-4 border-b border-borda bg-card2 flex items-start gap-3">
          <Globe className="w-5 h-5 text-acento flex-none mt-0.5" />
          <div>
            <h2 className="font-tit font-bold text-lg m-0">
              Exportar acervo histórico público
            </h2>
            <p className="text-xs text-tinta2 m-0 mt-0.5 leading-relaxed">
              Gera os arquivos do portal web a partir das árvores públicas que
              acompanham o programa.
            </p>
          </div>
        </header>

        <div className="flex-1 overflow-y-auto min-h-0 p-4 flex flex-col gap-4">
          {relatorio ? (
            <div className="flex flex-col gap-3">
              <div className="flex items-start gap-2 p-3 rounded-raio-s border border-acento bg-card2">
                <Check className="w-4 h-4 text-acento flex-none mt-0.5" />
                <div className="text-sm text-tinta">
                  <p className="m-0 font-semibold">Arquivos gerados</p>
                  <p className="m-0 text-xs text-tinta2 break-all mt-1">
                    {relatorio.destino}
                  </p>
                </div>
              </div>

              <ul className="list-none m-0 p-0 text-sm text-tinta2 flex flex-col gap-1">
                <li>
                  {relatorio.arvores}{' '}
                  {relatorio.arvores === 1 ? 'árvore pública' : 'árvores públicas'} ·{' '}
                  {relatorio.pessoas} {relatorio.pessoas === 1 ? 'pessoa' : 'pessoas'}
                </li>
                <li>
                  {relatorio.unioes} {relatorio.unioes === 1 ? 'união' : 'uniões'} ·{' '}
                  {relatorio.linhas_tempo}{' '}
                  {relatorio.linhas_tempo === 1 ? 'linha do tempo' : 'linhas do tempo'}
                </li>
                <li>
                  {relatorio.fotos_copiadas}{' '}
                  {relatorio.fotos_copiadas === 1 ? 'retrato' : 'retratos'} ·{' '}
                  {formatarBytes(relatorio.bytes_de_midia)}
                </li>
              </ul>

              {relatorio.avisos.length > 0 && (
                <div className="flex flex-col gap-1.5 p-3 rounded-raio-s border border-borda bg-card2">
                  <div className="flex items-center gap-1.5 text-sm font-semibold text-tinta">
                    <TriangleAlert className="w-4 h-4 flex-none" />
                    O que ficou de fora
                  </div>
                  <ul className="list-disc m-0 pl-4 text-xs text-tinta2 flex flex-col gap-1">
                    {relatorio.avisos.map((a, i) => (
                      <li key={i}>{a}</li>
                    ))}
                  </ul>
                </div>
              )}

              <p className="text-xs text-tinta3 m-0 leading-relaxed border-t border-borda pt-3">
                No repositório do site, rode{' '}
                <code className="font-num">node scripts/gerar-paginas-acervo.mjs</code>{' '}
                para refazer as páginas de cada linhagem, o índice e o sitemap a
                partir destes arquivos.
              </p>
            </div>
          ) : (
            <>
              {erro && (
                <p
                  role="alert"
                  className="text-sm text-fem m-0 bg-fem/10 border border-fem/20 rounded-raio-s p-3"
                >
                  {erro}
                </p>
              )}

              <p className="text-sm text-tinta2 m-0 leading-relaxed">
                Escolha a pasta <code className="font-num">acervo</code> do
                repositório do site. Serão escritos o catálogo, um arquivo por
                árvore, as linhas do tempo de contexto e os retratos.
              </p>

              <p className="text-sm text-tinta2 m-0 leading-relaxed bg-card2 border border-borda rounded-raio-s p-3">
                <strong className="text-tinta">A sua família não entra aqui.</strong>{' '}
                Esta exportação leva apenas o acervo histórico público que
                acompanha o programa. Para levar os seus dados, use{' '}
                <strong className="text-tinta">Exportar GEDCOM</strong>.
              </p>
            </>
          )}
        </div>

        <footer className="p-4 border-t border-borda bg-card2 flex justify-end gap-2">
          <Button variant="secondary" onClick={onFechar}>
            {relatorio ? 'Fechar' : 'Cancelar'}
          </Button>
          {!relatorio && (
            <Button variant="primary" onClick={exportar} disabled={exportando}>
              {exportando ? 'Exportando…' : 'Escolher pasta e exportar'}
            </Button>
          )}
        </footer>
      </div>
    </div>
  );
}
