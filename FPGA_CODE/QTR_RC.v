module QTR_RC
(
  input rst,
  input clk,
  input stp,
  inout D,
  output [7:0] Qt,
  output eop
  );

  wire stBT,eoBT;
  wire h, igual,full;
  wire Din,sel;
  wire [1:0] opc;
  wire [7:0]Q;


  assign D = (sel==1'b1) ? 1'b1:1'bz;
	assign Din = D;

  FSM_QTR_RC                      U0(rst,clk,stp,eoBT,full,Din,sel,stBT,h,opc,eop);
  BASE_TIEMPO                #(7) U1(rst|h,clk,stBT,7'd119,eoBT);   // timer de 10us
  CONTADOR_ASCENDENTE_CLEAR #(8) U2(rst,clk,opc,Q);
  REGISTRO_PARALELO_HOLD    #(8) U3(rst,clk,h,Q,Qt);
  assign full  = (Q>8'd198)       ? 1'b1 : 1'b0;

endmodule
