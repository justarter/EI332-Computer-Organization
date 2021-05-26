module pipeif(pcsource,pc,bpc,da,jpc,npc,pc4,ins,mem_clock);
						//pcsource决定npc的值从哪里来，bpc是beq和bne的pc，da是jr的pc，jpc是j和jal的pc
	input [1:0] pcsource;
	input [31:0] pc,bpc,da,jpc;
	input        mem_clock;
	
	output [31:0] npc,pc4,ins;
	wire [31:0] npc,pc4,ins;
	
	assign pc4 = pc + 4;
	
	mux4x32 nextpc(pc4,bpc,da,jpc,pcsource,npc);//0:pc4,1:bpc,2:da,3:jpc
	
	sc_instmem imem(pc,ins,mem_clock);//取出指令
	
endmodule