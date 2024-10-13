#***************************************
# Team Member 1 Name: Edgar Cruz
# Team Member 1 Email: ecruz8@hawk.iit.edu
# Course: CS 350
# Assignment: Project 2
# Summary of Assignment Purpose: Dungeon Game
# Date of Initial Creation:12/01/2023
# Description of Program Purpose:  Dungeon Game
# Functions and Modules in this file:   
# main, main_loop, move_up, revertU, move_left, revertL, move_down, revertD, move_right, revertR, checkCell, initializePortal, portal0, portal1, portal2, portal3, exitCell, potion, demon, exit, copy_map, print_map, print_row, print_cell
# Additional Required Files:
# #**************************************

.data 0x10000000
    .asciiz "\nEnter your move: "
.data 0x10000020
    .asciiz "\nw = up, a = left, s = down, d = right, t = exit"
.data 0x10000060
    .asciiz "\n\nCONGRADULATIONS, YOU HAVE REACHED THE EXIT!"
.data 0x10000100
    .asciiz "\nScore: "
.data 0x10000130
    .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

.data 0x10002000
.ascii " ##0 ###"
.ascii "  + @  *"
.ascii "      @#"
.ascii "1@###+ 2"
.ascii "        "
.ascii "  @#### "
.ascii "   3  + "
.ascii "S ## ## "

.data 0x10003000
    .space 64

# The content of the byte describes WHAT is at that map location.
# Here are the values and their meanings:
# 83 = 0x53 = ‘S’: Player’s initial position
# 42 = 0x2A = ‘*’: Exit Gate
# 32 = 0x20 = ‘ ‘: empty space
# 35 = 0x23 = ‘#’: obstacle/walls
#Additional items (these can be ignored by replacing them empty spaces):
# 43 = 0x2B = ‘+’: potions
# 64 = 0x40 = ‘@’: demons
# 48 = 0x30 = ‘0’: portal 0
# 49 = 0x31 = ‘1’: portal 1
# 50 = 0x32 = ‘2’: portal 2
# 51 = 0x33 = ‘3’: portal 3
#Note for Portals: Portal 1 goes to portal 3 (Vice versa), Portal 0 goes to portal 2 (Vice versa)
# 0 --> 0x10002003
# 1 --> 0x10002018
# 2 --> 0x1000201F
# 3 --> 0x10002033

.text
main:
    addi $s2, $0, 0      #Score is stored in register $s2
    addi $s1, $0, ' '    #Empty space is stored in register $s1
    #Load address of Player initial position 'S' on the map in register $t7
    #la $t7, 0x10002038  # address position of 'S' on map stored in $t7
    lui $t7, 0x1000      # load the upper 16 bits of the address
    ori $t7, $t7, 0x2038 # load the lower 16 bits of the address
    lb $t6, 0($t7)       # binary value of 'S' stored in $t6
    or $0, $0, $0 
    j main_loop
    or $0, $0, $0     

main_loop:
    #print new line
    addi $v0, $0, 4
    #la $a0, 0x10000130
    lui $a0, 0x1000      # load the upper 16 bits of the address
    ori $a0, $a0, 0x0130 # load the lower 16 bits of the address
    syscall

    #print map
    #la $t0, dynamic_map   # load the address of the dynamic map
    lui $t0, 0x1000        # load the upper 16 bits of the address
    ori $t0, $t0, 0x3000   # load the lower 16 bits of the address
    #la $t1, 0x10002000    # load the address of the game map
    lui $t1, 0x1000        # load the upper 16 bits of the address
    ori $t1, $t1, 0x2000   # load the lower 16 bits of the address
    addi $t2, $0, 64       # load the number of bytes in the map
    jal copy_map           # jump to the code to copy the map
    or $0, $0, $0

    #print user control instructions to user
    addi $v0, $0, 4
    #la $a0, 0x10000020
    lui $a0, 0x1000      # load the upper 16 bits of the address
    ori $a0, $a0, 0x0020 # load the lower 16 bits of the address
    syscall
    #Print score prompt
    addi $v0, $0, 4
    #la $a0, 0x10000100
    lui $a0, 0x1000      # load the upper 16 bits of the address
    ori $a0, $a0, 0x0100 # load the lower 16 bits of the address
    syscall
    #Print score value
    addi $v0, $0, 1
    #move $a0, $s2
    add $a0, $0, $s2
    syscall
    #User prompt for input
    addi $v0, $0, 4
    #la $a0, 0x10000000
    lui $a0, 0x1000      # load the upper 16 bits of the address
    ori $a0, $a0, 0x0000 # load the lower 16 bits of the address
    syscall

    #Get user input (Player move)
    addi $v0, $0, 12
    syscall
    add $t3, $0, $v0  # Player action is now in $t3

    #Check user input
    addi $t2, $0, 'w'
    beq $t3, $t2, move_up
    or $0, $0, $0
    addi $t2, $0, 'a'
    beq $t3, $t2, move_left
    or $0, $0, $0
    addi $t2, $0, 's'
    beq $t3, $t2, move_down
    or $0, $0, $0
    addi $t2, $0, 'd'
    beq $t3, $t2, move_right
    or $0, $0, $0
    addi $t2, $0, 't'
    beq $t3, $t2, exit
    or $0, $0, $0
    j main_loop
    or $0, $0, $0

# Moves the player up one cell and reads the content of the cell.
move_up:
    sb $s1, 0($t7)          # Remove old position 'S' from map
    or $0, $0, $0
    #Restore Portal
    jal initializePortal
    or $0, $0, $0
    lui $t8, 0x1000         # load the upper 16 bits of the address
    ori $t8, $t8, 0x2003    # load the lower 16 bits of the address
    lb $t8, 0($t8)          # load the content(byte) of portal 0 into $t8   
    or $0, $0, $0 
    addi $t7, $t7, -8       # Update player position address
    # check content of cell
    lb $t4, 0($t7)          # load the content(byte) of the cell into $t4
    or $0, $0, $0
    addi $t2, $0, 0x23      # load the value of '#'
    beq $t4, $t2, revertU   # if cell is a wall, do not move
    or $0, $0, $0
    jal checkCell
    or $0, $0, $0
    sb $t6, 0($t7)          # Stores player('S') at new address position
    or $0, $0, $0
    #print newline
    addi $a0, $0, '\n'      # load a newline character
    addi $v0, $0, 11        # set the syscall number for print character
    syscall
    j main_loop
    or $0, $0, $0

# If the cell above is a wall, the player does not move.
revertU:
    addi $t7, $t7, 8    # Revert player position address
    sb $t6, 0($t7)      # Stores player('S') back at original address position
    or $0, $0, $0
    #print newline
    addi $a0, $0, '\n'  # load a newline character
    addi $v0, $0, 11    # set the syscall number for print character
    syscall
    j main_loop
    or $0, $0, $0

# Moves the player left one cell and reads the content of the cell. 
move_left:
    sb $s1, 0($t7)          # Remove initial position 'S' from map
    or $0, $0, $0
    #Restore Portal
    jal initializePortal
    or $0, $0, $0
    addi $t7, $t7, -1       # Update player position
    # check content of cell
    lb $t4, 0($t7)          # load the content(byte) of the cell into $t4
    or $0, $0, $0
    addi $t2, $0, 0x23      # load the value of '#'
    beq $t4, $t2, revertL   # if cell is a wall, do not move
    or $0, $0, $0
    jal checkCell
    or $0, $0, $0
    sb $t6, 0($t7)          # Stores player('S') at new address position
    or $0, $0, $0
    #print newline
    addi $a0, $0, '\n'      # load a newline character
    addi $v0, $0, 11        # set the syscall number for print character
    syscall
    j main_loop
    or $0, $0, $0

# If the cell to the left is a wall, the player does not move.
revertL:
    addi $t7, $t7, 1    # Revert player position address
    sb $t6, 0($t7)      # Stores player('S') back at original address position
    or $0, $0, $0
    #print newline
    addi $a0, $0, '\n'  # load a newline character
    addi $v0, $0, 11    # set the syscall number for print character
    syscall
    j main_loop
    or $0, $0, $0

# Moves the player down one cell and reads the content of the cell. 
move_down:
    sb $s1, 0($t7)          # Remove initial position 'S' from map
    or $0, $0, $0
    #Restore Portal
    jal initializePortal
    or $0, $0, $0
    addi $t7, $t7, 8        # Update player position
    # check content of cell
    lb $t4, 0($t7)          # load the content(byte) of the cell into $t4
    or $0, $0, $0
    addi $t2, $0, 0x23      # load the value of '#'
    beq $t4, $t2, revertD   # if cell is a wall, do not move
    or $0, $0, $0
    jal checkCell
    or $0, $0, $0
    sb $t6, 0($t7)          # Stores player('S') at new address position
    or $0, $0, $0
    #print newline
    addi $a0, $0, '\n'      # load a newline character
    addi $v0, $0, 11        # set the syscall number for print character
    syscall
    j main_loop
    or $0, $0, $0

# If the cell below is a wall, the player does not move.
revertD:
    addi $t7, $t7, -8   # Revert player position address
    sb $t6, 0($t7)      # Stores player('S') back at original address position
    or $0, $0, $0
    #print newline
    addi $a0, $0, '\n'  # load a newline character
    addi $v0, $0, 11    # set the syscall number for print character
    syscall
    j main_loop
    or $0, $0, $0

# Moves the player right one cell and reads the content of the cell. 
move_right:
    sb $s1, 0($t7)          # Remove initial position 'S' from map
    or $0, $0, $0
    #Restore Portal
    jal initializePortal
    or $0, $0, $0
    addi $t7, $t7, 0x1      # Update player position
    # check content of cell
    lb $t4, 0($t7)          # load the content(byte) of the cell into $t4
    or $0, $0, $0
    addi $t2, $0, 0x23      # load the value of '#'
    beq $t4, $t2, revertR   # if cell is a wall, do not move
    or $0, $0, $0
    jal checkCell
    or $0, $0, $0
    sb $t6, 0($t7)          # Stores player('S') at new address position
    or $0, $0, $0
    #print newline
    addi $a0, $0, '\n'      # load a newline character
    addi $v0, $0, 11        # set the syscall number for print character
    syscall
    j main_loop
    or $0, $0, $0

# If the cell to the right is a wall, the player does not move.
revertR:
    addi $t7, $t7, -1   # Revert player position address
    sb $t6, 0($t7)      # Stores player('S') back at original address position
    or $0, $0, $0
    #print newline
    addi $a0, $0,'\n'   # load a newline character
    addi $v0, $0, 11    # set the syscall number for print character
    syscall
    j main_loop
    or $0, $0, $0

# Checks the content of the cell the player moved to
checkCell:
    addi $t2, $0, 0x2A      # load the value of '*'
    beq $t4, $t2, exitCell  # if cell is an exit, exit game
    or $0, $0, $0
    addi $t2, $0, 0x2B      # load the value of '+'
    beq $t4, $t2, potion    # if cell is a potion, add 100 to score
    or $0, $0, $0
    addi $t2, $0, 0x40      # load the value of '@'
    beq $t4, $t2, demon     # if cell is a demon, reset player position to initial position and reset score to 0
    or $0, $0, $0
    addi $t2, $0, 0x30      # load the value of '0'
    beq $t4, $t2, portal0   # if cell is portal 0, move player to portal 2
    or $0, $0, $0
    addi $t2, $0, 0x31      # load the value of '1'
    beq $t4, $t2, portal1   # if cell is portal 1, move player to portal 3
    or $0, $0, $0
    addi $t2, $0, 0x32      # load the value of '2'
    beq $t4, $t2, portal2   # if cell is portal 2, move player to portal 0
    or $0, $0, $0
    addi $t2, $0, 0x33      # load the value of '3'
    beq $t4, $t2, portal3   # if cell is portal 3, move player to portal 1
    or $0, $0, $0
    jr $ra
    or $0, $0, $0

# Initializes the portals on the map
initializePortal:
    #Portal 0
    lui $t8, 0x1000      # load the upper 16 bits of the address
    ori $t8, $t8, 0x2003 # load the lower 16 bits of the address
    addi $t9, $0, 0x30   # load the value of '0'
    sb $t9, 0($t8)       # load the content(byte) of portal 0 into $t8   
    or $0, $0, $0 
    #Portal 1
    lui $t8, 0x1000      # load the upper 16 bits of the address
    ori $t8, $t8, 0x2018 # load the lower 16 bits of the address
    addi $t9, $0, 0x31   # load the value of '1'
    sb $t9, 0($t8)       # load the content(byte) of portal 0 into $t8   
    or $0, $0, $0 
    #Portal 2
    lui $t8, 0x1000      # load the upper 16 bits of the address
    ori $t8, $t8, 0x201F # load the lower 16 bits of the address
    addi $t9, $0, 0x32   # load the value of '2'
    sb $t9, 0($t8)       # load the content(byte) of portal 0 into $t8
    or $0, $0, $0
    #Portal 3
    lui $t8, 0x1000      # load the upper 16 bits of the address
    ori $t8, $t8, 0x2033 # load the lower 16 bits of the address
    addi $t9, $0, 0x33   # load the value of '3'
    sb $t9, 0($t8)       # load the content(byte) of portal 0 into $t8
    or $0, $0, $0
    jr $ra
    or $0, $0, $0

# Moves the player from portal 0 to portal 2
portal0:
    #sb $s1, 0($t7)      # Remove portal 0 from map
    or $0, $0, $0
    #la $t7, 0x1000201F  # load portal 2 address
    lui $t7, 0x1000      # load the upper 16 bits of the address
    ori $t7, $t7, 0x201F # load the lower 16 bits of the address
    #sb $t6, 0($t7)      # Stores player('S') at portal 2 address
    or $0, $0, $0
    j main_loop
    or $0, $0, $0

# Moves the player from portal 1 to portal 3
portal1:
    #sb $s1, 0($t7)      # Remove portal 1 from map
    or $0, $0, $0
    #la $t7, 0x10002033  # load portal 3 address
    lui $t7, 0x1000      # load the upper 16 bits of the address
    ori $t7, $t7, 0x2033 # load the lower 16 bits of the address
    #sb $t6, 0($t7)      # Stores player('S') at portal 3 address
    or $0, $0, $0
    j main_loop
    or $0, $0, $0

# Moves the player from portal 2 to portal 0
portal2:
    #sb $s1, 0($t7)      # Remove portal 2 from map
    or $0, $0, $0
    #la $t7, 0x10002003  # load portal 0 address
    lui $t7, 0x1000      # load the upper 16 bits of the address
    ori $t7, $t7, 0x2003 # load the lower 16 bits of the address
    #sb $t6, 0($t7)      # Stores player('S') at portal 0 address
    or $0, $0, $0
    j main_loop
    or $0, $0, $0

# Moves the player from portal 3 to portal 1
portal3:
    #sb $s1, 0($t7)      # Remove portal 3 from map
    or $0, $0, $0
    #la $t7, 0x10002018  # load portal 1 address
    lui $t7, 0x1000      # load the upper 16 bits of the address
    ori $t7, $t7, 0x2018 # load the lower 16 bits of the address
    #sb $t6, 0($t7)      # Stores player('S') at portal 1 address
    or $0, $0, $0
    j main_loop
    or $0, $0, $0

# Moves the player to the exit cell, prints the score and exit message, and ends the program
exitCell:
    #print newline
    addi $v0, $0, 4
    #la $a0, 0x10000130
    lui $a0, 0x1000      # load the upper 16 bits of the address
    ori $a0, $a0, 0x0130 # load the lower 16 bits of the address
    syscall
    sb $t6, 0($t7) #Stores player('S') at new position
    or $0, $0, $0
    #Print map
    #la $t0, 0x10003000    # load the address of the dynamic map
    lui $t0, 0x1000        # load the upper 16 bits of the address
    ori $t0, $t0, 0x3000   # load the lower 16 bits of the address
    #la $t1, 0x10002000    # load the address of the game map
    lui $t1, 0x1000        # load the upper 16 bits of the address
    ori $t1, $t1, 0x2000   # load the lower 16 bits of the address
    addi $t2, $0, 64       # load the number of bytes in the map
    jal copy_map    
    or $0, $0, $0       
    #Print score
    addi $v0, $0, 4
    #la $a0, 0x10000100
    lui $a0, 0x1000      # load the upper 16 bits of the address
    ori $a0, $a0, 0x0100 # load the lower 16 bits of the address
    syscall
    #Print score value
    addi $v0, $0, 1
    add $a0, $0, $s2
    syscall
    #print game completion message
    addi $v0, $0, 4
    #la $a0, 0x10000060
    lui $a0, 0x1000      # load the upper 16 bits of the address
    ori $a0, $a0, 0x0060 # load the lower 16 bits of the address
    syscall
    j exit
    or $0, $0, $0

# Removes potion from map and adds 100 to the score
potion:
    addi $s2, $s2, 100  # Add 100 to score 
    sb $t6, 0($t7)      # Stores player at new position
    or $0, $0, $0
    #print newline
    addi $a0, $0, '\n'  # load a newline character
    addi $v0, $0, 11    # set the syscall number for print character
    syscall
    j main_loop
    or $0, $0, $0

# When a player moves to a cell where there is a demon, all the accumulated score is lost
# and the player should begin at the “initial position” again.
demon:
    addi $s2, $0, 0      # Reset score to 0
    #Reset player position to initial position
    #la $t7, 0x10002038  # load initial address position
    lui $t7, 0x1000      # load the upper 16 bits of the address
    ori $t7, $t7, 0x2038 # load the lower 16 bits of the address
    sb $t6, 0($t7)       # Store player('S') at initial position
    or $0, $0, $0
    #print newline
    addi $a0, $0, '\n'   # load a newline character
    addi $v0, $0, 11     # set the syscall number for print character
    syscall
    j main_loop
    or $0, $0, $0

# Exits the game
exit:
    # exit the program
    add $ra, $0, $0
    lui $ra, 0x0040
    ori $ra, $ra, 0x001c
    jr $ra
    or $0, $0, $0

# Copies the game map to the dynamic map
copy_map:
    lb $t3, 0($t1)        # load a byte from the game map
    or $0, $0, $0
    sb $t3, 0($t0)        # store the byte in the dynamic map
    or $0, $0, $0
    addi $t0, $t0, 1      # increment the dynamic map address
    addi $t1, $t1, 1      # increment the game map address
    addi $t2, $t2, -1     # decrement the number of bytes left
    bne $t2, $0, copy_map # if there are bytes left, repeat
    or $0, $0, $0
    # call the function to print the map
    j print_map
    or $0, $0, $0

# Prints the dynamic map
print_map:
    #la $t0, 0x10003000    # load the address of the dynamic map
    lui $t0, 0x1000        # load the upper 16 bits of the address
    ori $t0, $t0, 0x3000   # load the lower 16 bits of the address
    addi $t1, $0, 8        # load the number of rows in the map

print_row:
    addi $t2, $0, 8        # load the number of columns in the map

print_cell:
    lb $a0, 0($t0)         # load a byte from the dynamic map
    or $0, $0, $0
    addi $v0, $0, 11       # set the syscall number for print character
    syscall

    addi $t0, $t0, 1        # increment the dynamic map address
    addi $t2, $t2, -1       # decrement the number of columns left
    bne $t2, $0, print_cell # if there are columns left, repeat
    or $0, $0, $0

    addi $a0, $0, '\n'      # load a newline character
    addi $v0, $0, 11        # set the syscall number for print character
    syscall

    addi $t1, $t1, -1       # decrement the number of rows left
    bne $t1, $0, print_row  # if there are rows left, repeat
    or $0, $0, $0
    jr $ra                  # return to the caller
    or $0, $0, $0
