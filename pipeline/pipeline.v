module pipeline
#(parameter bus_width=8)
(
	input clk,rst,
	input valide_in,
	input ready_in,
	input [bus_width-1:0] Datain,
	output reg ready_out,
	output reg [bus_width-1:0] Dataout,
	output reg valide_out
);

reg valide_r;
reg [bus_width-1:0] Data_r;
reg [bus_width-1:0] Data_inter;
reg valide_inter;

always@(posedge clk) begin
	
	Data_r <= (valide_inter) ? Data_inter : Datain;
	valide_r <= valide_in | valide_inter;
	
	if(!rst)begin //rst拉低复位
		valide_inter <= 1'b0;
		Data_inter <= {bus_width{1'b0}};
	end 
	else begin
		if(ready_in)
			valide_inter <= 1'b0;
		else if(ready_out) begin //!ready_in & ready_out 此时出现数据丢失
			valide_inter <= valide_in;
			Data_inter <= Datain;
		end
	end
	
	ready_out <= !valide_inter;	//pipeline内部为没有数据，ready_out持续拉高
	valide_out <= valide_r;
	Dataout <= Data_r;
	
end

endmodule

	