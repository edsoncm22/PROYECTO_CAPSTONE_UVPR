module PWM_5KHz
	(
	input  rst,
	input  clk,
	input  ena,
	input  [7:0] match,
	output pwm
	);


wire igual1,igual2;
wire [1:0] opc1;
wire [1:0] opc2;

wire [3:0] Q1;
wire [7:0] Q2, match_r;



assign igual1 = (Q1 == 4'd11)  ? 1'b1 : 1'b0;
assign igual2 = (Q2 == 8'd199) ? 1'b1 : 1'b0;
assign pwm    = (Q2 < match_r) ? 1'b1 : 1'b0;


assign opc1 = {(igual1 | ena), 1'b1};
assign opc2 = {(igual2 & igual1) | ena, igual1};

REGISTRO_PARALELO_HOLD    #(8)       U0(rst,clk,igual2,match,match_r);
CONTADOR_ASCENDENTE_CLEAR #(4)       U1(rst,clk,opc1,Q1);
CONTADOR_ASCENDENTE_CLEAR #(8)       U2(rst,clk,opc2,Q2);

endmodule
