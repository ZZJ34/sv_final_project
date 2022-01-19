`ifndef APB_TRANSACTION_SV
`define APB_TRANSACTION_SV

// apb -> uart
class apb_transaction extends uvm_sequence_item;


    bit [31:0] pdata;       // APB data bus
    bit [31:0] paddr;       // APB address bus
    bit        pwrite;      // APB write or read signal.1:write,0:read
    bit [31:0] udata;       // UART data bit
    bit        uverify;     // UART verify bit

    extern function new (string name = "apb_transaction");
    
endclass //apb_transaction

// new
function apb_transaction::new (string name = "apb_transaction");
    super.new(name);
endfunction

`endif 