module Control (
    input [5:0]OpCode,
    input [5:0]Funct,

    //output [1:0]PCSrc;//用于PC之前的输入做选择，不过流水线的情况更复杂，或许用逻辑直接实现更好
    output Jump,
    output JumpSrc,
    output isBranch,
    output RegWrite,
    output [1:0]RegDst,
    output MemRead,
    output MemWrite,
    output [1:0]MemtoReg,
    output ALUSrc_A,
    output ALUSrc_B,
    output ExtOp,
    output LuOp,
    output Sign,
    output [3:0]ALUOp//直接控制ALU的运算
);

    //OpCode宏定义
    parameter R=6'h00;

    parameter LW=6'h23;
    parameter SW=6'h2b;
    parameter LUI=6'h0f;
    parameter ADDI=6'h08;
    parameter ADDIU=6'h09;
    parameter ANDI=6'h0c;
    parameter SLTI=6'h0a;
    parameter SLTIU=6'h0b;
    parameter ORI=6'h0d;

    parameter BEQ=6'h04;
    parameter BNE=6'h05;
    parameter BLEZ=6'h06;
    parameter BGTZ=6'h07;
    parameter BLTZ=6'h01;//parameter BGEZ=6'h01;但rt=1，且BLTZ的rt=0，要怎么解决???

    parameter J=6'h02;
    parameter JAL=6'h03;

    //Funct宏定义
    parameter ADD=6'h20;
    parameter ADDU=6'h21;
    parameter SUB=6'h22;
    parameter SUBU=6'h23;
    parameter AND=6'h24;
    parameter OR=6'h25;
    parameter XOR=6'h26;
    parameter NOR=6'h27;
    parameter SLL=6'h00;
    parameter SRL=6'h02;
    parameter SRA=6'h03;
    parameter SLT=6'h2a;
    parameter SLTU=6'h2b;
    parameter JR=6'h08;
    parameter JALR=6'h09;

    //下面要根据所有实现的指令，先在理论上实现，然后写出控制信号的生成
    
    assign ExtOp=((OpCode==ANDI)||(OpCode==ORI))?0:1;
    assign LuOp=(OpCode==LUI)?1:0;
    assign Jump=(((OpCode==R)&&((Funct==JR)||(Funct==JALR)))||((OpCode==J)||(OpCode==JAL)))?1:0;
    assign JumpSrc=((OpCode==J)||(OpCode==JAL))?1:0;
    assign RegWrite=((OpCode==R && Funct==JR)||(OpCode==SW)||(OpCode==BEQ)||(OpCode==BNE)||(OpCode==BLEZ)||(OpCode==BGTZ)||(OpCode==BLTZ)||(OpCode==J))?0:1;
    assign MemRead=(OpCode==LW)?1:0;
    assign MemWrite=(OpCode==SW)?1:0;
    assign ALUSrc_A=((OpCode==R)&&((Funct==SLL)||(Funct==SRL)||(Funct==SRA)))?1:0;
    assign ALUSrc_B=((OpCode==R)||(OpCode==BEQ)||(OpCode==BNE)||(OpCode==BLEZ)||(OpCode==BGTZ)||(OpCode==BLTZ))?0:1;
    assign RegDst=(OpCode==R)?2'b10:((OpCode==JALR)||(OpCode==JAL))?2'b11:2'b01;
    assign MemtoReg=((OpCode==JAL)||(OpCode==JALR))?2'b11:(OpCode==LW)?2'b01:2'b10;
    assign Sign=(((OpCode==R)&&(Funct==SLTU))||(OpCode==SLTIU))?0:1;
    assign isBranch=((OpCode==BEQ)||(OpCode==BNE)||(OpCode==BLEZ)||(OpCode==BGTZ)||(OpCode==BLTZ))?1:0;
    
    //ALUOp比较复杂，直接生成控制ALU运算的信号
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


endmodule