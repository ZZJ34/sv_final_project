`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

class env extends uvm_env;

    apb_input_drv apb_drv_i;
    apb_input_mon apb_mon_i;

    `uvm_component_utils(env);

    extern function      new         (string name = "env", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase); 

endclass //env

// new
function env::new (string name = "env", uvm_component parent = null);
    super.new(name, parent);
endfunction

// build_phase
function void env::build_phase (uvm_phase phase);
    super.build_phase(phase);
    // instance apb_input_drv
    apb_drv_i = apb_input_drv::type_id::create("apb_drv_i", this);
    // instance apb_input_mon
    apb_mon_i = apb_input_mon::type_id::create("apb_mon_i", this);
endfunction

`endif