`ifndef VIF_IF_SV
`define VIF_IF_SV

interface vif_if(input logic clk);
  
    timeunit      1ns;
    timeprecision 100ps;
  
    logic dly;
    logic done;
    logic req;
    logic rst_n;
    logic gnt;

endinterface

`endif // VIF_IF_SV