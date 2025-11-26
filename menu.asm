.macro printString(%str)
  .data
  string: .asciiz %str
  .text
  li $v0, 4
  la $a0, string
  syscall
.end_macro


.data
charY: .asciiz "Y"
charN: .asciiz "N"
buffer: .space 20



.text
main: 
	printString("Tic Tac Toe\n")
	printString("-------------")
	printString("\n\nTo start press Y\nTo exit press N\n")


Input:
	li $v0, 12
	syscall 
	move $s0, $v0
	
	lb $s1, charY
	beq $s0, $s1, startGame 
	
	lb $s1, charN
	beq $s0, $s1, exit
	
	j error
	
	
error:
	printString("\nNot Valid Input, please Enter Y or N\n")
	j Input
	
	
startGame:	#this is just place holder until we have the code for tic tac toe
	printString("\n\nGame Started")
	printString("\n---------------\n")
	li $v0, 10
	syscall
	
	
exit:
	printString("\n\nExiting... Thanks for Playing!")
	li $v0, 10
	syscall