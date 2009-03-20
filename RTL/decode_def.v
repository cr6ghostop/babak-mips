//---------------------------------------------------------
//		Decode Stage Definitions
//
//
// Author: Babak Azimi
// Class: EG-EE  597 Senior Project
//
//---------------------------------------------------------
//
		//R-Formats
wire 
	ADD   = (id_Opcode == 0) && (id_ALUOp == 6'h20),
	ADDU  = (id_Opcode == 0) && (id_ALUOp == 6'h21),
	AND   = (id_Opcode == 0) && (id_ALUOp == 6'h24),
	JR    = (id_Opcode == 0) && (id_ALUOp == 6'h08),
	NOR   = (id_Opcode == 0) && (id_ALUOp == 6'h27),
	OR    = (id_Opcode == 0) && (id_ALUOp == 6'h25),
	SLT   = (id_Opcode == 0) && (id_ALUOp == 6'h2A),
	SLTU  = (id_Opcode == 0) && (id_ALUOp == 6'h2B),
	SLL   = (id_Opcode == 0) && (id_ALUOp == 6'h00),
	SRL   = (id_Opcode == 0) && (id_ALUOp == 6'h02),
	SUB   = (id_Opcode == 0) && (id_ALUOp == 6'h22),
	SUBU  = (id_Opcode == 0) && (id_ALUOp == 6'h23);

		//I-Formats
wire
	ADDI  = (id_Opcode == 6'h8),
	ADDIU = (id_Opcode == 6'h9),
	ANDI  = (id_Opcode == 6'hc),
	BEQ   = (id_Opcode == 6'h4),
	BNE   = (id_Opcode == 6'h5),
	LBU   = (id_Opcode == 6'h0) && (id_ALUOp == 
