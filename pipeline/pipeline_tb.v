module pipeline_tb;

parameter ClockPeriod = 100;

reg clock,reset;
reg valide_in;
reg ready_in;
reg [3:0] data_in;
wire ready_out;
wire [3:0] data_out;
wire valide_out;

//Pipeline例化
pipeline #(.bus_width(4))
	dut
	(	
		.clk		(clock),
		.rst		(reset),
		.valide_in	(valide_in),
		.ready_in	(ready_in),
		.Datain		(data_in),
		.ready_out	(ready_out),
		.Dataout	(data_out),
		.valide_out	(valide_out)
	);

//生成时钟信号
initial begin: ClockGeneration
	clock = 1;
	forever #(ClockPeriod/2) clock = ~clock;
end

initial begin: ResetGeneration
	reset = 1'b0;
	#ClockPeriod
	
	reset = 1'b1;
end



initial begin: Signal
	#ClockPeriod
	#ClockPeriod
	
	valide_in = 1'b1;
	data_in = 4'b0001;
	ready_in = 1'b0;
	#ClockPeriod
	
	data_in = 4'b0010;
	#ClockPeriod
	#ClockPeriod
	
	ready_in = 1'b1;
	#ClockPeriod
	
	data_in = 4'b0011;
	#ClockPeriod
	
	data_in = 4'b0100;
	#ClockPeriod
	
	data_in = 4'b0101;
	ready_in = 1'b0;
	#ClockPeriod
	
	data_in = 4'b0110;
	valide_in = 1'b0;	
end

endmodule
	
	

		
		
	
	
