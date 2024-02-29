module ID_EX (
    input clk,
    input rst,
    input ID_EX_MUX,//ID_EX寄存器输入端的MUX
    //数据
    input [31:0]IF_ID_PC_4,
    input [31:0]ID_Read_Data_1,
    input [31:0]ID_Read_Data_2,
    input [4:0]ID_Rs,
    input [4:0]ID_Rt,
    input [4:0]ID_Rd,
    input [31:0]ID_ExtImmOut,
    input [4:0]ID_Shamt,
    input [5:0]ID_OpCode,
    //控制信号
    //input ID_Jump;
    //input ID_JumpSrc;
    input ID_RegWrite,
    input ID_MemRead,
    input ID_MemWrite,
    input ID_ALUSrc_A,
    input ID_ALUSrc_B,
    input [1:0]ID_RegDst,
    input [1:0]ID_MemtoReg,
    input ID_Sign,
    input ID_isBranch,
    input [3:0]ID_ALUOp,


    //数据
    output reg [31:0]ID_EX_PC_4,
    output reg [31:0]ID_EX_Read_Data_1,
    output reg [31:0]ID_EX_Read_Data_2,
    output reg [4:0]ID_EX_Rs,
    output reg [4:0]ID_EX_Rt,
    output reg [4:0]ID_EX_Rd,
    output reg [31:0]ID_EX_ExtImmOut,
    output reg [4:0]ID_EX_Shamt,
    output reg [5:0]ID_EX_OpCode,
    //控制信号
    //output reg ID_EX_Jump;
    //output reg ID_EX_JumpSrc;
    output reg ID_EX_RegWrite,
    output reg ID_EX_MemRead,
    output reg ID_EX_MemWrite,
    output reg ID_EX_ALUSrc_A,
    output reg ID_EX_ALUSrc_B,
    output reg [1:0]ID_EX_RegDst,
    output reg [1:0]ID_EX_MemtoReg,
    output reg ID_EX_Sign,
    output reg ID_EX_isBranch,
    output reg [3:0]ID_EX_ALUOp
    
);

    always@(posedge clk or posedge rst)begin
        if(rst)begin//复位，所有的信号都置零
            ID_EX_PC_4<=32'h00000000;
            ID_EX_Read_Data_1<=32'h00000000;
            ID_EX_Read_Data_2<=32'h00000000;
            ID_EX_Rs<=5'b00000;
            ID_EX_Rt<=5'b00000;
            ID_EX_Rd<=5'b00000;
            ID_EX_ExtImmOut<=32'h00000000;
            ID_EX_Shamt<=5'b00000;
            ID_EX_OpCode<=6'b000000;

            //ID_EX_Jump<=1'b0;
            //ID_EX_JumpSrc<=1'b0;
            ID_EX_RegWrite<=1'b0;
            ID_EX_MemRead<=1'b0;
            ID_EX_MemWrite<=1'b0;
            ID_EX_ALUSrc_A<=1'b0;
            ID_EX_ALUSrc_B<=1'b0;
            ID_EX_RegDst<=2'b00;
            ID_EX_MemtoReg<=2'b00;
            ID_EX_Sign<=1'b0;
            ID_EX_isBranch<=1'b0;
            ID_EX_ALUOp<=4'b0000;
        end

        else begin//
            case(ID_EX_MUX)
            0:begin//清空Flush
                ID_EX_PC_4<=32'h00000000;
                ID_EX_Read_Data_1<=32'h00000000;
                ID_EX_Read_Data_2<=32'h00000000;
                ID_EX_Rs<=5'b00000;
                ID_EX_Rt<=5'b00000;
                ID_EX_Rd<=5'b00000;
                ID_EX_ExtImmOut<=32'h00000000;
                ID_EX_Shamt<=5'b00000;
                ID_EX_OpCode<=6'b000000;

                //ID_EX_Jump<=1'b0;
                //ID_EX_JumpSrc<=1'b0;
                ID_EX_RegWrite<=1'b0;
                ID_EX_MemRead<=1'b0;
                ID_EX_MemWrite<=1'b0;
                ID_EX_ALUSrc_A<=1'b0;
                ID_EX_ALUSrc_B<=1'b0;
                ID_EX_RegDst<=2'b00;
                ID_EX_MemtoReg<=2'b00;
                ID_EX_Sign<=1'b0;
                ID_EX_isBranch<=1'b0;
                ID_EX_ALUOp<=4'b0000;
            end
            1:begin//正常数据流
                ID_EX_PC_4<=IF_ID_PC_4;
                ID_EX_Read_Data_1<=ID_Read_Data_1;
                ID_EX_Read_Data_2<=ID_Read_Data_2;
                ID_EX_Rs<=ID_Rs;
                ID_EX_Rt<=ID_Rt;
                ID_EX_Rd<=ID_Rd;
                ID_EX_ExtImmOut<=ID_ExtImmOut;
                ID_EX_Shamt<=ID_Shamt;
                ID_EX_OpCode<=ID_OpCode;

                //ID_EX_Jump<=ID_Jump;
                //ID_EX_JumpSrc<=ID_JumpSrc;
                ID_EX_RegWrite<=ID_RegWrite;
                ID_EX_MemRead<=ID_MemRead;
                ID_EX_MemWrite<=ID_MemWrite;
                ID_EX_ALUSrc_A<=ID_ALUSrc_A;
                ID_EX_ALUSrc_B<=ID_ALUSrc_B;
                ID_EX_RegDst<=ID_RegDst;
                ID_EX_MemtoReg<=ID_MemtoReg;
                ID_EX_Sign<=ID_Sign;
                ID_EX_isBranch<=ID_isBranch;
                ID_EX_ALUOp<=ID_ALUOp;
            end
            endcase
        end

    end
    
endmodule

//ID_EX寄存器只有两种状态
//1、正常输入
//2、清空，对应Beq指令需要分支时会取消该阶段的内容