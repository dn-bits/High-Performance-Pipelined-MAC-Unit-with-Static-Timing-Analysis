`timescale 1ns / 1ps

module tb_mac_compare;

    reg clk, rst_n;
    reg [15:0] A, B;
    wire [31:0] Out_NonPipe;
    wire [31:0] Out_Pipe;

    mac_compare uut (
        .clk(clk), .rst_n(rst_n), 
        .A(A), .B(B), 
        .Out_NonPipe(Out_NonPipe), .Out_Pipe(Out_Pipe)
    );

    always #5 clk = ~clk; // 100 MHz Clock

    initial begin
        clk = 0; rst_n = 0; A = 0; B = 0;
        #20 rst_n = 1;

        // Test 1: 2 * 3 = 6
        @(posedge clk); A = 2; B = 3;
        
        // Test 2: 4 * 5 = 20 (Accumulate: 6 + 20 = 26)
        @(posedge clk); A = 4; B = 5;
        
        // Test 3: 10 * 10 = 100 (Accumulate: 26 + 100 = 126)
        @(posedge clk); A = 10; B = 10;

        @(posedge clk); A = 0; B = 0; // Stop inputs

        #50;
        $stop;
    end
endmodule
