# L8SelfModCode
# Author: Reagan Duggins
# Purpose: Practice writing self-modifying code


.data

enterN1:                  .asciiz               "Enter Num 1: "
enterN2:                  .asciiz               "Enter Num 2: "
sumEq:                    .asciiz               "Sum = "
newline:                  .asciiz               "\n"
num1:                     .word                 0
num2:                     .word                 0
sum:                      .word                 0
bye:                      .asciiz               "\nGoodbye!"
.text

###########################
# Procedure: print_string
# Arguments: $a0 contains address of string to put
# Return values: none
###########################
print_string:
	
	li $v0, 4    #load syscall for printing string
	syscall
	jr $ra       #return from procedure
	
############################
# Procedure: print_line
# Purpose: print a line
############################
print_line:
	la $a0, newline
	li $v0, 4
	syscall
	jr $ra
	
###########################
# Procedure: print_int
# Arguments: $a0 should contain int to print
# Returned Values: none
###########################
print_int:
	li $v0, 1
	syscall
	jr $ra
	
###########################
# Procedure: get_int
# Arguments: none
# returned values: $v0 will contain the integer entered on the keyboard
###########################
get_int:

	li $v0, 5  #syscall number of getting an int from keyboard
	syscall
	jr $ra     #return from program
	
	
###########################
# Procedure: add_to_and
# Arguments: none
# Returns: none
###########################
add_to_and:

	#la $t0, add_address            #load the address of the instruction
	li $t3, 0x01285024
	sw $t3, add_address
	
	li $t4, 0x20646E41
	sw $t4, sumEq###
	
	li $t4, 0x0000000203D
	sw $t4, sumEq + 4
	jr $ra
	
main:

	#prompt and get first number
	la $a0 enterN1
	jal print_string
	jal get_int
	sw $v0, num1
	#prompt and get second number
	la $a0 enterN2
	jal print_string
	jal get_int
	sw $v0, num2
	jal print_line
	#get, print and save the sum
	lw $t0, num1                    #t0 is num1
	lw $t1, num2                    #t1 is num2
	add_address:
	add $t2, $t1, $t0               #add the numbers into $t2
	la $a0, sumEq					#prepare string for printing
	jal print_string
	addi $a0, $t2, 0                #put sum into $a0 for printing
	jal print_int				    #print the string with a blank line underneath
	jal print_line
	jal print_line
	beq $t2, $0, end                #end the program if the sum/and is equal to zero
	sw $t2, sum                     #save sum into sum
	#if sum is 13 change add to and
	li $t3, 13                      #prepare 13 for subtracting
	beq $t3, $t2, if       #if sum is 13 go to the part that changes add to and
	
	j main
	
	
##############END################
end:
jal print_line
la $a0, bye
jal print_string
li $v0, 10
syscall

###############IF
#call add_to_and and go back to main
if:
jal add_to_and
j main