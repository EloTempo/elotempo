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
    <section className="flex flex-col gap-2">
      <div className="flex items-center justify-between gap-2">
        <h3 className="font-num text-[10.5px] uppercase tracking-wider text-tinta3 m-0">
          {titulo}
        </h3>
        <button
          type="button"
          onClick={() => setFormularioAberto((a) => !a)}
          className="text-[11px] text-acento hover:text-tinta transition-colors flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
        >
          <Plus className="w-3 h-3" />
          {formularioAberto ? 'Fechar' : 'Adicionar'}
        </button>
      </div>

      {erro && (
        <p role="alert" className="text-xs text-fem m-0">
          {erro}
        </p>
      )}

      {carregando ? (
        <p className="text-xs text-tinta3 m-0">Carregando…</p>
      ) : itens.length === 0 ? (
        <p className="text-xs text-tinta3 m-0">{vazio}</p>
      ) : (
        <ul className="list-none m-0 p-0 flex flex-col gap-1">
          {itens.map((item) => (
            <li
              key={item.id}
              className="flex items-start gap-2 px-2.5 py-1.5 rounded-raio-s bg-card border border-borda"
            >
              <div className="flex-1 min-w-0">
                <span className="block text-sm text-tinta truncate">{item.principal}</span>
                {item.secundario && (
                  <span className="block font-num text-[11px] text-tinta3 truncate">
                    {item.secundario}
                  </span>
                )}
              </div>
              <button
                type="button"
                onClick={() => onRemover(item.id)}
                disabled={removendo}
                aria-label={`Remover ${item.principal}`}
                className="text-tinta3 hover:text-fem transition-colors flex-none p-0.5 bg-transparent border-none cursor-pointer disabled:opacity-40"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </li>
          ))}
        </ul>
      )}

      {formularioAberto && (
        <form
          className="flex flex-col gap-2 p-2.5 rounded-raio-s border border-borda2 bg-card2"
          onSubmit={(e) => {
            e.preventDefault();
            onAdicionar();
          }}
        >
          {children}
          <div className="flex justify-end gap-2">
            <button
              type="button"
              onClick={() => setFormularioAberto(false)}
              className="text-xs text-tinta2 hover:text-tinta bg-transparent border-none cursor-pointer px-2 py-1"
            >
              Cancelar
            </button>
            <button
              type="submit"
              disabled={adicionando || !podeAdicionar}
              className="text-xs font-semibold px-3 py-1.5 rounded-raio-s bg-acento text-acento-tinta border-none cursor-pointer disabled:opacity-50"
            >
              {adicionando ? 'Salvando…' : 'Adicionar'}
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
      <span className="text-[11px] text-tinta2">{rotulo}</span>
      <input
        type="text"
        value={valor}
        onChange={(e) => aoMudar(e.target.value)}
        placeholder={placeholder}
        list={sugestoes ? idSugestoes : undefined}
        className="text-sm px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta w-full focus:outline-none focus:border-acento"
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
