module in_port(SW4,SW3,SW2,SW1,SW0,in_port_num);//把五位二进制数加入到inport中
	input SW4,SW3,SW2,SW1,SW0;
	output[31:0] in_port_num;
	assign in_port_num={27'b0,SW4,SW3,SW2,SW1,SW0};
 
 
endmodule 