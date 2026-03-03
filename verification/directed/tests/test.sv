module test (
    vif_if vif
);

  // =================== MAIN SEQUENCE ==================== //

  initial begin
    // Initial values
    $display("Begin Of Simulation.");
    
    // Apply reset
    reset();

    count();

    // Drain time
    #(200ns);
    $display("End Of Simulation.");
    $finish;
  end


  // ======================= TASKS ======================== //

  task automatic reset();
    vif.rst_i = 1'b1;
    vif.up_i  = 1'b0;
    repeat (2) @(vif.cb);
    vif.cb.rst_i <= 1'b0;
    repeat (20) @(vif.cb);
  endtask : reset


  task automatic count();
    vif.rst_i = 1;
    vif.up_i = 0;
    #30;
    vif.rst_i = 0;
    vif.up_i = 1;
  #200;
    vif.up_i = 0;
    vif.rst_i = 1;
    #25;
    vif.rst_i = 0;
  endtask : count


endmodule : test
