module FSM_SAR
(
  input rst,
  input clk,
  input stp,
  input zi,
  output reg clc,
  output reg hs,
  output reg hp,
  output reg hf,
  output reg eop
  );

  reg [1:0] Qp, Qn;

  always @ (Qp, stp, zi) begin
      case(Qp)

          2'b00:begin
          clc = 1'b1;
          hs  = 1'b0;
          hp  = 1'b0;
          hf  = 1'b0;
          eop = 1'b1;
          if(stp == 1'b1)
            Qn = 2'b01;
          else
            Qn = 2'b00;
          end
/*
          2'b01:begin
          clc = 1'b0;
          hs  = 1'b0;
          hp  = 1'b1;
          hf  = 1'b0;
          eop = 1'b0;
          Qn = 2'b10;
          end

  */
          2'b01:begin
          clc = 1'b0;
          hs  = 1'b1;
          hp  = 1'b1;
          hf  = 1'b0;
          eop = 1'b0;
          if (zi == 1'b1)
            Qn = 2'b10;
          else
            Qn = 2'b01;
          end

          default:begin
          clc = 1'b0;
          hs  = 1'b0;
          hp  = 1'b0;
          hf  = 1'b1;
          eop = 1'b0;
          Qn = 2'b00;
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
