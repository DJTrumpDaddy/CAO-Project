This project was modified by Logan Wood and Skylar Tesar.

HELPFUL TIPS:

** Verilog source code and modelsim work folder are located in the "source" folder of this directory.

** Media and output transcript are located in the "media" directory


In this version (part 2) we:

-- instantiated new modules im.v, ir.v, pc.v, and br.v within the sisc.v module

-- greatly enhanced the readability and organization of the sisc.v module as well as the ctrl.v module

-- generated new monitor statements in the sisc.v module

-- implemented new control signals in the ctrl.v module for branch calculator, program counter, mux4, and the instruction register

## NOTE: branching is dependent on status register state and CC bits from instruction register
