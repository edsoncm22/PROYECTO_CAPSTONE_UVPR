module MULTIPLICADOR #(
	parameter n=8,
	parameter m=8
	)
	(
	input  signed [n-1:0] A,
	input  signed [m-1:0] B,
	output reg signed [n+m-1:0] Y
	);
	
	always@(A,B)
		begin 
			Y = A * B;
		end
	endmodule
	
	/*module MULTIPLICADOR #(
	parameter n=8,
	parameter m=8
	)
	(
	input rst,
	input clk,
	input  signed [n-1:0] A,
	input  signed [m-1:0] B,
	output signed [n+m-1:0] Y
	);
	
	reg [n+m-1:0] reg_temp;
	
	assign Y = reg_temp;
	always@(posedge clk or posedge rst)
		begin 
			if (rst == 1'b1)
				reg_temp <= 0;
			else
				reg_temp <= A * B;
		end
	endmodule*/