`timescale 1ns/1ps   

`include "./pkg.svh" // 引入 uvm_pkg、uvm_macros.svh 以及所有的 UVM 设计文件

module testbench_top;

    logic clk;     // 0~100MHz
    logic clk26m;  // 26MHz

    logic rst_;    // reset for apb
    logic rst26m_; // reset for uart

    real clk_t_26m = 38.461;    // 26Mhz 1000/26
    real clk_t_50m = 1000/50;   // 50MHz

    // interface
    apb_uart_interface apb_uart_if(.*);
    
    // dut
    UART_TOP dut_top_inst(
        .clk(clk),
        .clk26m(clk26m),
        .rst_(rst_),
        .rst26m_(rst26m_),

        .paddr_i(),
        .pwdata_i(),
        .psel_i(),
        .penable_i(),
        .pwrite_i(),
        .urxd_i(),
    
        .prdata_o(),
        .utxd_o(),
        .uart_int_o()
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
        # 200 
        rst_ = 1;
        rst26m_ = 1;
    end

    initial begin
        $display($get_initial_random_seed);
        $display($random);
        $display(clk_t_26m);
    end
    
endmodule