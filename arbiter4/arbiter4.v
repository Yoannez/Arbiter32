module arbiter4
	#(
		parameter DW = 4
	)
	(
		input clk,
		input ready_in,
		input [3:0] valid_in,
		input [4*DW-1:0] data_in,
		output reg [3:0] ready_out,
		output valid_out,
		output reg [DW-1:0] data_out
	);
	
	
assign valid_out = (valid_in==4'b0000) ? 1'b0 : 1'b1;
	
always@(posedge clk) begin
	if(ready_in == 1'b0) begin
		ready_out <= 4'b0000;
		data_out  <= data_in[DW-1:0];
	end
	else begin
		case(ready_out)
			4'b0000: casez(valid_in)
						4'b0000: begin
									ready_out <= 4'b0000;
									data_out  <= data_in[DW-1:0];
								 end
						4'b???1: begin
									ready_out <= 4'b0001;
									data_out  <= data_in[DW-1:0];
								 end
						4'b??10: begin
									ready_out <= 4'b0010;
									data_out  <= data_in[2*DW-1:DW];
								 end
						4'b?100: begin
									ready_out <= 4'b0100;
									data_out  <= data_in[3*DW-1:2*DW];
								 end
						4'b1000: begin
									ready_out <= 4'b1000;
									data_out  <= data_in[4*DW-1:3*DW];
								 end
						default: begin
									ready_out <= 4'b0000;
									data_out  <= data_in[DW-1:0];
								 end
					endcase
			//ready_out <= valid_in & ~(valid_in-1'b1); //找出valid_in第一个1的位置
			4'b0001: casez(valid_in)
						4'b0000: begin
									ready_out <= 4'b0000;
									data_out  <= data_in[DW-1:0];
								 end
						4'b0001: begin
									ready_out <= 4'b0001;
									data_out  <= data_in[DW-1:0];
								 end
						4'b??1?: begin
									ready_out <= 4'b0010;
									data_out  <= data_in[2*DW-1:DW];
								 end
						4'b?10?: begin
									ready_out <= 4'b0100;
									data_out  <= data_in[3*DW-1:2*DW];
								 end
						4'b100?: begin
									ready_out <= 4'b1000;
									data_out  <= data_in[4*DW-1:3*DW];
								 end
						default: begin
									ready_out <= 4'b0000;
									data_out  <= data_in[DW-1:0];
								 end
					endcase
			4'b0010: casez(valid_in)
						4'b0000: begin
									ready_out <= 4'b0000;
									data_out  <= data_in[DW-1:0];
								 end
						4'b0010: begin
									ready_out <= 4'b0010;
									data_out  <= data_in[2*DW-1:DW];
								 end
						4'b?1??: begin
									ready_out <= 4'b0100;
									data_out  <= data_in[3*DW-1:2*DW];
								 end
						4'b10??: begin
									ready_out <= 4'b1000;
									data_out  <= data_in[4*DW-1:3*DW];
								 end
						4'b00?1: begin
									ready_out <= 4'b0001;
									data_out  <= data_in[DW-1:0];
								 end
						default: begin
									ready_out <= 4'b0000;
									data_out  <= data_in[DW-1:0];
								 end
					endcase
			4'b0100: casez(valid_in)
						4'b0000: begin
									ready_out <= 4'b0000;
									data_out  <= data_in[DW-1:0];
								 end
						4'b0100: begin
									ready_out <= 4'b0100;
									data_out  <= data_in[3*DW-1:2*DW];
								 end
						4'b1???: begin
									ready_out <= 4'b1000;
									data_out  <= data_in[4*DW-1:3*DW];
								 end
						4'b0??1: begin
									ready_out <= 4'b0001;
									data_out  <= data_in[DW-1:0];
								 end
						4'b0?10: begin
									ready_out <= 4'b0010;
									data_out  <= data_in[2*DW-1:DW];
								 end
						default: begin
									ready_out <= 4'b0000;
									data_out  <= data_in[DW-1:0];
								 end
					endcase
			4'b1000: casez(valid_in)
						4'b0000: begin
									ready_out <= 4'b0000;
									data_out  <= data_in[DW-1:0];
								 end
						4'b1000: begin
									ready_out <= 4'b1000;
									data_out  <= data_in[4*DW-1:3*DW];
								 end
						4'b???1: begin
									ready_out <= 4'b0001;
									data_out  <= data_in[DW-1:0];
								 end
						4'b??10: begin
									ready_out <= 4'b0010;
									data_out  <= data_in[2*DW-1:DW];
								 end
						4'b?100: begin
									ready_out <= 4'b0100;
									data_out  <= data_in[3*DW-1:2*DW];
								 end
						default: begin
									ready_out <= 4'b0000;
									data_out  <= data_in[DW-1:0];
								 end
					endcase
			default: begin
						ready_out <= 4'b0000;
						data_out  <= data_in[DW-1:0];
					 end
		endcase
	end
end
				
endmodule
				