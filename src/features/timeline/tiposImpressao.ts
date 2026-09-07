import type { LinhaDeContexto, LinhaPessoal, Marco } from '../../lib/api';
import type { TipoCalendario } from '../../lib/calendarios';

export interface DadosImpressaoTimeline {
  linhasPessoais: LinhaPessoal[];
  linhasContexto: LinhaDeContexto[];
  linhasAtivasIds: string[];
  marcos: Marco[];
  coresPersonalizadas: Record<string, string>;
  janelaAtual: { de: number; ate: number };
  regiaoImpressao: { de: number; ate: number } | null;
  calendarioAtivo: TipoCalendario;
  arvoreTitulo?: string;
  visibilidadeTrilhas?: Record<string, boolean>;
}

export interface OpcoesImpressaoAcademica {
  numeroFigura: string;
  tituloFigura: string;
  fonteTexto: string;
  incluirQuadroMarcos: boolean;
  anosPorPagina: number | "auto";
  anoDe: number;
  anoAte: number;
}
