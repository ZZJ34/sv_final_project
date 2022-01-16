`timescale 1ns/1ps   

`include "./pkg.svh" // 引入 uvm_pkg、uvm_macros.svh 以及所有的 UVM 设计文件

module testbench_top;

    initial begin
        $display($get_initial_random_seed);
        $display($random);
    end
    
endmodule