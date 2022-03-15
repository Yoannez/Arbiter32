module arbiter4_pipeline
	#(
		parameter WIDTH = 0
	)
	(
		input clk, rst,
		input [3:0] valid_in,
		input [4*WIDTH-1:0] data_in,
		output [3:0] ready_out,
		output valid_out,
		output [WIDTH-1:0] data_out,
		input ready_in
	);
	
	/*Instance 4 pipelines as base*/
	wire [3:0] valid_out_base;
	reg [3:0]ready_in_base;
	wire [4*WIDTH-1:0] data_out_base;
	genvar i;
	
	generate
		//Generation 4 pieplines
		for (i=0; i<4; i=i+1) begin
			pipeline_skid_buffer #(.WIDTH(WIDTH))
			pipelines_base
			(	
				.clk		(clk),
				.rst		(rst),
				.valid_in	(valid_in[i]),
				.data_in	(data_in[(i+1)*WIDTH-1:i*WIDTH]),
				.ready_out	(ready_out[i]),
				.valid_out	(valid_out_base[i]),
				.data_out	(data_out_base[(i+1)*WIDTH-1:i*WIDTH]),
				.ready_in	(ready_in_base[i])
			);
		end
		
	endgenerate
	
	/*Instance Arbiter4*/
	wire [3:0] req;
	wire [3:0] grant;
	assign req = valid_out_base;
	arbiter4 arbiter_inter
	(
		.clk	(clk),
		.rst	(rst), 
		.req	(req),
		.grant	(grant)
	);
	
	
	/*Instance top pipeline*/
	reg valid_in_top;
	reg [WIDTH-1:0] data_in_top;
	wire ready_out_top;
	pipeline_skid_buffer #(.WIDTH(WIDTH))
	pipeline_top
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
	
	always @(*) begin
		case(grant)
			4'b0001: begin
						valid_in_top  = valid_out_base[0];
						data_in_top   = data_out_base[WIDTH-1:0];
						ready_in_base[0] = ready_out_top;
					end
			4'b0010: begin
						valid_in_top  = valid_out_base[1];
						data_in_top   = data_out_base[2*WIDTH-1:WIDTH];
						ready_in_base[1] = ready_out_top;
					end
			4'b0100: begin
						valid_in_top  = valid_out_base[2];
						data_in_top   = data_out_base[3*WIDTH-1:2*WIDTH];
						ready_in_base[2] = ready_out_top;
					end
			4'b1000: begin
						valid_in_top  = valid_out_base[3];
						data_in_top   = data_out_base[4*WIDTH-1:3*WIDTH];
						ready_in_base[3] = ready_out_top;
					end
			default: begin
						valid_in_top  = 1'b0;
						data_in_top   = {WIDTH{1'b0}};
						ready_in_base = 4'b0000;
					end
		endcase
	end

endmodule				
		