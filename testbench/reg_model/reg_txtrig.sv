`ifndef REG_TXTRIG_SV
`define REG_TXTRIG_SV

class reg_txtrig extends uvm_reg; // -> uart_txtrig

    rand uvm_reg_field txtrig;

    `uvm_object_utils(reg_txtrig)

    extern function void build ();
    extern function      new   (string name = "reg_txtrig");

endclass

// new
function reg_txtrig::new (string name = "reg_txtrig");
    //parameter: name, size, has_coverage
    super.new(name, 32, UVM_NO_COVERAGE);
endfunction

// build
function void reg_txtrig::build ();
    txtrig = uvm_reg_field::type_id::create("txtrig");
    // parameter: parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
    txtrig.configure(this, 4, 0, "RW", 1, 0, 1, 0, 0);
endfunction

`endif