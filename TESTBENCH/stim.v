//-------------------------------------------------------------
//			STIMULUS FILE
//
// Description: This module contains the tasks and functions
// necessary to load the instruction memory and initialize the
// clock and reset.
//
// It also contains an instruction monitoring function for debug
// purposes. Plus memory loaders for loading the memories with
// instructions from a specific file.
//-------------------------------------------------------------
// Author: Babak Azimi
// Date: 12/29/05
//-------------------------------------------------------------

module stim ();

`define top		testbench
`define mips_top	`top.mips_top
`define imem		`top.instr_mem
`define dmem		`top.data_mem
`define ck		@(posedge `top.clock)
`define period		10

integer i,found_fsdb, fsdb;

	//--------------------------------------
	// task sys_init
	//
	// initialize the inputs
	// input:
	// 	none
	//--------------------------------------
 task sys_init;
	 begin
	 `top.reset = 1;
 	end
endtask

	//--------------------------------------
	//task sys_reset
	//
	// reset system after 'cycles'  cycle.
	//input:
	//	cycles: Number of cycles 
	//--------------------------------------
 task sys_reset;
	 
   input [31:0]	cycles;
	 
	 begin
	`top.reset = 1;
	repeat (cycles) `ck;
	`top.reset = 0;
	end
endtask


	//--------------------------------------------
	// task load_instr_mem
	//
	// load the instruction memory with text code
	// input:
	// 	file: file location in ASCII format
	//---------------------------------------------
 task load_instr_mem;
	 
   input [160*2:0] 	file;

	 begin
	 $readmemh (file, `imem.mem);
 	 end
	 
 endtask

 task load_data_mem;

     input[160*2:0]  file;

     begin
     $readmemh (file, `dmem.mem);
     end
endtask

 	//---------------------------------------------
	// task read_instr_mem
	//
	// read the contents of the instr memory.
	// input: 
	// 	start_addr - start addr of memoy dump
	// 	end_addr   - end addr of memory dump
	//---------------------------------------------
 task read_instr_mem;
   
  input [31:0]	start_addr;
  input [13:0]	end_addr;
  
  integer i,found_fsdb, fsdb;
  
	begin
	for (i=start_addr; i<=end_addr; i=i+1)
	    $display ("%d \t %h", i, `imem.mem[i]);
	end
endtask

	//--------------------------------------------
	// Init: start clock
	//--------------------------------------------
 initial
	 begin
	 `top.clock = 0;
	 forever #(`period/2) `top.clock = !`top.clock;
 	 end



	 //--------------------------------------------
	 // Main
	 //--------------------------------------------
 initial
 	begin
	found_fsdb = $value$plusargs ("fsdb=%d", fsdb);

	if (found_fsdb)
	   begin
	   $fsdbDumpfile("mips.fsdb");
	   $fsdbDumpvars;
	   end

	//$dumpfile("mips.vcd");
	//$dumpvars;
	//$dumpall;
	sys_reset (100);
	load_instr_mem("../CODE/quicksort.text.hex");
	load_data_mem ("../CODE/quicksort.data.hex");
	read_instr_mem(0,10);

	repeat (10000) `ck;
	$stop;
	end

endmodule	
