#!usr/bin/perl

use strict;
use warnings;
use Cwd;
use File::Copy qw(move);

my $pwd = cwd();
opendir(DIR, $pwd) or die $!;

my %new_song_names = ();

my @songs
	= grep {
		/\.mp3$/		# Ends in .mp3
		&& -f "$pwd/$_" # And is a file
	} readdir(DIR);
		
print "Current song names in this directory:\n";
foreach my $song (@songs) {
	print "$song\n";
}
print "\n";


my $accept = "n";
while($accept eq "n") {
	%new_song_names = ();
	
	print "What regex do you want to match?\n";
	my $regex = <>;
	chomp($regex);
	print "\n";
	
	print "What do you want to replace it with?\n";
	my $replace = <>;
	chomp($replace);
	print "\n";

	# Preview loop
	print "Preview of new song names:\n";
	foreach my $song (@songs) {
		my $new_name = $song;
		$new_name =~ s/$regex/$replace/;
		
		print "$new_name\n";
		$new_song_names{$song} = $new_name;
	}

	print "\nIs this what you wanted? (y/n/q) ";
	$accept = lc <>;
	chomp($accept);
	while(!($accept eq "y" || $accept eq "n" || $accept eq "q")) {
		print "Please type in either 'y', 'n' or 'q'\n";
		print "Is this what you wanted? (y/n/q) ";
		my $accept = lc <>;
		chomp($accept);
	}
}

if($accept eq "y") {
	while(my ($old_song_name, $new_song_name) = each(%new_song_names)) {
		move $old_song_name, $new_song_name;
	}
	print "\nAll song names have been changed.\n";
}


closedir(DIR);
exit 0;
