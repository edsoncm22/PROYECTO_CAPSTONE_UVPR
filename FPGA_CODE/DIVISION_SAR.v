module DIVIION_SAR #(
  parameter n1 = 16,
  parameter n2 = 5
  )
(                            //              A/B    A tiene dimensiones n1+n2
  input rst,
  input clk,
  input stp,
  input [n1-1:0] A,
  input [n2-1:0] B,
  output [n1-n2-1:0] R,
  output eop
  );

  wire hs,hp,hf,clc;
  wire [1:0] EG;
  wire [n1-n2-1:0] Rs, Rss, Rp, Rf;
  wire [n1-1:0] m;

  FSM_SAR U0(rst,clk,stp,Rs[0],clc,hs,hp,hf,eop);

  SYNC_SAR               #(n1-n2) U1(rst|clc,clk,hs,Rs);
  OPERADOR_SAR           #(n1-n2) U2(EG, Rs, Rss);
  REGISTRO_PARALELO_HOLD #(n1-n2) U3(rst|clc,clk,hp,Rp,Rf);
  SUMADOR                #(n1-n2) U4(Rss,Rf,Rp);
  REGISTRO_PARALELO_HOLD #(n1-n2) U5(rst,clk,hf,Rf,R);

  MULTIPLICADOR_U #(n2,n1-n2) U6(B,Rf,m);
  COMPARADOR_SAR  #(n1)       U7(m,A,EG);

endmodule //
