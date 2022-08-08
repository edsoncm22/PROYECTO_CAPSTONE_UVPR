module SATURADOR #(
	parameter n=8
	)
	(			 
	input  signed [n-1:0] MAX,
	input  signed [n-1:0] MIN,
	input  signed [n-1:0] U,
	output reg signed [n-1:0] Y
	); 
	
	always@(MAX,MIN,U)
		begin
		 if (U > MAX)
			 Y = MAX;
		 else if (U < MIN)
			 Y = MIN;
		 else
			 Y = U;
		end
		

endmodule