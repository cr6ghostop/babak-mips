//---------------------------------------------------------
//		Instruction Decode Stage
//
//
// Author: Babak Azimi
// Class: EG-EE  597 Senior Project
//
//---------------------------------------------------------


module decode_stage (	clock, 
			reset,
		        if_instr,
			if_PC,
                        wr_RegWriteSel,
		        wr_Data,       
                        wr_RegDest,
			hz_clear,
			ex_MemRd,
			ex_RegDest,
			ex_RegWriteSel,
			id_ALUOut,
			ex_ALUOut,

	  		id_PC,
                        id_ALUOp,
			id_OpCode,
                        id_ALUSrcSel,
                        id_SHF,
                        id_RT,
                        id_RS,
                        id_RD,
                        id_RegDestSel,
			id_MemRegSel,
                        id_RegWriteSel,
			id_RFOutA,
			id_RFOutB,
			id_SignExtImm,
			id_ZeroExtImm,
			id_MemRd,
			id_MemWr,
			if_RFOutA,
			if_PCSrcSel,
			stall
		        );

input		clock;
input		reset;
input  [31:0]	if_instr;
input  [31:0]	if_PC;
input  		wr_RegWriteSel;
input  [31:0]	wr_Data;
input  [4:0]	wr_RegDest;   
input		hz_clear;
input  [4:0]	ex_RegDest;
input		ex_MemRd;
input  [31:0]	id_ALUOut;
input  [31:0]	ex_ALUOut;
input		ex_RegWriteSel;

output [31:0]	id_PC;
output [5:0]	id_ALUOp;
output [5:0]	id_OpCode;
output [1:0]	id_ALUSrcSel;
output [4:0]	id_SHF;
output [4:0]	id_RT;
output [4:0]	id_RS;
output [4:0]	id_RD;
output		id_RegDestSel;
output		id_MemRegSel;
output		id_RegWriteSel;
output [31:0]	id_RFOutA;
output [31:0]	id_RFOutB;
output [31:0]	id_SignExtImm;
output [31:0]	id_ZeroExtImm;
output 		id_MemWr;
output		id_MemRd;
output [31:0]	if_RFOutA;
output [2:0]	if_PCSrcSel;
output		stall;

	//--------------------------
	//	Definitions
	//--------------------------
`define LBU	6'h24
`define LHU     6'h25
`define LW	6'h23
`define SB	6'h28
`define SH	6'h29
`define SW	6'h2B
`define ANDI	6'h0C
`define ORI     6'h0D
`define LUI     6'h0f

	//--------------------------
	//  Register Assignments
	//--------------------------
integer		i,j;
reg 		RFormat;
reg		JFormat;
reg		FFormat;
reg		IFormat;
reg		MemRd;
reg		MemWr;
reg [ 5:0]	id_ALUOp     ;
reg [ 4:0]	id_SHF       ;
reg [ 4:0]	id_RD        ;
reg [ 4:0]	id_RT        ;
reg [ 4:0]	id_RS        ;
reg [ 5:0]	id_OpCode    ;
reg 		id_RegDestSel;
reg [ 4:0] 	id_RegDest   ;
reg [ 1:0] 	id_ALUSrcSel ;
reg 		id_MemRegSel ;
reg 		id_RegWriteSel;
reg [31:0]	id_RFOutA    ;
reg [31:0]	id_RFOutB    ;
reg [31:0]	id_PC	     ;
reg 		id_MemRd     ;
reg		id_MemWr     ;
reg [31:0]	id_SignExtImm;
reg [31:0]	id_ZeroExtImm;
reg [1:0]	ALUSrcSel    ;
reg [31:0]	SignExtImm   ;
reg             BranchTaken_q;
reg             clear_q      ;
reg [31:0]	rf_mem[0:31] ;

	//---------------------------
	//  Wire Assignments
	//---------------------------
wire[31:0]      rf_zero = rf_mem[00];
wire[31:0]      rf_at   = rf_mem[01];
wire[31:0]      rf_v0   = rf_mem[02];
wire[31:0]      rf_v1   = rf_mem[03];
wire[31:0]      rf_a0   = rf_mem[04];
wire[31:0]      rf_a1   = rf_mem[05];
wire[31:0]      rf_a2   = rf_mem[06];
wire[31:0]      rf_a3   = rf_mem[07];
wire[31:0]      rf_t0   = rf_mem[08];
wire[31:0]      rf_t1   = rf_mem[09];

wire[31:0]      rf_t2   = rf_mem[10];
wire[31:0]      rf_t3   = rf_mem[11];
wire[31:0]      rf_t4   = rf_mem[12];
wire[31:0]      rf_t5   = rf_mem[13];
wire[31:0]      rf_t6   = rf_mem[14];
wire[31:0]      rf_t7   = rf_mem[15];
wire[31:0]      rf_s0   = rf_mem[16];
wire[31:0]      rf_s1   = rf_mem[17];
wire[31:0]      rf_s2   = rf_mem[18];
wire[31:0]      rf_s3   = rf_mem[19];

wire[31:0]      rf_s4   = rf_mem[20];
wire[31:0]      rf_s5   = rf_mem[21];
wire[31:0]      rf_s6   = rf_mem[22];
wire[31:0]      rf_s7   = rf_mem[23];
wire[31:0]      rf_t8   = rf_mem[24];
wire[31:0]      rf_t9   = rf_mem[25];
wire[31:0]      rf_k0   = rf_mem[26];
wire[31:0]      rf_k1   = rf_mem[27];
wire[31:0]      rf_gp   = rf_mem[28];
wire[31:0]      rf_sp   = rf_mem[29];

wire[31:0]      rf_fp   = rf_mem[30];
wire[31:0]      rf_ra   = rf_mem[31];

wire[31:0]	RFOutA;
wire[31:0]	RFOutB;
wire 		LwForwardRS;
wire		LwForwardRT;
wire		stall1;
wire		stall2;
wire            stall3;
wire 		BranchInstr;
wire 		JumpRegInstr;
wire            JumpLnkInstr;
wire		JInstr;
wire            BranchTaken;

	//--------------------------
	// Wire Re-Direction
	//--------------------------
wire [5:0]	ALUOp    = if_instr[5:0]  ;
wire [4:0]	SHF      = if_instr[10:6] ;
wire [4:0]	RD       = if_instr[15:11];
wire [4:0]	RT       = (JumpLnkInstr) ? 31 : if_instr[20:16];
wire [4:0] 	RS       = if_instr[25:21];
wire [5:0]	OpCode   = if_instr[31:26];
wire [15:0]	Imm      = if_instr[15:0] ;

wire 		RegDestSel = RFormat;
wire		MemRegSel  = MemRd;
assign		if_RFOutA = RFOutA;

wire [31:0]	ZeroExtImm = {16'b0,Imm[15:0]};


	//--------------------------
	//   Sign Extend
	//--------------------------
 always @(Imm)
 	begin
	SignExtImm[15:0] = Imm[15:0];

	for (j=16;j<=31;j=j+1)
	     SignExtImm[j] = Imm[15];
     	end

	
	//--------------------------
	//	Format Decode
	//--------------------------

  always @(OpCode)
	  begin
	  RFormat = 0;
	  JFormat = 0;
	  FFormat = 0;
	  IFormat = 0;
	  
	  casex (OpCode)
		  6'b00_0000: RFormat = 1;
		  6'b00_001x: JFormat = 1;
		  6'b01_00xx: FFormat = 1;
		  default   : IFormat = 1;
	  endcase
	  end


	  //-------------------------
	  //  ALU Source Operand B
	  //-------------------------

 always @(IFormat or RFormat or ALUOp or OpCode)
	 if (IFormat)
		 case (OpCode)
			 `ANDI,
			 `ORI,
			 `LUI : ALUSrcSel = 2'b10;
		      default : ALUSrcSel = 2'b01;
		 endcase
	else
		ALUSrcSel = 2'b00;
			 
		 
	  
 
	  //-----------------------
	  //	Memory Access
	  //-----------------------
	  //
 always @(OpCode)
	case (OpCode)
		`LBU,
		`LHU,
		`LW : begin
		      MemRd = 1;
		      MemWr = 0;
	      	      end
		`SB,
		`SH,
		`SW : begin
		      MemWr = 1;
		      MemRd = 0;
	              end

	     default: begin
		      MemRd = 0;
		      MemWr = 0;
	      	      end
	endcase




	//----------------------------
	//	Branch Decision Unit
	//----------------------------
 branch_unit branch (
		.RFOutA		(RFOutA),
		.RFOutB		(RFOutB),
		.id_ALUOut	(id_ALUOut),
		.ex_ALUOut	(ex_ALUOut),
		.wr_Data	(wr_Data),
		.OpCode		(OpCode),
		.ALUOp		(ALUOp),
		.ex_MemRd	(ex_MemRd),
		.ex_RegDest	(ex_RegDest),
		.id_RegDest	(id_RegDest),
		.wr_RegDest	(wr_RegDest),
		.ex_RegWriteSel (ex_RegWriteSel),
		.id_RegWriteSel (id_RegWriteSel),
		.wr_RegWriteSel (wr_RegWriteSel),
		.RS		(RS),
		.RT		(RT),
		
		.if_PCSrcSel	(if_PCSrcSel),
		.JBInstr	(JBInstr),
		.BranchInstr  	(BranchInstr),
		.JumpRegInstr	(JumpRegInstr),
		.JumpLnkInstr   (JumpLnkInstr),
		.BranchTaken    (BranchTaken)
		);
	
	//--------------------------
	//	RegWriteSel 
	//
	//Register file write enable
	//--------------------------
wire 	RegWriteEn = !(MemWr || JBInstr) || JumpLnkInstr; 


	//--------------------------
	//	RegDest
	//
	// If JAL, write to regfile[31]
	//--------------------------
wire [4:0]  RegDest =  (RegDestSel)  ? RD : RT;

	//-------------------------
	//	Register File
	//-------------------------
 
 always @(posedge clock)
	if (reset)
	    for (i=0;i<=31;i=i+1)
		    rf_mem[i] = 0;
	else
	   if (wr_RegWriteSel)
	       rf_mem[wr_RegDest] = wr_Data;

 assign       
	 RFOutA = (LwForwardRS) ? wr_Data : rf_mem[RS],

 	 RFOutB = (JumpLnkInstr) ? if_PC + 4
	        : (LwForwardRT)  ? wr_Data 
		                 : rf_mem[RT];


	 //-----------------------
	 // Load-Use Hazard
	 //-----------------------
 assign
 	stall1 = id_MemRd && (id_RT == RS || id_RT == RT),
	stall2 =    ex_MemRd
       		&& (BranchInstr || JumpRegInstr)	
		&& (ex_RegDest == RS || ex_RegDest == RT),
	
	stall  = stall1 || stall2;

 assign
       	LwForwardRS = (wr_RegDest == RS) && wr_RegWriteSel,
       	LwForwardRT = (wr_RegDest == RT) && wr_RegWriteSel;

 
 wire	clear = BranchTaken && !BranchTaken_q;

	 
	//------------------------
	// Output of Decode Stage
	//------------------------
  
 always @(posedge clock)
       if (reset)
          begin
          id_ALUOp     <= 0;
          id_SHF       <= 0;
          id_RD        <= 0;
          id_RT        <= 0;
          id_RS        <= 0;
          id_OpCode    <= 0;
          id_RegDestSel<= 0;
          id_ALUSrcSel <= 0;
          id_MemRegSel <= 0;
          id_RegWriteSel<= 0;
	  id_RFOutA    <= 0;
	  id_RFOutB    <= 0;
          id_PC        <= 0;
	  id_SignExtImm<= 0;
	  id_ZeroExtImm<= 0;
	  id_MemWr     <= 0;
	  id_MemRd     <= 0;
	  id_RegDest   <= 0;
          end
       else
	  begin
	  id_PC <= if_PC;
	  BranchTaken_q <= BranchTaken;
	  clear_q <= clear;
  
          if (hz_clear || stall) // || clear_q)
	     begin
             id_ALUOp     <= 0;
             id_SHF       <= 0;
             id_RD        <= 0;
             id_RT        <= 0;
             id_RS        <= 0;
             id_OpCode    <= 0;
             id_RegDestSel<= 0;
             id_ALUSrcSel <= 0;
             id_MemRegSel <= 0;
             id_RegWriteSel<= 0;
	     id_RFOutA    <= 0;
	     id_RFOutB    <= 0;
             id_SignExtImm<= 0;
	     id_ZeroExtImm<= 0;
	     id_MemWr     <= 0;
	     id_MemRd     <= 0;
	     id_RegDest   <= 0;
             end
	  else
	     begin
             id_ALUOp     <= ALUOp;
             id_SHF       <= SHF;
             id_RD        <= RD;
             id_RT        <= RT;
             id_RS        <= RS;
             id_OpCode    <= OpCode;
             id_RegDestSel<= RegDestSel;
             id_ALUSrcSel <= ALUSrcSel;
             id_MemRegSel <= MemRegSel;
             id_RegWriteSel<= RegWriteEn;
	     id_RFOutA    <= RFOutA;
	     id_RFOutB    <= RFOutB;
	     id_SignExtImm<= SignExtImm;
             id_ZeroExtImm<= ZeroExtImm;
	     id_MemWr     <= MemWr;
	     id_MemRd     <= MemRd;
	     id_RegDest   <= RegDest;
	     end
          end
	
endmodule       
