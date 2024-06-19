`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2024 22:07:04
// Design Name: 
// Module Name: spi_slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//slave
module spi_slave(input sclk,mosi,cs,
output [7:0] out,
output reg done);

integer count = 0;
parameter idle = 1'b0;
parameter transaction = 1'b1;

reg state;
reg [7:0] data = 0;

always@(negedge sclk)
begin
case(state)
idle:
begin
done <= 1'b0;

if (cs == 1'b0)
state <= transaction;
else
state <= idle;
end
transaction:
begin
if(count < 8)
begin
count <= count+1;
data <= { data[6:0],mosi };
state <= transaction;
end
else 
begin
count <= 1'b0;
state <= idle;
done <= 1'b1;
end
end

default :
state <= idle;
endcase
end

assign out = data;
endmodule
