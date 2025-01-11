class ip_monitor;
  configuration h_cfg;
  //virtual s_interface vif;
  intf_t1 vif;
  mailbox ip_mon2scbd;
  mailbox ip_mon2conv;
  packet pkt;
  
  function new(configuration cfg);
    h_cfg=cfg;
  endfunction
  
  function void build();
    ip_mon2scbd=new();
    ip_mon2conv=new();
    $display("inside ip mon build");
  endfunction
  
  function void connect();
    vif=h_cfg.vif;
    h_cfg.ip_mon2scbd=ip_mon2scbd;
    h_cfg.ip_mon2conv=ip_mon2conv;
  endfunction
  
  task run();
    forever begin
     @(posedge vif.clk);
     if(vif.reset_n=='b1 && vif.cs=='b1 && vif.wr_en=='b1 && vif.rd_en=='b0)
     //  if(vif.reset_n=='b1 && vif.cs=='b1)
       begin
        pkt=new();
        pkt.address_in=vif.address_in;
        pkt.data_in=vif.data_in;
        pkt.cs=vif.cs;
        pkt.wr_en=vif.wr_en;
        pkt.rd_en=vif.rd_en;
        ip_mon2scbd.put(pkt);
        ip_mon2conv.put(pkt);
        $display("ip mon data (from vif) is %p",pkt);
      end
      else begin
        $display("ip filter");
      end
    end
  endtask
endclass