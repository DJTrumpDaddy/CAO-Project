// ECE:3350 SISC computer project
// finite state machine

`timescale 1ns/100ps

module ctrl (clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel);

  /* TODO: Declare the ports listed above as inputs or outputs */
  //completed declarations
  input clk, rst_f, stat;
  input[3:0] opcode, mm;
  
  output rf_we, wb_sel;
  output[1:0] alu_op;
  
  
  // states
  parameter start0 = 3'b0, start1 = 3'b1, fetch = 3'b10, decode = 3'b11, execute = 3'b100, mem = 3'b101, writeback = 3'b110;
   
  // opcodes
  parameter NOOP = 4'b0, LOD = 4'b1, STR = 4'b10, SWP = 4'b11, BRA = 4'b100, BRR = 4'b101, BNE = 4'b110, BNR = 4'b111, ALU_OP = 4'b1000, HLT = 4'b1111;
	
  // addressing modes
  parameter am_imm = 8;

  // state registers
  reg [2:0]  present_state, next_state;

  initial
    present_state = start0;

  /* TODO: Write a sequential procedure that progresses the fsm to the next state on the
       positive edge of the clock, OR resets the state to 'start1' on the negative edge
       of rst_f. Notice that the computer is reset when rst_f is low, not high. */
	   
	always@(posedge clk or negedge rst_f)
	begin
		if(~rst_f) 
			present_state <= start1;
		else
			present_state <= next_state;
	end

  
  /* TODO: Write a combination procedure that determines the next state of the fsm. */

	
	always@(*)
	begin
		assign next_state = (present_state == start0) ? start1:
			(present_state == start1) ? fetch:
			(present_state == fetch) ? decode:
			(present_state == decode) ? execute:
			(present_state == execute) ? mem:
			(present_state == mem) ? writeback:
			start1;
	end


  /* TODO: Generate outputs based on the FSM states and inputs. For Parts 2, 3 and 4 you will
       add the new control signals here. */

// Halt on HLT instruction
  
  always @ (opcode)
  begin
    if (opcode == HLT)
    begin 
      #5 $display ("Halt."); //Delay 5 ns so $monitor will print the halt instruction
      $stop;
    end
  end
    
  
endmodule
