module HazardUnit (
    input ID_EX_MemRead,
    input [4:0]ID_EX_Rt,
    input [4:0]ID_Rs,
    input [4:0]ID_Rt,
    input ID_Jump,
    input EX_Branch,
    input ID_EX_isBranch,

    output reg PC_MUX,
    output reg [1:0]IF_ID_MUX,
    output reg ID_EX_MUX
);

    always@(*)begin
        //1、Load-use冒险
        if((ID_EX_MemRead==1)&&((ID_EX_Rt==ID_Rs)||(ID_EX_Rt==ID_Rt)))begin
            PC_MUX<=0;
            IF_ID_MUX<=2'b10;
            ID_EX_MUX<=0;
        end        

        //2、Jump情况
        else if(ID_Jump==1)begin
            PC_MUX<=1;
            IF_ID_MUX<=2'b01;
            ID_EX_MUX<=1;
        end

        //3、Beq情况
        else if((ID_EX_isBranch==1)&&(EX_Branch==1))begin
            PC_MUX<=1;
            IF_ID_MUX<=2'b01;
            ID_EX_MUX<=0;
        end

        //默认情况
        else begin
            PC_MUX<=1;
            IF_ID_MUX<=2'b00;
            ID_EX_MUX<=1;
        end

    end
    
endmodule 

//注：HazardUnit生成三种控制信号，分别为PC、IF_ID、ID_EX前面的MUX控制信号
//一共有如下几种情况会对MUX的输入信号有特殊要求
//1、出现Load-use冒险时，需要阻塞一个周期，插入一条空指令
//2、Jump指令出现时，必定取消后面一条指令
//3、Branch指令在EX阶段确定执行后，会取消后面两条指令