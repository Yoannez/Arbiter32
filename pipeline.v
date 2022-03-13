module pipeline
#(parameter bus_width=8)
(
	input clk,rst
	input valide_in,
	input ready_in,
	input [bus_width-1:0] Datain,
	output ready_out,
	output [bus_width-1:0] Dataout,
	output valide_out
);

reg valide_r, ready_r;
reg [bus_width-1:0] Data_r;
reg [bus_width-1:0] Data_inter;
reg valide_inter;

always@(posedge clk) begin
	
	ready_out <= ready_r;
	valide_out <= valide_r;
	Dataout <= Data_r;
	
	if(!rst)begin //rst拉低复位
		valide_inter <= 1'b0;
		Data_inter <= {bus_width{1'b0}};
	end 
	else begin
		if(ready_in)
			valide_inter <= 1b'0;
		else if(ready_r) begin //!ready_in & ready_r
			valide_inter <= valide_in;
			Data_inter <= Datain;
		end
		
end

assign ready_r = !valide_inter;
assign valide_r = valide_in or valide_inter;
assign Data_r = (valide_inter) ? Data_inter : Datain;

endmodule

	