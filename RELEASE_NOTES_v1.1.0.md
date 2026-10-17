# Notas de Lançamento: EloTempo v1.1.0 (Release Desktop Oficial)

Data de Lançamento: **Setembro de 2026**  
Versão do Software: **v1.1.0**  
Licença: **GNU General Public License v3.0 (GPLv3)**  
Autor: **Gabriel Nascimento**

---

## 1. Visão Geral do Lançamento

O **EloTempo v1.1.0** marca a conclusão histórica da **Fase 1 (Acervo Canônico da Humanidade)** e da **Fase 2 (Fechamento do Release Desktop Oficial)** do Strategic Roadmap do projeto.

O software consolida-se como a mais avançada e completa solução desktop local-first para genealogia e linhas do tempo históricas:
- **100% Offline & Soberano**: Todos os dados familiares, fotos e notas residem exclusivamente no computador do usuário, em banco de dados SQLite local protegido por criptografia opcional de padrão militar (AES-256-GCM com derivação de chave Argon2id e recuperação por frase mnemônica de 24 palavras).
- **Interoperabilidade Total**: Compatibilidade nativa com o padrão internacional **GEDCOM 7.0** e **5.5.1**, com suporte a pacotes multimídia GEDZip.
- **Acervo Canônico Completo Embutido**: 78 árvores genealógicas públicas prontas para consulta, cobrindo os maiores marcos civilizacionais, científicos, literários e políticos do Brasil e do mundo.

---

## 2. Artefatos Binários de Distribuição (Windows x64)

Os pacotes de instalação e o executável independente foram compilados em perfil `release` com Link-Time Optimization (LTO), remoção completa de símbolos de depuração (`strip`) e compressão de alto desempenho:

| Arquivo | Tipo | Tamanho | Checksum SHA-256 |
| :--- | :---: | :---: | :--- |
| **`EloTempo_1.1.0_x64-setup.exe`** | Instalador Windows (NSIS) | **3,62 MB** | `6b73cf5b6298d34435c78a279f7173d23cbdb893546b0138f2742823d1a5d676` |
| **`EloTempo_1.1.0_x64_pt-BR.msi`** | Pacote Corporativo (WiX MSI) | **4,50 MB** | `4de414538e87544d00eef2507bcc27c1fbf909cba6d7a96b92aa662bf29aa71e` |
| **`elotempo.exe`** | Executável Autônomo | **9,96 MB** | `8381b194ed991e35a72a324175d362d5b8a3bc500816096f820b1d49e5e4caa7` |

---

## 3. O Acervo Canônico da Humanidade (78 Árvores Genealógicas)

A versão 1.1.0 incorpora todo o trabalho de pesquisa, georreferenciamento e curadoria visual realizado ao longo dos 12 lotes da Fase 1:

- **Total de Árvores Públicas**: 78 linhagens
- **Total de Figuras Históricas**: 945 membros catalogados
- **Retratos Históricos Autênticos**: 453 fotos em alta definição com metadados arquivísticos Schema v4.0 (autoria, ano, técnica, custódia e licença pública institucional)
- **Avatares Nativos de Época (Zero Falsos Positivos)**: 492 figuras lendárias ou arcaicas preservadas com os avatares estilizados do EloTempo, sem anacronismos
- **Obras Culturais, Tratados e Atos de Estado**: 464 registros georreferenciados
- **Registros de Idiomas Falados**: 1.680 registros cobrindo 100% dos membros públicos
- **Locais Históricos no Banco**: 6.538 cidades, monumentos, capitais e sítios arqueológicos (Migrações 001 a 046)

### Estrutura Temática dos Lotes Embutidos:
1. **Brasil Imperial & Monarquias Tradicionais**: Família Imperial do Brasil, Casa Real de Portugal (Bragança), Casa Real Britânica (Windsor), Casa de Habsburgo, Casa de Bourbon, Dinastia Yamato (Japão) e Monarquias Europeias Tradicionais.
2. **Panteão dos Brasileiros Ilustres**: Duque de Caxias, Joaquim Nabuco, Machado de Assis, Oswaldo Cruz, Barão do Rio Branco, Ruy Barbosa, Alberto Santos Dumont, Barão de Mauá.
3. **Grandes Empreendedores & Pioneiros Industriais**: Família Matarazzo, Klabin/Lafer, Guinle, Armando Álvares Penteado, Antônio da Silva Prado, Dinastia Rockefeller.
4. **Pioneiros da Revolução Científica & Pensamento Moderno**: Albert Einstein, Isaac Newton, Galileu Galilei, Leonardo da Vinci, Nikola Tesla, Thomas Edison, Família Curie/Joliot-Curie, Família Darwin/Wedgwood.
5. **Pais Fundadores & Estadistas das Américas**: George Washington, Thomas Jefferson, Benjamin Franklin, Abraham Lincoln, José Bonifácio de Andrada e Silva.
6. **Mestres da Música Clássica & Artes Cênicas**: Dinastia Bach, Wolfgang Amadeus Mozart, Ludwig van Beethoven, Chiquinha Gonzaga.
7. **Grandes Gênios da Literatura Universal & Dramaturgia**: William Shakespeare, Miguel de Cervantes, Dante Alighieri, Johann Wolfgang von Goethe, Victor Hugo.
8. **Grandes Dinastias Políticas do Século XX**: Franklin D. Roosevelt, John F. Kennedy, George Bush, Winston Churchill, Mahatma Gandhi, Nelson Mandela, Martin Luther King Jr., etc.
9. **Antiguidade Clássica, Tradição Bíblica & Genealogias Ficcionais**: 18ª Dinastia do Egito, 19ª Dinastia (Ramsés II), Dinastias 21–23, Confúcio (Família Kong), Família Lurie (Rashi), Casa Real de Davi, Genealogia de Adão, Linhagem de Moisés, Patriarcas de Israel, Jesus (Lucas e Mateus), Buendía (*Cem Anos de Solidão*), Compson (*O Som e a Fúria*), Corleone (*O Poderoso Chefão*), Karamazov (*Dostoiévski*), Lannister & Targaryen (*Gelo e Fogo*), Skywalker (*Star Wars*), Terra Cambará (*O Tempo e o Vento*).

---

## 4. Requisitos do Sistema & Instalação

### Requisitos Mínimos (Windows):
- **Sistema Operacional**: Windows 10 (versão 1809 ou superior) ou Windows 11 (64-bit).
- **Processador**: Intel / AMD x64 (1.5 GHz ou superior).
- **Memória RAM**: 2 GB (recomendado: 4 GB).
- **Espaço em Disco**: 50 MB para o software (espaço adicional para dados locais conforme o tamanho das fotos do usuário).
- **Runtime**: Microsoft Edge WebView2 (já embutido nativamente no Windows 10 e 11).

### Como Instalar:
1. Baixe o instalador executável `EloTempo_1.1.0_x64-setup.exe` (ou o pacote `EloTempo_1.1.0_x64_pt-BR.msi`).
2. Dê um duplo clique para iniciar o assistente de instalação.
3. Conclua o processo e execute o atalho **EloTempo** na Área de Trabalho ou Menu Iniciar.

---

## 5. Próximo Marco Estratégico: Fase 3

Com a conclusão do executável desktop oficial:
- **Fase 3: Portal Web Interativo do Acervo Público**: Todos os dados do acervo público serão estruturados para consulta livre via navegador no site do EloTempo. Qualquer pessoa poderá explorar as 78 árvores genealógicas e as linhas do tempo históricas sem precisar instalar nada, enquanto o software desktop continuará sendo o ambiente soberano para criação e gestão de árvores familiares privadas.
