`ifndef MODEL_SV
`define MODEL_SV

class model extends uvm_component;

   
    `uvm_component_utils(model);

    bit check ; // check bit. default 0(none)
    bit parity; // parity. defalut 0(even parity) ; 1(odd parity)

    // input_agt -> model
    uvm_blocking_get_port#(transaction) agt_i2mdl_get_port;

    extern function      new         (string name = "model", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase);
    extern task          main_phase  (uvm_phase phase);
    
endclass

// new
function model::new(string name = "model", uvm_component parent = null);
    super.new(name, parent);
    check = 0 ;
    parity = 0 ;
endfunction

// build_phase
function void model::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // instance agt_i2mdl_get_port
    agt_i2mdl_get_port = new("agt_i2mdl_get_port", this);
endfunction

// main_phase
task model::main_phase(uvm_phase phase);
    transaction tr;
    super.main_phase(phase);
    while(1) begin
        /*
            transaction for register configuration -> record configuration
            transaction for uart send data -> 
        */

        agt_i2mdl_get_port.get(tr);

        `uvm_info("model", "\nget one transaction!", UVM_LOW);
        
        tr.print_apb_info();
    end
endtask


`endif