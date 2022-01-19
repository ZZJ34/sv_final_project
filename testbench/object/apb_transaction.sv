`ifndef APB_TRANSACTION_SV
`define APB_TRANSACTION_SV

// apb -> uart
class apb_transaction extends uvm_sequence_item;


    bit [31:0] pdata;       // APB data bus
    bit [31:0] paddr;       // APB address bus
    bit        pwrite;      // APB write or read signal.1:write,0:read
    bit [31:0] udata;       // UART data bit
    bit        uverify;     // UART verify bit

    `uvm_object_utils(apb_transaction);

    extern function      new (string name = "apb_transaction");
    extern function void print_info ();
    
endclass //apb_transaction

// new
function apb_transaction::new (string name = "apb_transaction");
    super.new(name);
endfunction

function void apb_transaction::print_info ();
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
 	s={s,$sformatf("       addr : %0h\n", this.paddr)};
    s={s,$sformatf("description : %s\n", description_s)};
    s={s,$sformatf("  direction : %s\n", this.pwrite ? "write" : "read")};
    if(this.pwrite) begin
        s={s,$sformatf("    data(d) : %0d\n", this.pdata)};
        s={s,$sformatf("    data(h) : %0h\n", this.pdata)};
    end
	s={s,"======================================================="};
 	$display("%s",s);
endfunction


`endif 