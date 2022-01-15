// module declaration
`timescale 1ns/1ps

module    UART_FIFO(
    //inputs
    clk,
    rst_,
    fifo_rst,
    rinc,
    winc,
    data_i,
    //outputs
    data_o,
    wfull,
    rempty,
    fifo_cnt
);

input           clk;                 // ARM clock
input           rst_;                // ARM reset
input           fifo_rst;            // FIFO reset control signal.high active
input           rinc;                // FIFO read enable signal
input           winc;                // FIFO write enable signal
input  [7:0]    data_i;              // in data line

output          wfull;               // write full signal
output          rempty;              // read empty signal
output [7:0]    data_o;              // FIFO out data
output [4:0]    fifo_cnt;            // FIFO statu register

reg  [7:0]      data_o;
reg  [4:0]      fifo_cnt;
reg  [4:0]      wptr;                // write pointer
reg  [4:0]      rptr;                // read pointer
reg  [7:0]      ram[15:0];           // ram in FIFO

// write data in ram
always@(posedge clk or negedge rst_) begin
    if(!rst_) begin
        data_o <= 8'd0;
        rptr   <= 5'd0;
    end
    else begin
        if(fifo_rst) begin
            rptr <= 5'd0;
        end
        else begin
            if(rinc && !rempty) begin
                data_o <= ram[rptr[3:0]];
                rptr   <= rptr + 1'b1;
            end
        end
    end
end

// read data from ram
always@(posedge clk or negedge rst_) begin
    if(!rst_) begin
        wptr <= 5'd0;
    end
    else begin
        if(fifo_rst) begin
            wptr <= 5'd0;
        end
        else begin
            if(winc && !wfull) begin
                ram[wptr[3:0]] <= data_i;
                wptr            <= wptr + 1'b1; 
            end
        end
    end
end

// the number of data in the FIFO
always@(posedge clk or negedge rst_) begin
    if(!rst_) begin
        fifo_cnt <= 5'd0;
    end
    else begin
        fifo_cnt <= wptr - rptr;
    end
end

// produce full and empty signal
assign    wfull  = ({!wptr[4],wptr[3:0]}==rptr)? 1'b1 : 1'b0;
assign    rempty = (wptr==rptr)? 1'b1:1'b0;

endmodule