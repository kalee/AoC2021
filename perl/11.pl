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



#######################################
sub get_xy {
  my ($position,$X,$Y) = @_;
  for my $y (1..$Y) {
    if ($position >= ($y-1)*$X && $position <= ($y)*$X) {
      # found the row
      return [($position-($X*($y-1)))+1, $y];
    }
  }
}


#######################################
sub get_position {
  my ($x,$y,$X,$Y) = @_;
  return ($X*($y-1)) + $x - 1;
}


#######################################
sub get_ref {
  my ($m_ref, $x,$y,$X,$Y) = @_;
  my $position = get_position($x,$y,$X,$Y);
  return $m_ref->[$position];
}


#######################################
sub get_neighbors {
  my ($m_ref, $c_ref, $X, $Y) = @_;
  my @neighbors = ();
  #print "Get neighbors for item: ", Dumper($c_ref), "\n";
  
  my $x = $c_ref->[0];
  my $y = $c_ref->[1];

  # Check Left
  if ($x > 1) {
    my $v = get_ref($m_ref, $x-1, $y, $X, $Y);
    push @neighbors, $v;
  }

  # Check Right
  if ($x < $X) {
    my $v = get_ref($m_ref, $x+1, $y, $X, $Y);
    push @neighbors, $v;
  }

  # Check Up
  if ($y > 1) {
    my $v = get_ref($m_ref, $x, $y-1, $X, $Y);
    push @neighbors, $v;  
  }

  # Check Down
  if ($y < $Y) {
    my $v = get_ref($m_ref, $x, $y+1, $X, $Y);
    push @neighbors, $v;  
  }

  # Check Left Up
  if ($x > 1 && $y > 1) {
    my $v = get_ref($m_ref, $x-1, $y-1, $X, $Y);
    push @neighbors, $v;  
  }

  # Check Right Up
  if ($x < $X && $y > 1) {
    my $v = get_ref($m_ref, $x+1, $y-1, $X, $Y);
    push @neighbors, $v;  
  }

  # Check Left Down
  if ($x > 1 && $y < $Y) {
    my $v = get_ref($m_ref, $x-1, $y+1, $X, $Y);
    push @neighbors, $v;
  }

  # Check Right Down
  if ($x < $X && $y < $Y) {
    my $v = get_ref($m_ref, $x+1, $y+1, $X, $Y);
    push @neighbors, $v;
  }
  return \@neighbors;
}


#######################################
sub update_matrix {
  my ($m_ref, $X, $Y) = @_;  #$m_ref->[0] = [1,1,5]
  my $flash = 0;
  
  # Step 1 Energy level of each cell increases by 1
  for my $y (1..$Y) {
    for my $x (1..$X) {
      my $i_ref = $m_ref->[get_position($x,$y,$X,$Y)];
      $i_ref->[2] += 1; 
    }
  }

  # Step 2 Update matrix for values greater than 9.  Put them on a stack
  my @stack;
  my @seen;
  for my $y (1..$Y) {
    for my $x (1..$X) {
      my $i_ref = $m_ref->[get_position($x,$y,$X,$Y)];
      if ($i_ref->[2] > 9) {
        #print "To stack: ", Dumper($i_ref), "\n";
        push @stack, $i_ref;
      }
    }
  }



  # Step 3 while loop for stack.  
  # Set cell value = 0
  # getNeighbors -  add 1 to each neighbor cell
  # If neighbor > 9 and not in stack, add neighbor to stack.
  while (@stack) {
    my $c_ref = pop @stack;
    push @seen, $c_ref;
    $c_ref->[2] = 0; # Set cell value = 0

    # getNeighbors
    my $neighbors_ref = get_neighbors($m_ref, $c_ref,$X,$Y);
    my @neighbors = @$neighbors_ref;
    for my $n_ref (@neighbors) {
      $n_ref->[2] += 1; # add 1 to each neighbor cell

      if ($n_ref->[2] > 9) { # If neighbor > 9

        # If not in stack, add neighbor to stack.
        my $flag = FALSE;
        for my $s_ref (@stack) {
          if ($n_ref->[0]==$s_ref->[0] && $n_ref->[1]==$s_ref->[1]) {
            $flag=TRUE;
            last;
          }
        }
        unless ($flag) {
          push @stack, $n_ref;
        }

      } # if ($n_ref->[2] > 9)
    } # for my $n_ref (@neighbors)
  } # while (@stack)


  # Set all flashed values to Zero.
  while (@seen) {
    my $i_ref = pop @seen;
    $i_ref->[2] = 0;  # Set flash cell value = 0
    $flash++;
  }

  return $flash;
} # sub update_matrix


#######################################
sub print_matrix {
  my ($m_ref, $X, $Y) = @_;
  for my $y (1..$Y) {
    for my $x (1..$X) {
      my $i_ref = $m_ref->[get_position($x,$y,$X,$Y)];
      printf("%3d", $i_ref->[2]);
    }
    print "\n";
  }
  print "\n";
}


#######################################
# sub part1
#######################################
sub part1 {
  @data=();
  load_data();

  my $flash_cnt=0;
  # Initialize @matrix
  my @matrix=();
  my $y=1;
  my $x=1;
  my $Y;
  my $X;
  for my $line (@data) {
    my @items = split//,$line;
    $x=1;
    for my $value (0..$#items) {
      push @matrix, [$x,$y,$items[$value]];
      $x++;
    }
    $y++
  }
  $X=$x-1;
  $Y=$y-1;


  # Work the problem
  #print "Before any steps:","\n";
  #print_matrix(\@matrix, $X, $Y);

  for (1..100) {
    $flash_cnt += update_matrix(\@matrix, $X, $Y);
    #print "After step $_:","\n";
    #print_matrix(\@matrix, $X, $Y);
  }

  #print Dumper(@matrix), "\n";

  print "part1: ", $flash_cnt, "\n";
}






#######################################
# sub part2
#######################################
sub part2 {
  @data=();
  seek DATA, $data_start, 0;  # reposition the filehandle right past __DATA__
  load_data();

  my $flash_cnt=0;
  # Initialize @matrix
  my @matrix=();
  my $y=1;
  my $x=1;
  my $Y;
  my $X;
  for my $line (@data) {
    my @items = split//,$line;
    $x=1;
    for my $value (0..$#items) {
      push @matrix, [$x,$y,$items[$value]];
      $x++;
    }
    $y++
  }
  $X=$x-1;
  $Y=$y-1;


  # Work the problem
  #print "Before any steps:","\n";
  #print_matrix(\@matrix, $X, $Y);

  my $part2;
  for (1..1000) {
    if (update_matrix(\@matrix, $X, $Y) == $X*$Y) {
      $part2=$_;
      last;
    }  
    #print "After step $_:","\n";
    #print_matrix(\@matrix, $X, $Y);
  }

  #print Dumper(@matrix), "\n";


  print "part2: ", $part2, "\n";
}


#######################################
sub load_data {
  ##### Load Data #####
  #my $filename = '../data/test-11.txt';
  my $filename = '../data/google-11.txt';
  #my $filename = '../data/reddit-11.txt';
  open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
  while (<$fh>) {
  #while (<DATA>) {
    chomp;
    push @data,$_;
  }
  close $fh;
}


#######################################
sub load_blob {
  ##### Load Data #####
  #my $filename = '../data/test-11.txt';
  #my $filename = '../data/google-11.txt';
  #my $filename = '../data/reddit-11.txt';
  
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
