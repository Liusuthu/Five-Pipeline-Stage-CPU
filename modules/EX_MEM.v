module EX_MEM (
    input clk,
    input rst,
    input [4:0]EX_RegWriteAddr,
    input [31:0]EX_ALUOut,
    input [31:0]ID_EX_PC_4,
    input [31:0]MUXB_Data,//原来图上画的是把Read_Data_2连过来，现在把MUXB_Data连过来后，就把R型指令后面接SW的情况一并搞定了
    //控制信号
    input ID_EX_MemWrite,
    input ID_EX_MemRead,
    input [1:0]ID_EX_MemtoReg,
    input ID_EX_RegWrite,


    output reg [4:0]EX_MEM_RegWriteAddr,
    output reg [31:0]EX_MEM_ALUOut,
    output reg [31:0]EX_MEM_PC_4,
    output reg [31:0]EX_MEM_MUXB_Data,
    //控制信号
    output reg EX_MEM_MemWrite,
    output reg EX_MEM_MemRead,
    output reg [1:0]EX_MEM_MemtoReg,
    output reg EX_MEM_RegWrite
);

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            EX_MEM_RegWriteAddr<=5'b00000;
            EX_MEM_ALUOut<=32'h00000000;
            EX_MEM_PC_4<=32'h00000000;
            EX_MEM_MUXB_Data<=32'h00000000;

            EX_MEM_MemWrite<=1'b0;
            EX_MEM_MemRead<=1'b0;
            EX_MEM_MemtoReg<=2'b00;
            EX_MEM_RegWrite<=1'b0;
        end

        else begin//正常数据流
            EX_MEM_RegWriteAddr<=EX_RegWriteAddr;
            EX_MEM_ALUOut<=EX_ALUOut;
            EX_MEM_PC_4<=ID_EX_PC_4;
            EX_MEM_MUXB_Data<=MUXB_Data;

            EX_MEM_MemWrite<=ID_EX_MemWrite;
            EX_MEM_MemRead<=ID_EX_MemRead;
            EX_MEM_MemtoReg<=ID_EX_MemtoReg;
            EX_MEM_RegWrite<=ID_EX_RegWrite;
        end
    end    
endmodule