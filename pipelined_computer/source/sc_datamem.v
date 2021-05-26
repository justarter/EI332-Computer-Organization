module sc_datamem (addr,datain,dataout,we,mem_clock,resetn,
		out_port0,out_port1,out_port2,in_port0,in_port1,
		mem_dataout,io_read_data
);

   input  [31:0]  addr;
   input  [31:0]  datain;
	input  [31:0]  in_port0,in_port1;
   input          we, mem_clock,resetn;

   output [31:0]  dataout;
	output [31:0]  out_port0,out_port1,out_port2;
	output [31:0]  mem_dataout,io_read_data;
   
 /*  wire           dmem_clk;  */  
   wire           write_enable; 
	wire [31:0]    dataout;
	wire [31:0]    mem_dataout;
	wire           write_data_enable;
	wire           write_io_enable;
	
   assign         write_enable = we; //可能会有问题
 /*  assign         dmem_clk = mem_clk & ( ~ clock) ; */
 
	assign         write_data_enable = write_enable & (~addr[7]);
	assign         write_io_enable = write_enable & addr[7];
   
   lpm_ram_dq_dram  dram(addr[6:2],mem_clock,datain,write_data_enable,mem_dataout );//从mem中取出mem_dataout
	
	io_output io_output_reg(addr,datain, write_io_enable, mem_clock, out_port0,out_port1,out_port2,resetn);//把数据送到外部设备
	
	io_input io_input_reg(addr,mem_clock,io_read_data,in_port0,in_port1);//从io中取出io_read_data
	
	mux2x32 io_data_mux(mem_dataout,io_read_data,addr[7],dataout);//选择io_read_data、mem_dataout哪个作为dataout
	
endmodule 