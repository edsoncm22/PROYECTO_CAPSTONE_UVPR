module FLIPFLOP_n 
	(
	input rst,
	input clk,
	input D,
	output reg Q
	);		  

	always@(posedge clk or posedge rst)
		begin						  
			if (rst == 1'b1)
			Q <= 1'b1; 
			else
			Q <= D;
		end
		
endmodule

	
	