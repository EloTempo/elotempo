/**
 * O nó da árvore (seção 10).
 *
 * Miniatura à esquerda, faixa de sexo antes do nome, dados-chave numa linha
 * (`n.` nascimento, `†` falecimento, longevidade), minibiografia resumida e a fileira
 * de ícones de presença, que mostram o que existe de informação sem obrigar a abrir os detalhes.
 */

import { User, FileText, Book, Info, ChevronRight } from 'lucide-react';
import { IconePessoaDesconhecida } from '../icons';
import type { PersonNode } from '../../types';
import { cn } from '../ui/Button';
import { ImagemDoAcervo } from '../ui/ImagemDoAcervo';
import { useI18n } from '../../i18n/I18nContext';

interface NodeCardProps {
  person: PersonNode;
  selecionado?: boolean;
  /** Estava vivo no marco clicado na linha do tempo (fatia 07). */
  destacado?: boolean;
  onClick?: () => void;
  onDetalhes?: () => void;
}

function faixaDeSexo(sexo: string): string {
  if (sexo === 'M') return 'bg-masc';
  if (sexo === 'F') return 'bg-fem';
  if (sexo === 'X') return 'bg-gradient-to-b from-masc to-fem';
  return 'bg-tinta3';
}

function formatarAno(ano?: number | null): string {
  if (ano == null) return '';
  if (ano < 0) return `c. ${Math.abs(ano)} a.C.`;
  if (ano > 0 && ano <= 100) return `${ano} d.C.`;
  return String(ano);
}

function formatarDatasVitais(person: PersonNode): string {
  const nasc = person.ano_nascimento;
  const falec = person.ano_falecimento;
  const isVivo = person.is_vivo;

  if (nasc != null && falec != null) {
    let idade = falec - nasc;
    if (nasc < 0 && falec > 0) {
      idade = falec - nasc - 1;
    } else if (nasc === 1 && falec === 33) {
      idade = 33;
    }
    return `* ${formatarAno(nasc)} · † ${formatarAno(falec)} (${idade}a)`;
  }
  if (nasc != null) {
    if (isVivo) {
      const idade = new Date().getFullYear() - nasc;
      return `* ${formatarAno(nasc)} (${idade}a, vivo)`;
    }
    return `* ${formatarAno(nasc)} · †`;
  }
  if (falec != null) {
    return `† ${formatarAno(falec)}`;
  }
  return isVivo ? 'Pessoa viva (datas s/d)' : 'Datas não registradas';
}

export function NodeCard({
  person,
  selecionado,
  destacado,
  onClick,
  onDetalhes,
}: NodeCardProps) {
  const { t } = useI18n();
  const nomeCompleto = [person.nome, person.sobrenome].filter(Boolean).join(' ');

  // Placeholder: borda tracejada e identidade em aberto. Continua clicável —
  // é assim que se promove o nó a ancestral real quando o nome aparece.
  if (person.is_placeholder) {
    return (
      <button
        type="button"
        onClick={onClick}
        style={{ backgroundColor: 'var(--card)' }}
        className={cn(
          'w-full h-full rounded-raio border-2 border-dashed border-borda2',
          'flex flex-col items-center justify-center gap-1 px-4 cursor-pointer',
          'hover:border-acento transition-colors text-center shadow-xs',
          selecionado && 'border-acento ring-2 ring-acento/40',
        )}
        title="Ancestral desconhecido — clique para dar um nome"
      >
        {/* Nó vazado: neste vocabulário uma pessoa é um nó, e sem nome ele
            não se preenche. O tracejado do card e o do nó dizem a mesma coisa. */}
        <IconePessoaDesconhecida className="w-5 h-5 text-tinta3 detail-text" />
        <span className="text-tinta2 italic font-serif text-[14px] leading-tight truncate w-full">
          {person.sexo === 'F' ? 'Ancestral Desconhecida' : 'Ancestral Desconhecido'}
        </span>
        <span className="text-tinta3 text-[11px] detail-text">
          clique para identificar
        </span>
      </button>
    );
  }

  const textoDatas = formatarDatasVitais(person);
  const bio = person.minibiografia?.trim();

  return (
    <div
      onClick={onClick}
      style={{ backgroundColor: 'var(--card)' }}
      className={cn(
        'w-full h-full rounded-raio border border-borda shadow-sombra',
        'flex items-stretch overflow-hidden cursor-pointer node-card node-content select-none',
        'hover:border-borda2 hover:shadow-md transition-all',
        destacado && 'border-anel ring-2 ring-anel/50',
        selecionado && 'border-acento ring-2 ring-acento/50 shadow-md',
      )}
    >
      {/* Barra colorida indicadora de sexo */}
      <div className={cn('w-1.5 flex-none', faixaDeSexo(person.sexo))} aria-hidden />

      <div className="flex items-center gap-3 px-3 py-2 min-w-0 flex-1">
        {/* Retrato / Avatar */}
        <div className="w-12 h-12 rounded-raio-s bg-chip flex-none grid place-items-center overflow-hidden border border-borda2 shadow-2xs">
          <ImagemDoAcervo
            caminhoRelativo={person.foto_url}
            alt=""
            className="w-full h-full object-cover"
            alternativo={<User className="w-5 h-5 text-tinta3" />}
          />
        </div>

        {/* Informações da Pessoa */}
        <div className="flex flex-col min-w-0 flex-1 justify-center gap-0.5">
          {/* Linha 1: Nome Completo e Destaque de Vínculo */}
          <div className="flex items-center gap-1.5 min-w-0">
            <span
              className="font-tit font-bold text-[14px] text-tinta truncate leading-tight flex-1"
              title={nomeCompleto}
            >
              {nomeCompleto}
            </span>
            {person.tipo_vinculo && person.tipo_vinculo !== 'biologico' && (
              <span
                className="text-[9.5px] font-semibold px-1.5 py-0.5 rounded bg-acento/15 text-acento border border-acento/30 shrink-0 uppercase tracking-wide leading-none"
                title={`Vínculo: ${person.tipo_vinculo}`}
              >
                {person.tipo_vinculo === 'adotado' ? 'Adotado(a)' : person.tipo_vinculo}
              </span>
            )}
          </div>

          {/* Linha 2: Datas Vitais e Idade formatadas */}
          <span className="font-num text-[11px] text-tinta2 font-medium truncate detail-text">
            {textoDatas}
          </span>

          {/* Linha 3: Minibiografia ou categoria */}
          {bio ? (
            <p
              className="text-[11px] text-tinta3 italic truncate leading-tight font-sans detail-text m-0"
              title={bio}
            >
              {bio}
            </p>
          ) : person.categoria ? (
            <span className="text-[10.5px] text-acento/90 font-medium truncate detail-text">
              {person.categoria}
            </span>
          ) : null}

          {/* Linha 4: Badges de presença e Ação de Detalhes */}
          <div className="flex items-center justify-between mt-0.5 detail-text">
            <div className="flex items-center gap-1.5 text-tinta3">
              {person.tem_documentos && (
                <span title={t('arvore', 'documentosBadge')}>
                  <FileText className="w-3 h-3 hover:text-tinta" />
                </span>
              )}
              {person.tem_religiao && (
                <span title={t('arvore', 'religiososBadge')}>
                  <Book className="w-3 h-3 hover:text-tinta" />
                </span>
              )}
              {person.tem_biografia && (
                <span title={t('arvore', 'biografiaBadge')}>
                  <Info className="w-3 h-3 hover:text-tinta" />
                </span>
              )}
              {person.is_publico && (
                <span
                  title="Registro histórico público"
                  className="text-[9px] font-semibold px-1 py-0.2 rounded bg-sup text-tinta3 border border-borda/60"
                >
                  Público
                </span>
              )}
            </div>

            {onDetalhes && (
              <button
                type="button"
                onClick={(e) => {
                  e.stopPropagation();
                  onDetalhes();
                }}
                className="text-[11px] font-semibold text-acento hover:text-tinta transition-colors bg-transparent border-none cursor-pointer flex items-center gap-0.5 p-0"
                title="Abrir ficha biográfica completa"
              >
                <span>{t('arvore', 'detalhes')}</span>
                <ChevronRight className="w-3 h-3" />
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
