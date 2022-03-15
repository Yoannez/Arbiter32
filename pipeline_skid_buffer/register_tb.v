module register_tb;

	reg clk,enable,rst;
	reg	[3:0] data_in;
	wire [3:0] data_out;
	reg ok;

	register #(.WIDTH(4), .RESET_VALUE(0))
	dut
	(
		.clk		(clk),
		.rst		(rst),
		.enable		(enable),
		.data_in	(data_in),
		.data_out	(data_out)
	);

	initial begin: ClockGeneration
		clk = 1'b1;
		forever #50 clk = ~clk;
	end
	
	initial begin
		ok = 1'b1;
		rst = 1'b1;
		enable = 1'b0;
		
		#100
		rst = 1'b0;
		data_in = 4'b0000;
		enable = 1'b1;
		while (data_in != 4'b1111) begin
			#100
			if (data_out != data_in) begin
				ok = 1'b0;
			end
			data_in = data_in + 1'b1;
		end
		
		#100
		rst = 1'b1;
	end
endmodule
			
