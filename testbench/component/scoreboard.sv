`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

class scoreboard extends uvm_scoreboard;

    transaction uart_tr_expect_queue[$];

    reg_model rm;
    
    `uvm_component_utils(scoreboard)

    // model -> scoreboard
    uvm_blocking_get_port #(transaction)  conf_tr_get_port;  // transaction for transaction for register configuration
    uvm_blocking_get_port #(transaction)  uart_tr_get_port;  // transaction for uart send data

    // out_agnet -> scoreboard
    uvm_blocking_get_port #(transaction) agt_o2scb_get_port;

    extern function      new         (string name = "scoreboard", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase);
    extern task          main_phase  (uvm_phase phase);

endclass // scoreboard

// new
function scoreboard::new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
endfunction

// build_phase
function void scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // instance conf_tr_get_port
    conf_tr_get_port = new("conf_tr_get_port", this);
    // instance uart_tr_get_port
    uart_tr_get_port = new("uart_tr_get_port", this);
    // instance agt_o2scb_get_port
    agt_o2scb_get_port = new("agt_o2scb_get_port", this);

    rm = reg_model::type_id::create("rm", this);
    rm.configure(null, "");
    rm.build();
    rm.lock_model();
    rm.reset();
    rm.set_hdl_path_root("testbench_top.dut_top_inst.uart_reg_if");
    
endfunction 

// main_phase
task scoreboard::main_phase(uvm_phase phase);
    transaction expect_conf_tr, expect_uart_tr, temp_uart_tr, actual_uart_tr;
    uvm_status_e var_status;
    uvm_reg_data_t var_value;
    super.main_phase(phase);
    fork
        // get expect_conf_tr and check
        while(1) begin
            conf_tr_get_port.get(expect_conf_tr);
            #10
            // tx
            if(expect_conf_tr.paddr == 32'h00) rm.tx.peek(var_status, var_value);
            // buad
            if(expect_conf_tr.paddr == 32'h08) rm.baud.peek(var_status, var_value);
            // delay
            if(expect_conf_tr.paddr == 32'h18) rm.delay.peek(var_status, var_value);
            // rxtrig
            if(expect_conf_tr.paddr == 32'h10) rm.rxtrig.peek(var_status, var_value);
            // txtrig
            if(expect_conf_tr.paddr == 32'h14) rm.txtrig.peek(var_status, var_value);
            // rxfifo_stat
            if(expect_conf_tr.paddr == 32'h20) rm.rxfifo_stat.peek(var_status, var_value);
            // txfifo_stat
            if(expect_conf_tr.paddr == 32'h24) rm.txfifo_stat.peek(var_status, var_value);
            // conf
            if(expect_conf_tr.paddr == 32'h0c) rm.conf.peek(var_status, var_value);
            // status
            if(expect_conf_tr.paddr == 32'h1c) rm.status.peek(var_status, var_value);

            if(expect_conf_tr.pdata == var_value) begin
                `uvm_info("scoreboard", "\nCompare APB REG SUCCESSFULLY", UVM_LOW);
            end
            else begin
                `uvm_error("scoreboard", "\nCompare APB REG FAILED");
                $display("the expect apb_tr is");
                expect_conf_tr.print_apb_info();
                $display("the actual apb reg data is: %d", var_value);
            end


        end
        // get expect_uart_tr
        while(1) begin
            uart_tr_get_port.get(expect_uart_tr);
            uart_tr_expect_queue.push_back(expect_uart_tr);
        end
        // check uart_tr
        while(1) begin
            agt_o2scb_get_port.get(actual_uart_tr);

            if(uart_tr_expect_queue.size() > 0) begin
                temp_uart_tr = uart_tr_expect_queue.pop_front();

                if(temp_uart_tr.compare(actual_uart_tr)) begin
                    `uvm_info("scoreboard", "\nCompare UART DATA SUCCESSFULLY", UVM_LOW);
                end
                else begin
                    `uvm_error("scoreboard", "\nCompare UART DATA FAILED");
                    $display("the expect uart_tr is");
                    temp_uart_tr.print_uart_info();
                    $display("the actual uart_tr is");
                    actual_uart_tr.print_uart_info();
                end
            end
            else begin
                `uvm_error("scoreboard", "\nReceived data from uart , while expect uart_queue is empty");
                $display("the unexpected uart_tr is");
                actual_uart_tr.print_uart_info();
            end
        end
    join
endtask

`endif