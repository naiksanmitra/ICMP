`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2018 09:38:53 AM
// Design Name: 
// Module Name: dff
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


module dff(d,clk,q,qbar
    );
    input d;
    input clk;
    output q;
    output qbar;
    wire d,clk;
    reg q,qbar;
    always @ (clk or d)
    begin
    if (clk==1)
    begin
    q <= d;
    qbar <= ~d;
    end
    else
    begin
    q<=q;
    qbar<=qbar;
    end
    end
endmodule
