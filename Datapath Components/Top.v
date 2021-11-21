`timescale 1ns / 1ps
 //Group 6: Kevin Gilman 33.333%, Ahmad Eladawy 33.333%, Nafisul Khondaker 33.333%
 //5 stage pipeline [Fetch, Decode, Execute, Memory, Writeback]
 //Branch is resolved in the Decode stage


module Top(Clk, PC_Rst, v1, v0);
    input Clk, PC_Rst;
    output reg [31:0] v1, v0;
    
    wire [31:0] PCResult, PCMuxOut, PCAddResult, CurrentInstruction, ReadData1, ReadData2, PCAddressOutID_EX,
                ReadData1OutID_EX, ReadData2OutID_EX, SEOut, SignExtendOutID_EX, ShiftLeft2Out, Adder1Out, EXMux1Out,
                ALUResult, Adder1EX_MEM, ALUResultEX_MEM, ReadData2EX_MEM,
                MemReadData, MemReadDataMEM_WB, ALUResultMEM_WB, MuxWBOut, SHAMT, SHAMTOut_EX, EXMuxShiftOut, Hi_in, Hi_out, Lo_in, Lo_out;
    wire [31:0] PCAddressOut, InstructionOut, jumpSEOut, ShiftJumpOut, ShiftJumpID_EX, jumpMuxEX_MEM, jumpMuxOut, PCAddressOutEX_MEM, 
                PCAddressOutMEM_WB, MuxJalOut, AdderJumpOut, out_v0, out_v1;
    wire ALUSrc, RegDst, RegWrite, MemRead, MemWrite, MemToReg, ALUShift, branch, jump,
         ALUSrcOutID_EX, RegDstOutID_EX, RegWriteOutID_EX, MemReadOutID_EX, MemWriteOutID_EX, MemToRegOutID_EX, ALUShiftOutID_EX,
         /*branchOutID_EX,*/ jumpOutID_EX, RegWriteEX_MEM, MemReadEX_MEM, MemWriteEX_MEM, MemToRegEX_MEM, branchEX_MEM,
         ZeroEX_MEM, PCSrc, RegWriteMEM_WB, MemToRegMEM_WB, zero, mov, movEX_MEM, movMEM_WB, RegWrite_AND, j_jrSrc, jumpOutEX_MEM, j_jrSrcID_EX, 
         jumpOutMEM_WB, HazardControl, PC_en, IF_ID_en, Zero_Branch, IF_Flush;
    wire [17:0] ControlMux_out;
    wire [4:0] rtOutID_EX, rdOutID_EX, WriteRegisterMEM_WB, EXMux2Out, WriteRegisterEX_MEM, MuxRaOut;
    wire [5:0] ALUOp, ALUOpOutID_EX;
    wire [1:0] whb, whbOutID_EX, whbEX_MEM;
    wire Clk;
    /*
    module ALU32Bit(ALUControl, A, B, ALUResult, Zero, Clk);
    module Controller(Instruction, ALUSrc, RegDst, RegWrite, ALUOp, MemRead, MemWrite, MemToReg, ALUShift, branch, whb, jump);
    module DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData, whb); 
    module InstructionMemory(Address, Instruction); 
    module Mux32Bit2To1(out, inA, inB, sel);
    module PCAdder(PCResult, PCAddResult);
    module ProgramCounter(Address, PCResult, Reset, Clk);
    module RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2);
    module ShiftLeft2(in, shiftedOut);
    module SignExtension(in, out);
    module IF_ID(Clk, PCAddress, Instruction, IF_IDOut);
    module ID_EX(Clk, ALUSrc, RegDst, RegWrite, ALUOp, MemRead, MemWrite, MemToReg, ALUShift, branch,
    whb, jump, PCAddress, ReadData1, ReadData2, SignExtend, rt, rd, ALUSrcOut, RegDstOut, RegWriteOut,
    ALUOpOut, MemReadOut, MemWriteOut, MemToRegOut, ALUShiftOut, branchOut, whbOut, jumpOut, PCAddressOut,
    ReadData1Out, ReadData2Out, SignExtendOut, rtOut, rdOut);
    */
    
    Mux32Bit3To1 PCMux(PCMuxOut, PCAddResult, Adder1Out, jumpMuxOut, {ControlMux_out[1],PCSrc});
    
    ProgramCounter PC(PCMuxOut, PCResult, PC_Rst, Clk, PC_en);
    
    PCAdder PCAdder(PCResult, PCAddResult);
    
   
    
    InstructionMemory InstructionMemory(PCResult, CurrentInstruction);
    OrGate FlushOR(PCSrc, ControlMux_out[1], IF_Flush);
    IF_ID IF_ID(Clk, PCAddResult, CurrentInstruction, PCAddressOut, InstructionOut, IF_ID_en, IF_Flush);
    
    HazardUnit HazardUnit(RegWriteEX_MEM, RegWriteOutID_EX, WriteRegisterEX_MEM, rdOutID_EX, rtOutID_EX, InstructionOut[25:21], InstructionOut[20:16], RegDstOutID_EX, PC_en, IF_ID_en, HazardControl); 
    
    SignExtensionJump jumpSE(InstructionOut[25:0], jumpSEOut);          //actually a zero extension
    
    ShiftLeft2 ShiftJump(jumpSEOut, ShiftJumpOut);
    
    Controller Controller(InstructionOut, ALUSrc, RegDst, RegWrite, ALUOp, MemRead, MemWrite, MemToReg, ALUShift, branch, whb, jump, j_jrSrc);
    
    ZeroExtension5Bit ZeroExtension5Bit(InstructionOut[10:6], SHAMT);
    
    //module RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2);
    RegisterFile RegisterFile(InstructionOut[25:21],InstructionOut[20:16], MuxRaOut, MuxJalOut, RegWrite_AND, Clk, PC_Rst, ReadData1, ReadData2, out_v0, out_v1);
    
    BranchALU BranchALU(ReadData1, ReadData2, Zero_Branch, InstructionOut[31:26], InstructionOut[20:16]);
    
    SignExtension SignExtender(InstructionOut[15:0], SEOut);
    
    ShiftLeft2 ShiftLeft2(SEOut, ShiftLeft2Out);
    
    Adder32bit Adder1(PCAddressOut, ShiftLeft2Out, Adder1Out);
    
    ControlMux ControlMux(ControlMux_out, /*18'b010100111001100000*/ 18'b0, {ALUSrc, RegDst, RegWrite, ALUOp, MemRead, MemWrite, MemToReg, ALUShift, branch, whb, jump, j_jrSrc}, HazardControl);
    
    Mux32Bit2To1 jumpMux(jumpMuxOut, ReadData1, ShiftJumpOut, ControlMux_out[0]);
    
    ANDGate BranchAND(Zero_Branch, ControlMux_out[4], PCSrc);
    
    
    ID_EX ID_EX(Clk, ControlMux_out[17], ControlMux_out[16], ControlMux_out[15], ControlMux_out[14:9], ControlMux_out[8], ControlMux_out[7], ControlMux_out[6], ControlMux_out[5], /*ControlMux_out[4],*/
        ControlMux_out[3:2], ControlMux_out[1], PCAddressOut, ReadData1, ReadData2, SEOut, InstructionOut[20:16], InstructionOut[15:11], SHAMT, ALUSrcOutID_EX, RegDstOutID_EX, RegWriteOutID_EX,
        ALUOpOutID_EX, MemReadOutID_EX, MemWriteOutID_EX, MemToRegOutID_EX, ALUShiftOutID_EX, /*branchOutID_EX,*/ whbOutID_EX, jumpOutID_EX, PCAddressOutID_EX,
        ReadData1OutID_EX, ReadData2OutID_EX, SignExtendOutID_EX, rtOutID_EX, rdOutID_EX, SHAMTOut_EX, /*ShiftJumpOut, ShiftJumpID_EX,*/ ControlMux_out[0], j_jrSrcID_EX);

//    Mux32Bit2To1 jumpMux(jumpMuxOut, ReadData1OutID_EX, ShiftJumpID_EX, j_jrSrcID_EX);
    //Adder32bit AdderJump(PCAddressOutID_EX, jumpMuxOut, AdderJumpOut);
//    ShiftLeft2 ShiftLeft2(SignExtendOutID_EX, ShiftLeft2Out);
//    Adder32bit Adder1(PCAddressOutID_EX, ShiftLeft2Out, Adder1Out);
    
    Mux32Bit2To1 EXMux1(EXMux1Out, ReadData2OutID_EX, SignExtendOutID_EX, ALUSrcOutID_EX);
    
    Mux32Bit2To1 EXMuxShift(EXMuxShiftOut, ReadData1OutID_EX, SHAMTOut_EX, ALUShiftOutID_EX);  
   
    //module ALU32Bit(ALUControl, A, B, ALUResult, Zero, Clk);
    ALU32Bit ALU(ALUOpOutID_EX, EXMuxShiftOut, EXMux1Out, ALUResult, zero, Hi_in, Hi_out, Lo_in, Lo_out, mov);
    
    HiLoRegisters HiLoRegisters(Clk, Hi_out, Hi_in, Lo_out, Lo_in);
   
    Mux5Bit2To1 EXMux2(EXMux2Out, rtOutID_EX, rdOutID_EX, RegDstOutID_EX);
    
    /*module EX_MEM(Clk, RegWrite, MemRead, MemWrite, MemToReg, branch, Adder1Result, whb,
              Zero, ALUResult, ReadData2, EXMux2Result,
              RegWriteOut, MemReadOut, MemWriteOut, MemToRegOut, branchOut, Adder1Out,
              whbOut, ZeroOut, ALUResultOut, ReadData2Out, EXMux2Out);*/
    
    EX_MEM EX_MEM(Clk, RegWriteOutID_EX, MemReadOutID_EX, MemWriteOutID_EX, MemToRegOutID_EX, /*branchOutID_EX,*/ /*Adder1Out,*/
        whbOutID_EX, /*zero,*/ ALUResult, ReadData2OutID_EX, EXMux2Out,
        RegWriteEX_MEM, MemReadEX_MEM, MemWriteEX_MEM, MemToRegEX_MEM, /*branchEX_MEM,*/ /*Adder1EX_MEM,*/ whbEX_MEM, /*ZeroEX_MEM,*/ ALUResultEX_MEM,
        ReadData2EX_MEM, WriteRegisterEX_MEM, mov, movEX_MEM, /*jumpMuxOut, jumpMuxEX_MEM,*/ jumpOutID_EX, jumpOutEX_MEM, PCAddressOutID_EX, PCAddressOutEX_MEM);
    //module ANDGate(A, B, Out);
//    ANDGate BranchAND(ZeroEX_MEM, branchEX_MEM, PCSrc);
    //module DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData, whb);
    
    DataMemory DataMemory(ALUResultEX_MEM, ReadData2EX_MEM, Clk, MemWriteEX_MEM, MemReadEX_MEM,
        MemReadData, whbEX_MEM);
    
    /*module MEM_WB(Clk, RegWrite, MemToReg, MemReadData, ALUResult, WriteData,
    RegWriteOut, MemToRegOut, MemReadDataOut, ALUResultOut, WriteDataOut);*/
    MEM_WB MEM_WB(Clk, RegWriteEX_MEM, MemToRegEX_MEM, MemReadData, ALUResultEX_MEM, WriteRegisterEX_MEM,
        RegWriteMEM_WB, MemToRegMEM_WB, MemReadDataMEM_WB, ALUResultMEM_WB, WriteRegisterMEM_WB, movEX_MEM, movMem_WB, PCAddressOutEX_MEM,
        PCAddressOutMEM_WB, jumpOutEX_MEM, jumpOutMEM_WB);
    
    Mux32Bit2To1 MuxWB(MuxWBOut, MemReadDataMEM_WB, ALUResultMEM_WB, MemToRegMEM_WB);
    
    Mux32Bit2To1 MuxJal(MuxJalOut, MuxWBOut, PCAddressOutMEM_WB, jumpOutMEM_WB);
    
    Mux5Bit2To1 MuxRa(MuxRaOut, WriteRegisterMEM_WB, 5'b11111, jumpOutMEM_WB);  
    
    ANDGate regWriteAnd(RegWriteMEM_WB, movMem_WB, RegWrite_AND);
    
//    assign v1 = out_v1;
//    assign v0 = out_v0;
    
    always@(posedge Clk) begin
        v1  <= out_v1;
        v0  <= out_v0;
    end
endmodule
