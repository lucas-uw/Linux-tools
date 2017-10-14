#!/usr/bin/env perl

$year = shift;
$month = 1;
$day = 1;

$end_year = $year;
$end_month = 12;
$end_day = 31;

if($year % 400 == 0 || ($year%4==0 && $year%100!=0) ) {
  @days_in_month = (0,31,29,31,30,31,30,31,31,30,31,30,31);
}
else {
  @days_in_month = (0,31,28,31,30,31,30,31,31,30,31,30,31);
}

while($year<$end_year || ($year==$end_year && $month<$end_month) || ($year==$end_year && $month==$end_month && $day<=$end_day)) {
  $stamp = sprintf "%d%02d%02d",$year,$month,$day;
  $cmd = "wget --user=anonymous --password=demo_email\@gmail.com ftp://prism.nacse.org/daily/ppt/$year/PRISM_ppt_stable_4kmD2_${stamp}_bil.zip";
  #$cmd = "wget --user=anonymous --password= ftp://prism.nacse.org/daily/ppt/$year/PRISM_ppt_provisional_4kmD2_${stamp}_bil.zip";
  print "$cmd\n";
  (system($cmd)==0) or die "$0: ERROR: $cmd failed\n";

  $day++;
  if($day==$days_in_month[$month]+1) {
    $month++;
    $day=1;
    if($month==13) {
      $year++;
      $month=1;
      if($year % 400 == 0 || ($year%4==0 && $year%100!=0) ) {
        $days_in_month[2]=29;
      }
      else {
        $days_in_month[2]=28;
      }
    }
  }

}
