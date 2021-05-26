module pipeexe(ealuc,ealuimm,ea,eb,eimm,esa,eshift,ern0,
				epc4,ejal,ern,ealu,/*ezero,ert,wrn,wdi,malu,wwreg*/);
	input  [3:0]  ealuc;
	input  [31:0] ea, eb, eimm, epc4,esa;
	input  [4:0]  ern0;
	input  		  ealuimm, eshift, ejal;
	
	output [31:0] ealu;
	output [4:0]  ern;
	
	wire   [31:0] alua, alub, alur;
	wire   [31:0] epc8 = epc4 + 4;
	wire   [4:0]  ern = ern0 | {5{ejal}};
	wire          ezero;
	
	mux2x32 a_mux( ea, esa, eshift, alua );//alu两个计算数的来源
	mux2x32 b_mux( eb, eimm, ealuimm, alub );
	
	alu     alu_unit( alua, alub, ealuc, alur, ezero);  // alu模块
	
	mux2x32 ealu_mux( alur, epc4, ejal, ealu );//判断ealu是pc+4(jal)还是alu的计算结果，没有延迟槽
	  
endmodule
	
