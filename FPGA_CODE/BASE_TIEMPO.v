module BASE_TIEMPO #(
	parameter n=8
	)
	(
	input  rst,
	input  clk,
	input  stBT,
	input  [n-1:0] dat,
	output reg eoBT
	);		   


	reg [n-1:0] Qn;
	reg [n-1:0] Qp;
	reg [n-1:0] Qf;
	
	reg [1:0] opc;
	reg igual;
	
		
	    always @(Qp,opc)
			
			begin		
	       	Qf=Qp;
			case(opc)
				
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
				  
		always @(Qf,dat,igual,stBT)
		
		begin 
		eoBT = igual;
		opc = {igual,stBT};
			if (Qf==dat)
				igual = 1'b1;
			else
				igual = 1'b0;
		end
			
		
		always @(posedge clk or posedge rst)
			begin 
			if(rst == 1'b1)
				Qp <= 0;
			else
				Qp <= Qn;
			end
			
endmodule
			
			