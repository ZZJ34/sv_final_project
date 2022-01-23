`ifndef REG_CONF_SV
`define REG_CONF_SV

class reg_conf extends uvm_reg;  // -> uart_conf

    rand uvm_reg_field check;      // bit[0] 决定是否有校验位
    rand uvm_reg_field parity;     // bit[1] 决定奇偶校验模式   (1-奇校验，0-偶校验)
    rand uvm_reg_field stop_bit;   // bit[2] 决定是否有停止位   (只对 TX 有效)
    rand uvm_reg_field st_check;   // bit[3] 决定是否校验停止位 (只对 RX 有效)
    rand uvm_reg_field txrst;      // bit[14] 决定 TX FIFO 复位
    rand uvm_reg_field rxrst;      // bit[15] 决定 RX FIFO 复位

    `uvm_object_utils(reg_conf)

    function void build ();
    function      new   (string name = "reg_conf");

endclass

// new
function reg_conf::new (string name = "reg_conf");
    //parameter: name, size, has_coverage
    super.new(name, 32, UVM_NO_COVERAGE);
endfunction

// build
function void reg_conf::build ();
    check = uvm_reg_field::type_id::create("check");
    parity = uvm_reg_field::type_id::create("parity");
    stop_bit = uvm_reg_field::type_id::create("stop_bit");
    st_check = uvm_reg_field::type_id::create("st_check");
    txrst = uvm_reg_field::type_id::create("txrst");
    rxrst = uvm_reg_field::type_id::create("rxrst");
    // parameter: parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
    check.configure(this, 1, 0, "RW", 1, 0, 1, 0, 0);
    parity.configure(this, 1, 1, "RW", 1, 0, 1, 0, 0);
    stop_bit.configure(this, 1, 2, "RW", 1, 1, 1, 0, 0);
    st_check.configure(this, 1, 3, "RW", 1, 0, 1, 0, 0);
    txrst.configure(this, 1, 14, "RW", 1, 0, 1, 0, 0);
    rxrst.configure(this, 1, 15, "RW", 1, 0, 1, 0, 0);
endfunction

`endif

