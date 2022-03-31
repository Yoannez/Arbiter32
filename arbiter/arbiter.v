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
	output  [REQ_WIDTH-1:0] 	ready_out,
	output 	 					valid_out,
	output  [DW-1:0] 			data_out
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
	
	// Get the grant bit location 
	function integer graLocation;
		input [REQ_WIDTH-1:0] grant;
		integer i;
		begin
			graLocation = 0;
			for (i=0; i<REQ_WIDTH; i=i+1) begin
				if(grant[i]==1'b1)
					graLocation = i;
			end
		end
	endfunction

	assign ready_out = {REQ_WIDTH{ready_in}} & grant;
	assign valid_out = |valid_in;
	assign data_out = data_in[(graLocation(grant)+1)*DW-1 -: DW];
											
endmodule
