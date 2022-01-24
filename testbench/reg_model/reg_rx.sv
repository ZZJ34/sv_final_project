`ifndef REG_RX_SV
`define REG_RX_SV

class reg_rx extends uvm_reg; // -> uart_rx

    rand uvm_reg_field rx_data;

    `uvm_object_utils(reg_rx)

    extern function void build ();
    extern function      new   (string name = "reg_rx");

endclass

// new
function reg_rx::new (string name = "reg_rx");
    //parameter: name, size, has_coverage
    super.new(name, 32, UVM_NO_COVERAGE);
endfunction

// build
function void reg_rx::build ();
    rx_data = uvm_reg_field::type_id::create("rx_data");
    // parameter: parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
    rx_data.configure(this, 8, 0, "RW", 1, 0, 1, 0, 0);
endfunction

`endif
