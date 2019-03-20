// ECE:3350 SISC processor project
// main SISC module, part 1

`timescale 1ns/100ps  

module sisc (clk, rst_f, ir);

  input clk, rst_f;
  input [31:0] ir;

// declare all internal wires here
  wire[1:0] alu_op; //alu_op 
  wire wb_sel; //wb_sel
  wire rf_we; //rf_we
  wire stat_en, br_sel, pc_sel; //stat_en
  
  wire[3:0] read_regb; //read_regb
  wire[31:0] rsa; //rsa
  wire[31:0] rsb; //rsb
  wire[3:0] stat_in; //stat_in
  wire[3:0] stat_out; //stat_out
  wire[31:0] alu_result; //alu_result to mux32
  wire[31:0] write_data, pc_out;
  wire[15:0] read_data, br_addr;
  


// component instantiation goes here

  ctrl ControlUnit (clk, rst_f, ir[31:28] /*opcode*/, ir[27:24] /*mm*/, stat_out, rf_we, alu_op, wb_sel, br_sel, pc_sel);
  
  mux4 Mux4 (ir[15:12] /*in_a*/, ir[23:20] /*in_b*/, 1'b0, read_regb);
  
  rf RegisterFile (clk, ir[19:16] /*read_rega*/, read_regb, ir[23:20] /*write_reg*/, write_data, rf_we, rsa, rsb);
  
  alu ArithmeticLogicUnit(clk, rsa, rsb, ir[15:0], alu_op, alu_result, stat_in, stat_en);
  
  mux32 Mux32 (alu_result, 32'h0, wb_sel, write_data);
  
  statreg StatusRegister (clk, stat_in, stat_en, stat_out);

  im InstructionMemory (pc_out, read_data);

  ir InstructionRegister (clk, /*ir_load*/, read_data, /*instr*/);

  pc ProgramCounter (clk, br_addr, pc_sel, /*pc_write*/, /*pc_rst*/, pc_out);

  br BranchCalculator (pc_out /*pc_in*/, ir[15:0] /*imm*/, br_sel, br_addr)
  
               
  

  initial
  
// put a $monitor statement here.  

    $monitor("\nir= %h,\nR1= %h,\nR2= %h,\nR3= %h,\nR4= %h,\nR5= %h,\nR6= %h,\nALU_OP= %h,\nWB_SEL= %h,\nRF_WE= %h,\nwrite_data= %h\nWaiting for next change.\n",
 ir, RegisterFile.ram_array[1], RegisterFile.ram_array[2],RegisterFile.ram_array[3], RegisterFile.ram_array[4],
 RegisterFile.ram_array[5], RegisterFile.ram_array[6], alu_op, wb_sel, rf_we, write_data);



endmodule


