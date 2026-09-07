import { useState, useEffect, useMemo } from 'react';
import { IconeAplicativo } from '../icons';
import { ArrowRight } from 'lucide-react';

interface TelaCarregamentoSimsProps {
  onConcluido: () => void;
  duracaoMinimaMs?: number;
}

const FRASES_DIVERTIDAS: string[] = [
  // Genealogia & Antepassados
  'Decifrando garranchos do vigário na certidão de batismo de 1782...',
  'Perguntando para a tia-avó se aquele primo de terceiro grau realmente existiu...',
  'Procurando a certidão de casamento que caiu atrás do guarda-roupa da bisavó...',
  'Descobrindo que dois ramos da árvore eram, na verdade, os mesmos primos...',
  'Eliminando 37 homônimos chamados José da Silva nascidos em Minas Gerais...',
  'Calculando se o trisavô tinha 28 ou 84 anos na certidão de óbito...',
  'Verificando se o sobrenome mudou de grafia no navio dos imigrantes...',
  'Localizando livros paroquiais roídos por traças na sacristia da paróquia...',
  'Separando os 12 primos que se chamam Antônio na mesma família...',
  'Descobrindo que o parente "conde italiano" era, na verdade, de Campinas...',
  'Consultando certidões escritas com pena de ganso e tinta de nogueira...',
  'Desfazendo o nó daquele tio solteirão que ninguém sabia o nome completo...',
  'Escaneando fotos em sépia guardadas dentro de latas de biscoito amanteigado...',
  'Convencendo o cartório do século XIX a usar letra legível...',
  'Procurando primos distantes para ver quem herdou os olhos do tataravô...',
  'Tentando entender por que o bisavô registrou os filhos com cinco anos de atraso...',
  'Desvendando se "dona sinhá" era nome de batismo ou apelido de infância...',
  'Encontrando uma certidão amassada usada como marcador da Bíblia de 1904...',

  // História do Brasil & Linhas de Contexto
  'Aguardando D. Pedro I proclamar a Independência às margens do Ipiranga...',
  'Contando moedas de réis para pagar o café no Império...',
  'Pedindo para D. Pedro II posar com calma para mais um daguerreótipo...',
  'Convertendo réis em cruzeiros, cruzados, cruzeiros reais e reais sem enlouquecer...',
  'Avisando a corte portuguesa no Rio de Janeiro que o correio de Lisboa chegou...',
  'Verificando se Santos Dumont já aterrissou o 14-Bis...',
  'Desembarcando malas de vime no Porto de Santos em 1898...',
  'Sintonizando a primeira transmissão de rádio na Exposição do Centenário de 1922...',
  'Alimentando os cavalos da diligência que traz as cartas de Ouro Preto...',
  'Afiando penas de pato para redigir o testamento em cartório colonial...',
  'Calculando o preço da saca de café na Bolsa de Santos em 1906...',
  'Acompanhando a chegada dos imigrantes na Hospedaria do Brás...',
  'Esperando a balsa atravessar o rio Paraíba do Sul com as mercadorias...',
  'Redigindo ata paroquial à luz de candeeiro de querosene...',

  // História Mundial & Bíblica
  'Traduzindo tábuas de argila da Mesopotâmia sobre a colheita de cevada...',
  'Esperando os escribas do Egito Antigo terminarem os hieróglifos...',
  'Aguardando os monges copistas terminarem de iluminar o manuscrito medieval...',
  'Calibrando o astrolábio das caravelas em alto-mar...',
  'Aguardando a peste bubônica passar para reabrir os arquivos paroquiais...',
  'Conferindo se Napoleão Bonaparte já terminou o retiro na Ilha de Elba...',
  'Consultando os patriarcas para conferir as 77 gerações desde Adão...',
  'Calculando a rota dos pombos-correio com notícias de além-mar...',
  'Lendo papiros antigos à procura da linhagem dos reis de Judá...',
  'Esperando a caravela vencer a calmaria no Oceano Atlântico...',
  'Verificando as rotas da Seda para encontrar certidões do Oriente...',

  // Homenagens The Sims 2 ("Reticulando...")
  'Reticulando splines genealógicas...',
  'Construindo árvores genealógicas sem remover a escada da piscina...',
  'Consultando o Plumbob ancestral...',
  'Alinhando 4.000 anos de história humana em ordem cronológica...',
  'Fortificando o cofre de segurança contra invasores do futuro...',
  'Sincronizando séculos, impérios e certidões no relógio do tempo...',
  'Organizando gerações familiares em filas perfeitamente ordenadas...',
  'Polindo anéis de sinete e brasões de família...',
  'Carregando acervo de vidas e memórias...',
];

function embaralharArray<T>(array: T[]): T[] {
  const copia = [...array];
  for (let i = copia.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [copia[i], copia[j]] = [copia[j], copia[i]];
  }
  return copia;
}

export function TelaCarregamentoSims({
  onConcluido,
  duracaoMinimaMs = 8000, // Barra atinge 100% em ~8s, depois aguarda qualquer tecla
}: TelaCarregamentoSimsProps) {
  // Embaralha as frases uma única vez por sessão para garantir variedade
  const frasesEmbaralhadas = useMemo(() => embaralharArray(FRASES_DIVERTIDAS), []);

  const [indiceFrase, setIndiceFrase] = useState(0);
  const [progresso, setProgresso] = useState(0);
  const [carregado, setCarregado] = useState(false);
  const [visivel, setVisivel] = useState(true);
  const [animandoTexto, setAnimandoTexto] = useState(true);
  const [iniciando, setIniciando] = useState(false);

  // Rotação das frases a cada 10 segundos com transição suave
  useEffect(() => {
    const intervaloTexto = setInterval(() => {
      setAnimandoTexto(false);
      setTimeout(() => {
        setIndiceFrase((prev) => (prev + 1) % frasesEmbaralhadas.length);
        setAnimandoTexto(true);
      }, 400);
    }, 10000);

    return () => clearInterval(intervaloTexto);
  }, [frasesEmbaralhadas]);

  // Avanço orgânico da barra de progresso estilo The Sims 2 até 100%
  useEffect(() => {
    const inicio = Date.now();
    const interval = setInterval(() => {
      const decorrido = Date.now() - inicio;
      const proporcao = Math.min(1, decorrido / duracaoMinimaMs);

      // Curva de progresso orgânica
      let progressoCurva: number;
      if (proporcao < 0.25) {
        progressoCurva = (proporcao / 0.25) * 32;
      } else if (proporcao < 0.75) {
        progressoCurva = 32 + ((proporcao - 0.25) / 0.5) * 46;
      } else {
        progressoCurva = 78 + ((proporcao - 0.75) / 0.25) * 22;
      }

      const valorAtual = Math.round(progressoCurva);
      setProgresso(valorAtual);

      if (proporcao >= 1) {
        clearInterval(interval);
        setProgresso(100);
        setCarregado(true);
      }
    }, 40);

    return () => clearInterval(interval);
  }, [duracaoMinimaMs]);

  // Transição de saída suave ao iniciar
  const iniciarAplicativo = () => {
    if (iniciando) return;
    setIniciando(true);
    setVisivel(false);
    setTimeout(() => {
      onConcluido();
    }, 500);
  };

  // Atalhos de teclado:
  // - Se 100% carregado: QUALQUER tecla inicia o aplicativo
  // - Se ainda carregando: [Esc] pula imediatamente
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (carregado) {
        iniciarAplicativo();
      } else if (e.key === 'Escape') {
        iniciarAplicativo();
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [carregado, iniciando]);

  return (
    <div
      onClick={() => {
        if (carregado) iniciarAplicativo();
      }}
      className={`fixed inset-0 z-[99999] flex flex-col items-center justify-between p-6 sm:p-10 select-none transition-opacity duration-500 ease-out text-white ${
        visivel ? 'opacity-100 pointer-events-auto' : 'opacity-0 pointer-events-none'
      } ${carregado ? 'cursor-pointer' : 'cursor-default'}`}
      style={{
        backgroundColor: '#070d18', // Azul-marinho profundo oficial da marca
        backgroundImage: `radial-gradient(circle at 50% 35%, #0f1c34 0%, #070d18 80%)`,
      }}
    >
      {/* Topo: Detalhe superior e botão */}
      <div className="w-full flex items-center justify-between text-xs max-w-4xl">
        <div className="flex items-center gap-2 text-slate-400 font-mono tracking-wider">
          <span
            className={`w-2 h-2 rounded-full ${
              carregado ? 'bg-emerald-400' : 'bg-blue-400 animate-ping'
            }`}
          />
          <span>{carregado ? 'SISTEMA PRONTO' : 'INICIALIZANDO ACERVO HISTÓRICO'}</span>
        </div>

        <button
          type="button"
          onClick={(e) => {
            e.stopPropagation();
            iniciarAplicativo();
          }}
          className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-full border transition-all text-xs cursor-pointer shadow-xs hover:scale-105 ${
            carregado
              ? 'bg-blue-600 hover:bg-blue-500 text-white border-blue-400 font-medium'
              : 'bg-slate-800/80 hover:bg-slate-700 text-slate-300 hover:text-white border-slate-700'
          }`}
          title={carregado ? 'Entrar no EloTempo' : 'Pular animação e entrar direto'}
        >
          <span>{carregado ? 'Entrar' : 'Pular'}</span>
          <ArrowRight className="w-3.5 h-3.5" />
          <span className="text-[10px] text-slate-300 font-mono">
            {carregado ? '[Qualquer Tecla]' : '[Esc]'}
          </span>
        </button>
      </div>

      {/* Centro: Logotipo em Destaque e Título com Fonte Sora Leve */}
      <div className="flex flex-col items-center text-center max-w-xl my-auto">
        <div className="relative mb-6">
          {/* Brilho discreto em harmonia com a marca */}
          <div className="absolute -inset-4 bg-blue-600/15 blur-3xl rounded-full" />
          <div className="relative p-5 rounded-3xl bg-slate-900/90 border border-slate-800 shadow-xl backdrop-blur-xl">
            <IconeAplicativo size={88} className="rounded-2xl shadow-lg" />
          </div>
        </div>

        <h1 className="text-4xl sm:text-5xl font-marca font-normal tracking-[-0.02em] text-white mb-2 drop-shadow-sm">
          EloTempo
        </h1>

        <div className="flex items-center gap-2 text-sm sm:text-base font-normal text-slate-300 drop-shadow-xs">
          <span>Genealogia & História em Linhas do Tempo</span>
        </div>
      </div>

      {/* Base: Caixa de Mensagens de Carregamento & Barra de Progresso Clássica */}
      <div className="w-full max-w-xl flex flex-col items-center gap-4 mb-4">
        {/* Cartão de Operação do Sistema (sem aspas, duração de 10s) */}
        <div className="w-full bg-slate-900/90 border border-slate-800/90 rounded-2xl p-4 sm:p-5 shadow-xl min-h-[86px] flex items-center justify-center text-center relative overflow-hidden backdrop-blur-md">
          {/* Luz discreta no topo do card */}
          <div className="absolute top-0 left-1/4 right-1/4 h-[1px] bg-gradient-to-r from-transparent via-blue-500/30 to-transparent" />

          <p
            className={`m-0 text-sm sm:text-base font-normal text-slate-200 leading-relaxed transition-all duration-400 transform ${
              animandoTexto
                ? 'opacity-100 translate-y-0 scale-100'
                : 'opacity-0 translate-y-2 scale-98'
            }`}
          >
            {frasesEmbaralhadas[indiceFrase]}
          </p>
        </div>

        {/* Barra de Progresso Estilo The Sims 2 em Azul Oficial */}
        <div className="w-full flex flex-col gap-2">
          <div className="w-full h-6 sm:h-7 bg-slate-950 rounded-full border border-slate-800 p-1 shadow-inner relative overflow-hidden flex items-center">
            {/* Faixa de Preenchimento em Azul Real */}
            <div
              className="h-full rounded-full transition-all duration-100 ease-out relative overflow-hidden bg-gradient-to-r from-blue-700 via-blue-600 to-blue-500 shadow-sm flex items-center justify-end pr-2"
              style={{ width: `${Math.max(4, progresso)}%` }}
            >
              {/* Efeito de listras clássicas The Sims */}
              <div
                className="absolute inset-0 opacity-20 animate-[pulse_3s_infinite]"
                style={{
                  backgroundImage: `repeating-linear-gradient(
                    -45deg,
                    transparent,
                    transparent 10px,
                    rgba(255, 255, 255, 0.5) 10px,
                    rgba(255, 255, 255, 0.5) 20px
                  )`,
                }}
              />
            </div>
          </div>

          {/* Rodapé com Porcentagem e Status */}
          <div className="flex justify-between items-center px-1.5 text-xs font-mono text-slate-400">
            {carregado ? (
              <span className="flex items-center gap-1.5 text-emerald-400 font-medium">
                <span className="inline-block w-2 h-2 rounded-full bg-emerald-400 shadow-xs" />
                <span>Acervo e banco de dados prontos!</span>
              </span>
            ) : (
              <span className="flex items-center gap-1.5">
                <span className="inline-block w-1.5 h-1.5 rounded-full bg-blue-400 animate-pulse" />
                <span>Preparando genealogias e contextos históricos...</span>
              </span>
            )}
            <span
              className={`font-medium text-sm font-num ${
                carregado ? 'text-emerald-400' : 'text-blue-400'
              }`}
            >
              {progresso}%
            </span>
          </div>
        </div>

        {/* Chamada para Ação ao Concluir 100%: Botão sóbrio e sem símbolos supérfluos */}
        {carregado ? (
          <div className="w-full flex flex-col items-center gap-2 pt-1 animate-in fade-in zoom-in-95 duration-300">
            <button
              type="button"
              onClick={(e) => {
                e.stopPropagation();
                iniciarAplicativo();
              }}
              className="flex items-center gap-2.5 px-8 py-3 rounded-full bg-blue-600 hover:bg-blue-500 text-white font-marca font-medium text-sm sm:text-base shadow-lg shadow-blue-950/50 hover:scale-105 active:scale-95 transition-all cursor-pointer border border-blue-400/30"
            >
              <span>Pressione qualquer tecla para iniciar</span>
              <ArrowRight className="w-4 h-4" />
            </button>
            <span className="text-[11.5px] text-slate-400 font-mono tracking-wide">
              ou clique em qualquer lugar da tela
            </span>
          </div>
        ) : null}
      </div>
    </div>
  );
}
