#!/usr/bin/perl
use strict;
use Data::Dumper qw(Dumper);
use File::Basename;

#print Dumper \@ARGV;


my @dirArray = @ARGV;
my %archiveHashMap;
for (my $i = 0; $i < @dirArray; $i++) {
	if (exists $archiveHashMap{basename($dirArray[$i])}) { #This 
		push (@{ $archiveHashMap{basename($dirArray[$i])} }, $dirArray[$i]);
	}else{
		my @dupArray = ();
		push @dupArray, $dirArray[$i];
		$archiveHashMap{basename($dirArray[$i])} = \@dupArray;
	}
}

foreach my $filename (keys %archiveHashMap){
	
	if (scalar( @{ $archiveHashMap{$filename} } ) != 1) {
		print "FileName: $filename\n";
		my $dupArray_ref = $archiveHashMap{$filename};
		my @dupArray = @$dupArray_ref;
		foreach(@dupArray){
			print "$_\n"
		}
	}
	
}

