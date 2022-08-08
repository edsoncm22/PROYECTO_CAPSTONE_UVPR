module REGISTRO_PARALELO_HOLD #(
	parameter n=8
	)
	(
	input rst,
	input clk,
	input h,
	input [n-1:0] D,  
	output reg [n-1:0] R
	);
	
	reg [n-1:0] Qn, Qp;
	
	always@(Qp,D,h)
		begin	   
			R = Qp;
			if(h == 1'b1)
				Qn = D;  
			else
				Qn = Qp;
		end
		
	always@(posedge clk or posedge rst)
		begin						   
			if(rst == 1'b1)
				Qp <= 0;
			else
				Qp <= Qn;
		end

endmodule