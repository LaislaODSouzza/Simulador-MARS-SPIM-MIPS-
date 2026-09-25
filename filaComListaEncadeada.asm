.data
str_erro_mem:    .asciiz "Erro: Falha na alocacao de memoria\n"
str_inserido:    .asciiz "Inserido: "
str_vazia:       .asciiz "Fila vazia! Nao ha o que remover\n"
str_removido:    .asciiz "Removido: "
str_fila_vazia:  .asciiz "Fila atual: [Vazia]\n"
str_fila_atual:  .asciiz "Fila atual: "
str_print_no:    .asciiz " -> "
str_null:        .asciiz "NULL\n"
str_nova_linha:  .asciiz "\n"

# Aloca espaco global na memoria para a estrutura Fila (8 bytes: 4 para o inicio e 4 pro fim)
.align 2
minha_fila:      .word 0, 0   # minha_fila->inicio = NULL, minha_fila->fim = NULL => A FILA COMEÇA VAZIA

.text
.globl main

main:
    # O MARS ja inicia a memoria global zerada, entao a fila comeca em NULL automaticamente.

    # 1. Testando insercoes
    la $a0, minha_fila
    li $a1, 10
    jal enfileirar

    la $a0, minha_fila
    jal exibirFila

    la $a0, minha_fila
    li $a1, 20
    jal enfileirar

    la $a0, minha_fila
    li $a1, 30
    jal enfileirar

    la $a0, minha_fila
    jal exibirFila

    # 2. Testando remocoes (Remove o 10)
    la $a0, minha_fila
    jal desenfileirar
    move $t0, $v0

    la $a0, str_removido
    li $v0, 4
    syscall
    move $a0, $t0
    li $v0, 1
    syscall
    la $a0, str_nova_linha
    li $v0, 4
    syscall

    la $a0, minha_fila
    jal exibirFila

    # Desenfileirar o 20
    la $a0, minha_fila
    jal desenfileirar
    move $t0, $v0
    la $a0, str_removido
    li $v0, 4
    syscall
    move $a0, $t0
    li $v0, 1
    syscall
    la $a0, str_nova_linha
    li $v0, 4
    syscall

    la $a0, minha_fila
    jal exibirFila

    # Desenfileirar o 30
    la $a0, minha_fila
    jal desenfileirar
    move $t0, $v0
    la $a0, str_removido
    li $v0, 4
    syscall
    move $a0, $t0
    li $v0, 1
    syscall
    la $a0, str_nova_linha
    li $v0, 4
    syscall

    la $a0, minha_fila
    jal exibirFila

    # Finaliza o programa no MARS
    li $v0, 10
    syscall

# =========================================================================
# FILA: Estrutura de dados do tipo FIFO (First in First out),
#       logo se os elementos da fila são adicionados pela direita, serão desenfileirados pela esquerda
#       Nessa implementação, não há relações de prioridade. Eh simplesmente a implementação de uma fila por uma
#       lista encadeada!!
# void enfileirar(Fila* fila, int valor)
# $a0 = endereco da fila, $a1 = valor

enfileirar:
    # Salva $ra e os registradores $s usados aqui, nessa funcao
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)

    move $s0, $a0               # $s0 = fila
    move $s1, $a1               # $s1 = valor

    # Aloca memoria para o novo no/elemento usando a Syscall 9 (sbrk)
    li $a0, 8                   # 8 bytes (4 para o dado, 4 para o proximo)
    li $v0, 9
    syscall
    move $s2, $v0               # $s2 = endereco do novoNo

    beq $s2, $zero, erro_memoria

    sw $s1, 0($s2)              # novoNo->dado = valor      => O conteúdo do novoNo recebe o valor do dado
    sw $zero, 4($s2)            # novoNo->proximo = NULL    => com o seu ponteiro para o proximo elemento apontando para NULL, garante que
#								 este eh o ultimo elemento da fila ate entao inserido
    lw $t0, 0($s0)              # $t0 = fila->inicio
    beq $t0, $zero, fila_vazia

    # Fila ja possui elementos: fila->fim->proximo = novoNo   => Na fila atual, no ponteiro proximo do ultimo elemento, faz ele apontar para novoNo
    lw $t1, 4($s0)              # $t1 = fila->fim
    sw $s2, 4($t1)              # antigo_fim->proximo = novoNo  => novoNo agora passa a sero ultimo elemento da fila
    sw $s2, 4($s0)              # fila->fim = novoNo            => conclui a mudanca do ponteiro fim da fila
    j fim_enfileirar

fila_vazia:
    sw $s2, 0($s0)              # fila->inicio = novoNo
    sw $s2, 4($s0)              # fila->fim = novoNo

fim_enfileirar:
    la $a0, str_inserido
    li $v0, 4
    syscall
    move $a0, $s1
    li $v0, 1
    syscall
    la $a0, str_nova_linha
    li $v0, 4
    syscall

    # Epilogo: restaura registradores e retorna
    lw $ra, 12($sp)
    lw $s0, 8($sp)
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 16
    jr $ra

erro_memoria:
    la $a0, str_erro_mem
    li $v0, 4
    syscall

    lw $ra, 12($sp)
    lw $s0, 8($sp)
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 16
    jr $ra

# =========================================================================
# int desenfileirar(Fila* fila)
# $a0 = endereco da fila | Retorno em $v0 = valor

desenfileirar:
    lw $t0, 0($a0)              # $t0 = fila->inicio
    bne $t0, $zero, tem_elementos

    la $a0, str_vazia           # Fila vazia
    li $v0, 4
    syscall
    li $v0, -1
    jr $ra

tem_elementos:
    move $t1, $a0               # $t1 = endereco da fila
    lw $v0, 0($t0)              # $v0 = temp->dado (valor de retorno): Cria um no temp que sera desenfileirado

    lw $t2, 4($t0)              # $t2 = temp->proximo
    sw $t2, 0($t1)              # fila->inicio = temp->proximo  => Conforme o primeiro elemento vai sendo desenfileirado,
#				   o ponteiro inicio passara a apontar para o proximo elemento, que eh o proximo no a ser desenfileirado!!
    lw $t3, 0($t1)              # Se fila->inicio mudou para NULL, significa que nao tem mais nenhum elemento na fila
    bne $t3, $zero, fim_desenfileirar
    sw $zero, 4($t1)            # fila->fim = NULL

fim_desenfileirar:
    jr $ra

# =========================================================================
# void exibirFila(Fila* fila)  => A logica consiste em criar um elemento chamado atual que vai percorrer toda a fila
#				   a partir do atual elemento onde inicio esta apontando e, a partir dele, percorrer com
#				   "while((atual = atual->proximo) != NULL)" que, enquanto essa condicao for verdadeira,
#				   todos os elementos irao aparecendo na saida sendo "printados". Para em NULL porque ai a lista acaba
# $a0 = endereco da fila

exibirFila:
    lw $t0, 0($a0)              # $t0 = fila->inicio
    bne $t0, $zero, iniciar_exibicao

    la $a0, str_fila_vazia
    li $v0, 4
    syscall
    jr $ra

iniciar_exibicao:
    move $t1, $t0               # $t1 = atual (fila->inicio)
    la $a0, str_fila_atual
    li $v0, 4
    syscall

loop_exibir:
    beq $t1, $zero, fim_loop_exibir

    lw $a0, 0($t1)              # $a0 = atual->dado
    li $v0, 1
    syscall

    la $a0, str_print_no        # Print " -> "
    li $v0, 4
    syscall

    lw $t1, 4($t1)              # atual = atual->proximo
    j loop_exibir

fim_loop_exibir:
    la $a0, str_null            # Print "NULL\n"
    li $v0, 4
    syscall
    jr $ra
