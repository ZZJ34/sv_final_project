`ifndef APB_INPUT_MONITOR_SV
`define APB_INPUT_MONITOR_SV

class apb_input_mon extends uvm_monitor;

    virtual apb_uart_interface vif; 

    `uvm_component_utils(apb_input_mon)

    extern function      new         (string name = "apb_input_mon", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase); 
    extern task          main_phase  (uvm_phase phase);

endclass //apb_input_mon

// new
function apb_input_mon::new (string name = "apb_input_mon", uvm_component parent = null);
    super.new(name, parent);
endfunction

// build_phase
function void apb_input_mon::build_phase (uvm_phase phase);
    super.build_phase(phase);
    // set apb_uart_interface
    if(!uvm_config_db#(virtual apb_uart_interface)::get(this, "", "vif", vif)) begin
        `uvm_fatal("apb_input_mon", "virtual interface must be set for vif!!!");
    end
endfunction

// main_task
task apb_input_mon::main_phase (uvm_phase phase);
    apb_transaction apb_tr;
    // wait reset end
    wait(this.vif.rst_ == 1);
    // collect a transaction
    while (1) begin

        @(posedge this.vif.clk)

        if (this.vif.apb_port.psel_i == 1 && this.vif.apb_port.penable_i == 1) begin
            `uvm_info("apb_input_mon", "\nget one transaction!", UVM_LOW);
            
            apb_tr = new("apb_tr");
            apb_tr.pdata = this.vif.pwdata_i;
            apb_tr.paddr = this.vif.paddr_i;
            apb_tr.pwrite = this.vif.pwrite_i;

            // display transaction info
            apb_tr.print_info();
        end
    end
endtask

`endif