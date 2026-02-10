module mmu_valid_ctrl (
input  logic        clk,
input  logic        rst_n,

input  logic        valid_in,
input  logic [1:0]  op_code,
  
output logic        sel_out,  
output logic        valid_out
);
// Pipeline registers
logic valid_d1;
logic valid_d2;
always_ff @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            valid_d1    <= 1'b0;
            valid_d2    <= 1'b0;     
        end else begin
                if (valid_in) begin
                    valid_d1    <= valid_in;
                    valid_d2    <= valid_d1;
            end
                else begin
                    valid_d1    <= 0;
                    valid_d2    <= valid_d1;                    
                end         
        end
    end

 // Output valid selection
always_ff @(posedge clk or negedge rst_n) begin
     if (!rst_n) begin
         valid_out <= 1'b0;
         sel_out   <= 1'b0;
     end else begin
         case (op_code)
             2'b00,
             2'b01: begin
                 valid_out <= valid_d1;
                 sel_out   <= 1'b0;
             end
 
             2'b10,
             2'b11: begin
                 sel_out <= 1'b1;
                 if (valid_d2)
                     valid_out <= ~valid_out;  // clean toggle
                 else
                     valid_out <= 1'b0;        // or hold, based on spec
             end
 
             default: begin
                 valid_out <= 1'b0;
                 sel_out   <= 1'b0;
             end
         endcase
     end
 end

endmodule
