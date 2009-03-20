asm.pl

Gregg Tracton, 2005-mar-22

PURPOSE: convert a mini-MIPS assembly language program to the corresponding 32-bit
  hex instructions, one instruction per line.

USAGE:  perl asm.pl [OPTIONS] < hello.asm > hello.out
 [command-line only]
 OPTIONS: TBD

OVERVIEW
- a separate program (written by you) converts this script's output to 1) a
  test fixture or to 2) RAM BLOCK values to directly load onto hardware.
- punctuation is seen as white space: "add $1,$2(100)" = "add 1 2 100".
  [TODO: is punctuation needed if the arg order is fixed? think about sw & lw.]
- symbolic labels can be used for data or code so that you
  don't have to calc offsets yourself nor use numbers when names
  are easier.
- You can position code and data anywhere in 1 or in 2
  memories, eg, von Neumann or Harvard architectures.
  Two special labels embedded in your assembly code tell where the data
  and instruction segments start: label ISTART will be subtracted
  off any instruction reference (j/beq); label DSTART will be
  subtracted off any data reference (lui/sw/lw). If you use
  a number instead of a label, it will not be changed -- only labels.
  EXAMPLES:
  1) your 128 words of data is kept in a separate memory from the 128
     words of code (a Harvard architecture). Each bank starts with index 0:

      DATA 1
      DATA 2
      DATA 16777215
      DATA 4294967295
      ISTART=128:
      add 1 2 3

    --> you'll get 128 words of data, then 1 word of instruction (or
    however many instructions you typed). You might want to end the
    program with a label like "END=256:" to guarantee that all 128
    code words are printed. Use the unix 'head' command to redirect
    the first 128 lines to the data memory and the last 128 lines to
    the code memory.

  2) there's a memory-mapped region of 32 words, then a data region of 16
     words, then the code

      MEMMAP:
      DSTART=32:
      DATA 33333
      DATA 65535
      DATA 254,255,254,254
      ISTART=48:
      add 1 2 3
      LOOPER:
      sub 2 3 4
      j LOOPER
      [...]

    --> you'll get 32 words of 0 followed by 33333, 65535, 4278189822
    and 13 more 0 words (a total of 16 words), then the code. The jump
    will set the PC to 1, not to 49, because ISTART is 48 (and 49-48
    is what's used), and that target refers to the sub
    instruction. You can use the MEMMAP label as an offset in a sw
    instruciton to access the first word of the memory-mapped
    region. Cute, huh?

  3) you integrated the address spaces of your data & instruction mem's
     together and specified no special regions. Don't use ISTART or
     DSTART as they both default to 0. Be careful, though, not to
     allow any code to run off the end and execute data words.


COMMANDS
- syntax: OP $rs $rt $rd/offset
- comments are allowed after each line, eg:
    addi $1,$2,100  # r1 <- table[LUTindex]
- comments by themselves (without a command) are ignored as
  unrecognized commands
- #stop is a special comment that marks end of input; you can stash
  unused code/data after that

  COMMAND                              SAMPLES
  add                                  add 1 2 3
  sub                                  sub 1 2 3
  and                                  and 1 2 3
  or                                   or  1 2 3
  slt                                  slt 1 2 3

  addi                                 addi 1 2 100
  andi                                 andi 1 2 100
  ori                                  ori 1 2 100
  slti                                 slti 1 2 100

  sw                                   sw 1 2 100
  lw                                   lw 1 2 100
  lui                                  lui 0 1 100

  label[=###]:                         endloop:
                                       endloop=32:
  beq {label | ####}                   beq 1 2 endloop
  j {label | ####}                     j begloop
                                       j 24

  #stop                                #stop
  DATA {#### | ###,###,###,###}        DATA 65535
                                       DATA 192,168,0,1
                                       DATA 192/168/0/1


- arbitrary words can be embedded and referenced symbolicly as either
  code or data, that is, the offset to the data or index of the code
  will be inserted into the referencing instruction:

  - as 32-bit words, use format: DATA 65535
  - as  8-bit bytes, use format: DATA 192,168,0,255

  Note that there's no "nop" or "halt" instructions. If you implement
  these on your hardware you can use "DATA ###" to generate an
  arbitrary *instruction* that is inserted into the code stream, eg:

   lw 1 2 100
   DATA 0
   lw 2 4 100

  The DATA emits the 0 word which your machine can implement as a nop.

  Another nifty use for DATA is to implement a LED command that
  changes the value seen on the LED to an immediate 4-bit value. Say
  you use the unused opcode '1' for this, then the code to display
  the number 9 would be:

   DATA 67108873

  which is 32'b000001_00000_00000_0000000000001001
           1=opcode               9=led value

- the script will range-test each value; all values non-negative, decimal
- "LABEL:" feature makes jumps easier to code.
  labels must be non-numeric.
  use "j L1" and "L1:" as corresponding reference and target offsets,
  and the script will calculate the actual offsets and insert those into
  the referencing instructions.
  - ISTART and DSTART are special labels, see above
  - when you use the "LABEL=###:" form, nop instructions will be inserted
    into your code to fill it out to the desired offset. Change this line
    in the script:
      $nop = 0;
    to your own NOP opcode.
- jump/branch can use number directly, if desired.

TO DO
- adjust offsets of code and data so that they're byte-aligned to
  word-aligned, via a switch. This will be done via the $addrDiv and
  $offsetDiv settings.
- parse ARGV
- print label on right line when "LABEL=###" is used
- allow alternate order of operands, and use "$1,$2(100)" syntax as
  it's easier to see mistakes
- detect if there's actually a jump/branch inst at the label
- command substitution:
  - nop        ->  addi $1,$0,0
  - sw [,...]  ->  sw [...]; nop
- detect comments in DATA and LABEL lines.


