module clock_and_mem_clock (clk,reset,clock_out);
	input clk,reset;
	output clock_out;
		
	reg clock_out;
		
	initial
		clock_out <= 0;//初始为零
			
	always @ (posedge clk)
		begin
			if (~reset)
				clock_out <= 0; // 复位置零
			else
				clock_out <= ~clock_out; // 否则clock_out信号翻转
		end
endmodule 