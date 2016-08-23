#File L3Recursion.s

.data

a0:         .word         3,4,9,2,126,35,489,51,23,548,354,1,2
len_a0:     .word         13
tmp:        .word         0
string:     .asciiz       "Largest Number: " 


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
# Procedure: get_integer
# Arguments: none
# returned values: $v0 will contain the integer entered on the keyboard
###########################
get_integer:

	li $v0, 5  #syscall number of getting an int from keyboard
	syscall
	jr $ra     #return to program
	


###############
# Procedure: get_from_array
# Args: $a0 array address, $a1 array index
# Returns: $v0 value in array at given index
# Purpose: returns the specified index's value in the given array
###############
get_from_array:

	li $t2, 4         #load 32 into $t2
	mult $a1, $t2     #get offset from index
	mflo $t1          #put result in $t1
	add $t0, $a0, $t1 #add offset to address
	lw $v0, ($t0)     #load value from array
	
	jr $ra




#######################
# Procedure: maxaux
# Arguments: $a0 array address, $a1 k first index, $a2 n second index
# Returns: $v0 highest value in this subsection of the array
# Purpose: Returns the highest value in the given array via recursion
#######################
maxaux:

	subu $sp, $sp, 8         # make room for $ra and all args on the stack
	sw $ra, 0($sp)           # push $ra on the stack
	sw $a1, 4($sp)           # push k
	
	li $t6, 8                #put the value 8 into $t6
	
	sub $t7, $a2, $t6         # put n-1 into $t7
	beq $t7, $a1, base_case
	
		#get the kth value from the array and put it in $v0 (it should be there when the get method ends)
		jal get_from_array
		#return to previous call
		#right now $v0 has the kth element of the array
		addi $t4, $v0, 0       #now $t4 has kth element of array
		addi $a1, $a1, 1       #k = k+1
		jal maxaux    #recurse   #maxaux(a[], k+1, n)
		sub $t5, $t4, $v0 #subtract temp from a[k]     #///////////////
		
		bgtz $t5, temp_is_greater   # if $t5 is greater than zero then return temp else return a[k]
			
			lw $ra, ($sp)            #load the return address to return
			addi $sp, 8        #pop $ra and $a1
			jr $ra
		
		
		temp_is_greater:
			li $v0, 0
			addi $v0, $t4, 0
			
			lw $ra, ($sp)            #load the return address to return
			addi $sp, 8        #pop $ra and $a1
			jr $ra
		
		lw $ra, ($sp)            #load the return address to return
		addi $sp, 8        #pop $ra and $a1
		jr $ra
		
	base_case:
		jal get_from_array
		lw $ra, ($sp)            #load the return address to return
		addi $sp, 8        #pop $ra and $a1
		jr $ra
	
	#return to main
	lw $ra, ($sp)            #load the final return address to return to main
	jr $ra
	
##########################
# Procedure: max
# Arguments: $a0 array address, $a1 k first index, $a2 n second index
# Returns: $v0 highest value in this array
# Purpose: I do not exactly know, it seems to only call the maxaux function
##########################
max:
	subu $sp, $sp, 4         # make room for $ra on the stack
	sw $ra, 0($sp)           # push $ra on the stack
	
	jal maxaux               #call maxaux
	
	lw $ra, 0($sp)           #load return address
	addi $sp, 4              #pop the $ra off the stacks
	jr $ra                   #return to main





#############################MAIN#####################################
main:
	#load args for max and call it
	la $a0, a0
	li $a1, 0
	lw $a2, len_a0
	jal max
	
	#print the result number
	sw $v0, tmp
	la $a0, string
	jal print_string
	lw $a0, tmp
	jal print_int





############End Program#################
	li $v0, 10
	syscall