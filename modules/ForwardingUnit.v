module ForwardingUnit (
    input [4:0]ID_EX_Rs,
    input [4:0]ID_EX_Rt,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    input [4:0]EX_MEM_RegWriteAddr,
    input [4:0]MEM_WB_RegWriteAddr,
    input EX_MEM_MemWrite,


    output reg [1:0]ForwardA,
    output reg [1:0]ForwardB
);

    always@(*)begin
        //ForwardA
        if((EX_MEM_RegWrite==1)&&(EX_MEM_RegWriteAddr!=5'b00000)&&(EX_MEM_RegWriteAddr==ID_EX_Rs)) ForwardA<=2'b10;
        else if((MEM_WB_RegWrite)&&(MEM_WB_RegWriteAddr!=5'b00000)&&(MEM_WB_RegWriteAddr==ID_EX_Rs)&&((EX_MEM_RegWriteAddr!=ID_EX_Rs)||(EX_MEM_MemWrite!=1))) ForwardA<=2'b01;
        else ForwardA<=2'b00;

        //ForwardB
        if((EX_MEM_RegWrite==1)&&(EX_MEM_RegWriteAddr!=5'b00000)&&(EX_MEM_RegWriteAddr==ID_EX_Rt)) ForwardB<=2'b10;
        else if((MEM_WB_RegWrite)&&(MEM_WB_RegWriteAddr!=5'b00000)&&(MEM_WB_RegWriteAddr==ID_EX_Rt)&&((EX_MEM_RegWriteAddr!=ID_EX_Rt)||(EX_MEM_MemWrite!=1))) ForwardB<=2'b01;
        else ForwardB<=2'b00;

    end
    
endmodule