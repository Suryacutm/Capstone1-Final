`timescale 1ns / 1ps

module wallace_tb;
    reg        clk;
    reg        rst_n;
    reg  [7:0] A;
    reg  [7:0] B;
    wire [15:0] Product;
    wire       valid_out;
    reg [15:0] expected_queue [0:3]; 
    integer error_count;
    integer test_count;
    integer i;
    wallace_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .A(A),
        .B(B),
        .Product(Product),
        .valid_out(valid_out)
    );
    always #10 clk = ~clk;
    initial begin
        clk = 0;
        rst_n = 0;
        A = 0;
        B = 0;
        error_count = 0;
        test_count = 0;        
        for (i = 0; i < 4; i = i + 1) expected_queue[i] = 16'd0;
        #25; 
        rst_n = 1;
        apply_stimulus(8'h00, 8'h00);
        apply_stimulus(8'hFF, 8'hFF);
        apply_stimulus(8'hAA, 8'h55);

        $display("Starting 1000 Random Tests...");
        for (i = 0; i < 1000; i = i + 1) begin
            apply_stimulus($random % 256, $random % 256);
        end
        $display("Flushing pipeline...");
        for (i = 0; i < 4; i = i + 1) begin
            apply_stimulus(8'h00, 8'h00);
        end
        $display("========================================");
        $display("TEST SUMMARY");
        $display("Total Tests Run: %0d", test_count);
        $display("Total Errors:    %0d", error_count);
        if (error_count == 0)
            $display("STATUS: PASS");
        else
            $display("STATUS: FAIL");
        $display("========================================");
        $finish;
    end
    task apply_stimulus(input [7:0] a_in, input [7:0] b_in);
        begin
            @(posedge clk);
            A <= a_in;
            B <= b_in;
            expected_queue[3] <= expected_queue[2];
            expected_queue[2] <= expected_queue[1];
            expected_queue[1] <= expected_queue[0];
            expected_queue[0] <= a_in * b_in; // Gold Reference Model     
            test_count <= test_count + 1;
        end
    endtask
    always @(negedge clk) begin
        if (rst_n && valid_out) begin
            if (Product !== expected_queue[3]) begin
    $display("ERROR at time %0t: Expected %0d, Got %0d", 
             $time, expected_queue[3], Product); 
    error_count = error_count + 1;
          end
        end
    end
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, wallace_tb);
    end
endmodule