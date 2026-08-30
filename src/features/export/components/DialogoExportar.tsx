/**
 * Exportar o acervo para GEDCOM (fatia 08).
 *
 * A seção 1 lista portabilidade como princípio inegociável: "o usuário é dono
 * do arquivo e deve poder exportar tudo". Um SQLite que só este programa sabe
 * ler cumpre isso pela metade — esta tela fecha a outra metade.
 */

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Check, Download, FileDown, Package } from 'lucide-react';
import { Button } from '../../../components/ui/Button';
import {
  exportarGedcom,
  extensaoDeExportacao,
  escolherOndeSalvar,
  ErroDoAcervo,
  type ResumoExportacao,
} from '../../../lib/api';

interface DialogoExportarProps {
  raizId: string | null;
  onFechar: () => void;
}

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo || erro instanceof Error) return erro.message;
  return String(erro);
}

export function DialogoExportar({ raizId, onFechar }: DialogoExportarProps) {
  const [escopoArvore, setEscopoArvore] = useState(false);
  const [ocultarVivas, setOcultarVivas] = useState(false);
  const [incluirMidia, setIncluirMidia] = useState(true);

  const [exportando, setExportando] = useState(false);
  const [resumo, setResumo] = useState<ResumoExportacao | null>(null);
  const [erro, setErro] = useState<string | null>(null);

  const { data: extensao } = useQuery({
    queryKey: ['extensao-exportacao', incluirMidia],
    queryFn: () => extensaoDeExportacao(incluirMidia),
  });

  const exportar = async () => {
    setErro(null);
    try {
      const caminho = await escolherOndeSalvar(extensao ?? 'ged');
      if (!caminho) return; // cancelou, o que é normal

      setExportando(true);
      const r = await exportarGedcom(caminho, {
        raiz_id: escopoArvore ? raizId : null,
        ocultar_vivas: ocultarVivas,
        incluir_midia: incluirMidia,
      });
      setResumo(r);
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
          <FileDown className="w-5 h-5 text-acento flex-none mt-0.5" />
          <div>
            <h2 className="font-tit font-bold text-lg m-0">Exportar o acervo</h2>
            <p className="text-xs text-tinta2 m-0 mt-0.5 leading-relaxed">
              GEDCOM 7.0 — o formato que outros programas de genealogia leem.
            </p>
          </div>
        </header>

        <div className="flex-1 overflow-y-auto min-h-0 p-4 flex flex-col gap-4">
          {/* Depois de exportar, a tela vira o comprovante do que saiu. */}
          {resumo ? (
            <div className="flex flex-col gap-3">
              <div className="flex items-start gap-2 p-3 rounded-raio-s border border-acento bg-card2">
                <Check className="w-4 h-4 text-acento flex-none mt-0.5" />
                <div className="text-sm text-tinta">
                  <p className="m-0 font-semibold">
                    {resumo.empacotado ? 'Pacote GEDZip criado' : 'Arquivo criado'}
                  </p>
                  <p className="m-0 text-xs text-tinta2 break-all mt-1">{resumo.caminho}</p>
                </div>
              </div>

              <ul className="list-none m-0 p-0 text-sm text-tinta2 flex flex-col gap-1">
                <li>
                  {resumo.pessoas} {resumo.pessoas === 1 ? 'pessoa' : 'pessoas'} ·{' '}
                  {resumo.unioes} {resumo.unioes === 1 ? 'união' : 'uniões'}
                </li>
                {resumo.arquivos_de_midia > 0 && (
                  <li>
                    {resumo.arquivos_de_midia}{' '}
                    {resumo.arquivos_de_midia === 1 ? 'arquivo' : 'arquivos'} de mídia no pacote
                  </li>
                )}
                {resumo.vivas_ocultadas > 0 && (
                  <li>
                    {resumo.vivas_ocultadas}{' '}
                    {resumo.vivas_ocultadas === 1 ? 'pessoa viva teve' : 'pessoas vivas tiveram'}{' '}
                    os dados omitidos, mantendo o parentesco
                  </li>
                )}
              </ul>

              <p className="text-xs text-tinta3 m-0 leading-relaxed border-t border-borda pt-3">
                Guarde este arquivo junto dos seus backups. Ele abre no Gramps, no Ancestris e
                em qualquer programa que leia GEDCOM — é a garantia de que o seu trabalho não
                depende deste programa continuar existindo.
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

              <fieldset className="flex flex-col gap-2.5 border-none p-0 m-0">
                <legend className="font-num text-[10.5px] uppercase tracking-wider text-tinta3 mb-1 p-0">
                  O que exportar
                </legend>

                <label className="flex items-start gap-2 text-sm text-tinta2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={escopoArvore}
                    disabled={!raizId}
                    onChange={(e) => setEscopoArvore(e.target.checked)}
                    className="mt-0.5 rounded border-borda accent-[var(--acento)]"
                  />
                  <span>
                    Só a árvore em volta da pessoa selecionada
                    {!raizId && (
                      <span className="block text-xs text-tinta3">
                        Escolha alguém na lista para habilitar.
                      </span>
                    )}
                  </span>
                </label>

                <label className="flex items-start gap-2 text-sm text-tinta2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={incluirMidia}
                    onChange={(e) => setIncluirMidia(e.target.checked)}
                    className="mt-0.5 rounded border-borda accent-[var(--acento)]"
                  />
                  <span>
                    Levar as fotos e documentos junto
                    <span className="block text-xs text-tinta3 leading-relaxed">
                      Gera um GEDZip — o arquivo GEDCOM mais a pasta de mídia, num pacote só.
                      Sem isso, o arquivo referencia fotos que ficaram para trás.
                    </span>
                  </span>
                </label>

                <label className="flex items-start gap-2 text-sm text-tinta2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={ocultarVivas}
                    onChange={(e) => setOcultarVivas(e.target.checked)}
                    className="mt-0.5 rounded border-borda accent-[var(--acento)]"
                  />
                  <span>
                    Ocultar dados de pessoas vivas
                    <span className="block text-xs text-tinta3 leading-relaxed">
                      Elas continuam no arquivo, sem nome nem datas, para o parentesco de quem
                      recebe não se partir. Use ao mandar a árvore para fora da família.
                    </span>
                  </span>
                </label>
              </fieldset>

              <p className="text-xs text-tinta3 m-0 leading-relaxed border-t border-borda pt-3 flex items-start gap-2">
                <Package className="w-3.5 h-3.5 flex-none mt-0.5" />
                <span>
                  Os “desconhecidos” que seguram lugar de pai ou mãe não são exportados como
                  pessoas — a união simplesmente sai com um lado só, que é GEDCOM válido.
                </span>
              </p>
            </>
          )}
        </div>

        <footer className="p-4 border-t border-borda flex justify-end gap-3 flex-none">
          <Button variant="ghost" onClick={onFechar}>
            {resumo ? 'Fechar' : 'Cancelar'}
          </Button>
          {!resumo && (
            <Button onClick={exportar} disabled={exportando}>
              <Download className="w-4 h-4 mr-1" />
              {exportando ? 'Exportando…' : 'Escolher onde salvar'}
            </Button>
          )}
        </footer>
      </div>
    </div>
  );
}
