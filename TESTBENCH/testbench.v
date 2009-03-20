
module testbench;

	//-------------------------------
	//	Register Declarations
	//-------------------------------
 reg 	clock;
 reg	reset;


 	//-------------------------------
	//	Wire Declarations
	//-------------------------------

 wire [31:0]	i_Instr;
 wire [31:0]	d_RdData;
 wire [31:0]	i_InstrAddr;
 wire 		i_InstrEn;
 wire [31:0]	d_MemWrData;
 wire [31:0]	d_MemAddr;
 wire 		d_MemWrEn;
 wire 		d_MemRdEn;


 	//------------------------------
	//	MIPS TOP Instantiation
	//------------------------------

 mips_top mips_top (
	 	.clock		(clock), 
		.reset		(reset),
		.instr_data	(i_Instr),
		.me_ExtMemRdData(d_RdData),

		.instr_addr	(i_InstrAddr),
		.instr_en	(i_InstrEn),
		.me_ExtMemWrData(d_MemWrData),
		.me_ExtMemAddr  (d_MemAddr),
		.me_ExtMemWrEn  (d_MemWrEn),
		.me_ExtMemRdEn  (d_MemRdEn)
	    	);


	//------------------------------
	//	Instruction Memory
	//------------------------------

 Memory instr_mem (
	 	.clock		(clock),
		.reset		(reset),
		.Addr		(i_InstrAddr),
		.MemEn		(i_InstrEn),
		.MemWr		(1'b0),
		.WData		(32'b0),
		
		.RdData		(i_Instr)
		);



	//-----------------------------
	// 	Data Memory
	//-----------------------------

 Memory data_mem (
		.clock		(clock),
       		.reset		(reset),
		.Addr		(d_MemAddr),
		.MemEn		(d_MemRdEn || d_MemWrEn),
		.MemWr		(d_MemWrEn),
		.WData		(d_MemWrData),

		.RdData		(d_RdData)
		);		

stim  stim	();

endmodule





