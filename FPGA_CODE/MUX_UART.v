module MUX_UART 
	(
	input [3:0] sel,
	input [7:0] DATA,
	output reg y
	);			

	always@(sel,DATA)
		begin		
			
			case (sel)
			
				4'b0000: begin
				y = 1'b1;
				end
				
				4'b0001: begin
				y = 1'b0;
				end		
				
				4'b0010: begin
				y = DATA[0];
				end
				
				4'b0011: begin
				y = DATA[1];
				end		  
				
				4'b0100: begin
				y = DATA[2];
				end
				
				4'b0101: begin
				y = DATA[3];
				end		  
				
				4'b0110: begin
				y = DATA[4];
				end		  
				
				4'b0111: begin
				y = DATA[5];
				end		  
				
				4'b1000: begin
				y = DATA[6];
				end		  
				
				4'b1001: begin
				y = DATA[7];
				end		  
				
				default: begin
				y = 1'b1;
				end
				
			endcase
			
		end
		
endmodule
