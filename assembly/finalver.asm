.data
graph:.space 512
dist:.space 64
bcd:.space 64



.text
#parameters
ori $s0 $0 0x06             #s0�??6,也就是n
la $a1 graph                #这是对应DataMemory的地�??,a1存graph的首地址
ori $t9 $0 1                #和后面的ori $t9 $0 0反差

#initialize graph
ori $t7 $0 0
sw $t7 0($a1)
sw $t7 24($a1)
sw $t7 28($a1)
sw $t7 36($a1)
sw $t7 56($a1)
sw $t7 60($a1)
sw $t7 72($a1)
sw $t7 88($a1)
sw $t7 92($a1)
sw $t7 108($a1)
sw $t7 120($a1)
sw $t7 124($a1)
sw $t7 144($a1)
sw $t7 152($a1)
sw $t7 156($a1)
sw $t7 180($a1)
sw $t7 184($a1)
sw $t7 188($a1)
ori $t7 $0 9
sw $t7 4($a1)
sw $t7 32($a1)
ori $t7 $0 3
sw $t7 8($a1)
sw $t7 44($a1)
sw $t7 64($a1)
sw $t7 100($a1)
ori $t7 $0 6
sw $t7 12($a1)
sw $t7 96($a1)
sw $t7 112($a1)
sw $t7 140($a1)
ori $t7 $0 -1
sw $t7 16($a1)
sw $t7 20($a1)
sw $t7 40($a1)
sw $t7 68($a1)
sw $t7 80($a1)
sw $t7 116($a1)
sw $t7 128($a1)
sw $t7 136($a1)
sw $t7 160($a1)
sw $t7 172($a1)
ori $t7 $0 4
sw $t7 48($a1)
sw $t7 132($a1)
ori $t7 $0 1
sw $t7 52($a1)
sw $t7 164($a1)
ori $t7 $0 2
sw $t7 76($a1)
sw $t7 104($a1)
sw $t7 148($a1)
sw $t7 176($a1)
ori $t7 $0 5
sw $t7 84($a1)
sw $t7 168($a1)



#bellman_ford
la $s1 dist                 #这是对应DataMemory的地�??,s1存dist的首地址
sw $0 0($s1)                #dist[0]=0
ori $t7 $0 -1               #作为常量-1,写入dist数组�??
ori $t1 $0 1                #循环变量i

#all dist[i]=-1
Loop1:
sll $t2 $t1 2               #t2=4i
add $t2 $t2 $s1             #新地�??为dist+4i
sw $t7 ($t2)                #dist[i]=-1
addi $t1 $t1 1              #i++
sub $a3 $t1 $s0             #a3=t1-s0=i-n
bltz $a3 Loop1              #i<n则再次循�??

#Relaxation for (n-1) times
ori $t1 $0 1                #循环变量i
ori $t2 $0 0                #循环变量u
ori $t3 $0 0                #循环变量v

Loop2:
    #Relaxation on every edge each time
    ori $t2 $0 0            #每次进入Loop3前u置零
    Loop3:
        ori $t3 $0 0        #每次进入Loop4前v置零
        Loop4:
        sll $t5 $t2 3
        add $t5 $t5 $t3
        sll $t5 $t5 2       #t5=4*(8u+v),对应graph索引addr(u,v)大小
        #dist[u] == -1
        sll $t6 $t2 2
        add $t6 $t6 $s1     #t6是dist[u]的地�??
        lw $t4 ($t6)        #t4临时变量,储存dist[u]的�??
        or $s2 $0 $t4       #s2=dist[u]
        beq $t4 -1 continue
        #graph[addr] == -1
        add $t6 $t5 $a1     #t6是graph[u,v]的地�??
        lw $t4 ($t6)        #t4临时变量,储存graph[u,v]的�??
        or $s4 $0 $t4       #s4=graph[u,v]
        beq $t4 -1 continue
        #dist[v] == -1
        sll $t6 $t3 2
        add $t6 $t6 $s1     #t6是dist[v]的地�??
        lw $t4 ($t6)        #t4临时变量,储存dist[v]的�??
        or $s3 $0 $t4       #s3=dist[v]
        beq $t4 -1 renew
        #dist[v] > dist[u] + graph[addr]
        add $t4 $s2 $s4     #t4临时变量,储存dist[u]+graph[u,v]的�??
        sub $a3 $s3 $t4     #a3=s3-t4=dist[v]-(dist[u]+graph[u,v])
        bgtz $a3 renew      #dist[v]>dist[u]+graph[u,v]则更�??
        blez $a3 continue   #dist[v]<=dist[u]+graph[u,v]则继�??

        renew:
        add $t4 $s2 $s4     #t4临时变量,储存dist[u]+graph[u,v]
        sll $t6 $t3 2
        add $t6 $t6 $s1     #t6是dist[v]的地�??
        sw $t4 ($t6)        #更新dist[v]=dist[u]+graph[u,v]

        continue:
        addi $t3 $t3 1
        sub $a3 $t3 $s0
        bltz $a3 Loop4      #v<n则再次循�??
    
    addi $t2 $t2 1
    sub $a3 $t2 $s0
    bltz $a3 Loop3          #u<n则再次循�??

addi $t1 $t1 1
sub $a3 $t1 $s0
bltz $a3 Loop2              #i<n则再次循�??


ori $t9 $0 0                #用t9寄存器存�??终的�??
ori $t8 $0 1                #循环变量i
Loop:
sll $t6 $t8 2
add $t6 $t6 $s1             #t6是dist[i]的地�??
addi $t8 $t8 1
lw $t4 ($t6)
add $t9 $t9 $t4             #t9=t9+dist[i]
bne $t8 $s0 Loop

ori $s7 $0 0x99             #预示�??Loop执行完了


