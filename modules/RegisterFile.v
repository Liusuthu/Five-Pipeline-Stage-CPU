module RegisterFile (
    input clk,
    input rst,
    input RegWrite,
    input [4:0]Read_Addr_1,
    input [4:0]Read_Addr_2,
    input [4:0]Write_Addr,
    input [31:0]Write_Data,

    output [31:0]Read_Data_1,
    output [31:0]Read_Data_2
);

    //寄存器堆是由32个32bit的寄存器构成的
    reg [31:0] RF[31:0];


    integer k=0;
    always@(posedge rst or posedge clk)begin
        if(rst) for(k=0;k<32;k=k+1) RF[k]<=32'h00000000;
        else begin//时钟沿写入
            if(RegWrite && (Write_Addr!=5'b00000)) RF[Write_Addr]<=Write_Data;
        end        
    end
    
    //实现先写后读+正常读取(组合逻辑)
    assign Read_Data_1=(Read_Addr_1==5'b00000)?0:(((Read_Addr_1==Write_Addr)&&RegWrite==1)?Write_Data:RF[Read_Addr_1]);
    assign Read_Data_2=(Read_Addr_2==5'b00000)?0:(((Read_Addr_2==Write_Addr)&&RegWrite==1)?Write_Data:RF[Read_Addr_2]);

endmodule

//注：这里的Addr可以直接做为索引是因为它从代码解析出来的地址本身就是0~31的序号