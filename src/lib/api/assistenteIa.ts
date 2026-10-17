/**
 * API do Assistente de IA Local Sob Demanda + Pipeline Neuro-Simbólico.
 */

import { chamar } from './index';

export interface InfoModeloCatalogo {
  id: string;
  nome: string;
  arquivo: string;
  url_download: string;
  /** SHA-256 do arquivo publicado. Vazio em modelo importado pelo usuário. */
  sha256_esperado: string;
  tamanho_bytes_estimado: number;
  ram_recomendada_gb: number;
  descricao: string;
  instalado: boolean;
  tamanho_em_disco: number;
}

export interface StatusIaLocal {
  motor_instalado: boolean;
  servidor_online: boolean;
  endpoint_local: string;
  modelo_ativo_id: string | null;
  modelos_catalogo: InfoModeloCatalogo[];
  download_em_andamento: boolean;
  download_modelo_id: string | null;
  download_bytes_atuais: number;
  download_bytes_totais: number;
  ultimo_erro_download: string | null;
  pasta_modelos: string;
}

export interface CitacaoAcervoIa {
  tipo: 'pessoa' | 'marco' | 'estatistica' | string;
  id: string;
  titulo: string;
  detalhe: string;
}

export interface ItemPessoaProposta {
  ref_id: string;
  nome: string;
  sobrenome: string | null;
  sexo: string;
  ano_nascimento: number | null;
  ano_falecimento: number | null;
  minibiografia: string | null;
  trecho_evidencia: string;
  pessoa_existente_id: string | null;
}

export interface ItemUniaoProposta {
  pai_ref: string | null;
  mae_ref: string | null;
  ano_casamento: number | null;
  filhos_refs: string[];
}

export interface PropostaCriarArvore {
  nome_arvore: string;
  descricao: string | null;
  categoria: string | null;
  raiz_ref: string;
  pessoas: ItemPessoaProposta[];
  unioes: ItemUniaoProposta[];
  ancoragem_verificada: boolean;
  alertas_auditoria: string[];
}

export interface ItemMarcoProposto {
  titulo: string;
  ano_inicio: number;
  ano_fim: number | null;
  data_periodo_texto: string;
  descricao: string | null;
  relevancia: string;
  trecho_evidencia: string;
}

export interface PropostaCriarLinhaTempo {
  titulo_linha: string;
  categoria: string;
  fonte_referencia: string | null;
  marcos: ItemMarcoProposto[];
  ancoragem_verificada: boolean;
  alertas_auditoria: string[];
}

export type PropostaAcaoIa =
  | { tipo_acao: 'criar_arvore'; dados: PropostaCriarArvore }
  | { tipo_acao: 'criar_linha_tempo'; dados: PropostaCriarLinhaTempo };

export interface RespostaAssistenteIa {
  resposta_markdown: string;
  abstencao: boolean;
  confianca: number;
  modo_execucao: string;
  citacoes: CitacaoAcervoIa[];
  proposta_acao: PropostaAcaoIa | null;
}

export interface ResultadoExecucaoIa {
  tipo: 'arvore' | 'linha_tempo' | string;
  entidade_id: string;
  raiz_pessoa_id: string | null;
  titulo: string;
  itens_criados: number;
  mensagem: string;
  /** Vínculos que a prévia prometia e o banco recusou. Vazio no caso normal. */
  avisos: string[];
}

/** Formata bytes de modelo em MB ou GB para exibição legível. */
export function formatarBytesModelo(bytes: number): string {
  if (!Number.isFinite(bytes) || bytes <= 0) return '0 MB';
  const mb = bytes / (1024 * 1024);
  if (mb >= 1000) {
    return `${(mb / 1024).toFixed(2)} GB`;
  }
  return `${Math.round(mb)} MB`;
}

/** Calcula o percentual de download (0 a 100) de forma segura. */
export function calcularProgressoDownload(atuais: number, totais: number): number {
  if (!totais || totais <= 0) return 0;
  return Math.min(100, Math.max(0, Math.round((atuais / totais) * 100)));
}

export function obterStatusIaLocal(): Promise<StatusIaLocal> {
  return chamar<StatusIaLocal>('obter_status_ia_local');
}

export function iniciarDownloadModeloIa(modeloId: string): Promise<void> {
  return chamar<void>('iniciar_download_modelo_ia', { modeloId });
}

export function cancelarDownloadModeloIa(): Promise<void> {
  return chamar<void>('cancelar_download_modelo_ia');
}

export function importarModeloGgufLocal(caminho: string): Promise<string> {
  return chamar<string>('importar_modelo_gguf_local', { caminho });
}

export function removerModeloIa(modeloId: string): Promise<void> {
  return chamar<void>('remover_modelo_ia', { modeloId });
}

export function configurarEndpointIaLocal(endpoint: string): Promise<StatusIaLocal> {
  return chamar<StatusIaLocal>('configurar_endpoint_ia_local', { endpoint });
}

export function iniciarMotorIaLocal(modeloId?: string): Promise<StatusIaLocal> {
  return chamar<StatusIaLocal>('iniciar_motor_ia_local', { modeloId });
}

export function pararMotorIaLocal(): Promise<StatusIaLocal> {
  return chamar<StatusIaLocal>('parar_motor_ia_local');
}

export function consultarAssistenteIa(mensagem: string): Promise<RespostaAssistenteIa> {
  return chamar<RespostaAssistenteIa>('consultar_assistente_ia', { mensagem });
}

export function executarPropostaIa(proposta: PropostaAcaoIa): Promise<ResultadoExecucaoIa> {
  return chamar<ResultadoExecucaoIa>('executar_proposta_ia', { proposta });
}
