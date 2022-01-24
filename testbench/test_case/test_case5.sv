`ifndef TEST_CASE5_SV
`define TEST_CASE5_SV

/*
覆盖率测试
*/

class case5_sequence extends uvm_sequence #(transaction);

    `uvm_object_utils(case5_sequence)

    extern function new  (string name = "case5_sequence");
    extern task     body ();

endclass
// new
function case5_sequence::new (string name = "case5_sequence");
    super.new(name);
endfunction
// body
task case5_sequence::body();
    int count;

    if(this.starting_phase != null) begin
        this.starting_phase.raise_objection(this);
    end

    for(int i = 0; i < 710; i++) begin
        // 设置波特率
        `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h08;})
        get_response(rsp);
        // 设置奇偶校验位、停止位
        `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h0c; req.pdata[14] == 0;})
        get_response(rsp);
        // 设置 TX FIFO 触发深度
        `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h14; })
        get_response(rsp);
        // 帧间隔
        `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h18; })
        get_response(rsp);

        `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h00;})
        get_response(rsp);
        `uvm_do_with(req, {req.ttype == transaction::IDLE;})
        get_response(rsp);
        `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h00;})
        get_response(rsp);

        #10000000;
    end



    // 设置波特率
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h08; req.pdata == 13;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h08; })
    get_response(rsp);
    // 设置奇偶校验位、停止位
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h0c; req.pdata[14] == 0;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h0c; })
    get_response(rsp);
    // 设置 TX FIFO 触发深度
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h14; })
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h14; })
    get_response(rsp);
    // 帧间隔
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h18; })
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h18; })
    get_response(rsp);

    // 传输数据
    count = 0;
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

    #80000000;



    if(this.starting_phase != null) begin
        starting_phase.drop_objection(this);
    end

endtask


class test_case5 extends base_test;

    `uvm_component_utils(test_case5)

    extern         function      new         (string name = "test_case5", uvm_component parent = null);
    extern virtual function void build_phase (uvm_phase phase); 

endclass
// new
function test_case5::new (string name = "test_case5", uvm_component parent = null);
    super.new(name, parent, "test_case5");
endfunction
// build_phase
function void test_case5::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.agt_i.sqr.main_phase", "default_sequence", case5_sequence::type_id::get());

endfunction

`endif