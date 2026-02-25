module fsm_counter (
    input clk, rst,         // clock and reset
    input start_btn,        // from the debouncer
    input [15:0] sw_val,    // timer value from physical switches
    input slow_en,          // the 1-second metronome tick
    output reg [15:0] count // what we show on the LEDs
);

    reg state; // 0 is IDLE, 1 is COUNTDOWN

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            count <= 0;
        end else begin
            case (state)
                0: begin // IDLE: wait for button
                    if (start_btn) begin
                        count <= sw_val; // load '5'
                        state <= 1;      
                    end
                end
                
                1: begin // COUNTDOWN
                    if (count == 0) begin
                        state <= 0;      // back to idle
                    end else if (slow_en) begin 
                        // only subtract when the 1-sec tick hits
                        count <= count - 1; 
                    end
                end
            endcase
        end
    end
endmodule

