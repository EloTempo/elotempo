import { useState, useEffect } from 'react';
import { X, Calendar, Check, Baby, Cross, Heart, Compass } from 'lucide-react';
import { useQueryClient } from '@tanstack/react-query';
import { Button } from '../../../components/ui/Button';
import { CampoDeData } from '../../../components/ui/CampoDeData';
import { SeletorDeLocal } from './SeletorDeLocal';
import {
  criarEvento,
  atualizarEvento,
  obterLocal,
  adicionarNacionalidade,
  listarNacionalidades,
} from '../../../lib/api';
import { DATA_VAZIA, type DataEscolhida, type Event, type Place } from '../../../types';
import { previaDoTexto } from '../../../components/ui/CampoDeData';

interface ModalEditarFatoVitalProps {
  aberto: boolean;
  aoFechar: () => void;
  pessoaId: string;
  tipoEvento: string; // 'nascimento' | 'batismo' | 'falecimento' | 'sepultamento'
  rotuloEvento: string;
  eventoExistente?: Event | null;
  aoSalvarSucesso?: () => void;
}

function eventoParaDataEscolhida(evento?: Event | null): DataEscolhida {
  if (!evento) return { ...DATA_VAZIA, qualificador: 'exata' };
  if (evento.ano_inicio != null) {
    if (evento.ano_fim != null && evento.ano_fim !== evento.ano_inicio) {
      return {
        ...DATA_VAZIA,
        qualificador: 'intervalo',
        ano: evento.ano_inicio,
        ano_fim: evento.ano_fim,
        dia: evento.dia_inicio ?? null,
        mes: evento.mes_inicio ?? null,
      };
    }
    return {
      ...DATA_VAZIA,
      qualificador: (evento.data_qualificador as DataEscolhida['qualificador']) || 'exata',
      ano: evento.ano_inicio,
      dia: evento.dia_inicio ?? null,
      mes: evento.mes_inicio ?? null,
    };
  }
  if (evento.data_texto) {
    return {
      ...DATA_VAZIA,
      qualificador: 'livre',
      texto_livre: evento.data_texto,
    };
  }
  return { ...DATA_VAZIA, qualificador: 'exata' };
}

export function ModalEditarFatoVital({
  aberto,
  aoFechar,
  pessoaId,
  tipoEvento,
  rotuloEvento,
  eventoExistente,
  aoSalvarSucesso,
}: ModalEditarFatoVitalProps) {
  const queryClient = useQueryClient();
  const [dataEscolhida, setDataEscolhida] = useState<DataEscolhida>(() =>
    eventoParaDataEscolhida(eventoExistente)
  );
  const [local, setLocal] = useState<Place | null>(null);
  const [rotuloHistorico, setRotuloHistorico] = useState(
    eventoExistente?.rotulo_historico_livre ?? ''
  );
  const [nota, setNota] = useState(eventoExistente?.nota ?? '');
  const [salvando, setSalvando] = useState(false);
  const [erro, setErro] = useState<string | null>(null);

  // Inicializa quando abre ou evento muda
  useEffect(() => {
    if (aberto) {
      setDataEscolhida(eventoParaDataEscolhida(eventoExistente));
      setRotuloHistorico(eventoExistente?.rotulo_historico_livre ?? '');
      setNota(eventoExistente?.nota ?? '');
      setErro(null);

      // Se há local_id, busca o objeto Place completo
      if (eventoExistente?.local_id) {
        obterLocal(eventoExistente.local_id)
          .then((l) => setLocal(l))
          .catch(() => setLocal(null));
      } else {
        setLocal(null);
      }
    }
  }, [aberto, eventoExistente]);

  if (!aberto) return null;

  const Icone =
    tipoEvento === 'nascimento'
      ? Baby
      : tipoEvento === 'falecimento'
      ? Cross
      : tipoEvento === 'casamento'
      ? Heart
      : tipoEvento === 'batismo'
      ? Compass
      : Calendar;

  const handleSalvar = async (e: React.FormEvent) => {
    e.preventDefault();
    setSalvando(true);
    setErro(null);

    try {
      const textoData = previaDoTexto(dataEscolhida);

      if (eventoExistente?.id) {
        // Atualiza evento existente
        await atualizarEvento({
          ...eventoExistente,
          data_texto: textoData || null,
          local_id: local?.id ?? null,
          rotulo_historico_livre: rotuloHistorico.trim() || null,
          nota: nota.trim() || null,
        });
      } else {
        // Cria novo evento
        await criarEvento({
          pessoa_id: pessoaId,
          tipo_evento: tipoEvento,
          data: dataEscolhida,
          local_id: local?.id ?? null,
          rotulo_historico_livre: rotuloHistorico.trim() || null,
          nota: nota.trim() || null,
        });
      }

      // Se for registro de nascimento no Brasil e a pessoa ainda não tiver nacionalidade BR registrada,
      // associa automaticamente a nacionalidade brasileira
      if (tipoEvento === 'nascimento' && local?.pais_id === 'br') {
        try {
          const nacs = await listarNacionalidades(pessoaId);
          if (!nacs.some((n) => n.pais_id === 'br')) {
            await adicionarNacionalidade(pessoaId, 'br');
          }
        } catch {
          // Associação secundária tolerante a falhas
        }
      }

      // Invalida caches pertinentes
      queryClient.invalidateQueries({ queryKey: ['eventos', pessoaId] });
      queryClient.invalidateQueries({ queryKey: ['pessoa', pessoaId] });
      queryClient.invalidateQueries({ queryKey: ['nacionalidades', pessoaId] });
      queryClient.invalidateQueries({ queryKey: ['arvore'] });

      aoSalvarSucesso?.();
      aoFechar();
    } catch (err) {
      setErro(err instanceof Error ? err.message : String(err));
    } finally {
      setSalvando(false);
    }
  };

  return (
    <div className="fixed inset-0 z-[85] flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs">
      <div className="absolute inset-0" onClick={aoFechar} aria-hidden />
      <div className="relative w-full max-w-lg bg-card rounded-raio border border-borda shadow-sombra overflow-hidden flex flex-col max-h-[90vh]">
        {/* Cabeçalho */}
        <div className="flex items-center justify-between px-5 py-3.5 border-b border-borda bg-card2 flex-none">
          <div className="flex items-center gap-2">
            <Icone className="w-4 h-4 text-acento" />
            <h3 className="font-tit font-bold text-base text-tinta m-0">
              {eventoExistente ? `Editar ${rotuloEvento}` : `Registrar ${rotuloEvento}`}
            </h3>
          </div>
          <button
            type="button"
            onClick={aoFechar}
            className="p-1 rounded-raio-s text-tinta3 hover:text-tinta hover:bg-sup transition-colors cursor-pointer border-none bg-transparent"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Formulário */}
        <form onSubmit={handleSalvar} className="p-5 flex flex-col gap-4 overflow-y-auto min-h-0">
          {erro && (
            <p
              role="alert"
              className="text-xs text-fem m-0 p-2.5 rounded-raio-s bg-fem/10 border border-fem/20"
            >
              {erro}
            </p>
          )}

          {/* Data */}
          <div className="p-3 bg-sup/40 rounded-raio-s border border-borda flex flex-col gap-2">
            <CampoDeData
              rotulo={`Data do ${rotuloEvento}`}
              valor={dataEscolhida}
              aoMudar={setDataEscolhida}
              ajuda="Ano sozinho basta; dia e mês são opcionais."
            />
          </div>

          {/* Localidade / Cidade (IBGE para Brasil) */}
          <div className="p-3 bg-sup/40 rounded-raio-s border border-borda flex flex-col gap-2">
            <SeletorDeLocal
              local={local}
              onEscolher={setLocal}
              rotuloHistorico={rotuloHistorico}
              onMudarRotulo={setRotuloHistorico}
            />
            {local?.codigo_ibge && (
              <p className="text-[11px] text-emerald-700 dark:text-emerald-300 font-medium m-0 flex items-center gap-1">
                <Check className="w-3.5 h-3.5" />
                Município oficial do IBGE ({local.nome} - {local.uf}) vinculado com sucesso.
              </p>
            )}
          </div>

          {/* Nota */}
          <label className="flex flex-col gap-1">
            <span className="text-xs font-semibold text-tinta">Observação / Nota</span>
            <input
              type="text"
              value={nota}
              onChange={(e) => setNota(e.target.value)}
              placeholder="Ex: Maternidade, paróquia, certidão de registro nº..."
              className="text-sm px-3 py-2 rounded-raio-s border border-borda bg-card text-tinta focus:outline-none focus:border-acento"
            />
          </label>

          {/* Rodapé */}
          <div className="flex justify-end gap-2.5 pt-3 border-t border-borda/40">
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={aoFechar}
              disabled={salvando}
            >
              Cancelar
            </Button>
            <Button type="submit" size="sm" disabled={salvando}>
              {salvando ? 'Salvando…' : 'Salvar Alterações'}
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}
