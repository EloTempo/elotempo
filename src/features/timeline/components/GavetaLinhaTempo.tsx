/**
 * A gaveta das linhas do tempo (fatia 07, seção 8).
 *
 * **Split, não overlay** — a seção 8 é explícita. A alça arrasta e o usuário
 * escolhe a proporção entre a árvore e o contexto.
 *
 * O eixo é horizontal. A proibição de layout horizontal da seção 10 vale só
 * para a **árvore** — o tempo é horizontal por natureza.
 *
 * Três coisas que a primeira versão errou e que estão resolvidas aqui:
 *
 * 1. **A vida era duas marcas soltas.** Agora é uma barra contínua do
 *    nascimento ao falecimento, com os eventos como traços sobre ela. A vida
 *    de alguém é um período, não dois instantes.
 * 2. **Os rótulos se sobrepunham** num borrão ilegível quando os marcos ficavam
 *    próximos. Agora só desenha o rótulo que tem espaço; os demais ficam no
 *    traço, com o texto no hover.
 * 3. **Não havia como percorrer o tempo.** Agora arrasta-se o eixo, e há
 *    botões — gesto escondido não conta como recurso.
 */

import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import {
  ChevronDown,
  ChevronUp,
  Clock,
  Info,
  Lock,
  Maximize2,
  X,
  ZoomIn,
  ZoomOut,
} from 'lucide-react';
import {
  listarLinhasDeContexto,
  buscarMarcos,
  montarLinhaPessoal,
  quemEstavaVivo,
  ehIntervalo,
  LIMITE_DE_CAMADAS,
  type Marco,
} from '../../../lib/api';

interface GavetaLinhaTempoProps {
  pessoaSelecionadaId: string | null;
  /** Comunica à árvore quem destacar; `null` limpa o destaque. */
  onDestacar: (ids: string[] | null) => void;
}

const ALTURA_MINIMA = 180;
const ALTURA_INICIAL = 320;
const ALTURA_DA_FAIXA = 52;
const ALTURA_DA_VIDA = 60;

/** Espaço mínimo entre dois rótulos para os dois caberem sem se encavalar. */
const ESPACO_ENTRE_ROTULOS = 96;

/** Ano de referência para "até hoje" nas barras de quem está vivo. */
const ANO_CORRENTE = new Date().getFullYear();

/**
 * Paleta própria das linhas do tempo.
 *
 * Não reaproveita `--masc` nem `--fem`: no card da árvore essas cores
 * significam **sexo** (seção 10), e usá-las aqui faria uma barra rosa de
 * "tecnologia" sugerir gênero. Cada tema define as cinco em globals.css,
 * ajustadas para contrastar com o fundo da gaveta.
 */
const COR_DA_CATEGORIA: Record<string, string> = {
  historia: 'var(--lt-historia)',
  politica: 'var(--lt-politica)',
  moeda: 'var(--lt-moeda)',
  tecnologia: 'var(--lt-tecnologia)',
  projeto: 'var(--lt-projeto)',
};

function corDa(categoria: string | undefined): string {
  return COR_DA_CATEGORIA[categoria ?? ''] ?? 'var(--acento)';
}

/**
 * Quais marcos ganham rótulo.
 *
 * Percorre da esquerda para a direita e só rotula quem começa depois do espaço
 * reservado pelo rótulo anterior. Sem isto, quarenta marcos de história do
 * Brasil viram um borrão — que foi exatamente o que aconteceu.
 */
export function marcosComRotulo(marcos: Marco[], x: (ano: number) => number): Set<string> {
  const ordenados = [...marcos].sort(
    (a, b) => (a.ano_inicio ?? 0) - (b.ano_inicio ?? 0),
  );
  const comRotulo = new Set<string>();
  let proximoLivre = -Infinity;

  for (const m of ordenados) {
    if (m.ano_inicio == null) continue;
    const posicao = x(m.ano_inicio);
    if (posicao >= proximoLivre) {
      comRotulo.add(m.id);
      proximoLivre = posicao + ESPACO_ENTRE_ROTULOS;
    }
  }
  return comRotulo;
}

export function GavetaLinhaTempo({
  pessoaSelecionadaId,
  onDestacar,
}: GavetaLinhaTempoProps) {
  const [aberta, setAberta] = useState(false);
  const [altura, setAltura] = useState(ALTURA_INICIAL);
  const [ativas, setAtivas] = useState<string[]>([]);
  const [marcoAberto, setMarcoAberto] = useState<Marco | null>(null);
  const [avisoLimite, setAvisoLimite] = useState<string | null>(null);
  const [vivosInfo, setVivosInfo] = useState<{
    ids: string[];
    sem_data_de_nascimento: number;
  } | null>(null);

  const { data: linhas } = useQuery({
    queryKey: ['linhas-de-contexto'],
    queryFn: listarLinhasDeContexto,
    staleTime: Infinity,
  });

  const { data: linhaPessoal } = useQuery({
    queryKey: ['linha-pessoal', pessoaSelecionadaId],
    queryFn: () => montarLinhaPessoal(pessoaSelecionadaId!),
    enabled: !!pessoaSelecionadaId && aberta,
  });

  useEffect(() => {
    if (linhas && linhas.length > 0 && ativas.length === 0) {
      const brasil = linhas.find((l) => l.categoria === 'historia');
      if (brasil) setAtivas([brasil.id]);
    }
  }, [linhas, ativas.length]);

  // ---------------------------------------------------------------
  // Janela de anos
  // ---------------------------------------------------------------
  const [janela, setJanela] = useState({ de: 1850, ate: 2030 });

  const enquadrarVida = useCallback(() => {
    if (!linhaPessoal?.ano_nascimento) return;
    const nasc = linhaPessoal.ano_nascimento;
    const falec =
      linhaPessoal.ano_falecimento ?? (linhaPessoal.is_vivo ? ANO_CORRENTE : nasc + 80);
    const folga = Math.max(15, Math.round((falec - nasc) * 0.25));
    setJanela({ de: nasc - folga, ate: falec + folga });
  }, [linhaPessoal]);

  useEffect(() => {
    enquadrarVida();
  }, [enquadrarVida]);

  const { data: marcos } = useQuery({
    queryKey: ['marcos', ativas, janela.de, janela.ate],
    queryFn: () => buscarMarcos(ativas, janela.de, janela.ate, true),
    enabled: aberta && ativas.length > 0,
  });

  // ---------------------------------------------------------------
  // Medidas
  // ---------------------------------------------------------------
  const palcoRef = useRef<HTMLDivElement>(null);
  const [largura, setLargura] = useState(900);

  useEffect(() => {
    const medir = () => setLargura(palcoRef.current?.clientWidth ?? 900);
    medir();
    window.addEventListener('resize', medir);
    return () => window.removeEventListener('resize', medir);
  }, [aberta, altura]);

  const posicaoDoAno = useMemo(() => {
    const span = Math.max(1, janela.ate - janela.de);
    return (ano: number) => ((ano - janela.de) / span) * largura;
  }, [janela, largura]);

  const marcasDoEixo = useMemo(() => {
    const span = janela.ate - janela.de;
    const passo = span > 400 ? 100 : span > 150 ? 50 : span > 60 ? 20 : span > 25 ? 10 : 5;
    const marcas: number[] = [];
    for (let a = Math.ceil(janela.de / passo) * passo; a <= janela.ate; a += passo) {
      marcas.push(a);
    }
    return marcas;
  }, [janela]);

  // ---------------------------------------------------------------
  // Zoom e deslocamento do eixo
  // ---------------------------------------------------------------
  const aplicarZoom = useCallback(
    (fator: number, ancoraX?: number) => {
      setJanela((atual) => {
        const span = atual.ate - atual.de;
        const proporcao = ancoraX != null ? ancoraX / Math.max(1, largura) : 0.5;
        const anoNaAncora = atual.de + proporcao * span;
        const novoSpan = Math.max(15, Math.min(700, span * fator));
        return {
          de: Math.round(anoNaAncora - novoSpan * proporcao),
          ate: Math.round(anoNaAncora + novoSpan * (1 - proporcao)),
        };
      });
    },
    [largura],
  );

  const deslocar = useCallback(
    (pixels: number) => {
      setJanela((atual) => {
        const span = atual.ate - atual.de;
        const anos = (pixels / Math.max(1, largura)) * span;
        return { de: Math.round(atual.de + anos), ate: Math.round(atual.ate + anos) };
      });
    },
    [largura],
  );

  // Arrastar o eixo para percorrer o tempo.
  const arrastandoEixo = useRef(false);
  const ultimoX = useRef(0);
  const arrastou = useRef(false);

  useEffect(() => {
    const mover = (e: MouseEvent) => {
      if (!arrastandoEixo.current) return;
      const delta = e.clientX - ultimoX.current;
      if (Math.abs(delta) > 2) arrastou.current = true;
      ultimoX.current = e.clientX;
      deslocar(-delta);
    };
    const soltar = () => {
      arrastandoEixo.current = false;
      document.body.style.cursor = '';
    };
    window.addEventListener('mousemove', mover);
    window.addEventListener('mouseup', soltar);
    return () => {
      window.removeEventListener('mousemove', mover);
      window.removeEventListener('mouseup', soltar);
    };
  }, [deslocar]);

  // ---------------------------------------------------------------
  // Alça de redimensionamento da gaveta
  // ---------------------------------------------------------------
  const arrastandoAlca = useRef(false);
  const inicioY = useRef(0);
  const alturaInicial = useRef(0);

  useEffect(() => {
    const mover = (e: MouseEvent) => {
      if (!arrastandoAlca.current) return;
      const nova = Math.max(
        ALTURA_MINIMA,
        Math.min(window.innerHeight * 0.8, alturaInicial.current + (inicioY.current - e.clientY)),
      );
      setAltura(nova);
    };
    const soltar = () => {
      arrastandoAlca.current = false;
      document.body.style.cursor = '';
      document.body.style.userSelect = '';
    };
    window.addEventListener('mousemove', mover);
    window.addEventListener('mouseup', soltar);
    return () => {
      window.removeEventListener('mousemove', mover);
      window.removeEventListener('mouseup', soltar);
    };
  }, []);

  // ---------------------------------------------------------------
  // Ações
  // ---------------------------------------------------------------
  const alternarLinha = (id: string) => {
    setAvisoLimite(null);
    setAtivas((atuais) => {
      if (atuais.includes(id)) return atuais.filter((x) => x !== id);
      if (atuais.length >= LIMITE_DE_CAMADAS) {
        setAvisoLimite(
          `A gaveta mostra até ${LIMITE_DE_CAMADAS} linhas de contexto ao mesmo tempo. Desligue uma para ligar outra — a vida da pessoa selecionada não ocupa vaga.`,
        );
        return atuais;
      }
      return [...atuais, id];
    });
  };

  const abrirMarco = async (m: Marco) => {
    // Arrastar o eixo não pode disparar o marco que estava sob o cursor.
    if (arrastou.current) return;
    setMarcoAberto(m);
    if (m.ano_inicio != null) {
      try {
        const r = await quemEstavaVivo(m.ano_inicio, m.ano_fim ?? null);
        onDestacar(r.ids);
        setVivosInfo(r);
      } catch {
        onDestacar(null);
      }
    }
  };

  const fecharMarco = () => {
    setMarcoAberto(null);
    setVivosInfo(null);
    onDestacar(null);
  };

  const marcosPorLinha = useMemo(() => {
    const mapa = new Map<string, Marco[]>();
    for (const m of marcos ?? []) {
      const lista = mapa.get(m.linha_id) ?? [];
      lista.push(m);
      mapa.set(m.linha_id, lista);
    }
    return mapa;
  }, [marcos]);

  // ---------------------------------------------------------------

  if (!aberta) {
    return (
      <div className="flex-none border-t border-borda bg-sup print:hidden">
        <button
          type="button"
          onClick={() => setAberta(true)}
          className="w-full flex items-center gap-2 px-4 py-2 text-sm text-tinta2 hover:text-tinta hover:bg-card transition-colors bg-transparent border-none cursor-pointer"
        >
          <Clock className="w-4 h-4" />
          Linha do tempo
          <span className="text-xs text-tinta3">— situe esta vida no contexto da época</span>
          <ChevronUp className="w-4 h-4 ml-auto" />
        </button>
      </div>
    );
  }

  return (
    <div
      className="flex-none border-t border-borda bg-sup flex flex-col print:hidden"
      style={{ height: altura }}
    >
      {/* Alça */}
      <div
        onMouseDown={(e) => {
          arrastandoAlca.current = true;
          inicioY.current = e.clientY;
          alturaInicial.current = altura;
          document.body.style.cursor = 'row-resize';
          document.body.style.userSelect = 'none';
        }}
        className="h-2 cursor-row-resize bg-borda/40 hover:bg-acento/40 transition-colors flex-none grid place-items-center"
        role="separator"
        aria-label="Arraste para redimensionar a linha do tempo"
      >
        <div className="w-10 h-0.5 rounded-full bg-borda2" />
      </div>

      {/* Camadas e controles */}
      <div className="flex items-center gap-2 px-3 py-2 border-b border-borda flex-none flex-wrap">
        <Clock className="w-4 h-4 text-acento flex-none" />

        <div className="flex flex-wrap gap-1.5 flex-1 min-w-0">
          {linhas?.map((l) => {
            const ligada = ativas.includes(l.id);
            const cor = corDa(l.categoria);
            return (
              <button
                key={l.id}
                type="button"
                onClick={() => alternarLinha(l.id)}
                title={
                  l.fonte_referencia
                    ? `${l.fonte_referencia}\n\nLinha de referência: somente leitura.`
                    : 'Linha de referência: somente leitura.'
                }
                // A cor vai na borda e no texto sobre `--card`, nunca como
                // fundo de texto branco: assim o contraste é o do próprio
                // tema e não depende de cada cor da paleta ser escura o
                // bastante — o que não era verdade nos temas noturnos.
                className={`text-[11px] px-2 py-1 rounded-raio-s border-2 bg-card transition-colors cursor-pointer flex items-center gap-1.5 ${
                  ligada ? 'font-semibold' : 'border-borda2 text-tinta2 hover:text-tinta'
                }`}
                style={ligada ? { borderColor: cor, color: cor } : undefined}
              >
                <span
                  className="w-2 h-2 rounded-full flex-none border"
                  style={{
                    background: ligada ? cor : 'transparent',
                    borderColor: cor,
                  }}
                  aria-hidden
                />
                {/* Somente leitura, marcado à vista — exigência da seção 10. */}
                <Lock className="w-2.5 h-2.5 opacity-50 flex-none" aria-hidden />
                {l.titulo}
                <span className="opacity-60">{l.marcos_alta}</span>
              </button>
            );
          })}
        </div>

        {/* Controles visíveis: gesto escondido não conta como recurso. */}
        <div className="flex items-center gap-0.5 flex-none">
          <button
            type="button"
            onClick={() => aplicarZoom(1.3)}
            title="Afastar (ver mais anos)"
            aria-label="Afastar"
            className="p-1.5 rounded-raio-s text-tinta2 hover:text-tinta hover:bg-card transition-colors"
          >
            <ZoomOut className="w-4 h-4" />
          </button>
          <button
            type="button"
            onClick={() => aplicarZoom(0.75)}
            title="Aproximar"
            aria-label="Aproximar"
            className="p-1.5 rounded-raio-s text-tinta2 hover:text-tinta hover:bg-card transition-colors"
          >
            <ZoomIn className="w-4 h-4" />
          </button>
          {linhaPessoal?.ano_nascimento && (
            <button
              type="button"
              onClick={enquadrarVida}
              title={`Enquadrar a vida de ${linhaPessoal.nome}`}
              aria-label="Enquadrar a vida da pessoa"
              className="p-1.5 rounded-raio-s text-tinta2 hover:text-tinta hover:bg-card transition-colors"
            >
              <Maximize2 className="w-4 h-4" />
            </button>
          )}
          <button
            type="button"
            onClick={() => setAberta(false)}
            aria-label="Recolher a linha do tempo"
            className="p-1.5 rounded-raio-s text-tinta3 hover:text-tinta transition-colors"
          >
            <ChevronDown className="w-4 h-4" />
          </button>
        </div>
      </div>

      {avisoLimite && (
        <p className="px-4 py-1.5 text-[11px] text-tinta2 bg-card2 border-b border-borda m-0">
          {avisoLimite}
        </p>
      )}

      {/* Eixo */}
      <div
        ref={palcoRef}
        className="flex-1 overflow-y-auto overflow-x-hidden min-h-0 select-none cursor-grab active:cursor-grabbing"
        onMouseDown={(e) => {
          arrastandoEixo.current = true;
          arrastou.current = false;
          ultimoX.current = e.clientX;
          document.body.style.cursor = 'grabbing';
        }}
        onWheel={(e) => {
          const caixa = palcoRef.current?.getBoundingClientRect();
          const x = caixa ? e.clientX - caixa.left : largura / 2;
          // Ctrl aproxima e afasta; a roda sozinha percorre o tempo, que é o
          // que se espera de um eixo horizontal.
          if (e.ctrlKey) aplicarZoom(e.deltaY > 0 ? 1.15 : 0.87, x);
          else deslocar(e.deltaY * 0.6 + e.deltaX);
        }}
      >
        {/* Régua */}
        <div className="sticky top-0 h-6 bg-sup border-b border-borda z-20">
          {marcasDoEixo.map((ano) => (
            <span
              key={ano}
              className="absolute top-0 font-num text-[10px] text-tinta3 border-l border-borda h-full pl-1"
              style={{ left: posicaoDoAno(ano) }}
            >
              {ano}
            </span>
          ))}
        </div>

        {/* Faixas de contexto */}
        {ativas.map((linhaId) => {
          const linha = linhas?.find((l) => l.id === linhaId);
          const cor = corDa(linha?.categoria);
          const daLinha = marcosPorLinha.get(linhaId) ?? [];
          const rotulados = marcosComRotulo(daLinha, posicaoDoAno);

          return (
            <div
              key={linhaId}
              className="relative border-b border-borda/50"
              style={{ height: ALTURA_DA_FAIXA }}
            >
              <span className="absolute left-1 top-0.5 font-num text-[9.5px] text-tinta3 z-10 pointer-events-none bg-sup/85 px-1 rounded flex items-center gap-1">
                <Lock className="w-2.5 h-2.5 opacity-60" aria-hidden />
                {linha?.titulo}
              </span>

              {daLinha.map((m) => {
                const inicio = m.ano_inicio ?? janela.de;
                const x = posicaoDoAno(inicio);
                const intervalo = ehIntervalo(m);
                const larguraBarra = intervalo
                  ? Math.max(3, posicaoDoAno(m.ano_fim!) - x)
                  : 0;
                const temRotulo = rotulados.has(m.id);

                return (
                  <button
                    key={m.id}
                    type="button"
                    onClick={() => abrirMarco(m)}
                    title={`${m.data_periodo_texto} — ${m.titulo}`}
                    className="absolute bottom-1 cursor-pointer bg-transparent border-none p-0 text-left group"
                    style={{ left: x, width: intervalo ? larguraBarra : 6 }}
                  >
                    {intervalo ? (
                      <span
                        className="block h-3 rounded-sm opacity-75 group-hover:opacity-100 transition-opacity"
                        style={{ background: cor, width: larguraBarra }}
                      />
                    ) : (
                      <span
                        className="block w-[3px] h-4 rounded-sm opacity-85 group-hover:opacity-100"
                        style={{ background: cor }}
                      />
                    )}

                    {/* Só rotula quem tem espaço; o resto fica no hover. */}
                    {temRotulo && (
                      <span className="block font-num text-[9.5px] text-tinta2 whitespace-nowrap truncate w-[90px] group-hover:text-tinta">
                        {m.titulo}
                      </span>
                    )}
                  </button>
                );
              })}
            </div>
          );
        })}

        {/* ---------------------------------------------------------
            A vida da pessoa — barra contínua, não duas marcas soltas.
            Sempre presente, sem ocupar vaga no limite de camadas.
        --------------------------------------------------------- */}
        {linhaPessoal?.ano_nascimento && (
          <FaixaDaVida
            linha={linhaPessoal}
            posicaoDoAno={posicaoDoAno}
          />
        )}

        {ativas.length === 0 && (
          <p className="p-4 text-sm text-tinta3 m-0">
            Nenhuma linha ligada. Escolha uma acima.
          </p>
        )}
      </div>

      {/* Detalhe do marco */}
      {marcoAberto && (
        <div className="flex-none border-t border-borda bg-card px-4 py-2.5 flex items-start gap-3">
          <Info className="w-4 h-4 text-acento flex-none mt-0.5" />
          <div className="flex-1 min-w-0">
            <p className="m-0 text-sm text-tinta">
              <strong>{marcoAberto.titulo}</strong>
              <span className="font-num text-tinta2"> · {marcoAberto.data_periodo_texto}</span>
            </p>
            {marcoAberto.descricao && (
              <p className="m-0 text-xs text-tinta2 leading-relaxed">{marcoAberto.descricao}</p>
            )}
            {marcoAberto.fonte_especifica && (
              <p className="m-0 text-[11px] text-tinta3 italic">
                Fonte: {marcoAberto.fonte_especifica}
              </p>
            )}
            {vivosInfo && (
              <p className="m-0 mt-1 text-[11px] text-acento">
                {vivosInfo.ids.length}{' '}
                {vivosInfo.ids.length === 1 ? 'pessoa destacada' : 'pessoas destacadas'} na árvore
                {vivosInfo.sem_data_de_nascimento > 0 &&
                  ` · ${vivosInfo.sem_data_de_nascimento} sem data de nascimento não puderam ser avaliadas`}
              </p>
            )}
          </div>
          <button
            type="button"
            onClick={fecharMarco}
            aria-label="Fechar detalhe"
            className="text-tinta3 hover:text-tinta p-1 flex-none"
          >
            <X className="w-4 h-4" />
          </button>
        </div>
      )}
    </div>
  );
}

/**
 * A faixa da vida de uma pessoa.
 *
 * A barra é o elemento principal: uma vida é um período, não dois instantes.
 * Os eventos são traços **sobre** a barra, e os anos das pontas ficam nas
 * extremidades, onde se lê sem precisar cruzar com a régua.
 */
function FaixaDaVida({
  linha,
  posicaoDoAno,
}: {
  linha: {
    nome: string;
    ano_nascimento?: number | null;
    ano_falecimento?: number | null;
    is_vivo: boolean;
    marcos: Array<{ tipo: string; data_texto?: string | null; local?: string | null; ano?: number | null }>;
  };
  posicaoDoAno: (ano: number) => number;
}) {
  const nasceu = linha.ano_nascimento!;
  const terminou = linha.ano_falecimento ?? (linha.is_vivo ? ANO_CORRENTE : null);

  const x0 = posicaoDoAno(nasceu);
  // Sem ano de fim conhecido, a barra vira um toco: mostra que a vida começou
  // ali e que o resto não se sabe, em vez de inventar uma duração.
  const x1 = terminou != null ? posicaoDoAno(terminou) : x0 + 14;
  const larguraBarra = Math.max(6, x1 - x0);

  return (
    <div
      className="relative border-t-2 border-acento/40 bg-card/50"
      style={{ height: ALTURA_DA_VIDA }}
    >
      <span className="absolute left-1 top-0.5 font-num text-[9.5px] text-acento z-10 pointer-events-none bg-sup/85 px-1 rounded">
        {linha.nome}
      </span>

      {/* A barra da vida */}
      <span
        className="absolute rounded-full bg-acento/70 border border-acento"
        style={{ left: x0, width: larguraBarra, height: 14, bottom: 22 }}
        title={`${nasceu} – ${
          linha.ano_falecimento ?? (linha.is_vivo ? 'hoje' : 'sem data de falecimento')
        }`}
      />

      {/* Anos nas pontas, para não precisar cruzar com a régua */}
      <span
        className="absolute font-num text-[9.5px] text-acento pointer-events-none"
        style={{ left: x0, bottom: 38 }}
      >
        {nasceu}
      </span>
      {terminou != null && larguraBarra > 46 && (
        <span
          className="absolute font-num text-[9.5px] text-acento pointer-events-none"
          style={{ left: x1 - 30, bottom: 38 }}
        >
          {linha.ano_falecimento ?? 'hoje'}
        </span>
      )}

      {/* Eventos como traços sobre a barra */}
      {linha.marcos
        .filter((m) => m.ano != null)
        .map((m, i) => (
          <span
            key={`${m.tipo}-${i}`}
            className="absolute flex flex-col items-center"
            style={{ left: posicaoDoAno(m.ano!) - 1, bottom: 4 }}
            title={`${m.tipo}: ${m.data_texto ?? ''}${m.local ? ' · ' + m.local : ''}`}
          >
            <span className="w-[2px] h-[26px] bg-tinta2/70" />
            <span className="font-num text-[9px] text-tinta2 whitespace-nowrap">{m.tipo}</span>
          </span>
        ))}
    </div>
  );
}
