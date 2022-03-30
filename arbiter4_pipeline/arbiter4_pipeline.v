module arbiter4_pipeline
#(
	parameter DW = 8
)
(
	input clk,rst,
	input ready_in,
	input [3:0] valid_in,
	input [4*DW-1:0] data_in,
	output [3:0] ready_out,
	output valid_out,
	output [DW-1:0] data_out
);

	wire ready_inter, valid_inter;
	wire [DW-1:0] data_inter;
	
	arbiter #(.REQ_WIDTH(4), .DW(DW))
	base
	(
		.clk		(clk),
		.rst		(rst),
		.ready_in	(ready_inter),
		.valid_in	(valid_in),
		.data_in	(data_in),
		.ready_out	(ready_out),
		.valid_out	(valid_inter),
		.data_out	(data_inter)
	);
	
	pipeline_skid #(.DW(DW))
	top
	(
		.clk		(clk),
		.rst		(rst),
		.valid_in	(valid_inter),
		.ready_in	(ready_in),
		.data_in	(data_inter),
		.valid_out	(valid_out),
		.ready_out	(ready_inter),
		.data_out	(data_out)
	);
endmodule
	
	

