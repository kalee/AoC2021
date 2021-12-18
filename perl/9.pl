#!/usr/bin/perl
# AdventOfCode2021
# 
#
#
#
#
#
use 5.010;
use strict;
use warnings;
no warnings 'uninitialized';
use experimental 'smartmatch';

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
  my %hash=();
  my $x;
  my $y;

  $y=1;
  for my $line (@data) {
    my @row = split//,$line;
    my $x=1;
    for (@row) {
      print $_ if DEBUG;
      $hash{$y}{$x}=$_;
      $x++;
    }
    $y++;
    print "\n" if DEBUG;
  }
  print "\n" if DEBUG;

  my @solution=();
  my @rowKeys = sort {$a <=> $b} keys %hash;
  for my $y (@rowKeys) {
    my @colKeys = sort {$a <=> $b} keys %{$hash{$y}};
    for my $x (@colKeys) {
      if (($hash{$y}{$x} < (defined($hash{$y}{$x-1})?$hash{$y}{$x-1}:10)) &&
          ($hash{$y}{$x} < (defined($hash{$y}{$x+1})?$hash{$y}{$x+1}:10)) &&
          ($hash{$y}{$x} < (defined($hash{$y-1}{$x})?$hash{$y-1}{$x}:10)) &&
          ($hash{$y}{$x} < (defined($hash{$y+1}{$x})?$hash{$y+1}{$x}:10))) {
        #print "(".$x.",".$y.") = ",$hash{$y}{$x}, "\n";
        push @solution,$hash{$y}{$x};
      }
    }
  }

  my $answer = 0;
  for (@solution) {
    $answer+=($_+1);
  }

  print "part1: ", $answer, "\n";
}


sub get_xy {
  my ($p,$X,$Y) = @_;
  for my $y (1..$Y) {
    if ($p >= ($y-1)*$X && $p <= ($y)*$X) {
      # found the row
      return [($p-($X*($y-1)))+1, $y];
    }
  }
}

sub get_position {
  my ($x,$y,$X,$Y) = @_;
  return ($X*($y-1)) + $x - 1;
}

sub get_value {
  my ($p_ref, $x,$y,$X,$Y) = @_;
  my $position = ($X*($y-1)) + $x - 1;
  return $p_ref->[$position];
}


sub get_neighbors {
  my ($p_ref, $f_ref, $X, $Y) = @_;
  my @neighbors = ();
  my $x = $f_ref->[0];
  my $y = $f_ref->[1];
  #my $v = $f_ref->[2];
  #print "(".$x.",".$y.") = ",$v, "\n";

  # Check Left
  if ($x > 1) {
    my $v = get_value($p_ref, $x-1, $y, $X, $Y);
    #print "(".($x-1).",".$y.") = ",$v, "\n";
    if ($v < 9) {
      push @neighbors, [$x-1, $y, $v];
    }
  }

  # Check Right
  if ($x < $X) {
    my $v = get_value($p_ref, $x+1, $y, $X, $Y);
    #print "(".($x+1).",".$y.") = ",$v, "\n";
    if ($v < 9) {
      push @neighbors, [$x+1, $y, $v];
    }
  }

  # Check Up
  if ($y > 1) {
    my $v = get_value($p_ref, $x, $y-1, $X, $Y);
    #print "(".$x.",".($y-1).") = ",$v, "\n";
    if ($v < 9) {
      push @neighbors, [$x, $y-1, $v];
    }
  }

  #Check Down
  if ($y < $Y) {
    my $v = get_value($p_ref, $x, $y+1, $X, $Y);
    #print "(".$x.",".($y+1).") = ",$v, "\n";
    if ($v < 9) {
      push @neighbors, [$x, $y+1, $v];
    }
  }
  #print Dumper(@neighbors), "\n";
  return \@neighbors;
}


sub part2 {
  @data=();
  seek DATA, $data_start, 0;  # reposition the filehandle right past __DATA__
  load_data();

  my @lowpoints=();
  my @p=();
  my $X;
  my $Y=0;
  for my $line (@data) {
    $X = length($line);
    my @items = split//,$line;
    for my $value (@items) {
      push @p, $value;
    }
    $Y++
  }

  # basically solve part1 again to get the coorinates and value of the low points.
  for my $position (0..(scalar @p-1)) {
    my $current = $p[$position];
    my $a_ref=get_xy($position,$X,$Y);
    my $x = $a_ref->[0];
    my $y = $a_ref->[1];
    #left
    if ($x>1) {
      if (get_value(\@p, $x-1,$y,$X,$Y) < $current) {next;}
    }
    #right
    if ($x<$X) {
     if (get_value(\@p, $x+1,$y,$X,$Y) < $current) {next;} 
    }
    #up
    if ($y>1) {
     if (get_value(\@p, $x,$y-1,$X,$Y) < $current) {next;} 
    }
    #down
    if ($y<$Y) {
     if (get_value(\@p, $x,$y+1,$X,$Y) < $current) {next;} 
    }
    push @lowpoints, [$x, $y, $current];
  }


  # Given each lowpoint (x,y,value), find all the values in the basin for that lowpoint using BFS
  #print "lowpoints: ",Dumper(@lowpoints), "\n";
  my @basin = ();

  for my $a_ref (@lowpoints) {

    my @frontier = ();
    push @frontier, $a_ref;
    my @reached = ();
    push @reached, $a_ref;

    while (@frontier) {
      my $f_ref = pop @frontier;
      my $x = $f_ref->[0];
      my $y = $f_ref->[1];
      my $v = $f_ref->[2];
      #print "current: ", Dumper($f_ref), "\n";
      #print "frontier: ", Dumper(@frontier), "\n";
      #print "reached: ", Dumper(@reached), "\n";
      my $neighbors = get_neighbors(\@p, $f_ref,$X,$Y);
      #print "neighbors: ", Dumper($neighbors), "\n";
      for my $n_ref (@$neighbors) {
        #print "neighbor: ", Dumper($n_ref), "\n";
        my $flag=FALSE;
        for my $r_ref (@reached) {
          if ($r_ref->[0] == $n_ref->[0] && $r_ref->[1] == $n_ref->[1] && $r_ref->[2] == $n_ref->[2]) {
            $flag=TRUE;
            last;
          } else {
            #print $r_ref->[0],"=",$n_ref->[0]," ",$r_ref->[1],"=",$n_ref->[1]," ",$r_ref->[2],"=",$n_ref->[2], "\n";
          }

        }
        unless ($flag) {
          #print "adding: ", Dumper($n_ref), "\n\n";
          push @frontier, $n_ref;
          push @reached, $n_ref;

        }
      }
    }
    #print scalar @reached, "\n";
    push @basin, scalar @reached;
  }

  @basin = sort {$a <=> $b} @basin;
  #print $basin[-1], " ", $basin[-2], " ", $basin[-3], "\n";
  print "part2: ", $basin[-1]*$basin[-2]*$basin[-3], "\n";
}

exit();


sub load_data {
  ##### Load Data #####
  #my $filename = '../data/test-9.txt';
  my $filename = '../data/google-9.txt';
  #my $filename = '../data/reddit-9.txt';
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


=for comment







  print Dumper(@p), "\n";
  print "\$X:$X", " ", "\$Y:$Y", "\n";
  print get_position(3,2,$X,$Y), " ", get_value(\@p,3,2,$X,$Y), "\n";
  print get_position(10,5,$X,$Y), " ", get_value(\@p,10,5,$X,$Y), "\n";
  my $a_ref = get_xy(12,$X,$Y); #[3,2]
  print $a_ref->[0], " ", $a_ref->[1], "\n";
  $a_ref = get_xy(49,$X,$Y); # [10,5]
  print $a_ref->[0], " ", $a_ref->[1], "\n";
  #print "\$x:$x", " ", "\$y:$y", "\n";
  #for (@@floor) {
  #  print $_, "\n";
  #}







  my %hash=();
  my $x;
  my $y;

  $y=1;
  for my $line (@data) {
    my @row = split//,$line;
    my $x=1;
    for (@row) {
      $hash{$y}{$x}=$_;
      $x++;
    }
    $y++;
  }

  #my @solution=();
  my @coordinates=();
  my @rowKeys = sort {$a <=> $b} keys %hash;
  for my $y (@rowKeys) {
    my @colKeys = sort {$a <=> $b} keys %{$hash{$y}};
    for my $x (@colKeys) {
      if (($hash{$y}{$x} < (defined($hash{$y}{$x-1})?$hash{$y}{$x-1}:10)) &&
          ($hash{$y}{$x} < (defined($hash{$y}{$x+1})?$hash{$y}{$x+1}:10)) &&
          ($hash{$y}{$x} < (defined($hash{$y-1}{$x})?$hash{$y-1}{$x}:10)) &&
          ($hash{$y}{$x} < (defined($hash{$y+1}{$x})?$hash{$y+1}{$x}:10))) {
        #push @solution,$hash{$y}{$x};
        push @coordinates, "(".$x.",".$y.")";
      }
    }
  }

    


  my $sum;
  my @basin=();
  for my $coordinate (@coordinates) {
    my ($x,$y) = $coordinate=~/^\((\d+),(\d+)\)$/;
    my $h_ref = build_basin(\%hash,$x, $y);
    print "\$x:$x", " ", "\$y:$y", " ", "\$h_ref:", Dumper($h_ref), "\n" ;

    my %h=%$h_ref;
    
    $sum = 0;
    my @yKeys = keys %h;
    print "\@yKeys:@yKeys", "\n";
    for my $y (@yKeys) {
      my @xKeys = keys %{$h{$y}};
      for my $x (@xKeys) {
        $sum += $h{$y}{$x};
      }
    }
    push @basin, $sum;
  }
  print $basin[-1], " ", $basin[-2], " ", $basin[-3], "\n";
=cut

=for comment
sub build_basin {
  my ($h_ref, $x, $y) = @_;
  my %hash = %$h_ref;

  my $distance=0;
  my %h=();
  my $x1=$x;
  my $y1=$y;
  $h{$y1}{$x1}=$$h_ref{$y1}{$x1};


  my $lflag  = 1;
  my $rflag  = 1;
  my $uflag  = 1;
  my $dflag  = 1;
  my $luflag = 1;
  my $ldflag = 1;
  my $ruflag = 1;
  my $rdflag = 1;


  
  while ($lflag || $rflag || $uflag || $dflag || $luflag || $ldflag || $ruflag || $rdflag) {
    $distance++;
    if ($lflag) {
      $x1=$x-$distance;
      $y1=$y;
      if (defined($hash{$y1}{$x1}) && ($hash{$y1}{$x1} < 9)) {
        $h{$y1}{$x1}=$$h_ref{$y1}{$x1};
      } else {
        $lflag=0;
      }
    }

    if ($rflag) {
      $x1=$x+$distance;
      $y1=$y;
      if (defined($hash{$y1}{$x1}) && ($hash{$y1}{$x1} < 9)) {
        $h{$y1}{$x1}=$$h_ref{$y1}{$x1};
      } else {
        $rflag=0;
      }
    }

    if ($uflag) {
      $x1=$x;
      $y1=$y-$distance;
      if (defined($hash{$y1}{$x1}) && ($hash{$y1}{$x1} < 9)) {
        $h{$y1}{$x1}=$$h_ref{$y1}{$x1};
      } else {
        $uflag=0;
      }
    }
    if ($dflag) {
      $x1=$x;
      $y1=$y+$distance;
      if (defined($hash{$y1}{$x1}) && ($hash{$y1}{$x1} < 9)) {
        $h{$y1}{$x1}=$$h_ref{$y1}{$x1};
      } else {
        $dflag=0;
      }
    }

    if ($luflag) {
      $x1=$x-$distance;
      $y1=$y-$distance;
      if (defined($hash{$y1}{$x1}) && ($hash{$y1}{$x1} < 9)) {
        $h{$y1}{$x1}=$$h_ref{$y1}{$x1};
      } else {
        $luflag=0;
      }
    }
    
    if ($ldflag) {
      $x1=$x-$distance;
      $y1=$y+$distance;
      if (defined($hash{$y1}{$x1}) && ($hash{$y1}{$x1} < 9)) {
        $h{$y1}{$x1}=$$h_ref{$y1}{$x1};
      } else {
        $ldflag=0;
      }
    }
    
    if ($ruflag) {
      $x1=$x+$distance;
      $y1=$y-$distance;
      if (defined($hash{$y1}{$x1}) && ($hash{$y1}{$x1} < 9)) {
        $h{$y1}{$x1}=$$h_ref{$y1}{$x1};
      } else {
        $ruflag=0;
      }
    }
    
    if ($rdflag) {
      $x1=$x+$distance;
      $y1=$y+$distance;
      if (defined($hash{$y1}{$x1}) && ($hash{$y1}{$x1} < 9)) {
        $h{$y1}{$x1}=$$h_ref{$y1}{$x1};
      } else {
        $rdflag=0;
      }
    }
  }
  return \%h;
}
=cut


__DATA__
