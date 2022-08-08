module FSM_QTR_RC
(
  input rst,
  input clk,
  input stp,
  input eoBT,
  input full,
  input ECO,
  output reg TRIGER,
  output reg stBT,
  output reg h,
  output reg [1:0] opc,
  output reg eop
  );

reg [2:0] Qp, Qn;
always @ (Qp, stp, ECO,full,eoBT)
begin

    case (Qp)

      3'b000: begin
      TRIGER = 1'b0;
      stBT   = 1'b0;
      h      = 1'b0;
      opc    = 2'b11;
      eop    = 1'b1;
      if (stp == 1'b1)
        Qn = 3'b001;
      else
        Qn = Qp;
      end

/////////////////////////// ACTIVACION DEL TRIGGER
      3'b001: begin
      TRIGER = 1'b1;
      stBT   = 1'b1;
      h      = 1'b0;
      opc    = 2'b00;
      eop    = 1'b0;
      if (eoBT == 1'b1)
        Qn = 3'b010;
      else
        Qn = Qp;
      end

////////////////////////////////////////////////////////////////////////

///////////////////////////// ESPERA DE SUBIDA DE ECO
      3'b010: begin
      TRIGER = 1'b0;
      stBT   = 1'b0;
      h      = 1'b0;
      opc    = 2'b11;
      eop    = 1'b0;
      if (ECO == 1'b1)
        Qn = 3'b011;
      else
        Qn = Qp;
      end
//////////////////////////////////////////////////////////////////////


      3'b011: begin      // CUENTA DE 1us
      TRIGER = 1'b0;
      stBT   = 1'b1;
      h      = 1'b0;
      opc    = 2'b00;
      eop    = 1'b0;
      if (eoBT == 1'b1)
        Qn = 3'b100;
      else
        Qn = Qp;
      end

      3'b100: begin    // pregunta si ya paso mas de 20ms
      TRIGER = 1'b0;
      stBT   = 1'b1;
      h      = 1'b0;
      opc    = 2'b01;
      eop    = 1'b0;
      if(full == 1'b1)
        Qn = 3'b110;
      else
        Qn = 3'b101;
      end


      3'b101: begin    // espera a que baje ECO
      TRIGER = 1'b0;
      stBT   = 1'b1;
      h      = 1'b0;
      opc    = 2'b00;
      eop    = 1'b0;
      if(ECO == 1'b0)
        Qn = 3'b110;
      else
        Qn = 3'b011;
      end

      default: begin
      TRIGER = 1'b0;
      stBT   = 1'b0;
      h      = 1'b1;
      opc    = 2'b00;
      eop    = 1'b0;
        Qn = 3'b000;
      end

    endcase
end
always @ ( posedge clk or posedge rst )
  begin
    if(rst == 1'b1)
      Qp <= 0;
    else
      Qp <= Qn;
  end

endmodule //
