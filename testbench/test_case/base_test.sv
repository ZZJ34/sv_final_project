`ifndef BASE_TEST_SV
`define BASE_TEST_SV

class base_test extends uvm_test;

    top_env env;
    string  test_name;

    `uvm_component_utils(base_test)
   
    extern function      new         (string name = "base_test", uvm_component parent = null, string test_name = "");
    extern function void build_phase (uvm_phase phase);
    extern function void report_phase(uvm_phase phase);

endclass

// new
function base_test::new (string name = "base_test", uvm_component parent = null, string test_name = "");
    super.new(name,parent);
    this.test_name = test_name;
endfunction

// build_phase
function void base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = top_env::type_id::create("env", this);
endfunction

// report_phase
function void base_test::report_phase(uvm_phase phase);
    uvm_report_server server;
   
    int err_num;
    super.report_phase(phase);

    server = get_report_server();
    err_num = server.get_severity_count(UVM_ERROR);

    if (err_num != 0) begin
        `uvm_info("base_test", $sformatf("\n%s : TEST CASE FAILED", this.test_name), UVM_LOW);
    end
    else begin
        `uvm_info("base_test", $sformatf("\n%s : TEST CASE PASSED", this.test_name), UVM_LOW);
    end

endfunction

`endif
