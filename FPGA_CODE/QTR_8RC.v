module QTR_8RC
(
  input rst,
  input clk,
  input stp,
  inout [7:0] D,
  output [7:0] QT8,QT7,QT6,QT5,QT4,QT3,QT2,QT1
  );

  wire eop1,eop2,eop3,eop4,eop5,eop6,eop7,eop8;

  QTR_RC U1(rst,clk,stp,D[7],QT8,eop1);
  QTR_RC U2(rst,clk,stp,D[6],QT7,eop2);
  QTR_RC U3(rst,clk,stp,D[5],QT6,eop3);
  QTR_RC U4(rst,clk,stp,D[4],QT5,eop4);
  QTR_RC U5(rst,clk,stp,D[3],QT4,eop5);
  QTR_RC U6(rst,clk,stp,D[2],QT3,eop6);
  QTR_RC U7(rst,clk,stp,D[1],QT2,eop7);
  QTR_RC U8(rst,clk,stp,D[0],QT1,eop8);

endmodule
