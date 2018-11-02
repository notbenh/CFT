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
}

draw_board;
