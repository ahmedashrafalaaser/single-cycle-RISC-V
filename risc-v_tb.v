module risc_tb ();
reg clk,rst,done;
wire [31:0] pc_m,X,ins,pc;
reg [31:0]lastins;
CPU DUT(clk,rst,pc_m,pc,X,ins);

initial begin
	clk=0;
	forever
	#20 clk=~clk;
end

initial begin 
	$readmemh("ins.mem",DUT.insmem.ins_rom);
	rst=1;
	done=0;
	repeat(2) @(negedge clk);
	rst=0;
	@(done);
	@(negedge clk);
	@(negedge clk);

	$stop;
end

integer outfile0; 

initial begin

    outfile0=$fopen("ins.mem","r"); 
    while (! $feof(outfile0)) begin 
        $fscanf(outfile0,"%h",lastins);
    end
    $fclose(outfile0);
end
always @(*) 
	if(ins==lastins)
		done=1;


endmodule