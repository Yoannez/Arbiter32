//完成pipeline的改写
//testbanche case改写
//拼装

module pipeline_tb;

reg clock,reset;
reg valid_in;
reg ready_in;
reg [3:0] data_in;
wire ready_out;
wire [3:0] data_out;
wire valid_out;

//Pipeline例化
pipeline_skid_buffer #(.WIDTH(4))
	dut
	(	
		.clk		(clock),
		.rst		(reset),
		.valid_in	(valid_in),
		.ready_in	(ready_in),
		.data_in	(data_in),
		.ready_out	(ready_out),
		.data_out	(data_out),
		.valid_out	(valid_out)
	);

//生成时钟信号
initial begin: ClockGeneration
	clock = 1;
	forever #50 clock = ~clock; //ClockPeriod == 100
end

initial begin: Signal
	
	reset = 1'b1;
	valid_in = 1'b0;
	ready_in = 1'b1;
	#100
	reset = 1'b0;
	valid_in = 1'b1;
	data_in = 4'b0000;
	#100
	data_in = 4'b0001;
	#100
	ready_in = 1'b0;
	data_in = 4'b0010;
	#100
	ready_in = 1'b1;
	#100
	data_in = 4'b0011;
	#100
	data_in = 4'b0100;
	#100
	ready_in = 1'b0;
	data_in = 4'b0101;
	#200
	ready_in = 1'b1;
	#100
	data_in = 4'b0110;
	
end

endmodule
	
	

		
		
	
	
