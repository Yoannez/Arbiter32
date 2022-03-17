module arbiter4_tb;

reg clk;
reg ready_in;
reg [3:0] valid_in;
reg [31:0] data_in;
wire [3:0] ready_out;
wire [7:0] data_out;
wire valid_out;

arbiter4 #(.DW(8))
dut(
	.clk		(clk),
	.ready_in	(ready_in),
	.valid_in	(valid_in),
	.data_in	(data_in),
	.ready_out	(ready_out),
	.valid_out	(valid_out),
	.data_out	(data_out)
);
	

initial begin: ClockGeneration
	clk = 1;
	forever #50 clk = ~clk;
end


initial begin: signal
	ready_in = 1'b0;
	valid_in = 4'b1111;
	data_in  = 32'h87654321;
	
	#100
	ready_in = 1'b1;
	
	#400
	ready_in = 1'b0;
	
	#100
	ready_in = 1'b1;
		
	

end

endmodule
	
	