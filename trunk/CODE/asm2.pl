#! /bin/perl
# asm.pl - mini-MIPS 2-pass assembler for comp160.

## STATUS: working on data reference via LABEL.

#  usage:  perl asm.pl < hello.asm
# Author: Gregg Tracton, 2003-mar-23
# see README.txt for PURPOSE, SYNTAX, TODO, EXAMPLES
$version = "05-apr-2005";

####
# USAGE:
# TODO: parse args
#   -v (verbose) embeds comments into the translation.
#      ERRS are printed regardless of verbosity setting.
#   -a# divide each data address (offset) by # before putting
#      it in the instruction [1]
#   -o# divide each instruction index by # before putting
#      it in the instruction [4]

$verbose = 1;
$writeRAMB = 1;			# deposit the compiled bytes into 2 16-bit RAM blocks,
				# in a file called out.ramb, with comments showing the
				# program's text
$addrDiv = 1;			# TODO: data address divisor
$offsetDiv = 4;			# TODO: instruction index divisor
$nop = 0;			# the 32-bit code for the NOP instruction

# offset the code and data address spaces with these.
# Instead of placing the first instruction
# whereever it fell in the sequence
# of assembly statements, it will be placed at 0. ISTART=###:
# and DSTART=###: statements set values for these first statements.
$istart = 0;			# offset to first instruction
$dstart = 0;			# offset to first data

# some local restrictions on the MIPS ISA
$maxrs = 32;			# only 8 registers
$maxrt = 32;
$maxrd = 32;

####
# map each command name to (format, opcode, function).
# the function will only be used if opcode==0
%fmtOpFns = (
  'add'   => "R 0 32",		# add $1,$2,$3
  'sub'   => "R 0 34",
  'and'   => "R 0 36",
  'or'    => "R 0 37",
  'slt'   => "R 0 42",
  'addi'  => "I 8 0",		# addi $1,$2(100)
  'andi'  => "I 12 0",
  'ori'   => "I 13 0",
  'slti'  => "I 10 0",
  'sw'    => "I 43 0",
  'lw'    => "I 35 0",
  'beq'   => "I 4 0",
  'lui'   => "I 15 0",
  'j'     => "J 2 0",		# j 1000
);

####
# phase 1: translate text instructions to 32-bit opcodes
#
# - $cmd is accumulated until it's needed for an error message
#   or because $verbose is set

if ($verbose) {print "asm.pl $version\n*********************************************\n";
	       print "* STAGE 1: translate text to opcodes\n\n"}

if ($verbose) {print "Line   Offset Command\n"}

$offset = 0;
while (<>) {
  $line++;
  chomp;

  # split command into words at white space, ignoring punctuation
  @words = split (/[\s,\(\)\/]+/, $_);
  if ($words[0] eq '#') {next}	# skip comment lines - should ck each word for '#' & delete rest of line...
  $cmdText{$offset} .= " $_";	# labels are concat'd by instr @ same offset
  if ($words[0] eq "#stop") {last;}  # triggers next stage
  $cmd = sprintf("%.6d %.6d %s", $line, $offset, $_);
  if ($verbose) {print "$cmd"; $cmd = ""}
  chomp(@words);

  # if it's a "LABEL:" just stash current offset as the target.
  # if it's a "LABEL=802:", use the number as the target.
  # if it's a "ISTART..." label, set $istart.
  # if it's a "DSTART..." label, set $dstart.
  $wc = @words;
  if ($wc == 1 && $words[0] =~ /^([\w]+).*:$/) {
    $lab = $1;			# may be "LAB:" or "LAB=40:"
    if ($words[0] =~ /^[\w]+=([\d]+):$/) {
      $newOffset = $1;
      # insert NOPs to fill up space from offset to newOffset
      @nis = keys(%is);
      while ($#nis < ($newOffset - 1)) {
	if ($verbose) {print "\n   NOP offset=$offset"}
	$is{$offset++} = $nop;
	@nis = keys(%is);
      }
    }
    if ($lab eq "ISTART") {$istart = $offset}
    if ($lab eq "DSTART") {$dstart = $offset}
    $cmd .= "\n   LABEL: symbol=$lab target=$offset\n";
    if ($verbose) {print "$cmd"; $cmd = ""}
    $labels{$lab} = $offset;
    next;			# offset should NOT be incremented here
  }

  # if it's a DATA line, fill curr instruction with data, which
  # can have form "DATA 32bitValue" or "DATA 8bit,8bit,8bit,8bit"
  $gotData = 0;
  $wc = @words;
  if (($wc == 2 || $wc == 5) && $words[0] eq "DATA") {
    @dataVals = @words[1 .. $wc-1];
    $dv = @dataVals;
    if ($dv == 1) {
      if ($dataVals[0] > 4294967295)  {print "$cmd\n   *** ERR: data val ($dataVals[0]) > 4294967295.\n"; $cmd = ""}
      $i = $dataVals[0];
      $gotData = 1;
    }
    if ($dv == 4) {
      if ($dataVals[0] > 255)  {print "$cmd\n   *** ERR: data val 1 ($dataVals[0]) > 255\n"; $cmd = ""}
      if ($dataVals[1] > 255)  {print "$cmd\n   *** ERR: data val 2 ($dataVals[1]) > 255\n"; $cmd = ""}
      if ($dataVals[2] > 255)  {print "$cmd\n   *** ERR: data val 3 ($dataVals[2]) > 255\n"; $cmd = ""}
      if ($dataVals[3] > 255)  {print "$cmd\n   *** ERR: data val 4 ($dataVals[3]) > 255\n"; $cmd = ""}
      $i = (  ($dataVals[0] << 24)
            | ($dataVals[1] << 16)
            | ($dataVals[2] <<  8)
            | ($dataVals[3]      ));
      $gotData = 1;
    }
    if (! $gotData) {
      print "ERR: DATA must be 1 32-bit number or 4 8-bit numbers\n";
    }
    #$cmd .= "\n   DATA: $i";
    if ($verbose) {print "$cmd"; $cmd = ""}
  }

  # interpret $line as a regular command via $fmtOpFns
  ($fmt, $op, $fn) = split (/ /, $fmtOpFns{$words[0]});
  if ($fmt eq "" && ! $gotData) {
    print "$cmd\n   *** ERR: unknown command - line ignored\n";
    $errs++;
    next;
  }

  # throw away remaining punctuation
  $a1 = $a2 = $a3 = "";		# clear out last command's tokens
  if ($words[1] =~ m/[^\w]*(\w+)/) {$a1 = $1;} # extract an alphaNum word
  if ($words[2] =~ m/[^\d]*(\d+)/) {$a2 = $1;} # extract a number
  if ($words[3] =~ m/[^\w]*(\w+)/) {$a3 = $1;} # extract an alphaNum word

  ####
  # the guts: use the relevant words for each command and
  # pack them into the instruction

  if ($fmt eq 'I') {		# process an I-format instruction
    $gotLabel = ($a3 =~ /\D/);	# is it non-numeric? (that's a label)
    $im = $a3 + 0;		# $im is 0 if $a1 is a textual label
    $rs = $a1; $rt = $a2;
    $i = (  ($op << 26)
          | ($rs << 21)
          | ($rt << 16)
          |  $im );
    $cmd .= "\n   I-cmd: op=$op rs=$rs rt=$rt im=$im" . ($gotLabel==1 ? " (label=$a3)" : "");
    if ($op >     63) {print "$cmd\n   *** ERR: op ($op) > 63\n"; $cmd = ""}
    if ($rs > $maxrs) {print "$cmd\n   *** ERR: rs ($rs) > $maxrs\n"; $cmd = ""}
    if ($rt > $maxrt) {print "$cmd\n   *** ERR: rt ($rt) > $maxrt\n"; $cmd = ""}
    if ($im >  65535) {print "$cmd\n   *** ERR: im ($im) > 65535\n"; $cmd = ""}
    # if it's a label, append it in the data table entry
    if ($gotLabel) {$jumps{$a3} .= " $offset"}
  }

  if ($fmt eq 'R') {		# process an R-format instruction
    $shamt = 0;			# for future sll or srl instructions
    $rs = $a1; $rt = $a2; $rd = $a3;
    $i = (  ($op << 26)
          | ($rs << 21)
          | ($rt << 16)
          | ($rd << 11)
          | ($sa << 6)
          |  $fn );

    $cmd .= "\n   R-cmd: op=$op rs=$rs rt=$rt rd=$rd sa=$sa fn=$fn";
    if ($op >     63) {print "$cmd\n   *** ERR: op ($op) > 63\n"; $cmd = ""}
    if ($rs > $maxrs) {print "$cmd\n   *** ERR: rs ($rs) > $maxrs\n"; $cmd = ""}
    if ($rt > $maxrt) {print "$cmd\n   *** ERR: rt ($rt) > $maxrt\n"; $cmd = ""}
    if ($rd > $maxrd) {print "$cmd\n   *** ERR: rd ($rd) > $maxrd\n"; $cmd = ""}
    if ($sa >     31) {print "$cmd\n   *** ERR: sa ($sa) > 31\n"; $cmd = ""}
    if ($fn >     63) {print "$cmd\n   *** ERR: fn ($fn) > 63\n"; $cmd = ""}
  }

  if ($fmt eq 'J') {		# process a J-format instruction
    $gotLabel = ($a1 =~ /\D/);	# is it non-numeric? (that's a label)
    $ad = $a1 >> 2;		# $ad is 0 if $a1 is a textual label
    $i = (  ($op << 26)
          |  $ad );
    $cmd .= "\n   J-cmd: op=$op ad=$ad" . ($gotLabel==1 ? " (label)" : "");
    if ($op > 63      ) {print "$cmd\n   *** ERR: op ($op) > 63\n"}
    if ($ad > 16777215) {print "$cmd\n   *** ERR: ad ($ad) > 16777215\n"}
    # if it's a label, append it in the jump table entry
    if ($gotLabel) {$jumps{$a1} .= " $offset"}
  }

  # record & optionally print each instruction;
  # labeled jumps are not rewritten at this point in the code...
  $is{$offset} = $i;
  if ($verbose) {printf "$cmd\n   i = %.8x  offset=$offset\n", $i}

  $offset++;
}

####
# phase 2: rewrite symbolic Jump instructions

if ($verbose) {print "\n*********************************************\n* STAGE 2: assign numeric target addresses to labels\n\n"}

if ($errs > 0) {
  print "FATAL: errs from last stage.\n";
  exit 1;
}

if ($verbose) {
  print "LABELS, with offsets\n";
  foreach $l (keys %labels) {print " $l: $labels{$l}\n";}
}
if ($verbose) {print "\n"}

# LATER: report labels not found

# rewrite jumps
if ($verbose) {print "*** JUMP/BRANCH LABEL REPORT\n"}
if ($verbose) {if ((keys %jumps) == ()) {print " (none)\n"}}
$loop = 1;
foreach $j (keys %jumps) {
  $o = $labels{$j};
  @ji = split / /, $jumps{$j};
  if ($verbose) {
    print "$loop: jump via $j from offsets ($jumps{$j}) will land @ offset "
      . ($o eq "" ? "UNDEF" : $o) . "\n";
  }
  if ($o eq "") {print "   ERR: undefined label $j\n"; next}
  $lis = (keys %is) + 1;		# last offset 
  $adjO = $o - $istart;
  if ($adjO > $lis) {print "   ERR: label $j jumps to ($o + $istart), after last instruction $lis\n"}
  if ($adjO > 16777215) {print "   ERR: jump address ($o + $istart) > 16777215\n"}
  foreach $i (@ji) {  if ($i ne "") {$is{$i} |= $adjO }}
  $loop++;
}
if ($verbose) {print "\n"}

# rewrite data references
if ($verbose) {print "*** DATA LABEL REPORT\n"}
if ($verbose) {if ((keys %dataRefs) == ()) {print " (none)\n"}}
$loop = 1;
foreach $r (keys %dataRefs) {
  $o = $labels{$r};
  @ri = split / /, $dataRefs{$r};
  if ($verbose) {
    print "$loop: data ref via label $r from offsets ($dataRefs{$r}) will refer to data @ offset "
      . ($o eq "" ? "UNDEF" : $o) . "\n";
  }
  if ($o eq "") {print "   ERR: undefined label $r\n"; next}
  $lis = (keys %is) + 1;		# last offset 
  $adjO = $o - $dstart;
  if ($adjO > $lis) {print "   ERR: data ref $r refer to ($o + $dstart), after last instruction $lis\n"}
  if ($adjO > 16777215) {print "   ERR: data ref address ($o + $dstart) > 16777215\n"}
  foreach $i (@ri) {  if ($i ne "") {$is{$i} |= $adjO}}
  $loop++;
}


####
# stage 3: output instructions, one per line, optionally decorated

if ($verbose) {
  print "\n*********************************************\n* STAGE 3: output instructions\n\n"
}

if ($verbose) {printf "Offset Instr    Command\n"}
foreach $i (sort {$a <=> $b} keys %is) { # sort by offset
  if ($verbose) {printf "%.6d ", $i}
                 printf "%.8x", $is{$i};
  if ($verbose) {print "$cmdText{$i}"}
                 print "\n";
}

# this part gets converted to RAMB format, via script toRam.pl
#open (RB, "|toRam.pl >out.ramb");
#foreach $i (sort {$a <=> $b} keys %is) { # sort by offset
#  printf RB "%.8x\n", $is{$i};
#}
#close(RB);

# the source code is just tacked on as a comment
open (RB, ">out.ramb");
printf RB "\/\/ Offset Instr     Command\n";
foreach $i (sort {$a <=> $b} keys %is) { # sort by offset
  printf RB "\/\/ %.6d %.8x %s\n", $i, $is{$i}, $cmdText{$i};
}
close(RB);

# added this section to generate the memory image file

open (MYFILE, ">mem.hex");
foreach $i (sort {$a <=> $b} keys %is) {
   printf MYFILE "%.8x\n", $is{$i};
}
close (MYFILE);
