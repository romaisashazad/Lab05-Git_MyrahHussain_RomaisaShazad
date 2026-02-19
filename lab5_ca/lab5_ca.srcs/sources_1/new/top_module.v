module top_module (
    input clk,
    input rst_pin,
    input start_pin,
    input [15:0] physical_switches,
    output [15:0] physical_leds
);

    wire debounced_start;
    wire [15:0] current_count;
    reg start_delay;
    wire start_pulse;

    // clean up button noise
    debouncer u_debouncer (
        .clk(clk),
        .pbin(start_pin),
        .pbout(debounced_start)
    );

    // edge detector to get 1-cycle pulse
    always @(posedge clk) begin
        start_delay <= debounced_start;
    end
    assign start_pulse = debounced_start && !start_delay; 

    // main logic
    fsm_counter u_fsm (
        .clk(clk),
        .rst(rst_pin),
        .start_btn(start_pulse), 
        .sw_val(physical_switches),
        .count(current_count)
    );

    // drive leds
    leds u_leds (
        .clk(clk),
        .rst(rst_pin),
        .switches(physical_switches),
        .readData({16'b0, current_count}), 
        .leds(physical_leds)      
    );

endmodule