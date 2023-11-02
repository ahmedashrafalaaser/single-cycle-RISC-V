module pc_4 (pc_in,pc_out);
input [31:0]pc_in;
output reg [31:0]pc_out;


always @(*)
	pc_out =pc_in+4;
endmodule
