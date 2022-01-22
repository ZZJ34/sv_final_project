`ifndef INPUT_AGENT_SV
`define INPUT_AGENT_SV

class input_agt extends uvm_agent;

    apb_input_drv apb_drv_i;
    apb_input_mon apb_mon_i;

    `uvm_component_utils(input_agt)

    // input_agt -> model : pointer
    uvm_analysis_port#(transaction) agt_i2mdl_port;

    extern function      new           (string name = "input_agt", uvm_component parent = null);
    extern function void build_phase   (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);

endclass //input_agt

// new
function input_agt::new (string name = "input_agt", uvm_component parent = null);
    super.new(name, parent);
endfunction

// build_phase
function void input_agt::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // instance apb_input_drv
    apb_drv_i = apb_input_drv::type_id::create("apb_drv_i", this);
    // instance apb_input_mon
    apb_mon_i = apb_input_mon::type_id::create("apb_mon_i", this);
endfunction

// connect_phase
function void input_agt::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt_i2mdl_port = apb_mon_i.apb_mon_i2mdl_port;
endfunction

`endif