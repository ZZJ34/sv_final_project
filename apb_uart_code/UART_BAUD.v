// module declaration
`timescale 1ns/1ps

module    UART_BAUD(
   // inputs
    clk26m,
    rst26m_,
    tx_bps_en,
    rx_bps_en,
    baud_div,
    // outputs
    rx_bpsclk,
    tx_bpsclk
);

input            clk26m;             // 26M function clock
input            rst26m_;            // function clk's rst_
input            rx_bps_en;          // baud enable signal
input            tx_bps_en;
input  [9:0]     baud_div;          // baud frequency divide factor
output           rx_bpsclk;          // receive bps clk
output           tx_bpsclk;          // send bps clk

reg  [13:0]     cnt_value;           // bps count value
reg  [13:0]     cnt_baud_rx;         // receive baud counter
reg  [13:0]     cnt_baud_tx;         // send baud counter


// produce receive bpsclk
always@(posedge clk26m or negedge rst26m_) begin
    if(!rst26m_) begin
        cnt_baud_rx <= 14'd0;
    end
    else begin
        if(rx_bps_en) begin
            if(cnt_baud_rx > cnt_value - 1'b1) begin
                cnt_baud_rx <= 14'd0;
            end
            else begin
                cnt_baud_rx <= cnt_baud_rx + 1'b1;
            end
        end
        else begin
            cnt_baud_rx <= 14'd0;
        end
    end
end
assign  rx_bpsclk = (cnt_baud_rx == (cnt_value/2))? 1'b1:1'b0;

// produce send bpsclk
always@(posedge clk26m or negedge rst26m_) begin
    if(!rst26m_) begin
        cnt_baud_tx <= 14'd0;
    end
    else begin
        if(tx_bps_en) begin
            if(cnt_baud_tx > cnt_value - 1'b1) begin
                cnt_baud_tx <= 14'd0;
            end
            else begin
                cnt_baud_tx <= cnt_baud_tx + 1'b1;
            end
        end
        else begin
            cnt_baud_tx <= 14'd0;
        end
    end
end
assign  tx_bpsclk = (cnt_baud_tx == (cnt_value/2))? 1'b1:1'b0;

always@(posedge clk26m or negedge rst26m_) begin
    if(!rst26m_) begin
        cnt_value <= (10'd338+ 1'b1) << 4;
    end
    else begin
        cnt_value <= (baud_div + 1'b1) << 4;
    end
end


endmodule