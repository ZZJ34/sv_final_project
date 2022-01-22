`ifndef SEQUENCER_SV
`define SEQUENCER_SV

class sequencer extends uvm_sequencer #(transaction);

    `uvm_component_utils(sequencer)
   
    extern function new (string name = "sequencer", uvm_component parent = null);
   
endclass

function sequencer::new (string name = "sequencer", uvm_component parent = null);
    super.new(name, parent);
endfunction

`endif