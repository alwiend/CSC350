#########################################################
# Alwien Dippenaar					
# V00849850						
# CSC 350 Assignment 2 Part B				
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


#
# Driver code.
#

	.text
	# Read in the first word...
	la $a0, MESSAGE_A
	li $v0, 4
	syscall
	la $a0, BUFFER_A
	li $a1, MAX_WORD_LEN
	li $v0, 8
	syscall
	
	# Read in the second word...
	la $a0, MESSAGE_B
	li $v0, 4
	syscall
	la $a0, BUFFER_B
	li $a1, MAX_WORD_LEN
	li $v0, 8
	syscall

	
	# Perform the swap
	la $a0, BUFFER_A
	la $a1, BUFFER_B
	li $a2, MAX_WORD_LEN
	jal FUNCTION_SWAP
	
	# Print string in BUFFER_A, BUFFER_B
	la $a0, BUFFER_A
	li $v0, 4
	syscall
	la $a0, NEW_LINE
	li $v0, 4
	syscall
	la $a0, BUFFER_B
	li $v0, 4
	syscall
	la $a0, NEW_LINE
	li $v0, 4
	syscall
	
	# Get outta here!	
EXIT:
	li $v0, 10
	syscall
	
	
##########################################################
#
# YOUR SOLUTION MAY NOT ADD MORE GLOBAL DATA OR CONSTANTS.
# ALL OF THE CODE FOR YOUR FUNCTION(S) MUST APPEAR AFTER
# THIS POINT. SUBMISSIONS THAT IGNORE THIS REQUIREMENT
# MAY NOT BE ACCEPTED FOR EVALUATION.
#
##########################################################


#
# $a0 contains the address of the first string array
# $a1 contains the address of the second string array
# $a2 contains the maximum length of the arrays
# 
FUNCTION_SWAP:
	sub	$sp,	$sp,	4	# Increase the size of stack for one item
	addi	$t1,	$zero,	1	# Word length counter
SWAP_LOOP:
	
	j	SWAP			# Swap the chars
	RET:
	beq	$t1,	$a2,	QUIT_FUNC
	
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
	jr	$ra	
