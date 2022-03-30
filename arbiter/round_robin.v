module round_robin
#(
	parameter REQ_WIDTH = 4
)
(
	input 					clk,
	input 					rst,
	input 					ready_in,
	input 	[REQ_WIDTH-1:0] req,
	output 	[REQ_WIDTH-1:0] grant
);

	wire [REQ_WIDTH-1:0] req_masked;
	wire [REQ_WIDTH-1:0] mask_pre_req;
	wire [REQ_WIDTH-1:0] mask_grant;
	wire [REQ_WIDTH-1:0] unmask_pre_req;
	wire [REQ_WIDTH-1:0] unmask_grant;
	reg  [REQ_WIDTH-1:0] pre_req;
	wire flag;
	
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
	assign flag  = ~(|req_masked);
	assign grant = ({REQ_WIDTH{flag}} & unmask_grant) | mask_grant;
	
	//Update pre_req
	always @(posedge clk) begin
		if (rst) 
			pre_req <= {REQ_WIDTH{1'b1}};
		else if (!ready_in || !(|req))
			pre_req <= pre_req;
		else begin
			if (|req_masked) //Use mask_grant
				pre_req <= mask_pre_req;
			else
				pre_req <= unmask_pre_req;
		end
	end
	
endmodule