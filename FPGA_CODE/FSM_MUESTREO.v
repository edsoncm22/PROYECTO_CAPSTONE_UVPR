module FSM_MUESTREO
	(
	input rst,
	input clk,
	input stp,
	input eoBT,
	input eoSEN,
	input eoPID,
	output reg stBT,
	output reg stSEN,
	output reg stPID,
	output reg h,
	output reg ena,
	output reg eop
	);

	reg [2:0] Qn, Qp;

	always@(Qp, stp, eoBT, eoSEN, eoPID)
		begin

			case(Qp)

				3'b000: begin
				stBT  = 1'b0;
				stSEN = 1'b0;
				stPID = 1'b0;
				h     = 1'b0;
				ena   = 1'b0;
				eop   = 1'b1;
				if (stp == 1'b1)
					Qn = 3'b001;
				else
					Qn = 3'b000;
				end

				3'b001: begin
				stBT  = 1'b1;
				stSEN = 1'b1;
				stPID = 1'b0;
				h     = 1'b0;
				ena   = 1'b1;
				eop   = 1'b0;
					Qn = 3'b010;
				end

				3'b010: begin
				stBT  = 1'b1;
				stSEN = 1'b0;
				stPID = 1'b0;
				h     = 1'b0;
				ena   = 1'b1;
				eop   = 1'b0;
				if (eoSEN == 1'b1)
					Qn = 3'b011;
				else
					Qn = 3'b010;
				end

				3'b011: begin
				stBT  = 1'b1;
				stSEN = 1'b0;
				stPID = 1'b0;
				h     = 1'b1;
				ena   = 1'b1;
				eop   = 1'b0;
					Qn = 3'b100;
				end


				3'b100: begin
				stBT  = 1'b1;
				stSEN = 1'b0;
				stPID = 1'b1;
				h     = 1'b0;
				ena   = 1'b1;
				eop   = 1'b0;
					Qn = 3'b101;
				end

				3'b101: begin
				stBT  = 1'b1;
				stSEN = 1'b0;
				stPID = 1'b0;
				h     = 1'b0;
				ena   = 1'b1;
				eop   = 1'b0;
				if (eoPID == 1'b1)
					Qn = 3'b110;
				else
					Qn = 3'b101;
				end

				3'b110: begin
				stBT  = 1'b1;
				stSEN = 1'b0;
				stPID = 1'b0;
				h     = 1'b0;
				ena   = 1'b1;
				eop   = 1'b0;
				if (eoBT == 1'b1)
					Qn = 3'b111;
				else
					Qn = 3'b110;
				end

				default: begin
				stBT  = 1'b1;
				stSEN = 1'b0;
				stPID = 1'b0;
				h     = 1'b0;
				ena   = 1'b1;
				eop   = 1'b0;
				if (stp == 1'b1)
					Qn = 3'b001;
				else
					Qn = 3'b000;
				end
			endcase
		end

	always@(posedge clk or posedge rst)
		begin
			if (rst == 1'b1)
				Qp <= 0;
			else
				Qp <= Qn;
		end

endmodule
