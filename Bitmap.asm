.data
    # Bitmap display at 0x10008400 (heap)
    displayAddress: .word 0x10004000
    
    # Colors for board, characters, etc
    white:     .word 0xFFFFFF
    black:     .word 0x000000
    gridColor: .word 0x808080 # Gray
    
    # Game board (3x3, stores 0=empty, 1=X, 2=O)
    board: .word 0, 0, 0, 0, 0, 0, 0, 0, 0

.text
.globl main

main:
    # Initialize the display
    jal clearScreen
    jal drawGrid
    
    # Exit
    li $v0, 10
    syscall

# Clear the entire screen to white
clearScreen:
    lw $t0, displayAddress
    lw $t1, white
    li $t2, 0          # counter
    li $t3, 4096       # 64x64 = 4096 pixels (for 512x512 display with 8x8 units)
    
clearLoop:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    blt $t2, $t3, clearLoop
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