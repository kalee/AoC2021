#!/usr/bin/perl
# AdventOfCode2021
# 
# part1: 340056
# part1 took 65.34600 ms
# Part 2: 96592275
# part2 took 350.5418 ms
# Duration: 415.931 ms
# 
#
use strict;
use warnings;
no warnings 'uninitialized';

use Time::HiRes qw/gettimeofday tv_interval time/;
use Data::Dumper;
$Data::Dumper::Terse = 1;        # don't output names where feasible
$Data::Dumper::Indent = 0;       # turn off all pretty print

use List::Util qw(sum min max);

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
  load_blob();
  my %hash=();
  for (@data) {
    if (!defined $hash{$_}) {
      $hash{$_}=1;
    } else {
      $hash{$_}++;
    }
  }

  my @keys = sort keys %hash;
  my $sum;
  my $min = 9999999;
  for my $key (@keys) {
    $sum = 0;
    for my $k (@keys) {
      #print "abs($key-$k)*$hash{$k}  ";
      $sum += abs($key-$k)*$hash{$k};
    }
    #print "$sum\n";
    if ($sum < $min) {
      $min=$sum;
    }
  }



  print "part1: ", $min, "\n";
}


sub part2 {
  @data=();
  seek DATA, $data_start, 0;  # reposition the filehandle
  load_blob();

  my %hash=();
  for (@data) {
    chomp;
    if (!defined $hash{$_}) {
      $hash{$_}=1;
    } else {
      $hash{$_}++;
    }
  }

  my @keys = sort keys %hash;

  my $sum;
  my $min = ~0;  ## max value
  my $minimum = min @keys;
  my $maximum = max @keys;
  for my $key ($minimum..$maximum) {  # where we are going to
    $sum = 0;
    for my $k (@keys) {
      my $diff=abs($k-$key);
      $sum += $hash{$k}*($diff*($diff+1)/2);  ## Arithmetic Sum
    }
    if ($sum < $min) {
      $min=$sum;
    }
  }
  print "Part 2: ", $min, "\n";
}


sub load_blob {
  ##### Load Data #####
  #my $filename = '../data/test-7.txt';
  my $filename = '../data/google-7.txt';
  #my $filename = '../data/reddit-7.txt';
  
  my $content;
  open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
  {
      local $/;
      $content = <$fh>;
      chomp $content;
  }
  close($fh);
  @data=split/,/,$content;
}




__DATA__
