`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

class env extends uvm_env;

    input_agt  agt_i;
    output_agt agt_o;

    uart_output_mon uart_mon_o;

    `uvm_component_utils(env);

    extern function      new           (string name = "env", uvm_component parent = null);
    extern function void build_phase   (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase); 
 

endclass //env

// new
function env::new (string name = "env", uvm_component parent = null);
    super.new(name, parent);
endfunction

// build_phase
function void env::build_phase (uvm_phase phase);
    super.build_phase(phase);
    // instance agt_i
    agt_i = input_agt::type_id::create("agt_i", this);
    // instance agt_i
    agt_o = output_agt::type_id::create("agt_o", this);
endfunction

// connect_phase
function void env::connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    // apb_input_mon -> uart_output_mon
    agt_i.apb_mon_i.apb_mon_i_port.connect(agt_o.uart_mon_o.uart_mon_o_export);
endfunction
`endif