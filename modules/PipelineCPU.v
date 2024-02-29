module PipelineCPU (
    input clk,
    input rst,
    output [11:0]BCD
);

    /* wire clk;
    
    clk_wiz_0 clk_wiz(
        .clk_out1(clk),
        .reset(rst),
        .clk_in1(sysclk)
    ); */
    
    wire PC_MUX;
    wire [31:0]PC_i;
    wire [31:0]PC_o;
    wire [31:0]PC_4;

    wire [31:0]IF_IR;

    wire [1:0]IF_ID_MUX;
    wire [31:0]IF_ID_IR;
    wire [31:0]IF_ID_PC_4;

    wire [5:0]ID_OpCode;
    wire [5:0]ID_Funct;
    wire [4:0]ID_Rs;
    wire [4:0]ID_Rt;
    wire [4:0]ID_Rd;
    wire [4:0]ID_Shamt;    
    wire ID_Jump;
    wire ID_JumpSrc;
    wire ID_isBranch;
    wire ID_RegWrite;
    wire [1:0]ID_RegDst;
    wire ID_MemRead;
    wire ID_MemWrite;
    wire [1:0]ID_MemtoReg;
    wire ID_ALUSrc_A;
    wire ID_ALUSrc_B;
    wire ID_ExtOp;
    wire ID_LuOp;
    wire ID_Sign;
    wire [3:0]ID_ALUOp;

    wire [15:0]ID_Imm;
    wire [31:0]ID_ExtImmOut;

    wire [31:0]ID_Read_Data_1;
    wire [31:0]ID_Read_Data_2;

    wire [31:0]ID_JumpAddr;
    wire [31:0]ID_JrAddr;

    wire ID_EX_MUX;
    wire [31:0]ID_EX_PC_4;
    wire [31:0]ID_EX_Read_Data_1;
    wire [31:0]ID_EX_Read_Data_2;
    wire [4:0]ID_EX_Rs;
    wire [4:0]ID_EX_Rt;
    wire [4:0]ID_EX_Rd;
    wire [31:0]ID_EX_ExtImmOut;
    wire [4:0]ID_EX_Shamt;
    wire [5:0]ID_EX_OpCode;
    //wire ID_EX_Jump;//这两个还用得到么�?
    //wire ID_EX_JumpSrc;//同上
    wire ID_EX_isBranch;
    wire ID_EX_RegWrite;
    wire [1:0]ID_EX_RegDst;
    wire ID_EX_MemRead;
    wire ID_EX_MemWrite;
    wire [1:0]ID_EX_MemtoReg;
    wire ID_EX_ALUSrc_A;
    wire ID_EX_ALUSrc_B;
    wire ID_EX_Sign;
    wire [3:0]ID_EX_ALUOp;

    wire [1:0]ForwardA;
    wire [1:0]ForwardB;

    wire [31:0]In1;
    wire [31:0]In2;
    wire EX_Zero;
    wire EX_Branch;
    wire [31:0]EX_ALUOut;

    wire [31:0]EX_BranchAddr;
    wire [4:0]EX_RegWriteAddr;
    wire [31:0]MUXA_Data;
    wire [31:0]MUXB_Data;

    wire [4:0]EX_MEM_RegWriteAddr;
    wire [31:0]EX_MEM_ALUOut;
    wire [31:0]EX_MEM_PC_4;
    wire [31:0]EX_MEM_MUXB_Data;
    wire EX_MEM_MemWrite;
    wire EX_MEM_MemRead;
    wire [1:0]EX_MEM_MemtoReg;
    wire EX_MEM_RegWrite;

    wire [31:0]MEM_Read_Data;

    wire [4:0]MEM_WB_RegWriteAddr;
    wire [31:0]MEM_WB_ALUOut;
    wire [31:0]MEM_WB_PC_4;
    wire [31:0]MEM_WB_Read_Data;
    wire [1:0]MEM_WB_MemtoReg;
    wire MEM_WB_RegWrite;

    wire [31:0]WB_RegWrite_Data;


    
    //HarzardUnit实时监测
    HazardUnit pplHazardUnit(.ID_EX_MemRead(ID_EX_MemRead),.ID_EX_Rt(ID_EX_Rt),.ID_Rs(ID_Rs),.ID_Rt(ID_Rt),
                            .ID_Jump(ID_Jump),.EX_Branch(EX_Branch),.ID_EX_isBranch(ID_EX_isBranch),.PC_MUX(PC_MUX),
                            .IF_ID_MUX(IF_ID_MUX),.ID_EX_MUX(ID_EX_MUX));
    //FordwardingUnit实时监测
    ForwardingUnit pplForwardingUnit(.ID_EX_Rs(ID_EX_Rs),.ID_EX_Rt(ID_EX_Rt),.EX_MEM_RegWrite(EX_MEM_RegWrite),
                                    .MEM_WB_RegWrite(MEM_WB_RegWrite),.EX_MEM_RegWriteAddr(EX_MEM_RegWriteAddr),
                                    .MEM_WB_RegWriteAddr(MEM_WB_RegWriteAddr),.EX_MEM_MemWrite(EX_MEM_MemWrite),
                                    .ForwardA(ForwardA),.ForwardB(ForwardB));


    //IF
    PC pplPC(.clk(clk),.rst(rst),.PC_MUX(PC_MUX),.PC_i(PC_i),.PC_o(PC_o));

    InstructionMemory pplInstructionMemory(.rst(rst),.InstructionAddr(PC_o),.IR(IF_IR));

    assign PC_4=PC_o+32'd4;    
    assign PC_i=EX_Branch?EX_BranchAddr:(ID_Jump?(ID_JumpSrc?ID_JumpAddr:ID_JrAddr):PC_4);


    //IF_ID
    IF_ID pplIF_ID(.clk(clk),.rst(rst),.IF_ID_MUX(IF_ID_MUX),.IR(IF_IR),.PC_4(PC_4),.IF_ID_IR(IF_ID_IR),.IF_ID_PC_4(IF_ID_PC_4));
    

    //ID
    assign ID_OpCode=IF_ID_IR[31:26];
    assign ID_Funct=IF_ID_IR[5:0];
    assign ID_Rs=IF_ID_IR[25:21];
    assign ID_Rt=IF_ID_IR[20:16];
    assign ID_Rd=IF_ID_IR[15:11];
    assign ID_Shamt=IF_ID_IR[10:6];
    assign ID_Imm=IF_ID_IR[15:0];

    assign ID_JrAddr=ID_Read_Data_1;
    assign ID_JumpAddr={IF_ID_PC_4[31:20],IF_ID_IR[19:0],2'b00};
    //(上条说明)由于Mars地址和本系统地址存在差异，�?�且我的程序本身代码量不会太大，因此要�?�过这种方式来得到地�?，�?�不是{IF_ID_PC_4[31:28],IF_ID_IR[25:0],2'b00}

    Control pplControl(.OpCode(ID_OpCode),.Funct(ID_Funct),.Jump(ID_Jump),.JumpSrc(ID_JumpSrc),.isBranch(ID_isBranch),
                        .RegWrite(ID_RegWrite),.RegDst(ID_RegDst),.MemRead(ID_MemRead),.MemWrite(ID_MemWrite),.MemtoReg(ID_MemtoReg),
                        .ALUSrc_A(ID_ALUSrc_A),.ALUSrc_B(ID_ALUSrc_B),.ExtOp(ID_ExtOp),.LuOp(ID_LuOp),.Sign(ID_Sign),.ALUOp(ID_ALUOp));

    RegisterFile pplRegisterFile(.clk(clk),.rst(rst),.RegWrite(MEM_WB_RegWrite),.Read_Addr_1(ID_Rs),.Read_Addr_2(ID_Rt),
                                    .Write_Addr(MEM_WB_RegWriteAddr),.Write_Data(WB_RegWrite_Data),.Read_Data_1(ID_Read_Data_1),
                                    .Read_Data_2(ID_Read_Data_2));

    Ext pplExt(.ExtOp(ID_ExtOp),.LuOp(ID_LuOp),.Imm(ID_Imm),.ExtImmOut(ID_ExtImmOut));



    //ID_EX
    ID_EX pplID_EX(.clk(clk),.rst(rst),.ID_EX_MUX(ID_EX_MUX),.IF_ID_PC_4(IF_ID_PC_4),.ID_Read_Data_1(ID_Read_Data_1),.ID_Read_Data_2(ID_Read_Data_2),
                    .ID_Rs(ID_Rs),.ID_Rt(ID_Rt),.ID_Rd(ID_Rd),.ID_ExtImmOut(ID_ExtImmOut),.ID_Shamt(ID_Shamt),.ID_OpCode(ID_OpCode),.ID_RegWrite(ID_RegWrite),
                    .ID_MemRead(ID_MemRead),.ID_MemWrite(ID_MemWrite),.ID_ALUSrc_A(ID_ALUSrc_A),.ID_ALUSrc_B(ID_ALUSrc_B),.ID_RegDst(ID_RegDst),
                    .ID_MemtoReg(ID_MemtoReg),.ID_Sign(ID_Sign),.ID_isBranch(ID_isBranch),.ID_ALUOp(ID_ALUOp),
                    .ID_EX_PC_4(ID_EX_PC_4),.ID_EX_Read_Data_1(ID_EX_Read_Data_1),.ID_EX_Read_Data_2(ID_EX_Read_Data_2),.ID_EX_Rs(ID_EX_Rs),.ID_EX_Rt(ID_EX_Rt),
                    .ID_EX_Rd(ID_EX_Rd),.ID_EX_ExtImmOut(ID_EX_ExtImmOut),.ID_EX_Shamt(ID_EX_Shamt),.ID_EX_OpCode(ID_EX_OpCode),.ID_EX_RegWrite(ID_EX_RegWrite),
                    .ID_EX_MemRead(ID_EX_MemRead),.ID_EX_MemWrite(ID_EX_MemWrite),.ID_EX_ALUSrc_A(ID_EX_ALUSrc_A),.ID_EX_ALUSrc_B(ID_EX_ALUSrc_B),
                    .ID_EX_RegDst(ID_EX_RegDst),.ID_EX_MemtoReg(ID_EX_MemtoReg),.ID_EX_Sign(ID_EX_Sign),.ID_EX_isBranch(ID_EX_isBranch),.ID_EX_ALUOp(ID_EX_ALUOp));



    //EX
    assign MUXA_Data=(ForwardA==2'b00)?ID_EX_Read_Data_1:((ForwardA==2'b10)?EX_MEM_ALUOut:WB_RegWrite_Data);
    assign MUXB_Data=(ForwardB==2'b00)?ID_EX_Read_Data_2:((ForwardB==2'b10)?EX_MEM_ALUOut:WB_RegWrite_Data);
    assign In1=(ID_EX_ALUSrc_A==1'b0)?MUXA_Data:ID_EX_Shamt; 
    assign In2=(ID_EX_ALUSrc_B==1'b0)?MUXB_Data:ID_EX_ExtImmOut;

    assign EX_BranchAddr=ID_EX_PC_4+{{ID_EX_ExtImmOut[29:0]},2'b0};//ID_EX_ExtImmOut<<2好像有问题，改了�?�?
    assign EX_RegWriteAddr=(ID_EX_RegDst==2'b01)?ID_EX_Rt:((ID_EX_RegDst==2'b10)?ID_EX_Rd:5'b11111);

    ALU pplALU(.In1(In1),.In2(In2),.Sign(ID_EX_Sign),.ALUOp(ID_EX_ALUOp),.OpCode(ID_EX_OpCode),.Out(EX_ALUOut),.Branch(EX_Branch),.Zero(EX_Zero));



    //EX_MEM
    EX_MEM pplEX_MEM(.clk(clk),.rst(rst),.EX_RegWriteAddr(EX_RegWriteAddr),.EX_ALUOut(EX_ALUOut),.ID_EX_PC_4(ID_EX_PC_4),.MUXB_Data(MUXB_Data),
                    .ID_EX_MemWrite(ID_EX_MemWrite),.ID_EX_MemRead(ID_EX_MemRead),.ID_EX_MemtoReg(ID_EX_MemtoReg),.ID_EX_RegWrite(ID_EX_RegWrite),
                    .EX_MEM_RegWriteAddr(EX_MEM_RegWriteAddr),.EX_MEM_ALUOut(EX_MEM_ALUOut),.EX_MEM_PC_4(EX_MEM_PC_4),.EX_MEM_MUXB_Data(EX_MEM_MUXB_Data),
                    .EX_MEM_MemWrite(EX_MEM_MemWrite),.EX_MEM_MemRead(EX_MEM_MemRead),.EX_MEM_MemtoReg(EX_MEM_MemtoReg),.EX_MEM_RegWrite(EX_MEM_RegWrite));



    //MEM
    DataMemory pplDataMemory(.clk(clk),.rst(rst),.MemRead(EX_MEM_MemRead),.MemWrite(EX_MEM_MemWrite),.Addr(EX_MEM_ALUOut),.Write_Data(EX_MEM_MUXB_Data),
                                .Read_Data(MEM_Read_Data),.BCD(BCD));



    //MEM_WB
    MEM_WB pplMEM_WB(.clk(clk),.rst(rst),.EX_MEM_RegWriteAddr(EX_MEM_RegWriteAddr),.EX_MEM_ALUOut(EX_MEM_ALUOut),.EX_MEM_PC_4(EX_MEM_PC_4),.MEM_Read_Data(MEM_Read_Data),
                        .EX_MEM_MemtoReg(EX_MEM_MemtoReg),.EX_MEM_RegWrite(EX_MEM_RegWrite),.MEM_WB_RegWriteAddr(MEM_WB_RegWriteAddr),.MEM_WB_ALUOut(MEM_WB_ALUOut),
                        .MEM_WB_PC_4(MEM_WB_PC_4),.MEM_WB_Read_Data(MEM_WB_Read_Data),.MEM_WB_MemtoReg(MEM_WB_MemtoReg),.MEM_WB_RegWrite(MEM_WB_RegWrite));


    //WB
    assign WB_RegWrite_Data=(MEM_WB_MemtoReg==2'b01)?MEM_WB_Read_Data:((MEM_WB_MemtoReg==2'b10)?MEM_WB_ALUOut:MEM_WB_PC_4);
    
endmodule