// Testbench top

`include "test.sv"
`include "sva.sv"
`include "vif_if.sv"

module tb;

  timeunit      1ns;
  timeprecision 100ps;


  // Clock signal
  logic clk = 0;
  int unsigned MainClkPeriod = 10;  // 100 MHz -> 10 ns period
  always #(MainClkPeriod / 2) clk = ~clk;
  // always #5 clk = ~clk; //opsción simple

  // Interface
  vif_if vif (clk);

  // Test
  test top_test (vif);

  // Instantiation
  fsm_cc4_2 
    dut (
      .dly(vif.dly),
      .done(vif.done),
      .req(vif.req),
      .clk(vif.clk),
      .rst_n(vif.rst_n),
      .gnt(vif.gnt)
  );
  
  // SVA
  bind fsm_cc4_2 sva 
  dut_sva (
      .dly(vif.dly),
      .done(vif.done),
      .req(vif.req),
      .clk(vif.clk),
      .rst_n(vif.rst_n),
      .gnt(vif.gnt)
    //  .state (state)  // señal interna accesible dentro del scope del bind
  );

  initial begin
    $timeformat(-9, 1, "ns", 10);
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

endmodule : tb