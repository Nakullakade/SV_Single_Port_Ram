class generator;
  configuration h_cfg;
  packet pkt;
  mailbox gen2Driv;
  parameter storage=16;
  int arr[storage];
  
  function new(configuration cfg);
    h_cfg=cfg;
  endfunction
  
  function void build();
    gen2Driv=new();
    $display("inside gen build");
  endfunction
  
  function void connect();
   h_cfg.gen2Driv=gen2Driv;
  endfunction
  
//test 1: single write & read with directed values 
  task single_write();
    pkt=new();
    pkt.data_in=8'b1010;
    pkt.address_in=4'b0001;
    pkt.cs='b1;
    pkt.wr_en='b1;
    pkt.rd_en='b0;
    gen2Driv.put(pkt);
    $display("gen single write successful %p",pkt);
  endtask
  
  task single_read();
    pkt=new();
    pkt.data_in=8'b1010;
    pkt.address_in=4'b0001;
    pkt.wr_en='b0;
    pkt.rd_en='b1;
    pkt.cs='b1;
    gen2Driv.put(pkt);
    $display("gen single read successful %p",pkt);
  endtask
  
 //test 2: multiple write & read with increment address  
 task multiple_series_write();
    int i=0;
    repeat(storage) begin
      pkt=new();
      pkt.randomize();
      pkt.address_in=i;
      pkt.wr_en='b1;
      pkt.rd_en='b0;
      pkt.cs='b1;
      gen2Driv.put(pkt);
      i++;
    end
   $display("series write mailbox numbers are %0d",gen2Driv.num());
  endtask
  
  task multiple_series_read();
    int j=0;
    repeat(storage) begin
        pkt=new();
        pkt.address_in=j;
        pkt.wr_en='b0;
        pkt.rd_en='b1;
        pkt.cs='b1;
        gen2Driv.put(pkt);
        j++;
      end
    $display("series read mailbox numbers are %0d",gen2Driv.num());
 endtask
    
//test 3: multiple write & read with randomize input & address  
    task multiple_write();
    int i=0;
    repeat(storage)
      begin
        pkt=new();
        pkt.randomize();
        pkt.wr_en='b1;
        pkt.rd_en='b0;
        pkt.cs='b1;
        arr[i]=pkt.address_in;
        gen2Driv.put(pkt);
        i++;
      end
      $display("random write array is %p mailbox numbers are %0d",arr,gen2Driv.num());
  endtask
  
  task multiple_read();
   int i=0;
   arr.shuffle(); //shuffled above array
   repeat(storage)
      begin
        pkt=new();
        pkt.wr_en='b0;
        pkt.rd_en='b1;
        pkt.cs='b1;
        pkt.address_in=arr[i];
        gen2Driv.put(pkt);
        i++;
      end
    $display("random read array is %p mailbox numbers are %0d",arr,gen2Driv.num());
  endtask
 
//test 4: alternate write & read
  task alternate();
    int j=0;
    repeat(storage) 
      begin
        pkt=new();
        pkt.randomize();
        pkt.address_in=j;
        pkt.wr_en='b1;
        pkt.rd_en='b0;
        pkt.cs='b1;
        gen2Driv.put(pkt);
      
    if(j==7 || j==14) begin
        pkt.cs='b0;
    end 
        pkt=new();
        pkt.wr_en='b0;
        pkt.rd_en='b1;
        pkt.cs='b1;
        pkt.address_in=j;
        gen2Driv.put(pkt);
        j++;        
     end
    $display("alternate w & r mailbox numbers are %0d",gen2Driv.num());
  endtask
  
//test 5: full randomization of signals
  task full_randomization();
    repeat(32)begin
      pkt=new();
      pkt.randomize();
      gen2Driv.put(pkt);
    end 
  endtask
  
  task run();
    //test 1: single write & read
    single_write();
    single_read();
    
    //test 2: multiple with incr address
    multiple_series_write();
    multiple_series_read();
    
    //test 3: multiple with random address
    multiple_write();
    multiple_read();
    
    //test 4: alternate write & read
    alternate();
    
    //test 5: full random conditions
    full_randomization();
  endtask
endclass
    
  