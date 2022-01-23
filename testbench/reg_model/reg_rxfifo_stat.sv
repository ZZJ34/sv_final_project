`ifndef REG_RXFIFO_STAT_SV
`define REG_RXFIFO_STAT_SV

class reg_rxfifo_stat extends uvm_reg; // -> uart_rxfifo_stat

    rand uvm_reg_field rxfifo_stat;

    `uvm_object_utils(reg_rxfifo_stat)

    extern function void build ();
    extern function      new   (string name = "reg_rxfifo_stat");

endclass

// new
function reg_rxfifo_stat::new (string name = "reg_rxfifo_stat");
    //parameter: name, size, has_coverage
    super.new(name, 32, UVM_NO_COVERAGE);
endfunction

// build
function void reg_rxfifo_stat::build ();
    rxfifo_stat = uvm_reg_field::type_id::create("rxfifo_stat");
    // parameter: parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
    rxfifo_stat.configure(this, 5, 0, "RW", 1, 0, 1, 0, 0);
endfunction

`endif