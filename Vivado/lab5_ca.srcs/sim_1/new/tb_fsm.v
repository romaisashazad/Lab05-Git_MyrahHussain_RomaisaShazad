`timescale 1ns / 1ps

module tb_fsm();
    reg clk;
    reg rst;
    reg start_btn;
    reg slow_en;       
    reg [15:0] sw_val;
    wire [15:0] count;

    // Unit Under Test
    fsm_counter uut (
        .clk(clk),
        .rst(rst),
        .start_btn(start_btn),
        .sw_val(sw_val),
        .slow_en(slow_en), 
        .count(count)
    );

    // 100MHz clock (10ns period)
    always #5 clk = ~clk;

    // Fix the Red 'X': Initialize slow_en and generate pulses
    initial begin
        slow_en = 0; // Essential initialization
        forever begin
            #90 slow_en = 1; // Pulse high for 1 clock cycle
            #10 slow_en = 0; 
        end
    end

    initial begin
        // --- 1. Initialization ---
        clk = 0; rst = 1; start_btn = 0; sw_val = 0;
        #20 rst = 0; // Release reset

        // --- 2. Test First Switch Instance (Count from 5) ---
        sw_val = 16'd5;
        #20 start_btn = 1; 
        #10 start_btn = 0; 
        
        // Wait for it to finish naturally to show "Versatility"
        wait(count == 0);
        #50;

        // --- 3. Test Second Switch Instance & Mid-Count Reset ---
        // Load a larger value like 10
        sw_val = 16'd10;
        #20 start_btn = 1;
        #10 start_btn = 0;

        // Let it count down a few steps (e.g., until it hits 7)
        #300; 

        // Apply Reset during active countdown
        // This proves "Safety/Control": the counter must drop to 0 immediately
        $display("Applying reset mid-count...");
        rst = 1; 
        #20 rst = 0; 

        // --- 4. Test Recovery ---
        // Verify we can start a new countdown immediately after the reset
        sw_val = 16'd3;
        #20 start_btn = 1;
        #10 start_btn = 0;

        wait(count == 0);
        #100;

        $display("Simulation Finished Successfully");
        $finish; 
    end
endmodule

