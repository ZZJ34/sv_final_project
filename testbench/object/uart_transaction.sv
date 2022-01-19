`ifndef UART_TRANSACTION_SV
`define UART_TRANSACTION_SV

// uart -> apb
class uart_transaction extends uvm_sequence_item;


    bit [31:0] pdata;       // APB data bus
    bit [31:0] paddr;       // APB address bus
    bit        pwrite;      // APB write or read signal.1:write,0:read
    bit [31:0] udata;       // UART data bit
    bit        uverify;     // UART verify bit

    extern function new (string name = "uart_transaction");
    
endclass //uart_transaction

// new
function uart_transaction::new (string name = "uart_transaction");
    super.new(name);
endfunction

`endif 