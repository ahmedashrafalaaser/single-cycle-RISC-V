module data_bus (clk,we_r,bsel,alu_sel,ins,wbsel,pl_c,asel,pcsel,brun,breq,brlt,pc_in,pc_m,data_out_dmm);
	input clk,we_r,bsel,asel,brun,pcsel;
	input[1:0] wbsel;
	input [2:0] pl_c;
	input [3:0]alu_sel;
	input [31:0]ins,pc_in;
	output breq,brlt;
	output [31:0]pc_m,data_out_dmm;

	wire [31:0]alu_out,r_d1,r_d2,r2_m,imm,reg_alu_out,lp_out,r1_m,pc_out,reg_alu_out_m;
	pc_4 pc_plus(pc_in,pc_out);
	mux ux(pc_out,alu_out,pcsel,pc_m);
	reg_file regfile(clk,we_r,ins[11:7],ins[19:15],ins[24:20],reg_alu_out,r_d1,r_d2);
	alu alu_d(r1_m,r2_m,alu_sel,alu_out);
	mux B(r_d2,imm,bsel,r2_m);
	mux A(r_d1,pc_in,asel,r1_m);
	extend x(ins,imm);
	DMEM d_mem(clk,pl_c,alu_out,r_d2,data_out_dmm);
	//partial_load lp(data_out_dmm,pl_c,lp_out); // done inside  mem 
	mux dmem_or_alu(data_out_dmm,alu_out,wbsel[0],reg_alu_out_m);
	mux mux_J(reg_alu_out_m,pc_out,wbsel[1],reg_alu_out);
	branch_comp comp(r_d1,r_d2,brun,breq,brlt);


endmodule 
