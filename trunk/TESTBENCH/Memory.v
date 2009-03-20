
module Memory ( clock,
		reset,
		Addr,
		MemEn,
		MemWr,
		WData,
		
		RdData
	      );

`define MEMSIZE 1000000*4

input		clock;
input		reset;
input [31:0]	Addr;
input		MemEn;
input		MemWr;
input [31:0]	WData;

output [31:0]	RdData;


	//-----------------------
	// Register Declaration
	//-----------------------
 reg [31:0]	RdData;
 reg [31:0]	mem[0:`MEMSIZE];	

	//-----------------------
	// Wire Declaration
	//------------------------
 wire [31:0]	MemAddr = {2'b0,Addr[31:2]};
 
 always @(posedge clock)

	if (reset)
	   RdData <= 0;

	else
	   begin
	   if (MemEn && !MemWr)
	       RdData <= mem[MemAddr];
	   
	   if (MemEn &&  MemWr)
	       mem[MemAddr] <= WData;
	   end
   	 

	 //------------------------
	 // Mem Error Detection
	 //------------------------  
 always @(posedge clock)
	 if(~reset)
	   begin
	   if (MemWr && MemEn && (WData == 'hx)) 
	       $display ("%s: MEM-ERROR- Writing X's into Address %h!!!", $stime, Addr);
	   end



endmodule



