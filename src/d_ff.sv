module ff (clk, rst_n, d, flush, q);
    input clk;
    input rst_n;
    input flush;
    input [15:0] d;
    output reg [15:0] q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            q <= 0; 
        else  begin 
            if (flush) 
                q <= 0;
            else 
                q <= d;
            end   
        end
endmodule
