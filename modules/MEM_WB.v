module MEM_WB (
    input clk,
    input rst,
    input [4:0]EX_MEM_RegWriteAddr,
    input [31:0]EX_MEM_ALUOut,
    input [31:0]EX_MEM_PC_4,
    input [31:0]MEM_Read_Data, 
    //控制信号    
    input [1:0]EX_MEM_MemtoReg,
    input EX_MEM_RegWrite,


    output reg [4:0]MEM_WB_RegWriteAddr,
    output reg [31:0]MEM_WB_ALUOut,
    output reg [31:0]MEM_WB_PC_4,
    output reg [31:0]MEM_WB_Read_Data,
    //控制信号
    output reg [1:0]MEM_WB_MemtoReg,
    output reg MEM_WB_RegWrite
);

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            MEM_WB_RegWriteAddr<=5'b00000;
            MEM_WB_ALUOut<=32'h00000000;
            MEM_WB_PC_4<=32'h00000000;
            MEM_WB_Read_Data<=32'h00000000;
            MEM_WB_MemtoReg<=2'b00;
            MEM_WB_RegWrite<=1'b0;
        end

        else begin
            MEM_WB_RegWriteAddr<=EX_MEM_RegWriteAddr;
            MEM_WB_ALUOut<=EX_MEM_ALUOut;
            MEM_WB_PC_4<=EX_MEM_PC_4;
            MEM_WB_Read_Data<=MEM_Read_Data;
            MEM_WB_MemtoReg<=EX_MEM_MemtoReg;
            MEM_WB_RegWrite<=EX_MEM_RegWrite;
        end
    end

endmodule