`timescale 1ns / 1ps
 //Group 6: Kevin Gilman 33.333%, Ahmad Eladawy 33.333%, Nafisul Khondaker 33.333%
 //5 stage pipeline [Fetch, Decode, Execute, Memory, Writeback]
 //Branch is resolved in the Decode stage


module Top2(Clk, Reset, out7, en_out);
    input Clk, Reset;
    wire Clk_f;
    output [6:0] out7;
    output [7:0] en_out;
    wire [31:0] v1;
    wire [31:0] v0;
    
    ClkDiv clkdiv(Clk, Reset, Clk_f);
    
    Top Datapath(Clk_f, Reset, v1, v0);
    
    Two4DigitDisplay TwoDD(Clk, v1[15:0], v0[15:0], out7, en_out);
    
endmodule
