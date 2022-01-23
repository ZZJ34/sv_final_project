`ifndef APB_TRANSACTION_SV
`define APB_TRANSACTION_SV

class transaction extends uvm_sequence_item;

    // APB write or read signal.1:write,0:read 
    typedef enum{READ=0, WRITE=1, IDLE=2}  trans_type;

    
	rand trans_type ttype;       // transaction type

    rand bit [31:0] pdata;       // APB data bus
    rand bit [31:0] paddr;       // APB address bus
    bit [7:0]  udata;            // UART data bit
    bit [1:0]  uverify;          // UART verify bit
    

    `uvm_object_utils_begin(transaction)
        `uvm_field_enum(trans_type, ttype, UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_sarray_int(pdata, UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_sarray_int(paddr, UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_sarray_int(udata, UVM_ALL_ON)
        `uvm_field_sarray_int(uverify, UVM_ALL_ON)
    `uvm_object_utils_end

    constraint c_paddr {
        soft paddr inside {32'h00, 32'h04, 32'h08, 32'h0c, 32'h10, 32'h14, 32'h18, 32'h1c, 32'h20, 32'h24};
    }

    constraint c_pdata {
        soft (ttype == WRITE) -> (paddr == 32'h00) -> pdata inside {[32'h00: 32'hff]};
        soft (ttype == WRITE) -> (paddr == 32'h08) -> pdata inside {[32'd13: 32'd676]};
        soft (ttype == WRITE) -> (paddr == 32'h0c) -> pdata[31:16] == 16'b0;
        soft (ttype == WRITE) -> (paddr == 32'h10) -> pdata inside {[32'd1: 32'd8]};
        soft (ttype == WRITE) -> (paddr == 32'h14) -> pdata inside {[32'd0: 32'd8]};
        soft (ttype == WRITE) -> (paddr == 32'h18) -> pdata inside {[32'd0: 32'd8]};
        soft (ttype == WRITE) -> (paddr == 32'h1c) -> pdata == 32'h1;
    }

    constraint c_order {
        solve ttype before paddr;
        solve paddr before pdata;
    }


    extern function      new (string name = "transaction");
    extern function void print_apb_info ();
    extern function void print_uart_info ();
    
endclass //transaction

// new
function transaction::new (string name = "transaction");
    super.new(name);
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
    if (this.ttype != 2) begin
        s={s,$sformatf("       addr : %2h\n", this.paddr)};
        s={s,$sformatf("description : %s\n", description_s)};
        s={s,$sformatf("  direction : %s\n", this.ttype ? "write" : "read")};
        if(this.paddr == 32'h00 || this.paddr == 32'h04) begin
            s={s,$sformatf("    data(b) : %8b\n", this.pdata)};
            s={s,$sformatf("    data(d) : %0d\n", this.pdata)};
            s={s,$sformatf("    data(h) : %2h\n", this.pdata)};
        end
        else if(this.paddr == 32'h08) begin
            s={s,$sformatf("    data(b) : %10b\n", this.pdata)};
            s={s,$sformatf("    data(d) : %0d\n", this.pdata)};
            s={s,$sformatf("    data(h) : %3h\n", this.pdata)};
        end
        else if(this.paddr == 32'h0c) begin
            s={s,$sformatf("    data(b) : %16b\n", this.pdata)};
            s={s,$sformatf("    data(d) : %0d\n", this.pdata)};
            s={s,$sformatf("    data(h) : %4h\n", this.pdata)};
        end
        else if(this.paddr == 32'h10 || this.paddr == 32'h14 || this.paddr == 32'h18 || this.paddr == 32'h1c) begin
            s={s,$sformatf("    data(b) : %4b\n", this.pdata)};
            s={s,$sformatf("    data(d) : %0d\n", this.pdata)};
            s={s,$sformatf("    data(h) : %1h\n", this.pdata)};
        end
        else if(this.paddr == 32'h20 || this.paddr == 32'h24) begin
            s={s,$sformatf("    data(b) : %5b\n", this.pdata)};
            s={s,$sformatf("    data(d) : %0d\n", this.pdata)};
            s={s,$sformatf("    data(h) : %2h\n", this.pdata)};
        end
    end
    else begin
        s={s,$sformatf("%s", "do nothing")};
    end
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