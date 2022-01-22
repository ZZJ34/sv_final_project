`ifndef BASE_SEQUENCE_SV
`define BASE_SEQUENCE_SV

class base_sequence extends uvm_sequence #(transaction);

    transaction tr; 

    `uvm_object_utils(base_sequence)
   
    extern function new  (string name = "base_sequence");
    extern task     body ();

endclass

function base_sequence::new (string name = "base_sequence");
    super.new(name);
endfunction

task base_sequence::body ();

    tr = new("tr");

    tr.pdata = 32'hac;
    tr.paddr = 32'h00;
    tr.ttype = transaction::WRITE;
    `uvm_send(tr)

    #2038866;

    tr.pdata = 32'd13;
    tr.paddr = 32'h08;
    tr.ttype = transaction::WRITE;
    `uvm_send(tr)

    tr.pdata = 32'h02;
    tr.paddr = 32'h00;
    tr.ttype = transaction::WRITE;
    `uvm_send(tr)

    tr.paddr = 32'h18;
    tr.ttype = transaction::READ;
    `uvm_send(tr)

    #8000000;
    
endtask

`endif