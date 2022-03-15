module pipeline_skid_buffer
	#(
		parameter WIDTH = 0
	)
	(
		input clk,rst,
		input valid_in,
		input [WIDTH-1:0] data_in,
		output ready_out,
		output valid_out,
		output [WIDTH-1:0] data_out,
		input ready_in
	);

	localparam ZERO = {WIDTH{1'b0}};




	/*-------Data Path--------*/
	reg data_buffer_en = 1'b0; // EMPTY at start, so don't load.
	wire [WIDTH-1:0] data_buffer_out;

	register
	#(
		.WIDTH		(WIDTH),
		.RESET_VALUE(ZERO)
	)
	data_buffer
	(
		.clk   		(clk),
        .enable   	(data_buffer_en),
        .rst        (rst),
        .data_in    (data_in),
        .data_out   (data_buffer_out)
    );
	
	reg	data_out_reg_en = 1'b1; // EMPTY at start, so accept data.
    reg	use_buffer = 1'b0;
    reg [WIDTH-1:0] selected_data = ZERO;
	
	always @(*) begin
        selected_data = (use_buffer == 1'b1) ? data_buffer_out : data_in;
    end
	
	register
    #(
        .WIDTH     	(WIDTH),
        .RESET_VALUE(ZERO)
    )
    data_out_reg
    (
        .clk      	(clk),
        .enable   	(data_out_reg_en),
        .rst      	(rst),
        .data_in  	(selected_data),
        .data_out 	(data_out)
    );




	/*-------Control Path--------*/
    localparam [1:0] EMPTY = 'd0; // Output and buffer registers empty
    localparam [1:0] BUSY  = 'd1; // Output register holds data
    localparam [1:0] FULL  = 'd2; // Both output and buffer registers hold data

	wire [1:0] state;
    reg  [1:0] state_next = EMPTY;
	
	// ready 打拍
	register
    #(
        .WIDTH     	(1),
        .RESET_VALUE(1'b1) // EMPTY at start, so accept data
    )
    ready_out_reg
    (
        .clk       	(clk),
        .enable   	(1'b1),
        .rst       	(rst),
        .data_in  	(state_next != FULL), //只要下个状态不是FULL，则ready_out一直拉高
        .data_out 	(ready_out)
    );
	
	//valid 打拍
	register
    #(
        .WIDTH     		(1),
        .RESET_VALUE    (1'b0)
    )
    valid_out_reg
    (
        .clk       	(clk),
        .enable   	(1'b1),
        .rst       	(rst),
        .data_in    (state_next != EMPTY), //只要下个状态不是EMPTY, 即data_out和data_buffer没有清空, valid_out一直拉高
        .data_out   (valid_out)
    );
	
	/*-------Describe condition signal--------*/
	reg insert = 1'b0;
	reg remove = 1'b0;
	
	always @(*) begin
		insert = (ready_out == 1'b1) && (valid_in == 1'b1);
		remove = (valid_out == 1'b1) && (ready_in == 1'b1);
	end

	reg load = 1'b0; 	// Inserts data into data_output register. state: EMPTY->BUSY
    reg flow = 1'b0; 	// Old data of data_out register is removed and insert new data in. state: BUSY->BUSY
    reg fill = 1'b0; 	// Inserts data into data_buffer register and data not removed from data_out register. state: BUSY->FULL
    reg flush = 1'b0; 	// Move data from data_buffer register into data_out register. state: FULL->BUSY
    reg unload = 1'b0; 	// Remove data from data_out register, leaving the datapath empty. state: BUSY->EMPTY
	
	always @(*) begin
        load    = (state == EMPTY) && (insert == 1'b1) && (remove == 1'b0);
        flow    = (state == BUSY)  && (insert == 1'b1) && (remove == 1'b1);
        fill    = (state == BUSY)  && (insert == 1'b1) && (remove == 1'b0);
        flush   = (state == FULL)  && (insert == 1'b0) && (remove == 1'b1);
        unload  = (state == BUSY)  && (insert == 1'b0) && (remove == 1'b1);
    end
	
	/*-------Calculate next state--------*/
	always @(*) begin
        state_next = (load   == 1'b1) ? BUSY  : state;
        state_next = (flow   == 1'b1) ? BUSY  : state_next;
        state_next = (fill   == 1'b1) ? FULL  : state_next;
        state_next = (flush  == 1'b1) ? BUSY  : state_next;
        state_next = (unload == 1'b1) ? EMPTY : state_next;
    end
	
	register
    #(
        .WIDTH     	(2),
        .RESET_VALUE(EMPTY)         // Initial state
    )
    state_reg
    (
        .clk          	(clk),
        .enable   		(1'b1),
        .rst          	(rst),
        .data_in        (state_next),
        .data_out       (state)
    );
	
	 always @(*) begin
        data_out_reg_en	= (load  == 1'b1) || (flow == 1'b1) || (flush == 1'b1);
        data_buffer_en  = (fill  == 1'b1);
        use_buffer 		= (flush == 1'b1);
    end

endmodule