module UART_Tx #(
	parameter n=8
	)
	(
	input rst,
	input clk,
	input stp,
	input [n-1:0] BR,
	input [7:0] DATA_Tx,
	output Tx,
	output eop
	);		  
	
	wire stBT, eoBT;
	wire igual;
	wire [1:0] opc;	
	wire [3:0] Q;
	
	assign igual = (Q == 4'b1010) ? 1'b1 : 1'b0;
	
	FSM_UART_Tx U0(rst,clk,stp,eoBT,igual,stBT,opc,eop); 
	BASE_TIEMPO               #(n) U1(rst,clk,stBT,BR,eoBT);
	CONTADOR_ASCENDENTE_CLEAR #(4) U2(rst,clk,opc,Q); 
	MUX_UART U3(Q,DATA_Tx,Tx);

endmodule
