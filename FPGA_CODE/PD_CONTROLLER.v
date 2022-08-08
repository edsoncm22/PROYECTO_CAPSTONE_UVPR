module PD_CONTROLLER #(
	parameter nH=31,
	          nL=0
	)
(
  input rst,
  input clk,
  input stp,
  input eo_sensor,
  input [15:0] b0,b1,
  input [15:0] SAT_UMAX, SAT_UMIN,
  input [15:0] DIST,
  input [15:0] SET_POINT,
  output st_sensor,
  output ena,
  output [15:0] u_k,
  output eop
  );


  wire st_BT,eo_BT;
  wire st_PID, eo_PID;
  wire h;
  wire [15:0] ek,e_k;

  wire [15:0] MAX, MIN,uk;
  wire [15:0] DIST_R;
  wire [15:0] Ts;

assign Ts  = 16'd59999;                //5ms
//assign Ts = 18'd239999;  //20ms



  FSM_MUESTREO                          U0(rst,clk,stp,eo_BT,eo_sensor,eo_PID,st_BT,st_sensor,st_PID,h,ena,eop);
  BASE_TIEMPO            #(16)          U1(rst,clk,st_BT,Ts,eo_BT);
  REGISTRO_PARALELO_HOLD #(16)          U2(rst,clk,1'b1,~DIST,DIST_R);
  //assign ek = SET_POINT + DIST_R;
  SUMADOR                #(16)          U7(SET_POINT,DIST_R,ek);
  REGISTRO_PARALELO_HOLD #(16)          U3(rst,clk,h,ek,e_k);
  PD                    #(16,16,nH,nL) U4(rst,clk,st_PID,b0,b1,e_k,uk,eo_PID);
  SATURADOR              #(16)          U5(SAT_UMAX,SAT_UMIN,uk,u_k);

endmodule
