// Two Always Block FSM Style (Good Style)
// CummingsICU2002_FSM fundamentals

module fsm_cc4_2(
  input dly, done, req, clk, rst_n,
  output reg gnt
  );
  
 parameter [1:0] IDLE = 2'b00,
                 BBUSY = 2'b01,
                 BWAIT = 2'b10,
                 BFREE = 2'b11;
  
 reg [1:0] state, next;
  
 always @(posedge clk or negedge rst_n)
   if (!rst_n) 
     state <= IDLE;
   else 
     state <= next;
  
 always @(state or dly or done or req) begin
   next = 2'bx;
   gnt = 1'b0;
   case (state)
     IDLE : if (req) 
              next = BBUSY;
            else 
              next = IDLE;
     BBUSY: begin
              gnt = 1'b1;
              if (!done) 
                next = BBUSY;
              else if ( dly) 
                next = BWAIT;
              else next = BFREE;
              end
     BWAIT: begin
              gnt = 1'b1;
              if (!dly) 
                next = BFREE;
              else 
                next = BWAIT;
              end
     BFREE: if (req) 
              next = BBUSY;
            else 
              next = IDLE;
   endcase
 end
  
endmodule