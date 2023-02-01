//Luke Brown
//Datapath for 464 Project 

module Datapath(
	input clock,
	input reset,
	input [15:0] InMat,  //Input 
	input [15:0] WMat,  //Weight Input 
	input datap_sel, //control signal from controller
	output reg [15:0] RMat //Output result flop
);
	wire [15:0] ResultPath;  //Wire from convolution math module to datapath result flop
	reg [15:0] WMem, InMem;  //Input and weight flops
	
	ConvoMath Math1(
		.w(WMem),
		.i(InMem),
		.dataSel(datap_sel),  //passing data to the convolutional math module for processing and return
		.result(ResultPath)
	);
	
	
	always @ (posedge clock)
	begin
		if(!reset)
		begin 
			InMem <= 0;
			WMem <= 0;  //Reset sets everything 0
			RMat <= 0;
		end
		
		else
		begin 
			if(datap_sel)
			begin
				WMem <= WMat;
				InMem <= InMat; //If the control signal is given then store the values
				RMat <= ResultPath;
			end
			
			else
			begin
				WMem <= WMem;
				InMem <= InMem;  //Otherwise they stay the same
				RMat <= ResultPath;
			end
			
			
		end
	end
endmodule
	
