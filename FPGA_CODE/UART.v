module UART #(
	parameter n=8
	)
	(
	input rst,
	input clk,
	input [n-1:0] BR,
	
	input  [7:0] DATA_Tx,
	output [7:0] DATA_Rx, 
	
	output Tx,
	input  Rx,
		
	input  stTx,
	output eoTx, 
	output eoRx,
	output int1
	); 	 
	
	UART_Tx #(n)    C1(rst,clk,stTx,BR,DATA_Tx,Tx,eoTx);
	UART_Rx	#(n-1)  C2(rst,clk,Rx,BR[n-1:1],DATA_Rx,int1,eoRx);
	

endmodule