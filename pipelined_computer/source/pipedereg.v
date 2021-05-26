module pipedereg(dbubble,drs,drt,dwreg,dm2reg,dwmem,
					daluc,daluimm,da,db,dimm,dsa,drn,dshift,djal,dpc4,
					clock,resetn,ebubble,ers,ert,ewreg,em2reg,ewmem,
					ealuc,ealuimm,ea,eb,eimm,esa,ern0,eshift,ejal,epc4);
					
	input         dwreg, dm2reg, dwmem, daluimm, dshift, djal, clock, resetn,dbubble;
	input  [3:0]  daluc;
	input  [31:0] dimm, da, db, dpc4,dsa;
	input  [4:0]  drn,drs,drt;
	
	output 		  ewreg, em2reg, ewmem, ealuimm, eshift, ejal,ebubble; 
	output [3:0]  ealuc;
	output [31:0] eimm, ea, eb, epc4,esa;
	output [4:0]  ern0,ers,ert;
	
	reg       	  ewreg, em2reg, ewmem, ealuimm, eshift, ejal,ebubble; 
	reg    [3:0]  ealuc;
	reg    [31:0] eimm, ea, eb, epc4,esa;
	reg    [4:0]  ern0,ers,ert;
	
	always @( posedge clock or negedge resetn)
	begin
		if (resetn == 0 )  //清零
		begin
			ewreg <= 0;
			em2reg <= 0;
			ewmem <= 0;
			ealuimm <= 0;
			eshift <= 0;
			ejal <= 0;
			ealuc <= 0;
			eimm <= 0;
			ea <= 0;
			eb <= 0;
			epc4 <= 0;
			ern0 <= 0;
			ers <= 0;
			ert <= 0;
			esa <= 0;
			ebubble <= 0;
		end
		else
		begin  
			ewreg <= dwreg;
			em2reg <= dm2reg;
			ewmem <= dwmem;
			ealuimm <= daluimm;
			eshift <= dshift;
			ejal <= djal;
			ealuc <= daluc;
			eimm <= dimm;
			ea <= da;
			eb <= db;
			epc4 <= dpc4;
			ern0 <= drn; 
			ers <= drs;
			ert <= drt;
			esa <= dsa;
			ebubble <= dbubble;
		end
	end
	
endmodule