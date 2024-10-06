module tb();
  logic rst, clk, en, push_in, pop_in;
  logic [7:0] din;
  logic [3:0] threshold;
  logic [7:0] dout;
  logic empty,full,overrun,underrun,thre_trigger;
  
  //Instantiate fifo module
  fifo_top fifo(.rst(rst), .clk(clk),.en(en), .push_in(push_in), .pop_in(pop_in), .din(din), .threshold(threshold), .dout(dout), .empty(empty), .full(full), .overrun(overrun), .underrun(underrun), .thre_trigger(thre_trigger));
 //assign initial values to global vars.
 initial begin
   rst <= 0;
   clk <= 0;
   en <= 0;
 end
  //Generate clock.
 always #5 clk = ~ clk;
 //Reset FiFo
  task rst_fifo();
    @(posedge clk);
    rst = 1;
    @(posedge clk);
    rst = 0;
   endtask
  //First write the data onto the FiFo(Techincally 15 data can be stored, here we are trying to trigger overrun).
  task write_input();
    @(posedge clk);
    repeat(5) @(posedge clk);
    for (int i = 0; i < 20;i++) begin
      push_in <= 1;
      pop_in <= 0;
      en <= 1;
      din <= $urandom;
      threshold <= 4'ha;
      @(posedge clk);
    end
  endtask
  //Next read the input for the FiFo    
  task read_input();
    @(posedge clk);
    for (int j = 0; j < 15;j++) begin
      push_in <= 0;
      pop_in <= 1;
      en <= 1;
      threshold <= 4'ha;
      @(posedge clk);
    end
  endtask
  //Using tasks for readability.
  initial begin
    
    fork begin
      rst_fifo();
      write_input();
      read_input();
    end
    join_none
  end 
        
  initial begin
    #500
    $finish;
  end 
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule 
