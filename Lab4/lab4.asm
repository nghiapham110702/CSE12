# Spring 2021 CSE12 Lab 4 Template
######################################################
# Macros made for you (you will need to use these)
######################################################

# Macro that stores the value in %reg on the stack 
#	and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#	loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

#################################################
# Macros for you to fill in (you will need these)
#################################################

# Macro that takes as input coordinates in the format
#	(0x00XX00YY) and returns x and y separately.
# args: 
#	%input: register containing 0x00XX00YY
#	%x: register to store 0x000000XX in
#	%y: register to store 0x000000YY in
.macro getCoordinates(%input %x %y)
    # YOUR CODE HERE
    andi %y, %input, 0x000000ff # Masking the y variable 
    andi %x, %input, 0x00ff0000 # Masking x variable
    srl %x, %x, 16 # Shifting x variable to be in correct format
.end_macro

# Macro that takes Coordinates in (%x,%y) where
#	%x = 0x000000XX and %y= 0x000000YY and
#	returns %output = (0x00XX00YY)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store 0x00XX00YY in
.macro formatCoordinates(%output %x %y)
    # YOUR CODE HERE
    add %output, %output, %y
    sll %x, %x, 16
.end_macro

# Macro that converts pixel coordinate to address
# 	  output = origin + 4 * (x + 128 * y)
# 	where origin = 0xFFFF0000 is the memory address
# 	corresponding to the point (0, 0), i.e. the memory
# 	address storing the color of the the top left pixel.
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store memory address in
.macro getPixelAddress(%output %x %y)
    # YOUR CODE HERE
    #li %output, 0xFFFF0000 # Constructing Origin Variable # 1
    mul %output, %y, 128 # multiply y by 128
    add %output, %output, %x # this x plus the (128y)
    mul %output, %output, 4 # this 4 time (x+128y)
    #add %output, %output, %x # Multiplying (origin+4) and ( x+128y)
    addi %output, %output, 0xFFFF0000# origin +(x+128y)



.end_macro

.text
# prevent this file from being run as main
li $v0 10 
syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# Clear_bitmap: Given a color, will fill the bitmap 
#	display with that color.
# -----------------------------------------------------
# Inputs:
#	$a0 = Color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
clear_bitmap: nop
    # YOUR CODE HERE, only use t registers (and a, v where appropriate)
    li $t0, 0xFFFF0000 # this is for Counter
    bodyloop: 
        sw $a0, ($t0) #store
        addi $t0, $t0, 4 # increament #t0 by 4
        bgt $t0, 0xFFFFFFFC, getout # if t0 is greater than 0xFFFFFFC, then it will go to get out which will return regisger
        j bodyloop# but if the value of t0 is not greater than  0xFFFFFFC then it will jump back to body loop 
    getout:
        jr $ra
        # sw instruction help to write the memory from 0xFFFF0000 to the end of the bitmap display addresses. Since MIPS is byte-addressable so If I increase the address by one, 
        #then I move 1 byte over, Since I need to move 4 bytes over which mean I would need to increament the address by 4.

#*****************************************************
# draw_pixel: Given a coordinate in $a0, sets corresponding 
#	value in memory to the color given by $a1
# -----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#		$a1 = color of pixel in format (0x00RRGGBB)
#	Outputs:
#		No register outputs
#*****************************************************
draw_pixel: nop
    # YOUR CODE HERE, only use t registers (and a, v where appropriate)
    getCoordinates($a0, $t0, $t1)# call back macro getcoordinate
    getPixelAddress($t2, $t0, $t1)#call back marcro getPixeladdress
    sw $a1, ($t2) # store a1 into register t2
    jr $ra
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#	Outputs:
#		Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
    # YOUR CODE HERE, only use t registers (and a, v where appropriate)
    getCoordinates($a0, $t0, $t1)# call back macro getcoordinate
    getPixelAddress($t2, $t0, $t1)#call back marcro getPixeladdress
    lw $v0, ($t2) # load data from t2 into v0
    jr $ra
#*****************************************************
# draw_horizontal_line: Draws a horizontal line
# ----------------------------------------------------
# Inputs:
#	$a0 = y-coordinate in format (0x000000YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_horizontal_line: nop
    # YOUR CODE HERE, only use t registers (and a, v where appropriate)
    #mul $t0, $a0, 128
    #mul $t0, $t0, 4
    #addi $t0, $t0, 0xFFFF0000 #X
   li $t0, 0x00000000
    horizontalloop:
        getPixelAddress($t2, $t0, $a0)
        sw $a1, ($t2)
        addi $t0, $t0, 1# increment t0 by 1
        bgt $t0, 127, end # if the t0 is greater than 127 it will branch to (end) which will jump return register
        j horizontalloop# if t0 is not greater than 127 then it will jump back to loop horizontal loop until it is greater than 127
        # a line is just basically the long memory, sicne we are doing 128
        # this code will do that it will draw the memory from 0 to 127 which mean when it reach to 127 then it will stop producing memory. 
     end:
         jr $ra

#*****************************************************
# draw_vertical_line: Draws a vertical line
# ----------------------------------------------------
# Inputs:
#	$a0 = x-coordinate in format (0x000000XX)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_vertical_line: nop
    # YOUR CODE HERE, only use t registers (and a, v where appropriate)
    li $v0, 1
    syscall 
    li $t5, 0x00000000 #y
    vert_loop:
        getPixelAddress($t4, $a0, $t5)# a line is just basically the long memory, sicne we are doing 128
        # this code will do that it will draw the memory from 0 to 127 which mean when it reach to 127 then it will stop producing memory. 
        sw $a1, ($t4)
        addi $t5, $t5, 1
        bgt, $t5, 127, stop
        j vert_loop
    stop:
        jr $ra

#*****************************************************
# draw_crosshair: Draws a horizontal and a vertical 
#	line of given color which intersect at given (x, y).
#	The pixel at (x, y) should be the same color before 
#	and after running this function.
# -----------------------------------------------------
# Inputs:
#	$a0 = (x, y) coords of intersection in format (0x00XX00YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_crosshair: nop
	push($ra)
	 getCoordinates($a0, $t0, $t1)# recall the macro funtion
   	 getPixelAddress($t2, $t0, $t1)
   	 lw $t6,($t2) 
    	push($t0)# push all the register value to stack memory
  #so that it can conserve the value of y coordinate, which mean the position of y and x will not be change.
    	push($t1)
    	push($t2)
    	push($t6)
    	push($a0)
    	srl $a0,$a0,16 # this will shift another right logical from where it is to 16 space
    	jal draw_vertical_line #then jump to vertical line function which will draw the vertical line at that position
   	pop($a0)
    	jal draw_horizontal_line# this will draw the horizontal line
   	 nop
    	pop($t6)# sincd the push put the value of register on top of eachother to keep it value to be conserve, the pop will do the opposite
    	# where they do botton to top so that they can conserve the value of x coorsinate
    	pop($t2)
    	pop($t1)
    	pop($t0)
    	sw $t6,($t2)
	
	# HINT: Store the pixel color at $a0 before drawing the horizontal and 
	# vertical lines, then afterwards, restore the color of the pixel at $a0 to 
	# give the appearance of the center being transparent.
	
	# Note: Remember to use push and pop in this function to save your t-registers
	# before calling any of the above subroutines.  Otherwise your t-registers 
	# may be overwritten.  
	
	# YOUR CODE HERE, only use t0-t7 registers (and a, v where appropriate)
   	

	# HINT: at this point, $ra has changed (and you're likely stuck in an infinite loop). 
	# Add a pop before the below jump return (and push somewhere above) to fix this.
	jr $ra
