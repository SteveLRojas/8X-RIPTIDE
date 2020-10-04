module ROM_high(input wire [12:0] address, input wire clk, output wire [7:0] data);
reg [7:0] oreg;
reg [7:0] mem [8191:0];
initial
begin
	$readmemh("hrom.txt", mem);
end
always @(posedge clk)
begin
	oreg <= mem[address];
end
assign data = oreg;
endmodule

module ROM_low(input wire [12:0] address, input wire clk, output wire [7:0] data);
reg [7:0] oreg;
reg [7:0] mem [8191:0];
initial
begin
	$readmemh("lrom.txt", mem);
end
always @(posedge clk)
begin
	oreg <= mem[address];
end
assign data = oreg;
endmodule
