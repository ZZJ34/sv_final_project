`ifndef REG_STATUS_SV
`define REG_STATUS_SV

class reg_status extends uvm_reg; // -> uart_status

    rand uvm_reg_field st_error_ack;  // bit[3]表示 RX 接收时停止位校验错误
    rand uvm_reg_field p_error_ack;   // bit[2]表示 RX 接收数据时奇偶校验错误
    rand uvm_reg_field rx_state;      // bit[1]表示 RX FIFO 触发中断
    rand uvm_reg_field tx_state;      // bit[0]表示 TX FIFO 触发中断

    `uvm_object_utils(reg_status)

    extern function void build ();
    extern function      new   (string name = "reg_status");

endclass

// new
function reg_status::new (string name = "reg_status");
    //parameter: name, size, has_coverage
    super.new(name, 32, UVM_NO_COVERAGE);
endfunction

// build
function void reg_status::build ();
    st_error_ack = uvm_reg_field::type_id::create("st_error_ack");
    p_error_ack = uvm_reg_field::type_id::create("p_error_ack");
    rx_state = uvm_reg_field::type_id::create("rx_state");
    tx_state = uvm_reg_field::type_id::create("tx_state");
    // parameter: parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
    st_error_ack.configure(this, 1, 3, "RW", 1, 0, 1, 0, 0);
    p_error_ack.configure(this, 1, 2, "RW", 1, 0, 1, 0, 0);
    rx_state.configure(this, 1, 1, "RW", 1, 0, 1, 0, 0);
    tx_state.configure(this, 1, 0, "RW", 1, 0, 1, 0, 0);
endfunction

`endif
