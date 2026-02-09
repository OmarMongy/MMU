module ff (clk, rst_n, d, q);
    input clk;
    input rst_n;
    input ena,
    input [15:0] d;
    output reg [15:0] q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            q <= 0; 
        else if (ena) 
            q <= d;
        else 
            q =< q;    
        end
endmodule
