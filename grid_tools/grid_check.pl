#!/usr/bin/env perl

$file = shift;
$nodata = shift;
$choice = shift;
$key = shift; 
$col_n = shift; #if choice is col, then specific col number is needed
$max_threshold = -99999;
$min_threshold = 99999;

if($file eq "") {
  print " Check the maximum/minimum value (except the nodata value) in a file\n";
  print " Use:  grid_check.pl (input file) (nodata value in input) (choice) (key) (col number)\n";
  print "          1.choice:  whole,col\n";
  print "          2.key:  max, min\n";
  print "          3.col number:  starting from 0\n";
  print " Note:    1.For avg, please use compute_column_avg, which is located at vic_tools\n";
  print "          2.For row results or for large file, please use grid_check_large\n";
  exit;
}


open(FILE,$file) or die "$0: ERROR: cannot open $file for reading\n";
foreach $line(<FILE>) {
  if($line =~ /^\d/) {
    chomp $line;
    @fields = split/\s+/,$line;
    $ncols = @fields;
    for($i=0; $i<$ncols; $i++) {
      if($choice eq "col"){
        $value = $fields[$col_n];
      }
      if($choice eq "whole"){
        $value = $fields[$i]; 
      }
      if($key eq "max"){
        if($value!= $nodata && $value> $max_threshold) {  
          $max_threshold = $value;
        }
      }
      if($key eq "min"){
        if($value!= $nodata && $value< $min_threshold) {  
          $min_threshold = $value;
        }
      }
    }
  }
}
close(FILE);

if($key eq "max"){
  print "max value satisfied in $file is: $max_threshold\n";
}
if($key eq "min"){
  print "min value satisfied in $file is: $min_threshold\n";
}
