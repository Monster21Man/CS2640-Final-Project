# Bitmap.asm
# CS2640.02 Group 5 Final Project
# Logan Bailey, Marco Joson, Russell Salvador, Jay Wu
# December 7th, 2025
# This file contains all bitmap display functions for the Tic Tac Toe game
# This file should be included with the main game file using: .include "Bitmap.asm"

.text

# Clear the entire screen to white
clearScreen:
    lw $t0, displayAddress
    lw $t1, white
    li $t2, 0          # counter
    li $t3, 4096       # 64x64 = 4096 pixels

clearScreenLoop:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    blt $t2, $t3, clearScreenLoop
    jr $ra

# Draw the tic-tac-toe grid
drawGrid:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Draw vertical lines at x=21 and x=42 
    li $a0, 21
    li $a1, 0
    li $a2, 64
    jal drawVerticalLine
    
    li $a0, 42
    li $a1, 0
    li $a2, 64
    jal drawVerticalLine
    
    # Draw horizontal lines at y=21 and y=42
    li $a0, 0
    li $a1, 21
    li $a2, 64
    jal drawHorizontalLine
    
    li $a0, 0
    li $a1, 42
    li $a2, 64
    jal drawHorizontalLine
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Draw vertical line: $a0=x, $a1=y_start, $a2=y_end
drawVerticalLine:
    lw $t0, displayAddress
    lw $t1, gridColor
    move $t2, $a1      # current y pos
    
vLoop:
    # Calculate the offset: (y * 64 + x) * 4
    mul $t3, $t2, 64
    add $t3, $t3, $a0
    sll $t3, $t3, 2    # multiply by 4 for word addressing
    add $t3, $t3, $t0
    sw $t1, 0($t3)
    
    addi $t2, $t2, 1
    blt $t2, $a2, vLoop
    jr $ra

# Draw horizontal line: $a0=x_start, $a1=y, $a2=x_end
drawHorizontalLine:
    lw $t0, displayAddress
    lw $t1, gridColor
    move $t2, $a0      # current x pos
    
hLoop:
    # Calculate offset: (y * 64 + x) * 4
    mul $t3, $a1, 64
    add $t3, $t3, $t2
    sll $t3, $t3, 2
    add $t3, $t3, $t0
    sw $t1, 0($t3)
    
    addi $t2, $t2, 1
    blt $t2, $a2, hLoop
    jr $ra

########################################
# X AND O DRAWING FUNCTIONS
########################################

# Draw a move on the bitmap
# $a0 = column (1-3)
# $a1 = row (1-3)
# $a2 = player (1=X, 2=O)
drawMove:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Calculate base position for the cell
    # Each cell is 21x21 pixels
    # Cell (col, row) starts at:
    # x = (col-1) * 21 + margin
    # y = (row-1) * 21 + margin
    # Using margins to center the symbols
    
    addi $t0, $a0, -1   # col-1
    li $t1, 21
    mul $t0, $t0, $t1   # (col-1)*21
    addi $t0, $t0, 5    # add margin for centering (5 pixels)
    
    addi $t2, $a1, -1   # row-1
    mul $t2, $t2, $t1   # (row-1)*21
    addi $t2, $t2, 5    # add margin for centering
    
    # $t0 = x start position
    # $t2 = y start position
    
    # Check if player 1 (X) or player 2 (O)
    li $t3, 1
    beq $a2, $t3, drawX
    j drawO

drawX:
    # FIXED: Save $t0 and $t2 to stack before drawing lines
    # because drawDiagonalLine1 will modify them!
    addi $sp, $sp, -8
    sw $t0, 0($sp)     # save base x
    sw $t2, 4($sp)     # save base y
    
    # Draw X as two diagonal lines
    # Line from top-left to bottom-right
    move $a0, $t0         # x start
    move $a1, $t2         # y start
    addi $a2, $t0, 10     # x end (10 pixels wide)
    addi $a3, $t2, 10     # y end (10 pixels tall)
    lw $s0, xColor
    jal drawDiagonalLine1
    
    # Restore $t0 and $t2 for second line
    lw $t0, 0($sp)     # restore base x
    lw $t2, 4($sp)     # restore base y
    
    # Line from top-right to bottom-left
    addi $a0, $t0, 10     # x start (right side)
    move $a1, $t2         # y start (top)
    move $a2, $t0         # x end (left side)
    addi $a3, $t2, 10     # y end (bottom)
    lw $s0, xColor
    jal drawDiagonalLine1
    
    # Clean up stack
    addi $sp, $sp, 8
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

drawO:
    # Draw O as a filled circle approximation (square for simplicity)
    # Draw a rectangle outline
    move $a0, $t0         # x start
    move $a1, $t2         # y start
    addi $a2, $t0, 10     # x end
    addi $a3, $t2, 10     # y end
    lw $s0, oColor
    jal drawRectangleOutline
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Draw diagonal line from (a0,a1) to (a2,a3) in color $s0
drawDiagonalLine1:
    lw $t0, displayAddress
    move $t1, $a0      # current x
    move $t2, $a1      # current y
    
    # Calculate delta
    sub $t3, $a2, $a0  # dx
    sub $t4, $a3, $a1  # dy
    
    # Determine step direction
    slt $t5, $t3, $zero
    beq $t5, 1, negDX
    li $t5, 1
    j checkDY
negDX:
    li $t5, -1
    
checkDY:
    slt $t6, $t4, $zero
    beq $t6, 1, negDY
    li $t6, 1
    j diagLoop
negDY:
    li $t6, -1
    
diagLoop:
    # Draw pixel at (t1, t2)
    mul $t7, $t2, 64
    add $t7, $t7, $t1
    sll $t7, $t7, 2
    add $t7, $t7, $t0
    sw $s0, 0($t7)
    
    # Check if we've reached the end
    beq $t1, $a2, diagDone
    beq $t2, $a3, diagDone
    
    # Step to next pixel
    add $t1, $t1, $t5
    add $t2, $t2, $t6
    j diagLoop
    
diagDone:
    jr $ra

# Draw rectangle outline from (a0,a1) to (a2,a3) in color $s0
drawRectangleOutline:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a2, 4($sp)     # Save original a2
    sw $a3, 8($sp)     # Save original a3
    sw $a0, 12($sp)    # Save original a0
    
    # Save start coordinates in temp registers
    move $t8, $a0      # x start
    move $t9, $a1      # y start
    
    # Get end coordinates
    lw $t6, 4($sp)     # x end
    lw $t7, 8($sp)     # y end
    
    # Top line (y = t9, x from t8 to t6)
    move $a0, $t8
    move $a1, $t9
    move $a2, $t6
    jal drawHorizontalLine2
    
    # Bottom line (y = t7, x from t8 to t6)
    move $a0, $t8
    move $a1, $t7
    move $a2, $t6
    jal drawHorizontalLine2
    
    # Left line (x = t8, y from t9 to t7)
    move $a0, $t8
    move $a1, $t9
    move $a2, $t7
    jal drawVerticalLine2
    
    # Right line (x = t6, y from t9 to t7)
    move $a0, $t6
    move $a1, $t9
    move $a2, $t7
    jal drawVerticalLine2
    
    lw $ra, 0($sp)
    addi $sp, $sp, 16
    jr $ra

# Helper: Draw horizontal line with color $s0
drawHorizontalLine2:
    lw $t0, displayAddress
    move $t2, $a0      # current x
    
hLoop2:
    mul $t3, $a1, 64
    add $t3, $t3, $t2
    sll $t3, $t3, 2
    add $t3, $t3, $t0
    sw $s0, 0($t3)
    
    addi $t2, $t2, 1
    ble $t2, $a2, hLoop2
    jr $ra

# Helper: Draw vertical line with color $s0
drawVerticalLine2:
    lw $t0, displayAddress
    move $t2, $a1      # current y
    
vLoop2:
    mul $t3, $t2, 64
    add $t3, $t3, $a0
    sll $t3, $t3, 2
    add $t3, $t3, $t0
    sw $s0, 0($t3)
    
    addi $t2, $t2, 1
    ble $t2, $a2, vLoop2
    jr $ra