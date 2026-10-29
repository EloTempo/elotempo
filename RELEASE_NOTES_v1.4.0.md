## EloTempo 1.4.0

Programa gratuito e offline para árvores genealógicas, que põe a vida de cada pessoa da família no mesmo eixo que a história do país. Software livre, sob licença GPL-3.0-or-later.

> ### Se você usa a 1.2 ou a 1.3, atualize antes de trocar de computador
>
> Nas versões 1.2 e 1.3, a chave que protege o acervo ficava presa ao nome do computador e ao nome do usuário do Windows. Renomear o computador, reinstalar o sistema com outro nome ou levar a pasta do EloTempo para uma máquina nova podia tornar o acervo **impossível de abrir**, sem recuperação.
>
> A 1.4 corrige isso. Ao abrir pela primeira vez **no mesmo computador em que você já usa o EloTempo**, a chave é convertida para um formato que acompanha o acervo para qualquer máquina. E o programa nunca mais substitui uma chave que não consegue abrir: em vez disso, avisa e preserva o arquivo.
>
> **O que fazer:** instale a 1.4 no computador atual e abra o programa uma vez. Só depois troque de computador. Se puder, exporte também uma cópia em GEDCOM — é o formato que qualquer programa de genealogia lê.
>
> **Se você já copiou a pasta para outro computador** e a 1.4 avisar que não consegue abrir a chave do acervo, **não apague nada**. Instale a 1.4 no computador antigo, abra o programa uma vez lá e copie a pasta de novo.

### Downloads

- **Windows 10 e 11** — `EloTempo_1.4.0_x64-setup.exe` (instalador) ou `EloTempo_1.4.0_x64_pt-BR.msi`
- **Linux** — `EloTempo_1.4.0_amd64.deb` (Ubuntu, Debian, Mint) ou `EloTempo_1.4.0_amd64.AppImage` (qualquer distribuição)

O GitHub mostra o SHA-256 de cada arquivo ao lado do nome. Confira antes de instalar, se quiser ter certeza de que o arquivo é o que foi publicado.

---

### O assistente agora edita, além de criar

Na 1.3 o assistente respondia sobre o acervo e montava árvores a partir de um texto colado. Agora ele também:

- **edita uma pessoa** da sua família — biografia, datas, profissão, apelido;
- **acrescenta parentesco** — pai, mãe, cônjuge, filho ou filha;
- **acrescenta marcos** a uma linha do tempo sua;
- **escreve uma biografia** a partir do que já está registrado;
- **aponta lacunas** no acervo, como pessoas sem data de nascimento ou sem biografia;
- conduz uma **entrevista familiar guiada**, pergunta por pergunta.

Nada é gravado sem passar por um cartão de revisão. E quando o banco recusa algo que a revisão mostrava — por exemplo, trocar um pai que já estava registrado —, o assistente diz o que ficou de fora em vez de gravar outra coisa. As pessoas do acervo histórico e as linhas do tempo de referência ficam protegidas: o assistente não as altera.

**Continua funcionando sem baixar nada.** O assistente roda dentro do programa, sem internet, e se recusa a responder quando a informação não está no seu acervo nem no texto que você colou.

### O modelo de linguagem é mais fácil de ligar — no Windows

Um modelo de linguagem local é opcional e deixa as respostas mais fluentes. No Windows, ao clicar em **Ativar**, o EloTempo baixa sozinho o motor `llama-server` (cerca de 19 MB, na primeira vez) e confere o hash SHA-256 do arquivo antes de usá-lo. A tela avisa disso antes do clique.

No Linux o motor não é baixado automaticamente: use o Ollama ou um `llama-server` instalado à parte.

O endereço do motor só aceita a sua própria máquina. É isso que garante que nenhum nome ou data da sua família saia do computador por esse caminho.

### Acervo histórico: 97 árvores em 9 pastas

O acervo público que acompanha o programa chega a **97 árvores**, organizadas em 9 pastas. Entre as famílias novas: a dinastia Júlio-Claudiana, Alexandre, o Grande, os Romanov, os Médici, Simón Bolívar, Tiradentes, Louis Pasteur, Sigmund Freud, Villa-Lobos, Carlos Drummond de Andrade, Monteiro Lobato, Pablo Picasso e Henry Ford.

Quem já tem uma versão anterior recebe as árvores novas ao abrir o programa, sem mudança nas pessoas e nos vínculos que você registrou.

### Outras mudanças

- A árvore mostra no topo o **nome, a pasta e o período** da família que está aberta.
- O menu GEDCOM ganhou **Exportar acervo histórico público**, que gera os arquivos do portal web. É uma ferramenta de manutenção do acervo público do site — para levar os seus dados, continue usando **Exportar GEDCOM**.

---

### Como os seus dados ficam protegidos

- O **acervo é cifrado com SQLCipher** no disco, o que impede que ele seja aberto por um programa comum de banco de dados.
- A senha do cofre é transformada em chave pelo **Argon2id**, e os dados do cofre são cifrados com **AES-256-GCM**.
- **Nenhum nome ou data da sua família é enviado para a internet.** O programa só se conecta em dois casos, e ambos começam por uma ação sua:
  - ao **baixar o modelo de linguagem ou o motor** — sempre conferidos por SHA-256 antes de serem usados;
  - ao abrir a aba **Mapa** de uma pessoa, que carrega as imagens do mapa do OpenStreetMap. Para entregá-las, o servidor do mapa recebe as coordenadas da região exibida — não o nome de ninguém.

**Correção:** as notas das versões 1.0 a 1.3 diziam que o cofre usava ChaCha20-Poly1305. Estava errado — o algoritmo sempre foi o AES-256-GCM descrito acima.
