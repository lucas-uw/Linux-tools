#!/usr/bin/perl

$startdate = shift; #(YYYY-MM-DD)
$enddate = shift; #(YYYY-MM-DD)

if($startdata eq "") {
  print "create_time_series.pl    Create daily time series\n";
  print "   Use:     create_time_series.pl <startdate> <enddate>\n";
  print "            <startdate>  YYYY-MM-DD\n";
  print "            <enddate>    YYYY-MM-DD\n";
  exit(0);
}

@month_days = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

($startyear,$startmonth,$startday) = split /-/, $startdate;
($endyear,$endmonth,$endday) = split /-/, $enddate;

$year = $startyear;
$month = $startmonth;
$day = $startday;

while ($year < $endyear || ($year == $endyear && ($month < $endmonth || ($month == $endmonth && $day <= $endday) ) ) ) {

  $year = sprintf "%04d", $year;
  $month = sprintf "%02d", $month;
  $day = sprintf "%02d", $day;

  # or whatever needs to be printed out
  print "$year  $month  $day\n";

  $day++;
  $days_in_month = @month_days[$month-1];
  if (($year % 400 == 0 || ($year%4==0 && $year%100!=0)) && $month == 2) {
    $days_in_month++;
  }
  if ($day > $days_in_month) {
    $day = 1;
    $month++;
    if ($month > 12) {
      $month = 1;
      $year++;
    }
  }

}
