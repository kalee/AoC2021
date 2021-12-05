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
$Data::Dumper::Terse = 1;        # don't output names where feasible
$Data::Dumper::Indent = 0;       # turn off all pretty print
use List::Util qw(sum);

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
my @matrix = ();
my @numbers = ();

$start = time();
part1();
$end = time();
$runtime = sprintf("%.8s", ($end - $start)*1000);
print "part1 took $runtime ms\n";

#$start = time();
#part2();
#$end = time();
#$runtime = sprintf("%.8s", ($end - $start)*1000);
#print "part2 took $runtime ms\n";

exit(0);


sub sum_unmarked_numbers {
  my ($matrix_ref) = @_;
  #my @matrix = @$matrix_ref;
  my $sum_unmarked_numbers = 0;
  for my $i (0..4) {
    for my $j (0..4) {
      if ($matrix_ref->[$i][$j] != -1) {
        $sum_unmarked_numbers += $matrix_ref->[$i][$j];
      }
    }
  }
  return $sum_unmarked_numbers;
}


sub part1 {
  @data=();
  load_data();

  my @calls = split /,/, shift @data;
  #print "@calls","\n";

  my @AoA = ();
  my %hash = ();

  my $card_cnt = 0;
  for my $card (@data) {
    my @AoA = ();
    my $row_cnt=0;
    for my $row (split/\n/,$card) {
      $row=~/(\d+)?\s+(\d+)?\s+(\d+)?\s+(\d+)?\s+(\d+)$/;
      $AoA[$row_cnt][0]=$1;
      $AoA[$row_cnt][1]=$2;
      $AoA[$row_cnt][2]=$3;
      $AoA[$row_cnt][3]=$4;
      $AoA[$row_cnt][4]=$5;
      $row_cnt++;
    }
    $hash{$card_cnt}=\@AoA;
    $card_cnt++;
  }

  my @keys = keys %hash;
  for my $call (@calls) {
    for my $key (@keys) {
      for my $row (0..4) {
        for my $col (0..4) {  # Mark cell with -1 if it matches $call value
          if ($hash{$key}->[$row][$col] == $call) {
            $hash{$key}->[$row][$col] = -1;
          }

          for my $r (0..4) {
            # Check for Row bingo
            if (sum(@{$hash{$key}->[$r]})==-5) {
              print "Bingo:", sum_unmarked_numbers($hash{$key}) * $call,  "\n" if sum_unmarked_numbers($hash{$key}) * $call > 0;
              delete $hash{$key};   
            }

            # Check for column bingo
            my $sumation = 0;
            for my $c (0..4) {
              $sumation+=$hash{$key}->[$c][$r];
            }
            if ($sumation == -5) {
              print "Bingo:", sum_unmarked_numbers($hash{$key}) * $call,  "\n" if sum_unmarked_numbers($hash{$key}) * $call > 0;
              delete $hash{$key};   
            }
          }
        }
      }
    }
  }
      

  print "part1: ","\n";
}


sub load_data {
  ##### Load Data #####
  my $filename = '../data/google-4.txt';
  #my $filename = '../data/reddit-.txt';
  open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
  #while (<$fh>) {
  #while () {
  #}
  #close $fh;
  $/ = "";
  @data = <$fh>;
  chomp @data;
  close $fh;
}


# 7 4 9 5 11 17 23 2 0 14 21 24 10 16 13 6 15 25 12 22 18 20 8 19 3 26 1
# 
# '1'[
#   ['3','15','0','2','22'],
#   ['9','18','13','17','5'],
#   ['19','8','7','25','23'],
#   ['20','11','10','24','4'],
#   ['14','21','16','12','6']
# ]
# '2'[
#   ['14','21','17','24','4'],
#   ['10','16','15','9','19'],
#   ['18','8','23','26','20'],
#   ['22','11','13','6','5'],
#   ['2','0','12','3','7']
# ]
# '0'[
#   ['22','13','17','11','0'],
#   ['8','2','23','4','24'],
#   ['21','9','14','16','7'],
#   ['6','10','3','18','5'],
#   ['1','12','20','15','19']
# ]
# 

__DATA__
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7