`ifndef SEQUENCER_SV
`define SEQUENCER_SV

class sequencer extends uvm_sequencer #(transaction);

    `uvm_component_utils(sequencer)
   
    extern function new        (string name = "sequencer", uvm_component parent = null);
    extern task     main_phase (uvm_phase phase);
   
endclass

function sequencer::new (string name = "sequencer", uvm_component parent = null);
    super.new(name, parent);
endfunction

task sequencer::main_phase (uvm_phase phase);
    base_sequence b_seq;

    phase.raise_objection(this);
    b_seq = base_sequence::type_id::create("b_seq");
    b_seq.start(this);
    phase.drop_objection(this);
    
endtask

`endif