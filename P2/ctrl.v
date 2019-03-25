// ECE:3350 SISC computer project
// finite state machine

`timescale 1ns/100ps

module ctrl (clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel, br_sel, pc_sel, ir_load, pc_write, pc_rst, rb_sel);

  /* TODO: Declare the ports listed above as inputs or outputs */
  //completed declarations
  input clk, rst_f;
  input[3:0] stat, opcode, mm;

  output rf_we, wb_sel, br_sel, pc_sel, ir_load, pc_write, pc_rst, rb_sel;
  output[1:0] alu_op;

  reg rf_we, wb_sel, br_sel, pc_sel, ir_load, pc_write, pc_rst, rb_sel;
  reg[1:0] alu_op;


  
  
  // states
  parameter start0 = 0, start1 = 1, fetch = 2, decode = 3, execute = 4, mem = 5, writeback = 6;
   
  // opcodes
  parameter NOOP = 0, LOD = 1, STR = 2, SWP = 3, BRA = 4, BRR = 5, BNE = 6, BNR = 7, ALU_OP = 8, HLT = 15;
	
  // addressing modes
  parameter am_imm = 8;

  // state registers
  reg [2:0]  present_state, next_state;

  initial
    present_state = start0;

  /* TODO: Write a sequential procedure that progresses the fsm to the next state on the
       positive edge of the clock, OR resets the state to 'start1' on the negative edge
       of rst_f. Notice that the computer is reset when rst_f is low, not high. */
	   
	//Go through this loop on the positive edge of the clock or the negative edge
	//of reset signal "rst_f"
	always@(posedge clk or negedge rst_f) 
	begin
		if(~rst_f) // (~rst_f) = 1 when rst_f = 0. This format only works for bitwise negation
			present_state <= start1;
		else
			present_state <= next_state;
	end

  
  /* TODO: Write a combination procedure that determines the next state of the fsm. */

	
	always@(*) // asterisk is valid shorthand syntax. See https://bit.ly/2BOdDw0 for more info
	begin
		case(present_state)
			start0: next_state <= start1;
			start1: next_state <= fetch;
			fetch: next_state <= decode;
			decode: next_state <= execute;
			execute: next_state <= mem;
			mem: next_state <= writeback;
			writeback: next_state <= fetch;
			default: next_state <= start0; //I don't know if this is necessary here, but just to be safe
		endcase
	end


  /* TODO: Generate outputs based on the FSM states and inputs. For Parts 2, 3 and 4 you will
       add the new control signals here. */

	   always@(*)
	   begin
		case(present_state)
			start0: 
			begin
				ir_load <= 0; // ir output is 0 (DO NOT TOUCH)

				rf_we <= 0; // register write off (DO NOT TOUCH)
				wb_sel <= 0; // write_data set to alu output (DO NOT TOUCH)
				
				br_sel <= 1; // br_addr set to immediate value + 0 (should be 0 if ir_load is 0) (DO NOT TOUCH)

				pc_rst <= 1; // pc_out set to 0 (DO NOT TOUCH)
				pc_sel <= 1; // pc_in is set to br_addr(0) (DO NOT TOUCH)
				pc_write <= 0; // as long as pc_rst == 1, this doesn't matter too much, but 0 is a safety (TOUCH IF YOU LIKE A LITTLE DANGER)
				

				alu_op <= 2'b10; // no arithmetic, not immediate value input
			end
				
			start1:
			begin
				ir_load <= 0; // ir output is 0 (DO NOT TOUCH)

				rf_we <= 0; // register write off (DO NOT TOUCH)
				wb_sel <= 0; // write_data set to alu output (DO NOT TOUCH)
				
				br_sel <= 1; // br_addr set to immediate value only (should be 0 if ir_load is 0) (DO NOT TOUCH)

				pc_rst <= 1; // pc_out set to 0 (DO NOT TOUCH)
				pc_sel <= 1; // pc_in is set to br_addr(0) (DO NOT TOUCH)
				pc_write <= 0; // as long as pc_rst == 1, this doesn't matter too much, but 0 is a safety (TOUCH IF YOU LIKE A LITTLE DANGER)
				

				alu_op <= 2'b10; // no arithmetic, not immediate value input
			end
				
			fetch:
			begin
				ir_load <= 1; // ir activated

				rf_we <= 0; // register write off (DO NOT TOUCH)
				wb_sel <= 0; // write_data set to alu output (DO NOT TOUCH)
				
				br_sel <= 0; // br_addr set to immediate value + pc_out (DO NOT TOUCH)

				pc_rst <= 0; //  PC not reset (DO NOT TOUCH)
				pc_sel <= 0; // pc_in + 1 (DO NOT TOUCH)
				pc_write <= 0; // pc_out <= pc_in (DO NOT TOUCH)
				

				alu_op <= 2'b10; // 1 no arithmetic, 0 not immediate value input
			end

			decode:
			begin
				ir_load <= 0; // ir deactivated

				rf_we <= 0; // reg write off
				wb_sel <= 0; // write_data <= alu output

				br_sel <= 0; // br_addr <= imm + pc_out

				pc_rst <= 0; //PC not reset

				if(opcode == BRA || opcode == BRR || opcode == BNE || opcode == BNR) begin
					pc_write <= 1;
					pc_sel <= 1;
				end else begin
					pc_write <= 0;
				end


				alu_op <= 2'b10;
				
			end
				
			execute:
			begin
				rf_we <= 0;
				wb_sel <= 0;
				if(opcode == ALU_OP && mm == ALU_OP) begin
					alu_op <= 2'b01; // arithmetic instruction
				end else if (opcode == ALU_OP) begin
					alu_op <= 2'b00; // some other arithmetic operation
				end else begin
					alu_op <= 2'b10;
				end
			end
			mem:
			begin
				rf_we <= 0;
				wb_sel <= 0;
				if(opcode == ALU_OP && mm == ALU_OP) begin
					alu_op <= 2'b01; // arithmetic instruction
				end else if (opcode == ALU_OP) begin
					alu_op <= 2'b00; // some other arithmetic operation
				end else begin
					alu_op <= 2'b10;
				end
			end
				
			writeback:
			begin
				rf_we <= 1; //register file write enabled
				wb_sel <= 0;
				if(opcode == ALU_OP && mm == ALU_OP) begin
					alu_op <= 2'b01; // arithmetic instruction
				end else if (opcode == ALU_OP) begin
					alu_op <= 2'b00; // some other arithmetic operation
				end else begin
					alu_op <= 2'b10;
				end
			end

			default:  //default to initial conditions to be safe
			begin
				rf_we <= 0;
				wb_sel <= 0;
				
				alu_op <= 2'b10;
			end
		endcase
	end

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
