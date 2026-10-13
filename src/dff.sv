module DFF #(
	parameter WIDTH = 1
)
  (clk,WE,SR, d,q);
  input wire clk,WE,SR;
  input wire [WIDTH-1:0] d;
  output reg [WIDTH-1:0] q;
  
  always@(posedge clk) 
    begin
      q <= (SR == 1'b1)? {WIDTH{1'b0}}  :   // if reset 
     	   (WE == 1'b1)? d     :  q ;   //if WE take d otherwise keep q
      
    end 
  
  endmodule
