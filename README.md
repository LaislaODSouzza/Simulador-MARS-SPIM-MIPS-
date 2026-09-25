# Simulador-MARS-SPIM-MIPS
Projeto de Simulador MARS/SPIM (MIPS) para a matéria de Arquitetura de Computadores pela Universidade Federal de Sergipe (UFS).

### Membros do Projeto
* **Guilherme Victório de Carvalho Brito Vieira** - [victoriog@academico.ufs.br](mailto:victoriog@academico.ufs.br)
* **Gustavo Tínel Vitória Fraga**
* **Laísla Oliveira Dias de Souza** - [laislaoliveirads@academico.ufs.br](mailto:laislaoliveirads@academico.ufs.br)

---

## Resumo
Este repositório apresenta um estudo sobre simuladores de arquitetura de computadores, com foco na análise do **MARS (MIPS Assembler and Runtime Simulator)**. O simulador é amplamente utilizado no ensino de conceitos como conjunto de instruções, registradores, memória e desvios condicionais. Discutimos a escolha da ferramenta, instalação, configuração e a execução de exemplos práticos com algoritmos básicos para ilustrar o funcionamento interno de um processador.

**Vídeo de Apresentação:** [Inserir Link do YouTube/Drive aqui]

---

## 1. Introdução
O estudo da arquitetura de computadores é fundamental para compreender como as instruções de um programa são executadas pelo processador (busca, decodificação, execução e acesso à memória). 

Para tornar esse aprendizado visual e prático, o uso de simuladores é essencial. Neste projeto, optamos pelo **MARS**, uma ferramenta com interface gráfica intuitiva que exibe em tempo real o conteúdo dos registradores e da memória durante a execução dos programas em Assembly MIPS, a qual permite analisar o comportamento do hardware sem precisar de equipamentos físicos dedicados.

---

## 2. O Simulador Selecionado: MARS
Avaliamos três opções principais para o projeto:
1. **Logisim (Evolution):** Focado em circuitos digitais de baixo nível.
2. **Ripes:** Focado na arquitetura RISC-V e visualização de pipeline (curva de aprendizado maior).
3. **MARS:** IDE para programação em Assembly MIPS.

Escolhemos o MARS pelo seu **didatismo e intuitividade**. Como o simulador já oferece um processador funcional baseado nos princípios RISC de 32 bits, a equipe focou na compreensão do conjunto de instruções e no modo de execução dos algoritmos, bem como no próprio funcionamento do simulador. 

**Principais Recursos:**
* Interface *point-and-click* com editor integrado.
* Edição de valores de registradores e memória em tempo real (Hex/Dec).
* Execução passo a passo (com opção de retrocesso).
* Suporte a registradores de ponto flutuante e exceções.

---

## 3. Instalação e Configuração
O MARS destaca-se pela sua grande simplicidade de configuração (*seção em andamento*):

* **Pré-requisito:** Java Runtime Environment (JRE) 1.5 ou superior.
* **Instalação:** Distribuído como um executável `.jar` único (`Mars4_5.jar`). Pode ser baixado na [página da Missouri State University](https://courses.missouristate.edu/KenVollmar/mars/).
* **Execução:** Clique duas vezes no arquivo ou via terminal com `java -jar Mars4_5.jar`. Não exige seleção prévia de arquitetura, pois abre nativamente no padrão MIPS32.

---

## 4. Códigos feitos para a Simulação (Exemplos Práticos)

Para ilustrar o funcionamento do simulador e a aplicação de conceitos de programação, desenvolvemos e adaptamos algoritmos clássicos em Assembly MIPS. *(Seção em andamento)*

## 4.1. ÍNDICE - Códigos feitos para a Simulação
|   Nome   |   Descrição   |
|   -------   |   ---------   |
|[Algoritmo HeapSort](heapsort.asm)|Responsável por ordenar um array utilizando a estrutura de dados Heap (Max-Heap), com o código demonstrando o uso de manipulação de memória, laços de repetição, desvios condicionais e chamadas de procedimentos|
|[Algoritmo de Fila](filaComListaEncadeada.asm)|Trata-se de uma estrutura de dados do tipo FIFO (*First In First Out*), onde o primeiro elemento a ser inserido pelo método `enfileirar` também será o primeiro a ser removido da fila chamando o método `desenfileirar`. O código demonstra o uso de manipulação de memória, gerenciamento da pilha com `$sp` e `$ra` e o controle de fluxo por desvios condicionais|
