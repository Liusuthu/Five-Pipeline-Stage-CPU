module Ext (
    input ExtOp,
    input LuOp,
    //input Sign;//一开始以为没有"Sign"，原来ExtOp就是
    input [15:0]Imm,

    output [31:0]ExtImmOut
);

    wire [31:0]LuImm;
    wire [31:0]ExtImm;

    assign ExtImm=ExtOp?{{16{Imm[15]}},Imm}:{{16{1'b0}},Imm};
    assign LuImm={Imm,{16{1'b0}}};

    assign ExtImmOut=LuOp?LuImm:ExtImm;
    
endmodule

//这里的输出ExtImm有两种情况，分别是有无符号扩展后的立即数和加载到高16位的立即数