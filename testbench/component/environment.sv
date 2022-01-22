`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

class env extends uvm_env;

    input_agt  agt_i;
    output_agt agt_o;

    model      mdl;
    scoreboard scb;

    // fifo
    uvm_tlm_analysis_fifo#(transaction) agt_i2mdl_fifo;
    uvm_tlm_analysis_fifo#(transaction) mdl2scb_conf_fifo;
    uvm_tlm_analysis_fifo#(transaction) mdl2scb_uart_fifo;
    uvm_tlm_analysis_fifo#(transaction) agt_o2scb_fifo;


    `uvm_component_utils(env)

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
    // instance mdl
    mdl = model::type_id::create("mdl", this);
    // instance scb
    scb = scoreboard::type_id::create("scb", this);

    // instance fifo
    agt_i2mdl_fifo = new("agt_i2mdl_fifo", this);
    mdl2scb_conf_fifo = new("mdl2scb_conf_fifo", this);
    mdl2scb_uart_fifo = new("mdl2scb_uart_fifo", this);
    agt_o2scb_fifo = new("agt_o2scb_fifo", this);
endfunction

// connect_phase
function void env::connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    // apb_input_mon -> uart_output_mon
    agt_i.apb_mon_i.uart_set_port.connect(agt_o.uart_mon_o.uart_tx_set_imp);
    // input_agt -> model
    agt_i.agt_i2mdl_port.connect(agt_i2mdl_fifo.analysis_export);
    mdl.agt_i2mdl_get_port.connect(agt_i2mdl_fifo.blocking_get_export);
    // model -> scoreboard
    mdl.conf_tr_port.connect(mdl2scb_conf_fifo.analysis_export);
    scb.conf_tr_get_port.connect(mdl2scb_conf_fifo.blocking_get_export);
    mdl.uart_tr_port.connect(mdl2scb_uart_fifo.analysis_export);
    scb.uart_tr_get_port.connect(mdl2scb_uart_fifo.blocking_get_export);
    // output_agt -> scoreboard
    agt_o.agt_o2mdl_port.connect(agt_o2scb_fifo.analysis_export);
    scb.agt_o2scb_get_port.connect(agt_o2scb_fifo.blocking_get_export);
endfunction
`endif