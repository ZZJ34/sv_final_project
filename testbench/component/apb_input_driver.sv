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
    extern task          response    (transaction tr);

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
    // wait reset end
    wait(this.vif.rst_ == 1);
    idle_state();
    // drive
    while (1) begin
        seq_item_port.try_next_item(req);
        if(req == null)
            idle_state();
        else if (req.ttype == transaction::IDLE) begin
            idle_state();
            response(req);
            seq_item_port.item_done();
        end
        else begin
            setup_state(req);
            enable_state(req);
            response(req);
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

// return response
task apb_input_drv::response (transaction tr);
    rsp = new("rsp");
    rsp.set_id_info(tr);
    if(this.vif.apb_port.uart_int_o == 1) rsp.ttype = transaction::UART_INT;
    seq_item_port.put_response(rsp);
endtask

`endif