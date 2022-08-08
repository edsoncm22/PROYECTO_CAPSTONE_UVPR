module COMPARADOR_SAR #(
  parameter n = 8
  )
  (
    input [n-1:0] D,
    input [n-1:0] C,
    output reg [1:0] EG
    );

  always @ (D, C) begin
    if (D < C)
      EG = 2'b00;
    else if (D > C)
      EG = 2'b01;
    else
      EG = 2'b10;
  end
  
endmodule //
