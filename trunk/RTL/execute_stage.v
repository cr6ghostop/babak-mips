//---------------------------------------------------------
//		Execute Stage
//
//
// Author: Babak Azimi
// Class: EG-EE  597 Senior Project
//
//---------------------------------------------------------


module execute_stage (	clock, 
			reset, 
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
			me_Data,
			wr_Data,
			me_RegDest,
			me_RegWriteSel,

			ex_MemWr,
                        ex_MemRd,
                        ex_ALUOut,
                        id_ALUOut,
                        ex_OpB_pre,
                        ex_RegDest,
                        ex_MemRegSel,
                        ex_RegWriteSel
		     );


input		clock;
input		reset;
input [5:0]	id_ALUOp;
input [5:0]	id_OpCode;
input [1:0] 	id_ALUSrcSel;
input [4:0]	id_SHF;
input [4:0]	id_RT;
input [4:0]	id_RS;
input [4:0]	id_RD;
input		id_RegDestSel;
input		id_MemRegSel;
input		id_RegWriteSel;
input [31:0]	id_RFOutA;
input [31:0]	id_RFOutB;
input [31:0]	id_SignExtImm;
input [31:0]	id_ZeroExtImm;
input [31:0]	me_Data;
input [31:0]	wr_Data;
input [4:0]	me_RegDest;
input		me_RegWriteSel;
input		id_MemWr;
input		id_MemRd;


output 		ex_MemWr;
output 		ex_MemRd;
output [31:0]	ex_ALUOut;
output [31:0]	id_ALUOut;
output [31:0]	ex_OpB_pre;
output [4:0]	ex_RegDest;
output 		ex_MemRegSel;
output 		ex_RegWriteSel;





	//---------------------------------
	//	Register Declarations
	//---------------------------------
reg  [31:0]	OpA;
reg  [31:0]	OpB;
reg  [31:0]	OpB_pre;
reg		ex_MemWr;
reg		ex_MemRd;
reg  [31:0]	ex_ALUOut;
reg  [31:0]	ex_OpB_pre;
reg  [4:0]	ex_RegDest;
reg		ex_MemRegSel;
reg		ex_RegWriteSel;

 

	//--------------------------------
	//	Wire Declaration
	//---------------------------------
wire [31:0]	ALUOut;
wire [1:0]      ForwardA;
wire [1:0]      ForwardB;
assign		id_ALUOut = ALUOut;


	//--------------------------------
	//	ALU Operands MUXes
	//--------------------------------


 always @(ForwardA or ex_ALUOut or wr_Data or id_RFOutA)
	 case (ForwardA)
		2'b00: OpA = id_RFOutA;
	        2'b01: OpA = ex_ALUOut;
		2'b10: OpA = wr_Data;
	      default: OpA = id_RFOutA;
        endcase

 always @(ForwardB or ex_ALUOut or wr_Data or id_RFOutB)
 	case (ForwardB)
       		2'b00: OpB_pre = id_RFOutB;
		2'b01: OpB_pre = ex_ALUOut;
		2'b10: OpB_pre = wr_Data;
	     default : OpB_pre = id_RFOutB;
         endcase
	
 
 always @(id_ALUSrcSel or OpB_pre or id_SignExtImm or id_ZeroExtImm)
	 case(id_ALUSrcSel)
		 2'b00: OpB = OpB_pre;
		 2'b01: OpB = id_SignExtImm;
		 2'b10: OpB = id_ZeroExtImm;
	     default  : OpB = OpB_pre;
          endcase

	 //-----------------------
	 //	ALU Block
	 //----------------------- 

 ALU ALU (
	 .OpA	(OpA),
	 .OpB	(OpB),
	 .ALUOp (id_ALUOp),
	 .OpCode(id_OpCode),
	 .ShiftA(id_SHF),

	 .ALUOut(ALUOut)
 	 );


	//-------------------------
	//	RF Destination Mux
	//-------------------------
 
wire [4:0]  RegDest = (id_RegDestSel) ? id_RD : id_RT;
 

	//---------------------------------------
	//	Forwarding Unit
	//
	// ForwardA/B   00       01         10
	//          id_Reg  ex_ALUOut   wr_Data
	//
	//----------------------------------------
 
 assign ForwardA = (ex_RegWriteSel && (ex_RegDest == id_RS))   ? 2'b01
                 : (ex_RegWriteSel && (ex_RegDest == RegDest)) ? 2'b01
 		 : (me_RegWriteSel && (me_RegDest == id_RS))   ? 2'b10
		                                               : 2'b00;

 assign ForwardB = (ex_RegWriteSel && (ex_RegDest == id_RT)) ? 2'b01
 		 : (me_RegWriteSel && (me_RegDest == id_RT)) ? 2'b10
		                                             : 2'b00;

		 

	//----------------------------
	//	PipeLine to Next Stage
	//----------------------------

 always @(posedge clock)
	 if (reset)
	     begin
	     ex_MemWr       <= 0;
	     ex_MemRd       <= 0;
	     ex_ALUOut      <= 0;
	     ex_OpB_pre     <= 0;
	     ex_RegDest     <= 0;
	     ex_MemRegSel   <= 0;
	     ex_RegWriteSel <= 0;
             end
	 else
 	     begin
 	     ex_MemWr       <= id_MemWr;
	     ex_MemRd       <= id_MemRd;
	     ex_ALUOut	    <= ALUOut;
	     ex_OpB_pre     <= OpB_pre;
	     ex_RegDest     <= RegDest;
	     ex_MemRegSel   <= id_MemRegSel;
	     ex_RegWriteSel <= id_RegWriteSel;
  	     end



 
endmodule       
