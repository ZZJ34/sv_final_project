`ifndef REG_TXFIFO_STAT_SV
`define REG_TXFIFO_STAT_SV

class reg_txfifo_stat extends uvm_reg; // -> uart_txfifo_stat

    rand uvm_reg_field txfifo_stat;

    `uvm_object_utils(reg_txfifo_stat)

    extern function void build ();
    extern function      new   (string name = "reg_txfifo_stat");

endclass

// new
function reg_txfifo_stat::new (string name = "reg_txfifo_stat");
    //parameter: name, size, has_coverage
    super.new(name, 32, UVM_NO_COVERAGE);
endfunction

// build
function void reg_txfifo_stat::build ();
    txfifo_stat = uvm_reg_field::type_id::create("txfifo_stat");
    // parameter: parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
    txfifo_stat.configure(this, 5, 0, "RW", 1, 0, 1, 0, 0);
endfunction

`endif