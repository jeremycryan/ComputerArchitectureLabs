xori $t0, $zero, 20
xori $t2, $zero, 9

sub $t1, $t0, $zero
sub $t3, $t2, $t0

slt $t4, $zero, $zero
slt $t4, $t2, $t0
slt $t4, $t2, $zero

sw $t2, 20($zero)
sw $t0, 0($t2)

lw $t5, 0($t0)
lw $t6, 9($zero)

