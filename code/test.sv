class test;
  configuration h_cfg;
  environment h_env;
  
  function new(configuration cfg);
    h_cfg=cfg;
    $display("inside test");
  endfunction
  
  function void build();
    h_env=new(h_cfg);
    h_env.build();
  endfunction
  
  function void connect();
    h_env.connect();
  endfunction
  
  task run();
    fork
    h_env.h_gen.run();
    h_env.run();
    join
  endtask
endclass
      
  