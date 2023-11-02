module mux (in1,in2,sel,out);
	input [31:0]in1,in2;
	input sel;
	output [31:0] out;
	assign out =(sel)?in2:in1;

endmodule