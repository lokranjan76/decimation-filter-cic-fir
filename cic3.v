// 3rd-order CIC decimator, R=2048, M=1. Input: 2-bit signed. Hogenauer width = 3*log2(2048)+2 = 35 bits.
// Integrators wrap (two's complement) on purpose; combs cancel the wrap.
module cic3 #(parameter W = 35, parameter R = 2048) (
    input  wire              clk, reset, enable,
    input  wire signed [1:0] din,
    output reg  signed [W-1:0] dout,   // full-precision comb output
    output reg               valid     // 1-cycle strobe, once per R inputs
);
    reg signed [W-1:0] i1, i2, i3;                 // integrators (fast clock)
    reg signed [W-1:0] d1, d2, d3;                 // comb delays (slow rate)
    reg [11:0] cnt;                                // counts 0..R-1

    wire signed [W-1:0] n1 = i1 + din;             // chained so result == ideal cumsum^3
    wire signed [W-1:0] n2 = i2 + n1;
    wire signed [W-1:0] n3 = i3 + n2;
    wire last = (cnt == R-1);

    wire signed [W-1:0] c1 = n3 - d1;              // combs (evaluated only when 'last')
    wire signed [W-1:0] c2 = c1 - d2;
    wire signed [W-1:0] c3 = c2 - d3;

    always @(posedge clk) begin
        if (reset) begin
            i1<=0; i2<=0; i3<=0; d1<=0; d2<=0; d3<=0; cnt<=0; dout<=0; valid<=0;
        end else begin
            valid <= 1'b0;
            if (enable) begin
                i1 <= n1; i2 <= n2; i3 <= n3;
                if (last) begin
                    cnt <= 0;
                    d1 <= n3; d2 <= c1; d3 <= c2;
                    dout <= c3; valid <= 1'b1;
                end else cnt <= cnt + 1'b1;
            end
        end
    end
endmodule
