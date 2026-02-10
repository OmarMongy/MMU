module mmu_top (
    input  logic clk,
    input  logic rst_n,

    // Control
    input  logic       valid_in,
    input  logic [1:0] op_code,
    output logic       valid_out,

    // MMU data
    input  logic [7:0]  mmu_in   [0:11][0:6][0:3],
    input  logic [7:0]  mmu_w    [0:11][0:3],
    input  logic [15:0] mmu_bias [0:11][0:6],
    output logic [18:0] mmu_out  [0:6]
);
    wire sel_out;
    // ----------------------------
    // Flag controller
    // ----------------------------
    mmu_valid_ctrl u_flag_ctrl (
        .clk       (clk),
        .rst_n     (rst_n),
        .valid_in  (valid_in),
        .op_code   (op_code),
        .sel_out   (sel_out),
        .valid_out (valid_out)
    );

    // ----------------------------
    // MMU Datapath
    // ----------------------------
    mmu mmu_datapath (
        .clk       (clk),
        .rst_n     (rst_n),
        .sel       (sel_out),
        .flush     (valid_out),
        .mmu_in    (mmu_in),
        .mmu_w     (mmu_w),
        .mmu_bias  (mmu_bias),
        .mmu_out   (mmu_out)
    );

endmodule
