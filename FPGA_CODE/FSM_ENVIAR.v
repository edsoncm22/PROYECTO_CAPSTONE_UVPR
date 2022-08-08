module FSM_ENVIAR
	(
	input rst,
	input clk,
	input stp,
	input eoTx,
	input igual,
	output reg stTx,
	output reg [1:0] opc,
	output reg eop
	);

	reg [1:0] Qp,Qn;

	always@(Qp, stp,eoTx,igual)
		begin

			case (Qp)

				2'b00: begin
				stTx  = 1'b0;
				opc   = 2'b11;
				eop   = 1'b1;
				if(stp == 1'b1)
					Qn = 2'b01;
				else
					Qn = Qp;
				end

				2'b01: begin
				stTx  = 1'b1;
				opc   = 2'b00;
				eop   = 1'b0;
				Qn = 2'b10;
				end

				2'b10: begin
				stTx  = 1'b0;
				opc   = 2'b00;
				eop   = 1'b0;
				if(eoTx == 1'b1)
					Qn = 2'b11;
				else
					Qn = Qp;
				end

				default: begin
				stTx  = 1'b0;
				opc   = 2'b01;
				eop   = 1'b0;
				if(igual == 1'b1)
					Qn = 2'b00;
				else
					Qn = 2'b01;
				end

			endcase

		end

		always@(posedge clk or posedge rst)
			begin
			if(rst == 1'b1)
				Qp <= 0;
			else
				Qp <= Qn;
			end


endmodule
