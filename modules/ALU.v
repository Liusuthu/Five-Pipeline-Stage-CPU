module ALU (
    input [31:0]In1,
    input [31:0]In2,
    input Sign,
    input [3:0]ALUOp,
    input [5:0]OpCode,

    output reg [31:0]Out,
    output reg Branch,
    output Zero
);
    
    //沿用Control中的一些宏定义
    parameter BEQ=6'h04;
    parameter BNE=6'h05;
    parameter BLEZ=6'h06;
    parameter BGTZ=6'h07;
    parameter BLTZ=6'h01;

    always@(*)begin
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
    end

    assign Zero=(In1==In2);

    //在ALU内部判断是否要分支，由于要对不同的分支指令作区分判断
    //因此做相应设计，把前面指令的OpCode也传过来
    always@(*)begin
        case(OpCode)
            BEQ:Branch=(In1==In2);
            BNE:Branch=~(In1==In2);
            BLEZ:Branch=(In1[31]==1'b1)?1:(In1==32'h00000000)?1:0;
            BGTZ:Branch=(In1[31]==1'b0);
            BLTZ:Branch=(In1[31]==1'b1);
            default:Branch=0;
        endcase
    end


endmodule

//这是一个纯组合逻辑的运算单元