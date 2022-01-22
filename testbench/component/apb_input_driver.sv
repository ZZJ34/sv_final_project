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
    phase.raise_objection(this); //temp

    // instance a transaction
    req = new("tr");

    // wait reset end
    wait(this.vif.rst_ == 1);

    req.pdata = 32'hac;
    req.paddr = 32'h00;
    req.ttype = transaction::WRITE;
    idle_state();
    setup_state(req);
    enable_state(req);
    idle_state();

    #2038866

    req.pdata = 32'd13;
    req.paddr = 32'h08;
    req.ttype = transaction::WRITE;
    idle_state();
    setup_state(req);
    enable_state(req);


    req.pdata = 32'h02;
    req.paddr = 32'h00;
    req.ttype = transaction::WRITE;
    idle_state();
    setup_state(req);
    enable_state(req);


    req.paddr = 32'h18;
    req.ttype = transaction::READ;
    idle_state();
    setup_state(req);
    enable_state(req);


    idle_state();
    #8000000

    phase.drop_objection(this); //temp
endtask 

// idle_state
task apb_input_drv::idle_state ();
    @(posedge this.vif.clk);
    this.vif.apb_port.psel_i <= 0;
    this.vif.apb_port.penable_i <= 0;
endtask

// setup_state
task apb_input_drv::setup_state (transaction tr);
    if(tr.ttype != 2) begin
        @(posedge this.vif.clk);
        this.vif.apb_port.psel_i <= 1;
        this.vif.apb_port.pwrite_i <= tr.ttype;     // write or read
        this.vif.apb_port.paddr_i <= tr.paddr;      // addr
    end
endtask

// enable_state
task apb_input_drv::enable_state (transaction tr);
    if(tr.ttype != 2) begin
        @(posedge this.vif.clk)
        this.vif.apb_port.penable_i <= 1;                                   // enable
        this.vif.apb_port.pwdata_i <= tr.ttype ? tr.pdata : 32'h0000_0000;  // write data
    end
endtask

`endif