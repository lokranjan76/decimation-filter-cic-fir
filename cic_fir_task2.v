// TASK 2: CIC (N=3,R=2048,M=1) -> >>>10 -> 3-tap droop compensator -> 20-bit output.
module cic_fir_task2 (
    input  wire clk, reset, enable,
    input  wire signed [1:0] din,
    output wire signed [19:0] dout,
    output wire valid
);
    wire signed [34:0] y; wire v;
    cic3 u0 (.clk(clk), .reset(reset), .enable(enable), .din(din), .dout(y), .valid(v));
    fir3 u1 (.clk(clk), .reset(reset), .din(y[34:10]), .en(v), .dout(dout), .valid(valid));
endmodule
