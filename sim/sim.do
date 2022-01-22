# 新建 work 库并设置映射关系
vlib work

# 定义变量
set UVM_HOME F:/questasim64_10.6c/verilog_src/uvm-1.1d   
set WORK_HOME D:/sv_final_project/
# 初始种子值
# set SEED [expr int(rand() * 100)]
set SEED 34

# 编译
vlog +incdir+$UVM_HOME/src -novopt $UVM_HOME/src/uvm_pkg.sv $WORK_HOME/apb_uart_code/*.v $WORK_HOME/testbench/testbench_top.sv

# 仿真
vsim -onfinish stop -sv_seed $SEED -coverage -assertdebug -novopt -c -sv_lib F:/questasim64_10.6c/uvm-1.1d/win64/uvm_dpi work.testbench_top 

# 仿真设置
proc external_editor {filename linenumber} { exec "F:/VS code/Microsoft VS Code/Code.exe" -g $filename:$linenumber}
set PrefSource(altEditor) external_editor

# 波形设置

add wave -expand -group 26MHz_clk /testbench_top/clk26m
add wave -expand -group 26MHz_clk /testbench_top/rst26m_
add wave -expand -group system_clk /testbench_top/clk
add wave -expand -group system_clk /testbench_top/rst_

add wave -expand -group apb_bus /testbench_top/apb_uart_if/paddr_i
add wave -expand -group apb_bus /testbench_top/apb_uart_if/pwrite_i
add wave -expand -group apb_bus /testbench_top/apb_uart_if/psel_i
add wave -expand -group apb_bus /testbench_top/apb_uart_if/penable_i
add wave -expand -group apb_bus /testbench_top/apb_uart_if/pwdata_i
add wave -expand -group apb_bus /testbench_top/apb_uart_if/prdata_o
add wave -expand -group apb_bus /testbench_top/apb_uart_if/uart_int_o

add wave -expand -group uart /testbench_top/apb_uart_if/urxd_i
add wave -expand -group uart /testbench_top/apb_uart_if/utxd_o
add wave -expand -group uart /testbench_top/dut_top_inst/uart_tx/tx_bpsclk  

add wave -expand -group assert /testbench_top/apb_uart_if/assert__check_multiple_tr_penable_i 
add wave -expand -group assert /testbench_top/apb_uart_if/assert__check_single_tr_penable_i

# 设置仿真波形时间单位
configure wave -timelineunits ns
update

# 设置波形缩放
WaveRestoreZoom {0 ns} {500 ns}

run -all