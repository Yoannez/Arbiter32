module arbiter
#( 
	parameter REQ_WIDTH = 4,
	parameter DW		= 8
)
(	
	input 						clk,rst,
	input 						ready_in,
	input 	[REQ_WIDTH-1:0] 	valid_in,
	input 	[REQ_WIDTH*DW-1:0] 	data_in,
	output 	reg [REQ_WIDTH-1:0] ready_out,
	output 	reg 				valid_out,
	output 	reg [DW-1:0] 		data_out
);
	
	wire [REQ_WIDTH-1:0] grant;
	
	round_robin #(.REQ_WIDTH(REQ_WIDTH))
	dut(
		.clk		(clk),
		.rst		(rst),
		.ready_in	(ready_in),
		.req		(valid_in),
		.grant		(grant)
	);
	
	
	
	integer i;
	always @(*) begin
		ready_out = {REQ_WIDTH{ready_in}} & grant;
		valid_out = |valid_in;
		for (i=0;i<REQ_WIDTH;i=i+1) begin
			if(grant[i]==1'b1)
				data_out = data_in[i*DW +: DW];
		end
	end
				
							
endmodule
