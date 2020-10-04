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
	3'b000: merge_reg <= {shift_reg[0], 7'h00} | (merge_in & {merge_mask[0], merge_mask[7:1]});
	3'b001: merge_reg <= {shift_reg[1:0], 6'h00} | (merge_in & {merge_mask[1:0], merge_mask[7:2]});
	3'b010: merge_reg <= {shift_reg[2:0], 5'h00} | (merge_in & {merge_mask[2:0], merge_mask[7:3]});
	3'b011: merge_reg <= {shift_reg[3:0], 4'h0} | (merge_in & {merge_mask[3:0], merge_mask[7:4]});
	3'b100: merge_reg <= {shift_reg[4:0], 3'h0} | (merge_in & {merge_mask[4:0], merge_mask[7:5]});
	3'b101: merge_reg <= {shift_reg[5:0], 2'b00} | (merge_in & {merge_mask[5:0], merge_mask[7:6]});
	3'b110: merge_reg <= {shift_reg[6:0], 1'b0} | (merge_in & {merge_mask[6:0], merge_mask[7]});
	3'b111: merge_reg <= shift_reg | (merge_in & merge_mask);
	endcase
end
assign merge_out = merge_reg;
endmodule