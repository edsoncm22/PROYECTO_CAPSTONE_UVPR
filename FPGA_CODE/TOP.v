// CAMBIO EN EL FUNCIONAMIENTO DEL SENSOR
// MUESTREO CADA 1ous
module TOP
(
   input rst,
	input clk,
   input SET1,
   input SET2,
   inout [7:0] D,
   output STBY,
   output PWM_A,
   output DIR_A1,
   output DIR_A2,
   output PWM_B,
   output DIR_B1,
   output DIR_B2,
   output Tx,
   input Rx,
   output eop
  );

  wire st_sen,eo_sen;
  wire ena;
  wire [10:0] BR;
  wire [10:0] POS;
  wire [15:0] u_k, vd, vd_s, vi, vi_s;
  wire [15:0] vr, VPM, Vmin, refp;
  wire [15:0] b0,b1;
  wire [15:0] SAT_UMAX, SAT_UMIN;

  wire st_Tx,eo_Tx;
  wire int1,eo_Rx;
  wire flag_fin,flag;
  wire [7:0] DATA_Rx, DATA_Tx, nc, vr_r;
  wire [47:0]DATOS;
  wire [39:0] DATOS_R;

  wire eops;

  // tiempo de respuesta de los sensores
  wire [7:0] QT8,QT7,QT6,QT5,QT4,QT3,QT2,QT1;

// BAUDRATE
  assign BR = 11'd1249;   // BAUDRATE = 9600

// REFERENCIAS
  assign refp = 16'd46;                       // posicion de referencia    45+1 por CA2

// SATURADOR
  assign SAT_UMAX  = 16'd100;                 // saturación máxima vel      100
  assign SAT_UMIN  = 16'd65436;               // saturación máxima vel     -100

  assign VPM  = 16'd170;                      // saturación máxima vel     200
  assign Vmin = 16'd0;                        // saturación minima vel       0


// kp=3.7;ki=20;kd=0.7;Ts=0.005;
/*
assign b0 = 16'd9203;
assign b1 = 16'd47379;
assign b2 = 16'd8960;
*/



  // formato para el seuidor de linea
  // error         16.0
  // ganancias     11.5
  // salida        27.5

  QTR_PROMEDIO       U1(rst,clk,st_sen,D,QT8,QT7,QT6,QT5,QT4,QT3,QT2,QT1,POS,eo_sen);
  PD_CONTROLLER #(20,5) U2(rst,clk,SET1,eo_sen,b0,b1,SAT_UMAX,SAT_UMIN,{5'b00000,POS},refp,st_sen,ena,u_k,eop);

// motor izquierdo
  SUMADOR    #(16) U3( u_k,vr,vd);
  SATURADOR  #(16) U4(VPM,Vmin,vd,vd_s);
  PWM_5KHz         U5(rst,clk,~ena,vd_s[7:0],PWM_A);


// motor derecho
  SUMADOR    #(16) U6(~u_k,vr,vi);
  SATURADOR  #(16) U7(VPM,Vmin,vi,vi_s);
  PWM_5KHz         U8(rst,clk,~ena,vi_s[7:0],PWM_B);


// configuracion del puent H para avanzar
  assign STBY = SET2;

  assign DIR_A2 = 1'b0;
  assign DIR_B2 = 1'b0;

  assign DIR_A1 = 1'b1;
  assign DIR_B1 = 1'b1;

////////////////////  recepción de la configuracion
/*
assign flag_fin  = (DATA_Rx == 8'hF7) ? 1'b1:1'b0;
FLIPFLOP        U12(rst,clk,flag_fin&int1,flag);
*/

assign flag_fin  = (DATOS[7:0] == 8'hF7) ? 1'b1:1'b0;
REGISTRO_CORRIMIENTO_IZQUIERDA_BYTE #(48) U13 (rst,clk,int1,DATA_Rx,DATOS);
//REGISTRO_PARALELO_HOLD              #(48) U14 (rst,clk,flag,DATOS,DATOS_R);
REGISTRO_PARALELO_HOLD_INI                U14 (rst,clk,flag_fin,DATOS[47:8],DATOS_R);
assign vr = {8'd0,DATOS_R[7:0]};

//la aplicacion manda el byte de mens peso al inicio de cada trama de 2 bytes
//  47:40   39:32    31:24    23:16

//assign b0 = {DATOS_R[39:32],DATOS_R[47:40]};
//assign b1 = {DATOS_R[23:16],DATOS_R[31:24]};
assign b0 = DATOS_R[39:24];
assign b1 = DATOS_R[23:8];

////////////////// solo envia la posicion del sensor cada 50ms
/*
wire eoBT_e;
wire [16:0]TE;
assign TE = 17'd119999;   // 10ms
UART #(11) U10(rst,clk,BR,POS[7:0],DATA_Rx,Tx,Rx,eoBT_e,eo_Tx,eo_Rx,int1);
BASE_TIEMPO #(17) U11(rst,clk,SET1,TE,eoBT_e);
*/
UART #(11) U10(rst,clk,BR,DATA_Tx,DATA_Rx,Tx,Rx,st_Tx,eo_Tx,eo_Rx,int1);
SEND_DATA U11(rst,clk,SET1,eo_Tx,refp[7:0],POS[7:0],vi_s[7:0],vd_s[7:0],QT8,QT7,QT6,QT5,QT4,QT3,QT2,QT1,DATA_Tx,st_Tx,eops);








endmodule //
