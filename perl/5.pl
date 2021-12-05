#!/usr/bin/perl
# AdventOfCode2020
# 
# part1: 5576
# part1 took 130.6810 ms
# part2: 18144
# part2 took 226.3600 ms
# Duration: 357.175 ms
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


#0,9 -> 5,9 => 0,9 1,9, 2,9 3,9 4,9 5,9
#8,0 -> 0,8 => 8,0 7,1 6,2 5,3 4,4 3,5 2,6 1,7 0,8
#9,4 -> 3,4 => 9,4 8,4 7,4 6,4 5,4 4,4 3,4
#2,2 -> 2,1 => 2,2 2,1
#7,0 -> 7,4 => 7,0 7,1 7,2 7,3 7,4
#6,4 -> 2,0 => 6,4 5,3 4,2 3,1 2,0
#0,9 -> 2,9 => 0,9 1,9 2,9
#3,4 -> 1,4 => 3,4 2,4 1,4
#0,0 -> 8,8 => 0,0 1,1 2,2 3,3 4,4 5,5 6,6 7,7 8,8
#5,5 -> 8,2 => 5,5 6,4 7,3 8,2
sub part1 {
  @data=();
  load_data();
  my @xArray=();
  my @yArray=();
  my %hash=();

  for (@data) {
    my $x1;
    my $y1;
    my $x2;
    my $y2;

    if (/^(\d+),(\d+) -> (\d+),(\d+)$/) {
      $x1=$1;
      $y1=$2;
      $x2=$3;
      $y2=$4;
    }

    #Part 1:only consider horizontal and vertical lines
    if ($x1!=$x2 && $y1!=$y2) {
      next;
    }

    # go from x1,y1 to x2,y2
    my $xIncr = 0;
    if ($x1>$x2) {
      $xIncr=-1;
    } elsif ($x1<$x2) {
      $xIncr=1;
    } else {
      $xIncr=0;
    }
    #print "\$xIncr:$xIncr", "\n";

    my $yIncr = 0;
    if ($y1>$y2) {
      $yIncr=-1;
    } elsif($y1<$y2) {
      $yIncr=1;
    } else {
      $yIncr=0;
    }
    #print "\$yIncr:$yIncr", "\n";

    while ($x1!=$x2 || $y1!=$y2) {
      #push @xArray,$x;
      #push @yArray,$y;
      my $key = "(" . $x1 . "," . $y1 . ")";
      #print $key, "\n";
      if (defined $hash{$key}) {
        $hash{$key}+=1;
      } else {
        $hash{$key}=1;
      }
      $x1+=$xIncr;
      $y1+=$yIncr;
    }
    my $key = "(" . $x1 . "," . $y1 . ")";
    #print $key, "\n";
    if (defined $hash{$key}) {
      $hash{$key}+=1;
    } else {
      $hash{$key}=1;
    }
  }

  my $sum = 0;
  while (my ($k,$v) = each %hash) {
    if ($v>=2) {
      $sum++;
    }
  }
  print "part1: ", $sum, "\n";


  if (DEBUG) {
    for my $row (0..9) {
      for my $col (0..9) {
        my $k = "(" . $col . "," . $row . ")";
        printf("%1d", $hash{$k});
      }
      print "\n";
    }
    print "\n";
  }

}


sub part2 {  # 48447, too low; needs to be 52069
  # waypoint is fixed.  10 units east, 1 unit north, fixed.
  @data=();
  seek DATA, $data_start, 0;  # reposition the filehandle right past __DATA__
  load_data();
  my @xArray=();
  my @yArray=();
  my %hash=();

  for (@data) {
    my $x1;
    my $y1;
    my $x2;
    my $y2;

    if (/^(\d+),(\d+) -> (\d+),(\d+)$/) {
      $x1=$1;
      $y1=$2;
      $x2=$3;
      $y2=$4;
    }

    # go from x1,y1 to x2,y2
    my $xIncr = 0;
    if ($x1>$x2) {
      $xIncr=-1;
    } elsif ($x1<$x2) {
      $xIncr=1;
    } else {
      $xIncr=0;
    }
    #print "\$xIncr:$xIncr", "\n";

    my $yIncr = 0;
    if ($y1>$y2) {
      $yIncr=-1;
    } elsif($y1<$y2) {
      $yIncr=1;
    } else {
      $yIncr=0;
    }
    #print "\$yIncr:$yIncr", "\n";

    while ($x1!=$x2 || $y1!=$y2) {
      #push @xArray,$x;
      #push @yArray,$y;
      my $key = "(" . $x1 . "," . $y1 . ")";
      #print $key, "\n";
      if (defined $hash{$key}) {
        $hash{$key}+=1;
      } else {
        $hash{$key}=1;
      }
      $x1+=$xIncr;
      $y1+=$yIncr;
    }
    my $key = "(" . $x1 . "," . $y1 . ")";
    #print $key, "\n";
    if (defined $hash{$key}) {
      $hash{$key}+=1;
    } else {
      $hash{$key}=1;
    }
  }

  my $sum = 0;
  while (my ($k,$v) = each %hash) {
    if ($v>=2) {
      $sum++;
    }
  }

  print "part2: ", $sum,"\n";
}


sub load_data {
  ##### Load Data #####
  my $filename = '../data/google-5.txt';
  #my $filename = '../data/reddit-5.txt';
  open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
  while (<$fh>) {
  #while (<DATA>) {
    chomp;
    push @data,$_;
  }
  close $fh;
}


__DATA__
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2