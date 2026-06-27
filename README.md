# Capstone1-Final (PW MEDHARTHI-IIT MADRAS)
# 8-Bit Pipelined Wallace Tree Multiplier


## Overview
This repository contains the RTL design and verification environment for a high-speed **8-bit Pipelined Wallace Tree Multiplier**. 

Multipliers often form the critical path bottleneck in digital processors. This project mitigates that delay by utilizing a Wallace Tree compressor architecture to reduce partial products in parallel, combined with a **3-stage synchronous pipeline** to maximize clock frequency and maintain a continuous throughput of 1 result per clock cycle.

## Architecture Highlights
The multiplication process is divided into three distinct pipeline stages to balance the combinational logic delay and target a **50 MHz** operating frequency.

* **Stage 1: Partial Product Generation** Uses a parallel 64-gate AND-array to instantly generate all 8 rows of partial products from the `A[7:0]` and `B[7:0]` inputs, followed by a register bank.
* **Stage 2: Wallace Tree Reduction**
  Compresses the 8 rows of data down to just 2 rows (Sum and Carry vectors) using multiple tiers of Half Adders and Full Adders, followed by a register bank.
* **Stage 3: Final Addition**
  A fast Carry Lookahead Adder (CLA) computes the final 16-bit product from the reduced Sum and Carry rows, outputting to the final register.

### Performance Specs
* **Latency:** 3 Clock Cycles
* **Throughput:** 1 Multiplication / Clock Cycle (Steady-state)
* **Target Frequency:** 50 MHz

## Repository Structure
```text
Wallace_Multiplier/
├── rtl/
│   ├── wallace_top.v         # Top-level pipeline wrapper
│   ├── partial_product.v     # 8x8 AND-gate generation array
│   ├── full_adder.v          # 3-input compressor unit
│   └── half_adder.v          # 2-input compressor unit
├── tb/
│   └── wallace_tb.v          # Self-checking validation environment
└── README.md
```
## Verification & Testing

The design is fully validated using a robust, self-checking testbench (`wallace_tb.v`).

Instead of relying on manual waveform inspection, the testbench features an automated 4-stage shift register queue that tracks the expected software math (`A * B`). It aligns the exact 3-cycle hardware latency with the software checker, flagging any mismatches.

**Test Coverage Includes:**

* **Corner Cases:** Zeros (`0x00 * 0x00`), Maximums (`0xFF * 0xFF`), and alternating bit patterns.
* **Random Stress Test:** 1,000 randomized input vectors injected continuously.
* **Pipeline Flush:** Active zero-padding at the end of the simulation to verify the final calculations mid-flight in the pipeline.

**Result:** 1,000+ tests executed with **0 Errors**.

---

## How to Run (Vivado / XSim)

1. Clone this repository and add the `.v` files to a new Vivado project.
2. Set `wallace_tb.v` as the top module in your **Simulation Sources**.
3. Launch Behavioral Simulation.
4. **Important:** By default, Vivado pauses at 1000ns. To execute all 1,000+ random tests, run the following command in the **Tcl Console**:

   ```tcl
   run -all
