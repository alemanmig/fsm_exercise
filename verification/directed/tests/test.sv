// Generación de señales
// TEST

module test (
    vif_if vif
);

  // =================== MAIN SEQUENCE ==================== //

  initial begin
    // Initial values
    $display("Begin Of Simulation.");
    
    // Apply reset
    reset();

    test0();

    // Drain time
    #(200ns);
    $display("End Of Simulation.");
    $finish;
  end


  // ======================= TASKS ======================== //

  task automatic reset();
    vif.rst_n = 1'b1;
    vif.dly   = 1'b0;
    vif.done  = 1'b0;
    vif.req   = 1'b0;
    #5;
    vif.rst_n <= 1'b0;
    #5;
    vif.rst_n <= 1'b1;
    #20;
    vif.rst_n <= 1'b0;
    #20;
    vif.rst_n <= 1'b1;
    #10;
    
  endtask : reset


  task automatic test0();
    vif.req = 1;
    #10;
    vif.req = 1;
    #20;
    vif.req = 0;
    #20;

  endtask : test0


endmodule : test