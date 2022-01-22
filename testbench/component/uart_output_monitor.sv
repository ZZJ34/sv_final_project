`ifndef UART_OUTPUT_MONITOR_SV
`define UART_OUTPUT_MONITOR_SV

class uart_output_mon extends uvm_monitor;

    virtual apb_uart_interface vif;

    int baud_div ;   // frequency division factor. default 10'd338
    bit check    ;   // check bit. default 0(none)

    `uvm_component_utils(uart_output_mon)

    // apb_input_mon -> uart_output_mon
    uvm_analysis_imp#(transaction, uart_output_mon) uart_tx_set_imp;

    // uart_output_mon -> scoreboard
    uvm_analysis_port#(transaction) uart_mon_o2scb_port;

    extern function      new           (string name = "uart_output_mon", uvm_component parent = null);
    extern function void build_phase   (uvm_phase phase); 
    extern task          main_phase    (uvm_phase phase);
    extern function void write         (transaction tr);

endclass //uart_output_mon

// new 
function uart_output_mon::new (string name = "uart_output_mon", uvm_component parent = null);
    super.new(name, parent);
    // initial baud rate
    this.baud_div = 10'd338;
    // initial check
    this.check = 0;
endfunction

// build_phase
function void uart_output_mon::build_phase (uvm_phase phase);
    super.build_phase(phase);
    // set apb_uart_interface
    if(!uvm_config_db#(virtual apb_uart_interface)::get(this, "", "vif", vif)) begin
        `uvm_fatal("uart_output_mon", "virtual interface must be set for vif!!!");
    end
    // initialize imp
    uart_tx_set_imp = new("uart_tx_set_imp", this);

    // initialize uart_mon_o2scb_port
    uart_mon_o2scb_port = new("uart_mon_o2scb_port", this);
endfunction

// main_phase
task uart_output_mon::main_phase (uvm_phase phase);
    transaction tr;

    bit uart_data_history = 1;
    bit uart_data_start = 0;
    int uart_data_cnt = 0;
    int uart_baud_cnt = 0;

    bit[8:0] uart_data;

    // wait reset end
    wait(this.vif.rst26m_ == 1);
    // collect one uart data
    while (1) begin

        @(posedge this.vif.clk26m);

        // detect falling edge
        if(~uart_data_start && uart_data_history && ~this.vif.uart_port.utxd_o) begin
            `uvm_info("uart_output_mon", "\n uart falling edge!", UVM_LOW);
            uart_data_start = 1;
            uart_baud_cnt = 0;
            uart_data_cnt= 0;
        end
        
        uart_data_history = this.vif.uart_port.utxd_o;

        // data
        if(uart_data_start) begin
            uart_baud_cnt = uart_baud_cnt  > ((this.baud_div + 1) << 4) - 1 ? 0 : uart_baud_cnt + 1;

            uart_data_cnt = uart_baud_cnt == ((this.baud_div + 1) << 4) - 1 ? uart_data_cnt + 1 : uart_data_cnt;

            if(uart_baud_cnt == ((this.baud_div + 1) << 4)/2 && uart_data_cnt != 0) begin
                uart_data[uart_data_cnt-1] = this.vif.uart_port.utxd_o;
            end
        
                
            if(uart_data_cnt == (9 + this.check)) begin
                uart_data_start = 0;

                tr = new("tr");
                tr.udata = uart_data[7:0];
                tr.uverify = this.check ? {1'b1, uart_data[8]} : 2'b00;

                `uvm_info("uart_output_mon", "\n collect one uart data", UVM_LOW);
                tr.print_uart_info();

                // to scoreborad
                uart_mon_o2scb_port.write(tr);
            end

        end
    end
endtask

// write
function void uart_output_mon::write (transaction tr);
    // set baud
    if(tr.paddr == 32'h08) begin
        this.baud_div = tr.pdata;
        `uvm_info("uart_output_mon", "\n set receive baud_div", UVM_LOW);
        $display(this.baud_div);
    end
    // set check
    if(tr.paddr == 32'h0c) begin
        this.check = tr.pdata[0];
        `uvm_info("uart_output_mon", "\n set check bit", UVM_LOW);
        $display(this.check);
    end
endfunction

`endif