module io_input_mux(a0,a1,a2,sel_addr,y);
	input [31:0] a0,a1,a2;
	input [5:0] sel_addr;
	
	output [31:0]  y;
	
	reg [31:0] y;
	
	always @ *
		case (sel_addr)
			6'b100000: y = a1;//80h
			6'b100001: y = a0;//84h
			6'b100100: y = a2;//90h
// more ports 可根据需要设计更多的端口
			default: y = 32'h0;
		endcase
endmodule