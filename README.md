# SV 课程 project 

搭建一个相对完整的 UVM 平台验证 DUT 功能的正确性

---

## DUT 简介

带有 APB 总线的 UART 模块作为 DUT，系统结构图如下所示：

<img src="./img/APB_UART.png" width = "60%" height = "60%" alt="APB_UART" align=center />


### APB 总线时序

总线协议规定了 2 个周期发送一组数据，状态机如下图所示：

<img src="./img/APB_state.png" width = "50%" height = "50%" alt="APB_state" align=center />

当一笔数据需要传送时：
- APB master 会在 SETUP 状态拉高 Psel 信号（选中对应的 slave 设备）
  
- 下一个周期进入 ENABLE 状态拉高 PENABLE 信号进行数据传输

- 之后如果有数据需要继续传送则进入 SETUP 状态并拉低 PENABLE，否则进入 IDLE

APB 读写时序如下图所示：

<img src="./img/APB_diagram.png" width = "60%" height = "60%" alt="APB_state" align=center />

### UART 模块

通用异步收发传输器（Universal Asynchronous Receiver/Transmitter），通常称作 UART

该接口可以实现双向通信，即全双工传输和接收

该模块特性如下：
- 系统最大工作频率满足 100MHz，功能时钟 26MHz（参考时钟）

- 寄存器配置接口满足 AMBA2.0-APB 总线时序接口，总线位宽 32bit

- 数据传输符合串口时序，奇偶校验功能可配置
  
- 波特率可任意配置，配置范围为 2400-115200bps
  
- 具有数据收发中断功能，可配置中断触发深度

- UART 数据发送帧间隔可配置

- 具有状态指示功能

寄存器说明说下：

|名称|偏移地址|属性|备注
|--|--|--|--
|UART 发送数据|0x00|可读可写|bit[7:0]
|UART 数据接收|0x04|只读|bit[7:0]
|UART 波特率|0x08|可读可写|bit[9:0]为波特率分频系数，范围13-676
|UART 功能模式|0x0C|可读可写|bit[0]决定是否有校验位，bit[1]决定奇偶校验模式（1-奇校验，0-偶校验），bit[2]决定是否有停止位（只对 TX 有效），bit[3]决定是否校验停止位（只对 RX 有效），bit[14]决定 TX FIFO 复位，bit[15]决定 RX FIFO 复位
|UART rx fifo 触发深度|0x10|可读可写|bit[3:0]设置触发深度，可选范围 1-8
|UART tx fifo 触发深度|0x14|可读可写|bit[3:0]设置触发深度，可选范围 0-8
|UART 发送帧间隔|0x18|可读可写|bit[3:0]设置帧间隔 0-8（只对 TX 生效）
|UART 状态寄存器|0x1C|可读可写|读取该寄存器时，bit[0]表示 TX FIFO 触发中断，bit[1]表示 RX FIFO 触发中断，bit[2]表示 RX 接收数据时奇偶校验错误，bit[3]表示 RX 接收时停止位校验错误。向该寄存器写 1 表示清除中断
|UART rx fifo 状态|0x20|只读|bit[5:0]表示当前 RX FIFO 数据量
|UART tx fifo 状态|0x24|只读|bit[5:0]表示当前 TX FIFO 数据量

---


## UVM 验证平台简介
---


## 运行方式
---