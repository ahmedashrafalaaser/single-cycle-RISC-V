module reg_file (clk,we,w_a,r_a1,r_a2,w_d,r_d1,r_d2);
	input clk,we;
	input [4:0] w_a,r_a1,r_a2;
	input [31:0] w_d;
	output [31:0] r_d1,r_d2;

	reg [31:0] r_f [31:0];
	initial 
	r_f[0]=0;
	always@(posedge clk)
	if (we)
		r_f[w_a]<=w_d;

	assign r_d1=(r_a1!=0)? r_f[r_a1] :0;
	assign r_d2=(r_a2!=0)? r_f[r_a2] :0;


endmodule 