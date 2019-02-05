module icmp_read_tb();
reg[31:0] inputmessage;
reg clock;
reg reset;
wire [7:0] icmptype;
wire [7:0] icmp_code;
wire [15:0] checksum;
wire [31:0] unused;
wire [31:0] outputmessage1;
wire [31:0] outputmessage2;
wire [31:0] outputmessage3;
ICMP_read u0(inputmessage, reset, clock, 
icmp_type,icmp_code, checksum, 
unused, outputmessage1, outputmessage2, outputmessage3);

initial
begin
clock=0;
reset=1;
#10 reset=0;
inputmessage=32'h0032;
#10 inputmessage=32'h0;
#10 inputmessage=32'habab32;
#10 inputmessage=32'habab32;
#10 inputmessage=32'hcaa200;
end
always
begin
#5 clock=~clock;
end
always
begin
#150 $finish;
end
endmodule