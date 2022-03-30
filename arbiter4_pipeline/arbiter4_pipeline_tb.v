module arbiter4_pipeline_tb;

	reg clk,rst;
	reg ready_in;
	reg [3:0] valid_in;
	reg [31:0] data_in;
	wire [3:0] ready_out;
	wire valid_out;
	wire [7:0] data_out;
	reg ok;
	
	arbiter4_pipeline #(.DW(8))
	dut
	(
		.clk		(clk),
		.rst		(rst),
		.ready_in 	(ready_in),
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
	
	initial begin
		rst = 1'b1;
		ready_in = 1'b0;
		valid_in = 4'b0000;
		data_in = 32'h00000000;
		
		#100
		rst = 1'b0;
		ready_in = 1'b1;
		valid_in = 4'b0001;
		data_in = 32'h00000001;
		
		#100
		valid_in = 4'b0111;
		data_in = 32'h00211102;
		
		#100
		valid_in = 4'b0111;
		data_in = 32'h00211202;
		
		#100
		valid_in = 4'b0011;
		data_in = 32'h00001202;
		
		#100
		valid_in = 4'b1011;
		data_in = 32'h31001203;
		
		#100
		valid_in = 4'b1001;
		data_in = 32'h31000003;
		
		
	end
	
	initial begin
		ok = 1'b1;
		
		#200
		ok = (data_out==8'h01) ? 1'b1 : 1'b0;
		
		#100
		ok = (data_out==8'h11) ? 1'b1 : 1'b0;
		
		#100
		ok = (data_out==8'h21) ? 1'b1 : 1'b0;
		
		#100
		ok = (data_out==8'h02) ? 1'b1 : 1'b0;
		
		#100
		ok = (data_out==8'h12) ? 1'b1 : 1'b0;
		
		#100
		ok = (data_out==8'h31) ? 1'b1 : 1'b0;
	
	end
endmodule