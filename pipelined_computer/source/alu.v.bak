module alu (a,b,aluc,s,z);
   input [31:0] a,b;
   input [3:0] aluc;
   output [31:0] s;
   output        z;
   reg [31:0] s;
   reg        z;
	
	reg[31:0]    res;
   always @ (a or b or aluc) 
      begin                                   // event
         casex (aluc)
             4'bx000: s = a + b;              //x000 ADD
             4'bx100: s = a - b;              //x100 SUB
				 4'bx001: s = a & b;					 //x001 AND
             4'bx101: s = a | b;              //x101 OR
             4'bx010: s = a ^ b;              //x010 XOR
             4'bx110: s = {b[15:0],16'b0};    //x110 LUI: imm << 16bit             
             4'b0011: s = b << a;             //0011 SLL: rd <- (rt << sa)
             4'b0111: s = b >> a;             //0111 SRL: rd <- (rt >> sa) (logical)
             4'b1111: s = $signed(b) >>> a;   //1111 SRA: rd <- (rt >> sa) (arithmetic)
				 4'b1011: 								 //1011 hads
					begin
						res = a ^ b;
						s = res[0] + res[1] + res[2] + res[3] + res[4] + res[5] + res[6] + res[7] +
							 res[8] + res[9] + res[10] + res[11] + res[12] + res[13] + res[14] + res[15] +
							 res[16] + res[17] + res[18] + res[19] + res[20] + res[21] + res[22] + res[23] +
							 res[24] + res[25] + res[26] + res[27] + res[28] + res[29] + res[30] + res[31] ;
					end
             default: s = 0;
         endcase
         if (s == 0 )  z = 1;
            else z = 0;         
      end      
endmodule 