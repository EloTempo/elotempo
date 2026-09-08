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
import { useGatekeeper } from '../../security';
import { useI18n } from '../../../i18n/I18nContext';
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
  const { t } = useI18n();
  const { executarComGatekeeper } = useGatekeeper();
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

      await executarComGatekeeper(t('seguranca', 'gatekeeperDescGedcom'), async (ticket) => {
        setExportando(true);
        try {
          const r = await exportarGedcom(caminho, {
            raiz_id: escopoArvore ? raizId : null,
            ocultar_vivas: ocultarVivas,
            incluir_midia: incluirMidia,
          }, ticket);
          setResumo(r);
        } finally {
          setExportando(false);
        }
      });
    } catch (e) {
      setErro(mensagemDeErro(e));
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm print:hidden">
      <div className="absolute inset-0" onClick={onFechar} aria-hidden />

      <div className="relative w-full max-w-lg bg-card rounded-raio border border-borda shadow-sombra overflow-hidden flex flex-col max-h-[85vh]">
        <header className="p-4 border-b border-borda bg-card2 flex items-start gap-3">
          <FileDown className="w-5 h-5 text-acento flex-none mt-0.5" />
          <div>
            <h2 className="font-tit font-bold text-lg m-0">{t('gedcom', 'exportarTitulo')}</h2>
            <p className="text-xs text-tinta2 m-0 mt-0.5 leading-relaxed">
              {t('gedcom', 'exportarSubtitulo')}
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
                    {resumo.empacotado ? t('gedcom', 'pacoteGedzipCriado') : t('gedcom', 'arquivoCriado')}
                  </p>
                  <p className="m-0 text-xs text-tinta2 break-all mt-1">{resumo.caminho}</p>
                </div>
              </div>

              <ul className="list-none m-0 p-0 text-sm text-tinta2 flex flex-col gap-1">
                <li>
                  {resumo.pessoas} {resumo.pessoas === 1 ? t('gedcom', 'pessoa') : t('gedcom', 'pessoas')} ·{' '}
                  {resumo.unioes} {resumo.unioes === 1 ? t('gedcom', 'uniao') : t('gedcom', 'unioes')}
                </li>
                {resumo.arquivos_de_midia > 0 && (
                  <li>
                    {resumo.arquivos_de_midia}{' '}
                    {resumo.arquivos_de_midia === 1 ? t('gedcom', 'arquivoMidiaNoPacote') : t('gedcom', 'arquivosMidiaNoPacote')}
                  </li>
                )}
                {resumo.vivas_ocultadas > 0 && (
                  <li>
                    {resumo.vivas_ocultadas}{' '}
                    {resumo.vivas_ocultadas === 1 ? t('gedcom', 'pessoaVivaOcultada') : t('gedcom', 'pessoasVivasOcultadas')}
                  </li>
                )}
              </ul>

              <p className="text-xs text-tinta3 m-0 leading-relaxed border-t border-borda pt-3">
                {t('gedcom', 'dicaBackup')}
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
                  {t('gedcom', 'oQueExportar')}
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
                    {t('gedcom', 'soArvoreEmVolta')}
                    {!raizId && (
                      <span className="block text-xs text-tinta3">
                        {t('gedcom', 'escolhaAlguemLista')}
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
                    {t('gedcom', 'levarFotosDocumentos')}
                    <span className="block text-xs text-tinta3 leading-relaxed">
                      {t('gedcom', 'levarFotosDocumentosDesc')}
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
                    {t('gedcom', 'ocultarDadosVivas')}
                    <span className="block text-xs text-tinta3 leading-relaxed">
                      {t('gedcom', 'ocultarDadosVivasDesc')}
                    </span>
                  </span>
                </label>
              </fieldset>

              <p className="text-xs text-tinta3 m-0 leading-relaxed border-t border-borda pt-3 flex items-start gap-2">
                <Package className="w-3.5 h-3.5 flex-none mt-0.5" />
                <span>
                  {t('gedcom', 'desconhecidosLugarPaiMae')}
                </span>
              </p>
            </>
          )}
        </div>

        <footer className="p-4 border-t border-borda flex justify-end gap-3 flex-none">
          <Button variant="ghost" onClick={onFechar}>
            {resumo ? t('comum', 'fechar') : t('comum', 'cancelar')}
          </Button>
          {!resumo && (
            <Button onClick={exportar} disabled={exportando}>
              <Download className="w-4 h-4 mr-1" />
              {exportando ? t('gedcom', 'exportando') : t('gedcom', 'escolherOndeSalvar')}
            </Button>
          )}
        </footer>
      </div>
    </div>
  );
}
