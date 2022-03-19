module pipeline_tb;

	reg clk,rst;
	reg valid_in;
	reg [7:0] data_in;
	reg ready_in;
	wire [7:0] data_out;
	wire valid_out;
	wire ready_out;
	
	pipeline_skid #(.DW(8))
	dut
	(	.clk		(clk),
		.rst		(rst),
		.valid_in	(valid_in),
		.data_in	(data_in),
		.ready_in	(ready_in),
		.valid_out	(valid_out),
		.ready_out	(ready_out),
		.data_out	(data_out)
	);
	
	initial begin: ClockGeneration
		clk = 1;
		forever #50 clk = ~clk;
	end
	
	initial begin
		rst = 1'b1;
		valid_in = 1'b0;
		ready_in = 1'b0;
		data_in = 8'h00;
		
		#100
		rst = 1'b0;
		valid_in = 1'b1;
		data_in = 8'h01;
		ready_in = 1'b1;
		
		#100
		data_in = 8'h02;
		
		#100
		valid_in = 1'b1;
		data_in = 8'h03;
		ready_in = 1'b0;
		
		#100
		data_in = 8'h04;
		
		#100
		ready_in = 1'b1;
		
		#100
		data_in = 8'h04;
		
		#100
		valid_in = 1'b0;
		data_in = 8'h00;
		ready_in = 1'b0;
		
		#200
		ready_in = 1'b1;
		
		#100
		ready_in = 1'b0;
		
		#100
		valid_in = 1'b1;
		data_in = 8'h05;
		
		#100
		data_in = 8'h06;
		
	end
	
endmodule
		
		