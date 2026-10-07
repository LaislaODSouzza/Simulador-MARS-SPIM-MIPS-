
        .data
minha_pilha:    .word 0                      # topo = NULL (pilha vazia)
str_erro_mem:   .asciiz "Erro: sem memoria\n"
str_erro_vazia: .asciiz "Erro: pilha vazia\n"
str_inserido:   .asciiz "Inserido: "
str_removido:   .asciiz "Removido: "
str_atual:      .asciiz "Pilha atual: "
str_seta:       .asciiz " -> "
str_null:       .asciiz "NULL"
str_vazia:      .asciiz "[Vazia]"
str_nl:         .asciiz "\n"

        .text
        .globl main

# --------------------------------------------------------------
# main: empilha 10, 20, 30 e desempilha tres vezes
# $s0 guarda o endereco da pilha durante todo o programa
# --------------------------------------------------------------
main:
        la   $s0, minha_pilha

        # ---- empilhar(10) ----
        move $a0, $s0
        li   $a1, 10
        jal  empilhar
        la   $a0, str_inserido
        li   $a1, 10
        jal  imprimir_rotulo_valor
        move $a0, $s0
        jal  exibirPilha

        # ---- empilhar(20) ----
        move $a0, $s0
        li   $a1, 20
        jal  empilhar
        la   $a0, str_inserido
        li   $a1, 20
        jal  imprimir_rotulo_valor

        # ---- empilhar(30) ----
        move $a0, $s0
        li   $a1, 30
        jal  empilhar
        la   $a0, str_inserido
        li   $a1, 30
        jal  imprimir_rotulo_valor
        move $a0, $s0
        jal  exibirPilha

        # ---- desempilhar (remove 30) ----
        move $a0, $s0
        jal  desempilhar
        move $a1, $v0
        la   $a0, str_removido
        jal  imprimir_rotulo_valor
        move $a0, $s0
        jal  exibirPilha

        # ---- desempilhar (remove 20) ----
        move $a0, $s0
        jal  desempilhar
        move $a1, $v0
        la   $a0, str_removido
        jal  imprimir_rotulo_valor
        move $a0, $s0
        jal  exibirPilha

        # ---- desempilhar (remove 10) ----
        move $a0, $s0
        jal  desempilhar
        move $a1, $v0
        la   $a0, str_removido
        jal  imprimir_rotulo_valor
        move $a0, $s0
        jal  exibirPilha

        li   $v0, 10                         # syscall 10 = exit
        syscall

# --------------------------------------------------------------
# empilhar (Pilha* pilha, int valor)
#   $a0 = endereco da pilha, $a1 = valor
#   Prologo: frame de 16 bytes para $ra, $s0, $s1, $s2
# --------------------------------------------------------------
empilhar:
        addi $sp, $sp, -16
        sw   $ra, 12($sp)
        sw   $s0, 8($sp)
        sw   $s1, 4($sp)
        sw   $s2, 0($sp)

        move $s0, $a0                        # $s0 = pilha
        move $s1, $a1                        # $s1 = valor

        li   $a0, 8                          # um no = 8 bytes
        li   $v0, 9                          # syscall 9 = sbrk
        syscall
        beqz $v0, erro_memoria               # sem memoria?

        move $s2, $v0                        # $s2 = endereco do novo no
        sw   $s1, 0($s2)                     # no->dado = valor
        lw   $t0, 0($s0)                     # $t0 = topo atual
        sw   $t0, 4($s2)                     # no->proximo = topo antigo
        sw   $s2, 0($s0)                     # pilha->topo = novo no
        j    fim_empilhar

erro_memoria:
        la   $a0, str_erro_mem
        li   $v0, 4
        syscall

fim_empilhar:
        lw   $s2, 0($sp)                     # epilogo: restaura registradores
        lw   $s1, 4($sp)
        lw   $s0, 8($sp)
        lw   $ra, 12($sp)
        addi $sp, $sp, 16
        jr   $ra

# --------------------------------------------------------------
# desempilhar (Pilha* pilha)
#   $a0 = endereco da pilha; retorna o valor removido em $v0
#   Rotina folha (nao chama outras): nao precisa de frame de pilha
# --------------------------------------------------------------
desempilhar:
        lw   $t0, 0($a0)                     # $t0 = pilha->topo
        beqz $t0, pilha_vazia_erro           # topo == NULL?
        lw   $v0, 0($t0)                     # $v0 = topo->dado
        lw   $t1, 4($t0)                     # $t1 = topo->proximo
        sw   $t1, 0($a0)                     # pilha->topo = proximo
        jr   $ra

pilha_vazia_erro:
        la   $a0, str_erro_vazia
        li   $v0, 4
        syscall
        li   $v0, 0
        jr   $ra

# --------------------------------------------------------------
# exibirPilha (Pilha* pilha)
#   Percorre do topo ate NULL usando o ponteiro auxiliar $t0 (atual)
# --------------------------------------------------------------
exibirPilha:
        lw   $t0, 0($a0)                     # atual = pilha->topo
        la   $a0, str_atual
        li   $v0, 4
        syscall
        beqz $t0, exibir_vazia               # pilha vazia?

laco_exibir:
        beqz $t0, exibir_null                # atual == NULL? fim
        lw   $a0, 0($t0)                     # $a0 = atual->dado
        li   $v0, 1                          # syscall 1 = print int
        syscall
        la   $a0, str_seta
        li   $v0, 4
        syscall
        lw   $t0, 4($t0)                     # atual = atual->proximo
        j    laco_exibir

exibir_null:
        la   $a0, str_null
        li   $v0, 4
        syscall
        j    fim_exibir

exibir_vazia:
        la   $a0, str_vazia
        li   $v0, 4
        syscall

fim_exibir:
        la   $a0, str_nl
        li   $v0, 4
        syscall
        jr   $ra

# --------------------------------------------------------------
# imprimir_rotulo_valor: $a0 = string (rotulo), $a1 = inteiro
# --------------------------------------------------------------
imprimir_rotulo_valor:
        li   $v0, 4
        syscall                              # imprime o rotulo
        move $a0, $a1
        li   $v0, 1
        syscall                              # imprime o inteiro
        la   $a0, str_nl
        li   $v0, 4
        syscall
        jr   $ra
