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


module ICMPv_7(hardreset,inputdata,typeoficmp,code,typedata,clock,checksum,outputmessage); //declaration of the module
input hardreset;
/*all inputs are declared here */
input [31:0] inputdata; //first 16 bits are source address next 16 are desitnation address and following 64 bits are data//
/* input data must be constant for the first three T states then must change*/
input [31:0] typedata;//data depending on the type of message
input [7:0] typeoficmp; //represents the type of icmp
/*based on the type of the icmp message the user will assign the typeoficmp as input*/
input [7:0] code; //represents the type of code of icmp
/*based on the code of the icmp message the user will assign the code as input*/
input clock; // clock signal, everything will function wrt the clock


/*all outputs are declared here */
output [15:0] checksum; //the 16 bit checksum is taken as an output
output [31:0] outputmessage; //the output message will be generated 32 bits at a time. 
/* generally the icmp message is 160 bits long. so there will be 5 sequences in the output message */



/*all registers are declared here */
reg [31:0] outputmessage;  
reg [15:0] checksum;
reg magic=0; //magic and actreset are two registers which will function to reset the icmp output and states
reg actreset=0; //this will act as a reset switch
//magic when high will mean that the outputmessage is valid.
//when actreset goes hgh it mean that the output message is completely transmitted and now the icmp message will reset
/*parameters defined here*/
parameter SIZE=3;
parameter s0=3'b000;
parameter s1=3'b001;
parameter s2=3'b010;
parameter s3=3'b011;
parameter s4=3'b100;
parameter s5=3'b110;
parameter s6=3'b111;
parameter s7=3'b101;
// these 8 parameters basically define the states of the finite state machine

//definining memory elements//

//9 memory elements are defined inorder to keep the data ready for processing or transmission
reg [15:0] m0;
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

always @ (posedge clock or posedge actreset)
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
     if (actreset==1)
     begin
     next_state<=s1; //currently the state is s0 and the next state will be s1
     end
     else
     begin
     next_state<=s1;
     end
     end
s1 : begin
     if (actreset==1)
     begin
     next_state<=s2;
     end 
     else
     begin
     next_state<=s2;
     end
     end
s2 : begin
     if (actreset==1)
     begin
     next_state<=s3;
     end
     else
     begin
     next_state=s3;
     end
     end
s3 : begin
     if (actreset==1) 
     begin
     next_state<=s4;
     end
     else
     begin
     next_state<=s4;
     end
     end
s4 : begin
     if (actreset==1)//when the state is s4 and actreset is high
     begin
     next_state<=s7; // the next state is s7 which means that the ICMP message has transmitted completely and circuit has reset
     end
     else
     begin
     next_state<=s5; // the next state is s5 which means the ICMP message is still under process
     end
     end
s5 : begin
     if (actreset==1)
     begin
     next_state<=s6;
     end
     else
     begin
     next_state<=s6;
     end
     end
s6 : begin
     if (actreset==1)
     begin
     next_state<=s0; //s6 is the final state in generating checksum
     end
     else
     begin
     next_state<=0;
     end
     end
s7 : begin
     if (actreset==1)
     begin
     next_state<=s0; //s7 is the reset state
     end
     else
     begin
     next_state=s0;
     end
     end
default : begin
if (actreset==1)
begin
next_state<=s0; //by default state will be s0       
end
else
begin
next_state<=s0;
end
end
endcase
end
end




/*
In this always loop the data from typeoficmp and code and checksum is assigned to memory elements m0 and unused data to memory m1.
Also in this always loop the data from input memory is transferred to the output memory.
*/
always @ (posedge clock)
begin
if (hardreset==1)
begin
end
else
begin
case(state)
s0 : m0<={typeoficmp,code};
s1 : m1<=typedata;
s2 : begin
     mo1<=m1;
     end
s3 : begin
     mo2<=m2;
     end
s4 : begin
     mo3<=m3;
     end
s5 : begin
     mo4<=m4;
     end
s6 : begin
     end
default : begin
          m0<={typeoficmp,code};
	  end
endcase
end
end


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
s0 : m2<=inputdata;//first 32 bits of inputdata
s1 : m3<=inputdata;//next 32 bits of inputdata
s2 : m4<=inputdata;//final 32 bits of inputdata
s3 : begin
     end
s4 : begin
     if (magic==1) //this means output message is completely generated
     begin
     actreset<=1; //now we are ready to reset the system
     end
     end
s5 : begin
     if (actreset==1)
     begin
     actreset<=0; //we will reset the system
     magic<=0; // please note: this section of the code has to be reverified. may not be required.
     end
     end
s6 : begin
     magic<=1; //this means that the data is ready and now we can begin the transmission of outputmessage
     end
s7 : begin
     actreset<=0; //when s7 is accessed it means we have begun the reset process
     magic<=0;
     end
default : begin
	  end
endcase
end
end







//generating the checksum//
//this part of the code is used to generate the checksum//
always @ (posedge clock)
begin
if (hardreset==1)
begin
end
else
begin
case(state)
s0 : checksum<=16'b0;
s1 : checksum<=~(m0[15:0]);
s2 : checksum<=checksum+(~(m1[31:16]))+(~(m1[15:0])); 
s3 : checksum<=checksum+(~(m2[31:16] ))+(~(m2[15:0] ));
s4 : checksum<=checksum+(~(m3[31:16] ))+(~(m3[31:16] ));
s5 : checksum<=checksum+(~(m4[31:16] ))+(~(m4[31:16] ));
s6 : checksum<=~checksum;
s7 : begin
     end
default : begin
          end
endcase
end
end





//this part of the code is used to transmit the outputmessage//
always @ (posedge clock)
begin
if (hardreset==1)
begin
end

else
begin
if (magic==1) //when magic is 1 the output message will be transmitted else not
begin
case(state)
s0 : outputmessage<={m0[15:0],checksum}; //the first 32 bits are transmitted. these bits are the last to be generated
s1 : outputmessage<=mo1;//next 32 bits
s2 : outputmessage<=mo2;//next 32 bits
s3 : outputmessage<=mo3;//next 32 bits
s4 : begin
     outputmessage<=mo4;//final 32 bits
     end
s5 : begin
     if (actreset==1)
     begin
     outputmessage<=32'b0; //now we reset to 0
     end
     end
s6 : begin
     end
s7 : begin
     outputmessage<=32'b0; //now we reset to 0
     end 
default : begin
          end
endcase
end
end
end
endmodule //termination of the module
