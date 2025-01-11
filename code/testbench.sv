`include "s_interface.sv"
`include "test_top.sv"

module tb_top();
  logic clk,reset_n;
  parameter clk_period=10;
  parameter rst_period=5;
  
  s_interface sif(clk,reset_n);
  
  single_port_ram i_sram(.data_in(sif.data_in),
                         .address_in(sif.address_in),
                         .clk(clk),
                         .reset_n(reset_n),
                         .cs(sif.cs),
                         .wr_en(sif.wr_en),
                         .rd_en(sif.rd_en),
                         .data_out(sif.data_out));
  
  test_top i_test_top(sif);
  
  initial begin
    $display("inside tb_top");
  end
  
  task clk_generate();
    clk='b1;
    forever begin
      #(clk_period/2) clk=~clk;
    end
  endtask
  
  task reset_period();
    reset_n='b1;
    #(rst_period);
    reset_n='b0;
    #(rst_period);
    reset_n='b1;
  endtask
  
  initial begin
    clk_generate();
  end
 
  initial begin
    reset_period();//test 1 reset (single w & r)
    #200;
    reset_period();//test 2 reset (multiple w & r with series addr)
    #200;
    reset_period();//test 3 reset (multiple w & r with random addr)
    #300;
    reset_period();//test 4 reset (alternate w & r)
    #300;
    reset_period();//test 5 reset (full randomization)
    #300;
    $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule
