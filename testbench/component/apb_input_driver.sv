`ifndef APB_INPUT_DRIVER_SV
`define APB_INPUT_DRIVER_SV

class apb_input_drv extends uvm_driver;

    virtual apb_uart_interface vif; 

    `uvm_component_utils(apb_input_drv)

    extern function      new         (string name = "apb_input_drv", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase); 
    extern task          main_phase  (uvm_phase phase);
    extern task          idle_state  ();
    extern task          setup_state (apb_transaction apb_t);
    extern task          enable_state(apb_transaction apb_t);

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
    apb_transaction apb_tr;
    phase.raise_objection(this); //temp

    apb_tr = new("apb_tr");

    // wait reset end
    wait(this.vif.rst_ == 1);

    apb_tr.pdata = 32'hac;
    apb_tr.paddr = 32'h00;
    apb_tr.pwrite = 1'b1;

    idle_state();
    setup_state(apb_tr);
    enable_state(apb_tr);

    apb_tr.pdata = 32'h02;
    apb_tr.paddr = 32'h00;
    apb_tr.pwrite = 1'b1;

    idle_state();
    setup_state(apb_tr);
    enable_state(apb_tr);


    idle_state();
    #1000

    phase.drop_objection(this); //temp
endtask 

// idle_state
task apb_input_drv::idle_state ();
    @(posedge this.vif.clk);
    this.vif.apb_port.psel_i <= 0;
    this.vif.apb_port.penable_i <= 0;
endtask

// setup_state
task apb_input_drv::setup_state (apb_transaction apb_t);
    @(posedge this.vif.clk);
    this.vif.apb_port.psel_i <= 1;
    this.vif.apb_port.pwrite_i <= apb_t.pwrite;     // write or read
    this.vif.apb_port.paddr_i <= apb_t.paddr;       // addr
endtask

// enable_state
task apb_input_drv::enable_state (apb_transaction apb_t);
    @(posedge this.vif.clk)
    this.vif.apb_port.penable_i <= 1;                                         // enable
    this.vif.apb_port.pwdata_i <= apb_t.pwrite ? apb_t.pdata : 32'h0000_0000; // write data
endtask

`endif