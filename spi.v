`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2024 11:20:07
// Design Name: 
// Module Name: spi
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
//top
module top(input clk,rst,tx_enable,
output [7:0] out,
output done);
wire mosi,cs,sclk;

spi instance1(.clk(clk),.rst(rst),.tx_enable(tx_enable), .mosi(mosi), .cs(cs), .sclk(sclk));
spi_slave instance2(.sclk(sclk),.mosi(mosi), .cs(cs), .out(out), .done(done));

endmodule

//master///////////////////////////////////////////
module spi(input wire clk,
input wire rst,
input wire tx_enable,
output reg mosi,
output reg cs,
output wire sclk);


parameter idle = 2'b00;
parameter start_en = 2'b01;
parameter tx_data = 2'b10;
parameter end_tx = 2'b11;

reg state;
reg next_state;

reg [7:0] din = 8'b00011000;
reg spi_clk = 0;
reg [2:0] count = 0;
reg [2:0] ccount = 0;
integer bit_count = 0;

//serialclk generating////////////////////////////////////////////
always@(posedge clk)
begin
case(next_state)
idle:
begin
spi_clk <= 0;
end


start_en:
begin
if(count < 3'b011 || count == 3'b111)
spi_clk <= 1'b1;
else
spi_clk <= 1'b0;
end

tx_data:
begin
if(count < 3'b011 || count == 3'b111)
spi_clk <= 1'b1;
else
spi_clk <= 1'b0;
end

end_tx:
begin
if(count < 3'b011)
spi_clk <= 1'b1;
else
spi_clk <= 1'b0;
end

default spi_clk <= 1'b0;
endcase
end

//reset//////////////////////////////////////////////////////////////
always @(posedge clk)
begin
if (rst)
state <= idle;
else
state <= next_state;
end

//next_state decoder/////////////////////////////////////////////////////

always@(*)
begin
case (state)

idle: 
begin
    mosi = 1'b0;
    cs = 1'b1;
    if(tx_enable)
    next_state = start_en;
    else
    next_state = idle;
    end
start_en: 
begin
     cs =1'b0;
     mosi = 1'b1;
     if(count == 3'b111)
     next_state = tx_data;
     else
     next_state = start_en;
     end
tx_data: 
begin
     mosi = din[7 - bit_count];
     if(bit_count != 8)
     next_state = tx_data;
     else
     begin
     next_state = end_tx;
     mosi=1'b0;
     end    
 end
end_tx: 
begin
     mosi = 1'b0;
     cs = 1'b1;
     if(count == 3'b111)
      next_state = idle;
     else
      next_state = end_tx;
 end
 default: next_state = idle;
 endcase
 end
 //count update//////////////////////////////////////////////
always@(posedge clk)
begin
case(state)

idle:
begin
count <= 0;
bit_count <= 0;
end

start_en: 
count <= count+1;

tx_data:
 begin
 if(bit_count != 8)
  begin
  if(count < 3'b111)
  count <= count+1;
  else
  begin
  count <= 0;
  bit_count <= bit_count+1;
  end
  end
end

end_tx:
begin
count <= count+1;
bit_count <= 0;
end

default:
begin
count <= 0;
bit_count <= 0;
end
endcase
end

assign sclk = spi_clk;

endmodule

