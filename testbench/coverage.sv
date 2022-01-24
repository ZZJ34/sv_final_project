`ifndef COVERAGE_SV
`define COVERAGE_SV

class coverage;

    transaction apb_tr;

    covergroup apb_tr_coverage;
        // 总线状态 
        cover_point_ttype: coverpoint apb_tr.ttype { bins ttype[] = {transaction::READ, transaction::WRITE, transaction::IDLE}; }
        // 波特率
        cover_point_baud : coverpoint apb_tr.pdata {
            bins b9600   = {32'd168} iff (apb_tr.paddr == 32'h08);
            bins b19200  = {32'd84 } iff (apb_tr.paddr == 32'h08);
            bins b38400  = {32'd41 } iff (apb_tr.paddr == 32'h08);
            bins b115200 = {32'd13 } iff (apb_tr.paddr == 32'h08);
            bins others[4]= {[14:40], [42:83], [85:167], [169:676]} iff (apb_tr.paddr == 32'h08);
        }
        // 功能配置
        cover_point_conf_check : coverpoint apb_tr.pdata[0] { bins check [] = {0, 1} iff (apb_tr.paddr == 32'h0c); }
        cover_point_conf_parity: coverpoint apb_tr.pdata[1] { bins parity [] = {0, 1} iff (apb_tr.paddr == 32'h0c) && apb_tr.pdata[0]; }
        cover_point_conf_stop  : coverpoint apb_tr.pdata[2] { bins stop [] = {0, 1} iff (apb_tr.paddr == 32'h0c); }
        // tx 触发深度
        cover_point_txtrig     : coverpoint apb_tr.pdata { bins txtrig [5] = {[0:4], 5, 6, 7, 8} iff (apb_tr.paddr == 32'h14); }
        // 帧间隔
        cover_point_delay      : coverpoint apb_tr.pdata { bins delay [4] = {0, 1, 2, [3:8]} iff (apb_tr.paddr == 32'h18); }
        // 中断
        cover_point_status     : coverpoint apb_tr.paddr { bins interrupt = {32'h1c}; }


    endgroup

    extern function new    ();
    extern task     sample (transaction tr);

endclass

// new
function coverage::new();
    apb_tr_coverage = new();
endfunction

// sample
task coverage::sample(transaction tr);
    this.apb_tr = tr;
    apb_tr_coverage.sample();
endtask

`endif