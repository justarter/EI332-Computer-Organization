module pipeemreg(ewreg,em2reg,ewmem,ealu,eb,ern,/*ezero,*/clock,
			resetn,mwreg,mm2reg,mwmem,malu,mb,mrn/*,mzero*/);
	
	input        ewreg,em2reg,ewmem,clock,resetn;
	input [31:0] ealu,eb;
	input [4:0]  ern;
	
	output       mwreg, mm2reg, mwmem;
	output [31:0] malu, mb;
	output [4:0] mrn;
	reg	       mwreg, mm2reg, mwmem;
	reg [31:0]   malu, mb;
	reg [4:0]    mrn;
	
	always @(posedge clock or negedge resetn)
	begin
		if (resetn == 0)
		begin
			mwreg <= 0;
			mm2reg <= 0;
			mwmem <= 0;
			malu <= 0;
			mb <= 0;
			mrn <= 0;
		end
		else
		begin
			mwreg <= ewreg;
			mm2reg <= em2reg;
			mwmem <= ewmem;
			malu <= ealu;
			mb <= eb;
			mrn <= ern;
		end
	end
endmodule 