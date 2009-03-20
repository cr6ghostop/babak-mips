#! /bin/perl

while (<>) {

	@line = split;
	@next = split('x',$line[1]);
	print "$next[1] \n";
}
