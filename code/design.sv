module single_port_ram #(parameter data_size=8, address_size=4)
 ( input [data_size-1:0] data_in,
 input [address_size-1:0] address_in,
 input clk, reset_n,
 input cs,
 input wr_en,
 input rd_en,
 output logic [data_size-1:0] data_out);

 logic [data_size-1:0] memory [ 2**address_size];

 always_ff@(posedge clk, negedge reset_n)
 begin : Memory_wr
 if(!reset_n)
 memory[address_in] <= 'b0;
 else if ( cs==1 && wr_en==1 && rd_en==0)
 memory[address_in] <= data_in;
 end : Memory_wr

 always_ff @ (posedge clk, negedge reset_n)
 begin : Memory_rd
 if ( ! reset_n)
 data_out <= 'bz;
 else if ( cs==1 && wr_en ==0 && rd_en==1)
 data_out <= memory[address_in];
 end : Memory_rd

endmodule