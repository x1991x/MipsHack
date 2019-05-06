# Jie Dai
# jidai
# 111648788

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

# Part I
#@Parameter
#$a0 = map filename
#$a1 = map ptr
#$a2 = player ptr
#@Return 
#	$v0
init_game:
	addi $sp, $sp, -24	#init_game:
	sw $a0, ($sp)	#map_filename
	sw $a1, 4($sp)	#map
	sw $a2, 8($sp)	#player
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)	
	li $v0, 13	# Open File
	li $a1, 0
	li $a2, 0
	syscall
	bltz $v0, part_one_return_error
	move $t0, $v0
	li $v0, 14	#Read from File
	move $a0, $t0	#$a0 = file descriptor
	lw  $a1, 4($sp)	#$a1 = load map address
	li $a2, 6		#$a2 = # of characters to read
	syscall
#read row_number		
	lbu $t0, ($a1)	#$t0 = the first digit
	addi $t0, $t0, -48 
	addi $a1, $a1, 1
	lbu $t1, ($a1)	#$t1 = the second digit
	addi $t1, $t1, -48
	addi $a1, $a1, 2 			
#read colum_number
	lbu $t2, ($a1)	#$t2 = the first digit
	addi $t2, $t2, -48
	addi $a1, $a1, 1	
	lbu $t3, ($a1)	#$t3 = the second digit
	addi $t3, $t3, -48
#calculation
	li $t4, 10		#$t4 = 10;
	mul $s0, $t0, $t4
	add $s0, $s0, $t1	#$s0 = row_number
	mul $s1, $t2, $t4
	add $s1, $s1, $t3#$s1 = colum_number
	addi $t1, $s1, 1
	mul $t0, $s0, $t1	#$t0 = map_size
	addi $t0, $t0, 2	#$t0 = map_size + two health characters	
	lw $t1, 4($sp)	#$t1 = map_stru
	lw $t6, 8($sp)	#$t6 = player stru
	sb $s0, ($t1)	#save row_number into map
	addi $t1, $t1, 1
	sb $s1, ($t1)	#save colum_number into map
	addi $t1, $t1, 1

	subu $sp, $sp, $t0 #allocate  spcae in stack 
	move  $a1, $sp	#$a1 = load buffer address
	move  $a2, $t0	#$a2 = # of characters to read
	li $v0, 14
	syscall 
			
#@Parameter
#$a1 = $sp = load buffer address
#$a2 =  $t0 = map_size + health characters
#$t1 = map_addr
#$t2 = row pt = 0
#$t3 = colum pt = 0
#$t4 = char
#$t5 = '@'
#$t6 = player stru
#$s0 = row_number
#$s1 = colum_number
#@Return
#	player stru
#	map stru
	li $t2, 0	#$t2 = row pt= 0
	li $t5, '@'	#$t5 = '@'
part_one_read_map_loop:	
	bge $t2, $s0, part_one_read_map_loop_end	#if row_pt >= row num, outter loop ends
	li $t3, 0	#$t3 = colum pt= 0
part_one_read_map_inner_loop:
	bge $t3, $s1, part_one_read_map_inner_loop_end #if colum pt >= colum num, inner loop ends
	lbu $t4, ($sp)	
	beq $t4, $t5, part_one_get_player_pos
	addi $t4, $t4, 128	#set the hidden flag
	sb $t4, ($t1)	#sb from buffer into map	
	addi $sp, $sp, 1	#buffer_addr ++
	addi $t1, $t1, 1	#map_addr ++
	addi $t3, $t3, 1	#colum_pt ++
	j part_one_read_map_inner_loop	
part_one_read_map_inner_loop_end:
	addi $sp, $sp, 1	#buffer_addr += 1 (skip character '\n')
	addi $t2, $t2, 1	#row pt++
	j part_one_read_map_loop
	
part_one_read_map_loop_end:
#read health
	lbu $t7, ($sp)		#part_one_read_map_loop_end; #read health
	addi $t7, $t7, -48	#$t7 = the first digit of health number
	addi $sp, $sp, 1
	lbu $t8, ($sp)	
	addi $t8, $t8, -48	#$t8 = the second digit of health number
	li $t4, 10
	mul $t7, $t7, $t4		#$t7 = the first digit * 10
	add $s2, $t7, $t8		#$s2 = health number
	addi $sp, $sp, 1		#restore $sp
	sb $s2, 2($t6)		#store health number into player stru
	li $t4, 0
	sb $t4, 3($t6)		#initialize player coins to 0
part_one_end:
	li $v0, 16	#close file
	syscall	
	lw $a0, ($sp)	#map_filename
	lw $a1, 4($sp)	#map
	lw $a2, 8($sp)	#player
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	addi $sp, $sp, 24	#init_game:
	li $v0, 0
	jr $ra

part_one_get_player_pos:
	addi $t4, $t4, 128	#part_one_get_player_pos:set the hidden flag
	sb $t2, ($t6)	#save row into player stru
	sb $t3, 1($t6)	#save col into player stru
	sb $t4, ($t1)	#sb from buffer into map
	addi $sp, $sp, 1	#buffer_addr ++
	addi $t1, $t1, 1	#map_addr ++
	addi $t3, $t3, 1	#colum_pt ++
	j part_one_read_map_inner_loop	

part_one_return_error:	
	lw $a0, ($sp)	#map_filename
	lw $a1, 4($sp)	#map
	lw $a2, 8($sp)	#player
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	addi $sp, $sp, 24	
	li $v0, -1
	jr $ra
			
# Part II
#@Parameter
#$a0 = map_stru
#$a1 = row_index
#$a2 = colum_index
#@Return
#	$v0
is_valid_cell:
	bltz $a1, part_two_error
	bltz $a2, part_two_error
	lbu $t0, ($a0)	#$t0 = row_number
	lbu $t1, 1($a0)	#$t0 = colum_number
	bge $a1, $t0, part_two_error
	bge $a2, $t1, part_two_error
	li $v0, 0
	jr $ra

part_two_error:
	li $v0, -1
	jr $ra

# Part III
#@Parameter
#$a0 = map_stru
#$a1 = row_index
#$a2 = colum_index
#@Return
#	$v0
get_cell:
	addi $sp, $sp, -4	#Part_three: get_cell
	sw $ra, ($sp)
	jal is_valid_cell
	li $t0, -1
	beq $v0, $t0, part_three_error
	lbu $t1, 1($a0)	#$t1 = col_number
	mul $t2, $a1, $t1	
	add $t2, $t2, $a2 #$t2 = offset
	move $t3, $a0
	addi $t3, $t3, 2
	add $t3, $t3, $t2	#$t3 = cell[row][col]
	lbu $v0, ($t3)	#$v0 = char
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

part_three_error:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
# Part IV
#@Parameter
#$a0 = map_stru
#$a1 = row_index
#$a2 = colum_index
#$a3 = char
#@Return
#	$v0
set_cell:
	addi $sp, $sp, -4	#part_four
	sw $ra, ($sp)
	jal is_valid_cell
	li $t0, -1
	beq $t0, $v0, part_four_error
	lbu $t1, 1($a0)	#$t1 = col_number
	mul $t2, $a1, $t1	
	add $t2, $t2, $a2 #$t2 = offset
	move $t3, $a0
	addi $t3, $t3, 2
	add $t3, $t3, $t2	#$t3 = cell[row][col]
	sb $a3, ($t3)	#set char into map
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
part_four_error:
	lw $ra, ($sp)
	addi $sp, $sp, 4	
	jr $ra


# Part V
#@Parameter
#$a0 = map_stru
#$a1 = row
#$a2 = colum
reveal_area:
	addi $sp, $sp, -28
	sw $ra, ($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $v0, 16($sp)
	sw $s0, 20($sp)
	sw $s1, 24($sp)
	li $s0, -1	#$t0 = -1
	li $s1, 109	#$t1 = 109
case_1:#(-1, -1)	
	addi $a1, $a1, -1	#$a1 = row - 1
	addi $a2, $a2, -1	#$a2 = colum -1
	jal is_valid_cell	
	beq $s0, $v0, case_2	#if it is invalid cell, jump to case_2
	jal get_cell
	ble $v0, $s1, case_2	#if $v0 <= 109 , jump;if the cell cannot be revealed, jump to case_2
	addi $a3, $v0, -128	#$a3 = revealed cell
	jal set_cell
case_2:#(-1, 0)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $a1, $a1, -1	#$a1 = row - 1
	jal is_valid_cell
	beq $s0, $v0, case_3	#if it is invalid cell, jump to case_3
	jal get_cell
	ble $v0, $s1, case_3	#if $v0 <= 109 , jump;if the cell cannot be revealed, jump to case_3
	addi $a3, $v0, -128	#$a3 = revealed cell
	jal set_cell
case_3:#(-1,1)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $a1, $a1, -1	#$a1 = row - 1
	addi $a2, $a2, 1	#$a2 = colum + 1
	jal is_valid_cell
	beq $s0, $v0, case_4	#if it is invalid cell, jump to case_4
	jal get_cell
	ble $v0, $s1, case_4	#if $v0 <= 109 , jump;if the cell cannot be revealed, jump to case_4
	addi $a3, $v0, -128	#$a3 = revealed cell	
	jal set_cell
case_4:#(0, -1)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $a2, $a2, -1	#$a2 = colum - 1
	jal is_valid_cell
	beq $s0, $v0, case_5	#if it is invalid cell, jump to case_5
	jal get_cell
	ble $v0, $s1, case_5	#if $v0 <= 109 , jump;if the cell cannot be revealed, jump to case_5
	addi $a3, $v0, -128	#$a3 = revealed cell
	jal set_cell
case_5:#(0, 0)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	jal is_valid_cell
	beq $s0, $v0, case_6	#if it is invalid cell, jump to case_6
	jal get_cell
	ble $v0, $s1, case_6	#if $v0 <= 109 , jump;if the cell cannot be revealed, jump to case_6
	addi $a3, $v0, -128	#$a3 = revealed cell
	jal set_cell
case_6:#(0, 1)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $a2, $a2, 1	#$a2 = colum + 1
	jal is_valid_cell
	beq $s0, $v0, case_7	#if it is invalid cell, jump to case_7
	jal get_cell
	ble $v0, $s1, case_7	#if $v0 <= 109 , jump;if the cell cannot be revealed, jump to case_7
	addi $a3, $v0, -128	#$a3 =revealed cell
	jal set_cell
case_7:#(1, -1)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $a1, $a1, 1	#$a1 = row + 1
	addi $a2, $a2, -1 #$a2 = colum - 1
	jal is_valid_cell
	beq $s0, $v0, case_8	#if it is invalid cell, jump to case_8
	jal get_cell
	ble $v0, $s1, case_8	#if $v0 <= 109 , jump;if the cell cannot be revealed, jump to case_8
	addi $a3, $v0, -128	#$a3 = revealed cell
	jal set_cell
case_8:#(1, 0)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $a1, $a1, 1	#$a1 = row + 1
	jal is_valid_cell
	beq $s0, $v0, case_9	#if it is invalid cell, jump to case_9
	jal get_cell
	ble $v0, $s1, case_9	#if $v0 <= 109 , jump;if the cell cannot be revealed, jump to case_9
	addi $a3, $v0, -128	#$a3 = revealed cell
	jal set_cell
case_9:#(1, 1)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $a1, $a1, 1	#$a1 = row + 1
	addi $a2, $a2, 1	#$a2 = colum + 1
	jal is_valid_cell
	beq $s0, $v0, part_five_done	#if it is incalid cell, jump to part_five_done
	jal get_cell
	ble $v0, $s1, part_five_done	#if $v0 <= 109 , jump;if the cell cannot be revealed, jump to part_five_done
	addi $a3, $v0, -128	#$a3 = revealed cell
	jal set_cell
part_five_done:	
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $v0, 16($sp)
	sw $s0, 20($sp)
	sw $s1, 24($sp)
	addi $sp, $sp, 28
	jr $ra

# Part VI
#@Parameter
#$a0 = map
#$a1 = player
#$a2 = direction char
#@Return
#	$v0
get_attack_target:
	addi $sp, $sp, -28
	sw $ra, ($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	li $s0, -1	#$s0 = -1
	li $s1, 'm'	#$s1 = 'm'
	li $s2, 'B'	#$s2 = 'B'
	li $s3, '/'	#$s3 = '/'
	lbu $t1, ($a1)	#$t1 = player_row
	lbu $t2, 1($a1)	#$t2 = player_colum
	li $t0, 'U'
	beq $a2, $t0, part_six_UP_target
	li $t0, 'D'
	beq $a2, $t0, part_six_DOWN_target
	li $t0, 'L'
	beq $a2, $t0, part_six_LEFT_target
	li $t0, 'R'
	beq $a2, $t0, part_six_RIGHT_target
	j part_six_error
part_six_UP_target:#(-1, 0)
	addi $t1, $t1, -1	#$t1 = row - 1	
	move $a1, $t1	#$a1 = player_row - 1
	move $a2, $t2	#$a2 = player_colum
	jal get_cell
	jal part_six_check_target
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	addi $sp, $sp, 28
	jr $ra	
part_six_RIGHT_target:#(0, 1)
	addi $t2, $t2, 1	#$t1 = colum + 1	
	move $a1, $t1	#$a1 = player_row
	move $a2, $t2	#$a2 = player_colum + 1
	jal get_cell
	jal part_six_check_target
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	addi $sp, $sp, 28
	jr $ra	
part_six_DOWN_target:#(1, 0)
	addi $t1, $t1, 1	#$t1 = row + 1	
	move $a1, $t1	#$a1 = player_row + 1
	move $a2, $t2	#$a2 = player_colum
	jal get_cell
	jal part_six_check_target
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	addi $sp, $sp, 28
	jr $ra	
part_six_LEFT_target:#(0, -1)
	addi $t2, $t2, -1	#$t1 = colum - 1	
	move $a1, $t1	#$a1 = player_row
	move $a2, $t2	#$a2 = player_colum - 1
	jal get_cell
	jal part_six_check_target
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	addi $sp, $sp, 28
	jr $ra	
part_six_error:
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	addi $sp, $sp, 28
	li $v0, -1
	jr $ra
#Helper
return:
	jr $ra
part_six_check_target:
	beq $v0, $s0 part_six_error
	beq $v0, $s1 return	#if target is 'm', return
	beq $v0, $s2 return	#if target is 'B', return
	beq $v0, $s3 return	#if target is '/', return
	j part_six_error
	
# Part VII
#@Parameter
#$a0 = map
#$a1 = player
#$a2 = target_row
#$a3 = target_colum
complete_attack:
	addi $sp, $sp, -20
	sw $ra, ($sp)
	sw $a1, 4($sp)	#player
	sw $a2, 8($sp)	#target_row
	sw $a3, 12($sp)	#target_colum
	sw $v0, 16($sp)
	move $a1, $a2	#a1 = target_row
	move $a2, $a3	#a2 = target_colum
	jal get_cell
	li $t0, 'm'
	li $t1, 'B'
	beq $v0, $t0, part_seven_attack_m	#if target is 'm', j attack_m
	beq $v0, $t1, part_seven_attack_B	#else if target is 'B', j attack_B
	li $a3, '.'	#else target is '/', attack door
	jal set_cell
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $v0, 16($sp)
	addi $sp, $sp, 20
	jr $ra
part_seven_attack_m:
	li $a3, '$'
	jal set_cell
	lw $t0, 4($sp)	#$t0 = player
	lb $t1, 2($t0)	#$t1 = health
	addi $t1, $t1, -1	#$t1 = health - 1
	bgtz $t1, part_seven_attack_m_alive	#if health > 0, j player is alive
	lbu $a1, ($t0)	#else player is dead, $a1 = row
	lbu $a2, 1($t0)	#$a2 = cloum
	li $a3, 'X'
	jal set_cell	
part_seven_attack_m_alive:	
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $v0, 16($sp)
	addi $sp, $sp, 20
	jr $ra
part_seven_attack_B:
	li $a3, '*'
	jal set_cell
	lw $t0, 4($sp)	#$t0 = player
	lb $t1, 2($t0)	#$t1 = health
	addi $t1, $t1, -2	#$t1 = health - 2
	bgtz $t1, part_seven_attack_B_alive	#if health > 0, j player is alive
	lbu $a1, ($t0)	#else player is dead, $a1 = row
	lbu $a2, 1($t0)	#$a2 = cloum
	li $a3, 'X'
	jal set_cell	
part_seven_attack_B_alive:
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $v0, 16($sp)
	addi $sp, $sp, 20
	jr $ra
	
# Part VIII
#@Parameter
#$a0 = map
#$a1 = player
#@Return
#	$v0
monster_attacks:
	addi $sp, $sp, -32
	sw $ra, ($sp)
	sw $a1, 4($sp)
	sw $s0, 8($sp)
	sw $s1, 12($sp)
	sw $s2, 16($sp)
	sw $s3, 20($sp)
	sw $s4, 24($sp)
	sw $a2, 28($sp)
	li $s2, 'm'	#$s2 = 'm'
	li $s3, 'B'	#$s3 = 'B'
	li $s4, 0	#$s4 = sum 
	lbu $s0, ($a1)	#$s0 = player_row	
	lbu $s1, 1($a1)	#$s1 = player_colum
part_eight_case_1:#CheckUP(-1, 0)
	addi $t0, $s0, -1	
	move $a1, $t0	#$a1 = player_row - 1
	move $a2, $s1 	#$a2 = player_colum
	jal get_cell
	bne $v0, $s2, part_eight_UP_check_B
	jal part_eight_is_m
	j part_eight_case_2
part_eight_UP_check_B:
	bne $v0, $s3, part_eight_case_2
	jal part_eight_is_B	
part_eight_case_2:#CheckRIGHT(0, 1)
	addi $t1, $s1, 1	
	move $a1, $s0	#$a1 = player_row 
	move $a2, $t1 	#$a2 = player_colum + 1
	jal get_cell
	bne $v0, $s2, part_eight_RIGHT_check_B
	jal part_eight_is_m
	j part_eight_case_3
part_eight_RIGHT_check_B:
	bne $v0, $s3, part_eight_case_3
	jal part_eight_is_B	
part_eight_case_3:#CheckDOWN(1, 0)
	addi $t0, $s0, 1	
	move $a1, $t0	#$a1 = player_row + 1
	move $a2, $s1 	#$a2 = player_colum 
	jal get_cell
	bne $v0, $s2, part_eight_DOWN_check_B
	jal part_eight_is_m
	j part_eight_case_4
part_eight_DOWN_check_B:
	bne $v0, $s3, part_eight_case_4
	jal part_eight_is_B	
part_eight_case_4:#CheckLEFT(0, -1)
	addi $t1, $s1, -1	
	move $a1, $s0	#$a1 = player_row 
	move $a2, $t1 	#$a2 = player_colum - 1
	jal get_cell
	bne $v0, $s2, part_eight_LEFT_check_B
	jal part_eight_is_m
	j part_eight_down
part_eight_LEFT_check_B:
	bne $v0, $s3, part_eight_down
	jal part_eight_is_B
part_eight_down:
	move $v0, $s4	
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $s0, 8($sp)
	lw $s1, 12($sp)
	lw $s2, 16($sp)
	lw $s3, 20($sp)
	lw $s4, 24($sp)	
	lw $a2, 28($sp)
	addi $sp, $sp, 32
	jr $ra
#Helper
part_eight_is_m:
	addi $s4, $s4, 1
	jr $ra
part_eight_is_B:
	addi $s4, $s4, 2
	jr $ra

# Part IX
#@Parameter
#$a0 = map
#$a1 = player
#$a2 = target_row
#$a3 = target_colum
#@Return
#	$v0
player_move:
	addi $sp, $sp -20
	sw $ra, 0($sp)
	sw $a0, 4($sp)	#map
	sw $a1, 8($sp)	#player
	sw $a2, 12($sp)	#target_row
	sw $a3, 16($sp)	#target_colum
	jal monster_attacks
	lb $t0, 2($a1) #$t0 = health
	sub $t0, $t0, $v0	#health = health - damage
	blez $t0, part_nine_player_isKilled
	move $a1, $a2	#$a1 = target_row
	move $a2, $a3	#$a2 = target_colum
	jal get_cell
	li $t0, '.'
	li $t1, '$'
	li $t2, '*'
	li $t3, '>'	
	beq $v0, $t0, part_nine_moveTo_floor
	beq $v0, $t1, part_nine_moveTo_coin
	beq $v0, $t2, part_nine_moveTo_gem
	beq $v0, $t3, part_nine_moveTo_exit	
	lw $ra, ($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp 20
	jr $ra	
part_nine_player_isKilled:
	lbu $t0, ($a1)	#$t0 = player_row
	lbu $t1, 1($a1)	#$t1 = player_colum
	move $a1, $t0	#$a1 = player_row
	move $a2, $t1	#$a2 = player_colum
	li $a3, 'X'
	jal set_cell
	li $v0, 0	
	lw $ra, ($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp 20
	jr $ra	
part_nine_moveTo_floor:
	lw $a1, 8($sp)	#$a1 = player
	lbu $t0, ($a1)	#$t0 = player_row
	lbu $t1, 1($a1)	#$t1 = player_colum
	move $a1, $t0	#$a1 = player_row
	move $a2, $t1	#$a2 = player_colum
	li $a3, '.'
	jal set_cell
	lw $a1, 12($sp)	#$a1 = target_row
	lw $a2, 16($sp)	#$a2 = target_colum
	li $a3, '@'
	jal set_cell
	li $v0, 0	
	lw $ra, ($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp 20
	jr $ra	
part_nine_moveTo_coin:
	lw $a1, 8($sp)	#$a1 = player
	lbu $t0, ($a1)	#$t0 = player_row
	lbu $t1, 1($a1)	#$t1 = player_colum
	lbu $t2, 3($a1)	#$t2 = player_coins
	addi $t2, $t2, 1	#$t2 = player_coins + 1
	sb $t2, 3($a1)	
	move $a1, $t0	#$a1 = player_row
	move $a2, $t1	#$a2 = player_colum
	li $a3, '.'
	jal set_cell
	lw $a1, 12($sp)	#$a1 = target_row
	lw $a2, 16($sp)	#$a2 = target_colum
	li $a3, '@'
	jal set_cell
	li $v0, 0	
	lw $ra, ($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp 20
	jr $ra	
part_nine_moveTo_gem:
	lw $a1, 8($sp)	#$a1 = player
	lbu $t0, ($a1)	#$t0 = player_row
	lbu $t1, 1($a1)	#$t1 = player_colum
	lbu $t2, 3($a1)	#$t2 = player_coins
	addi $t2, $t2, 5	#$t2 = player_coins + 5
	sb $t2, 3($a1)
	move $a1, $t0	#$a1 = player_row
	move $a2, $t1	#$a2 = player_colum
	li $a3, '.'
	jal set_cell
	lw $a1, 12($sp)	#$a1 = target_row
	lw $a2, 16($sp)	#$a2 = target_colum
	li $a3, '@'
	jal set_cell
	li $v0, 0	
	lw $ra, ($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp 20
	jr $ra	
part_nine_moveTo_exit:
	lw $a1, 8($sp)	#$a1 = player
	lbu $t0, ($a1)	#$t0 = player_row
	lbu $t1, 1($a1)	#$t1 = player_colum
	move $a1, $t0	#$a1 = player_row
	move $a2, $t1	#$a2 = player_colum
	li $a3, '.'
	jal set_cell
	lw $a1, 12($sp)	#$a1 = target_row
	lw $a2, 16($sp)	#$a2 = target_colum
	li $a3, '@'
	jal set_cell
	li $v0, -1	
	lw $ra, ($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp 20
	jr $ra	
# Part X
#@Parameter
#$a0 = map
#$a1 = player
#$a2 = direction char
#@Return
#	$v0
player_turn:
	addi $sp, $sp, -24
	sw $ra, ($sp)
	sw $a1, 4($sp)	#player
	sw $a2, 8($sp)	#direction char
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	li $s2, -1
	li $t0, 'U'
	li $t1, 'R'
	li $t2, 'D'
	li $t3, 'L'
	beq $a2, $t0, part_ten_goes_up
	beq $a2, $t1, part_ten_goes_right
	beq $a2, $t2, part_ten_goes_down
	beq $a2, $t3, part_ten_goes_left
	li $v0, -1
	lw $s2, 20($sp)
	addi $sp, $sp, 24
	jr $ra
part_ten_goes_up:#(-1, 0)
	lbu $t0, ($a1)	#$t0 = player row
	lbu $t1, 1($a1)	#$t1 = player colum
	addi $t0, $t0, -1
	move $s0, $t0	#$s0 = target row
	move $s1, $t1	#$s1 = target colum
	move $a1, $t0	#$a1 = target row = player row - 1
	move $a2, $t1	#$a2 = target colum = player colum
	jal get_cell
	bne $v0, $s2, part_ten_valid_cell	#if $v0 != -1 , the target cell is valid
	li $v0, 0
	lw $ra, ($sp)
	lw $a1, 4($sp)	#player
	lw $a2, 8($sp)	#direction char
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	addi $sp, $sp, 24
	jr $ra
part_ten_goes_right:#(0, 1)
	lbu $t0, ($a1)	#$t0 = player row
	lbu $t1, 1($a1)	#$t1 = player colum
	addi $t1, $t1, 1
	move $s0, $t0	#$s0 = target row
	move $s1, $t1	#$s1 = target colum
	move $a1, $t0	#$a1 = target row = player row 
	move $a2, $t1	#$a2 = target colum = player colum + 1
	jal get_cell
	bne $v0, $s2, part_ten_valid_cell	#if $v0 != -1 , the target cell is valid
	li $v0, 0
	lw $ra, ($sp)
	lw $a1, 4($sp)	#player
	lw $a2, 8($sp)	#direction char
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	addi $sp, $sp, 24
	jr $ra	
part_ten_goes_down:#(1, 0)
	lbu $t0, ($a1)	#$t0 = player row
	lbu $t1, 1($a1)	#$t1 = player colum
	addi $t0, $t0, 1
	move $s0, $t0	#$s0 = target row
	move $s1, $t1	#$s1 = target colum
	move $a1, $t0	#$a1 = target row = player row  + 1
	move $a2, $t1	#$a2 = target colum = player colum
	jal get_cell
	bne $v0, $s2, part_ten_valid_cell	#if $v0 != -1 , the target cell is valid
	li $v0, 0
	lw $ra, ($sp)
	lw $a1, 4($sp)	#player
	lw $a2, 8($sp)	#direction char
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	addi $sp, $sp, 24
	jr $ra	
part_ten_goes_left:#(0, -1)
	lbu $t0, ($a1)	#$t0 = player row
	lbu $t1, 1($a1)	#$t1 = player colum
	addi $t1, $t1, -1
	move $s0, $t0	#$s0 = target row
	move $s1, $t1	#$s1 = target colum
	move $a1, $t0	#$a1 = target row = player row
	move $a2, $t1	#$a2 = target colum = player colum - 1
	jal get_cell
	bne $v0, $s2, part_ten_valid_cell	#if $v0 != -1 , the target cell is valid
	li $v0, 0
	lw $ra, ($sp)
	lw $a1, 4($sp)	#player
	lw $a2, 8($sp)	#direction char
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	addi $sp, $sp, 24
	jr $ra
#Helper
part_ten_valid_cell:
	li $t0, '#'
	bne $v0, $t0, part_ten_not_wall	#if $v0 != '#', the cell is not a wall
	li $v0, 0
	lw $ra, ($sp)
	lw $a1, 4($sp)	#player
	lw $a2, 8($sp)	#direction char
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	addi $sp, $sp, 24
	jr $ra
part_ten_not_wall:
	lw $a1, 4($sp)	#$a1 = player
	lw $a2, 8($sp)	#$a2 = direction char
	jal get_attack_target
	move $a2, $s0	#$a2 = target row
	move $a3, $s1	#$a3 = target colum
	beq $v0, $s2, part_ten_notAttackable
	jal complete_attack
	li $v0, 0
	lw $ra, ($sp)
	lw $a1, 4($sp)	#player
	lw $a2, 8($sp)	#direction char
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	addi $sp, $sp, 24
	jr $ra
part_ten_notAttackable:
	jal player_move 
	lw $ra, ($sp)
	lw $a1, 4($sp)	#player
	lw $a2, 8($sp)	#direction char
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	addi $sp, $sp, 24
	jr $ra
	
# Part XI
#@Parameter
#$a0 = map
#$a1 = row_index
#$a2 = colum_index
#$a3 = visited array
#@Return
#	$v0
flood_fill_reveal:
	addi $sp, $sp -52
	sw $fp, ($sp)
	sw $ra, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $a3, 16($sp)
	sw $s0, 20($sp)	
	sw $s1, 24($sp)	
	sw $s2, 28($sp)
	sw $s3, 32($sp)
	sw $s4, 36($sp)
	sw $s5, 40($sp)
	sw $s6, 44($sp)
	sw $s7, 48($sp)
	move $s0, $a3	#$s0 = visited array
	li $s3, '.'	#$s3 = '.'	
	li $s4, 174	#$s4 = '.' (hidden)
	li $t0, -1
	jal get_cell
	beq $v0, $t0, part_eleven_error
	move $fp, $sp
	addi $sp, $sp, -4
	sb $a1, ($sp) #sb row
	sb $a2, 1($sp)	#sb colum
part_eleven_loop:
	beq $sp, $fp, part_eleven_loop_end #if $sp == $fp, loop ends
	lbu $s1, ($sp)	#$s1 = cell_row_index
	lbu $s2, 1($sp)	#$s2 = cell_colum_index
	addi $sp, $sp, 4	#stack.pop()	
	move $a1, $s1	#$a1 = row
	move $a2, $s2	#$a2 = colum
	jal get_cell
	li $t0, 128
	ble $v0, $t0, part_eleven_case1 #if cell is visible, jump to case1
	addi $a3, $v0, -128	#set the cell visible
	jal set_cell
part_eleven_case1:#(-1, 0)	
	addi $a1, $s1, -1 #$a1 = cell_row_index - 1
	move $a2, $s2	#$a2 = cell_colum_index
#get visited bit
	lbu $t2, 1($a0)	#$t2 = map_colum_number
	mul $t3, $a1, $t2	#$t3 = cell_row_index * map_colum_number
	add $t3, $t3, $a2 #$t3 = offset in visited array
	li $t0, 8
	divu $t3, $t0	#$t3 / 8
	mflo $t4	#$t4 = quotient
	mfhi $t5	#$t5 = remainder
	add $t6, $s0, $t4	#$t6 = visitedArray_addr + quotient
	lbu $t7, ($t6)	#$t7 = the byte 
	li $t0, 7
	subu $t8, $t0, $t5 #$t8 = 7 - remainder
	li $t0, 1
	sllv $t9, $t0, $t8	#$t9 = the position of the visited bit in binary
	and $t8, $t7, $t9	#$t8 = the bit in binary
	bnez $t8, part_eleven_case2 #if $t8 is visited, jump to case2
	move $s5, $t6	#$s5 = visitedArray_addr + quotient
	move $s6, $t7	#$s6 = the byte
	move $s7, $t9	#$s7 = the position of the visited bit in binary
	jal get_cell
	beq $v0, $s3, part_eleven_case1_isFloor #if $v0 == '.', jump to isFloor
	bne $v0, $s4, part_eleven_case2	#if $v0 != '.' (hidden), jump to case2
part_eleven_case1_isFloor:		
	or $t0, $s6, $s7	
	sb $t0, ($s5)	#the cell is set as having been visited
	addi $sp, $sp, -4	#stack.push()
	sb $a1, ($sp)	#push the row index
	sb $a2, 1($sp)	#push the colum index
part_eleven_case2:#(0, 1)
	move $a1, $s1	#$a1 = cell_row_index
	addi $a2, $s2, 1	#$a2 = cell_colum_index + 1
#get visited bit
	lbu $t2, 1($a0)	#$t2 = map_colum_number
	mul $t3, $a1, $t2	#$t3 = cell_row_index * map_colum_number
	add $t3, $t3, $a2 #$t3 = offset in visited array
	li $t0, 8
	divu $t3, $t0	#$t3 / 8
	mflo $t4	#$t4 = quotient
	mfhi $t5	#$t5 = remainder
	add $t6, $s0, $t4	#$t6 = visitedArray_addr + quotient
	lbu $t7, ($t6)	#$t7 = the byte 
	li $t0, 7
	subu $t8, $t0, $t5 #$t8 = 7 - remainder
	li $t0, 1
	sllv $t9, $t0, $t8	#$t9 = the position of the visited bit in binary
	and $t8, $t7, $t9	#$t8 = the bit in binary
	bnez $t8, part_eleven_case3 #if $t8 is visited, jump to case3
	move $s5, $t6	#$s5 = visitedArray_addr + quotient
	move $s6, $t7	#$s6 = the byte
	move $s7, $t9	#$s7 = the position of the visited bit in binary
	jal get_cell
	beq $v0, $s3, part_eleven_case2_isFloor #if $v0 == '.', jump to isFloor
	bne $v0, $s4, part_eleven_case3	#if $v0 != '.' (hidden), jump to case3
part_eleven_case2_isFloor:		
	or $t0, $s6, $s7	
	sb $t0, ($s5)	#the cell is set as having been visited
	addi $sp, $sp, -4 #stack.push()
	sb $a1, ($sp)	#push the row index
	sb $a2, 1($sp)	#push the colum index
part_eleven_case3:#(1, 0)
	addi $a1, $s1, 1	#$a1 = cell_row_index + 1
	move $a2, $s2 #$a2 = cell_colum_index
#get visited bit
	lbu $t2, 1($a0)	#$t2 = map_colum_number
	mul $t3, $a1, $t2	#$t3 = cell_row_index * map_colum_number
	add $t3, $t3, $a2 #$t3 = offset in visited array
	li $t0, 8
	divu $t3, $t0	#$t3 / 8
	mflo $t4	#$t4 = quotient
	mfhi $t5	#$t5 = remainder
	add $t6, $s0, $t4	#$t6 = visitedArray_addr + quotient
	lbu $t7, ($t6)	#$t7 = the byte 
	li $t0, 7
	subu $t8, $t0, $t5 #$t8 = 7 - remainder
	li $t0, 1
	sllv $t9, $t0, $t8	#$t9 = the position of the visited bit in binary
	and $t8, $t7, $t9	#$t8 = the bit in binary
	bnez $t8, part_eleven_case4 #if $t8 is visited, jump to case4
	move $s5, $t6	#$s5 = visitedArray_addr + quotient
	move $s6, $t7	#$s6 = the byte
	move $s7, $t9	#$s7 = the position of the visited bit in binary
	jal get_cell
	beq $v0, $s3, part_eleven_case3_isFloor #if $v0 == '.' , jump to isFloor
	bne $v0, $s4, part_eleven_case4	#if $v0 != '.' (hidden), jump to case4
part_eleven_case3_isFloor:		
	or $t0, $s6, $s7	
	sb $t0, ($s5)	#the cell is set as having been visited
	addi $sp, $sp, -4	#stack.push()
	sb $a1, ($sp)	#push the row index
	sb $a2, 1($sp)	#push the colum index	

part_eleven_case4:#(0, -1)
	move $a1, $s1 	#$a1 = cell_row_index
	addi $a2, $s2, -1 #$a2 = cell_colum_index - 1
#get visited bit
	lbu $t2, 1($a0)	#$t2 = map_colum_number
	mul $t3, $a1, $t2	#$t3 = cell_row_index * map_colum_number
	add $t3, $t3, $a2 #$t3 = offset in visited array
	li $t0, 8
	divu $t3, $t0	#$t3 / 8
	mflo $t4	#$t4 = quotient
	mfhi $t5	#$t5 = remainder
	add $t6, $s0, $t4	#$t6 = visitedArray_addr + quotient
	lbu $t7, ($t6)	#$t7 = the byte 
	li $t0, 7
	subu $t8, $t0, $t5 #$t8 = 7 - remainder
	li $t0, 1
	sllv $t9, $t0, $t8	#$t9 = the position of the visited bit in binary
	and $t8, $t7, $t9	#$t8 = the bit in binary
	bnez $t8, part_eleven_loop #if $t8 is visited, jump to loop
	move $s5, $t6	#$s5 = visitedArray_addr + quotient
	move $s6, $t7	#$s6 = the byte
	move $s7, $t9	#$s7 = the position of the visited bit in binary
	jal get_cell
	beq $v0, $s3, part_eleven_case4_isFloor #if $v0 == '.' , jump to isFloor
	bne $v0, $s4, part_eleven_loop	#if $v0 != '.' (hidden), jump to loop
part_eleven_case4_isFloor:		
	or $t0, $s6, $s7	
	sb $t0, ($s5)	#the cell is set as having been visited
	addi $sp, $sp, -4	#stack.push()
	sb $a1, ($sp)	#push the row index
	sb $a2, 1($sp)	#push the colum index	
	j part_eleven_loop	

part_eleven_loop_end:	
	li $v0, 0
	lw $fp, ($sp)
	lw $ra, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	lw $s0, 20($sp)	
	lw $s1, 24($sp)	
	lw $s2, 28($sp)
	lw $s3, 32($sp)
	lw $s4, 36($sp)
	lw $s5, 40($sp)
	lw $s6, 44($sp)
	lw $s7, 48($sp)
	addi $sp, $sp, 52
	jr $ra
part_eleven_error:
	li $v0, -1
	lw $fp, ($sp)
	lw $ra, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	lw $s0, 20($sp)	
	lw $s1, 24($sp)	
	lw $s2, 28($sp)
	lw $s3, 32($sp)
	lw $s4, 36($sp)
	lw $s5, 40($sp)
	lw $s6, 44($sp)
	lw $s7, 48($sp)
	addi $sp, $sp, 52
	jr $ra
#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
