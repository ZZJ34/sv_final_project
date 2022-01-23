`ifndef REG_MODEL_SV
`define REG_MODEL_SV

`include "./reg_baud.sv"
`include "./reg_conf.sv"
`include "./reg_delay.sv"
`include "./reg_status.sv"
`include "./reg_rxtrig.sv"
`include "./reg_txtrig.sv"
`include "./reg_rxfifo_stat.sv"
`include "./reg_txfifo_stat.sv"

class reg_model extends uvm_reg_block;

    rand reg_baud baud;

    `uvm_object_utils(reg_model)

    extern function      new   (string name = "reg_model");
    extern function void build ();
    
endclass

// new
function reg_model::new (string name = "reg_model");
    super.new(name, UVM_NO_COVERAGE);
endfunction

// build
function void reg_model::build ();
    default_map = create_map("default_map", 0, 4, UVM_BIG_ENDIAN, 0);

    baud = reg_baud::type_id::create("baud", , get_full_name());
    baud.configure(this, null, "uart_baud");
    baud.build();

endfunction

`endif