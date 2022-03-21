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
	output 	reg [REQ_WIDTH-1:0] 	ready_out,
	output 	reg 					valid_out,
	output 	reg [DW-1:0] 			data_out
);
	wire [REQ_WIDTH-1:0] req;
	wire [REQ_WIDTH-1:0] grant;
	wire [REQ_WIDTH-1:0] req_masked;
	wire [REQ_WIDTH-1:0] mask_pre_req;
	wire [REQ_WIDTH-1:0] mask_grant;
	wire [REQ_WIDTH-1:0] unmask_pre_req;
	wire [REQ_WIDTH-1:0] unmask_grant;
	reg  [REQ_WIDTH-1:0] pre_req;
	wire flag;
	
	
	integer i;
	always @(*) begin
		ready_out = {REQ_WIDTH{ready_in}} & grant;
		valid_out = |valid_in;
		for (i=0;i<REQ_WIDTH;i=i+1) begin
			if(grant[i]==1'b1)
				data_out = data_in[i*DW +: DW];
		end
	end
				
				
				
	assign req = valid_in;
	
	
	//Fixed arbiter with input request masked
	assign req_masked = req & pre_req;
	assign mask_pre_req[0] = 1'b0;
	assign mask_pre_req[REQ_WIDTH-1:1] = req_masked[REQ_WIDTH-2:0] | mask_pre_req[REQ_WIDTH-2:0];
	assign mask_grant = req_masked & ~mask_pre_req;
	
	
	
	//Fixed arbiter with input req unmasked
	assign unmask_pre_req[0] = 1'b0;
	assign unmask_pre_req[REQ_WIDTH-1:1] = req[REQ_WIDTH-2:0] | unmask_pre_req[REQ_WIDTH-2:0];
	assign unmask_grant = req & ~unmask_pre_req;
	
	
	
	//Use mask_grant if mask_grant != 0, otherwise use unmask_grant.
	// if req_masked == 0, flag = 1, otherwise flag = 0
	assign flag = ~(|req_masked);
	assign grant = ({REQ_WIDTH{flag}} & unmask_grant) | mask_grant;
	
	
	
	//Update pre_req
	always @(posedge clk) begin
		if (rst) begin
			pre_req <= {REQ_WIDTH{1'b1}};
		end
		else begin
			if (|req_masked) begin //Use mask_grant
				pre_req <= mask_pre_req;
			end
			else begin
				if (|req) begin
					pre_req <= unmask_pre_req;
				end
				else begin
					pre_req <= pre_req;
				end
			end
		end
	end
	
endmodule
