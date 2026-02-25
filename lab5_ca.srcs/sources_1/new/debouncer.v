module debouncer(
    input clk,          // system clock
    input pbin,         // raw button input
    output reg pbout    // clean button output signal
);

   reg [19:0] timer;
    reg [1:0] sync; // sync the human button press to the computer clock to prevent logic errors 

    always @(posedge clk) begin
        // Shift register for syncing
        sync <= {sync[0], pbin};  // for every clock tick it pulls the current state of pbin

        // If output matches input, reset timer. Otherwise, count up.
        if (sync[1] == pbout)    //checks if current button state mathces the last stable output
            timer <= 0;            //if they match, reset the timer
            
        else if (timer == 20'hFFFFF)      // timer reached max value
            pbout <= sync[1]; // Final stable state reached
        else 
            timer <= timer + 1;
    end
endmodule
