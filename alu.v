
//operation can be performed : ADD SUB SLT SLTU _comapre signed and unsigned _ AND OR XOR SLL SRL SRA  
module alu (in1,in2,op,out);
///////////////////////////////////PARAMETERS/////////////////////////////
parameter ADD = 4'h0 , AND = 4'h1 ,OR  = 4'h2 , XOR = 4'h3 ,  SUB = 4'h4 , SLT = 4'h5 , SLTU = 4'h6 ,
		   SLL = 4'h7 , SRL  = 4'h8 , SRA = 4'h9 ,LUI=4'ha;

////////////////////////////////////////////////////////////////////////
input signed[31:0] in1, in2;
input [3:0]op;
output reg [31:0] out;

wire   [31:0] in1_1, in2_1; // unsigned input for SLU
assign in1_1=in1;
assign in2_1=in2;

always @(*) begin
	
	case (op)
		ADD     : begin out = in1 + in2 ; 			    		end     // ADD
		AND     : begin out = in1 & in2 ;                		end     // AND   
		OR      : begin out = in1 | in2 ;                		end     // OR
		XOR     : begin out = in1 ^ in2 ;                		end     // XOR
		SUB     : begin out = in1 - in2 ; 				    	end     //SUB
		SLT     : begin if (in1<in2) out=1; else out =0;   	end     //SLT
		SLTU    : begin if ( in1_1 < in2_1 ) out=1; else out =0; 	end     // SLTU 
		SLL     : begin out = in1   <<  in2[4:0] ;             	end     // SLL
		SRL     : begin out = in1_1   >>  in2[4:0] ;            end     // SRL
		SRA     : begin out = in1 >>> in2[4:0] ;             	end     // SRA	
		LUI		: begin out = in2;								end 	// LUI
		default : begin out = 'bz;								end 	// default

	endcase
	
end



endmodule 