//32 bit adder
module add(input[31 : 0] a, b, input c_in, output[31 : 0] c, output overflow);
  wire[7:0] c_out;

  //Size of adder
  parameter N = 32 / 4;
  genvar i;

  assign overflow = c_out[7];

  generate
    for(i = 0; i < N; i = i + 1) begin
      if(i == 0) begin
        qb_add qba(
          .a (a[3 : 0]),
          .b (b[3 : 0]),
          .c_in (c_in),
          .c (c[3 : 0]),
          .c_out (c_out[0])
        );
      end else begin
        qb_add qba(
          .a (a[4 * i + 3 : 4 * i]),
          .b (b[4 * i + 3 : 4 * i]),
          .c_in (c_out[i - 1]),
          .c (c[4 * i + 3 : 4 * i]),
          .c_out (c_out[i])
        );
      end
    end
  endgenerate
endmodule

//4 bit carry look ahead adder
module qb_add(input[3 : 0] a, input[3 : 0] b, input c_in, output[3 : 0] c, output c_out);
  wire[3 : 0] p;
  wire[3 : 0] g;
  wire[3 : 0] carry;

  assign p = a ^ b;
  assign g = a & b;

  assign carry[0] = c_in;
  assign carry[1] = g[0] | (p[0] & carry[0]);
  assign carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[0]);
  assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & carry[0]);
  assign c_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & carry[0]);

  assign c = p ^ carry;
endmodule
