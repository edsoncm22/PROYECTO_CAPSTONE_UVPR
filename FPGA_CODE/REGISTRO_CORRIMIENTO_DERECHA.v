module REGISTRO_CORRIMIENTO_DERECHA #(
	parameter n=8
	)
	(
	input rst,
	input clk,
	input h,
	input D,
	output reg [n-1:0] R
	);
	
	reg [n-1:0]Qn, Qp;
	
	always@(Qp, D, h)
		begin		 
			R = Qp;		
				if (h == 1'b1)
					Qn = {D,Qp[n-1:1]};
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