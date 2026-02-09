module mmu_valid_ctrl (
input  logic        clk,
input  logic        rst_n,

input  logic        valid_in,
input  logic [1:0]  op_code,

output logic        valid_out
);
// Pipeline registers
logic valid_d1;
logic valid_d2;
logic valid_d3;
logic [1:0] op_code_reg1;
logic [1:0] op_code_reg2;
 always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            valid_d1    <= 1'b0;
            valid_d2    <= 1'b0;
            valid_d3    <= 1'b0; 
            op_code_reg1 <= 2'b00; 
            op_code_reg2 <= 2'b00;          
        end else begin
            valid_d1     <= valid_in;
            op_code_reg1 <= op_code;
            op_code_reg2 <= op_code_reg1;
            valid_d2     <= valid_d1;
            valid_d3     <= valid_d2;
        end
    end

 // Output valid selection
always_comb begin
        case (op_code_reg2)
            2'b00: valid_out = valid_d2; // 1-cycle latency
            2'b01: valid_out = valid_d2; // 1-cycle latency
            2'b10: valid_out = valid_d3; // 2-cycle latency
            2'b11: valid_out = valid_d3; // 2-cycle latency
            default: valid_out = 1'b0;
        endcase
    end
endmodule
