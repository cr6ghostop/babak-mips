//-------------------------------------------------
// 	Branch Unit Moodule
//
// Description: This module contains the logic to 
//  control the branch instruction. It also contains
//  the forwarding logic for branches.
//--------------------------------------------------
// Author: Babak Azimi
// Date: 1/2/06
//--------------------------------------------------
module branch_unit (
		RFOutA,
		RFOutB,
		id_ALUOut,
		ex_ALUOut,
		wr_Data,
		OpCode,
		ALUOp,
		ex_MemRd,
		ex_RegDest,
		id_RegDest,
		wr_RegDest,
		ex_RegWriteSel,
		id_RegWriteSel,
		wr_RegWriteSel,
		RS,
		RT,
		
		if_PCSrcSel,      
 		BranchInstr,
		JumpRegInstr,
		JumpLnkInstr,
		JBInstr,
		BranchTaken
		);

input [31:0]	RFOutA;
input [31:0]	RFOutB;
input [31:0]	id_ALUOut;
input [31:0]	ex_ALUOut;
input [31:0]	wr_Data;
input [5:0]	OpCode;
input [5:0]	ALUOp;
input		ex_MemRd;
input [4:0]	ex_RegDest;
input [4:0]	id_RegDest;
input [4:0]	wr_RegDest;
input		ex_RegWriteSel;
input		id_RegWriteSel;
input		wr_RegWriteSel;
input [4:0]	RS;
input [4:0]	RT;

output [2:0]	if_PCSrcSel;   
output		BranchInstr;
output		JumpRegInstr;  		
output          JumpLnkInstr;
output		JBInstr;
output          BranchTaken;

	//-----------------------------
	// Definitions
	//-----------------------------
`define aBEQ	6'h04
`define aBNE	6'h05	
`define aBGEZ  	6'h01	
`define aBGTZ	6'h07	
`define aBLEZ	6'h06	
`define aBLTZ	6'h01	
`define aJR	6'h00	
`define aJMP	6'h02	
`define aJAL	6'h03	
`define BEQ	(OpCode == `aBEQ)
`define BNE	(OpCode == `aBNE)
`define BGEZ  	(OpCode == `aBGEZ && RT==1)
`define BGTZ	(OpCode == `aBGTZ && RT==0)
`define BLEZ	(OpCode == `aBLEZ && RT==0)
`define BLTZ	(OpCode == `aBLTZ && RT==0)
`define JR	(OpCode == `aJR	 && ALUOp == 6'h8)
`define JMP	(OpCode == `aJMP)
`define JAL	(OpCode == `aJAL)

	//-----------------------------
	// Wire Declaration
	//-----------------------------
wire [1:0]	BForwardA;
wire [1:0]	BForwardB;

	//-----------------------------
	// Register Declaration
	//-----------------------------
reg [31:0]	BRFOutA;
reg [31:0]	BRFOutB;
reg		CondTrue;

	//--------------------------
	//	Branch Decoding
	//--------------------------
assign 	BranchInstr  = `BEQ || `BNE || `BGEZ || `BGTZ || `BLEZ || `BLTZ;
wire 	JumpInstr    = `JMP;
assign 	JumpLnkInstr = `JAL;
assign 	JumpRegInstr = `JR;

wire 	JInstr  = JumpInstr || JumpLnkInstr || JumpRegInstr;
assign	JBInstr = BranchInstr || JInstr;
wire  	RegDepInstr = BranchInstr || JumpRegInstr;
assign  BranchTaken = JBInstr && CondTrue;


	//-----------------------------
	// Forwarding Muxes
	//-----------------------------
 
 always @(RFOutA or id_ALUOut or ex_ALUOut or wr_Data or BForwardA)
	 case (BForwardA)
		 0: BRFOutA = RFOutA;
		 1: BRFOutA = id_ALUOut;
		 2: BRFOutA = ex_ALUOut;
		 3: BRFOutA = wr_Data;
	 endcase
	 
  always @(RFOutB or id_ALUOut or ex_ALUOut or wr_Data or BForwardB)
	 case (BForwardB)
		 0: BRFOutB = RFOutB;
		 1: BRFOutB = id_ALUOut;
		 2: BRFOutB = ex_ALUOut;
		 3: BRFOutB = wr_Data;
	 endcase

	//----------------------------
	// Forwarding Logic
	//----------------------------
 assign 
    BForwardA = (RegDepInstr && id_RegWriteSel && (id_RegDest == RS))              ? 1
              : (RegDepInstr && ex_RegWriteSel && (ex_RegDest == RS) && !ex_MemRd) ? 2
	      : (RegDepInstr && wr_RegWriteSel && (wr_RegDest == RS))              ? 3
		  							           : 0;
 assign 
    BForwardB = (RegDepInstr && id_RegWriteSel && (id_RegDest == RT))              ? 1
              : (RegDepInstr && ex_RegWriteSel && (ex_RegDest == RT) && !ex_MemRd) ? 2
	      : (RegDepInstr && wr_RegWriteSel && (wr_RegDest == RT))              ? 3
		  							           : 0;

	//--------------------------
	// Branch Condition Logic 
	//--------------------------
 
 always @(OpCode or ALUOp or RT or BRFOutA or BRFOutB)
	case (OpCode)
	      `aBEQ  : CondTrue = (BRFOutA == BRFOutB); 
              `aBNE  : CondTrue = (BRFOutA != BRFOutB);
	      `aBGEZ : begin
		       CondTrue = (BRFOutA >= 0) && RT == 1; //BGEZ
		       CondTrue = (BRFOutA <  0) && RT == 0; //BLTZ
	       	       end
              `aBGTZ : CondTrue = (BRFOutA >  0) && RT == 0;
              `aBLEZ : CondTrue = (BRFOutA <= 0) && RT == 0;
              `aJR   : CondTrue = ALUOp == 6'h08;
              `aJMP  : CondTrue = 1;
              `aJAL  : CondTrue = 1;
	      default: CondTrue = 0;
        endcase


 assign
	if_PCSrcSel = (BranchInstr  && CondTrue) ? 1
      		    : (JumpInstr    && CondTrue) ? 2
		    : (JumpLnkInstr && CondTrue) ? 2
	    	    : (JumpRegInstr && CondTrue) ? 3
					         : 0;	    


endmodule
	
