module seven_segment_decoder (num,HEX);
   input[3:0] num;
	output[6:0] HEX;
	
	reg [6:0] HEX;
	
	always@(*)
		begin
			case(num)
				4'b0000: HEX = 7'b1111110; // 0
				4'b0001: HEX = 7'b0110000; // 1
				4'b0010: HEX = 7'b1101101; // 2
				4'b0011: HEX = 7'b1111001; // 3
				4'b0100: HEX = 7'b0110011; // 4
				4'b0101: HEX = 7'b1011011; // 5
				4'b0110: HEX = 7'b1011111; // 6
				4'b0111: HEX = 7'b1110000; // 7
         	4'b1000: HEX = 7'b1111111; // 8
				4'b1001: HEX = 7'b1111011; // 9
            default: HEX = 7'b0000000;
			endcase
		end
endmodule