`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2019 12:17:57 PM
// Design Name: 
// Module Name: Checksum
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


module Checksum(hardreset,inputdata,clock,checksum,valid);
input hardreset;
/*all inputs are declared here */
input [31:0] inputdata; //first 16 bits are source address next 16 are desitnation address and following 64 bits are data//
/* input data must be constant for the first three T states then must change*/


/*based on the type of the icmp message the user will assign the typeoficmp as input*/

/*based on the code of the icmp message the user will assign the code as input*/
input clock; // clock signal, everything will function wrt the clock


/*all outputs are declared here */
output [15:0] checksum; //the 16 bit checksum is taken as an output
output reg valid;
reg [15:0] checksum;
/* generally the icmp message is 160 bits long. so there will be 5 sequences in the output message */



/*all registers are declared here */
parameter size=3;
parameter s0=3'b000;
parameter s1=3'b001;
parameter s2=3'b010;
parameter s3=3'b011;
parameter s4=3'b100;
parameter s5=3'b101;
parameter s6=3'b110;
parameter s7=3'b111;
reg [size-1:0]state;
reg [size-1:0]next_state;
reg [31:0] m0;
reg [31:0] m1;
reg [31:0] m2;
reg [31:0] m3;
reg [31:0] m4;
reg [31:0] m5;



always @ (posedge clock or posedge hardreset)
begin
if(hardreset)
begin
state=0;
end
else
begin
state=next_state;
end
end


always @ (posedge clock or posedge hardreset)
begin
if (hardreset)
begin
next_state=s0;
end
else
begin
case(state)
s0 : next_state=s1;
s1 : next_state=s2;
s2 : next_state=s3;
s3 : next_state=s4;
s4 : next_state=s5;
s5 : next_state=s6;
s6 : next_state=s7;
s7 : next_state=s0;
default : next_state=s0;
endcase
end
end


always @ (posedge clock or posedge hardreset)
begin
if (hardreset)
begin
m0<=0;
m1<=0;
m2<=0;
m3<=0;
m4<=0;
m5<=0;
end
else
begin
case(state)
s0 : m0<=inputdata;
s1 : m1<=inputdata;
s2 : m2<=inputdata;
s3 : m3<=inputdata;
s4 : m4<=inputdata;
s5 : m5<=inputdata;
s6 : begin
     end
s7 : begin
     end
default : begin
          end
endcase
end
end




always @ (posedge clock or posedge hardreset)
begin
if (hardreset)
begin
checksum=16'b0;
end
else
begin
case(state)
s0 : checksum=16'b0;
s1 : checksum=checksum+(~(m0[31:16]))+(~(m0[15:0]));
s2 : checksum=checksum+(~(m1[31:16]))+(~(m1[15:0]));
s3 : checksum=checksum+(~(m2[31:16]))+(~(m2[15:0]));
s4 : checksum=checksum+(~(m3[31:16]))+(~(m3[15:0]));
s5 : checksum=checksum+(~(m4[31:16]))+(~(m4[15:0]));
s6 : checksum=checksum+(~(m5[31:16]))+(~(m5[15:0]));
s7 : checksum=~checksum;
default : checksum=0;
endcase
end
end

always @ (posedge clock or posedge hardreset)
begin
if (hardreset)
begin
valid<=0;
end
else
begin
case(state)
s0 : valid<=0;
s1 : valid<=0;
s2 : valid<=0;
s3 : valid<=0;
s4 : valid<=0;
s5 : valid<=0;
s6 : valid<=0;
s7 : valid<=1;
default : valid<=0;
endcase
end
end


endmodule
