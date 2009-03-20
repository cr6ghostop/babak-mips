#! /bin/perl
# converts output of asm.pl into a RAM BLOCK defparams format of 16 bits per RAMB

while (<>) {
  if (m/(....)(....)/) {
    $l1 = $1; $l2 = $2;
    $line1 = $l1 . $line1;
    $line2 = $l2 . $line2;
    $wordCount ++;
  }
  if ($wordCount == 16) {
    printf "defparam d1.INIT_%.2d = 256'h%s;\n", $lineCount, $line1;
    printf "defparam d0.INIT_%.2d = 256'h%s;\n", $lineCount, $line2;
    $line1 = "";
    $line2 = "";
    $lineCount++;
    $wordCount = 0;
  }
}

# any bits left over?
if ($wordCount > 0) {
    printf "defparam d1.INIT_%.2d = 256'h%s;\n", $lineCount, $line1;
    printf "defparam d0.INIT_%.2d = 256'h%s;\n", $lineCount, $line2;
    $line1 = "";
    $line2 = "";
    $lineCount++;
    $wordCount = 0;
}

if ($lineCount > 16) {print "\/\/ *** RAMB full\n"}
