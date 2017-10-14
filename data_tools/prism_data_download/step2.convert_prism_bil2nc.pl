#!/usr/bin/env perl

$year = shift; 
$month = 1;
$day = 1;

@days_in_month = (0,31,28,31,30,31,30,31,31,30,31,30,31);
if($year % 400 == 0 || ($year%4==0 && $year%100!=0) ) {
  $days_in_month[2]=29;
}

while($month<12 || ($month==12 && $day<=31)) {
  $stamp = sprintf "%d%02d%02d",$year,$month,$day;
  $bilfile = "PRISM_ppt_stable_4kmD2_${stamp}_bil.bil";
  $zipfile = "PRISM_ppt_stable_4kmD2_${stamp}_bil.zip";
  $ncfile = "PRISM_$stamp.nc";
  if(-e "$year/$zipfile") {
    $cmd = "unzip $zipfile;gdal_translate -of netCDF $bilfile $ncfile";
    print "$cmd\n";
  }

  $day++;
  if($day==$days_in_month[$month]+1) {
    $month++;
    $day=1;
    if($month==13) {
      exit;
      $year++;
      $month=1;
      if($year % 400 == 0 || ($year%4==0 && $year%100!=0)) {
        $days_in_month[2]=29;
      }
      else {
        $days_in_month[2]=28;
      }
    }
  }

}
