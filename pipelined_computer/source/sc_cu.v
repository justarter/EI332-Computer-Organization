module sc_cu (op, func, z, wmem, wreg, regrt, m2reg, aluc, shift,
              aluimm, pcsource, jal,sext, fwda, fwdb, wpcir,
	rs, rt, mrn, mm2reg, mwreg, ern, em2reg, ewreg, ebubble);
	
   input        z,mm2reg,mwreg, em2reg,ewreg, ebubble;  
	input  [5:0] op,func;
	input  [4:0] rs, rt, mrn, ern;
   
   output       wreg,regrt,jal,m2reg,shift,aluimm,sext,wmem,wpcir;
   output [3:0] aluc;
   output [1:0] pcsource,fwda,fwdb;
   reg [1:0] fwda, fwdb;
	
   wire r_type = ~|op;
   wire i_add = r_type & func[5] & ~func[4] & ~func[3] &
                ~func[2] & ~func[1] & ~func[0];          //100000
   wire i_sub = r_type & func[5] & ~func[4] & ~func[3] &
                ~func[2] &  func[1] & ~func[0];          //100010
					 
   wire i_hads = r_type & func[5] & func[4] & func[3] &
                func[2] &  func[1] & func[0];           //111111
   
   wire i_and = r_type & func[5] & ~func[4] & ~func[3] &
                func[2] & ~func[1] & ~func[0]; 				//100100
   wire i_or  = r_type & func[5] & ~func[4] & ~func[3] &
                func[2] & ~func[1] & func[0]; 				//100101
   wire i_xor = r_type & func[5] & ~func[4] & ~func[3] &
                func[2] & func[1] & ~func[0]; 				//100110
   wire i_sll = r_type & ~func[5] & ~func[4] & ~func[3] &
                ~func[2] & ~func[1] & ~func[0]; 			//000000
   wire i_srl = r_type & ~func[5] & ~func[4] & ~func[3] &
                ~func[2] & func[1] & ~func[0]; 				//000010
   wire i_sra = r_type & ~func[5] & ~func[4] & ~func[3] &
                ~func[2] & func[1] & func[0]; 				//000011
   wire i_jr  = r_type & ~func[5] & ~func[4] & func[3] &
                ~func[2] & ~func[1] & ~func[0]; 			//001000
                
   wire i_addi = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0]; //001000
   wire i_andi = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0]; //001100
   
   wire i_ori  = ~op[5] & ~op[4] &  op[3] & op[2] & ~op[1] & op[0];	//001101         
   wire i_xori = ~op[5] & ~op[4] &  op[3] & op[2] & op[1] & ~op[0];  //001110
   wire i_lw   = op[5] & ~op[4] &  ~op[3] & ~op[2] & op[1] & op[0];  //100011
   wire i_sw   = op[5] & ~op[4] &  op[3] & ~op[2] & op[1] & op[0];	//101011
   wire i_beq  = ~op[5] & ~op[4] &  ~op[3] & op[2] & ~op[1] & ~op[0];//000100
   wire i_bne  = ~op[5] & ~op[4] &  ~op[3] & op[2] & ~op[1] & op[0];	//000101
   wire i_lui  = ~op[5] & ~op[4] &  op[3] & op[2] & op[1] & op[0];	//001111
   wire i_j    = ~op[5] & ~op[4] &  ~op[3] & ~op[2] & op[1] & ~op[0];//000010
   wire i_jal  = ~op[5] & ~op[4] &  ~op[3] & ~op[2] & op[1] & op[0];	//000011
   
	assign wpcir = ~(em2reg & ( ern == rs | ern == rt ));//lw的数据冒险
	wire control = wpcir & ~ebubble;//跳转指令的bubble
	
   assign pcsource[1] = control&(i_jr | i_j | i_jal);
   assign pcsource[0] = control&(( i_beq & z ) | (i_bne & ~z) | i_j | i_jal) ;
   
   assign wreg =control&(i_add | i_sub | i_and | i_or   | i_xor  |
                 i_sll | i_srl | i_sra | i_addi | i_andi |
                 i_ori | i_xori | i_lw | i_lui  | i_jal | i_hads);
   
   assign aluc[3] = control&(i_sra | i_hads);     
   assign aluc[2] = control&(i_sub | i_beq | i_bne | i_or | i_ori | i_lui | i_srl | i_sra);
   assign aluc[1] = control&(i_xor | i_sll | i_srl | i_sra | i_xori | i_lui | i_hads);
   assign aluc[0] = control&(i_and | i_andi | i_or | i_ori | i_sll | i_srl | i_sra |i_hads);
   assign shift   = control&(i_sll | i_srl | i_sra );

   assign aluimm  = control&(i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_lui);      
   assign sext    = control&(i_addi | i_lw | i_sw | i_beq | i_bne);
   assign wmem    = control&(i_sw);
   assign m2reg   = control&(i_lw);
   assign regrt   = control&(i_addi | i_andi | i_ori | i_xori | i_lw | i_lui);
   assign jal     =control&(i_jal);
	
	always @(*)
	begin
		if (ewreg & ~ em2reg & (ern != 0) & (ern == rs) )  
			fwda <= 2'b01; //将上一条指令的alu结果直通
      else 
			if (mwreg & ~ mm2reg & (mrn != 0) & (mrn == rs) ) 
            fwda <= 2'b10;  //将向前第二条指令的alu结果直通
			else  
				if (mwreg & mm2reg & (mrn != 0) & (mrn == rs) )  
					fwda <= 2'b11; // 将向前第二条指令的数据RAM的输出直通
				else 
					fwda <= 2'b00;  
	end
	
	always@(*)
	begin
		if (ewreg & ~ em2reg &(ern != 0) & (ern == rt) ) 
			fwdb <= 2'b01;
      else  
			if (mwreg & ~ mm2reg & (mrn != 0) & (mrn == rt) )  
				fwdb <= 2'b10;
			else 
				if (mwreg & mm2reg & (mrn != 0) & (mrn == rt) )   
					fwdb <= 2'b11;
				else 
					fwdb <= 2'b00; 
	end
	
endmodule