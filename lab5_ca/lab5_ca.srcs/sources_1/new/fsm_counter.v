module fsm_counter (
    input clk,              // system clock
    input rst,              // reset signal
    input start_btn,        // button pulse from debouncer
    input [15:0] sw_val,    // switch input value
    output reg [15:0] count,// 16-bit countdown register
    output reg [1:0] state  // state monitor for debug
);

    // states
    localparam IDLE      = 1'b0; // wait state
    localparam COUNTDOWN = 1'b1; // active state

    reg current_state, next_state; // state registers

    // update current state
    always @(posedge clk or posedge rst) begin
        if (rst) 
            current_state <= IDLE; // go to idle on reset
        else 
            current_state <= next_state; // move to next state on clock
    end

    // logic for next state
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (start_btn) next_state = COUNTDOWN; // start if button pressed
                else           next_state = IDLE;      // stay in idle
            end
            COUNTDOWN: begin
                if (count == 0) next_state = IDLE;      // return home when finished
                else            next_state = COUNTDOWN; // keep counting
            end
            default: next_state = IDLE; // safety default
        endcase
    end

    // counter handling
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0; // clear count on reset
        end else begin
            if (current_state == IDLE && start_btn) begin
                count <= sw_val; // load switches into counter
            end else if (current_state == COUNTDOWN && count > 0) begin
                count <= count - 1; // subtract one each cycle
            end
        end
    end

endmodule