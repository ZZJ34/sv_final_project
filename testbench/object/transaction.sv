`ifndef APB_TRANSACTION_SV
`define APB_TRANSACTION_SV

class transaction extends uvm_sequence_item;


    bit [31:0] pdata;       // APB data bus
    bit [31:0] paddr;       // APB address bus
    bit        pwrite;      // APB write or read signal.1:write,0:read
    bit [7:0]  udata;       // UART data bit
    bit [1:0]  uverify;     // UART verify bit

    `uvm_object_utils(transaction);

    extern function      new (string name = "transaction");
    extern function void print_apb_info ();
    extern function void print_uart_info ();
    extern function bit  compare(transaction tr);
    
endclass //transaction

// new
function transaction::new (string name = "transaction");
    super.new(name);
endfunction

// compare
function bit transaction::compare (transaction tr);
    return this.udata == tr.udata && this.uverify == tr.uverify;
endfunction

// print_apb_info
function void transaction::print_apb_info ();
 	string s;
    string description_s;

    case (this.paddr)
        32'h00: description_s = "[R/W]uart send data";
        32'h04: description_s = "[R]uart receive data";
        32'h08: description_s = "[R/W]uart baud control";
        32'h0c: description_s = "[R/W]uart function control";
        32'h10: description_s = "[R/W]uart rx fifo trigger depth";
        32'h14: description_s = "[R/W]uart tx fifo trigger depth";
        32'h18: description_s = "[R/W]uart send frame interval";
        32'h1c: description_s = "[R/W]uart status register";
        32'h20: description_s = "[R]rx fifo status";
        32'h24: description_s = "[R]tx fifo status";
        default: description_s = "illegal address";
    endcase

 	s={s,$sformatf("=======================================================\n")};
 	s={s,$sformatf("       addr : %2h\n", this.paddr)};
    s={s,$sformatf("description : %s\n", description_s)};
    s={s,$sformatf("  direction : %s\n", this.pwrite ? "write" : "read")};
    s={s,$sformatf("    data(b) : %8b\n", this.pdata)};
    s={s,$sformatf("    data(d) : %0d\n", this.pdata)};
    s={s,$sformatf("    data(h) : %2h\n", this.pdata)};
	s={s,"======================================================="};
 	$display("%s",s);
endfunction

// print_uart_info
function void transaction::print_uart_info ();
    string s;
    s={s,$sformatf("=======================================================\n")};
 	s={s,$sformatf("     data(b) : %8b\n", this.udata)};
    s={s,$sformatf("     data(d) : %0d\n", this.udata)};
    s={s,$sformatf("     data(h) : %2h\n", this.udata)};
    if(this.uverify[1])
        s={s,$sformatf("    uverify : %0b\n", this.uverify[0])};
    else
        s={s,$sformatf("     no verify bit\n")};
	s={s,"======================================================="};
 	$display("%s",s);
endfunction

`endif 