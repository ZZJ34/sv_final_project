`ifndef OUTPUT_AGENT_SV
`define OUTPUT_AGENT_SV

class output_agt extends uvm_agent;

    uart_output_mon uart_mon_o;
    apb_output_mon  apb_mon_o;

    `uvm_component_utils(output_agt);

    extern function      new           (string name = "output_agt", uvm_component parent = null);
    extern function void build_phase   (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);

endclass //output_agt

// new
function output_agt::new (string name = "output_agt", uvm_component parent = null);
    super.new(name, parent);
endfunction

// build_phase
function void output_agt::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // instance uart_output_mon
    uart_mon_o = uart_output_mon::type_id::create("uart_mon_o", this);
    // instance apb_output_mon
    apb_mon_o = apb_output_mon::type_id::create("apb_mon_o", this);
endfunction

// connect_phase
function void output_agt::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction

`endif