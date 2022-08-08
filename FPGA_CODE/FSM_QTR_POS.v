module FSM_QTR_POS
 (
   input rst,
   input clk,
   input stp,
   input eo_bt,
   input eo_div,
   output reg st_sen,
   output reg st_bt,
   output reg st_div,
   output reg h,
   output reg eop
   );

   reg [2:0] Qp, Qn;

   always @ (Qp, stp, eo_bt, eo_div)
   begin

        case(Qp)

        3'b000:begin
        st_sen = 1'b0;
        st_bt  = 1'b0;
        st_div = 1'b0;
        h      = 1'b0;
        eop    = 1'b1;
        if(stp == 1'b1)
          Qn = 3'b001;
        else
          Qn = Qp;
        end

        3'b001:begin
        st_sen = 1'b1;
        st_bt  = 1'b1;
        st_div = 1'b0;
        h      = 1'b0;
        eop    = 1'b0;
          Qn = 3'b010;
        end

        3'b010:begin
        st_sen = 1'b0;
        st_bt  = 1'b1;
        st_div = 1'b0;
        h      = 1'b0;
        eop    = 1'b0;
        if(eo_bt == 1'b1)
          Qn = 3'b011;
        else
          Qn = Qp;
        end

        3'b011:begin
        st_sen = 1'b0;
        st_bt  = 1'b0;
        st_div = 1'b0;
        h      = 1'b1;
        eop    = 1'b0;
          Qn = 3'b100;
        end

        3'b100:begin
        st_sen = 1'b0;
        st_bt  = 1'b0;
        st_div = 1'b1;
        h      = 1'b0;
        eop    = 1'b0;
          Qn = 3'b101;
        end

        default:begin
        st_sen = 1'b0;
        st_bt  = 1'b0;
        st_div = 1'b0;
        h      = 1'b0;
        eop    = 1'b1;
        if(eo_div == 1'b1)
          Qn = 3'b000;
        else
          Qn = Qp;
        end

        endcase
   end


  always @ (posedge clk or posedge rst)
  begin
  if(rst == 1'b1)
    Qp <= 0;
  else
    Qp <= Qn;
  end
endmodule
