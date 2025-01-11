interface s_interface(input logic clk,reset_n);
  parameter data_size=8;
  parameter address_size=4;
 logic [data_size-1:0]data_in;
  logic [address_size-1:0]address_in;
  logic wr_en;
  logic rd_en;
  logic cs;
  logic [data_size-1:0]data_out;
 // modport sRam(input data_in, address_in, cs,wr_en,rd_en, output data_out);
  modport tb(input clk, reset_n, data_out, output data_in, address_in,cs,wr_en,rd_en);
endinterface