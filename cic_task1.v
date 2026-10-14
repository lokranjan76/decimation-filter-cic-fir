// TASK 1: standalone CIC with 20-bit output. Round + drop 13 LSBs (largest shift-free scale that never clips).
module cic_task1 (
    input  wire clk, reset, enable,
    input  wire signed [1:0] din,
    output reg  signed [19:0] dout,
    output reg  valid
);
    wire signed [34:0] y; wire v;
    cic3 u (.clk(clk), .reset(reset), .enable(enable), .din(din), .dout(y), .valid(v));
    wire signed [34:0] r = y + 35'sd4096;          // +2^12 rounding
    always @(posedge clk) begin
        valid <= v;
        if (v) dout <= r[32:13];
    end
endmodule
