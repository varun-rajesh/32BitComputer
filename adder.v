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
  assign c = c_in ^ (a ^ b);
  assign c_out = (c_in & (a ^ b)) | (a & b);
endmodule
