//---------------------------------------------------------
//		Execute Stage
//
//
// Author: Babak Azimi
// Class: EG-EE  597 Senior Project
//
//---------------------------------------------------------

module ALU (	OpA,
		OpB,
		ALUOp,
		OpCode,
		ShiftA,

		ALUOut
	  );

input [31:0]	OpA;
input [31:0]	OpB;
input [5:0]	ALUOp;
input [5:0]	OpCode;
input [4:0]	ShiftA;

output [31:0]	ALUOut;


	//------------------------
	// Definitions
	//------------------------

`define RF      6'h00
`define DNT	6'hxx
`define ADD	{`RF,6'h20}
`define ADDI	{6'h08,`DNT}
`define ADDIU	{6'h09,`DNT}
`define ADDU	{`RF,6'h21}
`define AND     {`RF,6'h24}
`define ANDI	{6'h0C,`DNT}
`define LW	{6'h23,`DNT}
`define NOR	{`RF,6'h27}
`define OR	{`RF,6'h25}
`define LUI     {6'h0F,`DNT}
`define ORI	{6'h0D,`DNT}
`define SLT	{`RF,6'h2A}
`define SLTI    {6'h0A,`DNT}
`define SLTIU   {6'h0B,`DNT}
`define SLTU    {`RF,6'h2B}
`define SLL 	{`RF,6'h00}
`define SRL	{`RF,6'h02}
`define SW	{6'h2B,`DNT}
`define SUB	{`RF,6'h22}
`define SUBU	{`RF,6'h23}


	//-------------------------
	// Register Declaration
	//-------------------------
 reg [32:0]	Xout;

    always @(OpA or OpB or ALUOp or OpCode)
	    casex ({OpCode, ALUOp})
		    `ADD  : Xout = OpA + OpB;
		    `ADDI : Xout = OpA + OpB;
		    `ADDIU: Xout = {1'b0, OpA + OpB};
		    `ADDU : Xout = {1'b0, OpA + OpB};
		    `AND  : Xout = {1'b0, OpA & OpB};
		    `ANDI : Xout = {1'b0, OpA & OpB};
		    `LW   : Xout = OpA + OpB;
		    `NOR  : Xout = {1'b0, ~(OpA | OpB)};
		    `OR   : Xout = {1'b0,  (OpA | OpB)};
		    `ORI  : Xout = {1'b0,  (OpA | OpB)};
		    `SLT  : Xout = (OpA < OpB) ? 32'h1 : 32'h0;
		    `SLTI : Xout = (OpA < OpB) ? 32'h1 : 32'h0;
		    `SLTIU: Xout = (OpA < OpB) ? 32'h1 : 32'h0;
		    `SLTU : Xout = (OpA < OpB) ? 32'h1 : 32'h0;
		    `SLL  : Xout = OpA << ShiftA;
		    `SRL  : Xout = OpA >> ShiftA;
		    `SW   : Xout = OpA + OpB;
		    `SUB  : Xout = OpA - OpB;
		    `SUBU : Xout = {1'b0, (OpA - OpB)};
		    `LUI  : Xout = {OpB[15:0],16'b0};
		   default: Xout = {1'b0,OpB}; 
		    
	    endcase
	    
 assign ALUOut = Xout[31:0];
 
endmodule
