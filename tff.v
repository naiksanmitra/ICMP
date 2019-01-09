`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2018 11:16:34 AM
// Design Name: 
// Module Name: tff
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


module tff(t,clk,preset,clear,q,qbar);
    input t;
    input clk;
    input preset;
    input clear;
    output q;
    output qbar;
    wire t,clk,preset,clear;
    reg q, qbar;
    always @ (posedge clk or posedge preset or posedge clear)
    begin
    if (preset==1)
    begin
    q<=1;
    qbar<=0;
    end
    if (clear==1)
    begin
    q<=0;
    qbar<=1;
    end
    if(t==1)
    begin
    if ({preset,clear}==2'b00)
    begin
    q=~q;
    qbar=~qbar;
    end
    end
    if(t==0)
    begin
    if ({preset,clear}==2'b00)
    begin
    q=q;
    qbar=qbar;
    end
    end
    end
endmodule
