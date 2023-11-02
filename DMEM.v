module DMEM (clk,we,add,data_in,data_out);
/////////////////////////////////////////PARAMETERS/////////////////////////////
parameter LW =3'h0 ,
		  LH =3'h1 ,
		  LHU=3'h2 ,
		  LB =3'h3 ,
		  LBU=3'h4 ,
		  SB =3'h5 ,
		  SH =3'h6 ,
		  SW =3'h7 ;
//////////////////////////////////////////////////////////////////////////////		  
	input clk;
	input [2:0]we;
	input[31:0] add, data_in;
	output [31:0] data_out;

	reg [7:0] D_mem [1023:0];
	wire [31:0] word;

	always @(posedge clk) begin
		if(we==SB)
			D_mem[add]<=data_in[7:0];
		else if(we==SH)begin
			D_mem[add]<=data_in[7:0];
			D_mem[add+1]<=data_in[15:8];
		end
		else if(we==SW)begin
			D_mem[add]<=data_in[7:0];
			D_mem[add+1]<=data_in[15:8];
			D_mem[add+2]<=data_in[24:16];
			D_mem[add+3]<=data_in[31:25];
		end
	end
	assign word ={D_mem[add+3],D_mem[add+2],D_mem[add+1],D_mem[add]};

	assign data_out=(we==LW)?word:
	(we==LH)?{{16{word[15]}},word[15:0]}:
	(we==LHU)?{{16{1'b0}},word[15:0]}:
	(we==LB)?{{24{word[7]}},word[7:0]}:
	(we==LBU)?{{24{1'b0}},word[7:0]}:32'bz;

endmodule 