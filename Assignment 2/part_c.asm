#########################################################
# Alwien Dippenaar					
# V00849850						
# CSC 350 Assignment 2 Part C				
# March 11th, 2019					
#########################################################

# Constants, strings, to be used in all part of the
# CSC 350 (Spring 2019) A#2 submissions

# These are similar to #define statements in a C program.
# However, the .eqv directions *cannot* include arithmetic.

.eqv  MAX_WORD_LEN 32
.eqv  MAX_WORD_LEN_SHIFT 5
.eqv  MAX_NUM_WORDS 100
.eqv  WORD_ARRAY_SIZE 3200  # MAX_WORD_LEN * MAX_NUM_WORDS
.eqv NEW_LINE_ASCII 10


# Global data

.data
WORD_ARRAY: 	.space WORD_ARRAY_SIZE
NUM_WORDS: 	.space 4
MESSAGE1:	.asciiz "Number of words in string array: "
MESSAGE2:	.asciiz "Contents of string arrayr:\n"
MESSAGE3:	.asciiz "Enter strings (blank string indicates end):\n"
SPACE:		.asciiz " "
NEW_LINE:	.asciiz "\n"
EMPTY_LINE:	.asciiz ""

# For strcmp testing...
MESSAGE_A:	.asciiz "Enter first word: "
MESSAGE_B:	.asciiz "Enter second word: "
BUFFER_A:	.space MAX_WORD_LEN
BUFFER_B:	.space MAX_WORD_LEN

	.text
#####
#####	
INIT:
	# Save $s0, $s1 and $s2 on stack.
	addi $t0, $sp, 12
	sub $sp, $sp, $t0
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	
	la $a0, MESSAGE3
	li $v0, 4
	syscall
	
	# Initialize NUM_WORDS to zero.
	#
	# Load start of word array into $s0; we'll directly read
	# input words into this array/buffer. 
	la $t0, NUM_WORDS
	sw $zero, 0($t0)
	la $s0, WORD_ARRAY
		
READ_WORD:
	add $a0, $s0, $zero
	li $a1, MAX_WORD_LEN
	li $v0, 8
	syscall
	
	# Empty string? If so, finish. An emtpy string
	# consists of the single newline character.
	lbu $t0, 0($s0)
	li $t1, NEW_LINE_ASCII
	beq $t0, $t1, CALL_QUICKSORT
	
	# Increment # of words; at the maximum??
	la $t0, NUM_WORDS
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)
	addi $t2, $zero, MAX_NUM_WORDS
	beq $t1, $t2, CALL_QUICKSORT
	
	# Otherwise proceed to the next work
	addi $s0, $s0, MAX_WORD_LEN
	j READ_WORD
	

	
CALL_QUICKSORT:	
	# Before call to quicksort
	jal FUNCTION_PRINT_WORDS
	
	# Assemble arguments
	la $a0, WORD_ARRAY
	li $a1, 0
	la $t0, NUM_WORDS
	lw $a2, 0($t0)
	addi $a2, $a2, -1
	jal FUNCTION_HOARE_QUICKSORT
			
	# Restore from stack the callee-save registers used in this code
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	# After call to quicksort
	jal FUNCTION_PRINT_WORDS

EXIT:
	li $v0, 10
	syscall
		
#####
#####	
FUNCTION_PRINT_WORDS:
	la $a0, MESSAGE1
	li $v0, 4
	syscall
	
	la $t0, NUM_WORDS
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	la $a0, NEW_LINE
	li $v0, 4
	syscall
	
	la $a0, MESSAGE2
	li $v0, 4
	syscall
	
	li $t0, 0
	la $t1, WORD_ARRAY
	la $t2, NUM_WORDS
	lw $t2, 0($t2)
	
LOOP_FPW:
	beq $t0, $t2, EXIT_FPW
	add $a0, $t1, $zero
	li $v0, 4
	syscall
	addi $t0, $t0, 1
	addi $t1, $t1, MAX_WORD_LEN
	j LOOP_FPW
	
EXIT_FPW:
	jr $ra
	
##########################################################
#
# YOUR SOLUTION MAY NOT ADD MORE GLOBAL DATA OR CONSTANTS.
# ALL OF THE CODE FOR YOUR FUNCTION(S) MUST APPEAR AFTER
# THIS POINT. SUBMISSIONS THAT IGNORE THIS REQUIREMENT
# MAY NOT BE ACCEPTED FOR EVALUATION.
#
##########################################################

#
# Solution for FUNCTION_PARTITION.
#
# $a0 contains the starting address of the array of strings,
# where each string occupies up to MAX_WORD_LEN chars.
# $a1 contains the starting index for the partition
# $a2 contains the ending index for the partition
# $v0 contains the index that is to be returned by the
# partition algorithm
#
FUNCTION_PARTITION:
	blt	$a2,	$a1,	QUIT_PART
	beq	$a1,	$t7,	QUIT_PART

	addi	$sp,	$sp,	-16	# Increase stack 

	sw	$a0,	12($sp)		# Store starting address of the array of strings
	sb	$a1,	8($sp)		# Store the starting index
	sb	$a2,	4($sp)		# Store the ending index
	div	$t2,	$t7,	2	# Pivot point
	add	$t3,	$zero,	$zero	# Counter

	la 	$t0,	($a0)
	j	GET_CHAR1		# Address at $a1 will be in $t0
	RETURN1:			

	la 	$t1,	($t0)
	j	GET_CHAR2		# Address at $a2 will be in $t1 and pivot in $t2
	RETURN2:

	add	$a0,	$zero,	$t0	# Load address for string at index $a1
	add	$a1,	$zero,	$t1	# Load address for string at index $a2

	j	PARTITION

GET_CHAR1:
 	beq	$t3,	$a1,	RETURN1
 	addi	$t0,	$t0,	32
 	addi,	$t3,	$t3,	1
  	j	GET_CHAR1 

GET_CHAR2:
 	beq	$t3,	$a2,	RETURN2
 	beq	$t2,	$t3,	GET_PIVOT
 	RETURN3:
 	addi	$t1,	$t1,	32
 	addi,	$t3,	$t3,	1
  	j	GET_CHAR2

GET_PIVOT:
	lb	$t2,	($t1)
	j	RETURN3

QUIT_PART:
   	jr 	$ra

PARTITION:
	j	FUNCTION_STRCMP

	RETURN4:

	beq	$v0,	-1,	INC1	# Increment $a1
	beq	$v0,	0,	INC1	# Increment $a1
	beq 	$v0,	1,	FUNCTION_SWAP

	RETURN5:

	lb	$a2,	4($sp)
	lb	$a1,	8($sp)
	lw	$a0,	12($sp)
	addi	$sp,	$sp,	16
	j	FUNCTION_PARTITION

INC1:
	lb	$a1,	8($sp)
	addi	$a1,	$a1,	1
	sb	$a1,	8($sp)

	j	RETURN5 

INC2:	
	lb	$a1,	8($sp)
	lb	$a2,	4($sp)
	addi	$a1,	$a1,	1
	addi	$a2,	$a2,	-1
	sb	$a2,	4($sp)
	sb	$a1,	8($sp)
	j	RETURN5

QUIT_P_LOOP:
	add	$t1,	$zero,	$t4
	j	PARTITION
#
# Solution for FUNCTION_HOARE_QUICKSORT.
#
# $a0 contains the starting address of the array of strings,	A
# where each string occupies up to MAX_WORD_LEN chars.
# $a1 contains the starting index for the quicksort		lo
# $a2 contains the ending index for the quicksort		hi
#
# THIS FUNCTION MUST BE WRITTEN IN A RECURSIVE STYLE.
#
FUNCTION_HOARE_QUICKSORT:
	addi	$sp,	$sp,	-8	# Save stack
	sw	$ra,	4($sp)	
	add	$t7,	$zero,	$a2
QUICKSORT_LOOP:
	sw	$a0,	0($sp)		# Store the starting address	

	jal	FUNCTION_PARTITION

	add	$t5,	$a0,	$zero
	j	CHECK_ORDER

CHECK_ORDER:
	lbu	$t0,	($t5)
	lbu	$t1,	32($t5)
	blt	$t0,	$t1,	EXIT_QUICKSORT
	# gets past this then should change back values of $a1 and $a2
	add	$a1,	$zero,	$zero
	add	$a2,	$t7,	$zero
	blt	$t1,	$t0,	QUICKSORT_LOOP

EXIT_QUICKSORT:
	addi	$t5,	$t5,	32
#	bne	$t1,	$zero,	CHECK_ORDER	# Not yet at end of string array --- take this out to have it halt
	lw	$ra,	4($sp)
	addi	$sp,	$sp,	8
	jr 	$ra

#
# Solution for FUNCTION_STRCMP.
#
# $a0 contains the address of the first string
# $a1 contains the address of the second string
# $v0 will contain the result of the function.
#
FUNCTION_STRCMP:
	addi	$sp,	$sp,	-4
	sb	$t2,	0($sp)
STR_CMP_LOOP:
	lb 	$t0, 	($a0)		# Load next char from S1
	lb 	$t1, 	($a1)		# Load next char from S2

	bne 	$t0, 	$t1, 	CMP_NOT_EQ
	beq	$t0, 	$zero, 	CMP_EQ	# At end of string, they are equal

	addi	$a0, 	$a0,	1	# Next char for S1
	addi 	$a1, 	$a1, 	1	# Next char for S2

	j	STR_CMP_LOOP

# decide if char for S1 is greater or less than char for S2
CMP_NOT_EQ:
	slt	$t3, 	$t0, 	$t2
	slt	$t4,	$t1,	$t2	

	beq	$t3, 	1, 	TEST1	# $t1 > $t2
	beq	$t3, 	$zero,	CMP_G

# char for S1 is greater than char for S2		
CMP_G:
	li 	$v0, 	1
	lb	$t2,	0($sp)
	addi	$sp,	$sp,	4
	j	RETURN4

# char for S1 is less than char for S2
CMP_L:
	li 	$v0, 	-1
	lb	$t2,	0($sp)
	addi	$sp,	$sp,	4
	j	RETURN4

# The strings are equal
CMP_EQ:
	li	$v0, 	0
	lb	$t2,	0($sp)
	addi	$sp,	$sp,	4
	j	RETURN4

#TEST0:
#	beq	$t3,	$t4,	CMP_G
#	bne	$t3,	$t4,	CMP_EQ

TEST1:
	beq	$t3,	$t4,	CMP_L
	bne	$t3,	$t4,	CMP_EQ
#
# Solution for FUNCTION_SWAP.
#
# $a0 contains the address of the first string array
# $a1 contains the address of the second string array
# $a2 contains the maximum length of the arrays
# 	
FUNCTION_SWAP:
	addi	$sp,	$sp,	-4	# Increase the size of stack for one item
	addi	$t1,	$zero,	1	# Word length counter
SWAP_LOOP:
	j	SWAP			# Swap the chars
	RET:
	beq	$t0,	$zero,	QUIT_FUNC

	addi	$a0,	$a0,	1	# Go to next char address
	addi	$a1,	$a1,	1	# Go to next char address
	
	addi	$t1,	$t1,	1	# Increment counter

	j 	SWAP_LOOP

SWAP:
	lbu	$t0,	($a0)		# get char of S1
	sb	$t0,	0($sp)		# push char of S1 on stack
	lbu	$t0,	($a1)		# get char of S2
	sb	$t0,	($a0)		# store char of S2 in S1
	lbu	$t0,	0($sp)		# pop char of S1
	sb	$t0,	($a1)		# store char of S1 in S2

	j	RET

QUIT_FUNC:
	add	$sp,	$sp,	4	# Decrease the size of stack
	j	INC2
