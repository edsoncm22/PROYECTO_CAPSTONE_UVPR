module REGISTRO_PARALELO_HOLD_INI
	(
	input rst,
	input clk,
	input h,
	input [39:0] D,
	output reg [39:0] R
	);

	reg [39:0] Qn, Qp;

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
           // b0 = 00010010 11101101
           // b1 = 11101101 10000000

			//	Qp <= 48'b111011010001001010000000111011010000000000000000;
			Qp <= 40'b0001001011101101111011011000000000000000;
			else
				Qp <= Qn;
		end

endmodule
