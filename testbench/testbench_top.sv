`timescale 1ns/1ps   

`include "./pkg.svh" // 引入 uvm_pkg、uvm_macros.svh 以及所有的 UVM 设计文件

module testbench_top;

    logic clk;     // 0~100MHz
    logic clk26m;  // 26MHz

    logic rst_;    // reset for apb
    logic rst26m_; // reset for uart

    real clk_t_26m = 38;    // 26Mhz 1000/26
    real clk_t_50m = 1000/50;   // 50MHz

    // interface
    apb_uart_interface apb_uart_if(.*);
    
    // dut
    UART_TOP dut_top_inst(
        .clk(clk),
        .clk26m(clk26m),
        .rst_(rst_),
        .rst26m_(rst26m_),

        .paddr_i(apb_uart_if.paddr_i),
        .pwdata_i(apb_uart_if.pwdata_i),
        .psel_i(apb_uart_if.psel_i),
        .penable_i(apb_uart_if.penable_i),
        .pwrite_i(apb_uart_if.pwrite_i),
        .urxd_i(apb_uart_if.urxd_i),
    
        .prdata_o(apb_uart_if.prdata_o),
        .utxd_o(apb_uart_if.utxd_o),
        .uart_int_o(apb_uart_if.uart_int_o)
    );

    // clk signal
    initial begin
        clk = 0;
        forever begin
            # (clk_t_50m/2) clk = ~clk;
        end
    end

    // clk26m signal
    initial begin
        clk26m = 0;
        forever begin
            # (clk_t_26m/2) clk26m = ~clk26m;
        end
    end

    // rst_ and rst26m_ (active low)
    initial begin
        rst_ = 0;
        rst26m_ = 0;
        # 100
        rst_ = 1;
        rst26m_ = 1;
    end

    initial begin
        // $display($get_initial_random_seed);
        // $display($random);
        run_test("env");
    end

    initial begin
        uvm_config_db#(virtual apb_uart_interface)::set(null, "uvm_test_top.agt_i.apb_drv_i", "vif", apb_uart_if);
        uvm_config_db#(virtual apb_uart_interface)::set(null, "uvm_test_top.agt_i.apb_mon_i", "vif", apb_uart_if);

        uvm_config_db#(virtual apb_uart_interface)::set(null, "uvm_test_top.agt_o.uart_mon_o", "vif", apb_uart_if);
        uvm_config_db#(virtual apb_uart_interface)::set(null, "uvm_test_top.agt_o.apb_mon_o", "vif", apb_uart_if);
    end
    
endmodule