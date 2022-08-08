module SUMADOR #(
	parameter n=8
	)
	(
	input  [n-1:0] A,
	input  [n-1:0] B,
	output reg [n-1:0] Y
	);
	
      always@(A,B)
		begin 
			Y = A + B;
		end	
		
endmodule
	