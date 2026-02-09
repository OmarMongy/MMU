module mmu_top (clk, rst_n, en, mmu_in, mmu_w, mmu_bias, mmu_out);

    input clk, rst_n;
    input  [7:0]  mmu_in     [0:11][0:6][0:3];
    input  [7:0]  mmu_w      [0:11][0:3];
    input  [15:0] mmu_bias   [0:11][0:6];
    input         en;
    output [18:0] mmu_out    [0:6];

    wire [15:0] pe_out       [0:11][0:6];
    wire [15:0] buff_out     [0:11][0:6];
    wire [15:0] fb_buff_out  [0:11][0:6];
    wire [15:0] acc_res      [0:11][0:6];
    wire [15:0] tree_in      [0:6][0:11];

    genvar i,j;
    generate
        for (i=0; i<12; i++) begin: PE
            PE_block PE (.in(mmu_in[i]), .w(mmu_w[i]), .bias(mmu_bias[i]), .out(pe_out[i]));
        end
        for (i=0; i<12; i++) begin: Buff
            for (j=0; j<7; j++) begin
                ff buff (.clk(clk), .rst_n(rst_n), .ena(en), .d(pe_out[i][j]), .q(buff_out[i][j]));
                ff fb_buff (.clk(clk), .rst_n(rst_n), .ena(en), .d(acc_res[i][j]), .q(fb_buff_out[i][j]));
                assign acc_res[i][j] = buff_out[i][j] + fb_buff_out[i][j];
            end
        end
        for (i=0; i<7; i++) begin
            for (j=0; j<12; j++) begin
                assign tree_in[i][j] = fb_buff_out[j][i];
            end
            adder_tree #(.N(12), .K(16)) adder_tree (.in(tree_in[i]), .sum(mmu_out[i]));
        end
    endgenerate
    
endmodule
