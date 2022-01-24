`ifndef TEST_CASE1_SV
`define TEST_CASE1_SV

/*
寄存器稳定性测试
测试内容：对读写寄存器保留域进行读写，对只读寄存器进行写操作。
测试通过标准：通过写入和读取，读写寄存器值是预期值不会紊乱，同时非法操作不会影响 uart 功能
*/

class case1_sequence extends uvm_sequence #(transaction);

    `uvm_object_utils(case1_sequence)

    extern function new  (string name = "case1_sequence");
    extern task     body ();

endclass
// new
function case1_sequence::new (string name = "case1_sequence");
    super.new(name);
endfunction
// body
task case1_sequence::body();

    if(this.starting_phase != null) begin
        this.starting_phase.raise_objection(this);
    end

    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h00;})
    #3000000;

    // 对只读寄存器进行写操作
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h04;})
    `uvm_do_with(req, {req.ttype == transaction::IDLE;})
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h04;})

    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h20;})
    `uvm_do_with(req, {req.ttype == transaction::IDLE;})
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h20;})

    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h24;})
    `uvm_do_with(req, {req.ttype == transaction::IDLE;})
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h24;})


    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h00;})
    #3000000;


    // 对寄存器保留位进行写操作
    `uvm_do_with(req, {
                        req.ttype == transaction::WRITE; 
                        req.paddr == 32'h0c; 
                        req.pdata[0] == 0;
                        req.pdata[1] == 0;
                        req.pdata[2] == 1;
                        req.pdata[3] == 0;
                        req.pdata[14] == 0;
                        req.pdata[15] == 0;
                        })
    `uvm_do_with(req, {req.ttype == transaction::IDLE;})
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h0c;})

    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h00;})
    #3000000;

    

    if(this.starting_phase != null) begin
        starting_phase.drop_objection(this);
    end

endtask


class test_case1 extends base_test;

    `uvm_component_utils(test_case1)

    extern         function      new         (string name = "test_case1", uvm_component parent = null);
    extern virtual function void build_phase (uvm_phase phase); 

endclass
// new
function test_case1::new (string name = "test_case1", uvm_component parent = null);
    super.new(name, parent, "test_case1");
endfunction
// build_phase
function void test_case1::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.agt_i.sqr.main_phase", "default_sequence", case1_sequence::type_id::get());

endfunction

`endif