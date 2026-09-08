/**
 * Os nomes de uma pessoa (fatia 02, redesenhada).
 *
 * A primeira versão expunha o modelo de dados: uma lista genérica com nove
 * tipos e quatro campos de nome (prefixo, nome, sobrenome, sufixo). Quem usou
 * não achou onde escrever o nome público — e tinha razão, porque a tela pedia
 * que ele traduzisse a própria intenção para um vocabulário de tabela.
 *
 * Agora a tela segue o modelo mental, que tem três degraus:
 *
 *   1. **Nome público** — como a pessoa é conhecida. É o do card, editado na
 *      Identidade. Aqui só se mostra, para dar contexto.
 *   2. **Nome completo** — o de registro, que costuma ser bem maior.
 *   3. **Mudanças de nome** — quando a pessoa passou a se chamar outra coisa,
 *      e a partir de quando.
 *
 * Prefixo e sufixo sumiram da interface. "D. João VI" se escreve inteiro no
 * nome público; separar em três caixas era pedir ao usuário que fizesse o
 * trabalho do banco. As colunas continuam no schema para a exportação GEDCOM.
 */

import { useState } from 'react';
import { ArrowRight, Pencil, Plus, X, User, FileText, History } from 'lucide-react';
import { Input } from '../../../components/ui/Input';
import { Button } from '../../../components/ui/Button';
import { MOTIVOS_DE_NOME, rotuloDoTipoDeNome } from '../taxonomias';
import { ErroDoAcervo } from '../../../lib/api';
import type { NameType, PersonName } from '../../../types';

interface SecaoNomesProps {
  pessoaId: string;
  /** O nome de exibição atual — o que aparece no card. */
  nomePublico: string;
  nomes: PersonName[];
  carregando?: boolean;
  erro?: unknown;
  adicionando?: boolean;
  removendo?: boolean;
  onAdicionar: (novo: {
    tipo: NameType;
    nome: string;
    sobrenome: string | null;
    periodo: string | null;
  }) => void;
  onRemover: (id: string) => void;
  onUsarNaArvore: (id: string) => void;
}

function mensagemDeErro(erro: unknown): string | null {
  if (!erro) return null;
  if (erro instanceof ErroDoAcervo) return erro.message;
  if (erro instanceof Error) return erro.message;
  return String(erro);
}

function nomeInteiro(n: PersonName): string {
  return [n.prefixo, n.nome, n.sobrenome, n.sufixo].filter(Boolean).join(' ');
}

export function SecaoNomes({
  pessoaId: _pessoaId,
  nomePublico,
  nomes,
  carregando,
  erro,
  adicionando,
  removendo,
  onAdicionar,
  onRemover,
  onUsarNaArvore,
}: SecaoNomesProps) {
  // O nome de registro é único por pessoa; as mudanças são a lista.
  const nomeCompleto = nomes.find((n) => n.tipo === 'nascimento') ?? null;
  const mudancas = nomes.filter((n) => n.tipo !== 'nascimento');

  const [editandoCompleto, setEditandoCompleto] = useState(false);
  const [rascunhoCompleto, setRascunhoCompleto] = useState({ nome: '', sobrenome: '' });

  const [formMudanca, setFormMudanca] = useState(false);
  const [novaMudanca, setNovaMudanca] = useState({
    motivo: 'religioso' as NameType,
    nome: '',
    periodo: '',
  });

  const mensagem = mensagemDeErro(erro);
  const motivoEscolhido = MOTIVOS_DE_NOME.find((m) => m.valor === novaMudanca.motivo);

  return (
    <section className="md:col-span-2 flex flex-col gap-3">
      <div className="flex items-center justify-between pb-1 border-b border-borda/60">
        <h3 className="font-tit font-bold text-xs uppercase tracking-wider text-tinta2 flex items-center gap-1.5 m-0">
          <User className="w-3.5 h-3.5 text-acento" />
          <span>Variações e Registros do Nome</span>
        </h3>
      </div>

      {mensagem && (
        <p role="alert" className="text-xs text-fem m-0 bg-fem/10 border border-fem/20 rounded-raio-s p-2">
          {mensagem}
        </p>
      )}

      {/* -------- 1. Nome usual (exibição no card) -------- */}
      <div className="flex flex-col gap-1.5 p-3.5 rounded-raio bg-card border border-borda shadow-2xs">
        <div className="flex items-center justify-between gap-2">
          <div>
            <h4 className="text-xs font-bold text-tinta m-0">
              Nome Usual (Exibição)
            </h4>
            <span className="text-[11px] text-tinta3 font-normal">
              Como a pessoa é identificada na árvore genealógica e nas buscas.
            </span>
          </div>
        </div>
        <div className="mt-1 px-3 py-2 rounded-raio-s bg-sup/50 border border-borda/80">
          <span className="text-base text-tinta font-tit font-bold leading-tight">
            {nomePublico || <span className="text-tinta3 italic font-normal">Sem nome informado</span>}
          </span>
        </div>
      </div>

      {/* -------- 2. Nome completo de registro -------- */}
      <div className="flex flex-col gap-2 p-3.5 rounded-raio bg-card border border-borda shadow-2xs">
        <div className="flex items-center justify-between gap-2">
          <div>
            <h4 className="text-xs font-bold text-tinta flex items-center gap-1.5 m-0">
              <FileText className="w-3.5 h-3.5 text-acento" />
              <span>Nome Completo de Registro (Certidão)</span>
            </h4>
            <span className="text-[11px] text-tinta3 font-normal">
              Nome oficial que consta na certidão de nascimento ou batismo.
            </span>
          </div>
          {!editandoCompleto && (
            <button
              type="button"
              onClick={() => {
                setRascunhoCompleto({
                  nome: nomeCompleto?.nome ?? '',
                  sobrenome: nomeCompleto?.sobrenome ?? '',
                });
                setEditandoCompleto(true);
              }}
              className="px-2.5 py-1 text-xs font-semibold rounded bg-acento/10 hover:bg-acento/20 text-acento border border-acento/30 transition-colors flex items-center gap-1 cursor-pointer flex-none"
            >
              {nomeCompleto ? <Pencil className="w-3 h-3" /> : <Plus className="w-3 h-3" />}
              <span>{nomeCompleto ? 'Alterar' : 'Registrar'}</span>
            </button>
          )}
        </div>

        {editandoCompleto ? (
          <form
            className="flex flex-col gap-2.5 mt-1 p-3 rounded-raio-s bg-sup/40 border border-borda2"
            onSubmit={(e) => {
              e.preventDefault();
              if (!rascunhoCompleto.nome.trim()) return;
              if (nomeCompleto) onRemover(nomeCompleto.id);
              onAdicionar({
                tipo: 'nascimento',
                nome: rascunhoCompleto.nome.trim(),
                sobrenome: rascunhoCompleto.sobrenome.trim() || null,
                periodo: null,
              });
              setEditandoCompleto(false);
            }}
          >
            <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
              <Input
                label="Preenomes"
                value={rascunhoCompleto.nome}
                onChange={(e) =>
                  setRascunhoCompleto({ ...rascunhoCompleto, nome: e.target.value })
                }
                placeholder="Ex: Joaquim Maria"
                required
                autoFocus
              />
              <Input
                label="Sobrenome"
                value={rascunhoCompleto.sobrenome}
                onChange={(e) =>
                  setRascunhoCompleto({ ...rascunhoCompleto, sobrenome: e.target.value })
                }
                placeholder="Ex: Ferreira dos Santos"
              />
            </div>
            <div className="flex justify-end gap-2 pt-1">
              <Button
                type="button"
                variant="ghost"
                size="sm"
                onClick={() => setEditandoCompleto(false)}
              >
                Cancelar
              </Button>
              <Button type="submit" size="sm" disabled={adicionando}>
                Salvar Nome de Registro
              </Button>
            </div>
          </form>
        ) : nomeCompleto ? (
          <div className="flex items-center justify-between gap-2 px-3 py-2 rounded-raio-s bg-sup/50 border border-borda">
            <span className="text-sm font-semibold text-tinta flex-1 leading-snug">
              {nomeInteiro(nomeCompleto)}
            </span>
            <button
              type="button"
              onClick={() => onRemover(nomeCompleto.id)}
              disabled={removendo}
              aria-label="Remover o nome de registro"
              className="text-tinta3 hover:text-fem p-1 rounded hover:bg-card transition-colors cursor-pointer flex-none"
              title="Remover nome de registro"
            >
              <X className="w-4 h-4" />
            </button>
          </div>
        ) : (
          <div className="py-2.5 px-3 rounded-raio-s bg-sup/30 border border-dashed border-borda/70 text-xs text-tinta3 italic text-center">
            {carregando ? 'Carregando…' : 'Nenhum nome de certidão registrado ainda.'}
          </div>
        )}
      </div>

      {/* -------- 3. Nomes Alternativos e Históricos -------- */}
      <div className="flex flex-col gap-2 p-3.5 rounded-raio bg-card border border-borda shadow-2xs">
        <div className="flex items-center justify-between gap-2">
          <div>
            <h4 className="text-xs font-bold text-tinta flex items-center gap-1.5 m-0">
              <History className="w-3.5 h-3.5 text-acento" />
              <span>Nomes Alternativos e Históricos</span>
            </h4>
            <span className="text-[11px] text-tinta3 font-normal">
              Nomes adotados por casamento, religiosos, artísticos ou variações ao longo da vida.
            </span>
          </div>
          <button
            type="button"
            onClick={() => setFormMudanca((a) => !a)}
            className="px-2.5 py-1 text-xs font-semibold rounded bg-acento/10 hover:bg-acento/20 text-acento border border-acento/30 transition-colors flex items-center gap-1 cursor-pointer flex-none"
          >
            <Plus className="w-3 h-3" />
            <span>{formMudanca ? 'Fechar' : 'Adicionar Nome'}</span>
          </button>
        </div>

        {mudancas.length === 0 && !formMudanca && (
          <div className="py-2.5 px-3 rounded-raio-s bg-sup/30 border border-dashed border-borda/70 text-xs text-tinta3 italic text-center">
            Nenhuma alteração ou variação de nome registrada.
          </div>
        )}

        {mudancas.length > 0 && (
          <ul className="list-none m-0 p-0 flex flex-col gap-1.5">
            {mudancas.map((n) => (
              <li
                key={n.id}
                className="flex items-center justify-between gap-3 px-3 py-2 rounded-raio-s bg-sup/50 border border-borda hover:border-acento/40 transition-colors"
              >
                <div className="flex-1 min-w-0">
                  <span className="block text-sm font-semibold text-tinta truncate">{nomeInteiro(n)}</span>
                  <span className="block font-num text-[11px] text-tinta3">
                    {rotuloDoTipoDeNome(n.tipo)}
                    {n.periodo ? ` · ${n.periodo}` : ''}
                  </span>
                </div>

                <div className="flex items-center gap-2 flex-none">
                  <button
                    type="button"
                    onClick={() => onUsarNaArvore(n.id)}
                    title="Usar este como nome público (o do card)"
                    className="px-2 py-0.5 text-xs font-medium text-tinta3 hover:text-acento hover:bg-card rounded border border-transparent hover:border-borda flex items-center gap-1 transition-all cursor-pointer"
                  >
                    <ArrowRight className="w-3 h-3 text-acento" />
                    <span>Usar no card</span>
                  </button>

                  <button
                    type="button"
                    onClick={() => onRemover(n.id)}
                    disabled={removendo}
                    aria-label={`Remover ${nomeInteiro(n)}`}
                    className="text-tinta3 hover:text-fem p-1 rounded hover:bg-card transition-colors cursor-pointer"
                    title="Remover nome"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>
              </li>
            ))}
          </ul>
        )}

        {formMudanca && (
          <form
            className="flex flex-col gap-2 pt-2 border-t border-borda"
            onSubmit={(e) => {
              e.preventDefault();
              if (!novaMudanca.nome.trim()) return;
              onAdicionar({
                tipo: novaMudanca.motivo,
                nome: novaMudanca.nome.trim(),
                sobrenome: null,
                periodo: novaMudanca.periodo.trim() || null,
              });
              setNovaMudanca({ motivo: 'religioso', nome: '', periodo: '' });
              setFormMudanca(false);
            }}
          >
            <label className="flex flex-col gap-1">
              <span className="text-[11px] text-tinta2">Por que mudou?</span>
              <select
                value={novaMudanca.motivo}
                onChange={(e) =>
                  setNovaMudanca({ ...novaMudanca, motivo: e.target.value as NameType })
                }
                className="text-sm px-2 py-1.5 rounded-raio-s border border-borda2 bg-bg text-tinta"
              >
                {MOTIVOS_DE_NOME.map((m) => (
                  <option key={m.valor} value={m.valor}>
                    {m.rotulo}
                  </option>
                ))}
              </select>
              {motivoEscolhido?.exemplo && (
                <span className="text-[11px] text-tinta3 leading-relaxed">
                  {motivoEscolhido.exemplo}
                </span>
              )}
            </label>

            <Input
              label="Passou a se chamar"
              value={novaMudanca.nome}
              onChange={(e) => setNovaMudanca({ ...novaMudanca, nome: e.target.value })}
              placeholder="escreva o nome inteiro, como se usa"
            />

            <Input
              label="A partir de quando (opcional)"
              value={novaMudanca.periodo}
              onChange={(e) => setNovaMudanca({ ...novaMudanca, periodo: e.target.value })}
              placeholder="2013, ao casar, quando chegou ao Brasil…"
            />

            <p className="text-[11px] text-tinta3 m-0 leading-relaxed">
              Guardar quando a mudança aconteceu importa: ao falar de uma época anterior, é o
              nome antigo que se usa.
            </p>

            <div className="flex justify-end gap-2">
              <Button
                type="button"
                variant="ghost"
                size="sm"
                onClick={() => setFormMudanca(false)}
              >
                Cancelar
              </Button>
              <Button type="submit" size="sm" disabled={adicionando || !novaMudanca.nome.trim()}>
                Adicionar
              </Button>
            </div>
          </form>
        )}
      </div>
    </section>
  );
}
