#!/usr/bin/perl

for($year=2000; $year<=2000; $year++) {
  $cmd = "step1.download_prism_data.pl $year";
  (system($cmd)==0) or die "$0: ERROR: $cmd failed\n";

  $cmd = "mkdir $year;mv PRISM_ppt_stable_4kmD2_$year* $year/";
  (system($cmd)==0) or die "$0: ERROR: $cmd failed\n";
 
  $cmd = "step2.convert_prism_bil2nc.pl $year > $year/cmd.csh";
  (system($cmd)==0) or die "$0: ERROR: $cmd failed\n";
 
  $cmd = "chmod +x $year/cmd.csh";
  (system($cmd)==0) or die "$0: ERROR: $cmd failed\n";
 
  $cmd = "cd $year;cmd.csh > /dev/null;cd ..";
  (system($cmd)==0) or die "$0: ERROR: $cmd failed\n";

  $cmd = "cd $year;rm *.bil *.xml *.hdr *.txt *.prj *.stx *.csv *.zip;cd ..";
  (system($cmd)==0) or die "$0: ERROR: $cmd failed\n";

  $cmd = "step3.create_annual_nc.pl $year > cmd.csh";
  (system($cmd)==0) or die "$0: ERROR: $cmd failed\n";
  
  $cmd = "cmd.csh > /dev/null";
  (system($cmd)==0) or die "$0: ERROR: $cmd failed\n";
}
