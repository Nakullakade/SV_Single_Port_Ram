class environment;
  configuration h_cfg;
  generator h_gen;
  Driver h_driv;
  ip_monitor h_ip;
  op_monitor h_op;
  Scoreboard h_scbd;
  coverage_collector h_cov;
  
  function new(configuration cfg);
    h_cfg=cfg;
    $display("inside environment");
  endfunction
  
  function void build();
    h_gen=new(h_cfg);
    h_driv=new(h_cfg);
    h_ip=new(h_cfg);
    h_op=new(h_cfg);
    h_scbd=new(h_cfg);
    h_cov=new(h_cfg);
    h_gen.build();
    h_driv.build();
    h_ip.build();
    h_op.build();
    h_scbd.build();
    h_cov.build();
  endfunction
  
  function void connect();
    h_gen.connect();
    h_driv.connect();
    h_ip.connect();
    h_op.connect();
    h_scbd.connect();
    h_cov.connect();
  endfunction
  
  task run();
    fork
      h_driv.run();
      h_ip.run();
      h_op.run();
      h_scbd.run();
      h_cov.run();
      h_scbd.report();
    join
  endtask
endclass