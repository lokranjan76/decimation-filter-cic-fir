`timescale 1ns / 1ps
// Your provided testbench, adapted: instantiates both designs and writes the txt files.
// ONE run = ONE tone. Edit the 3 lines marked  <<< EDIT  for each tone (10 / 500 / 990).
module cic_tb();
    reg data [0:4096025];
    reg clk, reset, enable;
    reg signed [1:0] bits;

    wire signed [19:0] y1, y2;          // 20-bit outputs of Task 1 and Task 2
    wire v1, v2;                        // 1-cycle "output ready" strobes (once per 2048 inputs)

    initial $readmemh("hz10.mem", data);           // <<< EDIT: input tone file
    integer fd1, fd2, i;
    initial begin
        fd1 = $fopen("t1_10.txt", "w");            // <<< EDIT: Task 1 output name
        fd2 = $fopen("t2_10.txt", "w");            // <<< EDIT: Task 2 output name
        clk=0; bits=0; enable=0; reset=1; i=0;
        #51 reset=0; enable=1;
    end
    always #50 clk = ~clk;

    // DUTs (same input stream for both)
    cic_task1      dut1 (.clk(clk), .reset(reset), .enable(enable), .din(bits), .dout(y1), .valid(v1));
    cic_fir_task2  dut2 (.clk(clk), .reset(reset), .enable(enable), .din(bits), .dout(y2), .valid(v2));

    // Same input trick as the provided tb (even: {0,d}, odd: {d,d}); non-blocking to avoid a race with the DUT
    always @(posedge clk) begin
        if (i < 4096026) begin
            if (i%2==0) bits <= {1'b0, data[i]};
            else        bits <= {2{data[i]}};
            i <= i + 1;
        end else begin
            #2000; $fclose(fd1); $fclose(fd2); $finish;
        end
    end
    always @(posedge clk) if (v1) $fwrite(fd1, "%0d\n", y1);
    always @(posedge clk) if (v2) $fwrite(fd2, "%0d\n", y2);
endmodule
