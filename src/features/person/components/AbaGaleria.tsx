import { useState } from 'react';
import {
  FileText,
  ImagePlus,
  Star,
  Trash2,
  UploadCloud,
  ExternalLink,
  Eye,
  X,
} from 'lucide-react';
import { ImagemDoAcervo } from '../../../components/ui/ImagemDoAcervo';
import { escolherArquivo, abrirDocumentoNoSistema } from '../../../lib/api';
import {
  useDocumentos,
  useAnexarDocumento,
  useRemoverDocumento,
  useDefinirFotoPrincipal,
} from '../hooks/useFicha';
import type { Document, Person } from '../../../types';

interface AbaGaleriaProps {
  pessoa: Person;
}

export function AbaGaleria({ pessoa }: AbaGaleriaProps) {
  const listaDocumentos = useDocumentos(pessoa.id);
  const anexar = useAnexarDocumento(pessoa.id);
  const delDocumento = useRemoverDocumento(pessoa.id);
  const definirRetrato = useDefinirFotoPrincipal(pessoa.id);

  const [docVisualizando, setDocVisualizando] = useState<Document | null>(null);

  const docs = listaDocumentos.data ?? [];

  const handleAnexar = async () => {
    const caminho = await escolherArquivo();
    if (caminho) {
      anexar.mutate(
        { pessoa_id: pessoa.id, caminho_origem: caminho },
        {
          onSuccess: (novoDocId) => {
            if (!pessoa.foto_url) {
              definirRetrato.mutate(novoDocId);
            }
          },
        },
      );
    }
  };

  const handleAbrir = async (doc: Document) => {
    if (doc.tipo_midia === 'imagem') {
      setDocVisualizando(doc);
    } else {
      // Abre PDFs, textos ou outros documentos diretamente no programa padrão do SO
      await abrirDocumentoNoSistema(doc.caminho_relativo);
    }
  };

  return (
    <div className="flex flex-col gap-4">
      {/* Cabeçalho da Galeria */}
      <div className="p-3.5 rounded-raio bg-card border border-borda shadow-2xs flex items-center justify-between gap-2 flex-wrap">
        <div>
          <h3 className="font-tit font-bold text-sm text-tinta m-0">
            Galeria de Fotos, Retratos & Certidões ({docs.length})
          </h3>
          <span className="text-[11px] text-tinta3">
            Clique em qualquer foto ou documento para abrir e visualizar em tamanho real
          </span>
        </div>
        <button
          type="button"
          disabled={anexar.isPending}
          onClick={handleAnexar}
          className="text-xs font-semibold px-3 py-1.5 rounded-raio-s bg-acento text-acento-tinta hover:opacity-90 transition-opacity flex items-center gap-1.5 cursor-pointer shadow-2xs disabled:opacity-50 border-none"
        >
          <UploadCloud className="w-3.5 h-3.5" />
          {anexar.isPending ? 'Copiando…' : 'Anexar Arquivo'}
        </button>
      </div>

      {/* Grade de Documentos */}
      {listaDocumentos.isLoading ? (
        <div className="p-8 text-center text-xs text-tinta3">Carregando acervo de imagens…</div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3">
          {/* Card Especial de Upload */}
          <div
            onClick={handleAnexar}
            className="aspect-square rounded-raio-s border-2 border-dashed border-borda hover:border-acento bg-sup/30 hover:bg-sup/60 transition-colors flex flex-col items-center justify-center p-3 text-center cursor-pointer group select-none"
          >
            <div className="w-10 h-10 rounded-full bg-acento/10 group-hover:bg-acento/20 text-acento flex items-center justify-center transition-colors mb-2">
              <ImagePlus className="w-5 h-5" />
            </div>
            <span className="text-xs font-semibold text-tinta block">Adicionar Arquivo</span>
            <span className="text-[10px] text-tinta3 block mt-0.5">Fotos, certidões ou PDFs</span>
          </div>

          {/* Cards dos Documentos */}
          {docs.map((d) => {
            const ehRetrato = pessoa.foto_url === d.caminho_relativo;
            const rotulo = d.titulo || d.nome_original || 'Anexo';

            return (
              <div
                key={d.id}
                onClick={() => handleAbrir(d)}
                className={`relative rounded-raio-s border overflow-hidden bg-card group shadow-2xs transition-all cursor-pointer hover:shadow-sombra ${
                  ehRetrato ? 'border-acento ring-2 ring-acento/30' : 'border-borda hover:border-acento/60'
                }`}
              >
                {/* Distintivo de Foto de Perfil */}
                {ehRetrato && (
                  <div className="absolute top-1.5 left-1.5 px-2 py-0.5 rounded-full bg-acento text-acento-tinta font-bold text-[9px] flex items-center gap-1 shadow-xs z-10 select-none">
                    <Star className="w-2.5 h-2.5 fill-current" />
                    <span>Retrato Principal</span>
                  </div>
                )}

                {/* Miniatura */}
                <div className="aspect-square bg-sup grid place-items-center text-tinta3 overflow-hidden relative">
                  {d.tipo_midia === 'imagem' ? (
                    <ImagemDoAcervo
                      caminhoRelativo={d.caminho_relativo}
                      alt={rotulo}
                      className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                      alternativo={<ImagePlus className="w-8 h-8" />}
                    />
                  ) : (
                    <div className="flex flex-col items-center gap-2 text-tinta3 p-3 text-center">
                      <div className="w-12 h-12 rounded-full bg-acento/10 flex items-center justify-center text-acento">
                        <FileText className="w-6 h-6" />
                      </div>
                      <span className="text-[10.5px] uppercase font-num tracking-wider font-semibold text-tinta2">
                        {rotulo.endsWith('.pdf') ? 'Documento PDF' : 'Documento'}
                      </span>
                      <span className="text-[10px] px-2 py-0.5 rounded bg-acento/10 text-acento border border-acento/20 font-medium">
                        Clique para abrir
                      </span>
                    </div>
                  )}

                  {/* Overlay sutil de clique ao passar o mouse */}
                  <div className="absolute inset-0 bg-black/20 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center pointer-events-none">
                    <span className="px-2.5 py-1 rounded bg-black/70 text-white text-[11px] font-medium flex items-center gap-1 backdrop-blur-xs">
                      <Eye className="w-3.5 h-3.5" />
                      Abrir
                    </span>
                  </div>
                </div>

                {/* Detalhes */}
                <div className="p-2 bg-card border-t border-borda/40">
                  <span className="block text-xs font-medium text-tinta truncate" title={rotulo}>
                    {rotulo}
                  </span>
                  {d.data_documento && (
                    <span className="block font-num text-[10.5px] text-tinta3 truncate mt-0.5">
                      {d.data_documento}
                    </span>
                  )}
                </div>

                {/* Ações Rápidas no Canto Superior Direito */}
                <div
                  className="absolute top-1.5 right-1.5 flex gap-1 z-20 opacity-0 group-hover:opacity-100 transition-opacity"
                  onClick={(e) => e.stopPropagation()}
                >
                  {/* Botão Abrir no Sistema */}
                  <button
                    type="button"
                    title="Abrir no aplicativo padrão do sistema (leitor de PDF, fotos, etc.)"
                    aria-label={`Abrir ${rotulo} no sistema`}
                    onClick={() => abrirDocumentoNoSistema(d.caminho_relativo)}
                    className="p-1.5 rounded-raio-s border bg-card/95 text-tinta hover:text-acento border-borda hover:border-acento transition-all cursor-pointer shadow-xs"
                  >
                    <ExternalLink className="w-3 h-3" />
                  </button>

                  {/* Botão Foto de Perfil */}
                  {d.tipo_midia === 'imagem' && (
                    <button
                      type="button"
                      title={ehRetrato ? 'Foto principal ativa' : 'Usar como foto de perfil'}
                      aria-label="Usar como foto de perfil"
                      disabled={definirRetrato.isPending}
                      onClick={() => definirRetrato.mutate(ehRetrato ? null : d.id)}
                      className={`p-1.5 rounded-raio-s border cursor-pointer transition-all shadow-xs ${
                        ehRetrato
                          ? 'bg-acento text-acento-tinta border-acento opacity-100'
                          : 'bg-card/95 text-tinta hover:text-acento border-borda hover:border-acento'
                      }`}
                    >
                      <Star className={`w-3 h-3 ${ehRetrato ? 'fill-current' : ''}`} />
                    </button>
                  )}

                  {/* Botão Remover */}
                  <button
                    type="button"
                    title="Remover anexo"
                    aria-label={`Remover ${rotulo}`}
                    disabled={delDocumento.isPending}
                    onClick={() => {
                      if (confirm(`Remover "${rotulo}" do acervo desta pessoa?`)) {
                        delDocumento.mutate(d.id);
                      }
                    }}
                    className="p-1.5 rounded-raio-s border bg-card/95 text-tinta3 hover:text-fem border-borda hover:border-fem/40 transition-all cursor-pointer shadow-xs"
                  >
                    <Trash2 className="w-3 h-3" />
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* ---------------- MODAL / LIGHTBOX DE VISUALIZAÇÃO DE IMAGEM ---------------- */}
      {docVisualizando && (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm">
          <div
            className="absolute inset-0"
            onClick={() => setDocVisualizando(null)}
            aria-hidden
          />
          <div className="relative max-w-3xl w-full bg-card rounded-raio border border-borda shadow-sombra overflow-hidden flex flex-col max-h-[92vh] z-10">
            {/* Barra Superior do Visualizador */}
            <div className="flex items-center justify-between px-4 py-3 border-b border-borda bg-card2 flex-none">
              <div className="flex items-center gap-2 min-w-0">
                <ImagePlus className="w-4 h-4 text-acento flex-none" />
                <span className="font-tit font-bold text-sm text-tinta truncate">
                  {docVisualizando.titulo || docVisualizando.nome_original || 'Visualização de Imagem'}
                </span>
                {docVisualizando.data_documento && (
                  <span className="text-xs font-num text-tinta3 flex-none">
                    ({docVisualizando.data_documento})
                  </span>
                )}
              </div>

              <div className="flex items-center gap-2 flex-none">
                {/* Abrir no aplicativo do Sistema */}
                <button
                  type="button"
                  onClick={() => abrirDocumentoNoSistema(docVisualizando.caminho_relativo)}
                  className="px-2.5 py-1 text-xs font-semibold rounded-raio-s border border-borda2 bg-card text-tinta hover:bg-sup transition-colors flex items-center gap-1.5 cursor-pointer shadow-2xs"
                  title="Abrir no visualizador de imagens padrão do Windows/Mac/Linux"
                >
                  <ExternalLink className="w-3.5 h-3.5 text-acento" />
                  <span>Abrir no Sistema</span>
                </button>

                {/* Usar como Retrato */}
                {pessoa.foto_url !== docVisualizando.caminho_relativo && (
                  <button
                    type="button"
                    onClick={() => {
                      definirRetrato.mutate(docVisualizando.id);
                    }}
                    className="px-2.5 py-1 text-xs font-semibold rounded-raio-s border border-acento/40 bg-acento/10 text-acento hover:bg-acento/20 transition-colors flex items-center gap-1.5 cursor-pointer shadow-2xs"
                    title="Definir esta foto como imagem de perfil na árvore"
                  >
                    <Star className="w-3.5 h-3.5 fill-current" />
                    <span>Usar como Perfil</span>
                  </button>
                )}

                {/* Fechar */}
                <button
                  type="button"
                  onClick={() => setDocVisualizando(null)}
                  className="p-1 text-tinta3 hover:text-tinta rounded-raio-s hover:bg-sup transition-colors cursor-pointer border-none bg-transparent ml-1"
                >
                  <X className="w-5 h-5" />
                </button>
              </div>
            </div>

            {/* Imagem em Tamanho Real */}
            <div className="flex-1 overflow-auto p-4 flex items-center justify-center bg-black/40 min-h-[300px]">
              <ImagemDoAcervo
                caminhoRelativo={docVisualizando.caminho_relativo}
                alt={docVisualizando.titulo || 'Imagem'}
                className="max-h-[70vh] max-w-full object-contain rounded-sm shadow-md"
                alternativo={<ImagePlus className="w-12 h-12 text-tinta3" />}
              />
            </div>
          </div>
        </div>
      )}

      {/* Nota Explicativa Subordinada */}
      <p className="text-[11px] text-tinta3 font-normal m-0 leading-relaxed">
        Os arquivos são salvos e organizados de forma segura dentro do acervo local do programa. A estrela indica a foto que representa esta pessoa nos cartões e árvores genealógicas.
      </p>
    </div>
  );
}
