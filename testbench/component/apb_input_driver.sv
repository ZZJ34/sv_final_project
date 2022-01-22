`ifndef APB_INPUT_DRIVER_SV
`define APB_INPUT_DRIVER_SV

class apb_input_drv extends uvm_driver #(transaction);

    virtual apb_uart_interface vif; 

    `uvm_component_utils(apb_input_drv)

    extern function      new         (string name = "apb_input_drv", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase); 
    extern task          main_phase  (uvm_phase phase);
    extern task          idle_state  ();
    extern task          setup_state (transaction tr);
    extern task          enable_state(transaction tr);

endclass //apb_input_drv

// new
function apb_input_drv::new (string name = "apb_input_drv", uvm_component parent = null);
    super.new(name, parent);
endfunction

// build_phase
function void apb_input_drv::build_phase (uvm_phase phase);
    super.build_phase(phase);
    // set apb_uart_interface
    if(!uvm_config_db#(virtual apb_uart_interface)::get(this, "", "vif", vif)) begin
        `uvm_fatal("apb_input_drv", "virtual interface must be set for vif!!!");
    end
endfunction

// main_phase
task apb_input_drv::main_phase (uvm_phase phase);

    // instance a transaction
    req = new("tr");

    // wait reset end
    wait(this.vif.rst_ == 1);

    idle_state();

    while (1) begin
        seq_item_port.try_next_item(req);
        if(req == null || req.ttype == 2)
            idle_state();
        else begin
            setup_state(req);
            enable_state(req);
            seq_item_port.item_done();
        end
    end

endtask 

// idle_state
task apb_input_drv::idle_state ();
    @(posedge this.vif.clk);
    this.vif.apb_port.psel_i <= 0;
    this.vif.apb_port.penable_i <= 0;
endtask

// setup_state
task apb_input_drv::setup_state (transaction tr);
    @(posedge this.vif.clk);
    this.vif.apb_port.psel_i <= 1;
    this.vif.apb_port.penable_i <= 0; 
    this.vif.apb_port.pwrite_i <= tr.ttype;     // write or read
    this.vif.apb_port.paddr_i <= tr.paddr;      // addr
endtask

// enable_state
task apb_input_drv::enable_state (transaction tr);
    @(posedge this.vif.clk)
    this.vif.apb_port.penable_i <= 1;                                   // enable
    this.vif.apb_port.pwdata_i <= tr.ttype ? tr.pdata : 32'h0000_0000;  // write data
endtask

`endif