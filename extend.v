module extend(ins,out_extend);
input signed [31:0]ins;
output  reg signed [31:0] out_extend;
reg  [31:0] out;

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
assign opcode =ins[6:0];
assign funct3 =ins[14:12];
assign funct7 =ins[31:25];

wire signed[11:0] imm_i;
assign imm_i=ins[31:20];

always @(*) begin 
	out = 'bz;
	if (opcode=='h13)begin
		case (funct3)
					'b000   ,
					'b010 	: out_extend=imm_i; // addi , slti

					'b001   : if(funct7==0) 	// slli
								begin
								out=ins[24:19];
								out_extend=out;	
								end

					'b101   :begin if(funct7==0)			//srli 			/////i*
							  begin
							 	out=ins[24:19];
								out_extend=out;		
							  end
							  else 
							  if(funct7=='h20)				//srai	////i* signed
							  out_extend=ins[24:19]; end	
					'b011	,  						
					'b100	,		   	 					/// sltiu ,xori, ori,andi
					'b110   ,
					'b111   :begin
							 	out=ins[31:20];
							 	out_extend=out;
							 end
					default : out_extend='bz;
			endcase
	end
	else if (opcode == 'h03)begin ////// i MEM
		case (funct3)
					'b000,
					'b001, 
					'b010,
					'b100,
					'b101	: out_extend=ins[31:20];								  
					default : out_extend='bz;
			endcase	
	end
	else if (opcode == 'h23)begin ////// S  MEM
		case (funct3)
					'b000	,
					'b001	, 
					'b010	: out_extend={{20{1'b0}},ins[31:25],ins[11:7]};								  
					default : out_extend='bz;
			endcase	
	end

	else if(opcode==7'h63)// Btype MEM
			begin
				case (funct3)
					'b000	, 	 
					'b001	, 	
					'b100	,  
					'b101	, 	
					'b110	, 	
					'b111	: out_extend = {{20{ins[31]}},ins[31],ins[7],ins[30:25],ins[11:8],1'b0};		
					default : out_extend = 'bz;	
				endcase
			
			end		


	else if(opcode==7'h67)// I type  JALR
			begin
				if(funct3==0)begin		
				out=ins[24:19];
				out_extend=out;
				end
			end

	else if(opcode==7'h6f)// J type  JAL
			begin
				out_extend={{11{ins[31]}},ins[31],ins[19:12],ins[20],ins[30:21],1'b0};
			end		
	else if(opcode==7'h37)// U type		LUI
			begin
				out_extend={ins[31:12],12'b0};
			end
	else if(opcode==7'h17)// U type		AUIPC
			begin
				out_extend={ins[31:12],12'b0};
			end
end

endmodule 