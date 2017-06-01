#!/usr/bin/env perl

$infile = shift; # file usually created by ls
$type = shift;

if($infile eq "") {
  print "  list2argu.pl:  Convert column list into single argu, seperate by comma \",\" or space\n";
  print "  Ver:     1.0.0\n";
  print "  Author:  Xiaodong Chen<xiaodc.work\@gmail.com>\n";
  print "  Use:       list2argu.pl <infile> <type>\n";
  print "               tpye: c=>comma, s=>space, p=>python style\n";
  exit;
}

open(FILE,$infile) or die "$0: ERROR: cannot open $infile for reading\n";
@info = <FILE>;
close(FILE);
$n = @info;
for($k=0; $k<$n; $k++) {
  $line = $info[$k];
  chomp $line;
  s/^\s+//,$line;
  if($type eq "p") {
    print "\'";
  }
  print "$line";
  if($type eq "p") {
    print "\'";
  }
  if($k< ($n-1)) {
    if($type eq "c" || $type eq "p") {
      print "\,";
    }
    if($type eq "s") {
      print " ";
    } 
  }
  else {
    print "\n";
  }
}
