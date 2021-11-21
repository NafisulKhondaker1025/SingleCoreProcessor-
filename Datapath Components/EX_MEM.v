`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2021 08:44:23 PM
// Design Name: 
// Module Name: EX_MEM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EX_MEM(Clk, RegWrite, MemRead, MemWrite, MemToReg, /*branch,*/ /*Adder1Result,*/ whb,
              /*Zero,*/ ALUResult, ReadData2, EXMux2Result,
              RegWriteOut, MemReadOut, MemWriteOut, MemToRegOut, /*branchOut,*/ /*Adder1Out,*/
              whbOut, /*ZeroOut,*/ ALUResultOut, ReadData2Out, EXMux2Out, movIn, movOut, /*jumpMuxin, jumpMuxOut,*/ jumpOutID_EX, jumpOutEX_MEM, 
              PCAddressOutID_EX, PCAddressOutEX_MEM);
              
    input RegWrite, MemRead, MemWrite, MemToReg, Clk, movIn, jumpOutID_EX;
    input [31:0] ALUResult, ReadData2, PCAddressOutID_EX;
    input [4:0] EXMux2Result;
    input [1:0] whb;
    
    output reg RegWriteOut, MemReadOut, MemWriteOut, MemToRegOut, movOut, jumpOutEX_MEM;
    output reg [31:0] ALUResultOut, ReadData2Out, PCAddressOutEX_MEM;
    output reg [4:0] EXMux2Out;
    output reg [1:0] whbOut;
    
    always@(posedge Clk) begin
        RegWriteOut  <= RegWrite;
        MemReadOut   <= MemRead;
        MemWriteOut  <= MemWrite;
        MemToRegOut  <= MemToReg;
//        branchOut    <= branch;
        whbOut       <= whb;
//        ZeroOut      <= Zero;
//        Adder1Out    <= Adder1Result;
        ALUResultOut <= ALUResult;
        ReadData2Out <= ReadData2;
        EXMux2Out    <= EXMux2Result;
        movOut       <= movIn;
//        jumpMuxOut   <= jumpMuxin;
        jumpOutEX_MEM <= jumpOutID_EX;
        PCAddressOutEX_MEM <= PCAddressOutID_EX;
    end
endmodule
