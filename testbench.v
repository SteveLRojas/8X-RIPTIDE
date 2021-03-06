module Testbench();

//timeunit 10ns;
//timeprecision 1ns;
reg clk;
reg n_reset;
reg n_halt;
wire[7:0] data_high;
wire[7:0] data_low;
wire[15:0] A;
wire[15:0] I;
wire[15:0] I_reg;
wire[15:0] I_alternate;
wire[7:0] n_IV_in;
wire[7:0] n_IV_out;
wire IO_SC;
wire IO_WC;
wire IO_n_LB_w;
wire IO_n_RB_w;
wire IO_n_LB_r;
wire IO_n_RB_r;
wire[2:0] REGF_A_ADDRESS;
wire[2:0] REGF_W_ADDRESS;
wire REGF_WREN;
wire[7:0] REGF_W_DATA;
wire[7:0] REGF_A_DATA;
wire[7:0] REGF_B_DATA;
wire NZT;
wire XEC;
wire JMP;
wire CALL;
wire RET;
wire hazard;
wire aux_hazard;
wire latch_hazard;
wire regf_hazard;
wire IO_hazard;
wire pipeline_flush;
wire decoder_RST;
wire[7:0] amux_out;
wire[7:0] alu_out;
wire OVF;
wire[7:0] latch_merge_out;
wire[7:0] latch_merge_in;
wire[2:0] shift_L4;
wire[2:0] merge_D05;
wire[7:0] LB_Din;
wire[7:0] RB_Din;
wire[7:0] LB_Dout;
wire[7:0] RB_Dout;
wire[15:0] IO_address;
wire[2:0] stack_addr;

ROM_high HROM(.clk(clk), .address(A[12:0]), .data(data_high));
ROM_low LROM(.clk(clk), .address(A[12:0]), .data(data_low));

assign I = {data_high, data_low};

N8XRIPTIDE CPU(.clk(clk),
		.n_halt(n_halt),
		.n_reset(n_reset),
		.I(I), .A(A),
		.n_IV_in(n_IV_in),
		.n_IV_out(n_IV_out),
		.IO_SC(IO_SC),	
		.IO_WC(IO_WC),
		.IO_n_LB_w(IO_n_LB_w),
		.IO_n_RB_w(IO_n_RB_w),
		.IO_n_LB_r(IO_n_LB_r),
		.IO_n_RB_r(IO_n_RB_r));
		
IO_mod IO_mod0(
		.clk(clk),
		.IO_SC(IO_SC),
		.IO_WC(IO_WC),
		.IO_n_LB_w(IO_n_LB_w),
		.IO_n_LB_r(IO_n_LB_r),
		.n_IV_out(n_IV_out),
		.n_IV_in(n_IV_in),
		.LB_Din(LB_Din),
		.RB_Din(RB_Din),
		.LB_Dout(LB_Dout),
		.RB_Dout(RB_Dout),
		.IO_address(IO_address));
		
testmem testmem0(.clk(clk), .wren(IO_WC & IO_n_LB_w), .A(IO_address[7:0]), .Din(RB_Dout), .Dout(RB_Din));
		
assign LB_Din = LB_Dout;
		
assign I_reg = CPU.decode_unit0.I_reg;
assign I_alternate = CPU.decode_unit0.I_alternate;
assign REGF_A_ADDRESS = CPU.reg_file0.a_address;
assign REGF_W_ADDRESS = CPU.reg_file0.w_address;
assign REGF_WREN = CPU.reg_file0.wren;
assign REGF_W_DATA = CPU.reg_file0.w_data;
assign REGF_A_DATA = CPU.reg_file0.a_data;
assign REGF_B_DATA = CPU.reg_file0.b_data;
assign NZT = CPU.NZT;
assign XEC = CPU.XEC;
assign JMP = CPU.JMP;
assign CALL = CPU.CALL;
assign RET = CPU.RET;
assign hazard = CPU.hazard;
assign aux_hazard = CPU.hazard_unit0.aux_hazard;
assign latch_hazard = CPU.hazard_unit0.latch_hazard;
assign regf_hazard = CPU.hazard_unit0.regf_hazard;
assign IO_hazard = CPU.hazard_unit0.IO_hazard;
assign pipeline_flush = CPU.pipeline_flush;
assign decoder_RST = CPU.decoder_RST;
assign amux_out = CPU.amux_out;
assign alu_out = CPU.alu_out;
assign OVF = CPU.OVF;
assign latch_merge_out = CPU.latch_merge_out;
assign latch_merge_in = CPU.latch_merge_in;
assign merge_D05 = CPU.merge_D05;
assign shift_L4 = CPU.shift_L4;
assign stack_addr = CPU.PC0.cstack0.address;

always begin: CLOCK_GENERATION
#1 clk =  ~clk;
end

initial begin: CLOCK_INITIALIZATION
	clk = 0;
end

initial begin: TEST_VECTORS
//initial conditions
n_reset = 1'b0;
n_halt = 1'b0;

#8 n_reset = 1'b1;
#8 n_halt = 1'b1;
end
endmodule
