# Macros

.macro getInt(%reg)          # get int input from user
li $v0, 5
syscall
move %reg, $v0
.end_macro

.macro exit                  # exit program
li $v0, 10
syscall
.end_macro

.macro printDataString(%str) # print a .asciiz label
li $v0, 4
la $a0, %str
syscall
.end_macro

# Data

.data
# Y/N for menu
charY: .asciiz "Y"
charN: .asciiz "N"

# Menu text
menu1: .asciiz "Tic Tac Toe\n"
menu2: .asciiz "-------------\n"
menu3: .asciiz "\nTo start press Y\nTo exit press N\n"
invalidYN: .asciiz "\nNot Valid Input, please Enter Y or N\n"

startMsg: .asciiz "\n\nGame Started\n---------------\n"
exitMsg: .asciiz "\n\nExiting... Thanks for Playing!\n"

# Turn
breakLine: .asciiz "\n|---------------------------------------------------------|\n"
user1Turn: .asciiz "\nIt is Player One's turn!"
user1XPrompt: .asciiz "\nPlace your 'X' x-cord (Choose 1-3): "
user1YPrompt: .asciiz "\nPlace your 'X' y-cord (Choose 1-3): "
user2Turn: .asciiz "\nIt is Player Two's turn!"
user2XPrompt: .asciiz "\nPlace your 'O' x-cord (Choose 1-3): "
user2YPrompt: .asciiz "\nPlace your 'O' y-cord (Choose 1-3): "
invalidInput: .asciiz "\nError! Invalid coordinate input. Please choose a number 1, 2, or 3."
errTaken: .asciiz "\nThat spot is already taken. Choose another.\n"

buffer: .space 20

# Game state
# board: 9 bytes, 0 = empty, 1 = X, 2 = O
board: .space 9
currentPlayer: .word 1      # 1 = Player 1 (X), 2 = Player 2 (O)



# Text / Code
.text
.globl main

# main: print menu, handle Y/N, start or exit

main:
# Print menu
printDataString(menu1)
printDataString(menu2)
printDataString(menu3)

MenuInput:
li $v0, 12        # read character
syscall
move $s0, $v0       # s0 = input char

lb $t0, charY     # first byte of "Y"
beq $s0, $t0, startGame

lb $t1, charN     # first byte of "N"
beq $s0, $t1, exitProgram

# Invalid Y/N
printDataString(invalidYN)
j MenuInput



# startGame: clear board, reset player, loop

startGame:
# Clear board (set all 9 cells to 0)
la $t0, board
li $t1, 0          # index 0..8

clearLoop:
beq $t1, 9, boardCleared
sb $zero, 0($t0)   # store 0 (empty)
addi $t0, $t0, 1
addi $t1, $t1, 1
j clearLoop

boardCleared:
printDataString(startMsg)

li $t0, 1
sw $t0, currentPlayer



gameLoop:
jal getMove

lw $t0, currentPlayer
li $t1, 1
beq $t0, $t1, switchTo2

li $t0, 1
sw $t0, currentPlayer
j gameLoop

switchTo2:
li $t0, 2
sw $t0, currentPlayer
j gameLoop

# exitProgram: print goodbye and exit
exitProgram:
printDataString(exitMsg)
exit
    
getMove:
lw $t0, currentPlayer

li $t1, 1
beq $t0, $t1, getMoveP1   # if player 1
j getMoveP2             # else player 2

# getMoveP1: Player One (X)

getMoveP1:
printDataString(breakLine)
printDataString(user1Turn)

GetP1X:
printDataString(user1XPrompt)
getInt($t7)               # t7 = x (1..3) -> col

# validate 1 <= x <= 3
li $t1, 1
blt $t7, $t1, errorCoordP1
li $t1, 3
bgt $t7, $t1, errorCoordP1

GetP1Y:
printDataString(user1YPrompt)
getInt($t6)               # t6 = y (1..3) -> row

# validate 1 <= y <= 3
li $t1, 1
blt $t6, $t1, errorCoordP1
li $t1, 3
bgt $t6, $t1, errorCoordP1

j checkCell

errorCoordP1:
printDataString(invalidInput)
j getMoveP1

# getMoveP2: Player Two (O)

getMoveP2:
printDataString(breakLine)
printDataString(user2Turn)

GetP2X:
printDataString(user2XPrompt)
getInt($t7)               # t7 = x (1..3) -> col

# validate 1 <= x <= 3
li $t1, 1
blt $t7, $t1, errorCoordP2
li $t1, 3
bgt $t7, $t1, errorCoordP2

GetP2Y:
printDataString(user2YPrompt)
getInt($t6)               # t6 = y (1..3) -> row

# validate 1 <= y <= 3
li $t1, 1
blt $t6, $t1, errorCoordP2
li $t1, 3
bgt $t6, $t1, errorCoordP2

j checkCell

errorCoordP2:
printDataString(invalidInput)
j getMoveP2



checkCell:
# Convert (row, col) from 1–3 to index 0–8:
addi $t1, $t6, -1         # t1 = row-1
addi $t2, $t7, -1         # t2 = col-1

li $t3, 3
mul $t3, $t1, $t3       
add $t3, $t3, $t2        

la $t4, board
add $t4, $t4, $t3        

# Check if cell is empty (0)
lb $t5, 0($t4)
bne $t5, $zero, cellTaken

# Cell is empty -> store currentPlayer (1 or 2) as byte
sb $t0, 0($t4)

jr $ra                  # done, return to gameLoop


cellTaken:
printDataString(errTaken)

# Reprompt same player based on currentPlayer
li $t1, 1
beq $t0, $t1, getMoveP1  # if player 1
j getMoveP2            # else player 2
