module CPU (clk,rst,pc_m,pc,X,ins);
	input clk , rst;
	output[31:0] pc_m,X,ins;
	output reg [31:0]pc;
	
	wire [3:0]alu_sel;
	wire [2:0] pl_c;
	wire [1:0] wbsel;
	wire bsel,asel,we_r,brun,pcsel,brlt,breq;
	control_unit cont(ins,alu_sel,bsel,wbsel,pl_c,we_r,asel,brun,breq,brlt,pcsel);

	data_bus bus(clk,we_r,bsel,alu_sel,ins,wbsel,pl_c,asel,pcsel,brun,breq,brlt,pc,pc_m,X);

	ins_mem insmem(clk,rst,pc,ins);



	always @(posedge clk) begin 
		if(rst) begin
			pc<= 0;
			$readmemh("reg_ini.mem",bus.regfile.r_f);
			$readmemh("Dmem_ini.mem",bus.d_mem.D_mem);
		end else begin
			pc <= pc_m;
		end
	end
endmodule 