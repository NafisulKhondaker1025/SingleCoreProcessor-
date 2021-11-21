`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2021 01:35:38 PM
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(Clk, RegWrite, MemToReg, MemReadData, ALUResult, WriteRegister,
    RegWriteOut, MemToRegOut, MemReadDataOut, ALUResultOut, WriteRegisterOut, movIn, movOut, PCAddressOutEX_MEM,
        PCAddressOutMEM_WB, jumpOutEX_MEM, jumpOutMEM_WB);
    
    input Clk, RegWrite, MemToReg, movIn, jumpOutEX_MEM;
    input [4:0] WriteRegister;
    input [31:0] MemReadData, ALUResult, PCAddressOutEX_MEM;
    output reg RegWriteOut, MemToRegOut, movOut, jumpOutMEM_WB;
    output reg [4:0] WriteRegisterOut;
    output reg [31:0] MemReadDataOut, ALUResultOut, PCAddressOutMEM_WB;
    
    always@(posedge Clk) begin
        RegWriteOut <= RegWrite;
        MemToRegOut <= MemToReg;
        MemReadDataOut <= MemReadData;
        ALUResultOut <= ALUResult;
        WriteRegisterOut <= WriteRegister;
        movOut          <= movIn;
        PCAddressOutMEM_WB <= PCAddressOutEX_MEM;
        jumpOutMEM_WB <= jumpOutEX_MEM;
    end
endmodule
