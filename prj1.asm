# Declare main as a global function
.globl main 

# All program code is placed after the
# .text assembler directive
.text 		

# The label 'main' represents the starting point
main:
	la $a0, arr	# $a0 based address of array
	li $a1, 4	# $a1 number to be found (checked) - change the value (7) to test
	li $a2, 3	# $a2 max array index to be checked - change the value (3) to test
	jal lookup
	li	$v0, 1
	add $a0, $v1, $zero
	syscall
	li	$v0,10		# Code for syscall: exit
	syscall
	# Write your code below
	# -------------------------------------------------

lookup:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	add $t0, $zero, $zero
	add $t1, $zero, $zero
	add $t2, $zero, $zero
loop:
	bge $t0, $a2, not_found
	sll $t1, $t0, 2
	add $t2, $t1, $a0
	lw $t2, 0($t2)
	beq $a1, $t2, found
	addi $t0, $t0, 1
	J loop
not_found:
	li $v1, -1
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	JR $ra
found:
	add $v1, $zero, $t0
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	JR $ra
	# -------------------------------------------------
	# End of your code

# All memory structures are placed after the
# .data assembler directive
.data
arr:		.word 5, 2, 1, 4, 6, 3		# change array to test
str_found:	.asciiz	"found"
str_not_found:	.asciiz	"not_found"
