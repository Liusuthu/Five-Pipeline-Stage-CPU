`timescale 1ps/1ps

module test_cpu_tb();


reg rst, clk;
wire [11:0]BCD;
localparam PERIOD = 200;

PipelineCPU pplcpu(.clk(clk),.rst(rst),.BCD(BCD));

always #(PERIOD/2) clk = ~clk;

initial begin
    rst=1'b0;
    clk=1'b0;

    #(50) rst=1'b1;
    #(100) rst=1'b0;
    
    #(PERIOD*10000) $stop;
    
end

endmodule
