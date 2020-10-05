module N8XRIPTIDE(
		input wire clk,
		input wire n_halt,
		input wire n_reset,
		input wire[15:0] I,
		output wire[15:0] A,
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
reg[7:0] IV_in;
reg SC1, SC2, SC3, SC4, SC5, SC6, SC7;
reg WC1, WC2, WC3, WC4, WC5, WC6, WC7;
reg n_LB_w1, n_LB_w2, n_LB_w3, n_LB_w4, n_LB_w5, n_LB_w6, n_LB_w7;
reg n_RB_w1, n_RB_w2, n_RB_w3, n_RB_w4, n_RB_w5, n_RB_w6;
reg n_LB_r1, n_LB_r2, n_LB_r3, n_LB_r4, n_LB_r5, n_LB_r6;
reg n_RB_r1, n_RB_r2, n_RB_r3, n_RB_r4, n_RB_r5, n_RB_r6;
reg latch_wren1, latch_wren2, latch_wren3, latch_wren4, latch_wren5, latch_wren6;
reg[1:0] latch_address_w1, latch_address_w2, latch_address_w3, latch_address_w4, latch_address_w5, latch_address_w6;
reg[1:0] latch_address_r1, latch_address_r2, latch_address_r3, latch_address_r4;
wire[7:0] latch_merge_in, latch_merge_out;
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
reg CALL1, CALL2, CALL3, CALL4;
wire NZT;
wire XEC;
wire JMP;
wire RET;
wire CALL;
wire long_I;
reg long_I1, long_I2, long_I3, long_I4;
wire[12:0] PC_I_field;
reg[2:0] merge_D01, merge_D02, merge_D03, merge_D04, merge_D05;
reg[2:0] shift_L1, shift_L2, shift_L3, shift_L4;
wire hazard;
wire branch_hazard;
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
	IV_in <= ~n_IV_in;
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
		//regf_w1 <= 3'h0;
		//regf_w2 <= 3'h0;
		//regf_w3 <= 3'h0;
		//regf_w4 <= 3'h0;
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
		CALL1 <= 1'b0;
		CALL2 <= 1'b0;
		CALL3 <= 1'b0;
		CALL4 <= 1'b0;
	end
	else
	begin	//not reset
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
		//regf_w1 <= 3'h0;
		//regf_w2 <= 3'h0;
		//regf_w3 <= 3'h0;
		//regf_w4 <= 3'h0;
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
		CALL1 <= 1'b0;
		CALL2 <= 1'b0;
		CALL3 <= 1'b0;
		CALL4 <= 1'b0;
		end
		else
		begin	//not flush
			if(hazard)
			begin
				SC1 <= 1'b0;
				WC1 <= 1'b0;
				n_LB_w1 <= 1'b0;
				n_RB_w1 <= 1'b1;
				n_LB_r1 <= 1'b0;
				n_RB_r1 <= 1'b1;
				latch_wren1 <= 1'b0;
				//regf_w1 <= 3'h0;
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
				CALL1 <= 1'b0;
			end
			else
			begin	//not hazard
				SC1 <= SC;
				WC1 <= WC;
				n_LB_w1 <= n_LB_w;
				n_RB_w1 <= n_RB_w;
				n_LB_r1 <= n_LB_r;
				n_RB_r1 <= n_RB_r;
				latch_wren1 <= latch_wren;
				//regf_w1 <= regf_w;
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
				CALL1 <= CALL;
			end	//not flush
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
			//regf_w2 <= regf_w1;
			//regf_w3 <= regf_w2;
			//regf_w4 <= regf_w3;
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
			CALL2 <= CALL1;
			CALL3 <= CALL2;
			CALL4 <= CALL3;
		end
	end	//always
	long_I1 <= long_I;
	long_I2 <= long_I1;
	long_I3 <= long_I2;
	long_I4 <= long_I3;
	latch_address_w1 <= latch_address_w;
	latch_address_r1 <= latch_address_r;
	latch_address_w2 <= latch_address_w1;
	latch_address_w3 <= latch_address_w2;
	latch_address_w4 <= latch_address_w3;
	latch_address_r2 <= latch_address_r1;
	latch_address_r3 <= latch_address_r2;
	latch_address_r4 <= latch_address_r3;
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
	regf_w1 <= regf_w;
	regf_w2 <= regf_w1;
	regf_w3 <= regf_w2;
	regf_w4 <= regf_w3;
	regf_w5 <= regf_w4;
	regf_wren5 <= regf_wren4;
	merge_D05 <= merge_D04;
end
// IO module
assign n_IV_out = ~latch_merge_in;
IO_latch IO_latch0(
		.clk(clk),
		.latch_wren(latch_wren6),
		.latch_address_w(latch_address_w6),
		.latch_address_r(latch_address_r4),
		.merge_in(latch_merge_in),
		.IO_in(~n_IV_in),
		.merge_out(latch_merge_out));
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
		.IO_in(IV_in),
		.rotate_out(rotate_out),
		.S0(rotate_S01),
		.R(rotate_R1),
		.source(rotate_source1));
//mask module
mask_unit mask0(.clk(clk), .mask_in(rotate_out), .L_select(mask_L2), .mask_out(mask_out));
//ALU
assign amux_out = alu_mux3 ? alu_I_field3 : b_data;
ALU ALU0(
		.clk(clk),
		.flush(pipeline_flush),
		.op(alu_op3),
		.in_a(mask_out),
		.in_b(amux_out),
		.alu_out(alu_out),
		.OVF_out(OVF),
		.NZ_out(NZ));
//shift and merge module
shift_merge shift_merge0(.clk(clk), .shift_in(alu_out), .merge_in(latch_merge_out), .merge_out(latch_merge_in), .D0(merge_D05), .L_select(shift_L4));
//PC
PC PC0(
		.clk(clk),
		.NZT4(NZT4),
		.XEC4(XEC4),
		.JMP(JMP),
		.CALL4(CALL4),
		.RET(RET),
		.RST(RST),
		.ALU_NZ(NZ),
		.hazard(hazard),
		.branch_hazard(branch_hazard),
		.long_I(long_I4),
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
		.PC_CALL(CALL),
		.PC_RET(RET),
		.PC_I_field(PC_I_field),
		.long_I(long_I));
//hazard unit
hazard_unit hazard_unit0(
		.clk(clk),
		.NZT1(NZT1), .NZT2(NZT2), .NZT3(NZT3), .NZT4(NZT4),
		.JMP(JMP),
		.XEC1(XEC1), .XEC2(XEC2), .XEC3(XEC3), .XEC4(XEC4),
		.RET(RET),
		.CALL4(CALL4),
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
		.latch_wren(latch_wren), .latch_wren1(latch_wren1), .latch_wren2(latch_wren2),
		.latch_address_w1(latch_address_w1), .latch_address_w2(latch_address_w2),
		.latch_address_r(latch_address_r),
		.shift_L(shift_L),
		.hazard(hazard),
		.branch_hazard(branch_hazard),
		.pipeline_flush(pipeline_flush),
		.decoder_RST(decoder_RST));
endmodule
