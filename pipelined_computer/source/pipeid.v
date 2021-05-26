module pipeid(mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst/*,ins*/,
               wrn,wdi,ealu,malu,mmo,wwreg,mem_clock,resetn,
					bpc,jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,daluc,
					daluimm,da,db,dimm,dsa,drn,dshift,djal/*,mzero,
					drs,drt*/,ebubble,dbubble);
	input 		mwreg,ewreg,em2reg,mm2reg,wwreg,mem_clock,resetn,ebubble;
	input [4:0] mrn,ern,wrn;
	input [31:0] dpc4,inst,wdi,ealu,malu,mmo;
	
	output [31:0] jpc,bpc,da,db,dimm,dsa;
	output [1:0] pcsource;
	output 		 wpcir,dwreg,dm2reg,dwmem,daluimm,dshift,djal,dbubble;
	output [3:0] daluc;
	output [4:0] drn;
	
	wire [31:0] q1,q2,da,db;
	wire [1:0]  fwda,fwdb;
	wire 	      z = (da == db);
	wire        regrt,sext;
	wire        e = sext & inst[15];
	wire [15:0] imm = {16{e}};
	wire [31:0] dimm = {imm,inst[15:0]};
	wire [31:0] dsa = {27'b0,inst[10:6]};     //sa部分
	wire [31:0] offset = {imm[13:0],inst[15:0],2'b0};
	wire [31:0] jpc = {dpc4[31:28],inst[25:0],2'b0};
	wire [31:0] bpc = dpc4 + offset;
	
	wire dbubble = (pcsource[1:0] != 2'b0);
	
	regfile rf(inst[25:21],inst[20:16],wdi,wrn,wwreg,mem_clock,resetn,q1,q2);
	mux4x32 da_mux(q1,ealu,malu,mmo,fwda,da);
	mux4x32 db_mux(q2,ealu,malu,mmo,fwdb,db);
	mux2x5  rn_mux(inst[15:11],inst[20:16],regrt,drn);
	sc_cu   cu(inst[31:26],inst[5:0],z,dwmem,dwreg,regrt,dm2reg,daluc,dshift,
					daluimm,pcsource,djal,sext,fwda,fwdb,wpcir,inst[25:21],
					inst[20:16],mrn,mm2reg,mwreg,ern,em2reg,ewreg,ebubble);
endmodule