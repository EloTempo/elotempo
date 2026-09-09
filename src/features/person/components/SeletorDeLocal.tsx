/**
 * Escolha de local para um evento (fatia 04).
 *
 * Dois modos, porque a seção 2.4 trata os dois casos de forma diferente:
 *
 * - **Brasil** — autocomplete sobre os 5.571 municípios do IBGE. O evento passa
 *   a apontar para uma linha de `locais` com `codigo_ibge`, que é a chave
 *   estável para agrupar em estatística. Nome de cidade muda; o código, não.
 * - **Exterior** — o país sai de lista, a cidade é texto livre. É o que a spec
 *   determina: no exterior só o país é padronizado.
 *
 * Escolher da lista **nunca é obrigatório**. Quem não achar o município, ou
 * cujo lugar não exista mais, escreve no rótulo histórico e salva do mesmo
 * jeito — a mesma regra transversal das datas.
 */

import { useEffect, useRef, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Check, MapPin, X } from 'lucide-react';
import { buscarLocais, registrarLocalEstrangeiro } from '../../../lib/api';
import { usePaises } from '../hooks/useFicha';
import { rotuloDoLocal, type Place } from '../../../types';

interface SeletorDeLocalProps {
  /** Local já escolhido, se houver. */
  local: Place | null;
  onEscolher: (local: Place | null) => void;
  /** Rótulo histórico: "Vila de São Salvador, hoje Campos". */
  rotuloHistorico: string;
  onMudarRotulo: (v: string) => void;
}

export function SeletorDeLocal({
  local,
  onEscolher,
  rotuloHistorico,
  onMudarRotulo,
}: SeletorDeLocalProps) {
  const [modo, setModo] = useState<'brasil' | 'exterior'>('brasil');
  const [termo, setTermo] = useState('');
  const [termoAtrasado, setTermoAtrasado] = useState('');
  const [cidadeExterior, setCidadeExterior] = useState('');
  const [paisId, setPaisId] = useState('pt');
  const [salvandoExterior, setSalvandoExterior] = useState(false);
  const [erro, setErro] = useState<string | null>(null);

  const { data: paises } = usePaises();

  // Espera a digitação parar antes de consultar. Sem isso, cada tecla dispara
  // uma varredura dos 5.571 municípios.
  const temporizador = useRef<ReturnType<typeof setTimeout> | null>(null);
  useEffect(() => {
    if (temporizador.current) clearTimeout(temporizador.current);
    temporizador.current = setTimeout(() => setTermoAtrasado(termo), 200);
    return () => {
      if (temporizador.current) clearTimeout(temporizador.current);
    };
  }, [termo]);

  const { data: sugestoes, isFetching } = useQuery({
    queryKey: ['locais', termoAtrasado],
    queryFn: () => buscarLocais(termoAtrasado),
    enabled: termoAtrasado.trim().length >= 2,
    staleTime: 5 * 60_000,
  });

  const usarCidadeEstrangeira = async () => {
    if (!cidadeExterior.trim()) return;
    setSalvandoExterior(true);
    setErro(null);
    try {
      let lat: number | undefined;
      let lon: number | undefined;
      try {
        // Tenta obter geolocalização rápida (timeout de 2.5s) para cidades rurais ou vilarejos não cadastrados
        const resp = await fetch(
          `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(cidadeExterior.trim())}&countrycodes=${encodeURIComponent(paisId.toLowerCase())}&format=json&limit=1`,
          { signal: AbortSignal.timeout(2500) }
        );
        if (resp.ok) {
          const dadosGeo = await resp.json();
          if (dadosGeo && dadosGeo[0]) {
            lat = parseFloat(dadosGeo[0].lat);
            lon = parseFloat(dadosGeo[0].lon);
          }
        }
      } catch {
        // Silencioso se offline ou sem resposta
      }

      const criado = await registrarLocalEstrangeiro(cidadeExterior.trim(), paisId, lat, lon);
      onEscolher(criado);
      setCidadeExterior('');
    } catch (e) {
      setErro(e instanceof Error ? e.message : String(e));
    } finally {
      setSalvandoExterior(false);
    }
  };

  return (
    <div className="flex flex-col gap-2">
      <span className="text-[11px] text-tinta2">Local</span>

      {/* Já escolhido: mostra e permite trocar. */}
      {local ? (
        <div className="flex items-center gap-2 px-2.5 py-2 rounded-raio-s border border-acento bg-card">
          <MapPin className="w-3.5 h-3.5 text-acento flex-none" />
          <span className="text-sm text-tinta flex-1 truncate">{rotuloDoLocal(local)}</span>
          {local.codigo_ibge && (
            <span className="font-num text-[10px] text-tinta3 flex-none">IBGE</span>
          )}
          <button
            type="button"
            onClick={() => onEscolher(null)}
            aria-label="Tirar o local"
            className="text-tinta3 hover:text-fem p-0.5 bg-transparent border-none cursor-pointer flex-none"
          >
            <X className="w-3.5 h-3.5" />
          </button>
        </div>
      ) : (
        <>
          <div className="flex gap-1 p-0.5 bg-sup rounded-raio-s border border-borda">
            {(
              [
                { id: 'brasil', rotulo: 'Brasil' },
                { id: 'exterior', rotulo: 'Exterior' },
              ] as const
            ).map(({ id, rotulo }) => (
              <button
                key={id}
                type="button"
                onClick={() => setModo(id)}
                className={`flex-1 py-1 text-[11px] rounded-raio-s transition-colors ${
                  modo === id
                    ? 'bg-card text-tinta font-semibold'
                    : 'text-tinta2 hover:text-tinta'
                }`}
              >
                {rotulo}
              </button>
            ))}
          </div>

          {modo === 'brasil' ? (
            <div className="flex flex-col gap-1">
              <input
                type="text"
                value={termo}
                onChange={(e) => setTermo(e.target.value)}
                placeholder="Digite o município — ex.: campos"
                className="text-sm px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta w-full focus:outline-none focus:border-acento"
              />

              {termoAtrasado.trim().length >= 2 && (
                <div className="max-h-40 overflow-y-auto border border-borda rounded-raio-s divide-y divide-borda">
                  {isFetching && (
                    <p className="px-2 py-1.5 text-[11px] text-tinta3 m-0">Procurando…</p>
                  )}
                  {!isFetching && (sugestoes ?? []).length === 0 && (
                    <p className="px-2 py-1.5 text-[11px] text-tinta3 m-0">
                      Nenhum município com esse nome. Se o lugar não existe mais, escreva
                      abaixo em “como era chamado”.
                    </p>
                  )}
                  {(sugestoes ?? []).map((l) => (
                    <button
                      key={l.id}
                      type="button"
                      onClick={() => {
                        onEscolher(l);
                        setTermo('');
                      }}
                      className="w-full text-left px-2 py-1.5 text-sm text-tinta hover:bg-sup transition-colors flex items-center gap-2"
                    >
                      <Check className="w-3 h-3 text-tinta3 flex-none" />
                      <span className="truncate">{rotuloDoLocal(l)}</span>
                    </button>
                  ))}
                </div>
              )}
            </div>
          ) : (
            <div className="flex flex-col gap-2">
              <select
                value={paisId}
                onChange={(e) => setPaisId(e.target.value)}
                aria-label="País"
                className="text-sm px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta"
              >
                {paises
                  ?.filter((p) => p.id !== 'br')
                  .map((p) => (
                    <option key={p.id} value={p.id}>
                      {p.nome}
                    </option>
                  ))}
              </select>

              <div className="flex gap-2">
                <input
                  type="text"
                  value={cidadeExterior}
                  onChange={(e) => setCidadeExterior(e.target.value)}
                  placeholder="Cidade — ex.: Lisboa"
                  className="flex-1 text-sm px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta focus:outline-none focus:border-acento"
                />
                <button
                  type="button"
                  onClick={usarCidadeEstrangeira}
                  disabled={salvandoExterior || !cidadeExterior.trim()}
                  className="text-xs px-3 rounded-raio-s bg-acento text-acento-tinta border-none cursor-pointer disabled:opacity-50"
                >
                  {salvandoExterior ? '…' : 'Usar'}
                </button>
              </div>

              <p className="text-[10.5px] text-tinta3 m-0 leading-relaxed">
                No exterior só o país é padronizado — a cidade é texto livre, como manda a
                seção 2.4.
              </p>
            </div>
          )}
        </>
      )}

      {erro && (
        <p role="alert" className="text-[11px] text-fem m-0">
          {erro}
        </p>
      )}

      {/* O rótulo histórico é independente do município escolhido: o código do
          IBGE continua sendo a chave, e isto é o que se lê na tela. */}
      <label className="flex flex-col gap-1">
        <span className="text-[11px] text-tinta2">Como era chamado na época (opcional)</span>
        <input
          type="text"
          value={rotuloHistorico}
          onChange={(e) => onMudarRotulo(e.target.value)}
          placeholder="Vila de São Salvador, hoje Campos"
          className="text-sm px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta w-full focus:outline-none focus:border-acento"
        />
      </label>
    </div>
  );
}
