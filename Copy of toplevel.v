module N8X300(
		input wire clk,
		input wire n_halt,
		input wire n_reset,
		input wire[15:0] I,
		output wire[12:0] A,
		input wire[7:0] n_IV_in,
		output wire[7:0] n_IV_out,
		output wire IO_SC,
		output wire IO_WC,
		output wire IO_n_LB_w,
		output wire IO_n_RB_w,
		output wire IO_n_LB_r,
		output wire IO_n_RB_r);

reg RST, RST_hold;
reg HALT;
reg SC1, SC2, SC3, SC4, SC5, SC6, SC7;
reg WC1, WC2, WC3, WC4, WC5, WC6, WC7;
reg n_LB_w1, n_LB_w2, n_LB_w3, n_LB_w4, n_LB_w5, n_LB_w6, n_LB_w7;
reg n_RB_w1, n_RB_w2, n_RB_w3, n_RB_w4, n_RB_w5, n_RB_w6;
reg n_LB_r1, n_LB_r2, n_LB_r3, n_LB_r4, n_LB_r5, n_LB_r6;
reg n_RB_r1, n_RB_r2, n_RB_r3, n_RB_r4, n_RB_r5, n_RB_r6;
reg latch_wren1, latch_wren2, latch_wren3, latch_wren4, latch_wren5, latch_wren6;
reg[1:0] latch_address_w1, latch_address_w2, latch_address_w3, latch_address_w4, latch_address_w5, latch_address_w6;
reg[1:0] latch_address_r1, latch_address_r2, latch_address_r3, latch_address_r4;
wire[7:0] latch_merge_in, latch_merge_out, latch_rotate_out;
wire[2:0] regf_a;
reg[2:0] regf_w1, regf_w2, regf_w3, regf_w4, regf_w5;
reg regf_wren1, regf_wren2, regf_wren3, regf_wren4, regf_wren5;
wire[7:0] a_data, b_data;
wire[7:0] rotate_out;
reg[2:0] rotate_S01, rotate_R1;
reg rotate_source1;
reg rotate_mux1;
wire[7:0] rmux_out;
reg[2:0] mask_L1, mask_L2;
wire[7:0] mask_out;
reg[2:0] alu_op1, alu_op2, alu_op3;
wire[7:0] amux_out;
reg[7:0] alu_I_field1, alu_I_field2, alu_I_field3;
reg alu_mux1, alu_mux2, alu_mux3;
wire[7:0] alu_out;
wire OVF;
wire NZ;
wire decoder_RST;
wire SC;
wire WC;
wire n_LB_w;
wire n_RB_w;
wire n_LB_r;
wire n_RB_r;
wire[2:0] merge_D0;
wire[2:0] shift_L;
wire[2:0] alu_op;
wire[2:0] rotate_S0;
wire[2:0] rotate_R;
wire rotate_source;
wire rotate_mux;
wire[2:0] mask_L;
wire alu_mux;
wire[7:0] alu_I_field;
wire latch_wren;
wire[1:0] latch_address_w;
wire[1:0] latch_address_r;
wire[2:0] regf_w;
wire regf_wren;
reg NZT1, NZT2, NZT3, NZT4;
reg XEC1, XEC2, XEC3, XEC4;
wire NZT;
wire XEC;
wire JMP;
wire long_I;
wire[12:0] PC_I_field;
reg[2:0] merge_D01, merge_D02, merge_D03, merge_D04, merge_D05;
reg[2:0] shift_L1, shift_L2, shift_L3, shift_L4;
wire hazard;
wire pipeline_flush;
assign IO_SC = SC6;
assign IO_WC = WC6;
assign IO_n_LB_w = n_LB_w6;
assign IO_n_RB_w = n_RB_w6;
assign IO_n_LB_r = n_LB_r6;
assign IO_n_RB_r = n_RB_r6;

always @(posedge clk)
begin
	RST <= (~n_reset) | RST_hold;
	RST_hold <= ~n_reset;
	HALT <= ~n_halt;
	if(RST)
	begin
		SC1 <= 1'b0;
		SC2 <= 1'b0;
		SC3 <= 1'b0;
		SC4 <= 1'b0;
		WC1 <= 1'b0;
		WC2 <= 1'b0;
		WC3 <= 1'b0;
		WC4 <= 1'b0;
		n_LB_w1 <= 1'b0;
		n_LB_w2 <= 1'b0;
		n_LB_w3 <= 1'b0;
		n_LB_w4 <= 1'b0;
		n_RB_w1 <= 1'b1;
		n_RB_w2 <= 1'b1;
		n_RB_w3 <= 1'b1;
		n_RB_w4 <= 1'b1;
		n_LB_r1 <= 1'b0;
		n_LB_r2 <= 1'b0;
		n_LB_r3 <= 1'b0;
		n_LB_r4 <= 1'b0;
		n_RB_r1 <= 1'b1;
		n_RB_r2 <= 1'b1;
		n_RB_r3 <= 1'b1;
		n_RB_r4 <= 1'b1;
		latch_wren1 <= 1'b0;
		latch_wren2 <= 1'b0;
		latch_wren3 <= 1'b0;
		latch_wren4 <= 1'b0;
		latch_address_w1 <= 2'h0;
		latch_address_w2 <= 2'h0;
		latch_address_w3 <= 2'h0;
		latch_address_w4 <= 2'h0;
		latch_address_r1 <= 2'h0;
		latch_address_r2 <= 2'h0;
		latch_address_r3 <= 2'h0;
		latch_address_r4 <= 2'h0;
		regf_w1 <= 3'h0;
		regf_w2 <= 3'h0;
		regf_w3 <= 3'h0;
		regf_w4 <= 3'h0;
		regf_wren1 <= 1'b0;
		regf_wren2 <= 1'b0;
		regf_wren3 <= 1'b0;
		regf_wren4 <= 1'b0;
		rotate_S01 <= 3'h0;
		rotate_R1 <= 3'h0;
		rotate_source1 <= 1'b0;
		rotate_mux1 <= 1'b0;
		mask_L1 <= 3'h0;
		mask_L2 <= 3'h0;
		alu_op1 <= 3'h0;
		alu_op2 <= 3'h0;
		alu_op3 <= 3'h0;
		alu_I_field1 <= 8'h0;
		alu_I_field2 <= 8'h0;
		alu_I_field3 <= 8'h0;
		alu_mux1 <= 1'b0;
		alu_mux2 <= 1'b0;
		alu_mux3 <= 1'b0;
		merge_D01 <= 3'h0;
		merge_D02 <= 3'h0;
		merge_D03 <= 3'h0;
		merge_D04 <= 3'h0;
		shift_L1 <= 3'h0;
		shift_L2 <= 3'h0;
		shift_L3 <= 3'h0;
		shift_L4 <= 3'h0;
		NZT1 <= 1'b0;
		NZT2 <= 1'b0;
		NZT3 <= 1'b0;
		NZT4 <= 1'b0;
		XEC1 <= 1'b0;
		XEC2 <= 1'b0;
		XEC3 <= 1'b0;
		XEC4 <= 1'b0;
	end
	else
	begin
		if(pipeline_flush)
		begin
		SC1 <= 1'b0;
		SC2 <= 1'b0;
		SC3 <= 1'b0;
		SC4 <= 1'b0;
		WC1 <= 1'b0;
		WC2 <= 1'b0;
		WC3 <= 1'b0;
		WC4 <= 1'b0;
		n_LB_w1 <= 1'b0;
		n_LB_w2 <= 1'b0;
		n_LB_w3 <= 1'b0;
		n_LB_w4 <= 1'b0;
		n_RB_w1 <= 1'b1;
		n_RB_w2 <= 1'b1;
		n_RB_w3 <= 1'b1;
		n_RB_w4 <= 1'b1;
		n_LB_r1 <= 1'b0;
		n_LB_r2 <= 1'b0;
		n_LB_r3 <= 1'b0;
		n_LB_r4 <= 1'b0;
		n_RB_r1 <= 1'b1;
		n_RB_r2 <= 1'b1;
		n_RB_r3 <= 1'b1;
		n_RB_r4 <= 1'b1;
		latch_wren1 <= 1'b0;
		latch_wren2 <= 1'b0;
		latch_wren3 <= 1'b0;
		latch_wren4 <= 1'b0;
		latch_address_w1 <= 2'h0;
		latch_address_w2 <= 2'h0;
		latch_address_w3 <= 2'h0;
		latch_address_w4 <= 2'h0;
		latch_address_r1 <= 2'h0;
		latch_address_r2 <= 2'h0;
		latch_address_r3 <= 2'h0;
		latch_address_r4 <= 2'h0;
		regf_w1 <= 3'h0;
		regf_w2 <= 3'h0;
		regf_w3 <= 3'h0;
		regf_w4 <= 3'h0;
		regf_wren1 <= 1'b0;
		regf_wren2 <= 1'b0;
		regf_wren3 <= 1'b0;
		regf_wren4 <= 1'b0;
		rotate_S01 <= 3'h0;
		rotate_R1 <= 3'h0;
		rotate_source1 <= 1'b0;
		rotate_mux1 <= 1'b0;
		mask_L1 <= 3'h0;
		mask_L2 <= 3'h0;
		alu_op1 <= 3'h0;
		alu_op2 <= 3'h0;
		alu_op3 <= 3'h0;
		alu_I_field1 <= 8'h0;
		alu_I_field2 <= 8'h0;
		alu_I_field3 <= 8'h0;
		alu_mux1 <= 1'b0;
		alu_mux2 <= 1'b0;
		alu_mux3 <= 1'b0;
		merge_D01 <= 3'h0;
		merge_D02 <= 3'h0;
		merge_D03 <= 3'h0;
		merge_D04 <= 3'h0;
		shift_L1 <= 3'h0;
		shift_L2 <= 3'h0;
		shift_L3 <= 3'h0;
		shift_L4 <= 3'h0;
		NZT1 <= 1'b0;
		NZT2 <= 1'b0;
		NZT3 <= 1'b0;
		NZT4 <= 1'b0;
		XEC1 <= 1'b0;
		XEC2 <= 1'b0;
		XEC3 <= 1'b0;
		XEC4 <= 1'b0;
		end
		else
		begin
			if(hazard)
			begin
				SC1 <= 1'b0;
				WC1 <= 1'b0;
				n_LB_w1 <= 1'b0;
				n_RB_w1 <= 1'b1;
				n_LB_r1 <= 1'b0;
				n_RB_r1 <= 1'b1;
				latch_wren1 <= 1'b0;
				latch_address_w1 <= 2'h0;
				latch_address_r1 <= 2'h0;
				regf_w1 <= 3'h0;
				regf_wren1 <= 1'b0;
				rotate_S01 <= 3'h0;
				rotate_R1 <= 3'h0;
				rotate_source1 <= 1'b0;
				rotate_mux1 <= 1'b0;
				mask_L1 <= 3'h0;
				alu_op1 <= 3'h0;
				alu_I_field1 <= 8'h0;
				alu_mux1 <= 1'b0;
				merge_D01 <= 3'h0;
				shift_L1 <= 3'h0;
				NZT1 <= 1'b0;
				XEC1 <= 1'b0;
			end
			else
			begin
				SC1 <= SC;
				WC1 <= WC;
				n_LB_w1 <= n_LB_w;
				n_RB_w1 <= n_RB_w;
				n_LB_r1 <= n_LB_r;
				n_RB_r1 <= n_RB_r;
				latch_wren1 <= latch_wren;
				latch_address_w1 <= latch_address_w;
				latch_address_r1 <= latch_address_r;
				regf_w1 <= regf_w;
				regf_wren1 <= regf_wren;
				rotate_S01 <= rotate_S0;
				rotate_R1 <= rotate_R;
				rotate_source1 <= rotate_source;
				rotate_mux1 <= rotate_mux;
				mask_L1 <= mask_L;
				alu_op1 <= alu_op;
				alu_I_field1 <= alu_I_field;
				alu_mux1 <= alu_mux;
				merge_D01 <= merge_D0;
				shift_L1 <= shift_L;
				NZT1 <= NZT;
				XEC1 <= XEC;
			end
			SC2 <= SC1;
			SC3 <= SC2;
			SC4 <= SC3;
			WC2 <= WC1;
			WC3 <= WC2;
			WC4 <= WC3;
			n_LB_w2 <= n_LB_w1;
			n_LB_w3 <= n_LB_w2;
			n_LB_w4 <= n_LB_w3;
			n_RB_w2 <= n_RB_w1;
			n_RB_w3 <= n_RB_w2;
			n_RB_w4 <= n_RB_w3;
			n_LB_r2 <= n_LB_r1;
			n_LB_r3 <= n_LB_r2;
			n_LB_r4 <= n_LB_r3;
			n_RB_r2 <= n_RB_r1;
			n_RB_r3 <= n_RB_r2;
			n_RB_r4 <= n_RB_r3;
			latch_wren2 <= latch_wren1;
			latch_wren3 <= latch_wren2;
			latch_wren4 <= latch_wren3;
			latch_address_w2 <= latch_address_w1;
			latch_address_w3 <= latch_address_w2;
			latch_address_w4 <= latch_address_w3;
			latch_address_r2 <= latch_address_r1;
			latch_address_r3 <= latch_address_r2;
			latch_address_r4 <= latch_address_r3;
			regf_w2 <= regf_w1;
			regf_w3 <= regf_w2;
			regf_w4 <= regf_w3;
			regf_wren2 <= regf_wren1;
			regf_wren3 <= regf_wren2;
			regf_wren4 <= regf_wren3;
			mask_L2 <= mask_L1;
			alu_op2 <= alu_op1;
			alu_op3 <= alu_op2;
			alu_I_field2 <= alu_I_field1;
			alu_I_field3 <= alu_I_field2;
			alu_mux2 <= alu_mux1;
			alu_mux3 <= alu_mux2;
			merge_D02 <= merge_D01;
			merge_D03 <= merge_D02;
			merge_D04 <= merge_D03;
			shift_L2 <= shift_L1;
			shift_L3 <= shift_L2;
			shift_L4 <= shift_L3;
			NZT2 <= NZT1;
			NZT3 <= NZT2;
			NZT4 <= NZT3;
			XEC2 <= XEC1;
			XEC3 <= XEC2;
			XEC4 <= XEC3;
		end
	end
	SC5 <= SC4;
	SC6 <= SC5;
	SC7 <= SC6;
	WC5 <= WC4;
	WC6 <= WC5;
	WC7 <= WC6;
	n_LB_w5 <= n_LB_w4;
	n_LB_w6 <= n_LB_w5;
	n_LB_w7 <= n_LB_w6;
	n_RB_w5 <= n_RB_w4;
	n_RB_w6 <= n_RB_w5;
	n_LB_r5 <= n_LB_r4;
	n_LB_r6 <= n_LB_r5;
	n_RB_r5 <= n_RB_r4;
	n_RB_r6 <= n_RB_r5;
	latch_wren5 <= latch_wren4;
	latch_wren6 <= latch_wren5;
	latch_address_w5 <= latch_address_w4;
	latch_address_w6 <= latch_address_w5;
	regf_w5 <= regf_w4;
	regf_wren5 <= regf_wren4;
	merge_D05 <= merge_D04;
end
// IO module
assign n_IV_out = latch_merge_in;
IO_latch IO_latch0(
		.clk(clk),
		.latch_wren(latch_wren6),
		.latch_address_w(latch_address_w6),
		.latch_address_r(latch_address_r4),
		.merge_in(latch_merge_in),
		.IO_in(~n_IV_in),
		.merge_out(latch_merge_out),
		.rotate_out(latch_rotate_out));
//register file
reg_file reg_file0(
		.clk(clk),
		.a_address(regf_a),
		.w_address(regf_w4),
		.wren(regf_wren4),
		.w_data(alu_out),
		.a_data(a_data),
		.b_data(b_data));
//right rotate module
assign rmux_out = rotate_mux1 ? {7'h0, OVF} : a_data;
right_rotate right_rotate0(
		.clk(clk),
		.regf_in(rmux_out),
		.IO_in(latch_rotate_out),
		.rotate_out(rotate_out),
		.S0(rotate_S01),
		.R(rotate_R1),
		.source(rotate_source1));
//mask module
mask_unit mask0(.clk(clk), .mask_in(rotate_out), .L_select(mask_L2), .mask_out(mask_out));
//ALU
assign amux_out = alu_mux3 ? alu_I_field3 : b_data;
ALU ALU0(.clk(clk), .flush(pipeline_flush), .op(alu_op3), .in_a(mask_out), .in_b(amux_out), .alu_out(alu_out), .OVF_out(OVF), .NZ_out(NZ));
//shift and merge module
shift_merge shift_merge0(.clk(clk), .shift_in(alu_out), .merge_in(latch_merge_out), .merge_out(latch_merge_in), .D0(merge_D05), .L_select(shift_L4));
//PC
PC PC0(
		.clk(clk),
		.NZT(NZT4),
		.XEC(XEC4),
		.JMP(JMP),
		.RST(RST),
		.ALU_NZ(NZ),
		.hazard(hazard),
		.long_I(long_I),
		.ALU_data(alu_out),
		.PC_I_field(PC_I_field),
		.A(A));
//control unit
decode_unit decode_unit0(
		.clk(clk),
		.RST(decoder_RST),
		.hazard(hazard), 
		.I(I),
		.SC(SC),
		.WC(WC),
		.n_LB_w(n_LB_w),
		.n_RB_w(n_RB_w),
		.n_LB_r(n_LB_r),
		.n_RB_r(n_RB_r),
		.rotate_S0(rotate_S0),
		.rotate_R(rotate_R),
		.rotate_source(rotate_source),
		.rotate_mux(rotate_mux),
		.mask_L(mask_L),
		.alu_op(alu_op),
		.alu_mux(alu_mux),
		.alu_I_field(alu_I_field),
		.latch_wren(latch_wren),
		.latch_address_w(latch_address_w),
		.latch_address_r(latch_address_r),
		.merge_D0(merge_D0),
		.shift_L(shift_L),
		.regf_a(regf_a),
		.regf_w(regf_w),
		.regf_wren(regf_wren),
		.PC_JMP(JMP),
		.PC_XEC(XEC),
		.PC_NZT(NZT),
		.PC_I_field(PC_I_field),
		.long_I(long_I));
//hazard unit
hazard_unit hazard_unit0(
		.clk(clk),
		.NZT(NZT), .NZT1(NZT1), .NZT2(NZT2), .NZT3(NZT3), .NZT4(NZT4),
		.JMP(JMP),
		.XEC(XEC), .XEC1(XEC1), .XEC2(XEC2), .XEC3(XEC3), .XEC4(XEC4),
		.ALU_NZ(NZ),
		.alu_op(alu_op),
		.alu_mux(alu_mux),
		.HALT(HALT),
		.RST(RST),
		.regf_a_read(regf_a),
		.regf_w_reg1(regf_w1), .regf_w_reg2(regf_w2), .regf_w_reg3(regf_w3), .regf_w_reg4(regf_w4), .regf_w_reg5(regf_w5),
		.regf_wren_reg1(regf_wren1), .regf_wren_reg2(regf_wren2), .regf_wren_reg3(regf_wren3), .regf_wren_reg4(regf_wren4), .regf_wren_reg5(regf_wren5),
		.SC_reg1(SC1), .SC_reg2(SC2), .SC_reg3(SC3), .SC_reg4(SC4), .SC_reg5(SC5), .SC_reg6(SC6), .SC_reg7(SC7),
		.WC_reg1(WC1), .WC_reg2(WC2), .WC_reg3(WC3), .WC_reg4(WC4), .WC_reg5(WC5), .WC_reg6(WC6), .WC_reg7(WC7),
		.n_LB_w_reg1(n_LB_w1), .n_LB_w_reg2(n_LB_w2), .n_LB_w_reg3(n_LB_w3), .n_LB_w_reg4(n_LB_w4), .n_LB_w_reg5(n_LB_w5), .n_LB_w_reg6(n_LB_w6), .n_LB_w_reg7(n_LB_w7),
		.n_LB_r(n_LB_r),
		.rotate_mux(rotate_mux),
		.rotate_source(rotate_source),
		.hazard(hazard),
		.pipeline_flush(pipeline_flush),
		.decoder_RST(decoder_RST));
endmodule

module right_rotate(input wire clk, input wire[7:0] regf_in, IO_in, output wire[7:0] rotate_out, input wire[2:0] S0, R, input wire source);
wire[2:0] selector;
wire[7:0] selected;
reg[7:0] rotate_reg;
assign selector = (source) ? ~S0 : R;
assign selected = (source) ? IO_in : regf_in;
always @(posedge clk)
begin
	case(selector)
	3'b000: rotate_reg <= selected;
	3'b001: rotate_reg <= {selected[0], selected[7:1]};
	3'b010: rotate_reg <= {selected[1:0], selected[7:2]};
	3'b011: rotate_reg <= {selected[2:0], selected[7:3]};
	3'b100: rotate_reg <= {selected[3:0], selected[7:4]};
	3'b101: rotate_reg <= {selected[4:0], selected[7:5]};
	3'b110: rotate_reg <= {selected[5:0], selected[7:6]};
	3'b111: rotate_reg <= {selected[6:0], selected[7]};
	endcase
end
assign rotate_out = rotate_reg;
endmodule

module mask_unit(input wire clk, input wire[7:0] mask_in, input wire[2:0] L_select, output wire[7:0] mask_out);
reg[7:0] mask_reg;
always @(posedge clk)
begin
	case(L_select)
	3'b000: mask_reg <= mask_in;
	3'b001: mask_reg <= {7'h0, mask_in[0]};
	3'b010: mask_reg <= {6'h0, mask_in[1:0]};
	3'b011: mask_reg <= {5'h0, mask_in[2:0]};
	3'b100: mask_reg <= {4'h0, mask_in[3:0]};
	3'b101: mask_reg <= {3'h0, mask_in[4:0]};
	3'b110: mask_reg <= {2'b0, mask_in[5:0]};
	3'b111: mask_reg <= {1'b0, mask_in[6:0]};
	endcase
end
assign mask_out = mask_reg;
endmodule

module ALU(input wire clk, flush, input wire[2:0] op, input wire[7:0] in_a, in_b, output wire[7:0] alu_out, output wire OVF_out, NZ_out);
reg[7:0] alu_reg;
reg OVF_reg;
reg NZ_reg;
wire[8:0] add_result;
assign add_result = in_a + in_b;
always @(posedge clk)
begin
	case(op)
	3'b000: alu_reg <= in_a;
	3'b001: alu_reg <= add_result[7:0];
	3'b010: alu_reg <= in_a & in_b;
	3'b011: alu_reg <= in_a ^ in_b;
	3'b100: alu_reg <= in_b;
	3'b101: alu_reg <= add_result[7:0];
	3'b110: alu_reg <= in_a & in_b;
	3'b111: alu_reg <= in_a ^ in_b;
	endcase
	if((op[1:0] == 2'b01) & (~flush))
		OVF_reg <= add_result[8];
	if(in_a != 8'h00)
		NZ_reg <= 1'b1;
	else
		NZ_reg <= 1'b0;
end
assign alu_out = alu_reg;
assign OVF_out = OVF_reg;
assign NZ_out = NZ_reg;
endmodule

module IO_latch(input wire clk, latch_wren, input wire[1:0] latch_address_w, latch_address_r, input wire[7:0] merge_in, IO_in, output wire[7:0] merge_out, rotate_out);
reg[7:0] merge_out_reg;
reg[7:0] rotate_out_reg;
reg[7:0] LBA_reg;
reg[7:0] RBA_reg;
reg[7:0] IV_reg0, IV_reg1, IV_reg2, IV_reg3;
always @(posedge clk)
begin
	rotate_out_reg <= IO_in;
	IV_reg0 <= rotate_out_reg;
	IV_reg1 <= IV_reg0;
	IV_reg2 <= IV_reg1;
	IV_reg3 <= IV_reg2;
	if(latch_wren)
	begin
		if(latch_address_w == latch_address_r)
			merge_out_reg <= merge_in;
		else
		begin
			case(latch_address_r)
			2'h0: merge_out_reg <= LBA_reg;
			2'h1: merge_out_reg <= RBA_reg;
			2'h2: merge_out_reg <= IV_reg3;
			2'h3: merge_out_reg <= IV_reg3;
			endcase
		end
		case(latch_address_w)
		2'h0: LBA_reg <= merge_in;
		2'h1: RBA_reg <= merge_in;
		2'h2: ;
		2'h3: ;
		endcase
	end
	else
	begin
		case(latch_address_r)
		2'h0: merge_out_reg <= LBA_reg;
		2'h1: merge_out_reg <= RBA_reg;
		2'h2: merge_out_reg <= IV_reg3;
		2'h3: merge_out_reg <= IV_reg3;
		endcase
	end
end
assign merge_out = merge_out_reg;
assign rotate_out = rotate_out_reg;
endmodule

module shift_merge(input wire clk, input wire[7:0] shift_in, merge_in, output wire[7:0] merge_out, input wire[2:0] D0, L_select);
reg[7:0] shift_reg;
reg[7:0] merge_reg;
reg[7:0] merge_mask;
always @(posedge clk)
begin
	case(L_select)
	3'b000: shift_reg <= shift_in;
	3'b001: shift_reg <= {7'h0, shift_in[0]};
	3'b010: shift_reg <= {6'h0, shift_in[1:0]};
	3'b011: shift_reg <= {5'h0, shift_in[2:0]};
	3'b100: shift_reg <= {4'h0, shift_in[3:0]};
	3'b101: shift_reg <= {3'h0, shift_in[4:0]};
	3'b110: shift_reg <= {2'b0, shift_in[5:0]};
	3'b111: shift_reg <= {1'b0, shift_in[6:0]};
	endcase
	case(L_select)
	3'b000: merge_mask <= 8'h0;
	3'b001: merge_mask <= {7'b1111111, 1'b0};
	3'b010: merge_mask <= {6'b111111, 2'b00};
	3'b011: merge_mask <= {5'b11111, 3'b000};
	3'b100: merge_mask <= {4'b1111, 4'b0000};
	3'b101: merge_mask <= {3'b111, 5'b00000};
	3'b110: merge_mask <= {2'b11, 6'b000000};
	3'b111: merge_mask <= {1'b1, 7'b0000000};
	endcase
	case(D0)
	3'b000: merge_reg <= {shift_reg[0], 7'h00} | (merge_in & {merge_mask[0], 7'h00});
	3'b001: merge_reg <= {shift_reg[1:0], 6'h00} | (merge_in & {merge_mask[1:0], 6'h00});
	3'b010: merge_reg <= {shift_reg[2:0], 5'h00} | (merge_in & {merge_mask[2:0], 5'h00});
	3'b011: merge_reg <= {shift_reg[3:0], 4'h0} | (merge_in & {merge_mask[3:0], 4'h0});
	3'b100: merge_reg <= {shift_reg[4:0], 3'h0} | (merge_in & {merge_mask[4:0], 3'h0});
	3'b101: merge_reg <= {shift_reg[5:0], 2'b00} | (merge_in & {merge_mask[5:0], 2'b00});
	3'b110: merge_reg <= {shift_reg[6:0], 1'b0} | (merge_in & {merge_mask[6:0], 1'b0});
	3'b111: merge_reg <= shift_reg | (merge_in & merge_mask);
	endcase
end
assign merge_out = merge_reg;
endmodule

module reg_file(input wire clk, wren, input wire[2:0] a_address, w_address, input wire[7:0] w_data, output wire[7:0] a_data, b_data);
reg[7:0] a_reg;
reg[7:0] rfile[7:0];
always @(posedge clk)
begin
	if(wren)
		rfile[w_address] <= w_data;
	a_reg <= rfile[a_address];
end
assign a_data = a_reg;
assign b_data = rfile[0];
endmodule

module decode_unit(
		input wire clk,
		input wire RST,
		input wire hazard,
		input wire[15:0] I,
		output wire SC,
		output wire WC,
		output wire n_LB_w,
		output wire n_RB_w,
		output wire n_LB_r,
		output wire n_RB_r,
		output wire[2:0] rotate_S0,
		output wire[2:0] rotate_R,
		output wire rotate_source,
		output wire rotate_mux,
		output wire[2:0] mask_L,
		output wire[2:0] alu_op,
		output wire alu_mux,
		output wire[7:0] alu_I_field,
		output wire latch_wren,
		output wire[1:0] latch_address_w,
		output wire[1:0] latch_address_r,
		output wire[2:0] merge_D0,
		output wire[2:0] shift_L,
		output wire[2:0] regf_a,
		output wire[2:0] regf_w,
		output wire regf_wren,
		output wire PC_JMP,
		output wire PC_XEC,
		output wire PC_NZT,
		output wire[12:0] PC_I_field,
		output wire long_I);
reg[15:0] I_reg;
reg[15:0] I_alternate;
reg prev_hazard;
reg SC_reg;
reg WC_reg;
reg n_LB_w_reg;
reg n_RB_w_reg;
reg n_LB_r_reg;
reg n_RB_r_reg;
reg[2:0] rotate_S0_reg;
reg[2:0] rotate_R_reg;
reg rotate_source_reg;
reg rotate_mux_reg;
reg[2:0] mask_L_reg;
reg[2:0] alu_op_reg;
reg alu_mux_reg;
reg[7:0] alu_I_field_reg;
reg latch_wren_reg;
reg[1:0] latch_address_w_reg;
reg[1:0] latch_address_r_reg;
reg[2:0] merge_D0_reg;
reg[2:0] shift_L_reg;
reg[2:0] regf_a_reg, regf_w_reg;
reg regf_wren_reg;
reg JMP;
reg XEC;
reg NZT;
reg[12:0] PC_I_field_reg;
assign long_I = ~I_reg[12];
always @(posedge clk)
begin
	if(RST)
	begin
		I_reg <= 16'h00;
		prev_hazard <= 1'b0;
	end
	else 
	begin
		prev_hazard <= hazard;
		PC_I_field_reg <= I_reg[12:0];
		if(hazard & (~prev_hazard))
			I_alternate <= I;
		if(~hazard)
		begin
			if(prev_hazard)
				I_reg <= I_alternate;
			else
				I_reg <= I;
		end
	end
	if(RST)
	begin
		JMP <= 1'b0;
		NZT <= 1'b0;
		XEC <= 1'b0;
	end
	else if(~hazard)
	begin
		case(I_reg[15:13])
		3'h0:	//move
		begin
			case(I_reg[11])	//S1 field
			1'h0: regf_a_reg <= I_reg[10:8];
			1'h1: regf_a_reg <= 3'h7;
			endcase
			n_LB_r_reg <= I_reg[11];
			n_RB_r_reg <= ~I_reg[11];
			JMP <= 1'b0;
			
			case(I_reg[11])
			1'b0: rotate_mux_reg <= 1'b0;
			1'b1: rotate_mux_reg <= ~I_reg[8];
			endcase
			rotate_source_reg <= I_reg[12];
			case(I_reg[4])
			1'b0: rotate_R_reg <= I_reg[7:5];
			1'b1: rotate_R_reg <= 3'b000;
			endcase
			rotate_S0_reg <= I_reg[10:8];
			
			if(I_reg[12])
				mask_L_reg <= I_reg[7:5];
			else
				mask_L_reg <= 3'h0;
				
			alu_op_reg <= 3'h0;	//move
			alu_mux_reg <= 1'b0;
			alu_I_field_reg <= I_reg[7:0] & {{3{~I_reg[12]}}, 5'b11111};
			
			shift_L_reg <= I_reg[7:5];
			case(I_reg[3])
			1'b0: regf_w_reg <= I_reg[2:0];
			1'b1: regf_w_reg <= 3'h7;
			endcase
			if((I_reg[4:3] == 2'b00 && I_reg[2:0] != 3'h7) || (I_reg[4:3] == 2'b01 && I_reg[2:0] == 3'b001))
				regf_wren_reg <= ((I_reg[7:5] != 3'h0) | (I_reg[12:8] != I_reg[4:0]));	//prevent NOP from triggering hazard detection
			else
				regf_wren_reg <= 1'b0;
			latch_address_r_reg <= I_reg[4:3];
			NZT <= 1'b0;
			XEC <= 1'b0;
			
			merge_D0_reg <= I_reg[2:0];
			WC_reg <= I_reg[4];
			if(I_reg[4] == 1'b0 && (I_reg[2:0] == 3'h7))
				SC_reg <= 1'b1;
			else
				SC_reg <= 1'b0;
			n_LB_w_reg <= I_reg[3];
			n_RB_w_reg <= ~I_reg[3];
			if((I_reg[4:3] != 2'b00) || (I_reg[2:0] == 3'h7))
				latch_wren_reg <= 1'b1;
			else
				latch_wren_reg <= 1'b0;
			latch_address_w_reg <= I_reg[4:3];
		end
		3'h1:	//add
		begin
			case(I_reg[11])	//S1 field
			1'h0: regf_a_reg <= I_reg[10:8];
			1'h1: regf_a_reg <= 3'h7;
			endcase
			n_LB_r_reg <= I_reg[11];
			n_RB_r_reg <= ~I_reg[11];
			JMP <= 1'b0;
			
			case(I_reg[11])
			1'b0: rotate_mux_reg <= 1'b0;
			1'b1: rotate_mux_reg <= ~I_reg[8];
			endcase
			rotate_source_reg <= I_reg[12];
			case(I_reg[4])
			1'b0: rotate_R_reg <= I_reg[7:5];
			1'b1: rotate_R_reg <= 3'b000;
			endcase
			rotate_S0_reg <= I_reg[10:8];
			
			if(I_reg[12])
				mask_L_reg <= I_reg[7:5];
			else
				mask_L_reg <= 3'h0;
				
			alu_op_reg <= 3'h1;	//add
			alu_mux_reg <= 1'b0;
			alu_I_field_reg <= I_reg[7:0] & {{3{~I_reg[12]}}, 5'b11111};
			
			shift_L_reg <= I_reg[7:5];
			case(I_reg[3])
			1'b0: regf_w_reg <= I_reg[2:0];
			1'b1: regf_w_reg <= 3'h7;
			endcase
			if((I_reg[4:3] == 2'b00 && I_reg[2:0] != 3'h7) || (I_reg[4:3] == 2'b01 && I_reg[2:0] == 3'b001))
				regf_wren_reg <= 1'b1;
			else
				regf_wren_reg <= 1'b0;
			latch_address_r_reg <= I_reg[4:3];
			NZT <= 1'b0;
			XEC <= 1'b0;
			
			merge_D0_reg <= I_reg[2:0];
			WC_reg <= I_reg[4];
			if(I_reg[4] == 1'b0 && (I_reg[2:0] == 3'h7))
				SC_reg <= 1'b1;
			else
				SC_reg <= 1'b0;
			n_LB_w_reg <= I_reg[3];
			n_RB_w_reg <= ~I_reg[3];
			if((I_reg[4:3] != 2'b00) || (I_reg[2:0] == 3'h7))
				latch_wren_reg <= 1'b1;
			else
				latch_wren_reg <= 1'b0;
			latch_address_w_reg <= I_reg[4:3];
		end
		3'h2:	//and
		begin
			case(I_reg[11])	//S1 field
			1'h0: regf_a_reg <= I_reg[10:8];
			1'h1: regf_a_reg <= 3'h7;
			endcase
			n_LB_r_reg <= I_reg[11];
			n_RB_r_reg <= ~I_reg[11];
			JMP <= 1'b0;
			
			case(I_reg[11])
			1'b0: rotate_mux_reg <= 1'b0;
			1'b1: rotate_mux_reg <= ~I_reg[8];
			endcase
			rotate_source_reg <= I_reg[12];
			case(I_reg[4])
			1'b0: rotate_R_reg <= I_reg[7:5];
			1'b1: rotate_R_reg <= 3'b000;
			endcase
			rotate_S0_reg <= I_reg[10:8];
			
			if(I_reg[12])
				mask_L_reg <= I_reg[7:5];
			else
				mask_L_reg <= 3'h0;
				
			alu_op_reg <= 3'h2;	//and
			alu_mux_reg <= 1'b0;
			alu_I_field_reg <= I_reg[7:0] & {{3{~I_reg[12]}}, 5'b11111};
			
			shift_L_reg <= I_reg[7:5];
			case(I_reg[3])
			1'b0: regf_w_reg <= I_reg[2:0];
			1'b1: regf_w_reg <= 3'h7;
			endcase
			if((I_reg[4:3] == 2'b00 && I_reg[2:0] != 3'h7) || (I_reg[4:3] == 2'b01 && I_reg[2:0] == 3'b001))
				regf_wren_reg <= 1'b1;
			else
				regf_wren_reg <= 1'b0;
			latch_address_r_reg <= I_reg[4:3];
			NZT <= 1'b0;
			XEC <= 1'b0;
			
			merge_D0_reg <= I_reg[2:0];
			WC_reg <= I_reg[4];
			if(I_reg[4] == 1'b0 && (I_reg[2:0] == 3'h7))
				SC_reg <= 1'b1;
			else
				SC_reg <= 1'b0;
			n_LB_w_reg <= I_reg[3];
			n_RB_w_reg <= ~I_reg[3];
			if((I_reg[4:3] != 2'b00) || (I_reg[2:0] == 3'h7))
				latch_wren_reg <= 1'b1;
			else
				latch_wren_reg <= 1'b0;
			latch_address_w_reg <= I_reg[4:3];
		end
		3'h3:	//xor
		begin
			case(I_reg[11])	//S1 field
			1'h0: regf_a_reg <= I_reg[10:8];
			1'h1: regf_a_reg <= 3'h7;
			endcase
			n_LB_r_reg <= I_reg[11];
			n_RB_r_reg <= ~I_reg[11];
			JMP <= 1'b0;
			
			case(I_reg[11])
			1'b0: rotate_mux_reg <= 1'b0;
			1'b1: rotate_mux_reg <= ~I_reg[8];
			endcase
			rotate_source_reg <= I_reg[12];
			case(I_reg[4])
			1'b0: rotate_R_reg <= I_reg[7:5];
			1'b1: rotate_R_reg <= 3'b000;
			endcase
			rotate_S0_reg <= I_reg[10:8];
			
			if(I_reg[12])
				mask_L_reg <= I_reg[7:5];
			else
				mask_L_reg <= 3'h0;
				
			alu_op_reg <= 3'h3;	//xor
			alu_mux_reg <= 1'b0;
			alu_I_field_reg <= I_reg[7:0] & {{3{~I_reg[12]}}, 5'b11111};
			
			shift_L_reg <= I_reg[7:5];
			case(I_reg[3])
			1'b0: regf_w_reg <= I_reg[2:0];
			1'b1: regf_w_reg <= 3'h7;
			endcase
			if((I_reg[4:3] == 2'b00 && I_reg[2:0] != 3'h7) || (I_reg[4:3] == 2'b01 && I_reg[2:0] == 3'b001))
				regf_wren_reg <= 1'b1;
			else
				regf_wren_reg <= 1'b0;
			latch_address_r_reg <= I_reg[4:3];
			NZT <= 1'b0;
			XEC <= 1'b0;
			
			merge_D0_reg <= I_reg[2:0];
			WC_reg <= I_reg[4];
			if(I_reg[4] == 1'b0 && (I_reg[2:0] == 3'h7))
				SC_reg <= 1'b1;
			else
				SC_reg <= 1'b0;
			n_LB_w_reg <= I_reg[3];
			n_RB_w_reg <= ~I_reg[3];
			if((I_reg[4:3] != 2'b00) || (I_reg[2:0] == 3'h7))
				latch_wren_reg <= 1'b1;
			else
				latch_wren_reg <= 1'b0;
			latch_address_w_reg <= I_reg[4:3];
		end
		3'h4:	//xec
		begin
			case(I_reg[11])	//S1 field
			1'h0: regf_a_reg <= I_reg[10:8];
			1'h1: regf_a_reg <= 3'h7;
			endcase
			n_LB_r_reg <= I_reg[11];
			n_RB_r_reg <= ~I_reg[11];
			JMP <= 1'b0;
			
			//case(I_reg[11])
			//1'b0: rotate_mux_reg <= 1'b0;
			//1'b1: rotate_mux_reg <= ~I_reg[8];
			//endcase
			rotate_mux_reg <= 1'b1;
			rotate_source_reg <= I_reg[12];
			rotate_R_reg <= 3'b000;
			rotate_S0_reg <= I_reg[10:8];
			
			if(I_reg[12])
				mask_L_reg <= I_reg[7:5];
			else
				mask_L_reg <= 3'h0;
			
			alu_op_reg <= 3'h5;
			alu_mux_reg <= 1'b1;
			alu_I_field_reg <= I_reg[7:0] & {{3{~I_reg[12]}}, 5'b11111};
			
			shift_L_reg <= I_reg[7:5];
			case(I_reg[3])
			1'b0: regf_w_reg <= I_reg[2:0];
			1'b1: regf_w_reg <= 3'h7;
			endcase
			regf_wren_reg <= 1'b0;
			latch_address_r_reg <= I_reg[4:3];
			NZT <= 1'b0;
			XEC <= 1'b1;
			
			merge_D0_reg <= I_reg[2:0];
			WC_reg <= 1'b0;
			SC_reg <= 1'b0;
			n_LB_w_reg <= I_reg[3];
			n_RB_w_reg <= ~I_reg[3];
			latch_wren_reg <= 1'b0;
			latch_address_w_reg <= I_reg[4:3];
		end
		3'h5:	//nzt
		begin
			case(I_reg[11])	//S1 field
			1'h0: regf_a_reg <= I_reg[10:8];
			1'h1: regf_a_reg <= 3'h7;
			endcase
			n_LB_r_reg <= I_reg[11];
			n_RB_r_reg <= ~I_reg[11];
			JMP <= 1'b0;
			
			case(I_reg[11])
			1'b0: rotate_mux_reg <= 1'b0;
			1'b1: rotate_mux_reg <= ~I_reg[8];
			endcase
			rotate_source_reg <= I_reg[12];
			rotate_R_reg <= 3'b000;
			rotate_S0_reg <= I_reg[10:8];
			
			if(I_reg[12])
				mask_L_reg <= I_reg[7:5];
			else
				mask_L_reg <= 3'h0;
			
			alu_op_reg <= 3'h4;
			alu_mux_reg <= 1'b1;
			alu_I_field_reg <= I_reg[7:0] & {{3{~I_reg[12]}}, 5'b11111};
			
			shift_L_reg <= I_reg[7:5];
			case(I_reg[3])
			1'b0: regf_w_reg <= I_reg[2:0];
			1'b1: regf_w_reg <= 3'h7;
			endcase
			regf_wren_reg <= 1'b0;
			latch_address_r_reg <= I_reg[4:3];
			NZT <= 1'b1;
			XEC <= 1'b0;
			
			merge_D0_reg <= I_reg[2:0];
			WC_reg <= 1'b0;
			SC_reg <= 1'b0;
			n_LB_w_reg <= I_reg[3];
			n_RB_w_reg <= ~I_reg[3];
			latch_wren_reg <= 1'b0;
			latch_address_w_reg <= I_reg[4:3];
		end
		3'h6:	//xmit
		begin
			case(I_reg[11])	//S1 field
			1'h0: regf_a_reg <= I_reg[10:8];
			1'h1: regf_a_reg <= 3'h7;
			endcase
			n_LB_r_reg <= I_reg[11];
			n_RB_r_reg <= ~I_reg[11];
			JMP <= 1'b0;
			
			//case(I_reg[11])
			//1'b0: rotate_mux_reg <= 1'b0;
			//1'b1: rotate_mux_reg <= ~I_reg[8];
			//endcase
			rotate_mux_reg <= 1'b1;
			rotate_source_reg <= I_reg[12];
			rotate_R_reg <= 3'b000;
			rotate_S0_reg <= I_reg[10:8];
			
			if(I_reg[12])
				mask_L_reg <= I_reg[7:5];
			else
				mask_L_reg <= 3'h0;
			
			alu_op_reg <= 3'h4;
			alu_mux_reg <= 1'b1;
			alu_I_field_reg <= I_reg[7:0] & {{3{~I_reg[12]}}, 5'b11111};
			
			shift_L_reg <= I_reg[7:5];
			case(I_reg[11])
			1'b0: regf_w_reg <= I_reg[10:8];
			1'b1: regf_w_reg <= 3'h7;
			endcase
			if((I_reg[12:11] == 2'b00 && I_reg[10:8] != 3'h7) || (I_reg[12:11] == 2'b01 && I_reg[10:8] == 3'b001))
				regf_wren_reg <= 1'b1;
			else
				regf_wren_reg <= 1'b0;
			latch_address_r_reg <= I_reg[12:11];
			NZT <= 1'b0;
			XEC <= 1'b0;
			
			merge_D0_reg <= I_reg[10:8];
			WC_reg <= I_reg[12];
			if(I_reg[12] == 1'b0 && (I_reg[10:8] == 3'h7))
				SC_reg <= 1'b1;
			else
				SC_reg <= 1'b0;
			n_LB_w_reg <= I_reg[11];
			n_RB_w_reg <= ~I_reg[11];
			if((I_reg[12:11] != 2'b00) || (I_reg[10:8] == 3'h7))
				latch_wren_reg <= 1'b1;
			else
				latch_wren_reg <= 1'b0;
			latch_address_w_reg <= I_reg[12:11];
		end
		3'h7:	//jmp
		begin
			case(I_reg[11])	//S1 field
			1'h0: regf_a_reg <= I_reg[10:8];
			1'h1: regf_a_reg <= 3'h7;
			endcase
			n_LB_r_reg <= I_reg[11];
			n_RB_r_reg <= ~I_reg[11];
			JMP <= 1'b1;
			
			//case(I_reg[11])
			//1'b0: rotate_mux_reg <= 1'b0;
			//1'b1: rotate_mux_reg <= ~I_reg[8];
			//endcase
			rotate_mux_reg <= 1'b1;
			rotate_source_reg <= I_reg[12];
			rotate_R_reg <= 3'b000;
			rotate_S0_reg <= I_reg[10:8];
			
			if(I_reg[12])
				mask_L_reg <= I_reg[7:5];
			else
				mask_L_reg <= 3'h0;
			
			alu_op_reg <= 3'h7;
			alu_mux_reg <= 1'b1;
			alu_I_field_reg <= I_reg[7:0] & {{3{~I_reg[12]}}, 5'b11111};
			
			shift_L_reg <= I_reg[7:5];
			case(I_reg[3])
			1'b0: regf_w_reg <= I_reg[2:0];
			1'b1: regf_w_reg <= 3'h7;
			endcase
			regf_wren_reg <= 1'b0;
			latch_address_r_reg <= I_reg[4:3];
			NZT <= 1'b0;
			XEC <= 1'b0;
			
			merge_D0_reg <= I_reg[2:0];
			WC_reg <= 1'b0;
			SC_reg <= 1'b0;
			n_LB_w_reg <= I_reg[3];
			n_RB_w_reg <= ~I_reg[3];
			latch_wren_reg <= 1'b0;
			latch_address_w_reg <= I_reg[4:3];
		end
		endcase
	end
end
assign SC = SC_reg;
assign WC = WC_reg;
assign n_LB_w = n_LB_w_reg;
assign n_RB_w = n_RB_w_reg;
assign n_LB_r = n_LB_r_reg;
assign n_RB_r = n_RB_r_reg;
assign rotate_S0 = rotate_S0_reg;
assign rotate_R = rotate_R_reg;
assign rotate_source = rotate_source_reg;
assign rotate_mux = rotate_mux_reg;
assign mask_L = mask_L_reg;
assign alu_op = alu_op_reg;
assign alu_mux = alu_mux_reg;
assign alu_I_field = alu_I_field_reg;
assign latch_wren = latch_wren_reg;
assign latch_address_w = latch_address_w_reg;
assign latch_address_r = latch_address_r_reg;
assign merge_D0 = merge_D0_reg;
assign shift_L = shift_L_reg;
assign regf_a = regf_a_reg;
assign regf_w = regf_w_reg;
assign regf_wren = regf_wren_reg;
assign PC_JMP = JMP;
assign PC_XEC = XEC;
assign PC_NZT = NZT;
assign PC_I_field = PC_I_field_reg;
endmodule

module PC(input wire clk, NZT, XEC, JMP, RST, ALU_NZ, hazard, long_I, input wire[7:0] ALU_data, input wire[12:0] PC_I_field, output wire[12:0] A);
reg[12:0] A_reg;
reg[12:0] PC_reg;
reg[12:0] A_next_I, A_pipe0, A_pipe1, A_pipe2, A_pipe3, A_pipe4;
always @(posedge clk)
begin
	if(~hazard)
		A_next_I <= A_reg;
	A_pipe0 <= A_next_I;
	A_pipe1 <= A_pipe0;
	A_pipe2 <= A_pipe1;
	A_pipe3 <= A_pipe2;
	A_pipe4 <= A_pipe3;
	if(RST)
	begin
		A_reg <= 13'h0;
		PC_reg <= 13'h0;
	end
	else
	begin
		if((NZT & ALU_NZ) | XEC)
		begin
			if(long_I)
				A_reg <= {A_pipe4[12:8], ALU_data};
			else
				A_reg <= {A_pipe4[12:5], ALU_data[4:0]};
			if(XEC)
				PC_reg <= A_pipe1;
			else if(long_I)
				PC_reg <= {A_pipe4[12:8], ALU_data};
			else
				PC_reg <= {A_pipe4[12:5], ALU_data[4:0]};
		end
		else if(JMP)
		begin
			A_reg <= PC_I_field;
			PC_reg <= PC_I_field;
		end
		else if(~hazard)
		begin
			A_reg <= PC_reg + 13'h1;
			PC_reg <= PC_reg + 13'h1;
		end
	end
end
assign A = A_reg;
endmodule

module hazard_unit(
		input wire clk,
		input wire NZT, NZT1, NZT2, NZT3, NZT4,
		input wire JMP,
		input wire XEC, XEC1, XEC2, XEC3, XEC4,
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
		output wire hazard,
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
wire branch_hazard = JMP & (NZT1 | NZT2 | NZT3 | XEC1 | XEC2 | XEC3);
assign aux_read = (alu_op != 3'b000) & (~alu_mux);
assign decoder_flush = (~branch_hazard) & ((NZT4 & ALU_NZ) | JMP | XEC4);
assign pipeline_flush = (NZT4 & ALU_NZ) | XEC4;
always @(posedge clk)
begin
	RST_hold <= decoder_flush;
end
assign decoder_RST = decoder_flush | RST_hold | RST;
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
assign regf_hazard = regf_hazard1 | regf_hazard2 | regf_hazard3 | regf_hazard4 | regf_hazard5;
assign IO_hazard = IO_hazard1 | IO_hazard2 | IO_hazard3 | IO_hazard4 | IO_hazard5 | IO_hazard6 | IO_hazard7;
assign hazard = decoder_flush | RST_hold | IO_hazard | regf_hazard | aux_hazard | branch_hazard | HALT;
endmodule

