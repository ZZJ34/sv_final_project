`ifndef REG_TX_SV
`define REG_TX_SV

class reg_tx extends uvm_reg; // -> uart_tx

    rand uvm_reg_field tx_data;

    `uvm_object_utils(reg_tx)

    extern function void build ();
    extern function      new   (string name = "reg_tx");

endclass

// new
function reg_tx::new (string name = "reg_tx");
    //parameter: name, size, has_coverage
    super.new(name, 32, UVM_NO_COVERAGE);
endfunction

// build
function void reg_tx::build ();
    tx_data = uvm_reg_field::type_id::create("tx_data");
    // parameter: parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
    tx_data.configure(this, 8, 0, "RW", 1, 0, 1, 0, 0);
endfunction

`endif



