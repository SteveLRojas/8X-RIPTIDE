module IO_latch(input wire clk, latch_wren, input wire[1:0] latch_address_w, latch_address_r, input wire[7:0] merge_in, IO_in, output wire[7:0] merge_out);
reg[7:0] merge_out_reg;
reg[7:0] LBA_reg;
reg[7:0] RBA_reg;
reg[7:0] LBD_reg;
reg[7:0] RBD_reg;
always @(posedge clk)
begin
	if(latch_wren)
	begin
		case(latch_address_w)
		2'h0: LBA_reg <= merge_in;
		2'h1: RBA_reg <= merge_in;
		2'h2: LBD_reg <= merge_in;
		2'h3: RBD_reg <= merge_in;
		endcase
	end
	case(latch_address_r)
	2'h0: merge_out_reg <= LBA_reg;
	2'h1: merge_out_reg <= RBA_reg;
	2'h2: merge_out_reg <= LBD_reg;
	2'h3: merge_out_reg <= RBD_reg;
	endcase
end
assign merge_out = merge_out_reg;
endmodule
