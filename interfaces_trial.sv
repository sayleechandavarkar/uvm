interface Bus;
    logic [7:0] Addr, Data;
    logic RWn;
endinterface

//using the interface 
module TestRAM;
    Bus TheBus();
    logic [7:0] mem[0:7];
    RAM TheRAM (.MemBus(TheBus)); //connect it

    initial 
    begin 
        TheBus.RWn = 0;
        TheBus.Addr = 0; 
        for(int I=0; I<7;I++) 
            TheBus.Addr = TheBus.Addr + 1;
        TheBus.Rwn = 1;
        TheBus.Data = mem[0];
    end
endmodule

module RAM (Bus MemBus);
    logic [7:0] mem[0:255];

    always @*
        if(MemBus.RWn)
            MemBus.Data = mem[MemBus.Addr];
        else 
            mem[MemBus.Addr] = MemBus.Data;
endmodule


// interface ports 

interface ClockedBus (input clk);
    logic [7:0] Addr, Data;
    logic RWn;
endinterface

module RAM (clockedBus Bus);
    always @(posedge Bus.clk)
        if(Bus.RWn)
            Bus.data = mem[Bus.Addr];
        else 
            mem[Bus.Addr] = Bus.data;
endmodule

//using the interface
module top;
    reg clock;

//Instance the interface with an input using named connection
clockedBus TheBus (.clk(clock));
RAM TheRAM (.Bus(TheBus));

endmodule


//parameterised interface
interface channel #(parameter N=0)
    (input bit clock, bit Ack, bit Sig);
    bit Buff[N-1:0];
    initial 
        for(int i=0;i<N;i++) 
            Buff[i] = 0;
    end
        always @(posedge clock)
            if(Ack = 1)
                Sig = Buff[N-1];
            else 
                Sig = 0;
endinterface

module Top;
    bit clock, Ack, Signal;
    //instance the interface. The parameter N is set to using 7 using named connection while the ports
    // are connected using implicit connection

    Channel #(.N(7)) Thech(.*);
    TX TheTx (.ch(Thech));

endmodule

//Modports in interfaces
interface MSBus(input clk);
    logic [7:0] Addr, Data;
    logic RWn;
    modport Slave(input Addr, inout Data);
endinterface

    module TestRAM;
        logic clk;
        MSBUS TheBus(.clk(clk));
        RAM TheRAM(.MemBus(TheBus.slave));
    endmodule
    

