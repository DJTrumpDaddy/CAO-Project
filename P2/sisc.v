// ECE:3350 SISC processor project
// main SISC module, part 1

`timescale 1ns/100ps  

module sisc (clk, rst_f);

  input clk, rst_f;
  
// declare all internal wires here

/*ctrl.v outputs*/
  wire[1:0] alu_op; //ctrl.v output
  wire rf_we, wb_sel, br_sel, pc_sel, ir_load, pc_write, pc_rst, rb_sel; //ctrl.v outputs

/*alu outputs*/
  wire stat_en; //alu.v output 
  wire[3:0] stat; //alu.v outputs
  wire[31:0] alu_result; //alu.v outputs  
  
  /*other outputs*/
  wire[31:0] mux32_out; //mux32.v outputs
  wire[31:0] instr; //ir.v outputs
  wire[3:0] mux4_out; //mux4.v outputs
  wire[31:0] rsa, rsb; //rf.v outputs
  wire[3:0] stat_out; //stat.v outputs
  wire[15:0] pc_out; //pc.v outputs
  wire[15:0] read_data; // im.v outputs
  wire[15:0] br_addr; //br.v outputs
  


// component instantiation goes here

  ctrl ControlUnit (clk, rst_f, instr[31:28] /*opcode*/, instr[27:24] /*mm*/, stat_out, rf_we, alu_op, wb_sel, br_sel, pc_sel, ir_load, pc_write, pc_rst, rb_sel);
  
  mux4 Mux4 (instr[15:12] /*in_a*/, instr[23:20] /*in_b*/, rb_sel, mux4_out);
  
  rf RegisterFile (clk, instr[19:16] /*read_rega*/, mux4_out, instr[23:20] /*write_reg*/, mux32_out, rf_we, rsa, rsb);
  
  alu ArithmeticLogicUnit(clk, rsa, rsb, instr[15:0], alu_op, alu_result, stat, stat_en);
  
  mux32 Mux32 (alu_result, 32'h0, wb_sel, mux32_out);
  
  statreg StatusRegister (clk, stat, stat_en, stat_out);

  im InstructionMemory (pc_out, read_data);

  ir InstructionRegister (clk, ir_load, read_data, instr);

  pc ProgramCounter (clk, br_addr, pc_sel, pc_write, pc_rst, pc_out);

  br BranchCalculator (pc_out /*pc_inc*/, instr[15:0] /*imm*/, br_sel, br_addr);
  
               
  

  initial
  
// put a $monitor statement here.  

    $monitor("\ninstr= %h,\nPC= %h\nR1= %h,\nR2= %h,\nR3= %h,\nR4= %h,\nR5= %h,\nR6= %h,\nALU_OP= %h,\nBR_SEL= %h,\nPC_WRITE= %h,\nPC_SEL= %h\nWaiting for next change.\n",
 instr, pc_out, RegisterFile.ram_array[1], RegisterFile.ram_array[2],RegisterFile.ram_array[3], RegisterFile.ram_array[4],
 RegisterFile.ram_array[5], RegisterFile.ram_array[6], alu_op, br_sel, pc_write, pc_sel);



endmodule


