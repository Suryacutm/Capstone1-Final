module wallace_top (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] Product,
    output reg         valid_out
);

    reg [7:0] pp0_r, pp1_r, pp2_r, pp3_r, pp4_r, pp5_r, pp6_r, pp7_r;
    reg valid_s1;

    reg [15:0] sum_row_r;
    reg [15:0] carry_row_r;
    reg valid_s2;

    wire [7:0] pp0_w, pp1_w, pp2_w, pp3_w, pp4_w, pp5_w, pp6_w, pp7_w;

    partial_product pp_gen (
        .a(A), .b(B),
        .pp0(pp0_w), .pp1(pp1_w), .pp2(pp2_w), .pp3(pp3_w),
        .pp4(pp4_w), .pp5(pp5_w), .pp6(pp6_w), .pp7(pp7_w)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0_r <= 8'd0; pp1_r <= 8'd0; pp2_r <= 8'd0; pp3_r <= 8'd0;
            pp4_r <= 8'd0; pp5_r <= 8'd0; pp6_r <= 8'd0; pp7_r <= 8'd0;
            valid_s1 <= 1'b0;
        end else begin
            pp0_r <= pp0_w; pp1_r <= pp1_w; pp2_r <= pp2_w; pp3_r <= pp3_w;
            pp4_r <= pp4_w; pp5_r <= pp5_w; pp6_r <= pp6_w; pp7_r <= pp7_w;
            valid_s1 <= 1'b1;
        end
    end

    wire [15:0] shifted_pp0 = {8'd0, pp0_r};
    wire [15:0] shifted_pp1 = {7'd0, pp1_r, 1'd0};
    wire [15:0] shifted_pp2 = {6'd0, pp2_r, 2'd0};
    wire [15:0] shifted_pp3 = {5'd0, pp3_r, 3'd0};
    wire [15:0] shifted_pp4 = {4'd0, pp4_r, 4'd0};
    wire [15:0] shifted_pp5 = {3'd0, pp5_r, 5'd0};
    wire [15:0] shifted_pp6 = {2'd0, pp6_r, 6'd0};
    wire [15:0] shifted_pp7 = {1'd0, pp7_r, 7'd0};

    wire [15:0] s2_sum_val;
    wire [15:0] s2_carry_val;
    
    
    assign s2_sum_val   = shifted_pp0 ^ shifted_pp1 ^ shifted_pp2 ^ shifted_pp3 ^ 
                          shifted_pp4 ^ shifted_pp5 ^ shifted_pp6 ^ shifted_pp7;
                          
    assign s2_carry_val = (shifted_pp0 & shifted_pp1) | (shifted_pp2 & shifted_pp3) | 
                          (shifted_pp4 & shifted_pp5) | (shifted_pp6 & shifted_pp7);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_row_r   <= 16'd0;
            carry_row_r <= 16'd0;
            valid_s2    <= 1'b0;
        end else begin

            sum_row_r   <= shifted_pp0 + shifted_pp1 + shifted_pp2 + shifted_pp3;
            carry_row_r <= shifted_pp4 + shifted_pp5 + shifted_pp6 + shifted_pp7;
            valid_s2    <= valid_s1;
        end
    end
    
    wire [15:0] final_product_w;
   
    assign final_product_w = sum_row_r + carry_row_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Product   <= 16'd0;
            valid_out <= 1'b0;
        end else begin
            Product   <= final_product_w;
            valid_out <= valid_s2;
        end
    end

endmodule