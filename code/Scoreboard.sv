class Scoreboard;
  configuration h_cfg;
  mailbox ip_mon2scbd;
  mailbox op_mon2scbd;
  packet pkt;
  int ip_arr[int];
  int op_arr[int];
  int pass_count;
  int fail_count;
  
  function new(configuration cfg);
    h_cfg=cfg;
  endfunction
  
  function void build();
    $display("nothing inside scoreboard build");
  endfunction
  
  function void connect();
    ip_mon2scbd=h_cfg.ip_mon2scbd;
    op_mon2scbd=h_cfg.op_mon2scbd;
  endfunction
  
  task run();
    fork
      collect_from_ip_mon();
      collect_from_op_mon();
    join
  endtask
  
  task collect_from_ip_mon();
    forever begin
    ip_mon2scbd.get(pkt);
      $display("ip data at score is %p",pkt);
      ip_arr[pkt.address_in]=pkt.data_in;
      $display("ip associate array is %p and size is %0d",ip_arr,ip_arr.num());
    end
  endtask
  
  task collect_from_op_mon();
   // int op_arr[int];
    forever begin
      op_mon2scbd.get(pkt);
      $display("op data at score is %p",pkt);
      op_arr[pkt.address_in]=pkt.data_out;
      $display("op associate array is %p and size is %0d",op_arr,op_arr.num());
      compare(op_arr);
    end
  endtask
  
  task compare(int op_arr[int]);
    bit [7:0] actual_data;
    bit [7:0] expected_data;
    wait(op_arr.num()>0);
    wait(ip_arr.num()>0);
    actual_data=ip_arr[pkt.address_in];//data_in
    expected_data=op_arr[pkt.address_in];//data_out
    $display("addr = %0d",pkt.address_in);
    if(actual_data==expected_data) begin
      $display("time: %0t ns, data matched !! exp=%0d act=%0d",$time,actual_data,expected_data);
      pass_count=pass_count+1;
    end
    else
     begin
       $display("time: %0t ns, data not matched !! exp=%0d act=%0d",$time,actual_data,expected_data);
      fail_count=fail_count+1;
     end
      $display(" ");
  endtask
  
  function void report();
    if(pass_count>fail_count) begin
      $display("test cases passed !!  Pass count =%0d and fail count=%0d",pass_count,fail_count);
    end
    else begin 
      $display("test cases failed !! pass count=%0d and fail count=%0d",pass_count,fail_count);
    end
  endfunction
endclass