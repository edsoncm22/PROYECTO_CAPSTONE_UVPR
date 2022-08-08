module QTR_POSICION
(
  input rst,
  input clk,
  input stp,
  inout [7:0] D,
  output [7:0] QT8,QT7,QT6,QT5,QT4,QT3,QT2,QT1,
  output [15:0] SP,
  output [4:0] SN
  );

  wire [4:0] m1,m2,m3,m4,m5,m6,m7,m8;
  wire [15:0] s1,s2,s3,s4,s5,s6,s7,s8;
  //wire [15:0] QT8,QT7,QT6,QT5,QT4,QT3,QT2,QT1;
  wire [7:0] umbral;

  assign umbral = 8'd18;
  QTR_8RC U0(rst,clk,stp,D,QT8,QT7,QT6,QT5,QT4,QT3,QT2,QT1);

  assign m1 = (QT1 > umbral) ? 5'd1 : 5'd0;
  assign m2 = (QT2 > umbral) ? 5'd1 : 5'd0;
  assign m3 = (QT3 > umbral) ? 5'd1 : 5'd0;
  assign m4 = (QT4 > umbral) ? 5'd1 : 5'd0;
  assign m5 = (QT5 > umbral) ? 5'd1 : 5'd0;
  assign m6 = (QT6 > umbral) ? 5'd1 : 5'd0;
  assign m7 = (QT7 > umbral) ? 5'd1 : 5'd0;
  assign m8 = (QT8 > umbral) ? 5'd1 : 5'd0;

  assign s1 = (QT1 > umbral) ? 16'd10 : 16'd0;
  assign s2 = (QT2 > umbral) ? 16'd20 : 16'd0;
  assign s3 = (QT3 > umbral) ? 16'd30 : 16'd0;
  assign s4 = (QT4 > umbral) ? 16'd40 : 16'd0;
  assign s5 = (QT5 > umbral) ? 16'd50 : 16'd0;
  assign s6 = (QT6 > umbral) ? 16'd60 : 16'd0;
  assign s7 = (QT7 > umbral) ? 16'd70 : 16'd0;
  assign s8 = (QT8 > umbral) ? 16'd80 : 16'd0;

assign SN = m1 + m2 + m3 + m4 + m5 + m6 + m7 + m8;
assign SP = s1 + s2 + s3 + s4 + s5 + s6 + s7 + s8;


endmodule
