module out_port_seg(out_port_num,HEX1,HEX0);
	input[31:0]   out_port_num;
	output[6:0]   HEX1,HEX0;
	
	
	wire[3:0]     num1,num0;
	
	assign num1 = out_port_num/10;//获取十位数
	assign num0 = out_port_num%10;//获取个位数
	
	seven_segment_decoder high_digit(num1,HEX1);//十位数保存在HEX1
	seven_segment_decoder low_digit(num0,HEX0);//个位数保存在HEX0
	
	
endmodule 