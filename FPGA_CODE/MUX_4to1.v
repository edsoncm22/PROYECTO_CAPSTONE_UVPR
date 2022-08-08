module MUX_4to1 #(
	parameter n=8
	)
	(
	input  [1:0] opc,
	input  [n-1:0] x0,
	input  [n-1:0] x1,
	input  [n-1:0] x2,
	input  [n-1:0] x3,
	output reg [n-1:0] y
	);					
	
	always@(opc,x0,x1,x2,x3)
		begin				
			case(opc)
				
				2'b00:begin
				y = x0;	
				end
				
				2'b01:begin
				y = x1;	
				end
				
				2'b10:begin
				y = x2;	
				end
				
				2'b11:begin
				y = x3;	
				end
				
			endcase
			
		end
		
endmodule
