#!/usr/bin/perl
# AdventOfCode2021
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

#use List::Util qw(sum min max);


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
  my @count=();
  my $sum = 0;

  for my $line (@data) {
    my @stack=();
    my $flag = FALSE;
    my $comp;
    my $value;
    my $cnt = 0;
    for (split//,$line) {
      $value=0;
      if(/[\(\[\{\<]/) {
        push @stack, $_;
      } else {
        my $char = pop @stack;
        if ($char eq "(") {
          $comp = ")";
        } elsif($char eq "[") {
          $comp = "]";
        } elsif($char eq "{") {
          $comp = "}";
        } elsif($char eq "<") {
          $comp = ">";
        }
        if ($_ ne $comp) {
          if ($_ eq ")") {
            $value = 3;
          } elsif($_ eq "]") {
            $value = 57;
          } elsif($_ eq "}") {
            $value = 1197;
          } elsif($_ eq ">") {
            $value = 25137;
          }
          $flag=TRUE;
          last;
        }
      }
      $cnt++;
      
    } # for (split//,$line)
    if ($cnt != length($line) ) {
      push @count, $cnt;
      $sum+=$value;
    }
  }
  print "part1: ", $sum, "\n";
}


sub part2 {
  @data=();
  seek DATA, $data_start, 0;  # reposition the filehandle right past __DATA__
  load_data();

  my @count=();
  my $sum = 0;
  my $total = 0;

  for my $line (@data) {
    my @stack=();
    my $flag = FALSE;
    my $comp;
    my $value;
    my $cnt = 0;
    for (split//,$line) {
      $value=0;
      if(/[\(\[\{\<]/) {
        push @stack, $_;
      } else {
        my $char = pop @stack;
        if ($char eq "(") {
          $comp = ")";
        } elsif($char eq "[") {
          $comp = "]";
        } elsif($char eq "{") {
          $comp = "}";
        } elsif($char eq "<") {
          $comp = ">";
        }
        if ($_ ne $comp) {
          if ($_ eq ")") {
            $value = 3;
          } elsif($_ eq "]") {
            $value = 57;
          } elsif($_ eq "}") {
            $value = 1197;
          } elsif($_ eq ">") {
            $value = 25137;
          }
          $flag=TRUE;
          last;
        }
      }
      $cnt++;
      
    } # for (split//,$line)
    unless ($flag) {
      $sum = 0;
      while (@stack) {
        $sum*=5;
        my $char = pop @stack;
        if ($char eq "(") {
          $value = 1;
        } elsif($char eq "[") {
          $value = 2;
        } elsif($char eq "{") {
          $value = 3;
        } elsif($char eq "<") {
          $value = 4;
        }
        $sum+=$value;
      }
      push @count, $sum;
    }
  }
  @count = sort {$a <=> $b} @count;
  my $index = $#count/2;

  print "part2: ", $count[$index], "\n";
}


sub load_data {
  ##### Load Data #####
  #my $filename = '../data/test-10.txt';
  my $filename = '../data/google-10.txt';
  #my $filename = '../data/reddit-10.txt';
  open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
  while (<$fh>) {
  #while (<DATA>) {
    chomp;
    push @data,$_;
  }
  close $fh;
}


sub load_blob {
  ##### Load Data #####
  #my $filename = '../data/test-xx.txt';
  #my $filename = '../data/google-xx.txt';
  #my $filename = '../data/reddit-xx.txt';
  
  #my $content;
  #open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
  #{
  #    local $/;
  #    $content = <$fh>;
  #    chomp $content;
  #}
  #close($fh);
  #@data=split/,/,$content;
}




__DATA__
