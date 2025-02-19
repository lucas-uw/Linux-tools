#!/usr/bin/env perl

$var = shift;  # ppt, tdmean, tmax, tmin, tmean, vpdmax, vpdmin
$long_name = shift; # e.g.  'daily minimum temperature'
$unit = shift; # e.g. K
$syear = shift;
$eyear = shift;

if($var eq "") {
	&help();
	exit(0);
}

for($year=$syear; $year<=$eyear; $year++) {
	$cmd = "step1.download_prism_data.pl $var $year";
	(system($cmd)==0) or die "$0: ERROR: $cmd failed\n";

	$cmd = "mkdir $year;mv PRISM_${var}_stable_4kmD2_$year* $year/";
	(system($cmd)==0) or die "$0: ERROR: $cmd failed\n";
 
	$cmd = "step2.convert_prism_bil2nc.pl $var $year > $year/cmd.csh";
	(system($cmd)==0) or die "$0: ERROR: $cmd failed\n";
 
	$cmd = "chmod +x $year/cmd.csh";
	(system($cmd)==0) or die "$0: ERROR: $cmd failed\n";
 
	$cmd = "cd $year;cmd.csh > /dev/null;cd ..";
	(system($cmd)==0) or die "$0: ERROR: $cmd failed\n";

	$cmd = "cd $year;rm *.bil *.xml *.hdr *.txt *.prj *.stx *.csv *.zip;cd ..";
	(system($cmd)==0) or die "$0: ERROR: $cmd failed\n";

	$cmd = "step3.create_annual_nc.pl $var $year $long_name $unit > cmd.csh;chmod +x cmd.csh";
	(system($cmd)==0) or die "$0: ERROR: $cmd failed\n";
  
	$cmd = "cmd.csh > /dev/null";
	(system($cmd)==0) or die "$0: ERROR: $cmd failed\n";

	$cmd = "rm -r $year";
	(system($cmd)==0) or die "$0: ERROR: $cmd failed\n";
}


sub help() {
	print "$0: download PRISM meteorological forcing dataset\n\n";
	print "  Author: Xiaodong Chen <xiaodc.work\@gmail.com>\n\n";
	print "  Use:    $0  <var>  <long_name>  <unit>  <syear> <eyear>\n";
	print "  Explanation:\n";
	print "                 <var>           variable name. Choose from: ppt, tdmean, tmax, tmin, tmean, vpdmax, vpdmin\n";
	print "           <long_name>           long name of variable in the final netcdf file. Please use single quote to handle space (see the example below)\n";
	print "                <unit>           unit of variable in the final netcdf file\n";
	print "               <syear>           starting year of downloading/processing\n";
	print "               <eyear>           end year of downloading/processing\n";
	print "  Example:\n";
	print "         $0  ppt \\\'PRISM\\\ daily\\\ precipitation\\\' mm/day 1981 1990\n";
	print "  Dependency:\n";
	print "         nco; gdal_translate; unzip";
}
