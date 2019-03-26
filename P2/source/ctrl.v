// ECE:3350 SISC computer project
// finite state machine

`timescale 1ns/100ps

module ctrl (clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel, br_sel, pc_sel, ir_load, pc_write, pc_rst, rb_sel);

	/* TODO: Declare the ports listed above as inputs or outputs */
  	//completed declarations
  	input clk, rst_f;
  	input[3:0] stat, opcode, mm;

  	output reg rf_we, wb_sel, br_sel, pc_sel, ir_load, pc_write, pc_rst, rb_sel;
  	output reg[1:0] alu_op;

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
	   
	//Go through this loop on the positive edge of the clock or the negative edge
	//of reset signal "rst_f"
	always@(posedge clk or negedge rst_f) 
	begin
		if(~rst_f) begin // (~rst_f) = 1 when rst_f = 0. This format only works for bitwise negation
			present_state <= start1;
		end else begin
			present_state <= next_state;
		end
	end
	
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

	always@(*)
	begin
		// set values to these defaults every loop
		ir_load <= 0; 
		rb_sel <= 0;
		rf_we <= 0; 
		wb_sel <= 0;		
		br_sel <= 0;
		pc_rst <= 0; 
		pc_write <= 0;
		alu_op <= 2'b10;

		if(opcode == NOOP) begin
			pc_sel <= 0;
		end

		case(present_state)
			start0: 
			begin
				// nothing necessary here
			end
				
			start1:
			begin
				pc_rst <= 1; //reset pc to 0
			end
				
			fetch:
			begin
				ir_load <= 1; // load instruction register
				pc_sel <= 0;
				pc_write <= 1; // write pc_out <= pc_in
			end

			decode:
			begin
				if(opcode == BNE || opcode == BRA) begin
					br_sel <= 1;
				end else if(opcode == BNR || opcode == BRR) begin
					br_sel <= 0;
				end

				if((opcode == BNE || opcode == BNR) && (stat & mm) == 0 || (opcode == BRA || opcode == BRR) && (stat & mm) != 0) begin
					pc_sel <= 1;
					pc_write <= 1;
				end
			end
				
			execute:
			begin
				if(opcode == ALU_OP) begin
					if(mm == 4'b1000) begin
						alu_op <= 2'b01;
					end else begin
						alu_op <= 2'b00;
					end
				end
			end

			mem:
			begin
				if(opcode == ALU_OP) begin
					if(mm == 4'b1000) begin
						alu_op <= 2'b01;
					end else begin
						alu_op <= 2'b00;
					end
				end
			end
				
			writeback:
			begin
				rb_sel <= 1;
				if(opcode == ALU_OP) begin
					rf_we <= 1;
				end
			end

			default:
			begin
				// nothing necessary here
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
