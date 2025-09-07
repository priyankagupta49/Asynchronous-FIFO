`timescale 1ns/1ps

module async_fifo_TB;

  parameter DATA_WIDTH = 8;

  wire [DATA_WIDTH-1:0] dataout;
  wire full;
  wire empty;
  reg [DATA_WIDTH-1:0] datain;
  reg w_en, wrclk, wrst;
  reg r_en, rclk, rrst;

  // DUT instantiation
  asynchronous_fifo asf (
    .wclk(wrclk),
    .wrst_n(wrst),   
    .rclk(rclk),
    .rrst_n(rrst),
    .w_en(w_en),
    .r_en(r_en),
    .data_in(datain),
    .data_out(dataout),
    .full(full),
    .empty(empty)
  );

  // Clock generation
  always #7  wrclk = ~wrclk;   // write clock ~71 MHz
  always #37 rclk  = ~rclk;    // read clock ~13.5 MHz
  
  initial begin
    wrclk = 1'b0; wrst = 1'b0;
    w_en = 1'b0;
    datain = 0;
    
    repeat(10) @(posedge wrclk);
    wrst = 1'b1;

    repeat(2) begin
      for (integer i = 0; i < 30; i = i + 1) begin
        @(posedge wrclk) 
        if (!full) begin 
          w_en   = (i%2 == 0)? 1'b1 : 1'b0; 
          datain = (w_en) ? $random : datain;
        end
      end
    end
  end

  initial begin
    rclk = 1'b0; rrst = 1'b0;
    r_en = 1'b0;

    repeat(20) @(posedge rclk);
    rrst = 1'b1;

    repeat(2) begin
      for (integer i = 0; i < 30; i = i + 1) begin
        @(posedge rclk) 
        if (!empty) begin
          r_en = (i%2 == 0)? 1'b1 : 1'b0;
        end
        #50;
      end
    end

    repeat(2) begin
      for (integer i = 0; i < 30; i = i + 1) begin
        @(posedge wrclk) 
        if (!full) begin 
          w_en   = (i%2 == 0)? 1'b1 : 1'b0;
          datain = (w_en) ? $random : datain; 
        end
      end
    end

    repeat(2) begin
      for (integer i = 0; i < 30; i = i + 1) begin
        @(posedge rclk) 
        if (!empty) begin
          r_en = (i%2 == 0)? 1'b1 : 1'b0;
        end
        #50;
      end
    end

    #8000 $finish;
  end 

endmodule
