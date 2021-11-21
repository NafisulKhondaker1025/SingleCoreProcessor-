`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2021 02:59:03 PM
// Design Name: 
// Module Name: InstructionMemory
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


module InstructionMemory(Address, Instruction); 

    input [31:0] Address;        // Input Address 

    output reg [31:0] Instruction;    // Instruction at memory location Address
    
    //reg [31:0] memory [127:0];
    reg [31:0] memory [257:0];
    
    integer i;
    
    initial begin
    $readmemh("instruction_memory.mem",memory);
   /* memory[0] = 32'h00000000;
memory[1] = 32'h00000000;
memory[2] = 32'h00000000;
memory[3] = 32'h00000000;
memory[4] = 32'h00000000;
memory[5] = 32'h00000000;
memory[6] = 32'h20090006;
memory[7] = 32'h00000000;
memory[8] = 32'h00000000;
memory[9] = 32'h00000000;
memory[10] = 32'h00000000;
memory[11] = 32'h00000000;
memory[12] = 32'h200a000a;
memory[13] = 32'h00000000;
memory[14] = 32'h00000000;
memory[15] = 32'h00000000;
memory[16] = 32'h00000000;
memory[17] = 32'h00000000;
memory[18] = 32'h00000000;
memory[19] = 32'h00000000;
memory[20] = 32'h00000000;
memory[21] = 32'h00000000;
memory[22] = 32'h00000000;
memory[23] = 32'h00000000;
memory[24] = 32'h00000000;
memory[25] = 32'h00000000;
memory[26] = 32'h00000000;
memory[27] = 32'h00000000;
memory[28] = 32'h00000000;
memory[29] = 32'h00000000;
memory[30] = 32'h00000000;
memory[31] = 32'h00000000;
memory[32] = 32'h00000000;
memory[33] = 32'h00000000;
memory[34] = 32'h00000000;
memory[35] = 32'h00000000;
memory[36] = 32'h00000000;
memory[37] = 32'h00000000;
memory[38] = 32'h00000000;
memory[39] = 32'h00000000;
memory[40] = 32'h00000000;
memory[41] = 32'h00000000;
memory[42] = 32'h00000000;
memory[43] = 32'h00000000;
memory[44] = 32'h00000000;
memory[45] = 32'h00000000;
memory[46] = 32'h00000000;
memory[47] = 32'h00000000;
memory[48] = 32'h000b60c0;
memory[49] = 32'h00000000;
memory[50] = 32'h00000000;
memory[51] = 32'h00000000;
memory[52] = 32'h00000000;
memory[53] = 32'h00000000;
memory[54] = 32'h000c6882;
memory[55] = 32'h00000000;
memory[56] = 32'h00000000;
memory[57] = 32'h00000000;
memory[58] = 32'h00000000;
memory[59] = 32'h00000000;
memory[60] = 32'h08000000;
*/
    end
    
    always @(Address) 
    begin
        Instruction = memory[Address[9:2]];
    end
endmodule
