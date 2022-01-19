`ifndef UART_OUTPUT_MONITOR_SV
`define UART_OUTPUT_MONITOR_SV

class uart_output_mon extends uvm_monitor;

    virtual apb_uart_interface vif; 

    `uvm_component_utils(uart_output_mon)

    extern function      new         (string name = "uart_output_mon", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase); 
    extern task          main_phase  (uvm_phase phase);

endclass //uart_output_mon

function uart_output_mon::new (string name = "uart_output_mon", uvm_component parent = null);
    super.new(name, parent);
endfunction