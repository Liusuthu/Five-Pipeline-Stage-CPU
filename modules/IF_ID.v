module IF_ID (
    input clk,
    input rst,
    input [1:0]IF_ID_MUX,
    input [31:0]IR,
    input [31:0]PC_4,

    output reg [31:0]IF_ID_IR,
    output reg [31:0]IF_ID_PC_4
);

    always@(posedge clk or posedge rst)begin
        if(rst) begin
            IF_ID_IR<=32'h00000000;
            IF_ID_PC_4<=32'h00000000;
        end

        else begin
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
        end
    end
        
endmodule

//注：IF_ID级间寄存器就储存两样东西，一个是传来的指令IR，
//一个是PC+4；并且其前端有一个多路选择器MUX，根据不同的情况选择输入，
//有正常数据流、清空(Flush)、阻塞(Keep)三种模式；
//其中清空会在执行Beq和J型指令时出现，阻塞会在Load-use冒险时出现，其余为正常数据流