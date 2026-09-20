# Algoritmo: Heap Sort em Assembly MIPS
# Compatível com o simulador MARS (MIPS Assembler and Runtime Simulator)
.data
    # Um exemplo simples de Array desordenado
    array:      .word 12, 11, 13, 5, 6, 7, 1, 9, 3, 20
    length:     .word 10 # Tamanho do array
    
    # Algumas mensagens para aparecer no console
    str_antes: .asciiz "Array original:  "
    str_depois:  .asciiz "Array ordenado:  "
    espaco:      .asciiz " "
    novalinha:    .asciiz "\n"

.text
.globl main

main:
    #1. Imprimindo a mensagem e o Array Original 
    li $v0, 4
    la $a0, str_antes
    syscall
    jal print_array

    #2. Executando o código Heap Sort 
    la $a0, array     # $a0 = Endereço base do array
    lw $a1, length    # $a1 = Tamanho do array (n)
    jal heap_sort

    #3. Imprimindo a mensagem e o Array Ordenado 
    li $v0, 4
    la $a0, str_depois
    syscall

    jal print_array

    #4. Encerrando a execução 
    li $v0, 10
    syscall

#####################################################################
# : heap_sort
# Conjunto de Entradas:
#   $a0 = Representa o fimereço do array
#   $a1 = É o tamanho do array (n)

heap_sort:
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)

    move $s0, $a0   # $s0 = Endereço base
    move $s1, $a1   # $s1 = n (tamanho do heap atual)

    #Fazendo o Max-Heap 
    #Teoria base: Começa do último nó pai: i = (n / 2)-1
    srl $s2, $s1, 1
    addi $s2, $s2, -1  # $s2 = i
    
construindo_heap_loop:
    bltz $s2, comeco_sorting   # Se i < 0: termina a construção do Heap
    move $a0, $s0  # Endereço
    move $a1, $s1  # Tamanho n
    move $a2, $s2  # Índice do nó pai i
    jal heapify
    addi $s2, $s2, -1  # É i--
    j construindo_heap_loop

#Passo 2: Pegando ocada um dos elementos do Heap
comeco_sorting:
    # For i= n-1 até 1
    addi $s2, $s1, -1 # $s2 = i = n-1

sort_loop:
    blez $s2, fim_heap_sort  # Se i <= 0, significa que finalizou a ordenação
    # Troca o elemento da raiz array[0] com o último elemento array[i]
    move $a0, $s0
    li $a1, 0
    move $a2, $s2
    jal troca

    # Chama o heapify na árvore reduzida (logo, o tamanho = i e a raiz = 0)
    move $a0, $s0
    move $a1, $s2  # Tamanho reduzido
    li $a2, 0      # Raiz
    jal heapify
    addi $s2, $s2, -1  # i-- novamente
    j sort_loop

fim_heap_sort:
    lw $s2, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

#####################################################################
# heapify
# Mantém a propriedade de Max-Heap para o subárvore com raiz no índice i.
# Entradas:
#   $a0 = Endereço do array
#   $a1 = Tamanho do heap (n)
#   $a2 = Índice i (nó pai atual)

heapify:
    addi $sp, $sp, -24
    sw $ra, 20($sp)
    sw $s0, 16($sp)
    sw $s1, 12($sp)
    sw $s2, 8($sp)
    sw $s3, 4($sp)
    sw $s4, 0($sp)
    move $s0, $a0 # $s0 = Endereço base
    move $s1, $a1 # $s1 = n
    move $s2, $a2 # $s2 = maisLargo = i

    # $s3 = esquerda = 2*i + 1
    sll $s3, $a2, 1
    addi $s3, $s3, 1

    # $s4 = direita = 2*i + 2
    addi $s4, $s3, 1

    #Verifica se [esquerda < n] E [array[esquerda] > array[maisLargo]] 
    bge $s3, $s1, check_direita

    # Carregando o array[esquerda]
    sll $t0, $s3, 2
    add $t0, $s0, $t0
    lw $t1, 0($t0)     # $t1 = array[esquerda]

    # Carregando o array[maisLargo]
    sll $t2, $s2, 2
    add $t2, $s0, $t2
    lw $t3, 0($t2)     # $t3 = array[maisLargo]
    ble $t1, $t3, check_direita
    move $s2, $s3  # maisLargo = esquerda

check_direita:
    # Verifica se direita < n E array[direita] > array[maisLargo] 
    bge $s4, $s1, check_maisLargo

    # Carrega array[direita]
    sll $t0, $s4, 2
    add $t0, $s0, $t0
    lw $t1, 0($t0)             # $t1 = array[direita]

    # Carrega array[maisLargo]
    sll $t2, $s2, 2
    add $t2, $s0, $t2
    lw $t3, 0($t2)             # $t3 = array[maisLargo]

    ble $t1, $t3, check_maisLargo
    move $s2, $s4              # maisLargo = direita

check_maisLargo:
    #Se maisLargo != i, faz a troca e recursão 
    beq $s2, $a2, fim_heapify

    # Faz o troca entre array[i] e array[maisLargo]
    move $a0, $s0
    move $a1, $a2              # Índice i
    move $a2, $s2              # Índice maisLargo
    jal troca

    # Chama heapify recursivamente na subárvore afetada
    move $a0, $s0
    move $a1, $s1              # Tamanho do heap n
    move $a2, $s2              # Novo índice da raiz (maisLargo)
    jal heapify

fim_heapify:
    lw $s4, 0($sp)
    lw $s3, 4($sp)
    lw $s2, 8($sp)
    lw $s1, 12($sp)
    lw $s0, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    jr $ra

#####################################################################
# : troca
# Troca o valor de dois elementos no array
# Entradas:
#   $a0 = Endereço do array
#   $a1 = Índice 1
#   $a2 = Índice 2

troca:
    # Endereço de array[index1]
    sll $t0, $a1, 2
    add $t0, $a0, $t0

    # Endereço de array[index2]
    sll $t1, $a2, 2
    add $t1, $a0, $t1

    # Lê os valores
    lw $t2, 0($t0)
    lw $t3, 0($t1)

    # Escreve invertido
    sw $t3, 0($t0)
    sw $t2, 0($t1)

    jr $ra

#####################################################################
#  Auxiliar: print_array
# Imprime o array na tela

print_array:
    la $t0, array
    lw $t1, length
    li $t2, 0       # Índice de loop

print_loop:
    bge $t2, $t1, print_fim

    # Imprime array[i]
    sll $t3, $t2, 2
    add $t3, $t0, $t3
    lw $a0, 0($t3)
    li $v0, 1
    syscall

    # Imprime espaço em branco
    li $v0, 4
    la $a0, espaco
    syscall
    addi $t2, $t2, 1
    j print_loop

print_fim:
    li $v0, 4
    la $a0, novalinha
    syscall
    jr $ra
