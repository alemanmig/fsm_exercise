// Systemverilog Assertions (SVA)

module sva (
    input logic dly,
    input logic done,
    input logic req,
    input logic clk,
    input logic rst_n,
    input logic gnt
//    input wire [1:0]  state
);

    parameter [1:0] IDLE  = 2'b00,
                    BBUSY = 2'b01,
                    BWAIT = 2'b10,
                    BFREE = 2'b11;
  
  //===========================================================================
  // RESET
  //===========================================================================

  // Tras reset, el estado debe ir a IDLE
  ast_reset_to_idle : assert property (
//    @(posedge clk)
//    (!rst_n) |=> (state == IDLE)
    @(negedge rst_n)
     ##0 (dut.state == IDLE)   // En ese mismo instante, state debe ser IDLE
  ) else $error("[FAIL] ast_reset_to_idle in t = %t", $time);

  // Durante reset, gnt debe ser 0
  ast_gnt_low_on_reset : assert property (
    @(posedge clk)
    (!rst_n) |-> (gnt == 1'b0)
  ) else $error("[FAIL] ast_gnt_low_on_reset");
    
  //===========================================================================
  // TRANSICIONES DE ESTADO
  //===========================================================================

  // IDLE → BBUSY si req=1
  ast_idle_to_bbusy : assert property (
    @(posedge clk) disable iff (!rst_n)
    (dut.state == IDLE && req) |=> (dut.state == BBUSY)
  ) else $error("[FAIL] ast_idle_to_bbusy");
    
 //===========================================================================
 // COVER PROPERTIES (cobertura funcional)
 //===========================================================================

    
 // Cubrir que el reset ocurrió y el estado llegó a IDLE
  cov_reset_to_idle : cover property (
    @(negedge rst_n)
    ##0 (dut.state == IDLE)
    );
    
 // Cubrir que gnt estaba en 0 durante reset
  cov_gnt_low_on_reset : cover property (
    @(posedge clk)
    (!rst_n) |-> (gnt == 1'b0)
   );
    
 // IDLE permanece en IDLE sin req
   cov_idle_stays_idle : cover property (
    @(posedge clk) disable iff (!rst_n)
    (dut.state == IDLE && !req) ##1 (dut.state == IDLE)
   );

 // IDLE → BBUSY con req
  cov_idle_to_bbusy : cover property (
    @(posedge clk) disable iff (!rst_n)
    (dut.state == IDLE && req) ##1 (dut.state == BBUSY)
  );
    
 // BBUSY permanece en BBUSY sin done
  cov_bbusy_stays_bbusy : cover property (
    @(posedge clk) disable iff (!rst_n)
    (dut.state == BBUSY && !done) ##1 (dut.state == BBUSY)
  );

 // BBUSY → BWAIT con done y dly
  cov_bbusy_to_bwait : cover property (
    @(posedge clk) disable iff (!rst_n)
    (dut.state == BBUSY && done && dly) ##1 (dut.state == BWAIT)
  );


endmodule