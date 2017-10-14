#!/usr/bin/env perl -w

$email= shift;
$pswd = shift;
$filepattern = shift; # e.g. ei.oper.an.sfc.regn128sc.XXXXXXXXXX
$dataid = shift;  # e.g. yang244632
$startdate = shift; # YYYY-MM-DD-HH
$enddate = shift; # YYYY-MM-DD-HH

if($email eq "") {
  &help();
  exit(0);
}

$filepattern .= '.'.$dataid;
$dataid_cap = $dataid;
$dataid_cap =~ tr/[a-z]/[A-Z]/;

@month_days = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

($startyear,$startmonth,$startday,$starthour) = split /-/, $startdate;
($endyear,$endmonth,$endday,$endhour) = split /-/, $enddate;

$year = $startyear;
$month = $startmonth;
$day = $startday;
$hour = $starthour;


# get account credential
open VN, "wget -V |" or die 'cannot find wget';
$vn = (<VN> =~ /^GNU Wget (\d+)\.(\d+)/) ? (100 * $1 + $2) : 109;
close(VN);
$syscmd = ($vn > 109 ? 'wget --no-check-certificate' : 'wget');
$syscmd .= ' -O Authentication.log --save-cookies auth.rda_ucar_edu --post-data' .
"=\"email=$email&passwd=$pswd&action=login\" " .
'https://rda.ucar.edu/cgi-bin/login';
system($syscmd);
$opt = 'wget -N';
$opt .= ' --no-check-certificate' if($vn > 109);
$opt .= sprintf ' --load-cookies auth.rda_ucar_edu http://rda.ucar.edu/dsrqst/%s/', $dataid_cap;

 
while ($year < $endyear || ($year == $endyear && ($month < $endmonth || ($month == $endmonth && ($day < $endday || ($day == $endday && $hour <= $endhour) ) ) ) ) ) {
 
  $datestr = sprintf "%04d%02d%02d%02d", $year, $month, $day, $hour;
  $file = $filepattern;
  $file =~ s/XXXXXXXXXX/$datestr/;

  $cmd = $opt . $file;
  print "$cmd\n";
  (system($cmd)==0) or die "$0: ERROR: $cmd failed\n";
 
  $hour+=6;
  if ($hour==24) {
    $day++;
    $hour=0;
  }
  $days_in_month = $month_days[$month-1];
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
   
# clean the credential
system('rm -f auth.rda_ucar_edu Authentication.log');
exit 0;


sub help() {
  print "$0: download dataset from NCAR Research Data Archive (rda.ucar.edu)\n";
  print "  Author:  Xiaodong Chen <xiaodc.work\@gmail.com>\n\n";
  print "  Use:  $0  <email> <password> <file_pattern> <data_id> <start_date> <end_date>\n";
  print "  Explanation:\n";
  print "       <email>           email that is registered for your RDA account \n";
  print "       <password>        password of your RDA account\n";
  print "       <file_pattern>    template of the data file. See example below\n";
  print "       <data_id>         data_id, unique for each data request. Can be found as Request# at https://rda.ucar.edu/sindex.html#!cgi-bin/dashboard\n";
  print "       <start_date>      first date to be download. Format: YYYY-MM-DD-HH\n";
  print "       <end_date>        last date to be download. Format: YYYY-MM-DD-HH\n\n";
  print "  Example:\n";
  print "       $0  demo_email\@gmail.com demo_password  ei.oper.an.sfc.regn128sc.XXXXXXXXXX  yang244356  2001-01-01-00 2002-01-01-00\n";
}
