class Driver;
  configuration h_cfg;
  mailbox gen2Driv;
  packet pkt;
 // virtual s_interface vif;
  intf_t1 vif;
  
  function new(configuration cfg);
    h_cfg=cfg;
  endfunction
  
  function void build();
    $display("nothing inside driver build");
  endfunction
  
  function void connect();
    vif=h_cfg.vif;
    gen2Driv=h_cfg.gen2Driv;
  endfunction
  
  task run();
    forever begin
      gen2Driv.get(pkt);
      vif.data_in<=pkt.data_in;
      vif.address_in<=pkt.address_in;
      vif.cs<=pkt.cs;
      vif.wr_en<=pkt.wr_en;
      vif.rd_en<=pkt.rd_en;
      $display("packet at driver is %p",pkt);
      @(posedge vif.clk);
    end
  endtask
endclass
    