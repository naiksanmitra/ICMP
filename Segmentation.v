`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: National Institute of Technology Goa
// Engineer: 
// 
// Create Date: 01/05/2019 10:19:27 AM
// Design Name: ICMPWrite
// Module Name: ICMPv_5
// Project Name: ICMP: Internet Control Message Protocol
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:7
// Revision 7
// Additional Comments: Comments will be distributed here and in the readme file.
// 
//////////////////////////////////////////////////////////////////////////////////


module ICMPv_7(hardreset,inputdata,clock,outputmessage); //declaration of the module
input hardreset;
/*all inputs are declared here */
input [31:0] inputdata; //first 16 bits are source address next 16 are desitnation address and following 64 bits are data//
/* input data must be constant for the first three T states then must change*/
/*based on the type of the icmp message the user will assign the typeoficmp as input*/
/*based on the code of the icmp message the user will assign the code as input*/
input clock; // clock signal, everything will function wrt the clock


/*all outputs are declared here */

output [31:0] outputmessage; //the output message will be generated 32 bits at a time. 
/* generally the icmp message is 160 bits long. so there will be 5 sequences in the output message */



/*all registers are declared here */
reg [31:0] outputmessage;  
reg [15:0] checksum;

//magic when high will mean that the outputmessage is valid.
//when actreset goes hgh it mean that the output message is completely transmitted and now the icmp message will reset
/*parameters defined here*/
parameter SIZE=3;
parameter s0=3'b000;
parameter s1=3'b001;
parameter s2=3'b010;
parameter s3=3'b011;
parameter s4=3'b100;
parameter s5=3'b101;
parameter s6=3'b110;
parameter s7=3'b111;
// these 8 parameters basically define the states of the finite state machine

//definining memory elements//

//9 memory elements are defined inorder to keep the data ready for processing or transmission
reg [31:0] m0;
reg [31:0] m1;
reg [31:0] m2;
reg [31:0] m3;
reg [31:0] m4;

reg [31:0] mo1;
reg [31:0] mo2;
reg [31:0] mo3;
reg [31:0] mo4;

//internal register state is defined here
reg [SIZE-1:0] state; //the current state of the finite state machine
reg [SIZE-1:0] next_state;// the next state of the finite state machine
//combinational logic part here

always @ (posedge clock)
begin
if (hardreset==1)
begin
m0<=32'b0;
m1<=32'b0;
m2<=32'b0;
m3<=32'b0;
m4<=32'b0;
state<=s0;
mo1<=32'b0;
mo2<=32'b0;
mo3<=32'b0;
mo4<=32'b0;
checksum<=16'b0;
outputmessage<=32'b0;
end
else
begin
state=next_state; //at every positive edge of the clock the state changes
end
end

always @ (posedge clock)
/* the functioning of this always block is sensitive to two parameters clock and actreset.
*/
begin
if (hardreset==1)
begin
next_state=s0;
end
else
begin
case(state)
s0 : begin
     next_state<=s1;
     end
s1 : begin
     next_state<=s2;
     end
s2 : begin
     next_state<=s3;
     end
s3 : begin
     next_state<=s4;
     end
s4 : begin
     next_state<=s5;
     end 
s5 : begin
     next_state<=s0;
     end
s6 : begin
     next_state<=s7;
     end
s7 : begin
     next_state<=s0;
     end
default : begin
     next_state<=s0;
     end
endcase
end
end




/*
In this always loop the data from typeoficmp and code and checksum is assigned to memory elements m0 and unused data to memory m1.
Also in this always loop the data from input memory is transferred to the output memory.
*/



/*
In this always loop the data from inputdata which contains information of IP address and user datagram is assigned to memory elements m2 through m4.
Also in this loop the magic and actreset signals are addressed.
*/

always @ (posedge clock)
begin
if (hardreset==1)
begin
end
else
begin
case(state)
s0 : m0<=inputdata;//first 32 bits of inputdata
s1 : m1<=inputdata;//next 32 bits of inputdata
s2 : m2<=inputdata;//final 32 bits of inputdata
s3 : m3<=inputdata;
s4 : m4<=inputdata;//first 32 bits of inputdata
default : begin
	  end
endcase
end
end


always @ (posedge clock)
begin
if (hardreset==1)
begin
end
else
begin
case(state)
s0 : begin
     end//first 32 bits of inputdata
s1 : outputmessage=m0;//next 32 bits of inputdata
s2 : outputmessage=m1;//final 32 bits of inputdata
s3 : outputmessage=m2;
s4 : outputmessage=m3;//first 32 bits of inputdata
s5 : outputmessage=m4;
default : begin
	  end
endcase
end
end




//generating the checksum//
//this part of the code is used to generate the checksum//






//this part of the code is used to transmit the outputmessage//

endmodule //termination of the module
