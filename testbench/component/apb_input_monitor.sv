`ifndef APB_INPUT_MONITOR_SV
`define APB_INPUT_MONITOR_SV

class apb_input_mon extends uvm_monitor;

    virtual apb_uart_interface vif; 

    `uvm_component_utils(apb_input_mon);
    
    // apb_input_mon -> uart_output_mon 
    uvm_blocking_put_port#(transaction) apb_mon_i_port;

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
    // initialize apb_mon_i_port
    apb_mon_i_port = new("apb_mon_i_port", this);
endfunction

// main_task
task apb_input_mon::main_phase (uvm_phase phase);
    transaction tr;
    // wait reset end
    wait(this.vif.rst_ == 1);
    // collect a transaction
    while (1) begin

        @(posedge this.vif.clk)

        if (this.vif.psel_i == 1 && this.vif.penable_i == 1) begin

            `uvm_info("apb_input_mon", "\nget one transaction!", UVM_LOW);
            
            tr = new("tr");
            tr.pdata = this.vif.pwdata_i;
            tr.paddr = this.vif.paddr_i;
            tr.pwrite = this.vif.pwrite_i;

            // display transaction info
            tr.print_apb_info();

            // set baud
            if(tr.paddr == 32'h08) apb_mon_i_port.put(tr);

            // set check
            if(tr.paddr == 32'h0c) apb_mon_i_port.put(tr);
        end
    end
endtask

`endif