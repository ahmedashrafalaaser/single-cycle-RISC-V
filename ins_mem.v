// 1 KB ROM to keep ins
module ins_mem (clk,rst,pointer,ins);
input clk,rst;
input [31:0]pointer;
output  [31:0] ins;
reg [31:0] ins_rom [255:0];

wire [7:0] add = pointer[9:2];
  


// always @(*) begin 
// 	ins_mem='{'h00500113,
// 			 'h00C00193,
// 			 'hFF718393,
// 			 'h0023E233,
// 			 'h0041F2B3,
// 			 'h004282B3,
// 			 'h02728463,
// 			 'h00020463,
// 			 'h00000293,
// 			 'h005203B3,
// 			 'h402383B3,
// 			 'h0471AA23,
// 			 'h06002103,
// 			 'h005104B3,
// 			 'h008001EF,
// 			 'h00100113,
// 			 'h00910133,
// 			 'h0221A023,
// 			 'h00210063};		
// end
assign ins =ins_rom[add];

endmodule
