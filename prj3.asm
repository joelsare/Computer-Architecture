# All memory structures are placed after the
# .data assembler directive
.data
arr:		.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
guessarr:	.word 0, 0, 0
st : 		.asciiz "Enter numbers on seperate lines:"
strike : 	.asciiz " strike "
ball : 		.asciiz " ball "
out : 		.asciiz "out"
newline:	.asciiz "\n"
goodjob:	.asciiz "Good Job!\n"
input: 		.word 0,0,0,0,0


# Declare main as a global function
.globl main 

# All program code is placed after the
# .text assembler directive
.text 		

# The label 'main' represents the starting point
main:
	la $a0, arr	# $a0 based address of array
	li $a1, 3	# $a1 how many numbers are generated? change the value to test

	jal generate_random
	add $t0, $0, $0
	add $t1, $0, $0
	la $t2, arr		#t2 has address of arr
	jal printval		#print array
	
	add $t3, $0, $0		#ball counter
	add $t4, $0, $0		#strike counter
    	jal whileloop		#whole program is in this loop
    	
	li $v0,10
    	syscall
    	
populate:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0,st
	li $v0,4
	syscall			#print "Enter numbers on seperate lines:"
	
	la $a0,newline
	li $v0,4
	syscall			#print newline
	
	li $v0, 8
	la $a0, input
	li $a1, 100
	syscall
	la $t7, input
	lbu $t0, ($t7)
	addi $t0, $t0, -48
	addi $t7, $t7, 2
	
	lbu $t1, ($t7)
	addi $t1, $t1, -48
	addi $t7, $t7, 2
	
	lbu $t2, ($t7)
	addi $t2, $t2, -48
	addi $t7, $t7, 2

	#li $v0, 5 		#read integer 
	#syscall
	#add $t0, $v0, $zero

	#li $v0, 5 		#read integer 
	#syscall
	#add $t1, $v0, $zero

	#li $v0, 5 		#read integer 
	#syscall
	#add $t2, $v0, $zero
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
whileloop:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal populate

	la $t5, arr			#t5 has address of target array
	
	lw $t6, 0($t5)			#t6 = arr[0]
	bne $t0, $t6, anotstrike	#if(a != arr[0])
	addi $t4, $t4, 1
anotstrike:
	lw $t6, 4($t5)			#t6 = arr[1]
	beq $t0, $t6, aball		#if(a == arr[1])
	lw $t6, 8($t5)			#t6 = arr[2]
	beq $t0, $t6, aball		#if(a == arr[2])
	j anotball
aball:
	addi $t3, $t3, 1
anotball:

	lw $t6, 4($t5)			#t6 = arr[0]
	bne $t1, $t6, bnotstrike	#if(b != arr[1])
	addi $t4, $t4, 1
bnotstrike:
	lw $t6, 0($t5)			#t6 = arr[0]
	beq $t1, $t6, bball		#if(b == arr[1])
	lw $t6, 8($t5)			#t6 = arr[2]
	beq $t1, $t6, bball		#if(b == arr[2])
	j bnotball
bball:
	addi $t3, $t3, 1
bnotball:

	lw $t6, 8($t5)			#t6 = arr[2]
	bne $t2, $t6, cnotstrike	#if(c != arr[2])
	addi $t4, $t4, 1
cnotstrike:
	lw $t6, 0($t5)			#t6 = arr[0]
	beq $t2, $t6, cball		#if(c == arr[0])
	lw $t6, 4($t5)			#t6 = arr[1]
	beq $t2, $t6, cball		#if(c == arr[1])
	j cnotball
cball:
	addi $t3, $t3, 1
cnotball:
check:
	beq $t4, 3, closeprogram
	beq $t3, 0, noball
	li $v0, 1
	move $a0, $t3			#print ball value
	syscall
	
	li $v0, 4
	la $a0, ball			#print ball value
	syscall
noball:
	beq $t4, 0, nostrike
	li $v0, 1
	move $a0, $t4			#print strike value
	syscall
	
	li $v0, 4
	la $a0, strike			#print strike value
	syscall
nostrike:
	bne $t3, 0, somethinghasvalue
	bne $t4, 0, somethinghasvalue
	li $v0, 4
	la $a0, out			#print out
	syscall
somethinghasvalue:
	li $v0, 4
	la $a0, newline
	syscall
	
	
	add $t3, $0, $0
	add $t4, $0, $0
	
	j whileloop
	
closeprogram:
	li $v0, 4
	la $a0, goodjob
	syscall
	li $v0,10
    	syscall
	
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
	li $v0, 4
	la $a0, newline
	syscall
	jr $ra

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
