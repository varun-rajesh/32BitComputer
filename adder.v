//32 bit adder
module add(input[31:0] a, b, output[31:0] c);
  wire[31:0] c_out;

  //Size of adder
  parameter N=32;
  genvar i;

  generate
    for(i = 0; i < N; i = i + 1) begin
      if(i == 0) begin
        //Half adder
        sb_add sba(
          .a (a[0]),
          .b (b[0]),
          .c_in (1'b0),
          .c (c[0]),
          .c_out (c_out[0])
        );
      end else begin
        //Full adder
        sb_add sba(
          .a (a[i]),
          .b (b[i]),
          .c_in (c_out[i - 1]),
          .c (c[i]),
          .c_out (c_out[i])
        );
      end
    end
  endgenerate
endmodule

//Single bit adder
module sb_add(input a, b, c_in, output reg c, c_out);
  always @ * c <= #14 c_in ^ (a ^ b);
  always @ * c_out <= #24 (c_in & (a ^ b)) | (a & b);
endmodule

//4 bit carry look ahead adder
module qb_add(input[3:0] a, input[3:0] b, input c_in, output[3:0] c, output c_out);
  wire[3:0] p;
  wire[3:0] g;
  wire[3:0] carry;

  assign p = a ^ b;
  assign g = a & b;

  assign carry[0] = c_in;
  assign carry[1] = g[0] | (p[0] & carry[0]);
  assign carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[0]);
  assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & carry[0]);
  assign c_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & carry[0]);

  assign c = p ^ carry;
endmodule
