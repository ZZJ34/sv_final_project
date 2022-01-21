`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

class scoreboard extends uvm_scoreboard;

    
    `uvm_component_utils(scoreboard);

    extern function      new         (string name = "scoreboard", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase);
    extern task          main_phase  (uvm_phase phase);

endclass // scoreboard

// new
function scoreboard::new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
endfunction

// build_phase
function void scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction 

// main_phase
task scoreboard::main_phase(uvm_phase phase);

endtask

`endif