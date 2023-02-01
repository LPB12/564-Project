//464 Controller FSM

module control(
	
	input go,
	input rst,
	input clock,
	output reg [11:0] write_addr,
	output reg write_en,
	output reg [11:0] read_addr_w,   //all input and output values
	output reg [11:0] read_addr_i,
	output reg busy, 
	output reg datapath_sel
);

	
	
	parameter [1:0] // synopsys enum states
	S0 = 2'b00,
	S1 = 2'b01,   //Parameterize state numbers
	S2 = 2'b10,
	S3 = 2'b11;

	reg [1:0] c_state;
	reg [1:0] n_state;  //Registers for FSM
	reg write_flg;
	

	always @(posedge clock)
	begin
		write_addr = 0;
		read_addr_w = 0;
		read_addr_i = 0;
		
		if(!rst) c_state <= S0;
		else c_state <= n_state;   // If theres no reset then take the next state
		
		if(write_flg) write_en <= 1; //If the write flag goes high then output write enable high
		else write_en <= 0;
	end

	always @(c_state or go)
	begin
	   case(c_state)
	    S0: begin
				busy = 0;
				datapath_sel = 0; 
				write_flg = 0;
				if(go) n_state = S1;  //State 0 is waiting for the Go from the bench
				else n_state = S0;
	        end

	    S1: begin
				busy = 1;
				datapath_sel = 0;  //State 1 sets busy high telling the bench to wait and write flag is low as there is nothing to right
				write_flg = 0;
				n_state = S2;
			end
			
        S2: begin
				busy = 1;
				datapath_sel = 1; //State 2 lets the data coming in on the inputs through to the flops to be processed and outputted
				write_flg = 0;
				n_state = S3;
			end
			
	    S3: begin
				write_flg = 1;
				busy = 1;
				datapath_sel = 0; //In S3 write flag is set high to allow the data out of the result flop into the SRAM
				
				n_state = S0;
			end
	    default: n_state = S0;
	   endcase	 
	end

endmodule
