//---------------------------------------------------------
//		Memory Stage
//
//
// Author: Babak Azimi
// Class: EG-EE  597 Senior Project
//
//---------------------------------------------------------


module memory_stage (	 
			
		clock,
		reset,
		ex_MemWr,
		ex_MemRd,
		ex_ALUOut,
		ex_OpB_pre,
		ex_RegDest,
		ex_MemRegSel,
		ex_RegWriteSel,

		me_ExtMemAddr,
		me_ExtMemWrData,
		me_ExtMemWrEn,
		me_ExtMemRdEn,
		me_MemRegSel,
		me_RegWriteSel,
		me_RegDest,
		me_ByData        
		);
	
input  		clock;
input  		reset;
input  		ex_MemWr;
input  		ex_MemRd;
input  [31:0]	ex_ALUOut;
input  [31:0]	ex_OpB_pre;
input  [4:0]	ex_RegDest;
input  		ex_MemRegSel;
input		ex_RegWriteSel;
                
output [31:0]	me_ExtMemAddr;
output [31:0]	me_ExtMemWrData;
output 		me_ExtMemWrEn;
output 		me_ExtMemRdEn;
output 		me_MemRegSel;
output 		me_RegWriteSel;
output [4:0]	me_RegDest;
output [31:0]	me_ByData;

			
	//--------------------------
	//   Register Declarations
	//--------------------------

reg 		me_MemRegSel;
reg 		me_RegWriteSel;
reg [4:0]	me_RegDest;
reg [31:0]	me_ByData;
	

	//--------------------------
	//  Wire Declarations
	//--------------------------

assign		me_ExtMemAddr   = ex_ALUOut;
assign 		me_ExtMemWrData = ex_OpB_pre;
assign		me_ExtMemWrEn   = ex_MemWr;
assign		me_ExtMemRdEn   = ex_MemRd;


 always @(posedge clock)
	 if (reset)
	    begin
	    me_MemRegSel    <= 0;
            me_RegWriteSel  <= 0;
            me_RegDest      <= 0;
	    me_ByData       <= 0;            
  	    end
	 else
	    begin
	    me_MemRegSel    <= ex_MemRegSel;
            me_RegWriteSel  <= ex_RegWriteSel;
            me_RegDest      <= ex_RegDest;
            me_ByData       <= ex_ALUOut; 
	    end

endmodule       
