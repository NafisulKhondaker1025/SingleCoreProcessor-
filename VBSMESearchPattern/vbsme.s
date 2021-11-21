.text
.globl  vbsme


# Preconditions:
#   1st parameter (a0) address of the first element of the dimension info (address of asize[0])
#   2nd parameter (a1) address of the first element of the frame array (address of frame[0][0])
#   3rd parameter (a2) address of the first element of the window array (address of window[0][0])
# Postconditions:	
#   result (v0) x coordinate of the block in the frame with the minimum SAD
#          (v1) y coordinate of the block in the frame with the minimum SAD


# Begin subroutine
vbsme:

    addi	$sp, $sp, -4
    sw  	$ra, 0($sp)

    li      $v0, 0              # reset $v0 and $V1
    li      $v1, 0

    # insert your code here
    add     $s0, $zero, $zero               #s0 is gonna store index of the frame [j]
    lw      $s1, 0($a0)                     #s1 stores asize[0] 
    lw      $s2, 4($a0)                     #s2 stores asize[1]
    lw      $s3, 8($a0)                     #s3 stores asize[2]
    lw      $s4, 12($a0)                    #s4 stores asize[3]
    addi    $s5, $zero, 0                   #s5 is the row number
    addi    $s6, $zero, 0                   #s6 is the column number
    addi    $s7, $zero, 10000               #s7 stored the minimum SAD
    add     $t8, $zero, $zero 
    add     $t9, $zero, $zero  

    jal     SAD

    traverse:
    addi    $t0, $s1, -1
    addi    $t1, $s2, -1
    slt     $t2, $s5, $t0 
    slt     $t3, $s6, $t1
    or      $t4, $t2, $t3
    beq     $t4, $zero, EXIT

    bne     $t3, $zero, IF_1
    addi    $s5, $s5, 1
    mul     $t0, $s5, $s2
    add     $s0, $t0, $s6
    jal     SAD

    WHILE_1:
    addi    $t0, $s1, -1
    slt     $t2, $s5, $t0 
    slt     $t5, $zero, $s6
    and     $t4, $t2, $t5
    beq     $t4, $zero, traverse_2
    addi    $s6, $s6, -1
    addi    $s5, $s5, 1
    mul     $t0, $s5, $s2
    add     $s0, $t0, $s6
    jal     SAD
    j       WHILE_1

    traverse_2:
    addi    $t0, $s1, -1
    slt     $t2, $s5, $t0 
    bne     $t2, $zero, IF_2
    addi    $t1, $s2, -1
    slt     $t3, $s6, $t1
    or      $t4, $t2, $t3
    beq     $t4, $zero, EXIT

    addi    $s6, $s6, 1
    mul     $t0, $s5, $s2
    add     $s0, $t0, $s6
    jal     SAD

    WHILE_2:
    addi    $t1, $s2, -1
    slt     $t3, $s6, $t1
    slt     $t5, $zero, $s5
    and     $t4, $t3, $t5
    beq     $t4, $zero, traverse
    addi    $s6, $s6, 1
    addi    $s5, $s5, -1
    mul     $t0, $s5, $s2
    add     $s0, $t0, $s6
    jal     SAD
    j       WHILE_2

    IF_1:
    addi    $s6, $s6, 1
    mul     $t0, $s5, $s2
    add     $s0, $t0, $s6
    jal     SAD
    j       WHILE_1

    IF_2:
    addi    $s5, $s5, 1
    mul     $t0, $s5, $s2
    add     $s0, $t0, $s6
    jal     SAD
    j       WHILE_2

    EXIT:
    lw     $ra, 0($sp)
    addi   $sp, $sp, 4
    jr     $ra

    SAD:
    add     $t0, $s6, $s4
    addi    $t1, $s2, 1
    slt     $t3, $t0, $t1
    add     $t0, $s5, $s3
    addi    $t1, $s1, 1
    slt     $t4, $t0, $t1
    and     $t5, $t3, $t4
    bne     $t5, $zero, IF_SAD
    jr      $ra



    IF_SAD:
    add    $t0, $zero, $zero                # this is wi
    add    $t1, $zero, $zero                # this is k
    add    $t2, $zero, $zero                # this is sum 
    add    $t3, $s0, $zero                  # this is fi
    mul    $t4, $s3, $s4                    # asize[0] * asize[1] #changed
    slt    $t5, $t0, $t4
    bne    $t5, $zero, SADLOOP
    jr     $ra
    
    SADLOOP:
    sll    $t5, $t3, 2
    sll    $t6, $t0, 2
    add    $t7, $t5, $a1                    
    add    $t4, $t6, $a2                    
    lw     $t5, 0($t7)                      # frame[fi]
    lw     $t6, 0($t4)                      # window[wi]
    slt    $t7, $t5, $t6
    beq    $t7, $zero, F_W
    
    sub    $t4, $t6, $t5
    j      CONTINUE

    F_W:
    sub    $t4, $t5, $t6

    CONTINUE:
    add    $t2, $t2, $t4                    
    addi   $t7, $s4, -1                     #changed
    slt    $t7, $t1, $t7
    beq    $t7, $zero, IF_SAD_2
    
    addi   $t3, $t3, 1
    addi   $t1, $t1, 1
    addi   $t0, $t0, 1 
    mul    $t4, $s3, $s4                    #changes 
    slt    $t5, $t0, $t4
    bne    $t5, $zero, SADLOOP
    j      MINIMUM
    

    IF_SAD_2:
    sub    $t5, $s2, $s4                    #changed
    addi   $t5, $t5, 1
    add    $t3, $t3, $t5
    add    $t1, $zero, $zero
    mul    $t4, $s3, $s4                    #changes
    addi   $t0, $t0, 1 
    slt    $t5, $t0, $t4
    bne    $t5, $zero, SADLOOP
    
    MINIMUM:
    addi   $t5, $s7, 1
    slt    $t5, $t2, $t5
    beq    $t5, $zero, GOBACK
    add    $v1, $s6, $zero
    add    $v0, $s5, $zero 
    add    $s7, $t2, $zero 

    GOBACK:
    jr     $ra