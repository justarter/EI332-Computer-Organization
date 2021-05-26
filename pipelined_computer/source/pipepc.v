module pipepc(npc,wpcir,clock,resetn,pc);//提供下一条指令的pc
	input [31:0] npc;//下一条指令pc
	input 		 wpcir,clock,resetn;
	
	output [31:0] pc;
	
	reg    [31:0] pc;
	
	always@(posedge clock or negedge resetn)//时钟上升沿
	begin
		if (resetn == 0)//复位
			begin
				pc <= -4;
			end
		else
			if (wpcir == 1)//不复位且没有气泡
				begin
					pc <= npc;
				end
	end
endmodule