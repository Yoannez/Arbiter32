module arbiter_generic_tb;
	reg clk,rst;
	reg ready_in;
	reg [63:0] valid_in;
	reg [64*8-1:0] data_in;
	wire [63:0] ready_out;
	wire valid_out;
	wire [7:0] data_out;
	reg [7:0] value = 8'h00;
	integer i;

	arbiter_generic #(.bus_num(64), .DW(8))
	dut(
			.clk      	(clk),
			.rst      	(rst),
			.ready_in	(ready_in),
			.valid_in 	(valid_in),
			.data_in  	(data_in),
			.data_out 	(data_out),
			.valid_out	(valid_out),
			.ready_out  (ready_out)
	);


	initial begin: ClockGeneration
		clk = 1;
		forever #50 clk = ~clk;
	end
	

	initial begin: signalGen
		rst = 1'b1;
		ready_in = 1'b0;
		valid_in = {64{1'b0}};
		data_in = {512{1'b0}};
		
		#100
		rst = 1'b0;
		ready_in = 1'b1;
		valid_in = {64{1'b1}};
		for (i=0; i<64; i=i+1) begin
			data_in[8*i+7 -: 8] = value;
			value = value + 8'h01;
		end
	end
endmodule