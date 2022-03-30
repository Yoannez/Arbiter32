module round_robin_tb;

	reg clk, rst;
	reg ready_in;
	reg [3:0] req;
	wire [3:0] grant;
	
	round_robin #(.REQ_WIDTH(4))
	dut(
		.clk		(clk),
		.ready_in	(ready_in),
		.rst		(rst),
		.req		(req),
		.grant		(grant)
	);
	
	initial begin: ClockGeneration
		clk = 1;
		forever #50 clk = ~clk;
	end
	
	initial begin
		rst = 1'b1;
		ready_in = 1'b1;
		req = 4'b1111;
		
		#100
		rst = 1'b0;
		req = 4'b0001;
		
		#100
		req = 4'b0111;
		
		// #200
		// req = 4'b0011;
		
		// #100
		// req = 4'b1011;
		
		// #100
		// req = 4'b1001;
		
		// #400
		// ready_in = 1'b0;
		
		// #200
		// ready_in = 1'b1;
	end
endmodule
		