module QTR_PROMEDIO
(
  input rst,
  input clk,
  input stp,
  inout [7:0] D,
  output [7:0] QT8,QT7,QT6,QT5,QT4,QT3,QT2,QT1,
  output [10:0]RES,
  output eop
  );

wire st_bt,eo_bt;
wire st_sen,h;
wire st_div, eo_div;

wire [4:0] SN, SN_R;
wire [15:0] SP, SP_R;

wire [14:0] Ts1;


assign Ts1 = 15'd23999;

  FSM_QTR_POS U0(rst,clk,stp,eo_bt,eo_div,st_sen,st_bt,st_div,h,eop);

  BASE_TIEMPO #(15) U1(rst,clk,st_bt,Ts1,eo_bt);
  QTR_POSICION U2(rst,clk,st_sen,D,QT8,QT7,QT6,QT5,QT4,QT3,QT2,QT1,SP,SN);

  REGISTRO_PARALELO_HOLD #(16) U3(rst,clk,h,SP,SP_R);
  REGISTRO_PARALELO_HOLD #(5) U4(rst,clk,h,SN,SN_R);

  DIVIION_SAR #(16,5) U5(rst,clk,st_div,SP_R,SN_R,RES,eo_div);


endmodule // QTR_PROMEDIO
