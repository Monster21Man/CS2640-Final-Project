#CS2640
#Logan Bailey, Marco Joson, Russell Salvador, Jay Wu
#12/05/25
#CS2640 Final Project: Tic-Tac-Toe using a bitmap

.macro getInt(%reg) #get int input from user
    li $v0, 5
    syscall
    move %reg, $v0
.end_macro

.macro exit #exit program
	li $v0, 10
	syscall
.end_macro 

.macro printString(%str) #print given string
 	.data
 		string: .asciiz %str
 	.text
 		li $v0, 4
 		la $a0, string
  		syscall
.end_macro

.macro printDataString(%str) #prints inputed string
	li $v0, 4
	la $a0, %str
	syscall
.end_macro

.data
charY: .asciiz "Y"
charN: .asciiz "N"
breakLine: .asciiz "\n|---------------------------------------------------------|\n"
user1Turn: .asciiz "\nIt is Player One's turn!"
user1XPrompt: .asciiz "\nPlace your 'X' x-cord (Choose 1-3): "
user1YPrompt: .asciiz "\nPlace your 'X' y-cord (Choose 1-3): "
user2Turn: .asciiz "\nIt is Player Two's turn!"
user2XPrompt: .asciiz "\nPlace your 'O' x-cord (Choose 1-3): "
user2YPrompt: .asciiz "\nPlace your 'O' y-cord (Choose 1-3): "
invalidInput: .asciiz "\nError! Invalid coordinate input. Please choose a number 1, 2, or 3."

buffer: .space 20



.text
main: 
	printString("Tic Tac Toe\n")
	printString("-------------")
	printString("\n\nTo start press Y\nTo exit press N\n")
	
	#assign '$t0' to be the gameOnOff boolean
	#0 - game has not started
	#1 - game has started
	#2 - game has ended, begin outputing result
	li $t0, 0


Input:
	li $v0, 12
	syscall 
	move $s0, $v0
	
	lb $s1, charY
	beq $s0, $s1, startGame 
	
	lb $s1, charN
	beq $s0, $s1, exitLabel
	
	j error
	
	
error:
	printString("\nNot Valid Input, please Enter Y or N\n")
	j Input
	
#Player 1 turn
# - $t1 = X cord
# - $t2 = Y cord
playerOneTurn: 

	printDataString(breakLine)
	printDataString(user1Turn)
	
	#Prompt for x-cord
	printDataString(user1XPrompt)
	getInt($t1)
	
	#check x-cord
	bge $t1, 4, errorCoord1
	ble $t1, $zero, errorCoord1
	
	#Prompt for y-cord
	printDataString(user1YPrompt)
	getInt($t2)
	
	#check y-cord
	bge $t1, 4, errorCoord1
	ble $t1, $zero, errorCoord1
	
	#check if game need to continue
	beq $t0, 1, playerTwoTurn
	#check if game has ended
	beq $t0, 2, endGame
	
#Player 1 turn
# - $t3 = X cord
# - $t4 = Y cord
playerTwoTurn: 

	printDataString(breakLine)
	printDataString(user2Turn)
	
	#Prompt for x-cord
	printDataString(user2XPrompt)
	getInt($t3)
	
	#check x-cord
	bge $t1, 4, errorCoord2
	ble $t1, $zero, errorCoord2
	
	#Prompt for y-cord
	printDataString(user2YPrompt)
	getInt($t4)
	
	#check y-cord
	bge $t1, 4, errorCoord2
	ble $t1, $zero, errorCoord2
	
	#placing this for now to end program
	li $t0, 2
	#check if game need to continue
	beq $t0, 1, playerTwoTurn
	#check if game has ended
	beq $t0, 2, endGame
	
startGame:	#this is just place holder until we have the code for tic tac toe
	printString("\n\nGame Started")
	printString("\n---------------\n")
	
	li $v0, 1
	
	j playerOneTurn

errorCoord1:
	printDataString(invalidInput)
	
	j playerOneTurn

errorCoord2:
	printDataString(invalidInput)
	
	j playerTwoTurn

endGame:
	j exitLabel
	
exitLabel:
	
	#end program
	exit
