`timescale 1ps/1ps

module InstructionMemory(
    input rst,
    input [31:0]InstructionAddr,

    output [31:0]IR
);
    
    //不妨假设这个指令储存器可以存储128条32bit指令
    reg [31:0]IRMemory[255:0];
    
    //取指令是一个组合逻辑操作，PC地址一来就可以取出新的指令
    //指令的地址是以4为单位增加的，因此取[9:2]位转为十进制就是其序号
    assign IR=(InstructionAddr[27:2]>255)?(32'h00000000):IRMemory[InstructionAddr[27:2]];

    //重置指令
    integer k=0;
    always@(posedge rst)
    begin        
        
        //在下面填汇编代码机器码
        
        /* IRMemory[0]<=32'h3c088000;
        IRMemory[1]<=32'h00084c02;
        IRMemory[2]<=32'h00853020; */


        //测试slt和sltu
        /* IRMemory[0]<=32'h3c088000;
        IRMemory[1]<=32'h00084c02;
        IRMemory[2]<=32'h00085403;
        IRMemory[3]<=32'h340b7000;
        IRMemory[4]<=32'h0169202a;
        IRMemory[5]<=32'h0149282a;
        IRMemory[6]<=32'h0149302b; */

        //测试ALU所有运算
        /* IRMemory[0] <= 32'h34080020;
        IRMemory[1] <= 32'h20090061;
        IRMemory[2] <= 32'h340a0001;
        IRMemory[3] <= 32'h01098020;
        IRMemory[4] <= 32'h20010061;
        IRMemory[5] <= 32'h01018822;
        IRMemory[6] <= 32'h01099024;
        IRMemory[7] <= 32'h01099825;
        IRMemory[8] <= 32'h0109a026;
        IRMemory[9] <= 32'h0109a827;
        IRMemory[10] <= 32'h000bb400;
        IRMemory[11] <= 32'h0009bc03;
        IRMemory[12] <= 32'h0008c402;
        IRMemory[13] <= 32'h0109c82a; */

        //验证了SW后面立即接LW是可行的，以及Forwarding
        /* IRMemory[0] <= 32'h34080020;
        IRMemory[1] <= 32'h34090030;
        IRMemory[2] <= 32'had280000;
        IRMemory[3] <= 32'h8d240000; */


        //测试EX阶段结束前，ALU 运算结果已经就绪的转发
        /* IRMemory[0] <= 32'h34080020;
        IRMemory[1] <= 32'h34090030;
        IRMemory[2] <= 32'h340a0040;
        IRMemory[3] <= 32'h012a2020;
        IRMemory[4] <= 32'h00882822;
        IRMemory[5] <= 32'h00893024; */

        //MEM阶段结束前，LW指令读取的数据已经就绪(无hazard版本)
        /* IRMemory[0] <= 32'h34080020;
        IRMemory[1] <= 32'h34090030;
        IRMemory[2] <= 32'had280000;
        IRMemory[3] <= 32'h8d240000;
        IRMemory[4] <= 32'h340a0040;
        IRMemory[5] <= 32'h00882820; */
        //（有hazard版本）(保持一个周期)
        /* IRMemory[0] <= 32'h34080020;
        IRMemory[1] <= 32'h34090030;
        IRMemory[2] <= 32'had280000;
        IRMemory[3] <= 32'h8d240000;
        IRMemory[4] <= 32'h00882820; */

        //j指令+取消后一条
        /* IRMemory[0] <= 32'h34080020;
        IRMemory[1] <= 32'h34090030;
        IRMemory[2] <= 32'h08100005;
        IRMemory[3] <= 32'h01092020;
        IRMemory[4] <= 32'h354a0050;
        IRMemory[5] <= 32'h356b0070; */

        //复杂的jump指令集合
        /* IRMemory[0] <= 32'h34080020;
        IRMemory[1] <= 32'h34090030;
        IRMemory[2] <= 32'h0c100004;
        IRMemory[3] <= 32'h08100006;
        IRMemory[4] <= 32'h21080001;
        IRMemory[5] <= 32'h03e00008;
        IRMemory[6] <= 32'h21290001; */

        //beq基本测试
        /* IRMemory[0] <= 32'h34080020;
        IRMemory[1] <= 32'h34090020;
        IRMemory[2] <= 32'h340a0030;
        IRMemory[3] <= 32'h110a0002;
        IRMemory[4] <= 32'h112a0002;
        IRMemory[5] <= 32'h11280002;
        IRMemory[6] <= 32'h01092020;
        IRMemory[7] <= 32'h012a2820;
        IRMemory[8] <= 32'h010a3020; */
        //blez
        /* IRMemory[0] <= 32'h34080020;
        IRMemory[1] <= 32'h34090020;
        IRMemory[2] <= 32'h00095022;
        IRMemory[3] <= 32'h19400002;
        IRMemory[4] <= 32'h01092020;
        IRMemory[5] <= 32'h01002820;
        IRMemory[6] <= 32'h340b0090; */
        /* IRMemory[0] <= 32'h34080020;
        IRMemory[1] <= 32'h34090020;
        IRMemory[2] <= 32'h00005022;
        IRMemory[3] <= 32'h19400001;
        IRMemory[4] <= 32'h01092020;
        IRMemory[5] <= 32'h340b0090; */
        /* IRMemory[0] <= 32'h34080020;
        IRMemory[1] <= 32'h34090020;
        IRMemory[2] <= 32'h00095022;
        IRMemory[3] <= 32'h1d400001;
        IRMemory[4] <= 32'h01092020;
        IRMemory[5] <= 32'h340b0090; */
        /* IRMemory[0] <= 32'h34080020;
        IRMemory[1] <= 32'h34090020;
        IRMemory[2] <= 32'h00095022;
        IRMemory[3] <= 32'h05400001;
        IRMemory[4] <= 32'h01092020;
        IRMemory[5] <= 32'h340b0090; */
        /* IRMemory[0] <= 32'h3408000a;
        IRMemory[1] <= 32'h34090000;
        IRMemory[2] <= 32'h34040000;
        IRMemory[3] <= 32'h21290001;
        IRMemory[4] <= 32'h00892020;
        IRMemory[5] <= 32'h1528fffd;
        IRMemory[6] <= 32'h340b0099; */

        //测试bellman算法
        /* IRMemory[0] <= 32'h34100006;
        IRMemory[1] <= 32'h34050000;
        IRMemory[2] <= 32'h34190001;
        IRMemory[3] <= 32'h34110100;
        IRMemory[4] <= 32'hae200000;
        IRMemory[5] <= 32'h3c01ffff;
        IRMemory[6] <= 32'h3421ffff;
        IRMemory[7] <= 32'h00017825;
        IRMemory[8] <= 32'h34090001;
        IRMemory[9] <= 32'h00095080;
        IRMemory[10] <= 32'h01515020;
        IRMemory[11] <= 32'had4f0000;
        IRMemory[12] <= 32'h21290001;
        IRMemory[13] <= 32'h01303822;
        IRMemory[14] <= 32'h04e0fffa;
        IRMemory[15] <= 32'h34090001;
        IRMemory[16] <= 32'h340a0000;
        IRMemory[17] <= 32'h340b0000;
        IRMemory[18] <= 32'h340a0000;
        IRMemory[19] <= 32'h340b0000;
        IRMemory[20] <= 32'h000a68c0;
        IRMemory[21] <= 32'h01ab6820;
        IRMemory[22] <= 32'h000d6880;
        IRMemory[23] <= 32'h000a7080;
        IRMemory[24] <= 32'h01d17020;
        IRMemory[25] <= 32'h8dcc0000;
        IRMemory[26] <= 32'h000c9025;
        IRMemory[27] <= 32'h2001ffff;
        IRMemory[28] <= 32'h102c0013;
        IRMemory[29] <= 32'h01a57020;
        IRMemory[30] <= 32'h8dcc0000;
        IRMemory[31] <= 32'h000ca025;
        IRMemory[32] <= 32'h2001ffff;
        IRMemory[33] <= 32'h102c000e;
        IRMemory[34] <= 32'h000b7080;
        IRMemory[35] <= 32'h01d17020;
        IRMemory[36] <= 32'h8dcc0000;
        IRMemory[37] <= 32'h000c9825;
        IRMemory[38] <= 32'h2001ffff;
        IRMemory[39] <= 32'h102c0004;
        IRMemory[40] <= 32'h02546020;
        IRMemory[41] <= 32'h026c3822;
        IRMemory[42] <= 32'h1ce00001;
        IRMemory[43] <= 32'h18e00004;
        IRMemory[44] <= 32'h02546020;
        IRMemory[45] <= 32'h000b7080;
        IRMemory[46] <= 32'h01d17020;
        IRMemory[47] <= 32'hadcc0000;
        IRMemory[48] <= 32'h216b0001;
        IRMemory[49] <= 32'h01703822;
        IRMemory[50] <= 32'h04e0ffe1;
        IRMemory[51] <= 32'h214a0001;
        IRMemory[52] <= 32'h01503822;
        IRMemory[53] <= 32'h04e0ffdd;
        IRMemory[54] <= 32'h21290001;
        IRMemory[55] <= 32'h01303822;
        IRMemory[56] <= 32'h04e0ffd9;
        IRMemory[57] <= 32'h34190000;
        IRMemory[58] <= 32'h34180001;
        IRMemory[59] <= 32'h00187080;
        IRMemory[60] <= 32'h01d17020;
        IRMemory[61] <= 32'h23180001;
        IRMemory[62] <= 32'h8dcc0000;
        IRMemory[63] <= 32'h032cc820;
        IRMemory[64] <= 32'h1710fffa;
        IRMemory[65] <= 32'h34170099; */

        //测试显示数码管        
        /* IRMemory[0] <= 32'h34190022;
        IRMemory[1] <= 32'h34100064;
        IRMemory[2] <= 32'h3c014000;
        IRMemory[3] <= 32'h34210010;
        IRMemory[4] <= 32'h00018825;
        IRMemory[5] <= 32'h34090000;
        IRMemory[6] <= 32'h332c000f;
        IRMemory[7] <= 32'h11800005;
        IRMemory[8] <= 32'h2187fffe;
        IRMemory[9] <= 32'h10e00006;
        IRMemory[10] <= 32'h340f0140;
        IRMemory[11] <= 32'hae2f0000;
        IRMemory[12] <= 32'h0810003d;
        IRMemory[13] <= 32'h340f013f;
        IRMemory[14] <= 32'hae2f0000;
        IRMemory[15] <= 32'h0810003d;
        IRMemory[16] <= 32'h340f015b;
        IRMemory[17] <= 32'hae2f0000;
        IRMemory[18] <= 32'h0810003d;
        IRMemory[19] <= 32'h34090000;
        IRMemory[20] <= 32'h332c00f0;
        IRMemory[21] <= 32'h11800005;
        IRMemory[22] <= 32'h2187ffe0;
        IRMemory[23] <= 32'h10e00006;
        IRMemory[24] <= 32'h340f0240;
        IRMemory[25] <= 32'hae2f0000;
        IRMemory[26] <= 32'h08100040;
        IRMemory[27] <= 32'h340f023f;
        IRMemory[28] <= 32'hae2f0000;
        IRMemory[29] <= 32'h08100040;
        IRMemory[30] <= 32'h340f025b;
        IRMemory[31] <= 32'hae2f0000;
        IRMemory[32] <= 32'h08100040;
        IRMemory[33] <= 32'h34090000;
        IRMemory[34] <= 32'h332c0f00;
        IRMemory[35] <= 32'h11800005;
        IRMemory[36] <= 32'h2187ff00;
        IRMemory[37] <= 32'h10e00006;
        IRMemory[38] <= 32'h340f0440;
        IRMemory[39] <= 32'hae2f0000;
        IRMemory[40] <= 32'h08100043;
        IRMemory[41] <= 32'h340f043f;
        IRMemory[42] <= 32'hae2f0000;
        IRMemory[43] <= 32'h08100043;
        IRMemory[44] <= 32'h340f045b;
        IRMemory[45] <= 32'hae2f0000;
        IRMemory[46] <= 32'h08100043;
        IRMemory[47] <= 32'h34090000;
        IRMemory[48] <= 32'h332cf000;
        IRMemory[49] <= 32'h11800005;
        IRMemory[50] <= 32'h2187f000;
        IRMemory[51] <= 32'h10e00006;
        IRMemory[52] <= 32'h340f0840;
        IRMemory[53] <= 32'hae2f0000;
        IRMemory[54] <= 32'h08100046;
        IRMemory[55] <= 32'h340f083f;
        IRMemory[56] <= 32'hae2f0000;
        IRMemory[57] <= 32'h08100046;
        IRMemory[58] <= 32'h340f085b;
        IRMemory[59] <= 32'hae2f0000;
        IRMemory[60] <= 32'h08100046;
        IRMemory[61] <= 32'h21290001;
        IRMemory[62] <= 32'h1530fffe;
        IRMemory[63] <= 32'h08100013;
        IRMemory[64] <= 32'h21290001;
        IRMemory[65] <= 32'h1530fffe;
        IRMemory[66] <= 32'h08100021;
        IRMemory[67] <= 32'h21290001;
        IRMemory[68] <= 32'h1530fffe;
        IRMemory[69] <= 32'h0810002f;
        IRMemory[70] <= 32'h21290001;
        IRMemory[71] <= 32'h1530fffe;
        IRMemory[72] <= 32'h08100005; */

        //final
        IRMemory[0] <= 32'h34100006;
        IRMemory[1] <= 32'h34050000;
        IRMemory[2] <= 32'h34190001;
        IRMemory[3] <= 32'h34110100;
        IRMemory[4] <= 32'hae200000;
        IRMemory[5] <= 32'h3c01ffff;
        IRMemory[6] <= 32'h3421ffff;
        IRMemory[7] <= 32'h00017825;
        IRMemory[8] <= 32'h34090001;
        IRMemory[9] <= 32'h00095080;
        IRMemory[10] <= 32'h01515020;
        IRMemory[11] <= 32'had4f0000;
        IRMemory[12] <= 32'h21290001;
        IRMemory[13] <= 32'h01303822;
        IRMemory[14] <= 32'h04e0fffa;
        IRMemory[15] <= 32'h34090001;
        IRMemory[16] <= 32'h340a0000;
        IRMemory[17] <= 32'h340b0000;
        IRMemory[18] <= 32'h340a0000;
        IRMemory[19] <= 32'h340b0000;
        IRMemory[20] <= 32'h000a68c0;
        IRMemory[21] <= 32'h01ab6820;
        IRMemory[22] <= 32'h000d6880;
        IRMemory[23] <= 32'h000a7080;
        IRMemory[24] <= 32'h01d17020;
        IRMemory[25] <= 32'h8dcc0000;
        IRMemory[26] <= 32'h000c9025;
        IRMemory[27] <= 32'h2001ffff;
        IRMemory[28] <= 32'h102c0013;
        IRMemory[29] <= 32'h01a57020;
        IRMemory[30] <= 32'h8dcc0000;
        IRMemory[31] <= 32'h000ca025;
        IRMemory[32] <= 32'h2001ffff;
        IRMemory[33] <= 32'h102c000e;
        IRMemory[34] <= 32'h000b7080;
        IRMemory[35] <= 32'h01d17020;
        IRMemory[36] <= 32'h8dcc0000;
        IRMemory[37] <= 32'h000c9825;
        IRMemory[38] <= 32'h2001ffff;
        IRMemory[39] <= 32'h102c0004;
        IRMemory[40] <= 32'h02546020;
        IRMemory[41] <= 32'h026c3822;
        IRMemory[42] <= 32'h1ce00001;
        IRMemory[43] <= 32'h18e00004;
        IRMemory[44] <= 32'h02546020;
        IRMemory[45] <= 32'h000b7080;
        IRMemory[46] <= 32'h01d17020;
        IRMemory[47] <= 32'hadcc0000;
        IRMemory[48] <= 32'h216b0001;
        IRMemory[49] <= 32'h01703822;
        IRMemory[50] <= 32'h04e0ffe1;
        IRMemory[51] <= 32'h214a0001;
        IRMemory[52] <= 32'h01503822;
        IRMemory[53] <= 32'h04e0ffdd;
        IRMemory[54] <= 32'h21290001;
        IRMemory[55] <= 32'h01303822;
        IRMemory[56] <= 32'h04e0ffd9;
        IRMemory[57] <= 32'h34190000;
        IRMemory[58] <= 32'h34180001;
        IRMemory[59] <= 32'h00187080;
        IRMemory[60] <= 32'h01d17020;
        IRMemory[61] <= 32'h23180001;
        IRMemory[62] <= 32'h8dcc0000;
        IRMemory[63] <= 32'h032cc820;
        IRMemory[64] <= 32'h1710fffa;
        IRMemory[65] <= 32'h34170099;
        IRMemory[66] <= 32'h341007d0;
        IRMemory[67] <= 32'h3c014000;
        IRMemory[68] <= 32'h34210010;
        IRMemory[69] <= 32'h00018825;
        IRMemory[70] <= 32'h34090000;
        IRMemory[71] <= 32'h332c000f;
        IRMemory[72] <= 32'h11800005;
        IRMemory[73] <= 32'h2187fffe;
        IRMemory[74] <= 32'h10e00006;
        IRMemory[75] <= 32'h340f0140;
        IRMemory[76] <= 32'hae2f0000;
        IRMemory[77] <= 32'h0810007e;
        IRMemory[78] <= 32'h340f013f;
        IRMemory[79] <= 32'hae2f0000;
        IRMemory[80] <= 32'h0810007e;
        IRMemory[81] <= 32'h340f015b;
        IRMemory[82] <= 32'hae2f0000;
        IRMemory[83] <= 32'h0810007e;
        IRMemory[84] <= 32'h34090000;
        IRMemory[85] <= 32'h332c00f0;
        IRMemory[86] <= 32'h11800005;
        IRMemory[87] <= 32'h2187ffe0;
        IRMemory[88] <= 32'h10e00006;
        IRMemory[89] <= 32'h340f0240;
        IRMemory[90] <= 32'hae2f0000;
        IRMemory[91] <= 32'h08100081;
        IRMemory[92] <= 32'h340f023f;
        IRMemory[93] <= 32'hae2f0000;
        IRMemory[94] <= 32'h08100081;
        IRMemory[95] <= 32'h340f025b;
        IRMemory[96] <= 32'hae2f0000;
        IRMemory[97] <= 32'h08100081;
        IRMemory[98] <= 32'h34090000;
        IRMemory[99] <= 32'h332c0f00;
        IRMemory[100] <= 32'h11800005;
        IRMemory[101] <= 32'h2187ff00;
        IRMemory[102] <= 32'h10e00006;
        IRMemory[103] <= 32'h340f0440;
        IRMemory[104] <= 32'hae2f0000;
        IRMemory[105] <= 32'h08100084;
        IRMemory[106] <= 32'h340f043f;
        IRMemory[107] <= 32'hae2f0000;
        IRMemory[108] <= 32'h08100084;
        IRMemory[109] <= 32'h340f045b;
        IRMemory[110] <= 32'hae2f0000;
        IRMemory[111] <= 32'h08100084;
        IRMemory[112] <= 32'h34090000;
        IRMemory[113] <= 32'h332cf000;
        IRMemory[114] <= 32'h11800005;
        IRMemory[115] <= 32'h2187f000;
        IRMemory[116] <= 32'h10e00006;
        IRMemory[117] <= 32'h340f0840;
        IRMemory[118] <= 32'hae2f0000;
        IRMemory[119] <= 32'h08100087;
        IRMemory[120] <= 32'h340f083f;
        IRMemory[121] <= 32'hae2f0000;
        IRMemory[122] <= 32'h08100087;
        IRMemory[123] <= 32'h340f085b;
        IRMemory[124] <= 32'hae2f0000;
        IRMemory[125] <= 32'h08100087;
        IRMemory[126] <= 32'h21290001;
        IRMemory[127] <= 32'h1530fffe;
        IRMemory[128] <= 32'h08100054;
        IRMemory[129] <= 32'h21290001;
        IRMemory[130] <= 32'h1530fffe;
        IRMemory[131] <= 32'h08100062;
        IRMemory[132] <= 32'h21290001;
        IRMemory[133] <= 32'h1530fffe;
        IRMemory[134] <= 32'h08100070;
        IRMemory[135] <= 32'h21290001;
        IRMemory[136] <= 32'h1530fffe;
        IRMemory[137] <= 32'h08100046;
        
       

        //在上面填汇编代码机器码
        for(k=138;k<256;k=k+1) IRMemory[k]<=32'h00000000;
    end

endmodule