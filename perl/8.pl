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
#no warnings 'uninitialized';

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

  my $l2;
  my $l3;
  my $l4;
  my $l7;
  my @input = ();
  my @output = ();
  my @digits = ();

  for (@data) {
    chomp;
    /^(.*) \| (.*)$/;
    push @input, $1;
    push @output, $2;
  }


  for my $d (@output) {
    my @digits = split/ /,$d;
    $l2 += () = grep{length==2}@digits; # 1
    $l3 += () = grep{length==3}@digits; # 7
    $l4 += () = grep{length==4}@digits; # 4
    $l7 += () = grep{length==7}@digits; # 8
  }


  print "part1: ", $l2+$l3+$l4+$l7, "\n";
}


sub sort_string {
  my ($s) = @_;
  my @str = split//,$s;
  @str = sort @str;
  return join"",@str;
}


sub part2 {
  @data=();
  seek DATA, $data_start, 0;  # reposition the filehandle right past __DATA__
  load_data();

  
  my $sum = 0;

  for (@data) {
    my @d0=();
    my @d1=();
    my @d2=();
    my @d3=();
    my @d4=();
    my @d5=();
    my @d6=();
    my @d7=();
    my @d8=();
    my @d9=();
    my @outlen=();
    my @values = ();
    my @lengths=();
    my @input=();
    my @output=();

    chomp;
    /^(.*) \| (.*)$/;
    push @input, $1;
    @output = split/ /,$2;


    # get each digit from input
    for my $p (@input) {
      my @patterns = split/ /,$p;

      @d2 = grep{length==2}@patterns;
      @d3 = grep{length==3}@patterns;
      @d4 = grep{length==4}@patterns;
      @d7 = grep{length==7}@patterns;
      @d5 = grep{length==5}@patterns;
      @d6 = grep{length==6}@patterns;
      
      $values[1] = $d2[0];
      $values[4] = $d4[0];
      $values[7] = $d3[0];
      $values[8] = $d7[0];
      
      # @l5:fdcge fecdb fabcd, $d7:edb, $d4:cgeb 
      # figure out length 5
      for (@d5) {
        my $match_counter = 0;
        #Can only be [2,3,5]
        #if contains a seven, then it is three.
        if(index($_,substr($values[7],0,1))!=-1 && index($_,substr($values[7],1,1))!=-1 && index($_,substr($values[7],2,1))!=-1) {
          $values[3] = $_;
        } else {
          #if what is left intersects with 4 in three places, then the answer is five, else it is two
          if(index($_,substr($values[4],0,1))!=-1) {$match_counter++};
          if(index($_,substr($values[4],1,1))!=-1) {$match_counter++};
          if(index($_,substr($values[4],2,1))!=-1) {$match_counter++};
          if(index($_,substr($values[4],3,1))!=-1) {$match_counter++};
          if ($match_counter == 3) {
            $values[5] = $_;
          } else {
            $values[2] = $_;
          }
        }
      }

      for (@d6) {
        #Can only be [0,6,9]
        #if contains a four, then it is nine.
        if(index($_,substr($values[4],0,1))!=-1 && index($_,substr($values[4],1,1))!=-1 && index($_,substr($values[4],2,1))!=-1 && index($_,substr($values[4],3,1))!=-1) {
          $values[9] = $_;
        } else {
          #if contains 7, then 0
          if (index($_,substr($values[7],0,1))!=-1 && index($_,substr($values[7],1,1))!=-1 && index($_,substr($values[7],2,1))!=-1) {
            $values[0] = $_;
          } else {
            $values[6]=$_;
          }
        }
      }
    }

    # sort values
    for (0..9) {
      $values[$_] = sort_string($values[$_]);
    }

    my $counter = 0;
    for (@output) {
      $output[$counter] = sort_string($output[$counter]);
      $counter++;
    }
    #print Dumper(@output), "\n";

    #### now compare to @output to get values

    #At this point, we know what the pattern is for each number from 0 to 9
    print "\@values:@values", "\n";
    print "\@output:@output", "\n";
    
    my $string="";
    for my $d (@output) {
      #print "\$d:$d", "\n";
      for my $v (0..9) {
        if ($values[$v] eq $d) {
          $string .= $v;
          last;
        }
      }
    }
    print "\$string:$string", "\n";
    $sum+=$string;
    print "\n";
  } # for (@data) {

    print "Part2: ", $sum, "\n";

}


sub load_data {
  ##### Load Data #####
  #my $filename = '../data/test-8.txt';
  my $filename = '../data/google-8.txt';
  #my $filename = '../data/reddit-8.txt';
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




__END__


=for comment



%AdjacencyList=()
$AdjacencyList{0}{A}=[B,C];
$AdjacencyList{0}{B}=[A,D];
$AdjacencyList{0}{C}=[A,E];
$AdjacencyList{0}{D}=[B,F];
$AdjacencyList{0}{E}=[C,F];
$AdjacencyList{0}{F}=[D,E];
0: 
A:B,C
B:A,D
C:A,E
D:B,F
E:C,F
F:D,E   
AaaaaB  
b    c  
b    c  
C....D  
e    f  
e    f  
EggggF  

$AdjacencyList{1}{A}=[];
$AdjacencyList{1}{B}=[D];
$AdjacencyList{1}{C}=[];
$AdjacencyList{1}{D}=[B,F];
$AdjacencyList{1}{D}=[];
$AdjacencyList{1}{F}=[D];
1:    
A:
B:D
C:
D:B,F
E:   
F:D
A....B  
.    c  
.    c  
C....D  
.    f  
.    f  
E....F  

$AdjacencyList{2}{A}=[B];
$AdjacencyList{2}{B}=[A,D];
$AdjacencyList{2}{C}=[D,E];
$AdjacencyList{2}{D}=[B,C];
$AdjacencyList{2}{E}=[C,F];
$AdjacencyList{2}{F}=[E];
2:    
A:B
B:A,D
C:D,E
D:B,C
E:C,F   
F:E
AaaaaB  
.    c  
.    c  
CddddD  
e    .  
e    .  
EggggF  

$AdjacencyList{3}{A}=[B];
$AdjacencyList{3}{B}=[A,D];
$AdjacencyList{3}{C}=[D];
$AdjacencyList{3}{D}=[B,C,F];
$AdjacencyList{3}{E}=[F];
$AdjacencyList{3}{F}=[D,E];
3:    
A:B
B:A,D
C:D
D:B,C,F
E:F   
F:D,E
AaaaaB  
.    c  
.    c  
CddddD  
.    f  
.    f  
EggggF  

$AdjacencyList{4}{A}=[C];
$AdjacencyList{4}{B}=[D];
$AdjacencyList{4}{C}=[A,D];
$AdjacencyList{4}{D}=[B,C,F];
$AdjacencyList{4}{D}=[];
$AdjacencyList{4}{F}=[D];
4:   
A:C
B:D
C:A,D
D:B,C,F
E:   
F:D
A....B 
b    c 
b    c 
CddddD 
.    f 
.    f 
E....F 


$AdjacencyList{5}{A}=[B,C];
$AdjacencyList{5}{B}=[A];
$AdjacencyList{5}{C}=[A,D];
$AdjacencyList{5}{D}=[C,F];
$AdjacencyList{5}{E}=[F];
$AdjacencyList{5}{F}=[D,E];
5:      
A:B,C
B:A
C:A,D
D:C,F
E:F   
F:D,E
AaaaaB  
b    .  
b    .  
CddddD  
.    f  
.    f  
EggggF  

$AdjacencyList{6}{A}=[B,C];
$AdjacencyList{6}{B}=[A];
$AdjacencyList{6}{C}=[A,D,E];
$AdjacencyList{6}{D}=[C,F];
$AdjacencyList{6}{E}=[C,F];
$AdjacencyList{6}{F}=[D,E];
6:      
A:B,C
B:A
C:A,D,E
D:C,F
E:C,F
F:D,E

AaaaaB  
b    .  
b    .  
CddddD  
e    f  
e    f  
EggggF  


$AdjacencyList{7}{A}=[B];
$AdjacencyList{7}{B}=[A,D];
$AdjacencyList{7}{C}=[];
$AdjacencyList{7}{D}=[B,F];
$AdjacencyList{7}{E}=[];
$AdjacencyList{7}{F}=[D];
7:      
A:B
B:A,D
C:
D:B,F
E:   
F:D
AaaaaB  
.    c  
.    c  
C....D  
.    f  
.    f  
E....F  

$AdjacencyList{8}{A}=[B,C];
$AdjacencyList{8}{B}=[A,D];
$AdjacencyList{8}{C}=[A,D,E];
$AdjacencyList{8}{D}=[B,C,F];
$AdjacencyList{8}{E}=[C,F];
$AdjacencyList{8}{F}=[D,E];
8:      
A:B,C
B:A,D
C:A,D,E
D:B,C,F
E:C,F
F:D,E
AaaaaB  
b    c  
b    c  
CddddD  
e    f  
e    f  
EggggF  

$AdjacencyList{9}{A}=[B,C];
$AdjacencyList{9}{B}=[A,D];
$AdjacencyList{9}{C}=[A,D];
$AdjacencyList{9}{D}=[B,C,F];
$AdjacencyList{9}{E}=[F];
$AdjacencyList{9}{F}=[D,E];
9:
A:B,C
B:A,D
C:A,D
D:B,C,F
E:F
F:D,E
AaaaaB
b    c
b    c
CddddD
.    f
.    f
EggggF


  0:      1:      2:      3:      4:
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
 gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg



 1: ab             2
 7: dab            3
 4: eafb           4
 8: acedgfb        7
 
 2: gcdfa          5
 3: fbcad          5
 5: cdfbe          5

if contains 7 "dab" = 3
else
2,5
intersects 4 in three places "eafb" = 5
else
2

 0: cagedb         6
 6: cdfgeb         6
 9: cefabd         6

contains 4 "eafb" = 9
else
0,6
contains 7 "dab" = 0
else
6


=cut