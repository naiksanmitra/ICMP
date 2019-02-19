`timescale 1ns / 1ps


module ICMP(readmode,sendmode,hardreset,inputdata,typeoficmpin,codein,restofheaderin,clock,outputmessage,outputvalid,restofheaderout,typeoficmpout,codeout); //declaration of the module
input hardreset;
output [31:0]restofheaderout;
reg [31:0] restofheaderout;
 output [7:0] typeoficmpout;
 reg [7:0] typeoficmpout;
/*all inputs are declared here */
input [31:0] inputdata; //first 16 bits are source address next 16 are desitnation address and following 64 bits are data//
/* input data must be constant for the first three T states then must change*/
input [31:0] restofheaderin;//data depending on the type of message
input [7:0] typeoficmpin; //represents the type of icmp
/*based on the type of the icmp message the user will assign the typeoficmp as input*/
input [7:0] codein; //represents the type of code of icmp
output [7:0] codeout;
reg [7:0] codeout;
/*based on the code of the icmp message the user will assign the code as input*/
input clock; // clock signal, everything will function wrt the clock
input readmode;
input sendmode;
output outputvalid;
/*all outputs are declared here */
 //the 16 bit checksum is taken as an output
output [31:0] outputmessage; //the output message will be generated 32 bits at a time. 
/* generally the icmp message is 160 bits long. so there will be 5 sequences in the output message */
reg [15:0] checksum;

/*all registers are declared here */
reg [31:0] outputmessage;  
reg outputvalid; //outputvalid and actreset are two registers which will function to reset the icmp output and states
 //this will act as a reset switch
//outputvalid when high will mean that the outputmessage is valid.
//when actreset goes hgh it mean that the output message is completely transmitted and now the icmp message will reset
/*parameters defined here*/
parameter SIZE=5;
parameter icmptypecode=5'b00000;
parameter roh=5'b00001;
parameter inpd1=5'b00010;
parameter inpd2=5'b00011;
parameter inpd3=5'b00100;
parameter csgen1=5'b00101;
parameter csgen2=5'b00110;
parameter opmsg1=5'b00111;
parameter opmsg2=5'b01000;
parameter opmsg3=5'b01001;
parameter opmsg4=5'b01010;
parameter opmsg5=5'b01011;
parameter icmptcrd=5'b01100;
parameter rohrd=5'b01101;
parameter d1rd=5'b01110;
parameter d2rd=5'b01111;
parameter d3rd=5'b10000;
parameter ord=5'b10001;
parameter IDLE=5'b11111;
// these 8 parameters basically define the states of the finite state machine

//definining memory elements//

//9 memory elements are defined inorder to keep the data ready for processing or transmission
reg [15:0] m0;
reg [31:0] m1;
reg [31:0] m2;
reg [31:0] m3;
reg [31:0] m4;

reg sendtrap;
reg readtrap;

//internal register state is defined here
reg [SIZE-1:0] state; //the current state of the finite state machine
//reg [SIZE-1:0] next_state;// the next state of the finite state machine
//combinational logic part here

//assign typeoficmp=(readtrap) ? m0[15:8]:typeoficmp; 
//assign code=(readtrap) ? m0[7:0]:code; 
//assign restofheader=(readtrap) ? m1:restofheader; 
//assign readtrap=(readmode) ? 1:0;
//assign sendtrap=(sendmode&&~readmode) ? 1:0; 


always @ (posedge clock)
begin
	if (hardreset==1)
		begin
			state <= IDLE;
		end
	else
		begin
//			state<=next_state; //at every positive edge of the clock the state changes
		end
	end

always @ (posedge clock)
/* the functioning of this always block is sensitive to two parameters clock and actreset.
*/
begin
	if (hardreset==1)
		begin
//		state<=IDLE;
		end
	else
		begin
//		state<=next_state;
			
//			case(state)
//            IDLE : next_state<=icmptypecode;
//            icmptypecode : next_state<=roh;
//            roh : next_state<=inpd1;
//            inpd1 : next_state<=inpd2;
//            inpd2 : next_state<=inpd3;
//            inpd3 : next_state<=IDLE;
//            default : next_state<=IDLE;
//            endcase
			
		
			
			case(state)
			IDLE :   begin
			         if(sendmode&&~readmode)
			         begin
			         sendtrap<=1;
			         state<=icmptypecode;
			         end
			         if(readmode)
			         begin
			         readtrap<=1;
			         state<=icmptcrd;
			         end
			         end
			icmptypecode : state<=roh;
			roh : state<=inpd1;
			inpd1 : state<=inpd2;
			inpd2 : state<=inpd3;
			inpd3 : state<=csgen1;
			csgen1 : state<=csgen2;
			csgen2 : state<=opmsg1;
			opmsg1 : state<=opmsg2;
			opmsg2 : state<=opmsg3;
			opmsg3 : state<=opmsg4;
			opmsg4 : state<=opmsg5;
			opmsg5 : state<=IDLE;
			icmptcrd: state<=rohrd;
			rohrd: state<=d1rd;
			d1rd: state<=d2rd;
			d2rd: state<=d3rd;
			d3rd: state<=ord;
			default : state<=IDLE;
			endcase
			
		end
	end

always @(posedge clock)
begin
	if(hardreset)
	begin
	sendtrap<=0;
	readtrap<=0;
	m0<=0;
	m1<=0;
	m2<=0;
	m3<=0;
	m4<=0;
	checksum<=0;
	outputmessage<=0;
	outputvalid<=0;
	restofheaderout<=0;
	typeoficmpout<=0;
	codeout<=0;
	end
	else
	begin
	case(state)
	IDLE : begin
	       outputmessage<=0;
	       outputvalid<=0;
	       end
icmptypecode : begin
				m0<={typeoficmpin,codein};
				m1<=restofheaderin;
				m2<=inputdata;
				checksum<=16'b0;
				end
roh :			begin
                m3<=inputdata;
				checksum<=~m0;
				end
inpd1 :         begin
                m4<=inputdata;
                checksum<=checksum+(~(m1[31:16])+(~(m1[15:0])));
                end
inpd2 :         begin
                checksum<=checksum+(~(m2[31:16])+(~(m2[15:0])));
                end
inpd3 :         begin
                checksum<=checksum+(~(m3[31:16])+(~(m3[15:0])));
                end
csgen1 :        begin
                checksum<=checksum+(~(m4[31:16])+(~(m4[15:0])));
                end
csgen2 :        begin
                checksum<=~checksum;
                end
opmsg1 :        begin
                outputmessage<={m0,checksum};
                outputvalid<=1;
                end
opmsg2 :        begin
                outputmessage<=m1;
                end
opmsg3 :        begin
                outputmessage<=m2;
                end
opmsg4 :        begin
                outputmessage<=m3;
                end
opmsg5 :        begin
                outputmessage<=m4;
               sendtrap<=0;
                end
icmptcrd :      	        begin
                            m0<=inputdata[31:16];
                            checksum<=inputdata[15:0];
                            end
rohrd :                     begin
                            m1<=inputdata;
                            typeoficmpout<=m0[15:8];
                            codeout<=m0[7:0];
                            
                            end
d1rd :                  begin
                        m2<=inputdata;
                        restofheaderout<=m1;
                        end
d2rd :                  begin
                        m3<=inputdata;
                        outputmessage<=m2;
                        end
d3rd :                  begin
                        m4<=inputdata;
                        outputmessage<=m3;
                        end
ord :                   begin
                        readtrap<=0;
                        outputmessage<=m4;
                        end
default : begin
end
endcase
end
end







endmodule //termination of the module
