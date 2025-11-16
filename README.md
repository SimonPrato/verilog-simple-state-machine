
   

# Verilog Simple State Machine

## File Structure

In the Verilog folder, the Verilog code of the testbench and the design is located. Images for documentation purposes are in the Images folder. A PDF describing the state machine in detail is in the Documentation folder.

## Description
A simple state machine is implemented. It is represented by the controller in the figure below.

![controller](Images/controller.png)

It can reach six states. Only two internal registers are used, cnt_n and cnt_m. They are used to iterate between the states $S_2$ and $S_3$. The user sets the number of iterations by configuring the parameters N and M in the Verilog code of the design.

![State Diagram](Images/state_diagram.png)

The outputs in each state behave according to the table below. 


|State |  mode |  init |  running |  finish|   bist_end|
|  -------| ------| ------| ---------| --------| ----------|
|   $S_0$  |  0|      0      |  0|        0     |    0|
 |  $S_1$ |   0 |     1     |   0 |       0    |     0|
|   $S_2$   | 1  |    0    |    1  |      0   |      0|
 |  $S_3$  |  0   |   0   |     1   |     0  |       0|
|   $S_4$ |   0    |  0  |      0    |    1 |        0|
 |  $S_5$|    0     | 0 |       0     |   0|         1|

## Simulation

Simulations have been conducted with [EDA Playground](https://edaplayground.com).
![waveforms of simulation](Images/waveforms.png)

