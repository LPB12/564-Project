//Luke Brown 
//Covolution math unit for project 464
module ConvoMath(
	input [15:0] w,
	input [15:0] i,  //Inputs
	input dataSel, //Control Signal
	output reg [15:0] result = 0 //result value
);

	reg [8:0]r00;
	
	reg [8:0] r01;
	
	reg [8:0] r10; //registers to store 9 bit concated values for each of the 4 values
	
	reg [8:0] r11;
	
	
	reg [7:0] r00sign = 0; 
	reg [7:0] r01sign = 0; 
	reg [7:0] r10sign = 0;  //The signs positive or negative of the 4 different result matrix values
	reg [7:0] r11sign = 0; 
	
	
	
	integer j;
	
	always @ (w or i)
	begin
		r00 = {(i[0] ~^ w[0]) , (i[1] ~^ w[1]) , (i[2] ~^ w[2]) , (i[4] ~^ w[3]) , (i[5] ~^ w[4]) , (i[6] ~^ w[5]) , (i[8] ~^ w[6]) , (i[9] ~^ w[7]) , (i[10] ~^ w[8])};
	
		r01 = {(i[1] ~^ w[0]) , (i[2] ~^ w[1]) , (i[3] ~^ w[2]) , (i[5] ~^ w[3]) , (i[6] ~^ w[4]) , (i[7] ~^ w[5]) , (i[9] ~^ w[6]) , (i[10] ~^ w[7]) , (i[11] ~^ w[8])}; //Perform  the XNOR multiplications and concat the values together into a single place
	
		r10 = {(i[4] ~^ w[0]) , (i[5] ~^ w[1]) , (i[6] ~^ w[2]) , (i[8] ~^ w[3]) , (i[9] ~^ w[4]) , (i[10] ~^ w[5]) , (i[12] ~^ w[6]) , (i[13] ~^ w[7]) , (i[14] ~^ w[8])};
	
		r11 = {(i[5] ~^ w[0]) , (i[6] ~^ w[1]) , (i[7] ~^ w[2]) , (i[9] ~^ w[3]) , (i[10] ~^ w[4]) , (i[11] ~^ w[5]) , (i[13] ~^ w[6]) , (i[14] ~^ w[7]) , (i[15] ~^ w[8])};
		

		r00sign = 0;
		r01sign = 0;
		r10sign = 0;
		r11sign = 0; //Set these values to prevent latches
		result[0] = 0;
		result[1] = 0;
		result[2] = 0;
		result[3] = 0;
			
		if(dataSel)
		begin
			for(j=0; j<=8; j=j+1)
			begin
				if(r00[j] == 1) r00sign = r00sign + 1;
				else r00sign = r00sign;
			
				if(r01[j] == 1) r01sign = r01sign + 1; //This for loop goes through the 9 bits for each value. If it is 0 it stays the same and if it is 1 then add 1 to the sign value
				else r01sign = r01sign;
			
				if(r10[j] == 1) r10sign = r10sign + 1;
				else r10sign = r10sign;
			
				if(r11[j] == 1) r11sign = r11sign + 1;
				else r11sign = r11sign;
			end
		
			
			
				if(r00sign >= 5) result[0] = 1'b1;
				else result[0] =  1'b0;
	
				if(r01sign >= 5) result[1] = 1'b1;  //This then checks the sign values
				else result[1] =  1'b0;             //If the value is greater than or equal to 5 then the value is positive and it is stored as 1 for 1
													//If the value is less than 5 then its negative and a 0 is stored for -1
				if(r10sign >= 5) result[2] = 1'b1;
				else result[2] =  1'b0;
	
				if(r11sign >= 5) result[3] = 1'b1;
				else result[3] =  1'b0;
		end

		
	
	end
endmodule

	
