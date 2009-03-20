#! /bin/perl
# converts output of asm.pl into a RAM BLOCK format like this:
#  //synthesis attribute INIT_00 of vox is "1ac01ac012001"
# (recodes in hex)
# note: 1 bit per word, packed as 1 4096-bit RAMB

$ramBlockName0 = "vox";
$maxLineCount = 16;
$wordsPerLine = 256;

# this would be sooo much easier if perl had 256-bit int's...
# so build up hex digits 4 bits at a time.

$place = 1;	# 1, 2, 4, 8: digit multiplier

while (<>) {
  if (m/(.)/) {
    $newDigit = $1;
    $l1 = $l1 + ($newDigit * $place);
    if ($place == 8) {
      $line1 = sprintf("%x", $l1) . $line1;
      $l1 = "";
      $place = 1;
    } else {$place *= 2}
    $wordCount ++;
  }
  if ($wordCount == $wordsPerLine) {
    printf "\/\/synthesis attribute INIT_%.2x of $ramBlockName0 is \"%s\"\n", $lineCount, $line1;
    $line1 = "";
    $lineCount++;
    $wordCount = 0;
  }
}

# any bits left over?
if ($wordCount > 0) {
    printf "\/\/synthesis attribute INIT_%.2x of $ramBlockName0 is \"%s\"\n", $lineCount, $line1;
    $line1 = "";
    $lineCount++;
    $wordCount = 0;
}

if ($lineCount > $maxLineCount) {print "\/\/ *** RAMB full ($lineCount > $maxLineCount lines)\n"}
