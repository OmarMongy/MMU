module ff (clk, rst_n, d, q);
    input clk;
    input rst_n;
    input [15:0] d;
    output reg [15:0] q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end
    
endmodule