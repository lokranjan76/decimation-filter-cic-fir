// 3-tap symmetric inverse-sinc compensator at the decimated rate. Gain folded into coefficients
// so the largest benchmark tone uses ~98.5% of the 20-bit range. Output is 20 bits.
module fir3 #(parameter signed [21:0] C0 = -22'sd530538, C1 = 22'sd1768461) (  // taps: C0, C1, C0
    input  wire clk, reset,
    input  wire signed [24:0] din,   // CIC output >>> 10
    input  wire en,
    output reg  signed [19:0] dout,
    output reg  valid
);
    reg signed [24:0] x1, x2;
    wire signed [25:0] outer = din + x2;
    wire signed [49:0] acc = C0 * outer + C1 * x1;     // 22b x 26b / 22b x 25b
    wire signed [49:0] rnd = acc + 50'sd2097152;       // +2^21
    always @(posedge clk) begin
        if (reset) begin x1<=0; x2<=0; dout<=0; valid<=0; end
        else begin
            valid <= en;
            if (en) begin
                x2 <= x1; x1 <= din;
                dout <= rnd[41:22];
            end
        end
    end
endmodule
