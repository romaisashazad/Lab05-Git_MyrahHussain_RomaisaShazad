`timescale 1ns / 1ps

module tb_fsm();
    reg clk;
    reg rst;
    reg start_btn;
    reg [15:0] sw_val;
    wire [15:0] count;

    // connect unit under test
    fsm_counter uut (
        .clk(clk),
        .rst(rst),
        .start_btn(start_btn),
        .sw_val(sw_val),
        .count(count)
    );

    // 100MHz clock
    always #5 clk = ~clk;

    initial begin
        // init signals
        clk = 0; rst = 1; start_btn = 0; sw_val = 16'h0000;
        #20 rst = 0; // release reset

        // test countdown from 5
        sw_val = 16'd5;
        #10 start_btn = 1; // hit start
        #10 start_btn = 0; 

        // wait for zero
        wait(count == 0);
        #50;

        $finish; // end sim
    end
endmodule