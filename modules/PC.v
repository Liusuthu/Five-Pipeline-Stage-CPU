module PC(
    input clk,
    input rst,
    input PC_MUX,
    input [31:0]PC_i,

    output reg [31:0]PC_o
);

    always@(posedge clk or posedge rst)
    begin
        if(rst) PC_o<=32'h00000000;
        else begin
            case(PC_MUX)
            0:PC_o<=PC_o;//keep PC
            1:PC_o<=PC_i;//update PC
            default:PC_o<=PC_i;//默认update PC
            endcase
        end
    end

endmodule

//注：所有需要Keep PC的情况，即为Load-use冒险时的阻塞一个周期，
//因为我对Beq和Jump的处理为直接取消接下来的两个或一个指令