`ifndef TEST_CASE4_SV
`define TEST_CASE4_SV

/*
UART 中断测试
测试内容：配置 TX FIFO 触发深度，向 TX FIFO 中连续写入 16 个数据，等待 UART 发送一定数量数据后触发中断。
测试通过标准：中断信号拉高，此时读取状态寄存器，判断中断情况，之后清除状态寄存器，中断信号拉低。
*/

class case4_sequence extends uvm_sequence #(transaction);

    `uvm_object_utils(case4_sequence)

    extern function new  (string name = "case4_sequence");
    extern task     body ();

endclass
// new
function case4_sequence::new (string name = "case4_sequence");
    super.new(name);
endfunction
// body
task case4_sequence::body();

    int count = 0;

    if(this.starting_phase != null) begin
        this.starting_phase.raise_objection(this);
    end

    // 设置 TX FIFO 触发深度 5
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h14; req.pdata == 5;})
    `uvm_do_with(req, {req.ttype == transaction::IDLE;})

    // 传输数据
    while (1) begin
        if(count <= 16) begin
            `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h00;})
            get_response(rsp);
            `uvm_do_with(req, {req.ttype == transaction::IDLE;})
            get_response(rsp);
            count += 1;
        end
        else begin
            `uvm_do_with(req, {req.ttype == transaction::IDLE;})
            get_response(rsp);
        end

        

        if(rsp.ttype == transaction::UART_INT) begin
            `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h1c;})
            get_response(rsp);
            break;
        end

    end


    #30000000;


    if(this.starting_phase != null) begin
        starting_phase.drop_objection(this);
    end

endtask


class test_case4 extends base_test;

    `uvm_component_utils(test_case4)

    extern         function      new         (string name = "test_case4", uvm_component parent = null);
    extern virtual function void build_phase (uvm_phase phase); 

endclass
// new
function test_case4::new (string name = "test_case4", uvm_component parent = null);
    super.new(name, parent, "test_case4");
endfunction
// build_phase
function void test_case4::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.agt_i.sqr.main_phase", "default_sequence", case4_sequence::type_id::get());

endfunction

`endif