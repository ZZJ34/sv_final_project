`ifndef APB_OUTPUT_MONITOR_SV
`define APB_OUTPUT_MONITOR_SV

class apb_output_mon extends uvm_monitor;

    virtual apb_uart_interface vif;

    `uvm_component_utils(apb_output_mon);

    extern function      new           (string name = "apb_output_mon", uvm_component parent = null);
    extern function void build_phase   (uvm_phase phase); 
    extern task          main_phase    (uvm_phase phase);

endclass // apb_output_mon

// new
function apb_output_mon::new (string name = "apb_output_mon", uvm_component parent = null);
    super.new(name, parent);
endfunction

// build_phase
function void apb_output_mon::build_phase (uvm_phase phase);
    super.build_phase(phase);
    // set apb_uart_interface
    if(!uvm_config_db#(virtual apb_uart_interface)::get(this, "", "vif", vif)) begin
        `uvm_fatal("apb_output_mon", "virtual interface must be set for vif!!!");
    end
endfunction

task apb_output_mon::main_phase (uvm_phase phase);
    transaction tr;
    // wait reset end
    wait(this.vif.rst_ == 1);
    // collect a transaction
    while(1) begin
        @(posedge this.vif.clk)
        if (this.vif.psel_i == 1 && this.vif.penable_i == 1) begin

            `uvm_info("apb_output_mon", "\nget one apb read data!", UVM_LOW);
            
            tr = new("tr");
            tr.pdata = this.vif.apb_port.prdata_o;

            // to scoreborad

        end
    end
endtask


`endif