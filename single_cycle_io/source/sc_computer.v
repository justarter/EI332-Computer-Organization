/////////////////////////////////////////////////////////////
//                                                         //
// School of Software of SJTU                              //
//                                                         //
/////////////////////////////////////////////////////////////

module sc_computer (reset,clk,
	SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW8,SW9,
	HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,WangHangyu);//
   
   input reset,clk;
	input SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW8,SW9;
	
	output [31:0] WangHangyu;
	
	output[6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
	
	wire [31:0] pc,inst,aluout,memout;
	wire        imem_clk,dmem_clk;
	
	wire        clock_out;
	wire[31:0]  mem_dataout,io_read_data;
	wire[31:0]  in_port0,in_port1,in_port2;//三个输入端口
	wire[31:0]  out_port0,out_port1,out_port2;//三个输出端口
	
	
	clock_and_mem_clock inst3(clk,reset,clock_out);//用clk产生clock_out
	
	in_port inst1(SW4,SW3,SW2,SW1,SW0,in_port0);//把五位2进制数存入io
	in_port inst2(SW9,SW8,SW7,SW6,SW5,in_port1);
	//assign in_port2 = WHY; //令输入端口2的值为WHY
	
	sc_computer_main inst4(reset,clock_out,clk,pc,inst,aluout,memout,imem_clk,dmem_clk,mem_dataout,io_read_data,
							out_port0,out_port1,out_port2,in_port0,in_port1,in_port2);//注意这里的输入输出端口
							
	//out_port_seg inst5(out_port0,HEX1,HEX0);//将输出数据转换到十进制然后七段译码器
	//out_port_seg inst6(out_port1,HEX3,HEX2);
	//out_port_seg inst7(out_port2,HEX5,HEX4);
	assign WangHangyu= out_port2;
endmodule



