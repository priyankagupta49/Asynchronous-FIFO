`timescale 1ns/1ps

module single_port_ram_tb;
    reg clk;
    reg [7:0] data_in;
    reg [3:0] addr;
    reg we;
    wire [7:0] data_out;

    // Instantiate DUT
    single_port_ram dut (
        .clk(clk),
        .data_in(data_in),
        .addr(addr),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;

        // Write some data
        we = 1;
        addr = 4'b0000; data_in = 8'hA5; #10;
        addr = 4'b0001; data_in = 8'h3C; #10;
        addr = 4'b0010; data_in = 8'hFF; #10;

        // Read back data
        we = 0;
        addr = 4'b0000; #10;
        addr = 4'b0001; #10;
        addr = 4'b0010; #10;

        $stop; // End simulation
    end
endmodule
