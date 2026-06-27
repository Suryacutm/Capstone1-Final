module partial_product (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7
);

    assign pp0 = a & {8{b[0]}};
    assign pp1 = a & {8{b[1]}};
    assign pp2 = a & {8{b[2]}};
    assign pp3 = a & {8{b[3]}};
    assign pp4 = a & {8{b[4]}};
    assign pp5 = a & {8{b[5]}};
    assign pp6 = a & {8{b[6]}};
    assign pp7 = a & {8{b[7]}};
endmodule