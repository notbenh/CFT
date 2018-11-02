#!/usr/bin/perl
use strict;
use warnings;

my $board = [
	[1,2,3],
	[4,5,6],
	[7,8,9],
];

sub draw_board {
	for my $row (@$board){
		for my $col (@$row){
			print $col;
		}
		print qq{\n}; #newline at end of row
	}
	print qq{\n}; # newline to seperate the board
}

sub make_play {
	my ($player,$position) = @_;
	for my $row (@$board){
		for my $col (@$row){
			if( $col eq $position ){
				# this works because perl uses references in for loops
				$col = $player;
				# because we don't want to walk the board anymore return
				return;
			}
		}
	}
}

sub players_turn {
	my $turn = shift;
	# 'X' plays first hence odd turns
	# 'O' plays on even turns (2nd) where
	if( $turn % 2 == 1){
		# the % here is the mod operator, ie remander after intger division
		# thus if $turn was 3 if we /2 then there's 1 left over hence 3 is odd
		return 'X';
	}
	else {
		return 'O';
	}
}

sub game_over { 0 } # TODO

my $player = '';
my $turn   = 0;    # start at zero and we'll use 'human' counting for turns
draw_board;        # draw the inital board so the players know what to pick

while( not game_over ){
	$turn++; # bump the turn by 1, ie 0->1
	$player = players_turn($turn); # update the $player variable

	print qq{turn $turn: Player $player, make your move: }; # note no newline here
	my $play = <STDIN>;
	chomp $play; # perl captures the newline from STDIN, chomp removes it;

	make_play($player => $play);
	draw_board;

	# DEBUGGING make sure that this doesn't go on for ever
	if( $turn > 5){
		print qq{!!! DEBUGGING, ending the game early\n};
		last; # stop the loop
	}
}

print qq{Congrats $player you won!};
