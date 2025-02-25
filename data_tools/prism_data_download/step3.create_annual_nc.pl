#!/usr/bin/env perl

$var = shift;
$year = shift;
$long_name = shift;
$unit = shift;

if($year % 400 == 0 || ($year%4==0 && $year%100!=0)  ) {
  $ndays = 366;
}
else {
  $ndays = 365;
}

@month_days = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

$month = 1;
$day = 1;
$endmonth = 12;
$endday = 31;

`mkdir -p annual_files`;

print "ncecat ";
while ($month < $endmonth || ($month == $endmonth && $day <= $endday) ) {

  $monthstr = sprintf "%02d", $month;
  $daystr = sprintf "%02d", $day;

  print "$year/PRISM_$year$monthstr$daystr.nc ";

  $day++;
  $days_in_month = @month_days[$month-1];
  if (($year % 400 == 0 || ($year%4==0 && $year%100!=0)) && $month == 2) {
    $days_in_month++;
  }
  if ($day > $days_in_month) {
    $day = 1;
    $month++;
  }

}
print "int.PRISM.$year.nc\n";
print "ncrename -d record,time -v crs,time -v Band1,$var int.PRISM.$year.nc\n";
print "ncap2 -O -s \"time=double(time)\" int.PRISM.$year.nc annual_files/PRISM.daily.$var.$year.nc\n";
print "ncatted -a calendar,time,c,c,gregorian -a units,time,c,c,\"days since $year-01-01 00:00:0.0\" -a long_name,$var,m,c,\"$long_name\" -a units,$var,c,c,\"$unit\" annual_files/PRISM.daily.$var.$year.nc\n";
print "step4.modify_time_info.py $var $year $ndays\n";
print "rm int.PRISM.$year.nc\n";
