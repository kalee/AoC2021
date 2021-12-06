#!/usr/bin/perl
# AdventOfCode2021
# 
# part1: 380758
# part1 took 558.3300 ms
# part2: 1710623015163
# part2 took 3.523111 ms
# Duration: 561.935 ms
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
  my $counter = 0;
  while ($counter<80) {
    map{
      $_--;
      if ($_<0) {
        $_=6;
        push(@data,8);
      }
    }@data;
    $counter++;
  }

  print "part1: ", scalar @data, "\n";
}


sub part2 {
  @data=();
  seek DATA, $data_start, 0;  # reposition the filehandle right past __DATA__
  load_data();
  my %hash=();
  my $sum=0;

  # initial hash to zero
  for (0..8) {
    $hash{$_}=0;
  }

  # initial load 
  for (@data) {
    chomp;
    $hash{$_}++;
  }

  my $counter = 0;
  while ($counter<256) {
    map{
      if ($hash{$_}>0) {
        $hash{$_-1}+=$hash{$_};
        $hash{$_}=0;
      }
    }(0..8);

    # this was the key.  Proess the < 0 values 
    # after running though the list once.
    if ($hash{-1}>0) {
      $hash{6}+=$hash{-1};
      $hash{8}+=$hash{-1};
      $hash{-1}=0;
    }

    $counter++;

  }

  # calculate sum for part 2 answer
  $sum=0;
  for (0..8) {
    $sum += $hash{$_};
  }

  print "part2: ", $sum, "\n";
}


sub load_data {
  ##### Load Data #####
  #my $filename = '../data/test-6.txt';
  my $filename = '../data/google-6.txt';
  #my $filename = '../data/reddit-6.txt';
  
  my $content;
  open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
  {
      local $/;
      $content = <$fh>;
      chomp $content;
  }
  close($fh);
  @data=split/,/,$content;
  close $fh;
}

__DATA__
