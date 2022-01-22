`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

class scoreboard extends uvm_scoreboard;

    transaction conf_tr_expect_queue[$];
    transaction uart_tr_expect_queue[$];
    
    `uvm_component_utils(scoreboard);

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
endfunction 

// main_phase
task scoreboard::main_phase(uvm_phase phase);
    transaction expect_conf_tr, expect_uart_tr;
    super.main_phase(phase);
    fork
        // get expect_conf_tr
        while(1) begin
            conf_tr_get_port.get(expect_conf_tr);
            conf_tr_expect_queue.push_back(expect_conf_tr);
        end
        // get expect_uart_tr
        while(1) begin
            uart_tr_get_port.get(expect_uart_tr);
            uart_tr_expect_queue.push_back(expect_uart_tr);
        end
    join
endtask

`endif