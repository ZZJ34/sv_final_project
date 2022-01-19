`ifndef APB_UART_INTERFACE_SV
`define APB_UART_INTERFACE_SV


interface apb_uart_interface(input clk, input clk26m, input rst_, input rst26m_);
    logic [31:0] paddr_i;             // APB address bus
    logic [31:0] pwdata_i;            // APB write data bus
    logic [31:0] prdata_o;            // APB read data bus
    logic        psel_i;              // APB module select signal,high active
    logic        penable_i;           // APB module enable signal,high cative
    logic        pwrite_i;            // APB write or read signal.1:write,0:read
    logic        urxd_i;              // UART receive data line
    logic        utxd_o;              // UART send data line
    logic        uart_int_o;          // UART interrupt signal.active high

    clocking apb_port @(posedge clk);
        default input #1ns output #1ns;
        output paddr_i, pwdata_i, psel_i, penable_i, pwrite_i;
        input uart_int_o, prdata_o;
    endclocking:apb_port

    clocking uart_port @(posedge clk26m);
        default input #1ns output #1ns;
        output urxd_i;
        input utxd_o;
    endclocking:uart_port

endinterface //apb_uart_interface


`endif


