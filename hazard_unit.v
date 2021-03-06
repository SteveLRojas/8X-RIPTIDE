module hazard_unit(
		input wire clk,
		input wire NZT1, NZT2, NZT3, NZT4,
		input wire JMP,
		input wire XEC1, XEC2, XEC3, XEC4,
		input wire RET,
		input wire CALL4,
		input wire ALU_NZ,
		input wire[2:0] alu_op,
		input wire alu_mux,
		input wire HALT,
		input wire RST,
		input wire[2:0] regf_a_read,
		input wire[2:0] regf_w_reg1, regf_w_reg2, regf_w_reg3, regf_w_reg4, regf_w_reg5,
		input wire regf_wren_reg1, regf_wren_reg2, regf_wren_reg3, regf_wren_reg4, regf_wren_reg5,
		input wire SC_reg1, SC_reg2, SC_reg3, SC_reg4, SC_reg5, SC_reg6, SC_reg7,
		input wire WC_reg1, WC_reg2, WC_reg3, WC_reg4, WC_reg5, WC_reg6, WC_reg7,
		input wire n_LB_w_reg1, n_LB_w_reg2, n_LB_w_reg3, n_LB_w_reg4, n_LB_w_reg5, n_LB_w_reg6, n_LB_w_reg7,
		input wire n_LB_r,
		input wire rotate_mux,
		input wire rotate_source,
		input wire latch_wren, latch_wren1, latch_wren2,
		input wire[1:0] latch_address_w1, latch_address_w2,
		input wire[1:0] latch_address_r,
		input wire[2:0] shift_L,
		output wire hazard,
		output wire branch_hazard,
		output wire pipeline_flush,
		output wire decoder_RST);
reg RST_hold;
wire decoder_flush;
wire aux_read;
wire aux_hazard;
wire regf_hazard1, regf_hazard2, regf_hazard3, regf_hazard4, regf_hazard5;
wire regf_hazard;
wire IO_hazard;
wire IO_hazard1, IO_hazard2, IO_hazard3, IO_hazard4, IO_hazard5, IO_hazard6, IO_hazard7;
wire latch_hazard;
wire latch_hazard1, latch_hazard2;
assign branch_hazard = (JMP | RET) & (NZT1 | NZT2 | NZT3 | XEC1 | XEC2 | XEC3);
assign aux_read = (alu_op != 3'b000) & (~alu_mux);
assign decoder_flush = ((~branch_hazard) & (JMP | RET)) | ((NZT4 & ALU_NZ) | XEC4 | CALL4);
assign pipeline_flush = (NZT4 & ALU_NZ) | XEC4 | CALL4;
always @(posedge clk)
begin
	RST_hold <= decoder_flush;
end
assign decoder_RST = decoder_flush | RST_hold | RST;
assign latch_hazard1 = latch_wren1 & (shift_L != 8'h00) & (latch_address_w1 == latch_address_r) & latch_wren;	//no latch write means no latch read
assign latch_hazard2 = latch_wren2 & (shift_L != 8'h00) & (latch_address_w2 == latch_address_r) & latch_wren;
assign regf_hazard1 = regf_wren_reg1 & (~rotate_mux) & (~rotate_source) & (regf_a_read == regf_w_reg1);
assign regf_hazard2 = regf_wren_reg2 & (~rotate_mux) & (~rotate_source) & (regf_a_read == regf_w_reg2);
assign regf_hazard3 = regf_wren_reg3 & (~rotate_mux) & (~rotate_source) & (regf_a_read == regf_w_reg3);
assign regf_hazard4 = regf_wren_reg4 & (~rotate_mux) & (~rotate_source) & (regf_a_read == regf_w_reg4);
assign regf_hazard5 = regf_wren_reg5 & (~rotate_mux) & (~rotate_source) & (regf_a_read == regf_w_reg5);
assign IO_hazard1 = (~rotate_mux) & rotate_source & (SC_reg1 | (WC_reg1 & (n_LB_w_reg1 == n_LB_r)));
assign IO_hazard2 = (~rotate_mux) & rotate_source & (SC_reg2 | (WC_reg2 & (n_LB_w_reg2 == n_LB_r)));
assign IO_hazard3 = (~rotate_mux) & rotate_source & (SC_reg3 | (WC_reg3 & (n_LB_w_reg3 == n_LB_r)));
assign IO_hazard4 = (~rotate_mux) & rotate_source & (SC_reg4 | (WC_reg4 & (n_LB_w_reg4 == n_LB_r)));
assign IO_hazard5 = (~rotate_mux) & rotate_source & (SC_reg5 | (WC_reg5 & (n_LB_w_reg5 == n_LB_r)));
assign IO_hazard6 = (~rotate_mux) & rotate_source & (SC_reg6 | (WC_reg6 & (n_LB_w_reg6 == n_LB_r)));
assign IO_hazard7 = (~rotate_mux) & rotate_source & (SC_reg7 | (WC_reg7 & (n_LB_w_reg7 == n_LB_r)));
assign aux_hazard = aux_read & regf_wren_reg1 & (regf_w_reg1 == 3'h0);
assign latch_hazard = latch_hazard1 | latch_hazard2;
assign regf_hazard = regf_hazard1 | regf_hazard2 | regf_hazard3 | regf_hazard4 | regf_hazard5;
assign IO_hazard = IO_hazard1 | IO_hazard2 | IO_hazard3 | IO_hazard4 | IO_hazard5 | IO_hazard6 | IO_hazard7;
assign hazard = decoder_flush | IO_hazard | regf_hazard | aux_hazard | branch_hazard | latch_hazard | HALT;
endmodule