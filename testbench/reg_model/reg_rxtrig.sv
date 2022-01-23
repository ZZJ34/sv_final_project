`ifndef REG_RXTRIG_SV
`define REG_RXTRIG_SV

class reg_rxtrig extends uvm_reg; // -> uart_rxtrig

    rand uvm_reg_field rxtrig;

    `uvm_object_utils(reg_rxtrig)

    extern function void build ();
    extern function      new   (string name = "reg_rxtrig");

endclass

// new
function reg_rxtrig::new (string name = "reg_rxtrig");
    //parameter: name, size, has_coverage
    super.new(name, 32, UVM_NO_COVERAGE);
endfunction

// build
function void reg_rxtrig::build ();
    rxtrig = uvm_reg_field::type_id::create("rxtrig");
    // parameter: parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
    rxtrig.configure(this, 4, 0, "RW", 1, 1, 1, 0, 0);
endfunction

`endif