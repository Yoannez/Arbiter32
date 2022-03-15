module register
#(
	parameter WIDTH = 0,
	parameter RESET_VALUE = 0
)
(
	input				clk,
	input				enable,
	input 				rst,
	input 	[WIDTH-1:0]	data_in,
	output reg [WIDTH-1:0] data_out
);
	// Give the initial value to data_out 
	initial begin
		data_out = RESET_VALUE;
	end
	
	always@(posedge clk) begin
		if (enable == 1'b1) begin
			data_out <= data_in;
		end
		
		// the last assignment works
		if (rst == 1'b1) begin
			data_out <= RESET_VALUE; //can not use ternary operators here
		end
	end
endmodule