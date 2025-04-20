`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2025 02:58:31 PM
// Design Name: 
// Module Name: apb_led_ctrl
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


module apb_led_ctl(

	input rst,

	//apb bus signals
	input clk,
	input [31:0] paddr,
	input psel,
	input penable,
	input pwrite,
	output pready,
	output pslverr,
	input  [31:0] pwdata,
	output [31:0] prdata,

	//led output signals
	output [7:0] led,
	output [2:0] rgbA,
	output [2:0] rgbB
);

	wire write_en;
	wire [1:0] addr;

	//IMPORTANT, make sure you don't use bits [1:0]
	assign addr = paddr[3:2];
	assign write_en = (psel & penable & pwrite);

	assign pready=1'b1;
	assign pslverr=1'b0;




	led_ctl led_inst(
		.clk(clk),
		.rst(rst),
		.addr(addr),
		.write_data(pwdata[7:0]),
		.read_data(prdata[7:0]),
		.write_en(write_en),

		.led(led),
		.rgbA(rgbA),
		.rgbB(rgbB)
	);

	//make sure remaining data bits are driven
	assign prdata[31:8]=0;



endmodule
