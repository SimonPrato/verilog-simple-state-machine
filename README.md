# Behavior of the State Machine

<figure id="fig:state_diagram">

<figcaption>State diagram</figcaption>
</figure>

::: {#tab:output_variables}
   State   mode   init   running   finish   bist_end
  ------- ------ ------ --------- -------- ----------
   $S_0$    0      0        0        0         0
   $S_1$    0      1        0        0         0
   $S_2$    1      0        1        0         0
   $S_3$    0      0        1        0         0
   $S_4$    0      0        0        1         0
   $S_5$    0      0        0        0         1

  : Output variables at every state
:::

The state machine module contains two registers. The first register
cnt_n is responsible for keeping track how many clock periods have
passed. In the state $S_2$, it is repeatedly compared with the
user-defined number of clock cycles N. The second register cnt_m follows
how often the sequence occurred on the output. It enables a repetition
of the sequence, until the user-defined variable M is reached.

By setting the input reset=1, the state $S_0$ will be reached at the
next rising edge of the clock. It has priority over all other input
variables. Every input signal is read at the rising edge of the clock
signal, i.e. they are synchronous. The output variables at every state
are shown in [1](#tab:output_variables){reference-type="ref+label"
reference="tab:output_variables"}, and their transitions are described
in the state diagram in
[1](#fig:state_diagram){reference-type="ref+label"
reference="fig:state_diagram"}.

# Implementation in Verilog

<figure id="fig:controller_interface_schematic">
<p><span id="fig:controller_interface_schematic"
data-label="fig:controller_interface_schematic"></span></p>
<figcaption>Controller interface</figcaption>
</figure>

[2](#tab:project1_group3){reference-type="ref+label"
reference="tab:project1_group3"} shows the selected parameters for our
Group (group 3) in Project 1. These values of N and M are used as the
basis for the project's implementation.

::: {#tab:project1_group3}
   **Group**   **N**   **M**
  ----------- ------- -------
       3         7      10

  : Project 1 - Parameters (Group 3)
:::

``` {.verilog language="Verilog" caption="State machine Verilog code"}
`timescale 100ps / 1ps 

//////////////////////////////////////////////////
//
// Company: Instituto Superior Técnico de Lisboa 
// Module Name: state_machine
// Description: Generic state machine 
// 
//////////////////////////////////////////////////

module state_machine(clock, reset, bist_start, mode, bist_end, init, running, finish);
input clock, reset, bist_start;
output mode, bist_end, init, running, finish;

// Registers containing the current and next state
reg [2:0] state, next_state;

// Parameters identifying states
localparam [2:0] S0=0, S1=1, S2=2, S3=3, S4=4, S5=5;

// Parameters N and M defining the output sequence
parameter N = 7;
parameter M = 10;

// Calculate required register sizes to contain the number of iterations conducted.
parameter N_SIZE = $clog2(N + 1);
parameter M_SIZE = $clog2(N + 1);

// Declaration of registers keeping track of iterations producting hte output sequence.
reg [N_SIZE:0] cnt_n;
reg [M_SIZE:0] cnt_m;

// Process the next state
always @(*)
begin
    case (state)
    S0: begin
        cnt_n = 0;
        cnt_m = 0;
        if (bist_start) next_state = S1;
        else next_state = S0;
        end
    S1: next_state = S2;
    S2: if (cnt_n >= N) next_state = S3;
        else begin
        next_state = S2;
        cnt_n = cnt_n + 1;
        end
    S3: if (cnt_m >= M) next_state = S4;
        else begin
        next_state = S2;
        cnt_m = cnt_m + 1;
        cnt_n = 0;
        end
    S4: next_state = S5;
    S5: if (bist_start == 1) begin
        next_state = S1;
        cnt_m = 0;
        cnt_n = 0;
        end
        else next_state = S5;

endcase
end

// Set the next state to S0 if reset is HIGH
always @(posedge clock)
    begin
        if (reset == 1'b1)
        state <= S0;
        else
        state <= next_state;
end

// Set output depending on state. This section only triggers, if the state changed, instead of any changes.
always @(state) begin
    case (state)
        S0: begin
        mode = 0;
        bist_end = 0;
        init = 0;
        running = 0;
        finish = 0;
        end

        S1: begin
        mode = 0;
        bist_end = 0;
        init = 1;
        running = 0;
        finish = 0;
        end

        S2: begin
        mode = 1;
        bist_end = 0;
        init = 0;
        running = 1;
        finish = 0;
        end

        S3: begin
        mode = 0;
        bist_end = 0;
        init = 0;
        running = 1;
        finish = 0;
        end

        S4: begin
        mode = 0;
        bist_end = 0;
        init = 0;
        running = 0;
        finish = 1;
        end

        S5: begin
        mode = 0;
        bist_end = 1;
        init = 0;
        running = 0;
        finish = 0;
        end
    endcase
end



endmodule



```

