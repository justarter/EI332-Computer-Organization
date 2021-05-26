module pipeir(pc4,ins,wpcir,clock,resetn,dpc4,inst,dbubble);
//IF/ID寄存器，clock上升沿启动
	input [31:0] pc4,ins;
	input        wpcir,clock,resetn;
	input 		dbubble;
	output [31:0] dpc4,inst;//在ID阶段的pc4和指令
	
	reg [31:0] dpc4,inst;
	
	always@(posedge clock or negedge resetn)
	begin	
		if (resetn == 0)
			begin
				dpc4 <= 0;
				inst <= 0;
			end
		else
			if(wpcir == 1)
					begin 
						dpc4 <= pc4;
						inst <= ins;
					end
		
	end
	
endmodule