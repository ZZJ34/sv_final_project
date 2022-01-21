`ifndef MODEL_SV
`define MODEL_SV

class model extends uvm_component;

   
    `uvm_component_utils(model);

    bit check ; // check bit. default 0(none)
    bit parity; // parity. defalut 0(even parity) ; 1(odd parity)

    // input_agt -> model
    uvm_blocking_get_port#(transaction) agt_i2mdl_get_port;

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
        if(tr.pwrite == 1 && tr.paddr == 32'h0c) begin
            this.check = tr.pdata[0];
            this.parity = tr.pdata[1];
        end

        // calculate parity
        if(tr.pwrite == 1 && tr.paddr == 32'h00) begin
            tr.udata = tr.pdata;

            if(this.check == 0) 
                tr.uverify = 2'b00;
            else begin
                // count 1
                int count;
                for (int i = 0; i < 7; i++) begin
                    bit temp = ((tr.pdata >> i) & 1);
                    count += temp;
                end
                if(count % 2 == 0) 
                    tr.uverify = this.parity == 0 ? 2'b10 : 2'b11;
                else 
                    tr.uverify = this.parity == 0 ? 2'b11 : 2'b10;

            end
        end

        // send transaction to scb

        // 数据发送给scb
        // 考虑到寄存器读写和uart数据发送的时间跨度相差甚远
        // 将这两种 transaction 分别发送到不同的fifo


    end
endtask


`endif