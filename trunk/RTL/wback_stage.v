//---------------------------------------------------------
//		Memory Stage
//
//
// Author: Babak Azimi
// Class: EG-EE  597 Senior Project
//
//---------------------------------------------------------


module wback_stage (	 
			
		me_ExtMemRdData,
		me_MemRegSel,
		me_RegWriteSel,
		me_RegDest,
		me_ByData,

		wr_RegDest,
		wr_Data,
		wr_RegWriteSel	
		);
	
                
input  [31:0]	me_ExtMemRdData;
input 		me_MemRegSel;
input 		me_RegWriteSel;
input  [4:0]	me_RegDest;
input  [31:0]	me_ByData;

output [4:0]	wr_RegDest;
output [31:0]	wr_Data;
output 		wr_RegWriteSel;

			

	//--------------------------
	//  Wire Declarations
	//--------------------------

 assign	  wr_Data = (me_MemRegSel) ? me_ExtMemRdData
 				   : me_ByData;

 assign   wr_RegDest     = me_RegDest;
 assign   wr_RegWriteSel = me_RegWriteSel;

endmodule       
