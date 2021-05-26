/////////////////////////////////////////////////////////////
//                                                         //
// School of Software of SJTU                              //
//                                                         //
/////////////////////////////////////////////////////////////

module pipelined_computer (resetn,clock,mem_clock,opc,oinst,oins,oealu,omalu,owalu,onpc,/*da,db,
							pcsource*/,in_port0,in_port1,out_port0,out_port1,out_port2,out_port3,WangHangyu);
   //定义顶层模块pipelined_computer，作为工程文件的顶层入口，如图1-1建立工程时指定。
   input resetn,clock /*,mem_clock*/;
	output mem_clock;
   assign mem_clock = ~clock;
   //定义整个计算机module和外界交互的输入信号，包括复位信号resetn、时钟信号clock、
	//以及一个和clock同频率但反相的mem_clock信号。mem_clock用于指令同步ROM和数据同步RAM使用，其波形需要有别于实验一。
	//这些信号可以用作仿真验证时的输出观察信号 。
	
   input  [5:0] in_port0,in_port1;
   output [31:0] out_port0,out_port1,out_port2,out_port3;// output [6:0] out_port0,out_port1,out_port2,out_port3;
   output [31:0] WangHangyu;
   wire [31:0] real_out_port0,real_out_port1,real_out_port2,real_out_port3;
   
   wire [31:0] real_in_port0 = {26'b00000000000000000000000000,in_port0};
   wire [31:0] real_in_port1 = {26'b00000000000000000000000000,in_port1};
   
   assign out_port0 = real_out_port0[31:0];//assign out_port0 = real_out_port0[6:0];
   assign out_port1 = real_out_port1[31:0];//assign out_port0 = real_out_port1[6:0];
   //assign out_port2 = real_out_port2[31:0];//assign out_port0 = real_out_port2[6:0];
   assign out_port3 = real_out_port3[31:0];//assign out_port0 = real_out_port3[6:0];
	assign WangHangyu = real_out_port2[31:0];
   //IO口的定义，宽度可根据自己设计选择。
   
   wire [31:0] pc,ealu,malu,walu;
	output [31:0] opc,oealu,omalu,owalu;// for watch
	assign opc = pc;
	assign oealu = ealu;
	assign omalu = malu ;
	assign owalu = walu ;
	
   output [31:0] onpc,oins,oinst;// for watch
	assign  onpc=npc;
	assign  oins=ins;
	assign  oinst=inst;
   //模块用于仿真输出的观察信号。缺省为 wire 型。 为了便于观察内部关键信号将其
	//接到输出管脚。不输出也一样，只是仿真时候要从内部信号里去寻找。
	
   wire   [31:0] bpc,jpc,pc4,npc,ins,inst;
	//模块间互联传递数据或控制信息的信号线,均为32位宽信号。IF取指令阶段。
	wire   [31:0] dpc4,da,db,dimm,dsa;
   //模块间互联传递数据或控制信息的信号线,均为32位宽信号。ID指令译码阶段。
   wire   [31:0] epc4,ea,eb,eimm,esa;
	//模块间互联传递数据或控制信息的信号线,均为32位宽信号。ExE指令运算阶段。
   wire   [31:0] mb,mmo;
	//模块间互联传递数据或控制信息的信号线,均为32位宽信号。MEM访问数据阶段。
   wire   [31:0] wmo,wdi;
   //模块间互联传递数据或控制信息的信号线,均为32位宽信号。WB回写寄存器阶段。
   wire   [4:0] ern0,ern,drn,mrn,wrn;
   //模块间互联通过流水线寄存器传递结果寄存器号的信号线寄存器号(32个)为 5bit。
   wire   [4:0] drs,drt,ers,ert;
   //模块间互联，通过流水线寄存器传递rs，rt寄存器号的信号线，寄存器号（32个）为5bit
   wire   [3:0] daluc,ealuc;
   //ID阶段向EXE阶段通过流水线寄存器传递的aluc控制信号，4bit
   wire   [1:0] pcsource;
   //CU模块向IF阶段模块传递的PC选择信号，2bit
   wire         wpcir,flush;
   //CU模块发出的控制流水线停顿的控制信号，使PC和IF/ID流水线寄存器保持不变
   wire         dwreg,dm2reg,dwmem,daluimm,dshift,djal;  //id stage
   //ID阶段产生，需要往后续流水级传播的信号
   wire         ewreg,em2reg,ewmem,ealuimm,eshift,ejal;  //exe stage
   //来自于ID/EXE流水线寄存器，EXE阶段使用，或需要往后续流水级传播的信号
   wire         mwreg,mm2reg,mwmem;  //mem stage
   //来自于EXE/MEM流水线寄存器，MEM阶段使用，或需要往后续流水级传播的信号
   wire         wwreg,wm2reg;  //wb stage
   //来自于MEM/WB流水线寄存器，WB阶段使用
  /* wire         ezero,mzero;  */
   //模块间互联，通过流水线寄存器传递的zero信号线
   wire     ebubble,dbubble;
   //模块间互联，通过流水线寄存器传递的流水线冒险处理bubble控制信号线
   
   pipepc   prog_cnt(npc,wpcir,clock,resetn,pc);
   
   pipeif   if_stage(pcsource,pc,bpc,da,jpc,npc,pc4,ins,mem_clock); 
	
   pipeir   inst_reg(pc4,ins,wpcir,clock,resetn,
                     dpc4,inst);  
							
   pipeid   id_stage(mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst/*,ins*/,
                    wrn,wdi,ealu,malu,mmo,wwreg,mem_clock,resetn,
					bpc,jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,daluc,
					daluimm,da,db,dimm,dsa,drn,dshift,djal/*,mzero,
					drs,drt,npc*/,ebubble,dbubble);  				
					
   pipedereg de_reg(dbubble,drs,drt,dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,dsa,drn,dshift,djal,dpc4,clock,resetn,
					ebubble,ers,ert,ewreg,em2reg,ewmem,ealuc,ealuimm,ea,eb,eimm,esa,ern0,eshift,ejal,epc4); 
					
   pipeexe  exe_stage(ealuc,ealuimm,ea,eb,eimm,esa,eshift,ern0,epc4,ejal,ern,ealu/*,ezero,ert,
               wrn,wdi,malu,wwreg*/);  
					
   pipeemreg em_reg(ewreg,em2reg,ewmem,ealu,eb,ern/*,ezero*/,clock,resetn,
					mwreg,mm2reg,mwmem,malu,mb,mrn/*,mzero*/); 
					
   pipemem mem_stage(mwmem,malu,mb/*,clock*/,mem_clock,mmo,resetn,
					real_in_port0,real_in_port1,real_out_port0,real_out_port1,real_out_port2/*,real_out_port3*/);  
					
   pipemwreg mw_reg(mwreg,mm2reg,mmo,malu,mrn,clock,resetn,
					wwreg,wm2reg,wmo,walu,wrn);  
					
   mux2x32 wb_stage(walu,wmo,wm2reg,wdi); 
	
endmodule
