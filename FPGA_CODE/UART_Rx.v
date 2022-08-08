module UART_Rx #(
	parameter n=8
	)
	(
	input  rst,
	input  clk,
	input  Rx,
	input  [n-1:0] BR,
	output [7:0] DATA_Rx,
	output int1,
	output eop
	);

	wire stBT, eoBT, Rx_aux;
	wire hc, hp, igual;
	wire [1:0] opc;
	wire [3:0] q;
	wire [8:0] D_1, D;

	assign igual = (q == 4'b1000) ? 1'b1:1'b0;
	FSM_UART_Rx                         U0(rst,clk,Rx_aux,eoBT,igual,stBT,opc,hc,hp,int1,eop);
	BASE_TIEMPO                   #(n)  U1(rst,clk,stBT,BR,eoBT);
	CONTADOR_ASCENDENTE_CLEAR     #(4)	U2(rst,clk,opc,q);
	REGISTRO_CORRIMIENTO_DERECHA  #(9)	U3(rst,clk,hc,Rx_aux,D_1);
	REGISTRO_PARALELO_HOLD        #(9)  U4(rst,clk,hp,D_1,D);
	FLIPFLOP_n        	                U5(rst,clk,Rx,Rx_aux);
	assign DATA_Rx = D[8:1];

	
endmodule
