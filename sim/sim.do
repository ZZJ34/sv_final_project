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
vsim -onfinish stop -sv_seed $SEED -assertdebug -novopt -c -sv_lib F:/questasim64_10.6c/uvm-1.1d/win64/uvm_dpi work.testbench_top 

# 仿真设置
proc external_editor {filename linenumber} { exec "F:/VS code/Microsoft VS Code/Code.exe" -g $filename:$linenumber}
set PrefSource(altEditor) external_editor

run -all