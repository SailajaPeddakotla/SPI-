`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2024 22:40:46
// Design Name: 
// Module Name: module_tb
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


module module_tb;
reg clk=0;
reg rst=0;
reg tx_enable=0;
/*wire mosi;
wire cs;
wire sclk;*/
wire [7:0] out;

//top dut(.clk(clk),.rst(rst),.tx_enable(tx_enable), .out(out));
spi instance1(.clk(clk),.rst(rst),.tx_enable(tx_enable), .mosi(mosi), .cs(cs), .sclk(sclk));
spi_slave instance2(.sclk(sclk),.mosi(mosi), .cs(cs), .out(out), .done(done));


always #5 clk=~clk;

initial begin
rst=1;
repeat(5)@(posedge clk);
rst=0;
end

initial begin
tx_enable=0;
repeat(5)@ (posedge clk);
tx_enable=1;

end


endmodule
