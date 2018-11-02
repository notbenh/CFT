#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use feature qw{say};

# TODO: sigh %ENV?
sub DEBUG(@){ say "@_" if $ENV{DEBUG} }

die qx{perldoc $0} unless @ARGV; # usage
my ($change, @coins) = @ARGV;
$change *= 100; # TODO assumes that $change is a float ( $1.23 = 123c )
@coins = (25,10,5,1) unless @coins; # use US common coins as default

my %attempts;
my $lowest= $change; # assume that $change can always be satisfied with 1c coins #TODO

DEBUG qq{Change: $change};
DEBUG qq{Coins: [@coins]};

PASS: foreach my $pass ( 0..$#coins ){
	SWAP: foreach my $swap ( $pass..$#coins ){
		my @work_coins = @coins;
		# swap the coins, sloppy and will have duplicate parings
		$work_coins[$pass] = $coins[$swap];
		$work_coins[$swap] = $coins[$pass];

		# make a unique key for this specific stack of coins
		my $key = join ':', @work_coins;
		next SWAP
			if exists $attempts{$key}; # we already did this one (ie swap 0,0 = swap 1,1)

		$attempts{$key}{coin_order} = [@work_coins];

		DEBUG qq{$pass : $swap [@work_coins] $lowest};
		my $work_change = $change;
		my @work_coin_stack;
		COIN: while( $work_change > 0 ){
			my $work_coin = shift @work_coins;
			COUNT: while( $work_change >= $work_coin ){
				last COUNT if not defined $work_coin;
				next COIN if $work_change < $work_coin;
				$attempts{$key}{coins}{$work_coin} += 1;
				$attempts{$key}{coin_count} += 1;
				# shortcut if we've already found a better solution
				$attempts{$key}{abort} += 1
					and next SWAP
					if $attempts{$key}{coin_count} > $lowest;
				$work_change -= $work_coin;
				DEBUG qq{  $work_coin: $work_change};
			}
		}

		$lowest = $attempts{$key}{coin_count}
			if $lowest > $attempts{$key}{coin_count};
	}
}

my ($winner) = sort{ $a->{coin_count} <=> $b->{coin_count} } values %attempts;

DEBUG Dumper $winner;

say q{Number of coins: } . $winner->{coin_count};
say q{Winning Search order: } . join ', ', @{ $winner->{coin_order} };
say q{Distribution:};
say "  $_ x " . $winner->{coins}->{$_}
	for reverse sort keys %{ $winner->{coins} };



=head1 GOAL

Provide the lowest number of 'coins' that can be used to amount to some
specified 'change'.

=head1 EXAMPLES

	> ./make_change.pl 1.23
	Number of coins: 9
	Winning Search order: 25, 10, 5, 1
	Distribution:
	  25 x 4
	  10 x 2
	  1 x 3

	> ./make_change.pl .66 30 3 1
	Number of coins: 4
	Winning Search order: 30, 3, 1
	Distribution:
	  30 x 2
	  3 x 2


=head2 INPUT

	make_change.pl $change [@coins]

B<$change> is required to be provided, help text will be shown if it's missing.

B<@coins> is optional, US common coins will be used by default (25,10,5,1)

=head2 TODO

=over 4

=item * printf would clean up the output nicely

=back

=cut
