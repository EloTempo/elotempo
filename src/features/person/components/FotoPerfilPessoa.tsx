import React, { useState } from 'react';
import { useQueryClient } from '@tanstack/react-query';
import { Camera, Trash2, User, Loader2, ImagePlus } from 'lucide-react';
import { ImagemDoAcervo } from '../../../components/ui/ImagemDoAcervo';
import { escolherFoto, definirFotoDaPessoa, definirFotoPrincipal } from '../../../lib/api';
import { cn } from '../../../components/ui/Button';

export interface FotoPerfilPessoaProps {
  pessoaId: string;
  fotoUrl?: string | null;
  nome?: string;
  tamanho?: 'sm' | 'md' | 'lg' | 'xl';
  editavel?: boolean;
  mostrarBotaoTexto?: boolean;
  className?: string;
  onSucesso?: () => void;
}

const TAMANHOS = {
  sm: { container: 'w-12 h-12', icon: 'w-5 h-5', badge: 'w-4 h-4 p-0.5', badgeIcon: 'w-2.5 h-2.5' },
  md: { container: 'w-16 h-16', icon: 'w-7 h-7', badge: 'w-5 h-5 p-1', badgeIcon: 'w-3 h-3' },
  lg: { container: 'w-20 h-20', icon: 'w-9 h-9', badge: 'w-6 h-6 p-1', badgeIcon: 'w-3.5 h-3.5' },
  xl: { container: 'w-24 h-24', icon: 'w-11 h-11', badge: 'w-7 h-7 p-1.5', badgeIcon: 'w-4 h-4' },
};

export function FotoPerfilPessoa({
  pessoaId,
  fotoUrl,
  nome = 'Pessoa',
  tamanho = 'md',
  editavel = true,
  mostrarBotaoTexto = false,
  className,
  onSucesso,
}: FotoPerfilPessoaProps) {
  const qc = useQueryClient();
  const [carregando, setCarregando] = useState(false);
  const [erro, setErro] = useState<string | null>(null);

  const dim = TAMANHOS[tamanho] ?? TAMANHOS.md;

  const invalidarConsultas = () => {
    qc.invalidateQueries({ queryKey: ['pessoa', pessoaId] });
    qc.invalidateQueries({ queryKey: ['arvore'] });
    qc.invalidateQueries({ queryKey: ['documentos', pessoaId] });
    qc.invalidateQueries({ queryKey: ['pessoas-arvore'] });
    qc.invalidateQueries({ queryKey: ['pessoas'] });
    qc.invalidateQueries({ queryKey: ['linha-pessoal'] });
  };

  const handleEscolherFoto = async (e?: React.MouseEvent) => {
    e?.stopPropagation();
    if (carregando || !editavel) return;

    try {
      setErro(null);
      const caminho = await escolherFoto();
      if (!caminho) return;

      setCarregando(true);
      await definirFotoDaPessoa(pessoaId, caminho);
      invalidarConsultas();
      onSucesso?.();
    } catch (err: any) {
      setErro(err?.message ?? 'Erro ao definir foto de perfil.');
    } finally {
      setCarregando(false);
    }
  };

  const handleRemoverFoto = async (e?: React.MouseEvent) => {
    e?.stopPropagation();
    if (carregando || !editavel || !fotoUrl) return;

    try {
      setErro(null);
      setCarregando(true);
      await definirFotoPrincipal(pessoaId, null);
      invalidarConsultas();
      onSucesso?.();
    } catch (err: any) {
      setErro(err?.message ?? 'Erro ao remover foto.');
    } finally {
      setCarregando(false);
    }
  };

  return (
    <div className={cn('flex flex-col items-start gap-1.5', className)}>
      <div className="relative group">
        {/* Moldura do Avatar */}
        <div
          onClick={editavel ? handleEscolherFoto : undefined}
          className={cn(
            dim.container,
            'rounded-raio-s bg-sup border border-borda flex-none grid place-items-center text-tinta3 overflow-hidden shadow-2xs relative transition-all',
            editavel && !carregando && 'cursor-pointer hover:border-acento hover:ring-2 hover:ring-acento/30 hover:scale-[1.02]',
            carregando && 'opacity-60 cursor-wait'
          )}
          title={
            editavel
              ? fotoUrl
                ? `Retrato de ${nome}. Clique para alterar a foto.`
                : `Sem foto. Clique para adicionar a foto do rosto de ${nome}.`
              : `Retrato de ${nome}`
          }
        >
          <ImagemDoAcervo
            caminhoRelativo={fotoUrl}
            alt={`Retrato de ${nome}`}
            className="w-full h-full object-cover"
            alternativo={<User className={cn(dim.icon, 'text-tinta3')} />}
          />

          {/* Overlay interativo de Hover */}
          {editavel && !carregando && (
            <div className="absolute inset-0 bg-preto/50 opacity-0 group-hover:opacity-100 transition-opacity flex flex-col items-center justify-center text-white gap-0.5 pointer-events-none">
              <Camera className={dim.badgeIcon} />
              <span className="text-[9px] font-bold text-center leading-none drop-shadow-xs px-1 truncate max-w-full">
                {fotoUrl ? 'Alterar' : 'Adicionar'}
              </span>
            </div>
          )}

          {/* Spinner de Carregamento */}
          {carregando && (
            <div className="absolute inset-0 bg-card/75 flex items-center justify-center">
              <Loader2 className="w-5 h-5 text-acento animate-spin" />
            </div>
          )}
        </div>

        {/* Emblema Flutuante de Câmera */}
        {editavel && (
          <button
            type="button"
            onClick={handleEscolherFoto}
            disabled={carregando}
            className={cn(
              dim.badge,
              'absolute -bottom-1 -right-1 rounded-full bg-acento text-acento-tinta shadow-md border-2 border-card flex items-center justify-center transition-transform hover:scale-110 cursor-pointer'
            )}
            title={fotoUrl ? 'Alterar foto do rosto' : 'Adicionar foto do rosto'}
          >
            <Camera className={dim.badgeIcon} />
          </button>
        )}
      </div>

      {/* Botões textuais de suporte */}
      {mostrarBotaoTexto && editavel && (
        <div className="flex flex-col items-stretch gap-1 pt-1 w-full max-w-[102px]">
          <button
            type="button"
            onClick={handleEscolherFoto}
            disabled={carregando}
            className="w-full inline-flex items-center justify-center gap-1 px-2 py-1 text-[11px] font-semibold text-acento hover:text-acento-tinta bg-acento/10 hover:bg-acento rounded-raio-s transition-all border border-acento/30 cursor-pointer shadow-2xs disabled:opacity-50 text-center"
            title={fotoUrl ? 'Escolher outra foto para o perfil' : 'Carregar foto do rosto para esta pessoa'}
          >
            {carregando ? (
              <Loader2 className="w-3 h-3 animate-spin flex-none" />
            ) : fotoUrl ? (
              <Camera className="w-3 h-3 flex-none" />
            ) : (
              <ImagePlus className="w-3 h-3 flex-none" />
            )}
            <span className="truncate">{fotoUrl ? 'Alterar foto' : 'Adicionar foto'}</span>
          </button>

          {fotoUrl && (
            <button
              type="button"
              onClick={handleRemoverFoto}
              disabled={carregando}
              className="w-full inline-flex items-center justify-center gap-1 px-1.5 py-0.5 text-[10.5px] text-tinta3 hover:text-fem hover:bg-fem/10 rounded transition-colors cursor-pointer disabled:opacity-50 text-center"
              title="Remover retrato de perfil"
            >
              <Trash2 className="w-3 h-3 flex-none" />
              <span>Remover</span>
            </button>
          )}
        </div>
      )}

      {/* Mensagem de Erro se houver */}
      {erro && (
        <span className="text-[10px] text-fem leading-tight max-w-[200px] break-words">
          {erro}
        </span>
      )}
    </div>
  );
}
