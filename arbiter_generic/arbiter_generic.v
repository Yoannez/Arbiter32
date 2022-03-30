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
	
	// These signals include all the signals in the module, including input and output signal
	wire [WIDTH-1:0] valid;
	wire [WIDTH-1:0] ready;
	wire [DW*WIDTH-1:0] data;

	generate
		genvar i,j;
		integer us_bit = 0;
		integer ds_bit = 0;
		
		for (j=bus_num; j>0; j=j/4) begin	// Control the number of arbiter for each level
			always @(*) begin
				us_bit = ds_bit;			// The bit point of upstream
				ds_bit = us_bit + j;		// The bit point of downstream
			end
			
			for (i=0; i<j/4; i=i+1) begin	// Generate arbiter according to j
				arbiter4_pipeline #(.DW(DW))
				arbiter_tree
				(
					.clk		(clk),
					.rst		(rst),
					.valid_in	(valid[us_bit+4*(i+1)-1 -: 4]),
					.data_in	(data[DW*(us_bit+4*(i+1))-1 -: 4*DW]),
					.ready_out	(ready[us_bit+4*(i+1)-1 -: 4]),
					.valid_out	(valid[ds_bit+i]),
					.data_out	(data[DW*(ds_bit+(i+1))-1 -: DW]),
					.ready_in	(ready[ds_bit+i])
				);
			end
		end

	endgenerate
	
	
	assign ready[WIDTH-1] = ready_in;
	assign valid[bus_num-1:0] = valid_in;
	assign data[bus_num*DW-1:0] = data_in;
	assign ready_out = ready[bus_num-1:0];
	assign valid_out = valid[WIDTH-1];
	assign data_out = data[DW*WIDTH-1:DW*(WIDTH-1)];
	
endmodule
				