class coverage_collector;
  mailbox ip_mon2conv;
  mailbox op_mon2conv;
  packet pkt1,pkt2;
  configuration h_cfg;
  
  covergroup cg;
    cp1:coverpoint pkt1.address_in{bins b1[16]={[0:15]};}
    cp2:coverpoint pkt1.data_in{bins b2[10]={[0:255]};}
    cp3:coverpoint pkt1.wr_en{bins b3[2]={[0:1]};}
    cp4:coverpoint pkt1.rd_en{bins b4[2]={[0:1]};}
    cp5:coverpoint pkt1.cs{bins b5[2]={[0:1]};}
    
    cp6:coverpoint pkt2.address_in{bins b6[16]={[0:15]};}
    cp7:coverpoint pkt2.wr_en{bins b7[2]={[0:1]};}
    cp8:coverpoint pkt2.rd_en{bins b8[2]={[0:1]};}
    cp9:coverpoint pkt2.cs{bins b9[2]={[0:1]};}
    cp10:coverpoint pkt2.data_out{bins b10[10]={[0:255]};}
  endgroup
  
  function new(configuration cfg);
    h_cfg=cfg;
    cg=new();
    $display("inside cov collector");
  endfunction
 
  
  function void build();
    $display("coverage collector build");
  endfunction
  
  function void connect();
    ip_mon2conv=h_cfg.ip_mon2conv;
    op_mon2conv=h_cfg.op_mon2conv;
  endfunction
  
  task run();
    forever begin
    ip_mon2conv.get(pkt1);
    $display("packet received from ip mon to coverage is %p",pkt1);
    op_mon2conv.get(pkt2);
    $display("packet received from op mon to coverage is %p",pkt2);
    cg.sample(); //calling sample method
    $display("functional coverage using get coverage is %0d",cg.get_coverage());
    $display("functional coverage using get instant coverage is %0d",cg.get_inst_coverage());
    end
  endtask
endclass
  