//---------------------------------------------------------
//	      MIPS Top Level	
//
//
// Author: Babak Azimi
// Class: EG-EE  597 Senior Project
//
//---------------------------------------------------------


module mips_top (	
		clock, 
		reset,
		instr_data,
		me_ExtMemRdData,

		instr_addr,
		instr_en,
		me_ExtMemWrData,
		me_ExtMemAddr,
		me_ExtMemWrEn,
		me_ExtMemRdEn
		
	    );

input 		clock;
input		reset;
input  [31:0]	instr_data;
input  [31:0]	me_ExtMemRdData;

output [31:0]	instr_addr;
output		instr_en;
output		me_ExtMemWrEn;
output		me_ExtMemRdEn;
output [31:0]	me_ExtMemWrData;
output [31:0]	me_ExtMemAddr;


	//---------------------------------
	//	wire assignments
	//---------------------------------
// global signals
wire		clock;
wire		reset;

// fetch stage
wire  [31:0]	if_instr = instr_data;
wire  [31:0]	if_PC;
wire  [2:0]	if_PCSrcSel;
wire  [31:0]	if_RFOutA;

// decode stage
wire [31:0]	id_PC;
wire [5:0]	id_ALUOp;
wire [5:0]	id_OpCode;
wire [1:0]	id_ALUSrcSel;
wire [4:0]	id_SHF;
wire [4:0]	id_RT;
wire [4:0]	id_RS;
wire [4:0]	id_RD;
wire		id_RegDestSel;
wire		id_MemRegSel;
wire		id_RegWriteSel;
wire [31:0]	id_RFOutA;
wire [31:0]	id_RFOutB;
wire [31:0]	id_SignExtImm;
wire [31:0]	id_ZeroExtImm;

// execute stage
wire		ex_MemWr;      
wire 		ex_MemRd;      
wire  [31:0]	ex_ALUOut;     
wire  [31:0]	id_ALUOut;     
wire  [31:0]	ex_OpB_pre;    
wire  [4:0]	ex_RegDest;   
wire 		ex_MemRegSel;  
wire 		ex_RegWriteSel;


// memory stage
wire  [31:0]	me_Data = me_ExtMemAddr;
wire 		me_MemRegSel;
wire 		me_RegWriteSel;
wire  [4:0]	me_RegDest;
wire  [31:0]	me_ByData;

// write-Back stage
wire  		wr_RegWriteSel;
wire  [31:0]	wr_Data;
wire  [4:0]	wr_RegDest;


// Hazard Unit
wire		hz_clear = 0;
wire 		stall;


assign          instr_addr = if_PC;
assign          instr_en   = !stall;

 fetch_stage fetch_stage (
	 	.clock 		(clock		),
		.reset 		(reset		),
		.if_instr 	(if_instr	),
		.id_PC 		(id_PC		),
		.if_PCSrcSel	(if_PCSrcSel	),
		.if_RFOutA      (if_RFOutA      ),
		.stall		(stall	        ),

		.if_PC		(if_PC		)
		);


 decode_stage decode_stage (
		.clock		(clock	       ), 
		.reset		(reset	       ),
		.if_instr	(if_instr      ),
		.if_PC		(if_PC	       ),
                .wr_RegWriteSel (wr_RegWriteSel),
		.wr_Data	(wr_Data       ),       
                .wr_RegDest	(wr_RegDest    ),
		.hz_clear	(hz_clear      ),
		.ex_MemRd 	(ex_MemRd      ),
		.ex_RegDest	(ex_RegDest    ),
		.ex_RegWriteSel (ex_RegWriteSel),
		.ex_ALUOut	(ex_ALUOut     ),
		.id_ALUOut	(id_ALUOut     ),
                
	  	.id_PC		(id_PC	       ),
                .id_ALUOp	(id_ALUOp      ),
		.id_OpCode	(id_OpCode     ),
                .id_ALUSrcSel	(id_ALUSrcSel  ),
                .id_SHF		(id_SHF	       ),
                .id_RT		(id_RT	       ),
                .id_RS		(id_RS	       ),
                .id_RD		(id_RD	       ),
                .id_RegDestSel	(id_RegDestSel ),
		.id_MemRegSel	(id_MemRegSel  ),
                .id_RegWriteSel (id_RegWriteSel),
		.id_RFOutA      (id_RFOutA     ),
		.id_RFOutB      (id_RFOutB     ),
		.id_SignExtImm  (id_SignExtImm ),
		.id_ZeroExtImm  (id_ZeroExtImm ),
		.id_MemWr	(id_MemWr      ),
		.id_MemRd	(id_MemRd      ),
		.if_PCSrcSel    (if_PCSrcSel   ),
		.if_RFOutA      (if_RFOutA     ),
		.stall		(stall	       )
		);	 	


execute_stage execute_stage (	
		.clock		(clock	       ), 
		.reset		(reset	       ), 
                .id_ALUOp	(id_ALUOp      ),
		.id_OpCode	(id_OpCode     ),
                .id_ALUSrcSel	(id_ALUSrcSel  ),
                .id_SHF		(id_SHF	       ),
                .id_RT		(id_RT	       ),
                .id_RS		(id_RS	       ),
                .id_RD		(id_RD	       ),
                .id_RegDestSel	(id_RegDestSel ),
		.id_MemRegSel	(id_MemRegSel  ),
                .id_RegWriteSel	(id_RegWriteSel),
		.id_RFOutA	(id_RFOutA     ),
		.id_RFOutB	(id_RFOutB     ),
		.id_SignExtImm	(id_SignExtImm ),
		.id_ZeroExtImm	(id_ZeroExtImm ),
		.id_MemRd	(id_MemRd      ),
		.id_MemWr	(id_MemWr      ),
		.me_Data	(me_Data       ),
		.wr_Data	(wr_Data       ),
		.me_RegDest	(me_RegDest    ),
		.me_RegWriteSel (me_RegWriteSel),
                                               
		.ex_MemWr	(ex_MemWr      ),
                .ex_MemRd	(ex_MemRd      ),
                .ex_ALUOut	(ex_ALUOut     ),
		.id_ALUOut	(id_ALUOut     ),
                .ex_OpB_pre	(ex_OpB_pre    ),
                .ex_RegDest	(ex_RegDest    ),
                .ex_MemRegSel	(ex_MemRegSel  ),
                .ex_RegWriteSel (ex_RegWriteSel)
		);

memory_stage memory_stage (
		.clock		(clock		),
		.reset		(reset		),
		.ex_MemWr	(ex_MemWr	),
		.ex_MemRd	(ex_MemRd	),
		.ex_ALUOut	(ex_ALUOut	),
		.ex_OpB_pre	(ex_OpB_pre	),
		.ex_RegDest	(ex_RegDest	),
		.ex_MemRegSel   (ex_MemRegSel	),
		.ex_RegWriteSel (ex_RegWriteSel ),

		.me_ExtMemAddr	(me_ExtMemAddr	),
		.me_ExtMemWrData(me_ExtMemWrData),
		.me_ExtMemWrEn	(me_ExtMemWrEn	),
		.me_ExtMemRdEn	(me_ExtMemRdEn	),
		.me_MemRegSel   (me_MemRegSel   ),
		.me_RegWriteSel (me_RegWriteSel ),
		.me_RegDest     (me_RegDest     ),
		.me_ByData      (me_ByData      )
		);

		
wback_stage wback_stage (
		.me_ExtMemRdData(me_ExtMemRdData),
		.me_MemRegSel   (me_MemRegSel   ),
		.me_RegWriteSel (me_RegWriteSel ),
		.me_RegDest     (me_RegDest     ),
		.me_ByData	(me_ByData	),

		.wr_RegDest	(wr_RegDest	),
		.wr_Data	(wr_Data	),
		.wr_RegWriteSel (wr_RegWriteSel )
		);

		
endmodule       
