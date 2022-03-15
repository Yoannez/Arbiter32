module arbiter4(
	input clk,rst,
	input [3:0] req,
	output reg [3:0] grant
);

always@(posedge clk) begin
	if(rst == 1'b1)
		grant <= 4'b0000;
	else begin
		case(grant)
			4'b0000: grant <= req & ~(req-1'b1);
			4'b0001: casez(req)
						4'b0000: grant <= 4'b0000;
						4'b0001: grant <= 4'b0001;
						4'b??1?: grant <= 4'b0010;
						4'b?10?: grant <= 4'b0100;
						4'b100?: grant <= 4'b1000;
						default: grant <= 4'b0000;
					endcase
			4'b0010: casez(req)
						4'b0000: grant <= 4'b0000;
						4'b0010: grant <= 4'b0010;
						4'b?1??: grant <= 4'b0100;
						4'b10??: grant <= 4'b1000;
						4'b00?1: grant <= 4'b0001;
						default: grant <= 4'b0000;
					endcase
			4'b0100: casez(req)
						4'b0000: grant <= 4'b0000;
						4'b0100: grant <= 4'b0100;
						4'b1???: grant <= 4'b1000;
						4'b0??1: grant <= 4'b0001;
						4'b0?10: grant <= 4'b0010;
						default: grant <= 4'b0000;
					endcase
			4'b1000: casez(req)
						4'b0000: grant <= 4'b0000;
						4'b1000: grant <= 4'b1000;
						4'b???1: grant <= 4'b0001;
						4'b??10: grant <= 4'b0010;
						4'b?100: grant <= 4'b0100;
						default: grant <= 4'b0000;
					endcase
			default: grant <= 4'b0000;
		endcase
	end
end
				
endmodule
				