module arbiter4_tb;

reg clk,rst;
reg [3:0] req;
wire [3:0] grant;

arbiter4 dut(
	.clk	(clk),
	.rst	(rst),
	.req	(req),
	.grant	(grant)
);
	

initial begin: ClockGeneration
	clk = 0;
	forever #50 clk = ~clk;
end


initial begin: signal
	rst = 0;
	req = 4'b0000;
	#100
	
	rst = 1;
	#100
	
	rst = 0;
	
	while(req != 4'b1111)
		#100 req = req + 1'b1;
		
	

end

endmodule
	
	