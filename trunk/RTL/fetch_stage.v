//---------------------------------------------------------
//		Instruction Fetch Stage
//
//
// Author: Babak Azimi
// Class: EG-EE  597 Senior Project
//
//---------------------------------------------------------


module fetch_stage (	clock, 
			reset, 
			if_instr, 
			id_PC,
			if_PCSrcSel,
			if_RFOutA,
			stall,
		
			if_PC);


input		clock;
input		reset;
input  [31:0]	if_instr;
input  [31:0]	id_PC;
input  [2:0]	if_PCSrcSel;
input  [31:0]	if_RFOutA;
input		stall;

output [31:0]	if_PC;

integer i;
	//--------------------------
	//   Register Declarations
	//--------------------------
reg  [31:0]	PCMuxOut;
reg  [31:0]	PCReg;
reg  [31:0]	BranchAddr;
reg  [31:0]	AddrSignExtend;

	//--------------------------
	//  Wire Declarations
	//--------------------------
wire [15:0] 	ImmAddr     = if_instr[15:0];
wire [25:0]	JAddr       = if_instr[25:0];
wire [31:0] 	JumpAddr    = {id_PC[31:28],JAddr,2'b00};
assign		if_PC       = PCReg;

 	//-----------------------
	// Branch Address
	//-----------------------
 always @(id_PC or ImmAddr)
 	 begin
	 AddrSignExtend[17:0] = {ImmAddr,2'b00};

	 for (i=18;i<=31;i=i+1)
		 AddrSignExtend[i] = ImmAddr[15];

	 BranchAddr = id_PC + 4 + AddrSignExtend;
 	 end

	//-----------------------
	// PC MUX
	// 0: PC = PC + 4
	// 1: PC = BranchAddr
	// 2: PC = JumpAddr
	// 3: PC = rf_mem[RS]
	//-----------------------
 always @(if_PCSrcSel or  BranchAddr or JumpAddr or PCReg or if_RFOutA)
	  case (if_PCSrcSel)
 		  2'b00: PCMuxOut = PCReg + 4;
		  2'b01: PCMuxOut = BranchAddr;
		  2'b10: PCMuxOut = JumpAddr;
		  3'b11: PCMuxOut = if_RFOutA;
		default: PCMuxOut = PCReg;
	  endcase
	  

	//---------------------
	// PC Register
	//---------------------
 always @(posedge clock)
	if (reset)
	    PCReg <= 0;
	else
	   if (!stall)
	       PCReg <= PCMuxOut;
 

endmodule       
