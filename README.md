# Verilog Simple State Machine

A parameterized finite state machine (FSM) controller implementation in Verilog for Built-In Self-Test (BIST) sequencing.

## Overview

This project implements a six-state controller that manages BIST operations through a sequence of states. The state machine generates configurable output sequences and provides status signals for integration into larger digital systems.

## Features

- **Parameterizable Design**: Configurable N (clock cycles per iteration) and M (number of iterations) parameters
- **Edge Detection**: Rising edge detection on `bist_start` input for precise sequence triggering
- **Synchronous Reset**: Priority reset capability with synchronous operation
- **Status Outputs**: Multiple output signals (`mode`, `init`, `running`, `finish`, `bist_end`) for system integration
- **Counter Management**: Internal counters for iteration tracking and sequence control

## File Structure

```
.
├── Verilog/
│   ├── state_machine.v      # Main state machine module
│   └── test_bench.v          # Testbench for simulation
├── Images/
│   ├── controller.png        # System block diagram
│   ├── state_diagram.png     # FSM state diagram
│   └── waveforms.png         # Simulation waveforms
├── Documentation/
│   └── [State machine specification PDF]
└── README.md
```

## Architecture

### State Machine Diagram

![State Diagram](Images/state_diagram.png)

### Internal Registers

The state machine contains three key registers:

1. **`cnt_n`**: Tracks elapsed clock cycles within each iteration (compared against parameter N in state S2)
2. **`cnt_m`**: Counts completed sequence iterations (compared against parameter M in state S3)
3. **`prev_bist_start`**: Stores previous clock cycle's `bist_start` value for edge detection

### State Descriptions

| State | Description |
|-------|-------------|
| **S0** | Idle state - waiting for rising edge on `bist_start` |
| **S1** | Initialization state - asserts `init` signal |
| **S2** | Active processing - asserts `mode` and `running`, increments `cnt_n` |
| **S3** | Iteration check - evaluates if M iterations completed |
| **S4** | Finishing state - asserts `finish` signal |
| **S5** | End state - asserts `bist_end`, waits for new sequence trigger |

### Output Signals

| State | mode | init | running | finish | bist_end |
|-------|------|------|---------|--------|----------|
| S0    | 0    | 0    | 0       | 0      | 0        |
| S1    | 0    | 1    | 0       | 0      | 0        |
| S2    | 1    | 0    | 1       | 0      | 0        |
| S3    | 0    | 0    | 1       | 0      | 0        |
| S4    | 0    | 0    | 0       | 1      | 0        |
| S5    | 0    | 0    | 0       | 0      | 1        |

## Module Interface

### Ports

**Inputs:**
- `clock` - System clock (active on rising edge)
- `reset` - Asynchronous reset (active high, highest priority)
- `bist_start` - Trigger signal for sequence start (rising edge detected)

**Outputs:**
- `mode` - Active processing indicator (high in S2)
- `init` - Initialization indicator (high in S1)
- `running` - Sequence running indicator (high in S2-S3)
- `finish` - Sequence completion indicator (high in S4)
- `bist_end` - All iterations complete (high in S5)

### Parameters

- **N** (default: 7) - Number of clock cycles per iteration
- **M** (default: 10) - Number of iterations per complete sequence

## Simulation

The testbench demonstrates three BIST sequences with various reset and start signal patterns. Each complete sequence takes approximately 9 μs with default parameters.

### Running Simulations

Simulations have been conducted using [EDA Playground](https://edaplayground.com).

**Simulation Results:**

![Waveforms](Images/waveforms.png)

### Testbench Features

- Clock period: 100 ns (10 MHz)
- Multiple test sequences demonstrating:
  - Normal operation
  - Mid-sequence resets
  - Multiple start triggers
  - State transitions

## Usage Example

```verilog
// Instantiate with custom parameters
state_machine #(
    .N(15),  // 15 clock cycles per iteration
    .M(5)    // 5 iterations total
) my_bist_controller (
    .clock(clk),
    .reset(rst),
    .bist_start(start_signal),
    .mode(mode_out),
    .init(init_out),
    .running(running_out),
    .finish(finish_out),
    .bist_end(end_out)
);
```

## Operation

1. **Idle (S0)**: System waits for rising edge on `bist_start`
2. **Initialize (S1)**: One-cycle initialization phase
3. **Process (S2)**: Executes N clock cycles with `mode` asserted
4. **Check (S3)**: Evaluates iteration count against M
   - If `cnt_m ≤ M`: Return to S2 for next iteration
   - If `cnt_m > M`: Proceed to S4
5. **Finish (S4)**: One-cycle finish indication
6. **End (S5)**: Sequence complete, ready for new trigger

## Design Notes

- All inputs are synchronous to the clock rising edge
- Reset has priority over all other inputs
- Edge detection on `bist_start` prevents false re-triggering
- Counter sizes automatically scale based on N and M parameters using `$clog2()`

