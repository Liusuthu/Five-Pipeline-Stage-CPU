ori $t9 $0 0x0022
ori $s0 $0 100
ori $s1 $0 0x40000010


show0:
ori $t1 $0 0
andi $t4 $t9 0x000f
beq $t4 $0 make00
addi $a3 $t4 -2
beq $a3 $0 make02
make0:
ori $t7 $0 0x0140
sw $t7 ($s1)
j delay0
make00:
ori $t7 $0 0x013f
sw $t7 ($s1)
j delay0
make02:
ori $t7 $0 0x015b
sw $t7 ($s1)
j delay0




show1:
ori $t1 $0 0
andi $t4 $t9 0x00f0
beq $t4 $0 make10
addi $a3 $t4 -32
beq $a3 $0 make12
make1:
ori $t7 $0 0x0240
sw $t7 ($s1)
j delay1
make10:
ori $t7 $0 0x023f
sw $t7 ($s1)
j delay1
make12:
ori $t7 $0 0x025b
sw $t7 ($s1)
j delay1




show2:
ori $t1 $0 0
andi $t4 $t9 0x0f00
beq $t4 $0 make20
addi $a3 $t4 -256
beq $a3 $0 make22
make2:
ori $t7 $0 0x0440
sw $t7 ($s1)
j delay2
make20:
ori $t7 $0 0x043f
sw $t7 ($s1)
j delay2
make22:
ori $t7 $0 0x045b
sw $t7 ($s1)
j delay2


show3:
ori $t1 $0 0
andi $t4 $t9 0xf000
beq $t4 $0 make30
addi $a3 $t4 -4096
beq $a3 $0 make32
make3:
ori $t7 $0 0x0840
sw $t7 ($s1)
j delay3
make30:
ori $t7 $0 0x083f
sw $t7 ($s1)
j delay3
make32:
ori $t7 $0 0x085b
sw $t7 ($s1)
j delay3







delay0:
addi $t1 $t1 1
bne $t1 $s0 delay0
j show1

delay1:
addi $t1 $t1 1
bne $t1 $s0 delay1
j show2

delay2:
addi $t1 $t1 1
bne $t1 $s0 delay2
j show3

delay3:
addi $t1 $t1 1
bne $t1 $s0 delay3
j show0




