#parameters
ori $s0 $0 0x06             #s0存6,也就是n
ori $a1 $0 0x00000000       #这是对应DataMemory的地址,a1存graph的首地址
ori $t9 $0 1                #和后面的ori $t9 $0 0反差

#bellman_ford
ori $s1 $0 0x00000100       #这是对应DataMemory的地址,s1存dist的首地址
sw $0 0($s1)                #dist[0]=0
ori $t7 $0 -1               #作为常量-1,写入dist数组用
ori $t1 $0 1                #循环变量i

#all dist[i]=-1
Loop1:
sll $t2 $t1 2               #t2=4i
add $t2 $t2 $s1             #新地址为dist+4i
sw $t7 ($t2)                #dist[i]=-1
addi $t1 $t1 1              #i++
sub $a3 $t1 $s0             #a3=t1-s0=i-n
bltz $a3 Loop1              #i<n则再次循环

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
        add $t6 $t6 $s1     #t6是dist[u]的地址
        lw $t4 ($t6)        #t4临时变量,储存dist[u]的值
        or $s2 $0 $t4       #s2=dist[u]
        beq $t4 -1 continue
        #graph[addr] == -1
        add $t6 $t5 $a1     #t6是graph[u,v]的地址
        lw $t4 ($t6)        #t4临时变量,储存graph[u,v]的值
        or $s4 $0 $t4       #s4=graph[u,v]
        beq $t4 -1 continue
        #dist[v] == -1
        sll $t6 $t3 2
        add $t6 $t6 $s1     #t6是dist[v]的地址
        lw $t4 ($t6)        #t4临时变量,储存dist[v]的值
        or $s3 $0 $t4       #s3=dist[v]
        beq $t4 -1 renew
        #dist[v] > dist[u] + graph[addr]
        add $t4 $s2 $s4     #t4临时变量,储存dist[u]+graph[u,v]的值
        sub $a3 $s3 $t4     #a3=s3-t4=dist[v]-(dist[u]+graph[u,v])
        bgtz $a3 renew      #dist[v]>dist[u]+graph[u,v]则更新
        blez $a3 continue   #dist[v]<=dist[u]+graph[u,v]则继续

        renew:
        add $t4 $s2 $s4     #t4临时变量,储存dist[u]+graph[u,v]
        sll $t6 $t3 2
        add $t6 $t6 $s1     #t6是dist[v]的地址
        sw $t4 ($t6)        #更新dist[v]=dist[u]+graph[u,v]

        continue:
        addi $t3 $t3 1
        sub $a3 $t3 $s0
        bltz $a3 Loop4      #v<n则再次循环
    
    addi $t2 $t2 1
    sub $a3 $t2 $s0
    bltz $a3 Loop3          #u<n则再次循环

addi $t1 $t1 1
sub $a3 $t1 $s0
bltz $a3 Loop2              #i<n则再次循环


ori $t9 $0 0                #用t9寄存器存最终的值
ori $t8 $0 1                #循环变量i
Loop:
sll $t6 $t8 2
add $t6 $t6 $s1             #t6是dist[i]的地址
addi $t8 $t8 1
lw $t4 ($t6)
add $t9 $t9 $t4             #t9=t9+dist[i]
bne $t8 $s0 Loop

ori $s7 $0 0x99             #预示着Loop执行完了
