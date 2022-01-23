`ifndef REG_DELAY_SV
`define REG_DELAY_SV

class reg_delay extends uvm_reg; // -> uart_delay

    rand uvm_reg_field two_tx_delay;

    `uvm_object_utils(reg_delay)

    extern function void build ();
    extern function      new   (string name = "reg_delay");

endclass

// new
function reg_delay::new (string name = "reg_delay");
    //parameter: name, size, has_coverage
    super.new(name, 32, UVM_NO_COVERAGE);
endfunction

// build
function void reg_delay::build ();
    two_tx_delay = uvm_reg_field::type_id::create("two_tx_delay");
    // parameter: parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
    two_tx_delay.configure(this, 4, 0, "RW", 1, 2, 1, 0, 0);
endfunction

`endif