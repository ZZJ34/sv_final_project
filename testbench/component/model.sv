`ifndef MODEL_SV
`define MODEL_SV

class model extends uvm_component;

   
    `uvm_component_utils(model)

    bit check ; // check bit. default 0(none)
    bit parity; // parity. defalut 0(odd parity) ; 1(even parity)

    // input_agt -> model
    uvm_blocking_get_port#(transaction) agt_i2mdl_get_port;

    // model -> scoreboard
    uvm_analysis_port#(transaction) conf_tr_port;
    uvm_analysis_port#(transaction) uart_tr_port;

    extern function      new         (string name = "model", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase);
    extern task          main_phase  (uvm_phase phase);
    
endclass

// new
function model::new(string name = "model", uvm_component parent = null);
    super.new(name, parent);
    check = 0 ;
    parity = 0 ;
endfunction

// build_phase
function void model::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // instance agt_i2mdl_get_port
    agt_i2mdl_get_port = new("agt_i2mdl_get_port", this);
    // instance conf_tr_port
    conf_tr_port = new("conf_tr_port", this);
    // instance uart_tr_port
    uart_tr_port = new("uart_tr_port", this);
endfunction

// main_phase
task model::main_phase(uvm_phase phase);
    transaction tr;
    super.main_phase(phase);
    while(1) begin
        /*
            transaction for register configuration -> record configuration
            transaction for uart send data -> calculate parity
        */
        
        // receive transaction from agt_i
        agt_i2mdl_get_port.get(tr);

        // `uvm_info("model", "\nget one transaction!", UVM_LOW);

        // tr.print_apb_info();

        // record check and parity
        if(tr.ttype == transaction::WRITE && tr.paddr == 32'h0c) begin
            this.check = tr.pdata[0];
            this.parity = tr.pdata[1];
        end

        // calculate parity
        if(tr.ttype == transaction::WRITE && tr.paddr == 32'h00) begin
            // udata
            tr.udata = tr.pdata;
            // uverify
            if(this.check == 0) 
                tr.uverify = 2'b00;
            else begin
                // count 1
                int count = 0;
                for (int i = 0; i <= 7; i++) begin
                    bit temp = ((tr.pdata >> i) & 1);
                    count += temp;
                end
                if(count % 2 == 0) 

                    tr.uverify = this.parity ? 2'b10 : 2'b11;
                else 
                    tr.uverify = this.parity ? 2'b11 : 2'b10;

            end
        
        end

        // send transaction to scb
        if(tr.paddr == 32'h00 && tr.ttype == transaction::WRITE)
            uart_tr_port.write(tr);
        else
            conf_tr_port.write(tr);

    end
endtask


`endif