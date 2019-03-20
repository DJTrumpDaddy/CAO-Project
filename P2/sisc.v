// ECE:3350 SISC processor project
// main SISC module, part 1

`timescale 1ns/100ps  

module sisc (clk, rst_f);

  input clk, rst_f;
  
// declare all internal wires here
  wire[1:0] alu_op; //ctrl.v output
  wire rf_we, wb_sel, br_sel, pc_sel, ir_load; //ctrl.v outputs
  wire stat_en;
  
  wire [31:0] instr; //ir.v outputs

  wire[3:0] mux4_out; //mux4.v outputs
  wire[31:0] rsa; //rsa
  wire[31:0] rsb; //rsb
  wire[3:0] stat_in; //stat_in
  wire[3:0] stat_out; //stat_out
  wire[31:0] alu_result; //alu_result to mux32
  wire[31:0] mux32_out; //mux32.v outputs
  wire[31:0] pc_out; //pc.v outputs
  wire[15:0] read_data; // im.v outputs
  wire[15:0] br_addr;
  


// component instantiation goes here

  ctrl ControlUnit (clk, rst_f, instr[31:28] /*opcode*/, instr[27:24] /*mm*/, stat_out, rf_we, alu_op, wb_sel, br_sel, pc_sel, ir_load);
  
  mux4 Mux4 (instr[15:12] /*in_a*/, instr[23:20] /*in_b*/, 1'b0, mux4_out);
  
  rf RegisterFile (clk, instr[19:16] /*read_rega*/, mux4_out, instr[23:20] /*write_reg*/, mux32_out, rf_we, rsa, rsb);
  
  alu ArithmeticLogicUnit(clk, rsa, rsb, instr[15:0], alu_op, alu_result, stat_in, stat_en);
  
  mux32 Mux32 (alu_result, 32'h0, wb_sel, mux32_out);
  
  statreg StatusRegister (clk, stat_in, stat_en, stat_out);

  im InstructionMemory (pc_out, read_data);

  ir InstructionRegister (clk, ir_load, read_data, instr);

  pc ProgramCounter (clk, br_addr, pc_sel, /*pc_write*/, /*pc_rst*/, pc_out);

  br BranchCalculator (pc_out /*pc_in*/, instr[15:0] /*imm*/, br_sel, br_addr)
  
               
  

  initial
  
// put a $monitor statement here.  

    $monitor("\nir= %h,\nR1= %h,\nR2= %h,\nR3= %h,\nR4= %h,\nR5= %h,\nR6= %h,\nALU_OP= %h,\nWB_SEL= %h,\nRF_WE= %h,\nwrite_data= %h\nWaiting for next change.\n",
 ir, RegisterFile.ram_array[1], RegisterFile.ram_array[2],RegisterFile.ram_array[3], RegisterFile.ram_array[4],
 RegisterFile.ram_array[5], RegisterFile.ram_array[6], alu_op, wb_sel, rf_we, mux32_out);



endmodule


