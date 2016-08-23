#Computer Organization Lab 2
#Author: Reagan Duggins
#Purpose: Take rainfall each month as user input, then display that, the average, total, and months with greatest and least rainfall

.data

jan:   .asciiz    "January"
feb:   .asciiz    "February"
mar:   .asciiz    "March"
apr:   .asciiz    "April"
may:   .asciiz    "May"
jun:   .asciiz    "June"
jul:   .asciiz    "July"
aug:   .asciiz    "August"
sep:   .asciiz    "September"
oct:   .asciiz    "October"
nov:   .asciiz    "November"
dec:   .asciiz    "December"
col:   .asciiz    ": "
at:    .asciiz    " at "
inches: .asciiz   " inches.\n"

months:  .word    jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec

in_prompt:   .asciiz  "Please enter rainfall total for month "
tot_str:     .asciiz  "\nYearlong Total of Rainfall: "
avg_str:     .asciiz  "\nAverage Rainfall: "
highest_str: .asciiz  "\nMonth with greatest rainfall: "
least_str:   .asciiz  "Month with least rainfall: "

highest_rain: .word     0
highest_rain_month:  .word  0
least_rain:   .word     10000      # set to 10000 so that it is greater than any realistic rain amounts
least_rain_month: .word 0
total_rain:    .word    0
avg_rain:      .word    0
month:         .space   9

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
	jr $ra     #return from program
	
	
	
###########################
# Procedure: print_month
# Arguments: $a0 -> number of month to print (jan is 0)
# returned values: none
###########################
print_month:

	#push $ra so print_string can be called
	subu $sp, $sp, 4   # make room for $ra on the stack
	sw $ra, 4($sp)     # push $ra on the stack
	li $t7, 0
	beq $t7, $a0, january       #if month is 0 print january
	addi $t7, $t7, 1  # $t7++;
	beq $t7, $a0, february      #if month is 1 print february
	addi $t7, $t7, 1  # $t7++;
	beq $t7, $a0, march         #if month is 2 print march
	addi $t7, $t7, 1  # $t7++;
	beq $t7, $a0, april         #if month is 3 print april
	addi $t7, $t7, 1  # $t7++;
	beq $t7, $a0, month_may           #if month is 4 print may
	addi $t7, $t7, 1  # $t7++;
	beq $t7, $a0, june          #if month is 5 print june
	addi $t7, $t7, 1  # $t7++;
	beq $t7, $a0, july          #if month is 6 print july
	addi $t7, $t7, 1  # $t7++;
	beq $t7, $a0, august        #if month is 7 print august
	addi $t7, $t7, 1  # $t7++;
	beq $t7, $a0, september     #if month is 8 print september
	addi $t7, $t7, 1  # $t7++;
	beq $t7, $a0, october       #if month is 9 print october
	addi $t7, $t7, 1  # $t7++;
	beq $t7, $a0, november     #if month is 10 print november
	addi $t7, $t7, 1  # $t7++;
	beq $t7, $a0, december     # if month is 11 print december
	addi $t7, $t7, 1  # $t7++;
	
	january:
		
		la $a0, jan        #load the month string
		jal print_string
		j end_print_month
	
	february:
	
		la $a0, feb        #load the month string
		jal print_string
		j end_print_month
	
	march:
	
		la $a0, mar        #load the month string
		jal print_string
		j end_print_month
	
	april:
	
		la $a0, apr        #load the month string
		jal print_string
		j end_print_month
	
	month_may: #named this because a may lable already exists
	
		la $a0, may        #load the month string
		jal print_string
		j end_print_month
	
	june:
	
		la $a0, jun        #load the month string
		jal print_string
		j end_print_month
	
	july:
	
		la $a0, jul        #load the month string
		jal print_string
		j end_print_month
	
	august:
	
		la $a0, aug        #load the month string
		jal print_string
		j end_print_month
	
	september:
	
		la $a0, sep        #load the month string
		jal print_string
		j end_print_month
	
	october:
	
		la $a0, oct        #load the month string
		jal print_string
		j end_print_month
	
	november:
	
		la $a0, nov        #load the month string
		jal print_string
		j end_print_month
	
	december:
	
		la $a0, dec        #load the month string
		jal print_string
		j end_print_month
	
	end_print_month:
	
		lw $ra, 4($sp)     #pop $ra
		addu $sp, $sp, 4   #pop $ra
		jr $ra
	
	
	
	
	
#############################MAIN######################################
main:

	
	li $t0, 0            # $t0 is the total counter
	li $t1, 0            # $t1 is the iterator
	input_loop:
		
		la $a0, in_prompt    # load the prompt
		jal print_string     # print the prompt
		addi $a0, $t1, 0     # load number of month
		jal print_month		 # print the month
		
		la $a0, col          # load a colon
		jal print_string     # print a colon
		jal get_integer      # get the rainfall amount
		add $t0, $t0, $v0    # add the month's rainfall amount to the current total
		
		
		### set highest rainfall month if necessary ###
			lw $t3, highest_rain          # load highest rain so far
			sub $t2, $v0, $t3             # subtract this highest month rain so far from this month's rain
			blt $t2, $zero, not_highest   # skip assignment if shouldn't assign
			
			sw $v0, highest_rain          #set highest_rain to current value
			sw $t1, highest_rain_month    # set highest month to current month
			
		not_highest:
		
		### set lowest rainfall month if necessary ###
			lw $t3, least_rain             #load lowest rain amount
			sub $t2, $t3, $v0              #subtract this month's rain from lowest amount
			bltz $t2, not_lowest
			
			sw $v0, least_rain             #set least_rain to current rain amount
			sw $t1, least_rain_month       #set lowest_rain_month to this month
		
		
		not_lowest:
		
		addi $t1, $t1, 1     # i++
		bne $t1, 12, input_loop   #if you aren't on 12th month then keep looping
		
		
	# print total rainfall
	la $a0, tot_str
	jal print_string
	add $a0, $t0, $zero    
	jal print_int
	
	# calculate and print average rainfall
	li $t5, 12
	div $t0, $t5            # tot/num_months
	la $a0, avg_str
	jal print_string
	mflo $a0     # prepare average for printing
	jal print_int
	
	# print highest rainfall
	la $a0, highest_str     #load string to print
	jal print_string
	
	lw $a0, highest_rain_month  #load month to print
	jal print_month
	la $a0, at   #finish the sentence now
	jal print_string
	lw $a0, highest_rain
	jal print_int
	la $a0, inches
	jal print_string
	
	# print lowest rainfall
	la $a0, least_str     #load string to print
	jal print_string
	
	lw $a0, least_rain_month  #load month to print
	jal print_month
	la $a0, at   #finish the sentence now
	jal print_string
	lw $a0, least_rain
	jal print_int
	la $a0, inches
	jal print_string
	
	
	
		
	
	
	
#########END###########
li $v0, 10
syscall