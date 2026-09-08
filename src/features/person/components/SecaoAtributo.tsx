/**
 * Casca das seis listas de atributos de vida (seção 2.5).
 *
 * Todas se comportam igual — listar, remover item, e um formulário curto para
 * acrescentar — então a repetição fica aqui uma vez só. O que muda entre elas
 * são os campos do formulário, que entram como `children`.
 */

import { useState, type ReactNode } from 'react';
import { Plus, X } from 'lucide-react';

export interface ItemDeLista {
  id: string;
  /** Linha principal: a denominação, a ocupação, o idioma. */
  principal: string;
  /** Linha de apoio: período, instituição, empregador. Opcional. */
  secundario?: string | null;
}

interface SecaoAtributoProps {
  titulo: string;
  icone?: ReactNode;
  /** Frase curta mostrada quando a lista está vazia. */
  vazio: string;
  itens: ItemDeLista[];
  carregando?: boolean;
  erro?: string | null;
  onRemover: (id: string) => void;
  removendo?: boolean;
  /** Campos do formulário de inclusão. */
  children: ReactNode;
  /** Chamado ao confirmar; devolver `false` mantém o formulário aberto. */
  onAdicionar: () => void;
  adicionando?: boolean;
  /** Desliga o botão de confirmar enquanto o formulário estiver incompleto. */
  podeAdicionar?: boolean;
}

export function SecaoAtributo({
  titulo,
  icone,
  vazio,
  itens,
  carregando,
  erro,
  onRemover,
  removendo,
  children,
  onAdicionar,
  adicionando,
  podeAdicionar = true,
}: SecaoAtributoProps) {
  const [formularioAberto, setFormularioAberto] = useState(false);

  return (
    <section className="flex flex-col gap-2.5 p-3.5 rounded-raio bg-card border border-borda shadow-2xs">
      <div className="flex items-center justify-between gap-2 flex-wrap">
        <div className="flex items-center gap-2">
          {icone && <span className="text-acento">{icone}</span>}
          <h3 className="font-tit font-bold text-sm text-tinta m-0 flex items-center gap-2">
            <span>{titulo}</span>
            {itens.length > 0 && (
              <span className="text-[10.5px] font-num font-semibold px-1.5 py-0.5 rounded-full bg-acento/10 text-acento border border-acento/20">
                {itens.length}
              </span>
            )}
          </h3>
        </div>
        <button
          type="button"
          onClick={() => setFormularioAberto((a) => !a)}
          className="text-xs font-semibold px-2.5 py-1 rounded-raio-s bg-acento/10 hover:bg-acento/20 text-acento border border-acento/30 transition-colors flex items-center gap-1 cursor-pointer shadow-2xs"
        >
          <Plus className="w-3 h-3" />
          {formularioAberto ? 'Fechar' : 'Adicionar'}
        </button>
      </div>

      {erro && (
        <p role="alert" className="text-xs text-fem m-0 p-2 rounded-raio-s bg-fem/10 border border-fem/20">
          {erro}
        </p>
      )}

      {carregando ? (
        <p className="text-xs text-tinta3 m-0 py-2">Carregando…</p>
      ) : itens.length === 0 ? (
        <div className="py-2.5 px-3 rounded-raio-s bg-sup/40 border border-dashed border-borda text-center">
          <p className="text-xs text-tinta3 italic m-0">{vazio}</p>
        </div>
      ) : (
        <ul className="list-none m-0 p-0 flex flex-col gap-1.5">
          {itens.map((item) => (
            <li
              key={item.id}
              className="flex items-start gap-2 px-3 py-2 rounded-raio-s bg-sup/60 border border-borda hover:border-borda2 transition-colors"
            >
              <div className="flex-1 min-w-0">
                <span className="block text-sm font-medium text-tinta truncate">{item.principal}</span>
                {item.secundario && (
                  <span className="block font-num text-[11px] text-tinta3 truncate mt-0.5">
                    {item.secundario}
                  </span>
                )}
              </div>
              <button
                type="button"
                onClick={() => onRemover(item.id)}
                disabled={removendo}
                aria-label={`Remover ${item.principal}`}
                className="text-tinta3 hover:text-fem transition-colors flex-none p-1 bg-transparent hover:bg-fem/10 rounded border-none cursor-pointer disabled:opacity-40"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </li>
          ))}
        </ul>
      )}

      {formularioAberto && (
        <form
          className="flex flex-col gap-2.5 p-3 rounded-raio-s border border-acento/30 bg-sup/80 mt-1"
          onSubmit={(e) => {
            e.preventDefault();
            onAdicionar();
          }}
        >
          {children}
          <div className="flex justify-end gap-2 pt-1 border-t border-borda/40">
            <button
              type="button"
              onClick={() => setFormularioAberto(false)}
              className="text-xs text-tinta2 hover:text-tinta bg-transparent border border-borda hover:bg-card rounded-raio-s cursor-pointer px-2.5 py-1 transition-colors"
            >
              Cancelar
            </button>
            <button
              type="submit"
              disabled={adicionando || !podeAdicionar}
              className="text-xs font-semibold px-3 py-1 rounded-raio-s bg-acento text-acento-tinta border-none cursor-pointer disabled:opacity-50 shadow-2xs hover:opacity-90 transition-opacity"
            >
              {adicionando ? 'Salvando…' : 'Salvar'}
            </button>
          </div>
        </form>
      )}
    </section>
  );
}

/** Campo de texto compacto, do tamanho certo para os formulários da ficha. */
export function CampoCurto({
  rotulo,
  valor,
  aoMudar,
  placeholder,
  sugestoes,
  idSugestoes,
}: {
  rotulo: string;
  valor: string;
  aoMudar: (v: string) => void;
  placeholder?: string;
  /** Vira um <datalist>: sugere sem impedir texto livre. */
  sugestoes?: readonly string[];
  idSugestoes?: string;
}) {
  return (
    <label className="flex flex-col gap-1">
      <span className="text-[11px] font-medium text-tinta2">{rotulo}</span>
      <input
        type="text"
        value={valor}
        onChange={(e) => aoMudar(e.target.value)}
        placeholder={placeholder}
        list={sugestoes ? idSugestoes : undefined}
        className="text-sm px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta w-full focus:outline-none focus:border-acento"
      />
      {sugestoes && (
        <datalist id={idSugestoes}>
          {sugestoes.map((s) => (
            <option key={s} value={s} />
          ))}
        </datalist>
      )}
    </label>
  );
}
