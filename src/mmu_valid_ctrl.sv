/*
    op-code:
        000 -> conv  => 1 cycle latency
        001 -> FC    => 2 Layers -> 1st layer = 2 cycles, 2 / -> Q,K,V => same as FC  1st layer
        101 -> FC    => 2 Layers -> 2nd layer = 4 * 1st layer cycles
        010 -> QxKT  => 1 cycle  latency
        011 -> SxV   => 2 cycles latency       
    stage:
        00 -> 1st stage, input width 48 *2
        01 -> 2nd stage, input width 48 *4
        10 -> 3rd stage, input width 48 *8
        11 -> 4th stage, input width 48 *16 
*/
module mmu_valid_ctrl (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        valid_in,
    input  logic [2:0]  op_code,
    input  logic [1:0]  stage,
    output logic        flush,
    output logic        valid_out
);

logic [6:0] count_mod;
logic [6:0] counter;
logic       busy;
logic       valid_d;          // 1-cycle delayed input => streaming cases
logic [2:0] op_latched;
logic [1:0] st_latched;
// 1-cycle streaming path (conv or QxKT)
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        valid_d <= 0;
    else
        valid_d <= valid_in;
end
// Decode latency for pulse mode
always_comb begin
    count_mod = 1;
    case(op_code)
        3'd1, 3'd5: begin  // FC layers
            count_mod = 2 << stage;     // stage scaling
            if (op_code[2])             // 2nd layer
                count_mod = count_mod * 4;
        end
        3'd3: count_mod = 2;            // SxV -> ثابت في كل الـستيجس
    endcase
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter     <= 0;
        busy        <= 0;
        valid_out   <= 0;
        op_latched  <= 0;
        st_latched  <= 0;
    end 
    else begin
        valid_out <= 0;
        // Streaming mode -> conv and QxKT
        if (op_code == 3'd0 || op_code == 3'd2) begin
            valid_out <= valid_d;  // 1-cycle delay
            busy      <= 0;
        end
        // Latency pulse mode for other opcodes
        else begin
            // FINISH!! condition
            if (busy && counter == count_mod-1) begin
                valid_out <= 1;
                if (valid_in) begin
                    counter    <= 0;
                    op_latched <= op_code;
                    st_latched <= stage;
                    busy       <= 1;
                end
                else begin
                    busy <= 0;
                end
            end
            // counting
            else if (busy) begin
                counter <= counter + 1;
            end
            else if (valid_in) begin
                busy       <= 1;
                counter    <= 0;
                op_latched <= op_code;
                st_latched <= stage;
            end
        end
    end
end
 // Flsuher logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        flush <= 1'b0;
    else
        flush <= 1'b0;   // deassert at every rising edge
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n)
        flush <= 1'b0;
    else if (valid_out)
        flush <= 1'b1;   // assert at falling edge of valid_out cycle
end
endmodule
