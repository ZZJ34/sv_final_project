`ifndef REG_MODEL_SV
`define REG_MODEL_SV

class reg_model extends uvm_reg_block;

    rand reg_baud baud;
    rand reg_delay delay;
    rand reg_rxtrig rxtrig;
    rand reg_txtrig txtrig;
    rand reg_rxfifo_stat rxfifo_stat;
    rand reg_txfifo_stat txfifo_stat;
    rand reg_conf conf;
    rand reg_status status;
    rand reg_tx tx;

    `uvm_object_utils(reg_model)

    extern function      new   (string name = "reg_model");
    extern function void build ();
    
endclass

// new
function reg_model::new (string name = "reg_model");
    super.new(name, UVM_NO_COVERAGE);
endfunction

// build
function void reg_model::build ();

    // uart_baud
    baud = reg_baud::type_id::create("baud", , get_full_name());
    baud.configure(this, null, "uart_baud");
    baud.build();

    // uart_delay
    delay = reg_delay::type_id::create("delay", , get_full_name());
    delay.configure(this, null, "uart_delay");
    delay.build();

    // uart_rxtrig
    rxtrig = reg_rxtrig::type_id::create("rxtrig", , get_full_name());
    rxtrig.configure(this, null, "uart_rxtrig");
    rxtrig.build();

    // uart_txtrig
    txtrig = reg_txtrig::type_id::create("txtrig", , get_full_name());
    txtrig.configure(this, null, "uart_txtrig");
    txtrig.build();

    // uart_rxfifo_stat
    rxfifo_stat = reg_rxfifo_stat::type_id::create("rxfifo_stat", , get_full_name());
    rxfifo_stat.configure(this, null, "uart_rxfifo_stat");
    rxfifo_stat.build();

    // uart_txfifo_stat
    txfifo_stat = reg_txfifo_stat::type_id::create("txfifo_stat", , get_full_name());
    txfifo_stat.configure(this, null, "uart_txfifo_stat");
    txfifo_stat.build();

    // uart_conf
    conf = reg_conf::type_id::create("conf", , get_full_name());
    conf.configure(this, null, "uart_conf");
    conf.build();

    // uart_status
    status = reg_status::type_id::create("status", , get_full_name());
    status.configure(this, null, "uart_status");
    status.build();

    // uart_tx
    tx = reg_tx::type_id::create("tx", , get_full_name());
    tx.configure(this, null, "uart_tx");
    tx.build();
endfunction

`endif