module arbiter_generic
#(
	parameter bus_num = 32,
	parameter DW	  = 8
)
(	input clk,rst,
	input ready_in,
	input [bus_num-1:0] valid_in,
	input [bus_num*DW-1:0] data_in,
	output [bus_num-1:0] ready_out,
	output [DW-1:0] data_out,
	output valid_out
);
	
	localparam WIDTH = getWidth(bus_num);
	localparam ARBITER_NUM = getArbiterNum(bus_num);

	// These signals include all the signals in the module, including input and output signal
	wire [WIDTH-1:0] valid;
	wire [WIDTH-1:0] ready;
	wire [DW*WIDTH-1:0] data;

	generate
		genvar i;
		for (i=0; i<ARBITER_NUM; i=i+1) begin
			arbiter4_pipeline #(.DW(DW))
			arbiter_tree
			(
				.clk		(clk),
				.rst		(rst),
				.valid_in	(valid[4*(i+1)-1 -: 4]),
				.data_in	(data[DW*4*(i+1)-1 -: 4*DW]),
				.ready_out	(ready[4*(i+1)-1 -: 4]),
				.valid_out	(valid[WIDTH-ARBITER_NUM+i]),
				.data_out	(data[DW*(WIDTH-ARBITER_NUM+i+1)-1 -: DW]),
				.ready_in	(ready[WIDTH-ARBITER_NUM+i])
			);
		end
	endgenerate
	
	assign ready[WIDTH-1] = ready_in;
	assign valid[bus_num-1:0] = valid_in;
	assign data[bus_num*DW-1:0] = data_in;
	assign ready_out = ready[bus_num-1:0];
	assign valid_out = valid[WIDTH-1];
	assign data_out = data[DW*WIDTH-1:DW*(WIDTH-1)];


	// Calculate the width of signal valid, ready, data according to bus_num
	function integer getWidth;
		input integer bus_num;
		integer k;
		begin
			getWidth = 0;
			for (k=bus_num; k>0; k=k/4) begin
				getWidth = getWidth + k;
			end
		end
	endfunction

	// Calculate the number of arbiter
	function integer getArbiterNum;
		input integer bus_num;
		integer k;
		begin
			getArbiterNum = 0;
			for (k=bus_num/4; k>0; k=k/4) begin
				getArbiterNum = getArbiterNum + k;
			end
		end
	endfunction

endmodule
				