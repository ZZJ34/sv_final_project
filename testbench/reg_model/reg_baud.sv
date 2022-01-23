`ifndef REG_BAUD_SV
`define REG_BAUD_SV

class reg_baud extends uvm_reg; // -> uart_baud

    rand uvm_reg_field baud_div;

    `uvm_object_utils(reg_baud)

    extern function void build ();
    extern function      new   (string name = "reg_baud");

endclass

// new
function reg_baud::new (string name = "reg_baud");
    //parameter: name, size, has_coverage
    super.new(name, 32, UVM_NO_COVERAGE);
endfunction

// build
function void reg_baud::build ();
    baud_div = uvm_reg_field::type_id::create("baud_div");
    // parameter: parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
    baud_div.configure(this, 10, 0, "RW", 1, 338, 1, 0, 0);
endfunction

`endif