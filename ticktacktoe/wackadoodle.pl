#!/usr/bin/env perl
use strict;
use warnings;
use feature qw{say};
use List::Util qw{first all};

# hard coding a 3x3 grid
my @board = 1..9;
sub draw_board { map{ say @board[@$_] } [0,1,2],[3,4,5],[6,7,8] }

# arrays count from 0
my @wins = ([0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]);

# look for a win by getting the slice and checking that all the chars are the same
sub game_over {
	# grab all the cell combos that 'could' be wins for testing
	my @possible_wins = map{join '', @board[@$_]} @wins;
	return 'win' if first { m/^(?:XXX|OOO)$/ } @possible_wins;
	return 'impossible to win' if all { m/(?:XO|OX)/ } @possible_wins;
	return 'board full' if ! first{ m/[0-9]/ } @board;
}

# the mechanics of a single play
sub play{
	my $player = shift;
	print qq{$player play: };
	my $play;
	# ask the user for input in a loop so we can handle errors
	while( ! defined $play ){
		$play = <STDIN>; # ask user
		chomp $play;
		if( $play !~ m/^[0-9]+$/ ){
			print qq{  error: can only take numbers as input};
		}
		elsif( $play < 1 || not defined $board[$play-1] ){
			print qq{  error: not valid move};
		}
		elsif( $board[$play-1] =~ m/^(?:X|O)$/ ){
			print qq{  error: not an open space};
		}
		else {
			last; # we passed all other validation so escape the loop
		}
		$play = undef; # reset value so we stay in the loop
		# let the user know we are still looking for input
		print ', try again: ';
	}
	# by now we've validated the input so just save off the play
	$board[$play-1] = $player;
}


draw_board;
my $turn = 0;
my $player = 'X';
my $reason;
while( not $reason = game_over ){
	$turn++;
	play( $player = $turn % 2 ? 'X' : 'O' );
	say ''; # create space before we show the play
	draw_board;
}

say qq{game over due to: $reason};
say qq{Congrats $player!!}
	if $reason eq 'win';

