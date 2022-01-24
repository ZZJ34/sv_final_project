`ifndef TEST_CASE3_SV
`define TEST_CASE3_SV

/*
UART 特殊功能测试
测试内容：随机化配置 UART 寄存器不同的工作模式，包括波特率、奇偶校验、停止位、触发深度等多种情况，之后向 TX FIFO 写入发送的数据。
测试通过标准：UART 模块 txd 信号线发送的字符格式与配置相同。
*/

class case3_sequence extends uvm_sequence #(transaction);

    `uvm_object_utils(case3_sequence)

    extern function new  (string name = "case3_sequence");
    extern task     body ();

endclass
// new
function case3_sequence::new (string name = "case3_sequence");
    super.new(name);
endfunction
// body
task case3_sequence::body();

    if(this.starting_phase != null) begin
        this.starting_phase.raise_objection(this);
    end

    // 随机设置波特率
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h08;})
    get_response(rsp);
    // 随机设置无奇偶校验位、有停止位
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h0c; req.pdata[14] == 0; req.pdata[0] == 1;})
    get_response(rsp);
    // 随机设置 TX FIFO 触发深度
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h14; })
    get_response(rsp);
    // 随机设置帧间隔为 2
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h18; })
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
    get_response(rsp);

    #15000000;


    if(this.starting_phase != null) begin
        starting_phase.drop_objection(this);
    end

endtask


class test_case3 extends base_test;

    `uvm_component_utils(test_case3)

    extern         function      new         (string name = "test_case3", uvm_component parent = null);
    extern virtual function void build_phase (uvm_phase phase); 

endclass
// new
function test_case3::new (string name = "test_case3", uvm_component parent = null);
    super.new(name, parent, "test_case3");
endfunction
// build_phase
function void test_case3::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.agt_i.sqr.main_phase", "default_sequence", case3_sequence::type_id::get());

endfunction

`endif