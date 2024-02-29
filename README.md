# 流水线 MIPS 处理器的设计

<hr>

如果这个项目帮到了你，请点亮“Follow”与“Star:star:”

<hr>

### 一、实验目的

设计五级流水线MIPS处理器，能正确执行规定的指令集中的指令，并利用此处理器完成最短路径算法的运算，求解最短路径问题。







### 二、设计方案

#### 1、设计框图

![image-20230803231502908](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230803231502908.png)





#### 2、原理说明

##### （1）整体设计

本次设计的流水线MIPS处理器遵循数字逻辑与处理器基础课程中教学的基础框架，为遵循哈佛架构的五级流水线处理器，有IF、ID、EX、MEM、WB五个执行阶段，由PC寄存器、指令存储器、寄存器堆、控制单元、立即数扩展模块、ALU、数据存储器、转发单元、冒险控制单元、级间寄存器和加法器、MUX等等模块组成，如上方设计图所示。



##### （2）跳转指令的设计

j/jal/jr/jalr四个跳转指令在ID阶段，通过解析出来的Jump控制信号来进行判断是否跳转：若Jump控制信号值为1，则需要跳转，并取消下一条指令，并将PC寄存器的输入更新为跳转地址，并根据指令的需求是否将PC+4存入$31寄存器。



##### （3）分支指令的设计

beq/bne/blez/bgtz/bltz等分支指令在ID阶段解析出isBranch信号，标识这是分支指令，在EX阶段经由ALU进行计算得到结果为Branch控制信号，并进行判断：若Branch控制信号为1，则需要分支，取消后两条指令，并把PC寄存器的输入更新为分支地址。



##### （4）ALU控制信号和输入数据的设计

在我的ALU设计中，我抛弃了单周期CPU中冗杂且繁琐的ALUControl控制信号模块，而是在Control扩展模块中直接生成ALU运算的控制信号来控制计算模式，对应关系如下：

`0: add;	1: sub;	2: and;	3: or ;	4: xor;`

`5: nor;	6: sll;	7: sra;	8: srl;	9: slt&sltu;  15: X.`



##### （5）寄存器堆的设计

- 一是先写后读，通过下列代码实现：

```verilog
assign Read_Data_1=(Read_Addr_1==5'b00000)?0:(((Read_Addr_1==Write_Addr)&&RegWrite==1)?Write_Data:RF[Read_Addr_1]);
```

可见，当同一时刻内读取地址和写入地址相同时，直接读出将写入的数据，实现先写后读。

- 二是写入数据通过MemtoReg信号的选择，代码如下：

```verilog
assign WB_RegWrite_Data=(MEM_WB_MemtoReg==2'b01)?MEM_WB_Read_Data:((MEM_WB_MemtoReg==2'b10)?MEM_WB_ALUOut:MEM_WB_PC_4);
```

根据控制信号的不同，可以写入ALU计算结果、数据存储器读取数据、PC+4等。



##### （6）PC输入端口的设计

PC输入端使用三目运算符"?:"代替复杂的MUX来进行输入信号的选择：

```verilog
assign PC_i=EX_Branch?EX_BranchAddr:(ID_Jump?(ID_JumpSrc?ID_JumpAddr:ID_JrAddr):PC_4);
```







### 三、关键代码及文件清单

#### 1、关键代码

##### （1）PC

根据寄存器前的多路选择器的控制信号`PC_MUX`来确定更新PC还是保持PC。

```verilog
case(PC_MUX)
0:PC_o<=PC_o;//keep PC
1:PC_o<=PC_i;//update PC
default:PC_o<=PC_i;//默认update PC
endcase
```

##### （2）InstructionMemory

根据输入的地址读取相应的指令，若地址越界则返回空指令。

```verilog
assign IR=(InstructionAddr[27:2]>255)?(32'h00000000):IRMemory[InstructionAddr[27:2]];
```

##### （3）IF_ID

根据级间寄存器IF_ID前的多路选择器的控制信号`IF_ID_MUX`来确定IF_ID是要正常执行、清除还是保持

```verilog
case(IF_ID_MUX)
//正常数据流
2'b00:begin
	IF_ID_IR<=IR;
    IF_ID_PC_4<=PC_4;
end
//清除(取消)
2'b01:begin
	IF_ID_IR<=32'h00000000;
    IF_ID_PC_4<=32'h00000000;
end
//阻塞(保持)
2'b10:begin
	IF_ID_IR<=IF_ID_IR;
    IF_ID_PC_4<=IF_ID_PC_4;
end
endcase
```

##### （4）RegisterFile

根据输入的地址和数据，进行写入。

```verilog
if(RegWrite && (Write_Addr!=5'b00000)) RF[Write_Addr]<=Write_Data;
```

能够实现“先写后读”的寄存器读取代码。

```verilog
assign Read_Data_1=(Read_Addr_1==5'b00000)?0:(((Read_Addr_1==Write_Addr)&&RegWrite==1)?Write_Data:RF[Read_Addr_1]);
assign Read_Data_2=(Read_Addr_2==5'b00000)?0:(((Read_Addr_2==Write_Addr)&&RegWrite==1)?Write_Data:RF[Read_Addr_2]);
```

##### （5）Control

生成部分控制信号(以几个为例)。

```verilog
assign ExtOp=((OpCode==ANDI)||(OpCode==ORI))?0:1;
assign LuOp=(OpCode==LUI)?1:0;
assign Jump=(((OpCode==R)&&((Funct==JR)||(Funct==JALR)))||((OpCode==J)||(OpCode==JAL)))?1:0;
assign JumpSrc=((OpCode==J)||(OpCode==JAL))?1:0;
……
```

直接生成ALU运算单元的控制信号(共有10种运算模式，1种默认模式不需要运算，且默认`ALUOp=6`)。

```verilog
assign ALUOp=(((OpCode==R)&&((Funct==ADD)||(Funct==ADDU)))||(OpCode==LW)||(OpCode==SW)||(OpCode==LUI)||(OpCode==ADDI)||(OpCode==ADDIU))?4'd0://add
    (((OpCode==R)&&((Funct==SUB)||(Funct==SUBU)))||(OpCode==BEQ)||(OpCode==BNE)||(OpCode==BLEZ)||(OpCode==BGTZ)||(OpCode==BLTZ))?4'd1://sub
    (((OpCode==R)&&(Funct==AND))||(OpCode==ANDI))?4'd2://and
    (((OpCode==R)&&(Funct==OR))||(OpCode==ORI))?4'd3://or
    ((OpCode==R)&&(Funct==XOR))?4'd4://xor
    ((OpCode==R)&&(Funct==NOR))?4'd5://nor
    ((OpCode==R)&&(Funct==SLL))?4'd6://sll
    ((OpCode==R)&&(Funct==SRA))?4'd7://sra
    ((OpCode==R)&&(Funct==SRL))?4'd8://srl
    (((OpCode==R)&&((Funct==SLT)||(Funct==SLTU)))||(OpCode==SLTI)||(OpCode==SLTIU))?4'd9:4'd15;//9:slt,15:X
```

##### （6）ALU

根据控制信号进行相应的运算。

```verilog
case(ALUOp)//这里用非阻塞赋值
    4'd0:Out=In1+In2;//add
    4'd1:Out=In1-In2;//sub
    4'd2:Out=In1&In2;//and
    4'd3:Out=In1|In2;//or
    4'd4:Out=In1^In2;//xor
    4'd5:Out=~(In1|In2);//nor
    4'd6:Out=In2<<(In1[4:0]);//sll
    4'd7:Out= ({{32{In2[31]}},In2}>>In1[4:0]);//sra//本来是64位，赋给32位自动截取
    4'd8:Out=In2>>(In1[4:0]);//srl
    4'd9:Out=Sign?(($signed(In1)<$signed(In2))?1:0):((In1<In2)?1:0);//slt&sltu
    4'd15:Out=32'h00000000;
    default:Out=32'h00000000;
endcase
```

在EX阶段判断是否执行分支。

```verilog
case(OpCode)
    BEQ:Branch=(In1==In2);
    BNE:Branch=~(In1==In2);
    BLEZ:Branch=(In1[31]==1'b1)?1:(In1==32'h00000000)?1:0;
    BGTZ:Branch=(In1[31]==1'b0);
    BLTZ:Branch=(In1[31]==1'b1);
    default:Branch=0;
endcase
```

##### （7）DataMemory

根据输入的地址读取内存。

```verilog
assign Read_Data=MemRead?((Addr[31:28]==4'b0100)?Device[Addr[4:2]]:DTMemory[Addr[8:2]]):32'h00000000;
```

根据给定的地址和数据写入内存。

```verilog
if(MemWrite) begin
    if(Addr==32'h40000010) Device[4]<=Write_Data;
    else DTMemory[Addr[10:2]]<=Write_Data;
end
```

##### （8）ForwardingUnit

分几种需要转发的情况(EX/MEM->ALU, MEM/WB->ALU, Load-use)，生成相应的控制信号。

```verilog
always@(*)begin
//ForwardA
if((EX_MEM_RegWrite==1)&&(EX_MEM_RegWriteAddr!=5'b00000)&&(EX_MEM_RegWriteAddr==ID_EX_Rs)) ForwardA<=2'b10;
else if((MEM_WB_RegWrite)&&(MEM_WB_RegWriteAddr!=5'b00000)&&(MEM_WB_RegWriteAddr==ID_EX_Rs)&&((EX_MEM_RegWriteAddr!=ID_EX_Rs)||(EX_MEM_MemWrite!=1))) ForwardA<=2'b01;
else ForwardA<=2'b00;

//ForwardB
if((EX_MEM_RegWrite==1)&&(EX_MEM_RegWriteAddr!=5'b00000)&&(EX_MEM_RegWriteAddr==ID_EX_Rt)) ForwardB<=2'b10;
else if((MEM_WB_RegWrite)&&(MEM_WB_RegWriteAddr!=5'b00000)&&(MEM_WB_RegWriteAddr==ID_EX_Rt)&&((EX_MEM_RegWriteAddr!=ID_EX_Rt)||(EX_MEM_MemWrite!=1))) ForwardB<=2'b01;
else ForwardB<=2'b00;
end
```

##### （9）HazardUnit

根据各种情况(Load-use/Jump/Branch)更改寄存器前多路选择器的控制信号，以实现正确功能。

```verilog
always@(*)begin
//1、Load-use冒险
if((ID_EX_MemRead==1)&&((ID_EX_Rt==ID_Rs)||(ID_EX_Rt==ID_Rt)))begin
    PC_MUX<=0;
    IF_ID_MUX<=2'b10;
    ID_EX_MUX<=0;
end        
//2、Jump情况
else if(ID_Jump==1)begin
    PC_MUX<=1;
    IF_ID_MUX<=2'b01;
    ID_EX_MUX<=1;
end
//3、Beq情况
else if((ID_EX_isBranch==1)&&(EX_Branch==1))begin
    PC_MUX<=1;
    IF_ID_MUX<=2'b01;
    ID_EX_MUX<=0;
end
//默认情况
else begin
    PC_MUX<=1;
    IF_ID_MUX<=2'b00;
    ID_EX_MUX<=1;
end        
```

##### （10）PipelineCPU

根据控制信号(等价于PCSrc)来选择PC寄存器的输入。

```verilog
assign PC_i=EX_Branch?EX_BranchAddr:(ID_Jump?(ID_JumpSrc?ID_JumpAddr:ID_JrAddr):PC_4);
```

在ID阶段可以计算出跳转地址。

```verilog
assign ID_JumpAddr={IF_ID_PC_4[31:20],IF_ID_IR[19:0],2'b00};
```

在EX阶段可以计算出分支地址。

```verilog
assign EX_BranchAddr=ID_EX_PC_4+{{ID_EX_ExtImmOut[29:0]},2'b0};
```

根据转发控制信号和选择控制信号来确定ALU的两个输入。

```verilog
assign MUXA_Data=(ForwardA==2'b00)?ID_EX_Read_Data_1:((ForwardA==2'b10)?EX_MEM_ALUOut:WB_RegWrite_Data);
assign MUXB_Data=(ForwardB==2'b00)?ID_EX_Read_Data_2:((ForwardB==2'b10)?EX_MEM_ALUOut:WB_RegWrite_Data);
assign In1=(ID_EX_ALUSrc_A==1'b0)?MUXA_Data:ID_EX_Shamt; 
assign In2=(ID_EX_ALUSrc_B==1'b0)?MUXB_Data:ID_EX_ExtImmOut;
```

##### （11）finalver.asm

我使用的是Bellman算法来实现最短路径的计算，更新dist数组的关键代码如下：

```assembly
#dist[v] > dist[u] + graph[addr]
add $t4 $s2 $s4     #t4临时变量,储存dist[u]+graph[u,v]的地址
sub $a3 $s3 $t4     #a3=s3-t4=dist[v]-(dist[u]+graph[u,v])
bgtz $a3 renew      #dist[v]>dist[u]+graph[u,v]则更新
blez $a3 continue   #dist[v]<=dist[u]+graph[u,v]则继续

renew:
add $t4 $s2 $s4     #t4临时变量,储存dist[u]+graph[u,v]
sll $t6 $t3 2
add $t6 $t6 $s1     #t6是dist[v]的地址
sw $t4 ($t6)        #更新dist[v]=dist[u]+graph[u,v]
```

以第0位(最低为数码管)的显示为例介绍显示代码：

①结果存储在$t9中，与`0x000f`进行与运算可以得到最后一位数字；

```assembly
show0:
ori $t1 $0 0
andi $t4 $t9 0x000f
```

②随后根据该位数字进行类似于“case”的判断，得到需要写入BCD的数据

```assembly
#例如需要在最低位显示2o
make02:
ori $t7 $0 0x015b
sw $t7 ($s1)
j delay0
```

③$s0中储存需要循环的次数,结合CPU的时钟周期,可以实现指定时间的延时

```assembly
delay0:
addi $t1 $t1 1
bne $t1 $s0 delay0
j show1
```





#### 2、文件清单

```c
ALU.v						//运算模块
Control.v					//控制信号生成模块
DataMemory.v				//内存模块，有内存和连接外设的功能
Ext.v						//立即数扩展模块
ForwardingUnit.v			//转发信号生成模块
HazardUnit.v				//冒险解决模块
InstructionMemory.v			//指令存储模块
PC.v						//指令寄存器模块
RegisterFile.v				//寄存器堆模块
IF_ID.v						//IF_ID级间寄存器
ID_EX.v						//ID_EX级间寄存器
EX_MEM.v					//EX_MEM级间寄存器
MEM_WB.v					//MEM_WB级间寄存器
PipelineCPU.v				//顶层文件，将所有模块通过一些信号连接
test_cpu_tb.v				//仿真文件

pplCPU.xdc					//管脚约束文件

finalver.asm				//汇编代码文件
```







### 四、仿真结果及分析

#### 1、整体运行情况

##### （1）最短路径算法的运算

![image-20230803235622402](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230803235622402.png)

根据上图，可以看见六个点到源点的距离已经被正确地记录到了DataMemory的相应位置上，十进制分别为：0, 8, 3, 5, 10, 8，符合正确结果。



##### （2）将内存中的值求和并写入寄存器$t9内

![image-20230803235847050](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230803235847050.png)

由上图可知，各点的最短路径之和$0+8+3+5+10+8=34=(22)_{\mathbb{hex}}$，已经正确地写入到了指定的\$25(\$t9)寄存器中。



##### （3）将此值按位间隔一定时间写入BCD外设

![image-20230804000014558](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230804000014558.png)

如上图所示，观察BCD的数值，在15b-25b-43f-83f之间周期轮换，这与我设计的四位轮流显示的正确结果是一致的，最终在板子上运行的结果也验证了这一点。 





#### 2、局部运行情况

##### （1）转发模块生成转发信号

![image-20230804004652307](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230804004652307.png)

上图部分对应执行到Loop2/Loop3/Loop4嵌条对应的代码部分，可以看到这里由于有Load-use冲突和RAW冲突，需要进行数据的转发来保证计算结果的正确性，并注意到图中对应的ForwardA和ForwardB控制信号能正确生成并控制数据的选择，最终得到正确的结果。



##### （2）冒险解决模块生成

![image-20230804004757771](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230804004757771.png)

上图中的PC_MUX / IF_ID_MUX / ID_EX_MUX分别对应三个寄存器前端的选择器，能根据程序要求选择正常进行、阻塞、清除等，由图可见它们也能根据代码需要生成正确的控制信号。



##### （3）跳转与分支的正确实现

![image-20230804004556587](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230804004556587.png)

上图中的EX_Branch信号是EX阶段中由ALU计算得到的控制信号，表明需要分支；ID_Jump信号是在ID阶段解码出的控制信号，表明需要跳转。结合PC_i和PC_o可见这两个信号也能正确的生成并执行。







### 五、综合情况

#### 1、面积占用

![image-20230803234448483](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230803234448483.png)

![image-20230803234514890](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230803234514890.png)

该五级流水线CPU的资源占用情况如上图所示，资源占用率是比较低的。下图为之前写的单周期CPU的资源占用情况，可见相比之下，流水线CPU所占用的资源要远少于单周期CPU，尤其是在IO资源的占用上。

![image-20230603230437116](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230603230437116.png)





#### 2、时序性能

![image-20230803234222323](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230803234222323.png)

![image-20230803234911039](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230803234911039.png)

![image-20230803234920022](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230803234920022.png)

上面三张图展示的是时钟最高频率逼近的过程。一开始将时钟频率设置为20MHz，如图一所示，每周期有24.45ns的余量，故逐渐提高时钟周期，并根据WNS进一步调整。当调整时钟频率为95MHz后，WNS为负数，说明接近极限了。这时我更改代码，对各模块进行优化后，结果如图三所示，故可计算得到，最高时钟频率约为：


$$
f_{\mathbf{Max}}=\frac{1}{{\frac1{95MHz}}-0.346ns}=99.11\mathbf{MHz}
$$
关键路径如下，集中在ID_EX和EX_MEM：

![image-20230804204912721](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230804204912721.png)

![image-20230804204946845](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230804204946845.png)

![image-20230804205010816](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230804205010816.png)

在MARS中运行软件程序，总指令数：

![image-20230804120137492](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230804120137492.png)

根据时钟频率为100MHz的行为级仿真结果所示，运行到该步结束大致需要1194.300ns，也就是需要使用的周期数为：
$$
N=\frac{1194.300×10^{-9}}{\frac1{100×10^6}}=5971.5
$$
![image-20230805140222251](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230805140222251.png)

故该五级流水线CPU在执行这段程序时的CPI大致为：
$$
CPI=\frac{5971.5}{4652}=1.2836
$$
相比于理想情况下的趋于1，CPI略大于1是由于分支指令和跳转指令等会阻塞或取消部分指令，使得吞吐率有所下降，该现象是正常的。







### 六、硬件调试情况

在调试硬件的过程中，为了确保最终能达到预期的效果，我分如下几步进行调试：

① 经过行为级仿真，确保最终运算得到正确结果(存储在DataMemory中)，并将值求和后存储到指定寄存器中。

② 编写一段负责BCD显示的程序，能使得指定寄存器上的值的十六进制形式显示到数码管上，这里用的是软件编译的方法，利用视觉暂留效应来实现四位数字"同时"显示。

③ 确保数码管能正确显示后，将两端程序拼接后重新综合并上传到板子上，最终能正常执行，如下图所示：

（注：一开始由于时钟周期过短，尽管行为级仿真能得到正确结果，但实际上部分指令执行结果出错，上板子后数码管数据显示状况不理想 ，如下面第一张图所示会有重影的问题。 经过时钟分频降低时钟频率后，最终运行结果非常良好，如下第二张图片所示）

![image-20230805130846491](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230805130846491.png)

![image-20230803235404114](C:\Users\asus\AppData\Roaming\Typora\typora-user-images\image-20230803235404114.png)







