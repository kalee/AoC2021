#!/usr/bin/perl
# AdventOfCode2020
# 
#
# part1: 1390
# part1 took 11.15703 ms
# part2: 1457
# part2 took 2.038955 ms
# Duration: 13.238 ms
#
#
use strict;
use warnings;
no warnings 'uninitialized';

use Time::HiRes qw/gettimeofday tv_interval time/;
use Data::Dumper;

use constant FALSE => 0;
use constant TRUE => 1;
use constant DEBUG => 0;

my $start_time = [gettimeofday];
END { print "Duration: ", tv_interval($start_time)*1000, " ms\n"; }

my $data_start = tell DATA;
my $start = 0;
my $end = 0;
my $runtime = 0;

my @data = ();

$start = time();
part1();
$end = time();
$runtime = sprintf("%.8s", ($end - $start)*1000);
print "part1 took $runtime ms\n";

$start = time();
part2();
$end = time();
$runtime = sprintf("%.8s", ($end - $start)*1000);
print "part2 took $runtime ms\n";

exit(0);


sub part1 {
  @data=();
  load_data();
  my $state = $data[0];
  my $counter = 0;
  for my $new (@data) {
    if ($new > $state) {
      $counter++;
    }
    $state = $new
  }

  print "part1: ", $counter,  "\n";
}


sub part2 {  # 48447, too low; needs to be 52069
  # waypoint is fixed.  10 units east, 1 unit north, fixed.
  @data=();
  seek DATA, $data_start, 0;  # reposition the filehandle right past __DATA__
  load_data();

  my $state = $data[0]+$data[1]+$data[2];
  my $counter = 0;
  for (my $new = 2; $new < (scalar @data); $new++) {
    my $new_value = $data[$new-2]+$data[$new-1]+$data[$new];
    #print "$data[$new-2]", " ", "$data[$new-1]", " ", "$data[$new]", " ", "$new_value",  "\n"; 
    if ($new_value > $state) {
      $counter++;
    }
    $state = $new_value;
    #print "state:", " ", "$state", "counter:", " ", "$counter", "\n";
  }



  print "part2: ", $counter, "\n";
}


sub load_data {
  ##### Load Data #####
  my $filename = '../data/google-1.txt';
  #my $filename = '../data/reddit-1.txt';
  open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
  while (<$fh>) {
  #while (<DATA>) {
    chomp;
    push @data,$_;
  }
  close $fh;
}


__DATA__
199
200
208
210
200
207
240
269
260
263