`ifndef TEST_CASE2_SV
`define TEST_CASE2_SV

/*
UART 模块基础功能测试
测试内容：配置 UART 基础功能寄存器，波特率设置 115200，无奇偶校验位，有停止位，TX FIFO 触发深度为 0，帧间隔为 2，之后向 TX FIFO 写入发送的数据。
测试通过标准：UART 模块 txd 信号线发送的字符格式与配置相同。
*/

class case2_sequence extends uvm_sequence #(transaction);

    `uvm_object_utils(case2_sequence)

    extern function new  (string name = "case2_sequence");
    extern task     body ();

endclass
// new
function case2_sequence::new (string name = "case2_sequence");
    super.new(name);
endfunction
// body
task case2_sequence::body();

    if(this.starting_phase != null) begin
        this.starting_phase.raise_objection(this);
    end

    // 设置波特率
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h08; req.pdata == 13;})
    get_response(rsp);
    // 设置无奇偶校验位、有停止位
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h0c; req.pdata[0] == 0; req.pdata[2] == 1; req.pdata[14] == 0;})
    get_response(rsp);
    // 设置 TX FIFO 触发深度为 0
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h14; req.pdata == 0;})
    get_response(rsp);
    // 帧间隔为 2
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h18; req.pdata == 2;})
    get_response(rsp);

    // 发送数据
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h00;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::IDLE;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h00;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::IDLE;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h00;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::IDLE;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h00;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::IDLE;})

    #450000;


    if(this.starting_phase != null) begin
        starting_phase.drop_objection(this);
    end

endtask


class test_case2 extends base_test;

    `uvm_component_utils(test_case2)

    extern         function      new         (string name = "test_case2", uvm_component parent = null);
    extern virtual function void build_phase (uvm_phase phase); 

endclass
// new
function test_case2::new (string name = "test_case2", uvm_component parent = null);
    super.new(name, parent, "test_case2");
endfunction
// build_phase
function void test_case2::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.agt_i.sqr.main_phase", "default_sequence", case2_sequence::type_id::get());

endfunction

`endif