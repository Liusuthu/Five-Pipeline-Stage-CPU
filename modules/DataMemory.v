module DataMemory (
    input clk,
    input rst,
    input MemRead,
    input MemWrite,
    input [31:0]Addr,
    input [31:0]Write_Data,

    output [31:0]Read_Data,
    output [11:0]BCD
);

    //假设数据存储器有128个32bit数据存储位置，而七段数码管外设有16个
    reg [31:0]DTMemory[75:0];//128=2^7（进一步缩减到76个）
    reg [31:0]Device[7:0];//8=2^3

    assign BCD=Device[4][11:0];//BCD地址：0x40000010,取[5:2]即为4

    //读内存
    assign Read_Data=MemRead?((Addr[31:28]==4'b0100)?Device[Addr[4:2]]:DTMemory[Addr[8:2]]):32'h00000000;
    //写内存
    integer k=0;
    always@(posedge clk or posedge rst)begin
        if(rst)begin//重设(不知道这里阻塞式赋值会不会有问题？)
            
            DTMemory[0]<=32'h00000000;
            DTMemory[1]<=32'h00000009;
            DTMemory[2]<=32'h00000003;
            DTMemory[3]<=32'h00000006;
            DTMemory[4]<=32'hffffffff;
            DTMemory[5]<=32'hffffffff;
            DTMemory[6]<=32'h00000000;
            DTMemory[7]<=32'h00000000;

            DTMemory[8]<=32'h00000009;
            DTMemory[9]<=32'h00000000;
            DTMemory[10]<=32'hffffffff;
            DTMemory[11]<=32'h00000003;
            DTMemory[12]<=32'h00000004;
            DTMemory[13]<=32'h00000001;
            DTMemory[14]<=32'h00000000;
            DTMemory[15]<=32'h00000000;

            DTMemory[16]<=32'h00000003;
            DTMemory[17]<=32'hffffffff;
            DTMemory[18]<=32'h00000000;
            DTMemory[19]<=32'h00000002;
            DTMemory[20]<=32'hffffffff;
            DTMemory[21]<=32'h00000005;
            DTMemory[22]<=32'h00000000;
            DTMemory[23]<=32'h00000000;

            DTMemory[24]<=32'h00000006;
            DTMemory[25]<=32'h00000003;
            DTMemory[26]<=32'h00000002;
            DTMemory[27]<=32'h00000000;
            DTMemory[28]<=32'h00000006;
            DTMemory[29]<=32'hffffffff;
            DTMemory[30]<=32'h00000000;
            DTMemory[31]<=32'h00000000;

            DTMemory[32]<=32'hffffffff;
            DTMemory[33]<=32'h00000004;
            DTMemory[34]<=32'hffffffff;
            DTMemory[35]<=32'h00000006;
            DTMemory[36]<=32'h00000000;
            DTMemory[37]<=32'h00000002;
            DTMemory[38]<=32'h00000000;
            DTMemory[39]<=32'h00000000;

            DTMemory[40]<=32'hffffffff;
            DTMemory[41]<=32'h00000001;
            DTMemory[42]<=32'h00000005;
            DTMemory[43]<=32'hffffffff;
            DTMemory[44]<=32'h00000002;
            DTMemory[45]<=32'h00000000;
            DTMemory[46]<=32'h00000000;
            DTMemory[47]<=32'h00000000;


            for(k=48;k<76;k=k+1) DTMemory[k]<=32'h00000000;
            for(k=0;k<8;k=k+1) Device[k]<=32'h00000000;
            //还有一些初始化的DTMemory值


        end

        else if(MemWrite) begin
            if(Addr==32'h40000010) Device[4]<=Write_Data;
            else DTMemory[Addr[10:2]]<=Write_Data;
        end

    end 
    
endmodule