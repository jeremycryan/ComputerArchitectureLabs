addi $t0, $zero, 11
xori $t1, $t0, 1

BRANCH:
bne $t0, $t1, SPOT1
j END

SPOT1:
jal SPOT2
add $t0, $zero, $zero
add $t0, $zero, $zero 
add $t0, $zero, $zero
add $t0, $zero, $zero
j END

SPOT2:
jr $ra

END:
addi $v0, $zero, 42