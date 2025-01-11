`include "s_package.sv"
import s_package::*;

program test_top(s_interface sif);
  configuration h_cfg;
  test h_test;
  Scoreboard h_scbd;
  
  initial begin
    $display("inside test_top");
  end
  
  initial begin
    h_cfg=new();
    PhysicalConnect();
    run_test();
    $finish;
  end
  
  function void PhysicalConnect();
    h_cfg.vif=sif;
  endfunction
  
  task run_test();
    h_test=new(h_cfg);
    h_test.build();
    h_test.connect();
    h_test.run();
  endtask
  
  final begin
    h_test.h_env.h_scbd.report();
  end
endprogram
    