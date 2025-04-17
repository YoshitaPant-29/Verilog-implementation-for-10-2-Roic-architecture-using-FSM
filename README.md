# Verilog-implementation-for-10 * 2(Column*Row)-Roic-architecture-using-FSM

This project demonstrates a Verilog-based controller for a Readout Integrated Circuit (ROIC) scanning a 2-row by 10-column sensor matrix. It's built using a clean FSM-based architecture with one-hot encoding for selective row-column traversal and simulated using Cadence Xcelium Online Simulator.

## Architecture Overview
Rows: 2

Columns: 10

Encoding: One-hot (row & column)

FSM States: IDLE → ROW_SELECT → COLUMN_HOLD → INTER_DELAY → NEXT_ROW → DONE

Goal: Simulate pixel readout logic for a basic ROIC controller

## Files:
roic_2x10.v: Core Verilog module

tb_roic_2x10.v: Testbench to simulate row-column traversal and capture output behavior

## Tool Used
🧰 Cadence Xcelium Online Simulator
Simulation and waveform analysis were performed using Xcelium, a high-performance logic simulator from Cadence. The tool efficiently visualized:

Clock transitions

One-hot row and column activations

Delay counters and state transitions

Final done signal at the end of the scan

## Core Module Description: 
Row Scan: Activates one row at a time

Column Scan: Activates each column in that row sequentially

Delay Logic: Adjustable hold time before switching to the next column

FSM Controlled: Compact 3-bit state machine handles all logic transitions

## 🔬 Testbench Highlights
Generates clock and reset logic

Monitors state transitions and control signals

Verifies full traversal across 2 rows and 10 columns

Ends simulation with assertion of the done flag

## Applications
Educational FSM + ROIC design

Basis for 640×512 high-resolution sensor array

FPGA-based low-level image sensor interface

## Author
Developed by Yoshita Pant 
🔧 Tools Used: Verilog | Cadence Xcelium | GTKWave
📌 Open to improvements, forks, and collaborative extensions!



