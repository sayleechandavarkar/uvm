module Test_Counter_w_clocking;
  timeunit 1ns;

  reg Clock = 0, Reset, Enable, Load, UpDn;
  reg [7:0] Data;
  wire [7:0] Q;

  // Clock generator
  always
  begin
    #5 Clock = 1;
    #5 Clock = 0;
  end

  // Test program
  program test_counter;
    // SystemVerilog "clocking block"
    // Clocking outputs are DUT inputs and vice versa
    clocking cb_counter @(posedge Clock);
      default input #1step output #4;
      output negedge Reset;
      output Enable, Load, UpDn, Data;
      input Q;
    endclocking

    // Apply the test stimulus
    initial begin

      // Set all inputs at the beginning    
      Enable = 0;            
      Load = 0;
      UpDn = 1;
      Reset = 1;

      // Will be applied on negedge of clock!
      ##1 cb_counter.Reset  <= 0;
      // Will be applied 4ns after the clock!
      ##1 cb_counter.Enable <= 1;
      ##2 cb_counter.UpDn   <= 0;
      ##4 cb_counter.UpDn   <= 1;
      ##10 cb_counter.UpDn  <= 0;
      ##12 cb_counter.UpDn  <= 1;  
    end

    // Check the results - could combine with stimulus block
    initial begin
      ##1   
      ##1 assert (cb_counter.Q == 8'b00000000);
      ##1 assert (cb_counter.Q == 8'b00000000);
      ##2 assert (cb_counter.Q == 8'b00000010);
      ##4 assert (cb_counter.Q == 8'b11111110);
      ##10 assert (cb_counter.Q == 8'b00000000);
      ##12 assert (cb_counter.Q == 8'b00000010);
     end

  endprogram

  // Instance the counter
  COUNTER G1 (Clock, Reset, Enable, Load, UpDn, Data, Q);

endmodule