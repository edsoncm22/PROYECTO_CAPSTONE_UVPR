module SEND_DATA (
  input rst,
  input clk,
  input stp,
  input eoTx,
  input [7:0] ref,
  input [7:0] pos,
  input [7:0] vi_s,
  input [7:0] vd_s,
  input [7:0] S8,S7,S6,S5,S4,S3,S2,S1,
  output [7:0] DATA_Tx,
  output stTx,
  output eop
  );


  wire igual;
  wire stBT,eoBT;
  wire [1:0] opc;
  wire [3:0] Q;
  wire [7:0] E;
  assign E = ref + ~pos;

  //envio de datos cada 200ms

  assign igual = (Q == 4'd12) ? 1'b1 : 1'b0;
  FSM_ENVIAR U0(rst,clk,stp,eoTx,igual,stTx,opc,eop);
  BASE_TIEMPO #(23) U1(rst,clk,stBT,23'd5999999,eoBT);
  CONTADOR_ASCENDENTE_CLEAR #(4) U2(rst,clk,opc,Q);
  MUX_16to1 U3(Q,pos,E,vi_s,vd_s,S8,S7,S6,S5,S4,S3,S2,S1,8'd247,pos,E,S8,DATA_Tx);

endmodule //
