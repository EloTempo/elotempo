import { useState } from 'react';
import {
  Briefcase,
  GraduationCap,
  Globe,
  Languages,
  Church,
  Plus,
  X,
} from 'lucide-react';
import {
  profissoes,
  escolaridade,
  nacionalidades,
  idiomas,
  religioes,
  usePaises,
} from '../hooks/useFicha';
import {
  NIVEIS_ESCOLARIDADE,
  IDIOMAS,
  RELIGIOES,
} from '../taxonomias';

interface AbaTrajetoriaProps {
  pessoaId: string;
}

export function AbaTrajetoria({ pessoaId }: AbaTrajetoriaProps) {
  const { data: paises } = usePaises();

  // Profissões
  const listaProfissoes = profissoes.useLista(pessoaId);
  const addProfissao = profissoes.useAdicionar(pessoaId);
  const delProfissao = profissoes.useRemover(pessoaId);
  const [formProfAberto, setFormProfAberto] = useState(false);
  const [novaProfissao, setNovaProfissao] = useState({ ocupacao: '', empregador: '', periodo: '' });

  // Escolaridade
  const listaEscolaridade = escolaridade.useLista(pessoaId);
  const addEscolaridade = escolaridade.useAdicionar(pessoaId);
  const delEscolaridade = escolaridade.useRemover(pessoaId);
  const [formEscAberto, setFormEscAberto] = useState(false);
  const [novaEscolaridade, setNovaEscolaridade] = useState({ nivel: '', instituicao: '', periodo: '' });

  // Nacionalidades
  const listaNacionalidades = nacionalidades.useLista(pessoaId);
  const addNacionalidade = nacionalidades.useAdicionar(pessoaId);
  const delNacionalidade = nacionalidades.useRemover(pessoaId);
  const [formNacAberto, setFormNacAberto] = useState(false);
  const [novaNacionalidade, setNovaNacionalidade] = useState('');

  // Idiomas
  const listaIdiomas = idiomas.useLista(pessoaId);
  const addIdioma = idiomas.useAdicionar(pessoaId);
  const delIdioma = idiomas.useRemover(pessoaId);
  const [formIdiAberto, setFormIdiAberto] = useState(false);
  const [novoIdioma, setNovoIdioma] = useState('');

  // Religiões
  const listaReligioes = religioes.useLista(pessoaId);
  const addReligiao = religioes.useAdicionar(pessoaId);
  const delReligiao = religioes.useRemover(pessoaId);
  const [formRelAberto, setFormRelAberto] = useState(false);
  const [novaReligiao, setNovaReligiao] = useState({ denominacao: '', periodo: '' });

  const nomeDoPais = (paisId: string) => paises?.find((p) => p.id === paisId)?.nome ?? paisId;

  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">
      {/* ---------------- Painel 1: Carreira & Formação ---------------- */}
      <div className="p-4 rounded-raio bg-card border border-borda shadow-2xs flex flex-col gap-4">
        <div className="flex items-center gap-2 border-b border-borda/50 pb-2.5">
          <Briefcase className="w-4 h-4 text-acento" />
          <h3 className="font-tit font-bold text-sm text-tinta m-0">Carreira & Formação</h3>
        </div>

        {/* Seção Profissões */}
        <div className="flex flex-col gap-2">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-tinta flex items-center gap-1.5">
              <span>Profissões & Ocupações</span>
              {(listaProfissoes.data ?? []).length > 0 && (
                <span className="text-[10px] font-num px-1.5 py-0.2 rounded-full bg-acento/10 text-acento border border-acento/20">
                  {listaProfissoes.data?.length}
                </span>
              )}
            </span>
            <button
              type="button"
              onClick={() => setFormProfAberto((a) => !a)}
              className="text-xs text-acento hover:text-tinta font-medium flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
            >
              <Plus className="w-3 h-3" />
              {formProfAberto ? 'Fechar' : 'Adicionar'}
            </button>
          </div>

          {formProfAberto && (
            <form
              onSubmit={(e) => {
                e.preventDefault();
                if (!novaProfissao.ocupacao.trim()) return;
                addProfissao.mutate(
                  [
                    novaProfissao.ocupacao.trim(),
                    novaProfissao.empregador.trim() || null,
                    novaProfissao.periodo.trim() || null,
                  ],
                  {
                    onSuccess: () => {
                      setNovaProfissao({ ocupacao: '', empregador: '', periodo: '' });
                      setFormProfAberto(false);
                    },
                  },
                );
              }}
              className="p-3 rounded-raio-s bg-sup/50 border border-borda flex flex-col gap-2.5"
            >
              <input
                type="text"
                value={novaProfissao.ocupacao}
                onChange={(e) => setNovaProfissao({ ...novaProfissao, ocupacao: e.target.value })}
                placeholder="Ocupação (ex: Ferreiro, Professora, Lavrador)"
                required
                className="text-xs px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta focus:outline-none focus:border-acento"
              />
              <div className="grid grid-cols-2 gap-2">
                <input
                  type="text"
                  value={novaProfissao.empregador}
                  onChange={(e) => setNovaProfissao({ ...novaProfissao, empregador: e.target.value })}
                  placeholder="Local / Empregador"
                  className="text-xs px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta focus:outline-none focus:border-acento"
                />
                <input
                  type="text"
                  value={novaProfissao.periodo}
                  onChange={(e) => setNovaProfissao({ ...novaProfissao, periodo: e.target.value })}
                  placeholder="Período (ex: 1920–1945)"
                  className="text-xs px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta focus:outline-none focus:border-acento"
                />
              </div>
              <div className="flex justify-end gap-2">
                <button
                  type="submit"
                  disabled={addProfissao.isPending || !novaProfissao.ocupacao.trim()}
                  className="text-xs font-semibold px-2.5 py-1 rounded-raio-s bg-acento text-acento-tinta border-none cursor-pointer disabled:opacity-50"
                >
                  {addProfissao.isPending ? 'Salvando…' : 'Salvar'}
                </button>
              </div>
            </form>
          )}

          {(listaProfissoes.data ?? []).length === 0 ? (
            <span className="text-xs text-tinta3 italic py-1">Nenhuma profissão registrada.</span>
          ) : (
            <div className="flex flex-col gap-1.5">
              {(listaProfissoes.data ?? []).map((p) => (
                <div
                  key={p.id}
                  className="p-2 rounded-raio-s bg-sup/50 border border-borda flex items-center justify-between text-xs"
                >
                  <div className="min-w-0 flex-1">
                    <span className="font-semibold text-tinta block truncate">{p.ocupacao}</span>
                    {[p.empregador_local, p.periodo].filter(Boolean).length > 0 && (
                      <span className="text-[11px] text-tinta3 block truncate font-num">
                        {[p.empregador_local, p.periodo].filter(Boolean).join(' · ')}
                      </span>
                    )}
                  </div>
                  <button
                    type="button"
                    onClick={() => delProfissao.mutate(p.id)}
                    disabled={delProfissao.isPending}
                    className="p-1 text-tinta3 hover:text-fem transition-colors border-none bg-transparent cursor-pointer"
                  >
                    <X className="w-3.5 h-3.5" />
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Seção Escolaridade */}
        <div className="flex flex-col gap-2 pt-3 border-t border-borda/40">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-tinta flex items-center gap-1.5">
              <GraduationCap className="w-3.5 h-3.5 text-acento" />
              <span>Escolaridade & Formação</span>
              {(listaEscolaridade.data ?? []).length > 0 && (
                <span className="text-[10px] font-num px-1.5 py-0.2 rounded-full bg-acento/10 text-acento border border-acento/20">
                  {listaEscolaridade.data?.length}
                </span>
              )}
            </span>
            <button
              type="button"
              onClick={() => setFormEscAberto((a) => !a)}
              className="text-xs text-acento hover:text-tinta font-medium flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
            >
              <Plus className="w-3 h-3" />
              {formEscAberto ? 'Fechar' : 'Adicionar'}
            </button>
          </div>

          {formEscAberto && (
            <form
              onSubmit={(e) => {
                e.preventDefault();
                if (!novaEscolaridade.nivel.trim()) return;
                addEscolaridade.mutate(
                  [
                    novaEscolaridade.nivel.trim(),
                    novaEscolaridade.instituicao.trim() || null,
                    novaEscolaridade.periodo.trim() || null,
                  ],
                  {
                    onSuccess: () => {
                      setNovaEscolaridade({ nivel: '', instituicao: '', periodo: '' });
                      setFormEscAberto(false);
                    },
                  },
                );
              }}
              className="p-3 rounded-raio-s bg-sup/50 border border-borda flex flex-col gap-2.5"
            >
              <input
                type="text"
                value={novaEscolaridade.nivel}
                onChange={(e) => setNovaEscolaridade({ ...novaEscolaridade, nivel: e.target.value })}
                placeholder="Nível de Instrução (ex: Ensino Primário, Direito)"
                list="sugestoes-nivel-escolaridade"
                required
                className="text-xs px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta focus:outline-none focus:border-acento"
              />
              <datalist id="sugestoes-nivel-escolaridade">
                {NIVEIS_ESCOLARIDADE.map((n) => (
                  <option key={n} value={n} />
                ))}
              </datalist>

              <div className="grid grid-cols-2 gap-2">
                <input
                  type="text"
                  value={novaEscolaridade.instituicao}
                  onChange={(e) => setNovaEscolaridade({ ...novaEscolaridade, instituicao: e.target.value })}
                  placeholder="Instituição / Escola"
                  className="text-xs px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta focus:outline-none focus:border-acento"
                />
                <input
                  type="text"
                  value={novaEscolaridade.periodo}
                  onChange={(e) => setNovaEscolaridade({ ...novaEscolaridade, periodo: e.target.value })}
                  placeholder="Ano / Período"
                  className="text-xs px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta focus:outline-none focus:border-acento"
                />
              </div>

              <div className="flex justify-end gap-2">
                <button
                  type="submit"
                  disabled={addEscolaridade.isPending || !novaEscolaridade.nivel.trim()}
                  className="text-xs font-semibold px-2.5 py-1 rounded-raio-s bg-acento text-acento-tinta border-none cursor-pointer disabled:opacity-50"
                >
                  {addEscolaridade.isPending ? 'Salvando…' : 'Salvar'}
                </button>
              </div>
            </form>
          )}

          {(listaEscolaridade.data ?? []).length === 0 ? (
            <span className="text-xs text-tinta3 italic py-1">Nenhuma formação registrada.</span>
          ) : (
            <div className="flex flex-col gap-1.5">
              {(listaEscolaridade.data ?? []).map((e) => (
                <div
                  key={e.id}
                  className="p-2 rounded-raio-s bg-sup/50 border border-borda flex items-center justify-between text-xs"
                >
                  <div className="min-w-0 flex-1">
                    <span className="font-semibold text-tinta block truncate">{e.nivel}</span>
                    {[e.instituicao, e.periodo].filter(Boolean).length > 0 && (
                      <span className="text-[11px] text-tinta3 block truncate font-num">
                        {[e.instituicao, e.periodo].filter(Boolean).join(' · ')}
                      </span>
                    )}
                  </div>
                  <button
                    type="button"
                    onClick={() => delEscolaridade.mutate(e.id)}
                    disabled={delEscolaridade.isPending}
                    className="p-1 text-tinta3 hover:text-fem transition-colors border-none bg-transparent cursor-pointer"
                  >
                    <X className="w-3.5 h-3.5" />
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* ---------------- Painel 2: Origens, Cultura & Crenças ---------------- */}
      <div className="p-4 rounded-raio bg-card border border-borda shadow-2xs flex flex-col gap-4">
        <div className="flex items-center gap-2 border-b border-borda/50 pb-2.5">
          <Globe className="w-4 h-4 text-acento" />
          <h3 className="font-tit font-bold text-sm text-tinta m-0">Origens, Cultura & Crenças</h3>
        </div>

        {/* Nacionalidades */}
        <div className="flex flex-col gap-2">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-tinta flex items-center gap-1.5">
              <span>Nacionalidades & Cidadanias</span>
              {(listaNacionalidades.data ?? []).length > 0 && (
                <span className="text-[10px] font-num px-1.5 py-0.2 rounded-full bg-acento/10 text-acento border border-acento/20">
                  {listaNacionalidades.data?.length}
                </span>
              )}
            </span>
            <button
              type="button"
              onClick={() => setFormNacAberto((a) => !a)}
              className="text-xs text-acento hover:text-tinta font-medium flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
            >
              <Plus className="w-3 h-3" />
              {formNacAberto ? 'Fechar' : 'Adicionar'}
            </button>
          </div>

          {formNacAberto && (
            <form
              onSubmit={(e) => {
                e.preventDefault();
                if (!novaNacionalidade) return;
                addNacionalidade.mutate([novaNacionalidade], {
                  onSuccess: () => {
                    setNovaNacionalidade('');
                    setFormNacAberto(false);
                  },
                });
              }}
              className="p-3 rounded-raio-s bg-sup/50 border border-borda flex items-center gap-2"
            >
              <select
                value={novaNacionalidade}
                onChange={(e) => setNovaNacionalidade(e.target.value)}
                className="text-xs px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta flex-1 focus:outline-none focus:border-acento"
              >
                <option value="">Escolha um país…</option>
                {paises?.map((p) => (
                  <option key={p.id} value={p.id}>
                    {p.nome}
                  </option>
                ))}
              </select>
              <button
                type="submit"
                disabled={addNacionalidade.isPending || !novaNacionalidade}
                className="text-xs font-semibold px-2.5 py-1.5 rounded-raio-s bg-acento text-acento-tinta border-none cursor-pointer disabled:opacity-50"
              >
                Salvar
              </button>
            </form>
          )}

          {(listaNacionalidades.data ?? []).length === 0 ? (
            <span className="text-xs text-tinta3 italic py-1">Nenhuma nacionalidade registrada.</span>
          ) : (
            <div className="flex flex-wrap gap-1.5">
              {(listaNacionalidades.data ?? []).map((n) => (
                <span
                  key={n.id}
                  className="px-2.5 py-1 rounded-full bg-sup border border-borda text-xs font-medium text-tinta flex items-center gap-1.5"
                >
                  <Globe className="w-3 h-3 text-acento" />
                  <span>{nomeDoPais(n.pais_id)}</span>
                  <button
                    type="button"
                    onClick={() => delNacionalidade.mutate(n.id)}
                    className="text-tinta3 hover:text-fem p-0.5 border-none bg-transparent cursor-pointer"
                  >
                    <X className="w-3 h-3" />
                  </button>
                </span>
              ))}
            </div>
          )}
        </div>

        {/* Idiomas */}
        <div className="flex flex-col gap-2 pt-3 border-t border-borda/40">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-tinta flex items-center gap-1.5">
              <Languages className="w-3.5 h-3.5 text-acento" />
              <span>Idiomas Falados</span>
              {(listaIdiomas.data ?? []).length > 0 && (
                <span className="text-[10px] font-num px-1.5 py-0.2 rounded-full bg-acento/10 text-acento border border-acento/20">
                  {listaIdiomas.data?.length}
                </span>
              )}
            </span>
            <button
              type="button"
              onClick={() => setFormIdiAberto((a) => !a)}
              className="text-xs text-acento hover:text-tinta font-medium flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
            >
              <Plus className="w-3 h-3" />
              {formIdiAberto ? 'Fechar' : 'Adicionar'}
            </button>
          </div>

          {formIdiAberto && (
            <form
              onSubmit={(e) => {
                e.preventDefault();
                if (!novoIdioma.trim()) return;
                addIdioma.mutate([novoIdioma.trim()], {
                  onSuccess: () => {
                    setNovoIdioma('');
                    setFormIdiAberto(false);
                  },
                });
              }}
              className="p-3 rounded-raio-s bg-sup/50 border border-borda flex items-center gap-2"
            >
              <input
                type="text"
                value={novoIdioma}
                onChange={(e) => setNovoIdioma(e.target.value)}
                placeholder="Idioma (ex: Português, Italiano, Alemão)"
                list="sugestoes-idiomas-trajetoria"
                className="text-xs px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta flex-1 focus:outline-none focus:border-acento"
              />
              <datalist id="sugestoes-idiomas-trajetoria">
                {IDIOMAS.map((i) => (
                  <option key={i} value={i} />
                ))}
              </datalist>
              <button
                type="submit"
                disabled={addIdioma.isPending || !novoIdioma.trim()}
                className="text-xs font-semibold px-2.5 py-1.5 rounded-raio-s bg-acento text-acento-tinta border-none cursor-pointer disabled:opacity-50"
              >
                Salvar
              </button>
            </form>
          )}

          {(listaIdiomas.data ?? []).length === 0 ? (
            <span className="text-xs text-tinta3 italic py-1">Nenhum idioma registrado.</span>
          ) : (
            <div className="flex flex-wrap gap-1.5">
              {(listaIdiomas.data ?? []).map((i) => (
                <span
                  key={i.id}
                  className="px-2.5 py-1 rounded-full bg-sup border border-borda text-xs font-medium text-tinta flex items-center gap-1.5"
                >
                  <Languages className="w-3 h-3 text-acento" />
                  <span>{i.idioma}</span>
                  <button
                    type="button"
                    onClick={() => delIdioma.mutate(i.id)}
                    className="text-tinta3 hover:text-fem p-0.5 border-none bg-transparent cursor-pointer"
                  >
                    <X className="w-3 h-3" />
                  </button>
                </span>
              ))}
            </div>
          )}
        </div>

        {/* Religiões */}
        <div className="flex flex-col gap-2 pt-3 border-t border-borda/40">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-tinta flex items-center gap-1.5">
              <Church className="w-3.5 h-3.5 text-acento" />
              <span>Tradições Religiosas</span>
              {(listaReligioes.data ?? []).length > 0 && (
                <span className="text-[10px] font-num px-1.5 py-0.2 rounded-full bg-acento/10 text-acento border border-acento/20">
                  {listaReligioes.data?.length}
                </span>
              )}
            </span>
            <button
              type="button"
              onClick={() => setFormRelAberto((a) => !a)}
              className="text-xs text-acento hover:text-tinta font-medium flex items-center gap-1 bg-transparent border-none cursor-pointer p-0"
            >
              <Plus className="w-3 h-3" />
              {formRelAberto ? 'Fechar' : 'Adicionar'}
            </button>
          </div>

          {formRelAberto && (
            <form
              onSubmit={(e) => {
                e.preventDefault();
                if (!novaReligiao.denominacao.trim()) return;
                addReligiao.mutate(
                  [novaReligiao.denominacao.trim(), novaReligiao.periodo.trim() || null],
                  {
                    onSuccess: () => {
                      setNovaReligiao({ denominacao: '', periodo: '' });
                      setFormRelAberto(false);
                    },
                  },
                );
              }}
              className="p-3 rounded-raio-s bg-sup/50 border border-borda flex flex-col gap-2"
            >
              <input
                type="text"
                value={novaReligiao.denominacao}
                onChange={(e) => setNovaReligiao({ ...novaReligiao, denominacao: e.target.value })}
                placeholder="Denominação (ex: Católica Apostólica Romana, Judaísmo)"
                list="sugestoes-religiao-trajetoria"
                className="text-xs px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta focus:outline-none focus:border-acento"
              />
              <datalist id="sugestoes-religiao-trajetoria">
                {RELIGIOES.map((r) => (
                  <option key={r} value={r} />
                ))}
              </datalist>
              <div className="flex gap-2">
                <input
                  type="text"
                  value={novaReligiao.periodo}
                  onChange={(e) => setNovaReligiao({ ...novaReligiao, periodo: e.target.value })}
                  placeholder="Período (opcional)"
                  className="text-xs px-2.5 py-1.5 rounded-raio-s border border-borda bg-card text-tinta flex-1 focus:outline-none focus:border-acento"
                />
                <button
                  type="submit"
                  disabled={addReligiao.isPending || !novaReligiao.denominacao.trim()}
                  className="text-xs font-semibold px-3 py-1.5 rounded-raio-s bg-acento text-acento-tinta border-none cursor-pointer disabled:opacity-50"
                >
                  Salvar
                </button>
              </div>
            </form>
          )}

          {(listaReligioes.data ?? []).length === 0 ? (
            <span className="text-xs text-tinta3 italic py-1">Nenhuma tradição religiosa registrada.</span>
          ) : (
            <div className="flex flex-col gap-1.5">
              {(listaReligioes.data ?? []).map((r) => (
                <div
                  key={r.id}
                  className="p-2 rounded-raio-s bg-sup/50 border border-borda flex items-center justify-between text-xs"
                >
                  <div className="min-w-0 flex-1">
                    <span className="font-semibold text-tinta block truncate">{r.denominacao}</span>
                    {r.periodo && (
                      <span className="text-[11px] text-tinta3 block truncate font-num">{r.periodo}</span>
                    )}
                  </div>
                  <button
                    type="button"
                    onClick={() => delReligiao.mutate(r.id)}
                    className="p-1 text-tinta3 hover:text-fem transition-colors border-none bg-transparent cursor-pointer"
                  >
                    <X className="w-3.5 h-3.5" />
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
