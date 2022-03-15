module arbiter4_pipeline_tb;

	parameter WIDTH = 4;

	reg clk,rst;
	reg [3:0] valid_in;
	reg [4*WIDTH-1:0] data_in;
	wire [3:0] ready_out;
	wire valid_out;
	wire [WIDTH-1:0] data_out;
	reg ready_in;

	arbiter4_pipeline #(.WIDTH(WIDTH))
	dut
	(	
		.clk		(clk),
		.rst		(rst),
		.valid_in	(valid_in),
		.data_in	(data_in),
		.ready_out	(ready_out),
		.valid_out	(valid_out),
		.data_out	(data_out),
		.ready_in	(ready_in)
	);
	
	
	initial begin: ClockGeneration
		clk = 1;
		forever #50 clk = ~clk; //ClockPeriod == 100
	end
	
	initial begin
		rst = 1'b1;
		ready_in = 1'b1;
		valid_in = 4'b1111;
		data_in	 = 16'h4321;
		#100
		rst = 1'b0;
		#1000
		ready_in = 1'b0;
		
	end
endmodule

