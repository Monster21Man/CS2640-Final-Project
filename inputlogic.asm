.data
#existing menu data 
charY:    .byte 'Y'
charN:    .byte 'N'
buffer:   .space 20

menu1:    .asciiz "Tic Tac Toe\n"
menu2:    .asciiz "-------------\n"
menu3:    .asciiz "\nTo start press Y\nTo exit press N\n"
invalid:  .asciiz "\nNot Valid Input, please Enter Y or N\n"
startMsg: .asciiz "\n\nGame Started\n---------------\n"
exitMsg:  .asciiz "\n\nExiting... Thanks for Playing!"

# Tic Tac Toe data

promptRow: .asciiz "\nPlayer "
promptCol: .asciiz ", enter ROW (1-3): "
promptCol2:.asciiz ", enter COLUMN (1-3): "
errRange:  .asciiz "Invalid input. Please enter a value from 1 to 3.\n"
errTaken:  .asciiz "That spot is already taken. Choose another.\n"

# 0 = empty, 1 = X, 2 = O
board:        .space 9        # 9 bytes for 3x3 board
currentPlayer:.word 1         # start with Player 1 (X)

.text
main:
    # Print menu
    li $v0, 4
    la $a0, menu1
    syscall

    li $v0, 4
    la $a0, menu2
    syscall

    li $v0, 4
    la $a0, menu3
    syscall

Input:
    li $v0, 12       # read character
    syscall
    move $s0, $v0

    lb $t0, charY
    beq $s0, $t0, startGame

    lb $t1, charN
    beq $s0, $t1, exitProgram

    li $v0, 4
    la $a0, invalid
    syscall
    j Input


startGame:
    # Clear board (set all 9 cells to 0)
    la $t0, board
    li $t1, 0        
clearLoop:
    beq $t1, 9, boardCleared
    sb $zero, 0($t0)  # store 0 (empty)
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j clearLoop

boardCleared:
    li $v0, 4
    la $a0, startMsg
    syscall

gameLoop:
    # Call getMove (will implement later)
    jal getMove

    # TODO:
    #   - draw board on bitmap
    #   - check win/tie and break loop

    # Switch player: if 1 -> 2, if 2 -> 1
    lw  $t0, currentPlayer
    li  $t1, 1
    beq $t0, $t1, switchTo2
    li  $t0, 1        # else switch to 1
    sw  $t0, currentPlayer
    j   gameLoop

switchTo2:
    li  $t0, 2
    sw  $t0, currentPlayer
    j   gameLoop


exitProgram:
    li $v0, 4
    la $a0, exitMsg
    syscall

    li $v0, 10
    syscall

