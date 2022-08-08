module CONTADOR_ASCENDENTE_CLEAR #(
	parameter n=8
	)			 
	(
	input rst,
	input clk,
	input [1:0] opc,
	output reg [n-1:0] Q
	);					
	
	reg [n-1:0] Qn, Qp;
	
	always@(Qp, opc)
		begin
			
			Q = Qp;	
			
			case (opc)
						   
				2'b00: begin
				Qn = Qp;
				end
				
				2'b01: begin
				Qn = Qp + 1;
				end	
				
				default: begin
				Qn = 0;
				end
				
			endcase	
			
		end	 
		
	always@(posedge clk or posedge rst)
		begin						  
			if( rst == 1'b1)
				Qp <= 0;
			else
				Qp <= Qn;
		end	
		
endmodule

 

