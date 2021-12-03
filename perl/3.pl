#!/usr/bin/perl
# AdventOfCode2020
# 
#
#
#
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
  my @g=();
  my @e=();
  my $len=length $data[0];

  for my $cnt (0..$len-1) {
    my $sumg=0;
    my $sume=0;
    for my $line (@data) {
      #print $line, " ", $cnt, "\n";
      if (substr($line,$cnt,1) == 1) {
        #$g[$cnt] = 1;
        $sumg++;
      } else {
        #$e[$cnt] = 0;
        $sume++;
      }
    }
    if ($sumg>$sume) {
      push @g,1;
      push @e,0;
    } else {
      push @g,0;
      push @e,1;
    }
  }
  print "part1: ", eval("0b".join("",@g)) * eval("0b".join("",@e)), "\n";
  #print "part1: ", $gamma, " ", $epsilon, "\n";
}


sub part2 {
  @data=();
  seek DATA, $data_start, 0;  # reposition the filehandle right past __DATA__
  load_data();
  my @o=@data;
  my @c=@data;

  my $len=length $data[0];
  my $cnt1;
  my $cnt0;
  for my $cnt (0..$len-1) {
    $cnt1=0;
    $cnt0=0;
    for my $line (@o) {
      if (substr($line,$cnt,1)==1) {
        $cnt1++;
      } else {
        $cnt0++;
      }
    }
    if (scalar @o > 1) {
      if ($cnt1>=$cnt0) {
        @o=grep{substr($_,$cnt,1)==1}@o;
      } else {
        @o=grep{substr($_,$cnt,1)==0}@o;
      }
    }  
    #print "\@o:@o", "\n";
  }

  for my $cnt (0..$len-1) {
    $cnt1=0;
    $cnt0=0;
    for my $line (@c) {
      if (substr($line,$cnt,1)==1) {
        $cnt1++;
      } else {
        $cnt0++;
      }
    }
    if (scalar @c > 1) {
      if ($cnt1>=$cnt0) {
        @c=grep{substr($_,$cnt,1)==0}@c;
      } else {
        @c=grep{substr($_,$cnt,1)==1}@c;
      }
    }
    #print "\@c:@c", "\n";
  }

  print "part2: ", eval("0b".join("",@o)) * eval("0b".join("",@c)), "\n";

}


sub load_data {
  ##### Load Data #####
  #my $filename = '../data/google-3.txt';
  my $filename = '../data/reddit-3.txt';
  open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
  while (<$fh>) {
  #while (<DATA>) {
    chomp;
    push @data,$_;
  }
  close $fh;
}


__DATA__
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010