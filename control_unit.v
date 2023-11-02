
module control_unit (ins,alu_sel,bsel,wbsel,pl_c,we_r,asel,brun,breq,brlt,pcsel);
///////////////////////////////////PARAMETERS/////////////////////////////

parameter ADD = 4'h0 , AND = 4'h1 ,OR  = 4'h2 , XOR = 4'h3 ,  SUB = 4'h4 , SLT = 4'h5 , SLTU = 4'h6 ,
		   SLL = 4'h7 , SRL  = 4'h8 , SRA = 4'h9 ,LUI=4'ha;
parameter LW =3'h0 ,
		  LH =3'h1 ,
		  LHU=3'h2 ,
		  LB =3'h3 ,
		  LBU=3'h4 ,
		  SB =3'h5 ,
		  SH =3'h6 ,
		  SW =3'h7 ;
////////////////////////////////////////////////////////////////////////
input brlt,breq;
input [31:0] ins;
output reg [3:0] alu_sel;
output reg bsel,asel,we_r,brun,pcsel ;
output reg [1:0] wbsel;
output reg [2:0] pl_c;

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
assign opcode =ins[6:0];
assign funct3 =ins[14:12];
assign funct7 =ins[31:25];

//alu_sel
always @(*) begin
	bsel='bz;
	wbsel='bz;
	pl_c='bz;
	we_r='bz;
	asel='bz;
	brun='bz;
	pcsel='b0;
	if (opcode==7'h33)// Rtype Arth
		begin
			asel=0;
			pcsel=0;
			we_r=1;
			bsel=0;
			wbsel=2'h1;
			if (funct7==0)begin
				case (funct3)
					'b000   : alu_sel= ADD;
					'b001   : alu_sel= SLL;
					'b010   : alu_sel= SLT;
					'b011   : alu_sel=SLTU;
					'b100   : alu_sel= XOR;
					'b101   : alu_sel= SRL;
					'b110   : alu_sel= OR ;
					'b111   : alu_sel= AND;
					default : alu_sel= 'bz;
				endcase	
			end
			else if(funct7=='h20)begin
				if (funct3=='b101)
					alu_sel= SRA;
				else if(funct3=='b000)
					alu_sel= SUB;
			end

		end
	else if(opcode==7'h13)// Itype Arth
			begin
				asel=0;
				pcsel=0;
				we_r=1;
				bsel=1;
				wbsel=2'h1;
				case (funct3)
					'b000   : alu_sel= ADD;
					'b001   : if(funct7==0) 
							  alu_sel= SLL;			/////i*
					'b010   : alu_sel= SLT; 
					'b011   : alu_sel=SLTU;
					'b100   : alu_sel= XOR;
					'b101   :if(funct7==0)			 /////i*
							  alu_sel= SRL; 
							 else 
							 if(funct7=='h20)		/////i*
							  alu_sel= SRA; 	 
					'b110   : alu_sel= OR ;
					'b111   : alu_sel= AND;
					default : alu_sel= 'bz;
				endcase				

			end
	else if(opcode==7'h03)// Itype MEM
			begin
				asel=0;
				pcsel=0;
				we_r=1;
				wbsel=2'h0;
				bsel=1;
				case (funct3)
					'b000	: begin alu_sel= ADD; pl_c =LB ; end
					'b001	: begin alu_sel= ADD; pl_c =LH ; end
					'b010	: begin alu_sel= ADD; pl_c =LW ; end
					'b100 	: begin alu_sel= ADD; pl_c =LBU; end
					'b101 	: begin alu_sel= ADD; pl_c =LHU; end 
					default : alu_sel= 'bz;
				endcase
			
			end	
	else if(opcode==7'h23)// Stype MEM
			begin
				asel=0;
				pcsel=0;
				we_r=0;
				bsel=1;
				case (funct3)
					'b000	: begin alu_sel= ADD; pl_c =SB ; end 
					'b001	: begin alu_sel= ADD; pl_c =SH ; end
					'b010	: begin alu_sel= ADD; pl_c =SW ; end
					default : alu_sel= 'bz;
				endcase
			
			end	

	else if(opcode==7'h63)// Btype MEM
			begin
				case (funct3)
					'b000	: begin			if( breq )begin alu_sel= ADD;asel=1; bsel=1;pcsel=1; end	end 
					'b001	: begin			if(!breq )begin alu_sel= ADD;asel=1; bsel=1;pcsel=1; end	end
					'b100	: begin brun=0;	if( brlt )begin alu_sel= ADD;asel=1; bsel=1;pcsel=1; end	end
					'b101	: begin	brun=0; if(!brlt )begin alu_sel= ADD;asel=1; bsel=1;pcsel=1; end	end
					'b110	: begin	brun=1; if( brlt )begin alu_sel= ADD;asel=1; bsel=1;pcsel=1; end	end
					'b111	: begin	brun=1; if(!brlt )begin alu_sel= ADD;asel=1; bsel=1;pcsel=1; end	end	
					default : begin	brun=1'bz;  alu_sel= 'bz;asel=1'bz; bsel=1'bz;pcsel=1'bz;	end	
				endcase
			
			end	
	else if(opcode==7'h67)// I type  JALR
			begin
				if(funct3==0)begin
				wbsel=2'h2;
				we_r =1;
				bsel=1;
				asel=0;
				pcsel=0;
				alu_sel=ADD;	
				end
			end
	else if(opcode==7'h6f)// J type  JAL
			begin
				pcsel=1;
				wbsel=2'h2;
				we_r =1;
				bsel=1;
				asel=1;
				alu_sel=ADD;	
			
			end
    else if(opcode==7'h37)// U type		LUI
			begin

				pcsel=0;
				wbsel=2'h1;
				we_r =1;
				bsel=1;
				alu_sel=LUI;	
			
			end
	else if(opcode==7'h17)// U type		AUIPC
			begin
				pcsel=0;
				wbsel=2'h1;
				we_r =1;
				bsel=1;
				asel=1;
				alu_sel=ADD;

			end	
end
	

endmodule 