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
				$col = $player;
				return;
			}
		}
	}
}

draw_board;
make_play(O=>2);
draw_board;
