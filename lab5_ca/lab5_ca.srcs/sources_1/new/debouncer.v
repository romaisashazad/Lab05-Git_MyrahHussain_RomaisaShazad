module debouncer(
    input clk,          // system clock
    input pbin,         // raw button input
    output reg pbout    // clean button output
);

    reg [19:0] count;   // timer for stability check
    reg sync_0, sync_1; // sync regs to stop metastability

    // sync input to clock domain
    always @(posedge clk) begin
        sync_0 <= pbin; // first stage
        sync_1 <= sync_0; // second stage
    end

    // check if input is stable
    always @(posedge clk) begin
        if (sync_1 == pbout) begin
            count <= 0; // reset timer if no change
        end else begin
            count <= count + 1; // start counting if input toggles
            if (count == 20'hFFFFF) begin 
                pbout <= sync_1; // update output after delay
                count <= 0;      // reset timer
            end
        end
    end

endmodule