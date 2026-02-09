module adder_tree #(parameter N=12, parameter K=15)(in,sum);

input  [K-1:0] in [0:N-1];
output [K+$clog2(N)-1:0] sum;

//number of stages
localparam stages = $clog2(N);

//declaration of stage's adder inputs
wire [K+$clog2(N)-1:0] stage_in [0:stages][0:N-1];

//assign inputs to first stage
genvar i,level;
generate
    for (i=0; i<N ; i=i+1) begin
        assign stage_in[0][i] = in[i];
    end    
endgenerate 

// adder tree logic generation
generate 
    for (level = 0; level < stages; level = level + 1) begin : STAGE
        for (i = 0; i < N; i = i + (2<<level)) begin : ADDER
            if (i + (1 << level) < N) // Ensure valid index
                assign stage_in[level+1][i] = stage_in[level][i] + stage_in[level][i + (1 << level)];
            else
                assign stage_in[level+1][i] = stage_in[level][i]; // Pass unchanged if no pair
        end
    end
endgenerate

assign sum = stage_in[stages][0];
endmodule
