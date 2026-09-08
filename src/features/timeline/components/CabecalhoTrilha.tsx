/**
 * Cabeçalho de Trilha (Track Header) inspirado no DaVinci Resolve e Blender.
 * Fica fixo na coluna lateral esquerda alinhado verticalmente com sua respectiva raia no canvas.
 */

import React, { useState, useRef, useEffect } from 'react';
import {
  Eye,
  EyeOff,
  Maximize2,
  Lock,
  Plus,
  Settings2,
  X,
  User,
  GripVertical,
  ChevronUp,
  ChevronDown,
  Palette,
  Check,
  RotateCcw,
  CalendarPlus,
} from 'lucide-react';
import { cn } from '../../../components/ui/Button';
import { useI18n } from '../../../i18n/I18nContext';

export const PALETA_CORES_HISTORICAS = [
  { nome: 'Azul Real', valor: '#2563eb' },
  { nome: 'Rosa Carmim', valor: '#db2777' },
  { nome: 'Esmeralda', valor: '#059669' },
  { nome: 'Âmbar Dourado', valor: '#d97706' },
  { nome: 'Roxo Imperial', valor: '#7c3aed' },
  { nome: 'Turquesa', valor: '#0891b2' },
  { nome: 'Índigo Noite', valor: '#4f46e5' },
  { nome: 'Terracota', valor: '#ea580c' },
  { nome: 'Bordô Histórico', valor: '#991b1b' },
  { nome: 'Ardósia', valor: '#475569' },
];

export interface CabecalhoTrilhaProps {
  identificador: string;
  tipo: 'pessoal' | 'contexto';
  titulo: string;
  subtitulo?: string;
  cor: string;
  altura: number;
  largura?: number;
  visivel?: boolean;
  bloqueada?: boolean;
  selecionado?: boolean;
  arrastavel?: boolean;
  estaArrastando?: boolean;
  posicaoDrop?: 'antes' | 'depois' | null;
  corPersonalizada?: string | null;
  onMudarCor?: (novaCor: string | null) => void;
  onToggleVisibilidade?: () => void;
  onFocar?: () => void;
  onAdicionarMarco?: () => void;
  onConfigurar?: () => void;
  onRemover?: () => void;
  onAbrirFicha?: () => void;
  onAdicionarEvento?: () => void;
  onRedimensionarLargura?: (e: React.MouseEvent) => void;
  onArrastarInicio?: (e: React.DragEvent) => void;
  onArrastarSobre?: (e: React.DragEvent) => void;
  onArrastarSair?: (e: React.DragEvent) => void;
  onSoltar?: (e: React.DragEvent) => void;
  onArrastarFim?: (e: React.DragEvent) => void;
  onMoverCima?: () => void;
  onMoverBaixo?: () => void;
  compacto?: boolean;
  abrirMenuParaCima?: boolean;
  menuCorAberto?: boolean;
  onAlternarMenuCor?: (aberto: boolean) => void;
  onRedimensionarAltura?: (e: React.MouseEvent) => void;
  onResetarAltura?: (e?: React.MouseEvent) => void;
}

const CabecalhoTrilhaComponent: React.FC<CabecalhoTrilhaProps> = ({
  identificador,
  tipo,
  titulo,
  subtitulo,
  cor,
  altura,
  largura = 224,
  visivel = true,
  bloqueada = false,
  selecionado = false,
  arrastavel = false,
  estaArrastando = false,
  posicaoDrop = null,
  corPersonalizada,
  onMudarCor,
  onToggleVisibilidade,
  onFocar,
  onAdicionarMarco,
  onConfigurar,
  onRemover,
  onAbrirFicha,
  onAdicionarEvento,
  onRedimensionarLargura,
  onArrastarInicio,
  onArrastarSobre,
  onArrastarSair,
  onSoltar,
  onArrastarFim,
  onMoverCima,
  onMoverBaixo,
  compacto = false,
  abrirMenuParaCima = false,
  menuCorAberto: propMenuCorAberto,
  onAlternarMenuCor,
  onRedimensionarAltura,
  onResetarAltura,
}) => {
  const { t } = useI18n();
  const [localMenuCorAberto, setLocalMenuCorAberto] = useState(false);
  const menuCorAberto = propMenuCorAberto !== undefined ? propMenuCorAberto : localMenuCorAberto;
  const setMenuCorAberto = (valor: boolean | ((prev: boolean) => boolean)) => {
    const novoValor = typeof valor === 'function' ? valor(menuCorAberto) : valor;
    if (onAlternarMenuCor) {
      onAlternarMenuCor(novoValor);
    } else {
      setLocalMenuCorAberto(novoValor);
    }
  };

  const seletorRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!menuCorAberto) return;
    const handleClickFora = (e: MouseEvent) => {
      if (seletorRef.current && !seletorRef.current.contains(e.target as Node)) {
        setMenuCorAberto(false);
      }
    };
    window.addEventListener('mousedown', handleClickFora);
    return () => window.removeEventListener('mousedown', handleClickFora);
  }, [menuCorAberto]);

  return (
    <div
      draggable={arrastavel}
      onDragStart={(e) => {
        if ((e.target as HTMLElement).closest('button, input, select')) {
          e.preventDefault();
          return;
        }
        onArrastarInicio?.(e);
      }}
      onDragOver={(e) => {
        e.preventDefault();
        e.stopPropagation();
        onArrastarSobre?.(e);
      }}
      onDragLeave={(e) => {
        e.stopPropagation();
        onArrastarSair?.(e);
      }}
      onDrop={(e) => {
        e.preventDefault();
        e.stopPropagation();
        onSoltar?.(e);
      }}
      onDragEnd={onArrastarFim}
      className={cn(
        'flex-none border-r-2 border-b border-borda/80 bg-card px-2 flex items-center justify-between gap-1.5 select-none transition-all group relative shadow-xs',
        menuCorAberto ? 'z-50' : 'z-20',
        !visivel && 'opacity-60 bg-sup/60',
        selecionado && 'bg-acento/10 ring-1 ring-acento/50',
        estaArrastando && 'opacity-30 scale-[0.98]',
        posicaoDrop === 'antes' && 'border-t-2 border-t-acento',
        posicaoDrop === 'depois' && 'border-b-2 border-b-acento',
      )}
      style={{ height: altura, width: largura }}
    >
      {/* Barra de cor indicadora na ponta esquerda */}
      <div
        className="absolute left-0 top-0 bottom-0 w-1.5 rounded-r-xs cursor-pointer hover:w-2.5 transition-all"
        style={{ backgroundColor: cor }}
        onClick={(e) => {
          e.stopPropagation();
          if (onMudarCor) setMenuCorAberto((prev) => !prev);
        }}
        title={onMudarCor ? t('linhaTempo', 'cliqueMudarCor') : undefined}
      />

      {/* Indicador de Drop (Linha azul/acento de alta visibilidade) */}
      {posicaoDrop === 'antes' && (
        <div className="absolute top-0 left-0 right-0 h-0.5 bg-acento z-50 shadow-[0_0_8px_var(--acento)] pointer-events-none" />
      )}
      {posicaoDrop === 'depois' && (
        <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-acento z-50 shadow-[0_0_8px_var(--acento)] pointer-events-none" />
      )}

      {/* Lado Esquerdo: Grip Handle + Controles Up/Down + Badge + Título */}
      <div className="flex items-center gap-1 min-w-0 flex-1 pl-1">
        {arrastavel && (
          <div className="flex items-center flex-none gap-0.5">
            {/* Grip Icon para arrastar */}
            <div
              title={t('linhaTempo', 'arrastarReordenarTrilha')}
              className="p-1 text-tinta3/70 hover:text-acento cursor-grab active:cursor-grabbing hover:bg-sup rounded transition-colors"
            >
              <GripVertical className="w-3.5 h-3.5" />
            </div>

            {/* Setas para mover acima/abaixo */}
            {(onMoverCima || onMoverBaixo) && (
              <div className="flex flex-col -my-1">
                {onMoverCima ? (
                  <button
                    type="button"
                    draggable={false}
                    onMouseDown={(e) => e.stopPropagation()}
                    onClick={(e) => {
                      e.stopPropagation();
                      onMoverCima();
                    }}
                    className="p-0.5 text-tinta3 hover:text-acento hover:bg-sup/50 rounded transition-colors cursor-pointer leading-none"
                    title={t('linhaTempo', 'moverUmaPosicaoAcima')}
                  >
                    <ChevronUp className="w-3 h-3" />
                  </button>
                ) : (
                  <span className="w-3 h-3" />
                )}
                {onMoverBaixo ? (
                  <button
                    type="button"
                    draggable={false}
                    onMouseDown={(e) => e.stopPropagation()}
                    onClick={(e) => {
                      e.stopPropagation();
                      onMoverBaixo();
                    }}
                    className="p-0.5 text-tinta3 hover:text-acento hover:bg-sup/50 rounded transition-colors cursor-pointer leading-none"
                    title={t('linhaTempo', 'moverUmaPosicaoAbaixo')}
                  >
                    <ChevronDown className="w-3 h-3" />
                  </button>
                ) : (
                  <span className="w-3 h-3" />
                )}
              </div>
            )}
          </div>
        )}

        {/* Badge da Trilha com Seletor de Cores */}
        <div className="relative">
          <button
            type="button"
            draggable={false}
            onMouseDown={(e) => e.stopPropagation()}
            onClick={(e) => {
              e.stopPropagation();
              if (onMudarCor) setMenuCorAberto((prev) => !prev);
            }}
            className={cn(
              'flex-none font-num font-bold text-[10px] px-1.5 py-0.5 rounded shadow-2xs text-white transition-all',
              onMudarCor ? 'cursor-pointer hover:scale-105 hover:ring-1 hover:ring-white/80 active:scale-95' : 'cursor-default'
            )}
            style={{ backgroundColor: cor }}
            title={
              onMudarCor
                ? `${t('linhaTempo', 'corDaTrilha')} (${corPersonalizada ? t('linhaTempo', 'personalizada') : t('linhaTempo', 'padrao')}). ${t('linhaTempo', 'cliqueParaTrocarCor')}`
                : tipo === 'pessoal'
                ? t('linhaTempo', 'trilhaPessoalTooltip')
                : t('linhaTempo', 'trilhaContextoTooltip')
            }
          >
            {identificador}
          </button>

          {/* Menu Flutuante Popover de Cores */}
          {menuCorAberto && onMudarCor && (
            <div
              ref={seletorRef}
              draggable={false}
              onMouseDown={(e) => e.stopPropagation()}
              onClick={(e) => e.stopPropagation()}
              className={cn(
                'absolute left-0 z-50 bg-card border border-borda shadow-xl rounded-md p-2.5 w-52 flex flex-col gap-2 text-tinta animate-in fade-in zoom-in-95 duration-100',
                abrirMenuParaCima ? 'bottom-full mb-1.5' : 'top-full mt-1.5'
              )}
            >
              <div className="flex items-center justify-between border-b border-borda/60 pb-1.5">
                <span className="text-[11px] font-semibold flex items-center gap-1.5">
                  <Palette className="w-3.5 h-3.5 text-acento" />
                  {t('linhaTempo', 'corDestaqueTrilha')}
                </span>
                <button
                  type="button"
                  onClick={() => setMenuCorAberto(false)}
                  className="text-tinta3 hover:text-tinta p-0.5 rounded cursor-pointer"
                  title={t('comum', 'fechar')}
                >
                  <X className="w-3 h-3" />
                </button>
              </div>

              {/* Grid da Paleta */}
              <div className="grid grid-cols-5 gap-1.5 py-1">
                {PALETA_CORES_HISTORICAS.map((p) => {
                  const estaAtiva = (corPersonalizada ?? cor).toLowerCase() === p.valor.toLowerCase();
                  return (
                    <button
                      key={p.valor}
                      type="button"
                      onClick={() => {
                        onMudarCor(p.valor);
                        setMenuCorAberto(false);
                      }}
                      className={cn(
                        'w-7 h-7 rounded-full flex items-center justify-center transition-all cursor-pointer hover:scale-110 shadow-xs relative',
                        estaAtiva ? 'ring-2 ring-white ring-offset-2 ring-offset-card scale-105' : 'hover:brightness-110'
                      )}
                      style={{ backgroundColor: p.valor }}
                      title={p.nome}
                    >
                      {estaAtiva && <Check className="w-3.5 h-3.5 text-white drop-shadow-md stroke-[3]" />}
                    </button>
                  );
                })}
              </div>

              {/* Redefinir para padrão */}
              {corPersonalizada && (
                <button
                  type="button"
                  onClick={() => {
                    onMudarCor(null);
                    setMenuCorAberto(false);
                  }}
                  className="w-full text-[10px] text-tinta3 hover:text-tinta py-1 px-2 rounded hover:bg-sup/80 flex items-center justify-center gap-1 transition-colors border border-borda/40 cursor-pointer"
                >
                  <RotateCcw className="w-3 h-3" />
                  {t('linhaTempo', 'restaurarCorPadrao')}
                </button>
              )}
            </div>
          )}
        </div>

        {/* Informações da Trilha */}
        <div className="flex flex-col min-w-0 flex-1 leading-tight">
          <div className="flex items-center gap-1 min-w-0">
            {bloqueada && (
              <span title={t('linhaTempo', 'trilhaBloqueada')} className="flex-none">
                <Lock className="w-2.5 h-2.5 text-tinta3" />
              </span>
            )}
            <span
              className={cn(
                'font-semibold text-xs text-tinta truncate block',
                onFocar && 'cursor-pointer hover:text-acento',
                selecionado && 'text-acento font-bold'
              )}
              onClick={onFocar}
              title={titulo}
            >
              {titulo}
            </span>
          </div>

          {!compacto && subtitulo && (
            <span className="font-num text-[10px] text-tinta3 truncate block mt-0.5 opacity-85">
              {subtitulo}
            </span>
          )}
        </div>
      </div>

      {/* Lado Direito: Ações da Trilha */}
      <div className="flex items-center gap-0.5 flex-none opacity-80 group-hover:opacity-100 transition-opacity">
        {/* Toggle Visibilidade / Mute */}
        {onToggleVisibilidade && (
          <button
            type="button"
            onMouseDown={(e) => e.stopPropagation()}
            onClick={onToggleVisibilidade}
            className={cn(
              'p-1 rounded hover:bg-sup text-tinta3 hover:text-tinta transition-colors cursor-pointer',
              !visivel && 'text-amber-500'
            )}
            title={visivel ? t('linhaTempo', 'ocultarTrilha') : t('linhaTempo', 'exibirTrilha')}
          >
            {visivel ? <Eye className="w-3.5 h-3.5" /> : <EyeOff className="w-3.5 h-3.5" />}
          </button>
        )}

        {/* Enquadrar / Focar no Eixo */}
        {onFocar && (
          <button
            type="button"
            onMouseDown={(e) => e.stopPropagation()}
            onClick={onFocar}
            className="p-1 rounded hover:bg-sup text-tinta3 hover:text-acento transition-colors cursor-pointer"
            title={t('linhaTempo', 'enquadrarNoEixo')}
          >
            <Maximize2 className="w-3.5 h-3.5" />
          </button>
        )}

        {/* Abrir Ficha Biográfica */}
        {onAbrirFicha && (
          <button
            type="button"
            onMouseDown={(e) => e.stopPropagation()}
            onClick={onAbrirFicha}
            className="p-1 rounded hover:bg-sup text-tinta3 hover:text-tinta transition-colors cursor-pointer"
            title={t('linhaTempo', 'abrirFichaPessoa')}
          >
            <User className="w-3.5 h-3.5" />
          </button>
        )}

        {/* Adicionar Evento de Vida à Pessoa */}
        {tipo === 'pessoal' && onAdicionarEvento && (
          <button
            type="button"
            onMouseDown={(e) => e.stopPropagation()}
            onClick={onAdicionarEvento}
            className="p-1 rounded hover:bg-sup text-tinta3 hover:text-acento transition-colors cursor-pointer"
            title={t('linhaTempo', 'adicionarEventoVidaDica')}
          >
            <CalendarPlus className="w-3.5 h-3.5" />
          </button>
        )}

        {/* Adicionar Marco à Linha de Contexto */}
        {onAdicionarMarco && !bloqueada && (
          <button
            type="button"
            onMouseDown={(e) => e.stopPropagation()}
            onClick={onAdicionarMarco}
            className="p-1 rounded hover:bg-sup text-tinta3 hover:text-acento transition-colors cursor-pointer"
            title={t('linhaTempo', 'adicionarNovoMarco')}
          >
            <Plus className="w-3.5 h-3.5" />
          </button>
        )}

        {/* Configurações da Linha */}
        {onConfigurar && !bloqueada && (
          <button
            type="button"
            onMouseDown={(e) => e.stopPropagation()}
            onClick={onConfigurar}
            className="p-1 rounded hover:bg-sup text-tinta3 hover:text-tinta transition-colors cursor-pointer"
            title={t('linhaTempo', 'configurarLinha')}
          >
            <Settings2 className="w-3.5 h-3.5" />
          </button>
        )}

        {/* Fechar / Remover Trilha */}
        {onRemover && (
          <button
            type="button"
            onMouseDown={(e) => e.stopPropagation()}
            onClick={onRemover}
            className="p-1 rounded hover:bg-sup text-tinta3 hover:text-fem transition-colors cursor-pointer"
            title={t('linhaTempo', 'removerTrilha')}
          >
            <X className="w-3.5 h-3.5" />
          </button>
        )}
      </div>

      {/* Alça Vertical de Redimensionamento Horizontal (Splitter Lateral) */}
      {onRedimensionarLargura && (
        <div
          onMouseDown={onRedimensionarLargura}
          className="absolute top-0 bottom-0 -right-1 w-2 hover:bg-acento/70 cursor-col-resize z-30 transition-colors select-none group-hover:bg-borda/40"
          title={t('linhaTempo', 'ajustarLarguraTrilhasDica')}
        />
      )}

      {/* Alça de Redimensionamento Individual de Altura (estritamente restrita à barra lateral esquerda) */}
      {onRedimensionarAltura && (
        <div
          onMouseDown={(e) => {
            e.stopPropagation();
            onRedimensionarAltura(e);
          }}
          onDoubleClick={(e) => {
            e.stopPropagation();
            onResetarAltura?.(e);
          }}
          className="absolute -bottom-1 left-0 right-0 h-2 hover:bg-acento/80 cursor-row-resize z-30 transition-colors select-none group-hover:bg-borda/40"
          title={t('linhaTempo', 'ajustarAlturaTrilhasDica')}
        />
      )}
    </div>
  );
};

export const CabecalhoTrilha = React.memo(CabecalhoTrilhaComponent);
