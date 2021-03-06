module PC(
		input wire clk,
		input wire NZT4,
		input wire XEC4,
		input wire JMP,
		input wire CALL4,
		input wire RET,
		input wire RST,
		input wire ALU_NZ,
		input wire hazard,
		input wire branch_hazard,
		input wire long_I,
		input wire[7:0] ALU_data,
		input wire[12:0] PC_I_field,
		output wire[15:0] A);
reg[15:0] A_reg;
reg prev_hazard;
reg[15:0] PC_reg;
reg[15:0] A_next_I, A_current_I, A_current_I_alternate, A_pipe0, A_pipe1, A_pipe2, A_pipe3, A_pipe4;
reg[7:0] PC_I_field1, PC_I_field2, PC_I_field3, PC_I_field4;
wire[15:0] stack_out;
wire stack_pop = RET & (~branch_hazard) & (~((NZT4 & ALU_NZ) | XEC4) & (~CALL4));
call_stack cstack0(.rst(RST), .clk(clk), .push(CALL4), .pop(stack_pop), .data_in(A_pipe3), .data_out(stack_out));
always @(posedge clk)
begin
	prev_hazard <= hazard;
	A_next_I <= A_reg;
	PC_I_field1 <= PC_I_field[7:0];
	PC_I_field2 <= PC_I_field1;
	PC_I_field3 <= PC_I_field2;
	PC_I_field4 <= PC_I_field3;
	if(RST)
	begin
		A_reg <= 13'h0;
		PC_reg <= 13'h0;
		A_current_I_alternate <= 16'h0000;
		A_current_I <= 16'h0000;
		A_pipe0 <= 16'h0000;
		A_pipe1 <= 16'h0000;
		A_pipe2 <= 16'h0000;
		A_pipe3 <= 16'h0000;
		A_pipe4 <= 16'h0000;
	end
	else
	begin
		if(hazard && ~prev_hazard)
			A_current_I_alternate <= A_next_I;
		if(~hazard)
		begin
			if(prev_hazard)
				A_current_I <= A_current_I_alternate;
			else
				A_current_I <= A_next_I;
			A_pipe0 <= A_current_I;
		end
		A_pipe1 <= A_pipe0;
		A_pipe2 <= A_pipe1;
		A_pipe3 <= A_pipe2;
		A_pipe4 <= A_pipe3;
		if(CALL4)
		begin
			A_reg <= {ALU_data, PC_I_field4};
			PC_reg <= {ALU_data, PC_I_field4};
		end
		else if((NZT4 & ALU_NZ) | XEC4)
		begin
			if(long_I)
				A_reg <= {A_pipe4[15:8], ALU_data};
			else
				A_reg <= {A_pipe4[15:5], ALU_data[4:0]};
			if(XEC4)
				PC_reg <= A_pipe4;
			else if(long_I)
				PC_reg <= {A_pipe4[15:8], ALU_data};
			else
				PC_reg <= {A_pipe4[15:5], ALU_data[4:0]};
		end
		else if(RET & (~branch_hazard))
		begin
			A_reg <= stack_out;
			PC_reg <= stack_out;
		end
		else if(JMP)
		begin
			A_reg <= {A_pipe0[15:13], PC_I_field};
			PC_reg <= {A_pipe0[15:13], PC_I_field};
		end
		else if(~hazard)
		begin
			A_reg <= PC_reg + 16'h01;
			PC_reg <= PC_reg + 16'h01;
		end
	end
end
assign A = A_reg;
endmodule
