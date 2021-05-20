# All memory structures are placed after the
# .data assembler directive
.data
arr:		.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

# Declare main as a global function
.globl main 

# All program code is placed after the
# .text assembler directive
.text 		

# The label 'main' represents the starting point
main:
	la $a0, arr	# $a0 based address of array
	li $a1, 9	# $a1 how many numbers are generated? change the value to test

	jal generate_random
	add $t0, $0, $0
	add $t1, $0, $0
	la $t2, arr	#t2 has address of arr
printval:
	bge $t0, $a1, nomore
	lw $t1, 0($t2)
	addi $t2, $t2, 4
	li $v0, 1
	move $a0, $t1
	syscall
	li $a0, 32
    	li $v0, 11  
    	syscall
    	addi $t0, $t0, 1
    	J printval
nomore:
	li $v0, 10
    	syscall

	#Write your code here
	#You must print (show) the numbers generated after the function call. 
	#In generate_random function, use your lookup function to avoid duplicated numbers. 


generate_random:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	add $t7, $0, $0 	#counter
	move $t5, $a0 		#t5 is address of arr
findunique:
	lw $a1, 8($sp)
	bgt $t7, $a1, done
	li $a1, 10  #max bound
    	li $v0, 42  #generates the random number
    	syscall
    	
    	add $t6, $a0, $0 	#$t6 is rand num
    				
	lw $a2, 8($sp)		#get values ready for lookup function
	lw $a0, 4($sp)
	move $a1, $t6
	
	jal lookup
	
	beq $v0, -1, unique	#unique if return equal to -1
	J findunique		#if not unique, find new number
unique:
    	sw $t6, 0($t5)		#save unique number
    	addi $t5, $t5, 4
    	addi $t7, $t7, 1
    	J findunique		#find new number
done:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	jr $ra

	#jal lookup

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
	li $v0, -1
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	JR $ra
found:
	add $v0, $zero, $t0
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	JR $ra
