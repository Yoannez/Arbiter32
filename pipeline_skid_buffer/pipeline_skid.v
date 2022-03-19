module pipeline_skid
#(
	parameter DW = 8
)
(
	input clk,rst,
	input valid_in,
	input ready_in,
	input [DW-1:0] data_in,
	output reg valid_out,
	output reg ready_out,
	output reg [DW-1:0] data_out
);

	reg valid_reg, valid_skid;
	reg ready_reg;
	reg [DW-1:0] data_reg, data_skid;
	
	always @(posedge clk) begin
		if (rst==1'b1) begin
			valid_reg <= 1'b0;
			valid_skid <= 1'b0;
			ready_reg <= 1'b0;
			data_reg <= {DW{1'b0}};
			data_skid <= {DW{1'b0}};
			valid_out <= 1'b0;
			data_out <= {DW{1'b0}};
			ready_out <= 1'b0;
		end
		else begin
		
			ready_out = ~valid_skid;

			if (ready_out==1'b1) begin
				valid_reg <= valid_in;
				data_reg <= data_in;
				if (ready_in==1'b0) begin
					valid_skid <= valid_reg;
					data_skid <= data_reg;
				end
			end
			
			if (ready_in==1'b1) begin
				valid_skid <= 1'b0;
			end
			
			valid_out <= valid_reg || valid_skid;
			data_out <= (valid_skid==1'b1) ? data_skid : data_reg;
			
		end
	end
endmodule