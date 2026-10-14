# Decimation Filter: CIC + FIR Droop Compensator

Inter-IIT VLSI bootcamp, IIT Guwahati.

## Design
- CIC: N=3, R=2048, M=1, 35-bit registers (Hogenauer: 3*log2(2048) + 2)
- Task 1: CIC with rounding to 20 bits (cic_task1.v)
- Task 2: CIC followed by a 3-tap symmetric FIR droop compensator, 20-bit output (cic_fir_task2.v, fir3.v)

## Results (SNR in dB, from the provided fft_2.m)
| Tone | Task 1 | Task 2 |
|---|---|---|
| 10 Hz  | FILL | FILL |
| 500 Hz | Inf in official script (exactly periodic output, noise below float resolution) | FILL |
| 990 Hz | FILL | FILL |

## Run
iverilog -g2005 -o sim cic_tb_mine.v cic3.v cic_task1.v fir3.v cic_fir_task2.v
vvp sim
(edit the three marked lines in the testbench for each tone)

Scoring: provided fft_2.m (unmodified, except hann replaced by its closed-form equivalent). 
The 500 Hz Task 1 value was computed with a direct noise sum because the official script returns Inf.
