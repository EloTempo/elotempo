/**
 * Escolha de data por listas suspensas.
 *
 * Antes era um campo de texto livre que o programa tentava interpretar. Isso
 * funcionava para ordenar, mas perdia dia e mês: quem escrevia "12/03/1945"
 * tinha o texto guardado, e estruturalmente o programa só sabia **1945** — o
 * que apareceu como perda de fidelidade ao planejar a exportação GEDCOM.
 *
 * Com listas, o dado chega estruturado da origem e o palpite deixa de existir.
 *
 * O que **não** muda: a regra da seção 2.5 continua valendo — a data nunca é
 * obrigatória, e há sempre a saída "só sei descrever" para o que a estrutura
 * não comporta ("na época da guerra").
 */

import { MESES, type DataEscolhida } from '../../types';

interface CampoDeDataProps {
  rotulo: string;
  valor: DataEscolhida;
  aoMudar: (v: DataEscolhida) => void;
  /** Frase curta abaixo do campo. */
  ajuda?: string;
}

const PRECISOES = [
  { valor: '', rotulo: 'Sem data' },
  { valor: 'exata', rotulo: 'Data exata' },
  { valor: 'cerca_de', rotulo: 'Cerca de' },
  { valor: 'antes_de', rotulo: 'Antes de' },
  { valor: 'apos', rotulo: 'Depois de' },
  { valor: 'intervalo', rotulo: 'Entre dois anos' },
  { valor: 'livre', rotulo: 'Só sei descrever' },
] as const;

const DIAS = Array.from({ length: 31 }, (_, i) => i + 1);

/** Como o texto ficará guardado — o mesmo que o Rust compõe ao salvar. */
export function previaDoTexto(d: DataEscolhida): string {
  if (d.qualificador === 'livre') return d.texto_livre?.trim() ?? '';
  if (!d.ano) return '';

  const formataAno = (a: number) => (a < 0 ? `${Math.abs(a)} a.C.` : String(a));

  const nucleo =
    d.dia && d.mes
      ? `${d.dia} de ${MESES[d.mes - 1]} de ${formataAno(d.ano)}`
      : d.mes
        ? `${MESES[d.mes - 1]} de ${formataAno(d.ano)}`
        : formataAno(d.ano);

  switch (d.qualificador) {
    case 'cerca_de':
      return `cerca de ${nucleo}`;
    case 'antes_de':
      return `antes de ${nucleo}`;
    case 'apos':
      return `após ${nucleo}`;
    case 'intervalo': {
      const fimFormatado = d.ano_fim != null ? formataAno(d.ano_fim) : '';
      return fimFormatado ? `entre ${formataAno(d.ano)} e ${fimFormatado}` : nucleo;
    }
    default:
      return nucleo;
  }
}

const SELECT =
  'text-sm px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta focus:outline-none focus:border-acento';

export function CampoDeData({ rotulo, valor, aoMudar, ajuda }: CampoDeDataProps) {
  const q = valor.qualificador ?? '';
  const mudar = (parcial: Partial<DataEscolhida>) => aoMudar({ ...valor, ...parcial });

  // Dia e mês só fazem sentido numa data exata: "cerca de 12 de março de 1890"
  // afirmaria uma precisão que o "cerca de" nega.
  const mostraDiaEMes = q === 'exata';
  const mostraAno = q !== '' && q !== 'livre';
  const previa = previaDoTexto(valor);

  return (
    <div className="flex flex-col gap-1.5">
      <span className="text-[11px] text-tinta2">{rotulo}</span>

      <select
        aria-label={`${rotulo} — precisão`}
        value={q}
        onChange={(e) => {
          const novo = e.target.value as DataEscolhida['qualificador'] | '';
          // Trocar de precisão limpa o que deixou de fazer sentido, para não
          // guardar um dia que a nova escolha não mostra.
          aoMudar({
            qualificador: novo === '' ? null : novo,
            dia: novo === 'exata' ? valor.dia : null,
            mes: novo === 'exata' ? valor.mes : null,
            ano: novo === '' || novo === 'livre' ? null : valor.ano,
            ano_fim: novo === 'intervalo' ? valor.ano_fim : null,
            texto_livre: novo === 'livre' ? valor.texto_livre : null,
          });
        }}
        className={SELECT}
      >
        {PRECISOES.map((p) => (
          <option key={p.valor} value={p.valor}>
            {p.rotulo}
          </option>
        ))}
      </select>

      {mostraAno && (
        <div className="flex gap-2">
          {mostraDiaEMes && (
            <>
              <select
                aria-label="Dia"
                value={valor.dia ?? ''}
                onChange={(e) => mudar({ dia: e.target.value ? Number(e.target.value) : null })}
                className={`${SELECT} w-[72px]`}
              >
                <option value="">dia</option>
                {DIAS.map((d) => (
                  <option key={d} value={d}>
                    {d}
                  </option>
                ))}
              </select>

              <select
                aria-label="Mês"
                value={valor.mes ?? ''}
                onChange={(e) => mudar({ mes: e.target.value ? Number(e.target.value) : null })}
                className={`${SELECT} flex-1`}
              >
                <option value="">mês</option>
                {MESES.map((m, i) => (
                  <option key={m} value={i + 1}>
                    {m}
                  </option>
                ))}
              </select>
            </>
          )}

          <div className="relative inline-flex items-center">
            <input
              type="number"
              aria-label={q === 'intervalo' ? 'Ano inicial' : 'Ano'}
              value={valor.ano ?? ''}
              onChange={(e) => mudar({ ano: e.target.value ? Number(e.target.value) : null })}
              placeholder="ano"
              max={2200}
              className={`${SELECT} w-[105px] ${valor.ano != null && valor.ano !== 0 ? 'pr-9 font-num' : 'font-num'}`}
            />
            {valor.ano != null && valor.ano !== 0 && (
              <span
                className={`absolute right-2 font-num text-[10px] font-bold pointer-events-none px-1 rounded ${
                  valor.ano < 0 ? 'text-acento bg-sup' : 'text-tinta3'
                }`}
                title={valor.ano < 0 ? 'Antes de Cristo (a.C.)' : 'Depois de Cristo (d.C.)'}
              >
                {valor.ano < 0 ? 'a.C.' : 'd.C.'}
              </span>
            )}
          </div>

          {q === 'intervalo' && (
            <>
              <span className="self-center text-xs text-tinta3">e</span>
              <div className="relative inline-flex items-center">
                <input
                  type="number"
                  aria-label="Ano final"
                  value={valor.ano_fim ?? ''}
                  onChange={(e) =>
                    mudar({ ano_fim: e.target.value ? Number(e.target.value) : null })
                  }
                  placeholder="ano"
                  max={2200}
                  className={`${SELECT} w-[105px] ${valor.ano_fim != null && valor.ano_fim !== 0 ? 'pr-9 font-num' : 'font-num'}`}
                />
                {valor.ano_fim != null && valor.ano_fim !== 0 && (
                  <span
                    className={`absolute right-2 font-num text-[10px] font-bold pointer-events-none px-1 rounded ${
                      valor.ano_fim < 0 ? 'text-acento bg-sup' : 'text-tinta3'
                    }`}
                    title={valor.ano_fim < 0 ? 'Antes de Cristo (a.C.)' : 'Depois de Cristo (d.C.)'}
                  >
                    {valor.ano_fim < 0 ? 'a.C.' : 'd.C.'}
                  </span>
                )}
              </div>
            </>
          )}
        </div>
      )}

      {q === 'livre' && (
        <input
          type="text"
          aria-label="Descrição da data"
          value={valor.texto_livre ?? ''}
          onChange={(e) => mudar({ texto_livre: e.target.value })}
          placeholder="na época da guerra, quando chegou ao Brasil…"
          className={SELECT}
        />
      )}

      {/* Mostra o que será guardado. Sem isso, o usuário escolhe em três
          listas sem saber o que sai do outro lado. */}
      {previa && (
        <span className="text-[11px] text-tinta3">
          Ficará registrado como: <span className="text-tinta2">{previa}</span>
        </span>
      )}

      {ajuda && !previa && (
        <span className="text-[11px] text-tinta3 leading-relaxed">{ajuda}</span>
      )}
    </div>
  );
}
