module MULTIPLICADOR_U #(
	parameter n=8,
	parameter m=8
	)
	(
	input  [n-1:0] A,
	input  [m-1:0] B,
	output reg [n+m-1:0] Y
	);

	always@(A,B)
		begin
			Y = A * B;
		end
	endmodule
