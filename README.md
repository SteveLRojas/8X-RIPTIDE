# 8X-RIPTIDE
Pipelined CPU based on 8X300  

The 8X-RIPTIDE is a vastly improved implementation of the 8X300 instruction set. Although it technically has an 8 stage pipeline it mostly operates like a 6 stage pipelined design, with the last 2 stages being used for IO timing only.  
Two new instructions (CALL and RET) have been added along with an 8 level call stack to allow for easy implementation of subroutines.  

An assembler supporting the two new instructions is available as a separate project, and backwards compatibility with the 8X300 is maintained.  
Documentation of the instruction set, timing model, and assembler syntax will be available before May 2021.  

When implemented on a Cyclone II FPGA this design can achieve speeds of up to 130 MIPS, a vast improvement over the 4 MIPS of the N8X300I.
