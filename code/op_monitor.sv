class op_monitor;
  configuration h_cfg;
  //virtual s_interface vif;
  intf_t1 vif;
  mailbox op_mon2scbd;
  mailbox op_mon2conv;
  packet pkt;
  
  function new(configuration cfg);
    h_cfg=cfg;
  endfunction
  
  function void build();
    op_mon2scbd=new();
    op_mon2conv=new();
    $display("inside op mon build");
  endfunction
  
  function void connect();
    vif=h_cfg.vif;
    h_cfg.op_mon2scbd=op_mon2scbd;
    h_cfg.op_mon2conv=op_mon2conv;
  endfunction
  
  task run();
    forever begin
      @(posedge vif.clk);
    if(vif.reset_n=='b1 && vif.cs=='b1 && vif.rd_en=='b1 && vif.wr_en=='b0)
     //   if(vif.reset_n=='b1 && vif.cs=='b1)
       begin
        pkt=new();
        pkt.address_in=vif.address_in;
        pkt.data_out=vif.data_out;
        pkt.cs=vif.cs;
        pkt.wr_en=vif.wr_en;
        pkt.rd_en=vif.rd_en;
        op_mon2scbd.put(pkt);
        op_mon2conv.put(pkt);
        $display("op mon data (from vif) is %p",pkt);
      end
      else begin
        $display("op filter");
      end
    end
  endtask
endclass
        