// src/features/person/components/PersonDetails.tsx
interface PersonDetailsProps {
  personId: string;
  onClose: () => void;
  onEdit: () => void;
  onOpenTimeline: () => void;
  // Em uma implementação real, usaríamos o useQuery aqui para buscar os dados completos
  // mockData injetado para fins de visualização da estrutura
}

export function PersonDetails({ onClose, onEdit, onOpenTimeline }: PersonDetailsProps) {
  return (
    // Overlay e Background (Modal)
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-6 md:p-12">
      {/* Fundo com grid pattern e opacidade */}
      <div 
        className="absolute inset-0 bg-mesa/55 backdrop-blur-sm transition-opacity"
        onClick={onClose}
      >
        <div className="absolute inset-0 bg-[radial-gradient(var(--borda)_1px,transparent_1px)] bg-[size:26px_26px] opacity-40"></div>
      </div>

      {/* Container Principal do Modal */}
      <div className="relative w-full max-w-[1080px] max-h-full bg-card border border-borda2 rounded-raio shadow-[0_24px_64px_rgba(0,0,0,.28)] flex flex-col overflow-hidden">
        
        {/* Cabeçalho */}
        <header className="p-4 sm:p-6 border-b border-borda bg-card2 flex flex-col sm:flex-row items-start gap-5 flex-none">
          {/* Foto/Avatar */}
          <div className="w-24 h-24 rounded-raio-s bg-sup border border-borda flex-none flex items-center justify-center text-tinta3 font-num text-xs">
            sem foto
          </div>

          <div className="flex-1 flex flex-col gap-2 min-w-0">
            <div className="flex items-center gap-2.5">
              <span className="w-1 h-5.5 rounded-sm bg-masc block"></span>
              <h3 className="m-0 font-tit font-fw7 text-2xl sm:text-3xl tracking-tit text-tinta truncate">
                José <span className="uppercase tracking-[0.04em]">Silva</span>
              </h3>
              <span className="text-xs px-2.5 py-1 rounded-full bg-chip text-tinta2 font-num whitespace-nowrap">
                geração II
              </span>
            </div>
            
            <div className="flex flex-wrap items-center gap-3 font-num text-[13.5px] text-tinta2">
              <span>n. 12/03/1945 · Campos dos Goytacazes, RJ</span>
              <span className="text-borda2 hidden sm:inline">|</span>
              <span>† 08/2012 · Macaé, RJ</span>
              <span className="text-borda2 hidden sm:inline">|</span>
              <span>67 anos</span>
            </div>

            <div className="flex gap-2 flex-wrap mt-1">
              <span className="text-[12.5px] px-2.5 py-1 rounded-full bg-sup border border-borda text-tinta2">“Zé do Campo”</span>
              <span className="text-[12.5px] px-2.5 py-1 rounded-full bg-sup border border-borda text-tinta2">brasileira · portuguesa</span>
              <span className="text-[12.5px] px-2.5 py-1 rounded-full bg-sup border border-borda text-tinta2">14 documentos</span>
            </div>
          </div>

          {/* Ações */}
          <div className="flex gap-2 sm:self-start w-full sm:w-auto justify-end mt-4 sm:mt-0">
            <button onClick={onEdit} className="touch-manipulation px-3.5 py-2 rounded-raio-s border border-acento bg-acento text-acento-tinta font-corpo text-[13.5px] font-fw6">
              Editar
            </button>
            <button onClick={onOpenTimeline} className="touch-manipulation px-3.5 py-2 rounded-raio-s border border-borda2 bg-card text-tinta font-corpo text-[13.5px] whitespace-nowrap">
              Na linha do tempo
            </button>
            <button onClick={onClose} className="touch-manipulation w-10 h-10 flex items-center justify-center rounded-raio-s border border-borda2 bg-card text-tinta2 text-lg">
              ✕
            </button>
          </div>
        </header>

        {/* Corpo: Duas Colunas com Scroll Independente */}
        <div className="flex flex-col md:flex-row flex-1 min-h-0 overflow-y-auto md:overflow-hidden">
          
          {/* Coluna Esquerda: Eventos e Atributos */}
          <div className="flex-1 p-5 sm:p-7 flex flex-col gap-7 md:border-r md:border-borda min-w-0 md:overflow-y-auto">
            
            {/* Eventos de Vida */}
            <section className="flex flex-col gap-3">
              <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Eventos de vida</span>
              <div className="flex flex-col border border-borda rounded-raio-s overflow-hidden bg-card">
                
                <div className="grid grid-cols-1 sm:grid-cols-[120px_1fr_100px] gap-2 sm:gap-3.5 p-3 border-b border-borda items-start sm:items-center">
                  <span className="text-[13.5px] text-tinta font-fw6 sm:font-normal">Nascimento</span>
                  <span className="text-[13.5px] text-tinta2">Campos dos Goytacazes, RJ</span>
                  <span className="font-num text-[12.5px] text-tinta2 sm:text-right">12/03/1945</span>
                </div>
                
                <div className="grid grid-cols-1 sm:grid-cols-[120px_1fr_100px] gap-2 sm:gap-3.5 p-3 border-b border-borda items-start sm:items-center">
                  <span className="text-[13.5px] text-tinta font-fw6 sm:font-normal">Casamento</span>
                  <span className="text-[13.5px] text-tinta2">união com <i className="text-tinta3">Desconhecida</i></span>
                  <span className="font-num text-[12.5px] text-tinta2 sm:text-right">1967</span>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-[120px_1fr_100px] gap-2 sm:gap-3.5 p-3 items-start sm:items-center">
                  <span className="text-[13.5px] text-tinta font-fw6 sm:font-normal">Falecimento</span>
                  <span className="text-[13.5px] text-tinta2">Macaé, RJ</span>
                  <span className="font-num text-[12.5px] text-tinta2 sm:text-right">08/2012</span>
                </div>

              </div>
            </section>

            {/* Atributos em Lista */}
            <section className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              
              <div className="flex flex-col gap-2.5">
                <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Religião</span>
                <div className="flex flex-col gap-1.5">
                  <div className="flex justify-between text-[13.5px]">
                    <span className="text-tinta">Católica Apostólica Romana</span>
                    <span className="font-num text-xs text-tinta3">1945–1979</span>
                  </div>
                  <div className="flex justify-between text-[13.5px]">
                    <span className="text-tinta">Espírita (kardecista)</span>
                    <span className="font-num text-xs text-tinta3">1979–2012</span>
                  </div>
                </div>
              </div>

              <div className="flex flex-col gap-2.5">
                <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Profissões</span>
                <div className="flex flex-col gap-1.5">
                  <div className="flex justify-between text-[13.5px]">
                    <span className="text-tinta">Lavrador · usina Santa Cruz</span>
                    <span className="font-num text-xs text-tinta3">1962–1971</span>
                  </div>
                  <div className="flex justify-between text-[13.5px]">
                    <span className="text-tinta">Contador</span>
                    <span className="font-num text-xs text-tinta3">1971–2008</span>
                  </div>
                </div>
              </div>

            </section>

            {/* Minibiografia */}
            <section className="flex flex-col gap-2.5 mt-2">
              <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Minibiografia</span>
              <p className="m-0 text-[14.5px] leading-relaxed text-tinta2 text-pretty">
                Nasceu na zona rural de Campos, filho mais velho de Antônio e Maria. Trabalhou na usina até se mudar para Macaé no começo dos anos 1970, quando passou a atuar como contador. Guardava as certidões da família numa lata de biscoito — a origem de boa parte deste acervo.
              </p>
            </section>

          </div>

          {/* Coluna Direita: Contexto e Parentesco */}
          <aside className="w-full md:w-[330px] p-5 sm:p-7 flex flex-col gap-6 bg-card2 flex-none md:overflow-y-auto">
            
            {/* Parentesco */}
            <div className="flex flex-col gap-3">
              <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Parentesco</span>
              <div className="flex flex-col gap-2.5 text-[13.5px]">
                <span className="text-tinta2">Pais · <span className="text-tinta">Antônio Silva ⚭ Maria Ferreira</span></span>
                
                <span className="text-tinta2 block">
                  União · <span className="text-tinta">Desconhecida</span> <span className="font-num text-xs text-tinta3">(⚭ 1967 · placeholder)</span> <button className="touch-manipulation text-acento font-fw6 ml-1 hover:underline">Identificar</button>
                </span>
                
                <span className="text-tinta2">Filhos · <span className="text-tinta">Gabriel Silva</span></span>
                <span className="text-tinta2">Irmãos · <span className="text-tinta">Ana, Sebastião</span></span>
              </div>
            </div>

            <hr className="border-t border-borda" />

            {/* A vida no contexto */}
            <div className="flex flex-col gap-3">
              <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">A vida no contexto</span>
              <div className="flex flex-col gap-2 text-[13px] text-tinta2 leading-relaxed">
                <span>Tinha <span className="text-tinta font-num">15 anos</span> na inauguração de Brasília</span>
                <span>Tinha <span className="text-tinta font-num">19 anos</span> no golpe militar</span>
                <span>Tinha <span className="text-tinta font-num">49 anos</span> no Plano Real</span>
              </div>
              <button onClick={onOpenTimeline} className="touch-manipulation mt-1 px-3.5 py-2 rounded-raio-s border border-borda2 bg-card text-tinta font-corpo text-[13.5px] text-left hover:border-borda transition-colors">
                Abrir gaveta da linha do tempo →
              </button>
            </div>

            <hr className="border-t border-borda" />

            {/* Documentos */}
            <div className="flex flex-col gap-3">
              <span className="font-num text-[10.5px] tracking-[0.14em] uppercase text-tinta3">Documentos</span>
              <div className="grid grid-cols-3 gap-2">
                <div className="h-16 rounded-md bg-sup border border-borda flex items-center justify-center font-num text-[10px] text-tinta3">certidão</div>
                <div className="h-16 rounded-md bg-sup border border-borda flex items-center justify-center font-num text-[10px] text-tinta3">retrato</div>
                <div className="h-16 rounded-md bg-sup border border-borda flex items-center justify-center font-num text-[10px] text-tinta3">carteira</div>
              </div>
              <span className="text-[12.5px] text-tinta3">+ 11 arquivos · 84 MB</span>
            </div>

          </aside>

        </div>
      </div>
    </div>
  );
}