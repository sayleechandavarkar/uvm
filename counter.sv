module COUNTER (input Clock, Reset, Enable, Load, UpDn,
                input [7:0] Data, output reg[7:0] Q);
  always @(posedge Clock or posedge Reset)
    if (Reset)
      Q <= 0;
    else
      if (Enable)
        if (Load)
          Q <= Data;
        else
          if (UpDn)
            Q <= Q + 1;
          else
            Q <= Q - 1;
endmodule