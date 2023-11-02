module branch_comp (in1,in2,brun,breq,brlt);
input [31:0]in1,in2;
input brun;
output reg breq,brlt;
	
	always @(*) begin
	breq=1'bz;
	brlt=1'bz; 
		if (in1==in2)
			breq=1;
		else
			breq=0;
		if(brun)begin
			if(in1<in2)
				brlt=1;
			else
				brlt=0;
		end
		else begin
			if($signed(in1)<$signed(in2))
				brlt=1;
			else
				brlt=0;
		end
		
	end

endmodule