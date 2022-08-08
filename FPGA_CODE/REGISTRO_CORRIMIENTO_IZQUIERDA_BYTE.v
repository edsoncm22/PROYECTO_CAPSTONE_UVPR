module REGISTRO_CORRIMIENTO_IZQUIERDA_BYTE #(
	parameter n=32
	)
	(
	input rst,
	input clk,
	input h,
	input [7:0] D,
	output reg [n-1:0] R
	);

	reg [n-1:0]Qn, Qp;

	always@(Qp, D, h)
		begin
			R = Qp;
				if (h == 1'b1)
					Qn = {Qp[n-9:0],D};
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
