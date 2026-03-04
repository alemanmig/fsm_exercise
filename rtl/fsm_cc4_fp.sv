// One hot FSM Coding Style (Good Style
// CummingsICU2002_FSM fundamentals

module fsm_cc4_fp(
       input dly, done, req, clk, rst_n,
       output reg gnt
       );
  
  parameter [3:0] IDLE = 0,
                  BBUSY = 1,
                  BWAIT = 2,
                  BFREE = 3;

  reg [3:0] state, next;
  
  always @(posedge clk or negedge rst_n)
    if (!rst_n) begin
      state <= 4'b0;
      state[IDLE] <= 1'b1;
      end
    else 
      state <= next;
  
  always @(state or dly or done or req) begin
    next = 4'b0;
    gnt = 1'b0;
    case (1'b1) // ambit synthesis case = full, parallel
      state[IDLE] : if (req) 
                      next[BBUSY] = 1'b1;
                    else 
                      next[IDLE] = 1'b1;
      
      state[BBUSY]: begin
        gnt = 1'b1;
        if (!done) 
          next[BBUSY] = 1'b1;
        else if ( dly) 
          next[BWAIT] = 1'b1;
        else 
          next[BFREE] = 1'b1;
      end
      
      state[BWAIT]: begin
        gnt = 1'b1;
        if (!dly) 
          next[BFREE] = 1'b1;
        else 
          next[BWAIT] = 1'b1;
      end
      
      state[BFREE]: begin
        if (req) 
          next[BBUSY] = 1'b1;
        else 
          next[IDLE] = 1'b1;
      end
    endcase
  end
  
endmodule