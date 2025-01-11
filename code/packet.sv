class packet;
  parameter data_size=8;
  parameter address_size=4;
  rand bit [data_size-1:0]data_in;
  randc bit [address_size-1:0]address_in;
  rand bit wr_en;
  rand bit rd_en;
  rand bit cs;
  bit [data_size-1:0]data_out; 
  //constraint s1{data_in inside {[0:255]};}
  //constraint s2{address_in inside{[0:15]};}
endclass