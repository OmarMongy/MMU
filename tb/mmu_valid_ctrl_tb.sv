`timescale 1ns / 1ps

module mmu_valid_ctrl_tb;

    // ----------------------------
    // DUT signals
    // ----------------------------
    logic        clk;
    logic        rst_n;
    logic        valid_in;
    logic [2:0]  op_code;
    logic [1:0]  stage;
    logic        valid_out;
    logic        flush;
    // ----------------------------
    // Instantiate DUT
    // ----------------------------
    mmu_valid_ctrl dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .valid_in  (valid_in),
        .op_code   (op_code),
        .stage     (stage),
        .flush     (flush),
        .valid_out (valid_out)
    );

    always #5 clk = ~clk;
  
    initial begin
        clk      = 0;
        rst_n    = 0;
        valid_in = 0;
        op_code  = 'hx;
        stage    = 'hx;
        repeat(5) @(posedge clk);
        rst_n    = 1;
        repeat(5) @(posedge clk);
        @(posedge clk)       
        valid_in = 1;
        stage    = 2'b00; // <----- control the stage from here!
        op_code  = 3'b000;
        wait(valid_out == 1);
        $display("OP-CODE = ,0 Pass!");
        //repeat(5) @(posedge clk);
        valid_in = 0;
        repeat(5) @(posedge clk);
        @(posedge clk)       
        valid_in = 1;
        op_code  = 3'b001;
        wait(valid_out == 1);
        $display("OP-CODE = ,1 Pass!");
        //repeat(5) @(posedge clk);
        valid_in = 0;
        repeat(5) @(posedge clk);
        @(posedge clk)       
        valid_in = 1;
        op_code  = 3'b101;
        wait(valid_out == 1);
        $display("OP-CODE = ,2 Pass!");
        //repeat(5) @(posedge clk);
        valid_in = 0;
        wait(valid_out == 1);
        repeat(5) @(posedge clk);
        @(posedge clk)       
        valid_in = 1;
        op_code  = 3'b010;
        wait(valid_out == 1);
        $display("OP-CODE = ,3 Pass!");
        //repeat(5) @(posedge clk);
        valid_in = 0;
        repeat(5) @(posedge clk);
        @(posedge clk)       
        valid_in = 1;
        op_code  = 3'b011;
        wait(valid_out == 1);
        $display("OP-CODE = ,4 Pass!");
        //repeat(5) @(posedge clk);
        valid_in = 0;
        repeat(5) @(posedge clk);
        #10;                                                                 
        $stop;                         
    end

endmodule
