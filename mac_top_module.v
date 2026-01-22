module mac_compare (
    input wire clk,
    input wire rst_n,
    input wire [15:0] A,      // 16-bit Input
    input wire [15:0] B,      // 16-bit Input
    output reg [31:0] Out_NonPipe,
    output reg [31:0] Out_Pipe
);

    // ==========================================
    // 1. Non-Pipelined MAC (One Cycle)
    // ==========================================
    // Logic: Out = Out + (A * B)
    // The Critical Path is: Mult -> Add -> Setup Time
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            Out_NonPipe <= 0;
        else 
            Out_NonPipe <= Out_NonPipe + (A * B);
    end

    // ==========================================
    // 2. Pipelined MAC (Two Stages)
    // ==========================================
    
    // Stage 1 Registers
    reg [31:0] mult_stage_reg;
    reg [31:0] pipe_acc_reg; // Accumulator for pipeline

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mult_stage_reg <= 0;
            Out_Pipe       <= 0;
        end else begin
            // Stage 1: Multiplication
            mult_stage_reg <= A * B; 
            
            // Stage 2: Accumulation (Uses the result from previous cycle)
            Out_Pipe       <= Out_Pipe + mult_stage_reg; 
        end
    end

endmodule
