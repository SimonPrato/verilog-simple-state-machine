`timescale 1ns / 1ps

module state_machine_tb;

    reg clock, reset, bist_start;
    wire mode, bist_end, init, running, finish;

    state_machine state_machine(
        .clock(clock),
        .reset(reset),
        .bist_start(bist_start),
        .mode(mode),
        .bist_end(bist_end),
        .init(init),
        .running(running),
        .finish(finish)
    );

    initial begin
		$dumpfile("dump.vcd"); $dumpvars;
        clock = 0;
        reset = 1;
        bist_start = 0;
    end

    always
        #50 clock = !clock;

    initial
        begin
        #100 reset = 0;
        #100 bist_start = 1;
        #200 $finish;
        end

endmodule
