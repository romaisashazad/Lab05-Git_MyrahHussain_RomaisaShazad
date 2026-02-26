module top_module (
    input clk,                      
    input rst_pin,                  
    input start_pin,                
    input [15:0] physical_switches, 
    output [15:0] physical_leds     
);

    // internal wires
    wire debounced_start;           
    wire [15:0] current_count;      
    reg start_delay;                
    wire start_pulse;               
    wire [31:0] sw_bus_data;       
    
    // clock divider
    reg [26:0] clk_div;             
    wire slow_en;                   

    always @(posedge clk) begin
        if (rst_pin) clk_div <= 0;
        else if (clk_div >= 100_000_000) clk_div <= 0;
        else clk_div <= clk_div + 1;
    end
    assign slow_en = (clk_div == 100_000_000);

    // clean button noise
    debouncer u_debouncer (
        .clk(clk),
        .pbin(start_pin),
        .pbout(debounced_start)
    );

    // edge detector
    always @(posedge clk) begin
        start_delay <= debounced_start;
    end
    assign start_pulse = debounced_start && !start_delay; 

    // Switch Interface: Grabs physical switches and puts them on sw_bus_data
    switches sw_inst (
        .clk(clk),
        .rst(rst_pin),
        .writeData(32'b0),
        .writeEnable(1'b0),
        .readEnable(1'b1),
        .memAddress(30'b0),
        .readData(sw_bus_data),     // This is the 32-bit output
        .leds(physical_switches)    // This is the 16-bit input from board
    );

    //  FSM Counter: Takes switch values from the bus and counts down
    fsm_counter u_fsm (
        .clk(clk),
        .rst(rst_pin),
        .slow_en(slow_en),        
        .start_btn(start_pulse), 
        .sw_val(sw_bus_data[15:0]), // Use the data from the switch interface
        .count(current_count)       // Output current value
    );

    // (c) LED Interface: Displays the 'current_count' on physical LEDs
    leds u_leds (
        .clk(clk),
        .rst(rst_pin),
        .btns(16'b0),             
        .writeData(32'b0),        
        .writeEnable(1'b0),       
        .readEnable(1'b1),        
        .memAddress(30'b0),
        .switches(current_count),   // Connect FSM output to LED input
        .readData(),                
        .leds(physical_leds)        // Drive the actual board lights
    );

endmodule  
