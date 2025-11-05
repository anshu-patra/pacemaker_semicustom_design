`timescale 1ns/1ps
module testbench;

    reg CLK;
    reg RSTn;
    wire LED_HEART;
    wire LED_PACE;

    initial CLK = 0;
    always #5 CLK = ~CLK;

    initial begin
        RSTn = 0;
        #100;
        RSTn = 1;
    end

    top dut (
        .CLK(CLK),
        .RSTn(RSTn),
        .LED_HEART(LED_HEART),
        .LED_PACE(LED_PACE)
    );

    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
        $display("Time(ns) LED_HEART LED_PACE");
        $monitor("%0t %b %b", $time, LED_HEART, LED_PACE);
        #(20000); // Fast, short simulation for EDA Playground
        $finish;
    end

endmodule
