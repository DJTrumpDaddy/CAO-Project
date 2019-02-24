// ECE:3350 SISC processor project
// main SISC module, part 1

`timescale 1ns/100ps  

module sisc (clk, rst_f, ir);

  input clk, rst_f;
  input [31:0] ir;

// declare all internal wires here
  wire ALUOP;
  wire WBSEL;
  wire  RFWE;
  wire STATEN;
  wire ZERO = i'bo
  
  wire opcode = ir[31:28];
  wire red=ir[27:24];
  wire white=ir[23:20];
  wire blue=ir[19:16];
  wire green=ir[15:12];
  wire orange=ir[15:0];
  
  wire MUX4RF;
  wire RSAALU;
  wire RSBALU;
  wire CCSTAT;
  wire STATCTRL;
  wire ALUMUX32;
  wire MUX32RF;
  


// component instantiation goes here

  ctrl CONTROL (clk,rst_f,opcode,red,RFWE,ALUOP,WBSEL);
  mux4 MUX4 (white,green,ZERO,MUTX4RF);
  rf RF (clk,blue,MUX4RF, white, MUX32RF,RFWE,RSAALU,RSBALU);
  asu ALU(clk,RSAALU,RSBALU,orange,ALUOP,ALUMUX32, CCSTAT,STATEN);
  mux32 MUX32 (ZERO, ALUMUX32,WBSEL,MUX32RF);
  statreg STAT (clk, CCSTAT, STATEN,STATCTRL);
               
  

  initial
  
// put a $monitor statement here.  

    $monitor("sisc initialized");


endmodule


