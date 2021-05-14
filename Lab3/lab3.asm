##########################################################################
# Created by:  Pham, Nghia                                               #
#              ngmpham                                                   #
#              May 14 2021                                               #
#                                                                        #
# Assignment:  Lab 3: ASCII-risks (Asterisks)                            #
#              CMPE 012, Computer Systems and Assembly Language          #
#              UC Santa Cruz, Spring 2021                                #
#                                                                        #
# Description: create star pattern with the number in it                 #
#                                                                        #
# Notes:       This program is intended to be run from the MARS IDE.     #
##########################################################################
#psuedo code: 
#python code for star patter
# num = int(input("enter the height:")) meaning asking what is the height of triangle they want to put in
#for i in range(1,num+1) meaning print the first star on the first row then print more star on second row as i increase
	# print("tab betwwen the star " multiply how many time u want to print space(num-i)+"* "*i
	
# there was also an outline I wrote out to plan for this lab:
# the pattern for first row they print 4 space then print the number which mean will be (n-(i+1) where n is the number of user input and i is the number of each row
# for example, if i want to print 4 tab on first row then it will be (5-(1+1) = 5 meaning will print 4 tab then at the 5th tab it will print the interger or star
# moving to second row it will print 3 tab then at the 4th tab it will print star or interger

.data
    height: .asciiz "Enter the height of the pattern (must be greater than 0):    "
    tab: .asciiz "  	 "
    errormessage: .asciiz "Invalid Entry!\n"
    star: .asciiz "*"
    changeline: .asciiz "\n"
.text
main:
    li $v0, 4          # it mean to tell the program to get ready to print something 
    la $a0, height# this giving the detail what it need to printfrom the .data which is the height of the triagnle
    syscall# to tell computer to execute the code
    li $v0, 5 # to read the interger when type in the number
    syscall# execute the code
    move $t0, $v0    # move the user input #vo into register #t0
    blez $t0, Invalid# if register t0 is less than or equal to 0 then it will jump to invalid and give out message "invalid entry!"
    li $t1, 0 # load value of 0 into register t1
    li $t3, 0# load value of 0 into register t3
loop1:
    li $t2, 0# load the value of 0 into register t2
    move $t4, $t1# set register t1 equal to register t4
    sub $t4, $t0, $t1# register t0-t1
    sub $t4, $t4, 1# this subtract register t4 by 1 so that I can get the number of tab
loop2:
    blt $t2, $t4, output# this mean when register t2 is equal to t4 the program will stop printing tab
b loop4 # this will branch to loop 4
loop3:
    blt $t1, $t0, loop1 # this to check if register t1 is less than register t0 then jump to loop 1
    b endprogram #branch to endprogram
 output:
    li $v0, 4# to tell the program be ready to print something
    la $a0, tab# then this will load the tab from .data in to the registwer $a0
    syscall# then will execute the code
    addi $t2, $t2, 1 # this add register t2 by 1 to create the number of tab
    b loop2 # this will branch to loop 2 to see if register t2 and t4 are equal then it will stop printing tab
loop4:
    addi $t3, $t3, 1# add register t3 by 1
    li $v0, 1# this to tell program to print an interger
    la $a0,($t3)# load register t3 into $a0 so it will print the interger 
    syscall#execute the code
    move $t5, $t3# store register t3 into t5
    bgt $t1, 0, loop5# if t1 is grater than 0 then jump to loop 5
line:
    li $v0, 4# to tell the program to be ready to print something
    la $a0, changeline#load the data changeline from the .data
    addi $t1, $t1, 1# add register t1 by 1 so that after the first row then then program can go to second line
    syscall #execute the code
    b loop3 #branch back to loop3
loop5:
    li $v0, 4# tell the program ready to print something
    la $a0, tab# load the tab data in .data so that the program will print tab
    syscall # execute the code
    li $v0, 4# tell the program be ready to print something
    la $a0, star# load the star data in .data into $a0 so that the program can print"*"
    syscall#execute the code
    sub $t5, $t5, 1 # subtract register t5 by 1
    bgt $t5, 1, loop5# this mean if t5 is less than 1 it will go to loop 5, this also mean like if 5>1 then it will print star until when 1>1, then it will print a tab then an interger
    li $v0, 4# to tell program to be ready to print something
    la $a0, tab# print tab from .data
    syscall#execute the code
    addi $t3, $t3, 1# increase register t3 by 1
    li $v0, 1# to tell the program ready to print the interger
    la $a0, ($t3)# print the interger in register t3
    syscall #execute the code
    b line# branch back to line
Invalid:
    li $v0, 4# to tell the program ready to print something
    la $a0, errormessage# this will print the "invalid entry!" message when the user put the input less than or equal to 0 
    syscall# execute the code
    b main# this will to tell the use to put another input again after the wrong input until it is correct input
 endprogram:
    li $v0, 10# to tell the program to stop running
    syscall #execute the code
