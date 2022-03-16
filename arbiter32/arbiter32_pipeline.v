module arbiter32_pipeline
	#(
		parameter WIDTH = 0
	)
	(
		input clk, rst,
		input [31:0] valid_in,
		input [32*WIDTH-1:0] data_in,
		output [31:0] ready_out,
		output valid_out,
		output [WIDTH-1:0] data_out,
		input ready_in
	);
	
	/*Instance 8 arbiter4_pipelines as base*/
	wire [7:0] valid_out_base;
	wire [7:0]ready_in_base;
	wire [8*WIDTH-1:0] data_out_base;
	genvar i;
	
	generate
		//Generation 8 pieplines
		for (i=0; i<8; i=i+1) begin
			arbiter4_pipeline #(.WIDTH(WIDTH))
			arbiter4_base
			(	
				.clk		(clk),
				.rst		(rst),
				.valid_in	(valid_in[(i+1)*4-1:i*4]),
				.data_in	(data_in[(i+1)*4*WIDTH-1:i*4*WIDTH]),
				.ready_out	(ready_out[(i+1)*4-1:i*4]),
				.valid_out	(valid_out_base[i]),
				.data_out	(data_out_base[(i+1)*WIDTH-1:i*WIDTH]),
				.ready_in	(ready_in_base[i])
			);
		end
		
	endgenerate
	
	/*Instance 2 arbiter4_pipelines as inter*/
	wire [1:0] valid_out_inter;
	wire [1:0]ready_in_inter;
	wire [2*WIDTH-1:0] data_out_inter;
	
	generate
		//Generation 2 pieplines
		for (i=0; i<2; i=i+1) begin
			arbiter4_pipeline #(.WIDTH(WIDTH))
			arbiter4_inter
			(	
				.clk		(clk),
				.rst		(rst),
				.valid_in	(valid_out_base[(i+1)*4-1:i*4]),
				.data_in	(data_out_base[(i+1)*4*WIDTH-1:i*4*WIDTH]),
				.ready_out	(ready_in_base[(i+1)*4-1:i*4]),
				.valid_out	(valid_out_inter[i]),
				.data_out	(data_out_inter[(i+1)*WIDTH-1:i*WIDTH]),
				.ready_in	(ready_in_inter[i])
			);
		end
		
	endgenerate
	
	/*Instance 1 arbiter4_pipelines as top*/
	wire valid_in_top = {valid_out_inter,2'b00};
	wire data_in_top = {data_out_inter,{2*WIDTH{1'b0}}};
	wire [3:0] ready_out_top;
	assign ready_in_inter = ready_out_top[3:2];
	arbiter4_pipeline #(.WIDTH(WIDTH))
	arbiter4_top
	(	
		.clk		(clk),
		.rst		(rst),
		.valid_in	(valid_in_top),
		.data_in	(data_in_top),
		.ready_out	(ready_out_top),
		.valid_out	(valid_out),
		.data_out	(data_out),
		.ready_in	(ready_in)
	);
endmodule